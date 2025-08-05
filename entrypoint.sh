#!/bin/bash
set -e

echo "🔧 Aguarde, preparando ambiente Rails..."

# Espera pelo banco (caso ainda não esteja up)
if [ "$WAIT_FOR_DB" = "true" ]; then
  echo "⏳ Aguardando banco de dados..."
  until rails db:version > /dev/null 2>&1; do
    sleep 1
  done
fi

echo "✅ Migrando banco..."
rails db:migrate

# Remove o arquivo pid do servidor, se existir
rm -f tmp/pids/server.pid

# Executa o processo principal
exec "$@"
