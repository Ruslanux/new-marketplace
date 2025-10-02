// functions/[[path]].js
export async function onRequest(context) {
  // Pass the request to the Cloudflare Pages'
  // built-in Rails application handler.
  return await context.next();
}