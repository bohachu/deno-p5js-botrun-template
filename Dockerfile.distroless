# Build stage - compile Deno app to binary
FROM denoland/deno:alpine-1.46.3 AS builder

WORKDIR /app

# Copy dependency files
COPY deno.json ./
COPY src ./src
COPY public ./public
COPY static ./static

# Compile to single executable
RUN deno compile \
    --allow-net \
    --allow-read \
    --allow-env \
    --output=server \
    --target=x86_64-unknown-linux-gnu \
    src/server.ts

# Final stage - minimal distroless image
FROM gcr.io/distroless/cc-debian12:nonroot

WORKDIR /app

# Copy compiled binary
COPY --from=builder /app/server /app/server

# Copy static assets
COPY --from=builder /app/public /app/public
COPY --from=builder /app/static /app/static

EXPOSE 8080

ENTRYPOINT ["/app/server"]