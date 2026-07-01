Estructura inicial para un proyecto Solana usando Anchor y solana-cli

Archivos creados:
- Anchor.toml
- Cargo.toml (workspace)
- programs/test_solana/Cargo.toml
- programs/test_solana/src/lib.rs
- scripts/setup.sh
- frontend/ (React + Vite)
- README.md
- .gitignore

Cómo empezar (resumen):
1) Backend (Anchor + solana-cli)
   - Instala Solana CLI:
     sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
   - Instala Anchor CLI (ejemplo con cargo):
     cargo install --git https://github.com/coral-xyz/anchor --locked anchor-cli
   - Inicia un validador local en otra terminal:
     solana-test-validator
   - Configura solana-cli para usar localnet:
     solana config set --url http://localhost:8899 --keypair ~/.config/solana/id.json
   - Construir y desplegar:
     anchor build
     anchor deploy

2) Frontend (React + Vite)
   - Ir al directorio frontend:
     cd frontend
   - Instalar dependencias:
     npm install
   - Iniciar servidor de desarrollo:
     npm run dev
   - La app consumirá el programa Solana usando conexión web3 y Anchor (puedo añadir ejemplos más adelante).

Notas:
- Reemplaza el program ID en programs/test_solana/src/lib.rs después de `anchor build` si lo necesitas.
- Si quieres que el frontend se conecte a Phantom u otra wallet, puedo añadir la integración y componentes para conexión.
