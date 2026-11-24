#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Backup automatizado de Banco de Dados com retenção configurável (padrão: 7 dias)
# ==============================================================================
BACKUP_DIR="${BACKUP_DIR:-./backups}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP_DIR"

if [[ -n "${POSTGRES_CONTAINER:-}" ]]; then
  OUT_FILE="$BACKUP_DIR/pg_backup_${TIMESTAMP}.sql.gz"
  docker exec "$POSTGRES_CONTAINER" pg_dump -U "${POSTGRES_USER:-whatsapp_ai}" "${POSTGRES_DB:-whatsapp_ai}" | gzip > "$OUT_FILE"
  echo "Backup PostgreSQL gerado: $OUT_FILE"
elif [[ -f "./backend/prisma/dev.db" ]]; then
  OUT_FILE="$BACKUP_DIR/sqlite_backup_${TIMESTAMP}.db.gz"
  gzip -c "./backend/prisma/dev.db" > "$OUT_FILE"
  echo "Backup SQLite gerado: $OUT_FILE"
else
  echo "Nenhum banco encontrado para backup." >&2
  exit 1
fi

find "$BACKUP_DIR" -type f -name "*.gz" -mtime +"$RETENTION_DAYS" -delete
echo "Limpeza de backups com mais de ${RETENTION_DAYS} dias concluída."
