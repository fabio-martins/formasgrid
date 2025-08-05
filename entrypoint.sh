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

# Precompile assets apenas se necessário
if [ "$RAILS_ENV" = "production" ]; then
  echo "🚀 Pré-compilando assets (produção)..."
  rails assets:precompile
else
echo "🚀 Pré-compilando assets (development)..."
  rails assets:clobber
  rails assets:precompile
  RAILS_ENV=development bundle exec rails assets:precompile
fi

# Remove o arquivo pid do servidor, se existir
rm -f tmp/pids/server.pid

# Executa o processo principal
exec "$@"
