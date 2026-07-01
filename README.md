Estructura inicial para un proyecto Solana usando Anchor y solana-cli

Archivos creados:
- Anchor.toml
- Cargo.toml (workspace)
- programs/test_solana/Cargo.toml
- programs/test_solana/src/lib.rs
- scripts/setup.sh
- .gitignore

Cómo empezar (resumen):
1) Instala Solana CLI:
   sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
2) Instala Anchor CLI (ejemplo con cargo):
   cargo install --git https://github.com/coral-xyz/anchor --locked anchor-cli
   (o sigue la guía oficial de Anchor si hay cambios)
3) Inicia un validador local en otra terminal:
   solana-test-validator
4) Corre el script de setup para configurar clave y construir:
   bash scripts/setup.sh
5) Para desplegar localmente:
   anchor deploy

Notas:
- Reemplaza el programa id en programs/test_solana/src/lib.rs por el ID que genere Anchor (o usa `anchor keys generate`).
- Ajusta las versiones de dependencias en Cargo.toml según la versión de Anchor que instales.
- Si quieres tests en TypeScript, puedo añadir package.json, tests/ y configuración extra.
