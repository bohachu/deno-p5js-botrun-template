#!/bin/bash
set -e

# === Configuration ===
SERVICE_NAME="deno-p5js-botrun"
REGION="asia-east1"
PROJECT_ID="scoop-386004"

# Construct image name
IMAGE_NAME="${REGION}-docker.pkg.dev/${PROJECT_ID}/${SERVICE_NAME}/${SERVICE_NAME}:latest"

echo "--- Configuration ---"
echo "Project ID:     ${PROJECT_ID}"
echo "Service Name:   ${SERVICE_NAME}"
echo "Region:         ${REGION}"
echo "Docker Image:   ${IMAGE_NAME}"
echo "---------------------"
echo

# --- Authenticate Docker ---
echo "Configuring Docker authentication for Artifact Registry..."
gcloud auth configure-docker ${REGION}-docker.pkg.dev --quiet
echo "Docker authentication configured."
echo "---------------------"
echo

# --- Create Artifact Registry Repository ---
echo "Checking and creating Artifact Registry repository if needed..."
gcloud artifacts repositories describe "${SERVICE_NAME}" \
    --location="${REGION}" \
    --project="${PROJECT_ID}" > /dev/null 2>&1 || \
  gcloud artifacts repositories create "${SERVICE_NAME}" \
    --repository-format=docker \
    --location="${REGION}" \
    --description="Docker repository for ${SERVICE_NAME} service" \
    --project="${PROJECT_ID}" --quiet || \
  { echo "Error: Unable to create Artifact Registry repository '${SERVICE_NAME}'."; exit 1; }
echo "Artifact Registry repository '${SERVICE_NAME}' ready."
echo "---------------------"
echo

# --- Build Docker Image ---
echo "Building Docker image with Distroless and compiled Deno binary..."
docker build --platform linux/amd64 -t "${IMAGE_NAME}" .
echo "Docker image built successfully."

# Get image size for comparison
IMAGE_SIZE=$(docker images "${IMAGE_NAME}" --format "{{.Size}}")
echo "Image size: ${IMAGE_SIZE}"
echo "---------------------"
echo

# --- Push Docker Image ---
echo "Pushing Docker image to Artifact Registry..."
docker push "${IMAGE_NAME}"
echo "Docker image pushed successfully."
echo "---------------------"
echo

# --- Deploy to Cloud Run ---
echo "Deploying to Cloud Run..."
gcloud run deploy "${SERVICE_NAME}" \
    --image "${IMAGE_NAME}" \
    --platform managed \
    --region "${REGION}" \
    --memory 128Mi \
    --port 8080 \
    --allow-unauthenticated \
    --project "${PROJECT_ID}"

echo "Deployment successful!"
echo "---------------------"
echo

# --- Get Service Info ---
echo "Getting service information..."
SERVICE_URL=$(gcloud run services describe "${SERVICE_NAME}" --region="${REGION}" --platform=managed --format="get(status.url)" --project="${PROJECT_ID}")

echo "Service URL: ${SERVICE_URL}"
echo "---------------------"

echo "Deployment complete!"