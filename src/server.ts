import { Application, Router } from "oak";

const app = new Application();
const router = new Router();

// Serve static files
app.use(async (ctx, next) => {
  const path = ctx.request.url.pathname;
  
  if (path === "/" || path === "/index.html") {
    ctx.response.body = await Deno.readTextFile("./public/index.html");
    ctx.response.type = "text/html";
  } else if (path.startsWith("/static/")) {
    const filePath = `.${path}`;
    try {
      const file = await Deno.readFile(filePath);
      ctx.response.body = file;
      if (path.endsWith(".js")) {
        ctx.response.type = "application/javascript";
      } else if (path.endsWith(".css")) {
        ctx.response.type = "text/css";
      }
    } catch {
      ctx.response.status = 404;
    }
  } else {
    await next();
  }
});

app.use(router.routes());
app.use(router.allowedMethods());

const port = parseInt(Deno.env.get("PORT") || "8080");
const hostname = "0.0.0.0";
console.log(`Server running on http://${hostname}:${port}`);
await app.listen({ hostname, port });