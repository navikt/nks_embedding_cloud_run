FROM ghcr.io/huggingface/text-embeddings-inference:cpu-1.8.3

# Tving antall tråder for TEI server, setter til samme verdi som maks på Nais
ENV TOKIO_WORKER_THREADS=8
ENV TOKENIZATION_WORKERS=8
# Definer modellen TEI skal laste
ENV MODEL_ID="/snowflake-arctic-embed-m-v2.0-nav/final/"
ENV MAX_BATCH_TOKENS=8192
ENV DTYPE=float32
ENV PORT=8080

# Kopier inn vekter i Docker for raskere oppstart i Cloud Run (dette er anbefalt
# av GCP:
# https://docs.cloud.google.com/run/docs/tutorials/gpu-gemma-with-ollama#store-model-weights)
ADD "./models${MODEL_ID}" "${MODEL_ID}"
