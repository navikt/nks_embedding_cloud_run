# https://just.systems

SERVICE_NAME := "nks-embedding"
GCP_REGION := "europe-west1"

# Hvis ingen kommando, vis tilgjengelige oppskrifter
default:
  @just --list

# Bygg Docker bilde lokalt
[arg('image', pattern='gpu|cpu')]
build image="gpu":
    docker build -t nks_cloud_embed -f {{image}}.Dockerfile --platform=linux/amd64 .

# Lanser Docker bildet til Cloud Run
deploy image="ghcr.io/nks_embedding_cloud_run:latest":
    gcloud run deploy {{SERVICE_NAME}} \
        --image {{image}} \
        --description="Finjustert embeddingmodell for Bob servert med GPU" \
        --region {{GCP_REGION}} \
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
    gcloud run services --region {{GCP_REGION}} delete {{SERVICE_NAME}} 

# Opprett en lokal tilkobling til Cloud Run instansen
[arg('port', pattern='\d{4}')]
proxy port="9090":
    gcloud run services --region {{GCP_REGION}} proxy {{SERVICE_NAME}} --port={{port}}

# Hent ut en beskrivelse av Cloud Run instansen
describe:
    gcloud run services --region {{GCP_REGION}} describe {{SERVICE_NAME}}
