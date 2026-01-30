# https://just.systems

SERVICE_NAME := "nks_embedding"

# Hvis ingen kommando, vis tilgjengelige oppskrifter
default:
  @just --list

# Bygg Docker bilde lokalt
build:
    docker build -t nks_cloud_embed . --platform=linux/amd64

# Lanser Docker bildet til Cloud Run
deploy:
    gcloud run deploy "{{SERVICE_NAME}}" \
        --source . \
        --region europe-west1 \
        --concurrency 64 \
        --cpu 8 \
        --memory 32Gi \
        --gpu 1 \
        --gpu-type nvidia-l4 \
        --max-instances 1 \
        --no-allow-unauthenticated \
        --no-cpu-throttling \
        --no-gpu-zonal-redundancy \
        --timeout 600

# Fjern Cloud Run instansen og alle tilknytte ressurser
delete:
    gcloud run services delete "{{SERVICE_NAME}}" 

# Opprett en lokal tilkobling til Cloud Run instansen på port `9090`
proxy:
    gcloud run services proxy "{{SERVICE_NAME}}" --port=9090
