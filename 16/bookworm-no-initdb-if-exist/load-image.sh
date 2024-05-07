#!/bin/bash

# Check if version argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

version="$1"

podman build -t postgres-local-16:$version .

# Get the image ID
image_id=$(podman images | awk -v version="$version" '$1 == "localhost/postgres-local-16" && $2 == version {print $3}')

# Tag the image
podman tag "${image_id}" "localhost:32000/postgres-local-16:${version}"

# Push the tagged image
podman push --tls-verify=false "localhost:32000/postgres-local-16:${version}" "localhost:32000/postgres-local-16:${version}"
