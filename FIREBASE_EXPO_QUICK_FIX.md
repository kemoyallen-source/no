# Firebase Storage + Expo Image Picker - Quick Reference

## 🚨 The Error

```
RangeError Failed to construct 'Response': The status provided (0) 
is outside the range [200, 599]
```

**Caused by line:** `const img = await fetch(images[i].img);`

---

## ✅ The Fix (Choose One)

### Option A: XMLHttpRequest (RECOMMENDED) ⭐
```javascript
// ✅ WORKS - Use this for React Native/Expo
const blob = await new Promise((resolve, reject) => {
  const xhr = new XMLHttpRequest();
  xhr.onload = () => resolve(xhr.response);
  xhr.onerror = () => reject(new TypeError('Failed to load'));
  xhr.responseType = 'blob';
  xhr.open('GET', images[i].img, true);
  xhr.send(null);
});
```

### Option B: Use uploadBytesResumable
```javascript
// ✅ ALSO WORKS - Better for large files
const uploadTask = uploadBytesResumable(storageRef, blob, metadata);
uploadTask.on(
  'state_changed',
  (snapshot) => console.log('Progress:', snapshot),
  (error) => console.error(error),
  async () => {
    const url = await getDownloadURL(uploadTask.snapshot.ref);
    console.log('Upload complete:', url);
  }
);
```

### Option C: React Native File System
```javascript
// ✅ Alternative - If using react-native-fs
import RNFS from 'react-native-fs';
const base64 = await RNFS.readFile(imageUri, 'base64');
```

---

## 📋 Full Working Code

```javascript
import { ref, uploadBytesResumable, getDownloadURL } from 'firebase/storage';

async function uploadImages(images, storage, auth) {
  const results = [];

  for (let i = 0; i < images.length; i++) {
    try {
      const fileName = `${Date.now()}_${i}`;
      const storageRef = ref(
        storage,
        `images/clinics/${auth.currentUser.uid}/${fileName}`
      );

      // ✅ Step 1: Use XMLHttpRequest (NOT fetch)
      const blob = await new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        xhr.onload = () => resolve(xhr.response);
        xhr.onerror = () => reject(new TypeError('Network request failed'));
        xhr.responseType = 'blob';
        xhr.open('GET', images[i].img, true);
        xhr.send(null);
      });

      // ✅ Step 2: Use uploadBytesResumable (NOT uploadBytes)
      const metadata = { contentType: 'image/jpeg' };
      
      const downloadURL = await new Promise((resolve, reject) => {
        const uploadTask = uploadBytesResumable(storageRef, blob, metadata);
        
        uploadTask.on('state_changed',
          (snapshot) => {
            const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
            console.log(`Upload ${i}: ${progress}%`);
          },
          (error) => reject(error),
          async () => {
            const url = await getDownloadURL(uploadTask.snapshot.ref);
            resolve(url);
          }
        );
      });

      results.push({
        img: downloadURL,
        isMainImg: images[i].isMainImg,
        fileName
      });

      console.log(`✅ Image ${i + 1} uploaded successfully`);
    } catch (error) {
      console.error(`❌ Error uploading image ${i}:`, error);
    }
  }

  return results;
}
```

---

## 🔴 ❌ DON'T DO THIS

```javascript
// ❌ WRONG - Causes status 0 error
const img = await fetch(images[i].img);  // FAILS with local URIs
const bytes = await img.blob();
```

---

## 🟢 ✅ DO THIS INSTEAD

```javascript
// ✅ CORRECT - Works with Expo Image Picker
const blob = await new Promise((resolve, reject) => {
  const xhr = new XMLHttpRequest();
  xhr.responseType = 'blob';
  xhr.onload = () => resolve(xhr.response);
  xhr.onerror = () => reject(new Error('Failed'));
  xhr.open('GET', images[i].img, true);
  xhr.send(null);
});
```

---

## 🛠️ Step-by-Step Fix

1. **Find the line:** `const img = await fetch(...)`
2. **Replace with:** XMLHttpRequest code above
3. **Change:** `uploadBytes` → `uploadBytesResumable`
4. **Add:** Progress tracking in `uploadTask.on()`
5. **Test:** Upload an image and check console

---

## 📊 Why This Works

| Component | Problem | Solution |
|-----------|---------|----------|
| **fetch()** | Doesn't support `file://` URIs | ✅ XMLHttpRequest does |
| **Status 0** | Invalid HTTP status | ✅ Bypassed with XMLHttpRequest |
| **uploadBytes** | Can timeout on large files | ✅ uploadBytesResumable has retry logic |
| **Error handling** | No try/catch | ✅ Promise rejection handling |

---

## 🧪 Testing Checklist

- [ ] Image selected from Expo Image Picker
- [ ] XMLHttpRequest loads blob without error
- [ ] uploadBytesResumable starts uploading
- [ ] Progress updates appear in console
- [ ] Upload completes successfully
- [ ] Download URL returned from Firebase
- [ ] UI updates with image URL
- [ ] No RangeError in console

---

## ⚠️ Common Issues & Fixes

### Issue: Still getting RangeError
**Fix:** Make sure you're using XMLHttpRequest AND uploadBytesResumable (not uploadBytes)

### Issue: Upload hangs
**Fix:** Set a timeout for the XMLHttpRequest:
```javascript
const timeout = setTimeout(() => {
  xhr.abort();
  reject(new Error('Request timeout'));
}, 30000); // 30 second timeout
```

### Issue: Android targetSDK 33+ doesn't work
**Fix:** Add permissions to AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### Issue: Memory issues with large images
**Fix:** Compress before upload:
```javascript
// Use expo-image-manipulator to compress
import * as ImageManipulator from 'expo-image-manipulator';
```

---

## 📚 Related Documentation

- [Firebase Storage Web Reference](https://firebase.google.com/docs/reference/js/storage)
- [Expo Image Picker API](https://docs.expo.dev/versions/latest/sdk/imagepicker/)
- [XMLHttpRequest MDN](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest)
- [Response Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)

---

## 🎯 TL;DR

**Problem:** `fetch(localUri)` fails with status 0  
**Solution:** Use `XMLHttpRequest` + `uploadBytesResumable`  
**Result:** ✅ Images upload successfully
