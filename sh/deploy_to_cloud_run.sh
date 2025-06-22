#!/bin/bash
set -e

# Config
SERVICE_NAME="deno-p5js-botrun"
REGION="asia-east1"
PROJECT_ID=$(gcloud config get-value project)
IMAGE="${REGION}-docker.pkg.dev/${PROJECT_ID}/${SERVICE_NAME}/${SERVICE_NAME}"

# Build & push
gcloud builds submit --tag ${IMAGE}

# Deploy
gcloud run deploy ${SERVICE_NAME} \
  --image ${IMAGE} \
  --region ${REGION} \
  --allow-unauthenticated \
  --memory 256Mi

echo "✅ Done: $(gcloud run services describe ${SERVICE_NAME} --region ${REGION} --format 'value(status.url)')"