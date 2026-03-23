# Firebase Storage + Expo Image Picker: RangeError Fix

## Problem Summary

**Error:** `RangeError Failed to construct 'Response': The status provided (0) is outside the range [200, 599]`

This error occurs when trying to `fetch()` local file URIs from Expo Image Picker to convert them to blobs for Firebase Storage upload. The issue stems from attempting to fetch local file URIs using the Fetch API, which doesn't support `file://` protocols and returns a status code of `0`, violating the Response status range requirement (200-599).

## Root Cause

1. **Expo Image Picker** returns local file URIs (e.g., `file:///data/...`)
2. **Fetch API** doesn't properly handle local file protocols
3. When fetch encounters a local file URI, it returns status `0` instead of a valid HTTP status
4. Firebase's Response constructor rejects status `0` as invalid

## Solution Overview

There are multiple approaches to fix this issue:

### Solution 1: Use XMLHttpRequest (Recommended for React Native)

Replace the `fetch()` call with `XMLHttpRequest` to properly read local files:

```javascript
import { ref, uploadBytesResumable, getDownloadURL } from 'firebase/storage';

async function uploadImageToFirebase(imageUri, storage, auth) {
  const fileName = Date.now();
  const storageRef = ref(
    storage,
    `images/clinics/${auth.currentUser.uid}/${fileName}`
  );

  // Use XMLHttpRequest instead of fetch for local URIs
  const blob = await new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    xhr.onload = function () {
      resolve(xhr.response);
    };
    xhr.onerror = function (e) {
      reject(new TypeError('Network request failed'));
    };
    xhr.responseType = 'blob';
    xhr.open('GET', imageUri, true);
    xhr.send(null);
  });

  const metadata = {
    contentType: 'image/jpeg',
  };

  // Use uploadBytesResumable for better control
  return new Promise((resolve, reject) => {
    const uploadTask = uploadBytesResumable(storageRef, blob, metadata);
    
    uploadTask.on(
      'state_changed',
      (snapshot) => {
        // Progress updates
        const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        console.log('Upload is ' + progress + '% done');
      },
      (error) => {
        reject(error);
      },
      async () => {
        const url = await getDownloadURL(uploadTask.snapshot.ref);
        resolve(url);
      }
    );
  });
}
```

### Solution 2: Complete Upload Loop

Here's the corrected version of your original code:

```javascript
async function uploadImages(images, storage, auth) {
  const clinicImages = [];
  const clinicImagesURI = [];

  for (let i = 0; i < images.length; i++) {
    const fileName = Date.now() + i;
    const storageRef = ref(
      storage,
      `images/clinics/${auth.currentUser.uid}/${fileName}`
    );

    clinicImages.push({ img: `${fileName}`, isMainImg: true });

    try {
      // ✅ Use XMLHttpRequest instead of fetch
      const blob = await new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        xhr.onload = () => resolve(xhr.response);
        xhr.onerror = () => reject(new TypeError('Network request failed'));
        xhr.responseType = 'blob';
        xhr.open('GET', images[i].img, true);
        xhr.send(null);
      });

      const metadata = {
        contentType: 'image/jpeg',
      };

      // ✅ Use uploadBytesResumable for resumable uploads
      const downloadURL = await new Promise((resolve, reject) => {
        const uploadTask = uploadBytesResumable(storageRef, blob, metadata);
        
        uploadTask.on(
          'state_changed',
          (snapshot) => {
            const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
            console.log(`Upload ${i + 1}: ${progress}% done`);
          },
          (error) => reject(error),
          async () => {
            const url = await getDownloadURL(uploadTask.snapshot.ref);
            resolve(url);
          }
        );
      });

      clinicImagesURI.push({
        img: downloadURL,
        isMainImg: images[i].isMainImg,
      });
    } catch (error) {
      console.error(`Error uploading image ${i}:`, error);
    }
  }

  return { clinicImages, clinicImagesURI };
}
```

### Solution 3: React Native File System Approach

If using React Native, you can also use `react-native-fs`:

```javascript
import RNFS from 'react-native-fs';

async function uploadImageRNFS(imageUri, storage, auth) {
  const fileName = Date.now();
  const storageRef = ref(
    storage,
    `images/clinics/${auth.currentUser.uid}/${fileName}`
  );

  // Read file as base64
  const base64Data = await RNFS.readFile(imageUri, 'base64');
  const blob = new Blob(
    [Uint8Array.from(atob(base64Data), c => c.charCodeAt(0))],
    { type: 'image/jpeg' }
  );

  const metadata = { contentType: 'image/jpeg' };
  
  return new Promise((resolve, reject) => {
    const uploadTask = uploadBytesResumable(storageRef, blob, metadata);
    
    uploadTask.on(
      'state_changed',
      () => {},
      (error) => reject(error),
      async () => {
        const url = await getDownloadURL(uploadTask.snapshot.ref);
        resolve(url);
      }
    );
  });
}
```

## Key Changes Explained

| Issue | Solution |
|-------|----------|
| `fetch()` doesn't handle local URIs | Use `XMLHttpRequest` with `responseType: 'blob'` |
| Status `0` is invalid for Response | XMLHttpRequest bypasses the Fetch API validation |
| `uploadBytes` can fail on large files | Use `uploadBytesResumable` with progress tracking |
| No error handling | Wrap in Promise with try/catch blocks |

## Common Issues & Fixes

### Issue 1: CORS/Security
**Problem:** XMLHttpRequest may be blocked by security policies  
**Fix:** This typically only affects web; React Native handles local URIs natively

### Issue 2: Android targetSDK 33+
**Problem:** Permissions model changed for file access  
**Fix:** Ensure proper permissions in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### Issue 3: Large Image Uploads Timeout
**Problem:** Single `uploadBytes` may timeout  
**Fix:** Use `uploadBytesResumable` which supports pause/resume and has better timeout handling

### Issue 4: Memory Issues
**Problem:** Large blobs in memory cause crashes  
**Fix:** 
- Compress images before upload
- Use `uploadBytesResumable` with smaller chunks

## Testing Checklist

- [ ] Replaced all `fetch()` calls with `XMLHttpRequest` for local URIs
- [ ] Using `uploadBytesResumable` instead of `uploadBytes`
- [ ] Error handling in place for each upload
- [ ] Progress tracking implemented
- [ ] Tested with various image sizes
- [ ] Verified on both iOS and Android (if applicable)
- [ ] Checked Firebase Storage rules allow uploads from your UID

## Related Issues

- React Native Fetch API doesn't support local file protocols
- Firebase Admin SDK vs Client SDK differences
- Expo Media Library vs Expo Image Picker URI formats

## References

- [Firebase Cloud Storage Docs](https://firebase.google.com/docs/storage/web/upload-files)
- [Expo Image Picker Documentation](https://docs.expo.dev/versions/latest/sdk/imagepicker/)
- [XMLHttpRequest vs Fetch for React Native](https://react-native.dev/docs/network)
- [MDN: Response Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)

## Version Info

- Firebase SDK: 9.0.0+
- React Native: 0.59.0+
- Expo: 45.0.0+
- Targeted Android targetSDK: 31+
