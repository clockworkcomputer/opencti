#!/usr/bin/env bash
set -euo pipefail

uuid() { uuidgen | tr '[:upper:]' '[:lower:]'; }

# Genera una cadena hexadecimal de 32 caracteres (16 bytes = 128 bits de entropía)
rand_hex() { openssl rand -hex 16; }

# Parámetros mínimos
IP_DEFAULT="${1:-$(hostname -I 2>/dev/null | awk '{print $1}')}"


cat > .env <<EOF
# --- OpenCTI básicos ---
OPENCTI_ADMIN_EMAIL=admin@clockwork.lan
OPENCTI_ADMIN_PASSWORD=$(rand_hex)
OPENCTI_ADMIN_TOKEN=$(uuid)

# IMPORTANTE: usa la IP del servidor y http en aula
OPENCTI_BASE_URL=http://${IP_DEFAULT:-127.0.0.1}:8080
OPENCTI_HEALTHCHECK_ACCESS_KEY=$(rand_hex)

APP__SECURE_COOKIE=false

# --- MinIO (S3) ---
MINIO_ROOT_USER=opencti_s3
MINIO_ROOT_PASSWORD=$(rand_hex)

# --- RabbitMQ ---
RABBITMQ_DEFAULT_USER=opencti
RABBITMQ_DEFAULT_PASS=$(rand_hex)

# --- Elasticsearch ---
ELASTIC_MEMORY_SIZE=2G

# --- SMTP opcional ---
SMTP_HOSTNAME=localhost

# --- IDs de conectores (UUIDv4 únicos) ---
CONNECTOR_EXPORT_FILE_STIX_ID=$(uuid)
CONNECTOR_EXPORT_FILE_CSV_ID=$(uuid)
CONNECTOR_EXPORT_FILE_TXT_ID=$(uuid)
CONNECTOR_IMPORT_FILE_STIX_ID=$(uuid)
CONNECTOR_IMPORT_DOCUMENT_ID=$(uuid)
CONNECTOR_ANALYSIS_ID=$(uuid)
XTM_COMPOSER_ID=$(uuid)
EOF

echo "✅ Listo: generado .env con credenciales únicas."

