#!/usr/bin/env bash
set -euo pipefail

# Script de ayuda para preparar el entorno de desarrollo local
# Requisitos previos: solana-cli y anchor-cli instalados

echo "Configurando Solana para localnet..."
solana config set --url http://localhost:8899

# Generar o reusar keypair local
KEYPAIR="$HOME/.config/solana/id.json"
if [ ! -f "$KEYPAIR" ]; then
  echo "Creando keypair en $KEYPAIR"
  solana-keygen new --outfile "$KEYPAIR" --no-passphrase
else
  echo "Keypair ya existe: $KEYPAIR"
fi

echo "Iniciando validador local (en otra terminal si prefieres): solana-test-validator"

echo "Recargando airdrop (si usas localnet)"
solana airdrop 100000 || true

echo "Construyendo programa con Anchor..."
anchor build

echo "Para desplegar: anchor deploy (asegúrate de tener un validador corriendo)"
