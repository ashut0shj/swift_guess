'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "925b8d9da22f55dcab33fcb15199e8bb",
"index.html": "d82dab74ceb4bc92e3db9a24a238588f",
"/": "d82dab74ceb4bc92e3db9a24a238588f",
"main.dart.js": "cd69e259c77c0d635296efffff3d7365",
"version.json": "e3127c67a1e82c5eb54a412b06dd978b",
"assets/assets/images/win/win1.png": "2df9761dcc8984dda1b917b611736b2a",
"assets/assets/images/win/win2.png": "7df7eb614c94e3c6d661c3b35b5666fa",
"assets/assets/images/win/win3.png": "9b7d9b69adf4fc19397176bd0c6d0181",
"assets/assets/images/win/win4.png": "01de72ebd67a3d05a2424deaa5ab3384",
"assets/assets/images/win/win5.png": "283e44b8790c95115ae5d565093cb89b",
"assets/assets/images/lose/lose1.png": "75d7a3d0828330d4ee770e3ba791e04b",
"assets/assets/images/lose/lose2.png": "5c114734870b20753853b245445e292c",
"assets/assets/images/lose/lose3.png": "1bf30f6815934f1fbe1fc872abfc3fc3",
"assets/assets/images/home_image.png": "037db0526b8cf582261ae9ad53a31a6b",
"assets/assets/images/home.jpg": "5a234977d644ac67fb7152569e7edaf4",
"assets/assets/audio/lose.wav": "035f4a66f3764114a042408052f5eb56",
"assets/assets/audio/win.wav": "0831d581d2789ace24690901067fd2f3",
"assets/assets/audio/i-think-he-knows.mp3": "8b09ecc1594dba1e03625cb030c73fd9",
"assets/assets/audio/love_story.mp3": "c5765849cb7b793e1b0262070844616a",
"assets/assets/audio/blank-space.mp3": "6352cd4178baed56eefcee2a99bfe398",
"assets/assets/audio/you-are-in-love.mp3": "e2f0a24c966c18b117b3119e798e2312",
"assets/assets/audio/bad-blood.mp3": "895adb521efdd0d903ec2cb56ebb8920",
"assets/assets/audio/jingle.mp3": "8c52ec5464afb81a77ce1c5c5005e34e",
"assets/fonts/MaterialIcons-Regular.otf": "a5f51d3fd72a47bbcbbc8d0506e184b6",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "961efe2b1c240f0247baa4375c92e314",
"assets/AssetManifest.bin.json": "59c6daa4832ec439f833375d04e7d98f",
"assets/NOTICES": "3bab5448369e45f79e6e3c2e3e2b64e8",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/AssetManifest.bin": "d4ce857089ffff4d1712d7c66aeb42e4",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"manifest.json": "2e7d67033c5f672cdf5283c92e803913",
"splash/img/dark-1x.png": "a7dfd295f6f27f160a0424be271d1a25",
"splash/img/dark-2x.png": "008e2fee7f2763cb2444f035dc95a9bf",
"splash/img/dark-3x.png": "c3fb3bf75cf2471069c1f880dc12737e",
"splash/img/dark-4x.png": "cd54fd8a795e42b66e7124e2a0bb5527",
"splash/img/light-1x.png": "a7dfd295f6f27f160a0424be271d1a25",
"splash/img/light-2x.png": "008e2fee7f2763cb2444f035dc95a9bf",
"splash/img/light-3x.png": "c3fb3bf75cf2471069c1f880dc12737e",
"splash/img/light-4x.png": "cd54fd8a795e42b66e7124e2a0bb5527"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
