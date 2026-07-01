#!/usr/bin/env bash
set -euo pipefail

# .devcontainer/start-services.sh
# Helper to start local services inside the devcontainer: solana-test-validator and optionally the frontend.

echo "=============================================="
echo " Solana + Anchor Development Container helper"
echo "=============================================="

echo "Opciones disponibles:"
echo "1) Iniciar solo Solana Test Validator"
echo "2) Iniciar solo frontend (cd frontend && npm run dev)"
echo "3) Iniciar ambas (validator + frontend)"
echo "4) Abrir shell (no iniciar servicios)"

read -p "Elige una opción [1-4]: " opt || true

case "$opt" in
  1)
    echo "Iniciando solana-test-validator..."
    solana-test-validator --rpc-port 8899 --faucet-port 9900 --bind-address 0.0.0.0 --quiet
    ;;
  2)
    echo "Iniciando frontend... (instala dependencias si es necesario en frontend/ )"
    cd /workspaces/test-solana/frontend || { echo "No existe frontend/"; exit 1; }
    npm install --no-audit --no-fund || true
    npm run dev
    ;;
  3)
    echo "Iniciando solana-test-validator en background..."
    solana-test-validator --rpc-port 8899 --faucet-port 9900 --bind-address 0.0.0.0 --quiet &
    sleep 1
    echo "Arrancando frontend..."
    cd /workspaces/test-solana/frontend || { echo "No existe frontend/"; exit 1; }
    npm install --no-audit --no-fund || true
    npm run dev
    ;;
  4)
    echo "Abriendo shell. Para iniciar servicios manualmente ejecuta: start-services.sh"
    exec /bin/bash
    ;;
  *)
    echo "Opción inválida o vacía. Abriendo shell."
    exec /bin/bash
    ;;
esac
