# `89` betyr CUDA kapabilitet 8.9 som kreves for L4 GPU-en tilgjengelig i Cloud
# Run (https://docs.cloud.google.com/run/docs/configuring/services/gpu#gpu-type)
FROM ghcr.io/huggingface/text-embeddings-inference:89-1.8.3

# Tving antall tråder for TEI server, viktig å bruke samme antall som vCPU i
# Cloud Run
ENV TOKIO_WORKER_THREADS=8
ENV TOKENIZATION_WORKERS=8
# Definer modellen TEI skal laste
ENV MODEL_ID="/snowflake-arctic-embed-m-v2.0-nav/final/"
ENV MAX_BATCH_TOKENS=8192
ENV DTYPE=float16
ENV PORT=8080
# Setter etter anbefaling:
# https://huggingface.co/docs/text-embeddings-inference/tei_cloud_run#deploy-tei-on-cloud-run
ENV MAX_CONCURRENT_REQUESTS=64

# Kopier inn vekter i Docker for raskere oppstart i Cloud Run (dette er anbefalt
# av GCP:
# https://docs.cloud.google.com/run/docs/tutorials/gpu-gemma-with-ollama#store-model-weights)
ADD "./models${MODEL_ID}" "${MODEL_ID}"

# Start TEI server
ENTRYPOINT ["text-embeddings-router", "--json-output"]
