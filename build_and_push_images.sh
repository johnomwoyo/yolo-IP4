#!/usr/bin/env bash
set -euo pipefail

DOCKERHUB_USER="${DOCKERHUB_USER:-omwoyojohn}"
echo "Using Docker Hub user: $DOCKERHUB_USER"

# Backend
echo "Building backend image..."
cd backend
docker build -t ${DOCKERHUB_USER}/backend-final:v1.0.0 .
docker push ${DOCKERHUB_USER}/backend-final:v1.0.0
cd ..

# Frontend (build-time arg must point to internal service name)
echo "Building frontend image (REACT_APP_API_URL=http://backend-service:5000/api)..."
cd client
npm ci
docker build --build-arg REACT_APP_API_URL="http://backend-service:5000/api" -t ${DOCKERHUB_USER}/clients-latest:v1.0.0 .
docker push ${DOCKERHUB_USER}/clients-latest:v1.0.0
cd ..

echo "Images pushed successfully."
