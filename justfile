# https://just.systems

SERVICE_NAME := "nks-embedding"

# Hvis ingen kommando, vis tilgjengelige oppskrifter
default:
  @just --list

# Bygg Docker bilde lokalt
[arg('image', pattern='gpu|cpu')]
build image="gpu":
    docker build -t nks_cloud_embed -f {{image}}.Dockerfile --platform=linux/amd64 .

# Lanser Docker bildet til Cloud Run
deploy: build
    gcloud run deploy {{SERVICE_NAME}} \
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
    gcloud run services delete {{SERVICE_NAME}} 

# Opprett en lokal tilkobling til Cloud Run instansen
[arg('port', pattern='\d{4}')]
proxy port="9090":
    gcloud run services proxy {{SERVICE_NAME}} --port={{port}}
