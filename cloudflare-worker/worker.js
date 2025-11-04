export default {
  async fetch(request, env, ctx) {
    try {
      const urlObject = new URL(request.url);

      // If the request is to a Vercel verification path, allow it to pass through
      if (urlObject.pathname.startsWith('/.well-known/')) {
        return await fetch(request);
      }

      // If the request is to the docs subdirectory
      if (/^\/docs/.test(urlObject.pathname)) {
        // Then Proxy to Mintlify
        const DOCS_URL = "qovery.mintlify.dev";
        const CUSTOM_URL = "www.qovery.com";

        let url = new URL(request.url);
        url.hostname = DOCS_URL;

        let proxyRequest = new Request(url, request);

        proxyRequest.headers.set("Host", DOCS_URL);
        proxyRequest.headers.set("X-Forwarded-Host", CUSTOM_URL);
        proxyRequest.headers.set("X-Forwarded-Proto", "https");
        // If deploying to Vercel, preserve client IP
        proxyRequest.headers.set("CF-Connecting-IP", request.headers.get("CF-Connecting-IP"));

        return await fetch(proxyRequest);
      }

      // If no action found, play the regular request
      return await fetch(request);
    } catch (error) {
      // If error occurs, play the regular request
      return await fetch(request);
    }
  }
};
