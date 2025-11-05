export default {
  async fetch(request, env, ctx) {
    try {
      const urlObject = new URL(request.url);

      // If the request is to a Vercel verification path, allow it to pass through
      if (urlObject.pathname.startsWith('/.well-known/')) {
        return await fetch(request);
      }

      // If the request is to /docs without trailing slash, redirect to /docs/
      if (urlObject.pathname === '/docs') {
        return Response.redirect(urlObject.origin + '/docs/', 301);
      }

      // If the request is to the docs subdirectory
      if (urlObject.pathname.startsWith('/docs/')) {
        // Proxy to Mintlify
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

      // Route everything else to main Webflow site
      const MAIN_SITE_URL = "qovery.webflow.io";
      let mainSiteUrl = new URL(request.url);
      mainSiteUrl.hostname = MAIN_SITE_URL;
      return await fetch(mainSiteUrl, {
        method: request.method,
        headers: request.headers,
        body: request.body
      });

      // If no action found, serve the regular request
      return await fetch(request);
    } catch (error) {
      // If error occurs, serve the regular request
      return await fetch(request);
    }
  }
};
