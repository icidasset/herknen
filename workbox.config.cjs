module.exports = {
  clientsClaim: true,
  globDirectory: "build/",
  globPatterns: [ "**/*" ],
  inlineWorkboxRuntime: true,
  navigateFallback: "index.html",
  runtimeCaching: [
    { urlPattern: /^https:\/\/fonts\.googleapis\.com/, handler: "StaleWhileRevalidate" },
    { urlPattern: /^https:\/\/fonts\.gstatic\.com/, handler: "CacheFirst" }
  ],
  skipWaiting: true,
  sourcemap: false,
  swDest: "build/service-worker.js"
};
