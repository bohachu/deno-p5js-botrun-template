# Deno distroless image (smallest: ~150MB)
FROM denoland/deno:distroless-1.46.3

WORKDIR /app

# Copy all files
COPY . .

# Cache dependencies
RUN ["cache", "src/server.ts"]

EXPOSE 8080

# Run server
ENTRYPOINT ["run", "--allow-net", "--allow-read", "--allow-env", "src/server.ts"]