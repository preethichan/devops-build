#!/bin/bash

# ─────────────────────────────────────────────
# build.sh — Builds and pushes Docker image
# Usage: ./build.sh <branch>
# ─────────────────────────────────────────────

set -e  # Exit immediately on any error

DOCKER_USERNAME="preethichan"
BRANCH=${1}  # Passed as argument: "dev" or "master"

if [ -z "$BRANCH" ]; then
  echo "ERROR: Branch name required. Usage: ./build.sh <branch>"
  exit 1
fi

# Map branch → Docker Hub repo
if [ "$BRANCH" == "master" ]; then
  REPO="prod"
elif [ "$BRANCH" == "dev" ]; then
  REPO="dev"
else
  echo "ERROR: Unknown branch '$BRANCH'. Must be 'dev' or 'master'."
  exit 1
fi

IMAGE_TAG="${DOCKER_USERNAME}/devops-build-${REPO}:latest"

echo ">>> Building Docker image: $IMAGE_TAG"
docker build -t "$IMAGE_TAG" .

echo ">>> Pushing image to Docker Hub: $IMAGE_TAG"
docker push "$IMAGE_TAG"

echo ">>> Done. Image pushed: $IMAGE_TAG"
