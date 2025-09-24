#!/bin/bash
set -e 
set -u

# color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status(){
    echo -e "${GREEN}[INFO]${NC} $1"
}
print_error(){
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}
print_warning(){
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

wait_for_resource(){
    local resource=$1
    local namespace=${2:"default"}
    local timeout=${3:-300}

    print_status "Waiting for resource $resource in namespace $namespace to be ready..."
    kubectl wait $resource -n $namespace --for=condition=Ready --timeout=${timeout}s || {
        print_error "Resource $resource in namespace $namespace did not become ready within ${timeout}s"
    }
    print_status "Resource $resource in namespace $namespace is ready."
}


# Cleanup function
cleanup() {
    print_warning "Script interrupted. Cleaning up..."
    # Add cleanup commands if needed
    exit 1
}

# Trap cleanup function on script exit
trap cleanup INT TERM

print_status "Setting up KIND cluster with Calico CNI..."

if [ ! -f "Ha-cluster.yaml" ]; then
    print_error "Configuration file Ha-cluster.yaml not found!"
    exit 1
fi

print_status "Creating KIND cluster..."
if kind create cluster --name kind-cluster --config Ha-cluster.yaml; then
    print_status "KIND cluster created successfully"
else
    print_error "Failed to create KIND cluster"
    exit 1
fi
# Wait for cluster to be ready
print_status "Waiting for cluster to be ready..."
sleep 30

# Check cluster status
if kubectl cluster-info &>/dev/null; then
    print_status "Cluster is accessible"
else
    print_error "Cluster is not accessible"
    exit 1
fi

# Install Calico Tigera Operator
print_status "Installing Calico Tigera Operator..."
if kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/tigera-operator.yaml; then
    print_status "Tigera Operator installed successfully"
else
    print_error "Failed to install Tigera Operator"
    exit 1
fi

# Wait for operator to be ready
sleep 60

# Install Calico custom resources
print_status "Installing Calico custom resources..."
if kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/custom-resources.yaml; then
    print_status "Calico custom resources installed successfully"
else
    print_error "Failed to install Calico custom resources"
    exit 1
fi

# Wait for Calico to be ready
print_status "Waiting for Calico to be ready..."
sleep 30

# Check Tigera status (non-blocking)
print_status "Checking Tigera status..."
timeout 60s bash -c 'until kubectl get tigerastatus &>/dev/null; do sleep 5; done' || {
    print_warning "Tigera status not available yet"
}

# Wait for all Calico pods to be ready
print_status "Waiting for Calico system pods to be ready..."
kubectl wait --for=condition=ready pod -l k8s-app=calico-node -n calico-system --timeout=300s || {
    print_warning "Some Calico pods may not be ready yet"
}

kubectl wait --for=condition=ready pod -l k8s-app=calico-kube-controllers -n calico-system --timeout=300s || {
    print_warning "Calico controllers may not be ready yet"
}

# Check cluster nodes
print_status "Checking cluster nodes..."
kubectl get nodes -o wide

# Check all system pods
print_status "Checking system pods..."
kubectl get pods -A

# Check Tigera status
print_status "Final Tigera status check..."
kubectl get tigerastatus || print_warning "Tigera status not available"

# Optional: Port forward (commented out as it's blocking)
print_status "Setup completed successfully!"
print_status "To monitor the cluster manually, run:"
echo "  kubectl get tigerastatus"
echo "  kubectl get pods -A"
echo ""
print_status "To port-forward whisker service, run:"
echo "  kubectl port-forward -n calico-system service/whisker 8081:8081"

print_status "KIND cluster with Calico is ready!"

nohup cloud-provider-kind -enable-lb-port-mapping > "$(date +%Y%m%d-%H%M%S)-cloud-provider-kind.log" 2>&1 &

print_status "Load balancer started successfully."

kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml

print_status "Ingress NGINX controller deployed."

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

print_status "Ingress NGINX controller is ready."

# # setup argo cd
# print_status "Setting up Argo CD..."

# helm upgrade --install argocd argo/argo-cd -f ../helm-chart/argo-cd/values.yaml --namespace dev-argocd --create-namespace
# print_status "Argo CD setup completed."

# print_status "Password for admin user: ArgoCD: "
# kubectl -n dev-argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# print_status "Deploying Mongodb..."
# helm upgrade --install mongodb -f ../helm-chart/mongodb/mongodb/values.yaml bitnami/mongodb --namespace dev-mongodb --create-namespace