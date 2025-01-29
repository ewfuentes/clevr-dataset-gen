#!/bin/env bash

# Initialize variables
output_dir=""
additional_args=()

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --output)
            if [[ -n "$2" ]]; then
                output_dir="$2"
                shift 2
            else
                echo "Error: --output requires a path argument"
                exit 1
            fi
            ;;
        *)
            additional_args+=("$1")
            shift
            ;;
    esac
done

# Check if output directory is provided
if [[ -z "$output_dir" ]]; then
    echo "Error: --output flag is required"
    exit 1
fi

# Ensure output directory exists
mkdir -p "$output_dir"

# Build the Docker image
docker build . -t clevr:latest

# Run the Docker container with the mounted output directory and additional arguments
docker run --gpus all \
    -v "${output_dir}:/app/clevr-dataset-gen/output" \
    clevr:latest \
    --use_gpu 1 \
    "${additional_args[@]}"
