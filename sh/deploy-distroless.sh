#!/bin/bash

# Exit on error
set -e

# Configuration
IMAGE_NAME="deno-distroless-app"
TAG="latest"
DOCKERFILE="Dockerfile.distroless"

echo "🚀 Starting deployment with Distroless and compiled Deno binary..."

# Change to project directory
cd "$(dirname "$0")/.."

# Build Docker image
echo "📦 Building Docker image..."
docker build -f $DOCKERFILE -t $IMAGE_NAME:$TAG .

# Get image size
IMAGE_SIZE=$(docker images $IMAGE_NAME:$TAG --format "{{.Size}}")
echo "✅ Built image: $IMAGE_NAME:$TAG (Size: $IMAGE_SIZE)"

# Test locally
echo "🧪 Testing container locally..."
CONTAINER_ID=$(docker run -d -p 8080:8080 $IMAGE_NAME:$TAG)
echo "Container started with ID: $CONTAINER_ID"

# Wait for server to start
echo "⏳ Waiting for server to start..."
sleep 3

# Test the server
if curl -s http://localhost:8080 > /dev/null; then
    echo "✅ Server is running successfully!"
else
    echo "❌ Server test failed!"
    docker logs $CONTAINER_ID
    docker stop $CONTAINER_ID
    docker rm $CONTAINER_ID
    exit 1
fi

# Stop test container
echo "🛑 Stopping test container..."
docker stop $CONTAINER_ID
docker rm $CONTAINER_ID

echo "✅ Deployment preparation complete!"
echo ""
echo "To deploy to a cloud provider:"
echo "  - Google Cloud Run: gcloud run deploy --image $IMAGE_NAME:$TAG"
echo "  - AWS ECS: Use AWS CLI or console to deploy"
echo "  - Fly.io: flyctl deploy --image $IMAGE_NAME:$TAG"