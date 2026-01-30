# Lokal embeddingmodell servert på Cloud Run

Dette prosjektet inneholder en oppskrift på hvordan Team AI og Automatisering i
Nav Kontaktsenter har satt opp servering av [Text Embedding Interface
(TEI)](https://huggingface.co/docs/text-embeddings-inference/index) på [GCP
Cloud Run](https://docs.cloud.google.com/run/docs/configuring/services/gpu).

## Komme i gang

Vi har inkludert en [`justfile`](./justfile) i prosjektet som automatiserer
bygging og lansering til Cloud Run.

List opp tilgjengelige oppskrifter med:

```bash
just
```

```text
Available recipes:
    build   # Bygg Docker bilde lokalt
    default # Hvis ingen kommando, vis tilgjengelige oppskrifter
    delete  # Fjern GCP Cloud Run instansen og alle ressurser tilknyttet
    deploy  # Lanser Docker bildet til GCP Cloud Run
    proxy   # Opprett en lokal tilkobling på port `9090`
```

### Lansere på Cloud Run

For å lansere ny versjon på Cloud Run er det et par steg som må være satt opp
før man kan kjøre `just deploy`.

1. Konfigurer riktig prosjekt: `gcloud config set project
nks-aiautomatisering-prod-194a`
1. Autentiser mot GCP: `gcloud auth login`

Deretter kan man kjøre:

```bash
just deploy
```

Dette vil lansere Docker bildet til Cloud Run med følgende oppsett:

- Region settes til `europe-west1` (per nå ikke tilgjengelig i `europe-north1`
som Nais kjører på)
- Per instans:
  - Ber om $8$ vCPU-er
  - Ber om $1$ GPU av typen `nvidia-l4`
  - Ber om $32$ GiB med minne
- Maks $1$ instans kjørende samtidig
- Man må være autentisert for å kunne kommunisere med instansen
- Ber om at lasten _ikke_ flyttes mellom forskjellige GCP soner

## Ressurser

- [Oppskrift fra TEI om Cloud
Run](https://huggingface.co/docs/text-embeddings-inference/tei_cloud_run).
- [Oppskrift fra Cloud Run om servering av
Ollama](https://docs.cloud.google.com/run/docs/tutorials/gpu-gemma-with-ollama)

---

## Henvendelser

Spørsmål knyttet til koden eller prosjektet kan stilles som issues her på
GitHub.

### For Nav-ansatte

Interne henvendelser kan sendes via Slack i kanalen
[`#team-nks-ai-og-automatisering`](https://nav-it.slack.com/archives/C04MRJ9SHM4).
