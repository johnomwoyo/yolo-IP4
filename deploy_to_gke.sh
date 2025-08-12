#!/usr/bin/env bash
set -euo pipefail

PROJECT="${GCP_PROJECT:-ip4-assignment-468811}"
CLUSTER="${CLUSTER_NAME:-ip4-cluster}"
REGION="${CLUSTER_REGION:-us-central1}"

echo "GCP project: $PROJECT"
read -p "Proceed to create GKE cluster named $CLUSTER in $REGION? (y/N) " confirm
if [[ "\$confirm" != "y" && "\$confirm" != "Y" ]]; then
  echo "Skipping cluster creation. Ensure you have a cluster and kubectl configured."
else
  gcloud config set project "$PROJECT"
  gcloud services enable container.googleapis.com compute.googleapis.com containerregistry.googleapis.com
  gcloud container clusters create "$CLUSTER" --region "$REGION" --num-nodes=3 --machine-type=e2-medium
fi

gcloud container clusters get-credentials "$CLUSTER" --region "$REGION"

# Create k8s secret for Mongo URI (safe: creates a secret resource in the cluster)
kubectl create secret generic mongo-uri \
  --from-literal=MONGODB_URI='mongodb://admin:password123@mongodb-service:27017/yolodb?authSource=admin' \
  --dry-run=client -o yaml | kubectl apply -f -

# Apply manifests in order
kubectl apply -f kubernetes/mongodb-stateful.yaml
kubectl rollout status statefulset/mongodb

kubectl apply -f kubernetes/backend-deployment.yaml
kubectl rollout status deployment/backend-deployment

kubectl apply -f kubernetes/frontend-deployment.yaml
kubectl rollout status deployment/frontend-deployment

echo "Deployment applied. Get frontend external IP with: kubectl get svc frontend-service -o wide"
