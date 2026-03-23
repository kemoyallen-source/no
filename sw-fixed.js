importScripts("./uv/uv.bundle.js");
importScripts("./uv/uv.config.js");
importScripts("./uv/uv.sw.js");

const sw = new UVServiceWorker();
let userKey = new URL(location).searchParams.get('userkey');

self.addEventListener("fetch", (event) => {
  try {
    const response = sw.fetch(event);
    
    // Ensure response has valid status code
    if (response instanceof Promise) {
      event.respondWith(
        response
          .then(res => {
            // Validate status code range [200-599]
            if (res && res.status !== undefined) {
              if (res.status < 200 || res.status > 599) {
                console.warn(`Invalid status code ${res.status} for URL: ${event.request.url}`);
                return new Response('Service Error', {
                  status: 503,
                  statusText: 'Service Unavailable'
                });
              }
            }
            return res;
          })
          .catch(err => {
            console.error(`Fetch error for ${event.request.url}:`, err);
            return new Response('Network error - proxy may be offline', {
              status: 503,
              statusText: 'Service Unavailable',
              headers: { 'Content-Type': 'text/plain' }
            });
          })
      );
    } else {
      event.respondWith(response);
    }
  } catch (err) {
    console.error(`Service worker error for ${event.request.url}:`, err);
    event.respondWith(
      new Response('Service worker error', {
        status: 500,
        statusText: 'Internal Server Error'
      })
    );
  }
});
