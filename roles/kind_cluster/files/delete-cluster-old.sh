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

if [ ! -f "Ha-cluster.yaml" ]; then
    print_error "Configuration file Ha-cluster.yaml not found!"
    exit 1
fi

kind delete cluster --name kind-cluster || {
    print_warning "Failed to delete KIND cluster. It may not exist."
}

print_status "KIND cluster deleted successfully."
