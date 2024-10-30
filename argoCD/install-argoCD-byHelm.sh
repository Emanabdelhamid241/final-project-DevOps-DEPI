#!/bin/bash

# Define variables
NAMESPACE="argo" # Set the namespace where Argo will be installed
RELEASE_NAME="argo-workflows" # Set the release name
HELM_REPO_URL="https://argoproj.github.io/argo-helm" # Argo Helm repository


#Start Minikube
echo "--------------------Starting Minikube--------------------".
minikube start

# Add the Argo Helm repository
helm repo add argo $HELM_REPO_URL
helm repo update

# Create the namespace (if it doesn't already exist)
kubectl create namespace $NAMESPACE || true

# Install Argo Workflows
helm install $RELEASE_NAME argo/argo-workflows --namespace $NAMESPACE

# Verify installation
kubectl get pods -n $NAMESPACE



kubectl --namespace argo get services -o wide | grep argo-workflows-server
echo "open from http://localhost:2746"
kubectl port-forward svc/argo-workflows-server -n argo 2746:2746
