#!/bin/bash

# ─────────────────────────────────────────────
# deploy.sh — Pulls and runs the Docker image
# Usage: ./deploy.sh <branch>
# Run this ON the target server (EC2)
# ─────────────────────────────────────────────

set -e

DOCKER_USERNAME="preethichan"
BRANCH=${1}

if [ -z "$BRANCH" ]; then
  echo "ERROR: Branch name required. Usage: ./deploy.sh <branch>"
  exit 1
fi

if [ "$BRANCH" == "master" ]; then
  REPO="prod"
elif [ "$BRANCH" == "dev" ]; then
  REPO="dev"
else
  echo "ERROR: Unknown branch '$BRANCH'. Must be 'dev' or 'master'."
  exit 1
fi

IMAGE_TAG="${DOCKER_USERNAME}/devops-build-${REPO}:latest"

echo ">>> Pulling image: $IMAGE_TAG"
docker pull "$IMAGE_TAG"

echo ">>> Stopping existing container (if any)..."
docker stop devops-app 2>/dev/null || true
docker rm devops-app 2>/dev/null || true

echo ">>> Starting new container..."
docker run -d \
  --name devops-app \
  --restart unless-stopped \
  -p 80:80 \
  "$IMAGE_TAG"

echo ">>> Deployment complete. App running on port 80."
echo ">>> Container status:"
docker ps --filter "name=devops-app"
