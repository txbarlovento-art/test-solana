#!/usr/bin/env bash
set -euo pipefail

BRANCH="feature/frontend-ts"
COMMIT_MSG="feat(frontend+ci): integrate wallet-adapter, TypeScript frontend, sync script and CI"

echo "Creando rama ${BRANCH}"
git checkout -b "${BRANCH}"

# Crear directorios
mkdir -p frontend/src
mkdir -p scripts
mkdir -p .github/workflows

# frontend/package.json
cat > frontend/package.json <<'EOF'
{
  "name": "test-solana-frontend",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "sync-idl": "../scripts/sync_idl.sh"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "@solana/web3.js": "^1.78.0",
    "@project-serum/anchor": "^0.27.0",
    "@solana/wallet-adapter-react": "^0.19.6",
    "@solana/wallet-adapter-wallets": "^0.19.6",
    "@solana/wallet-adapter-react-ui": "^0.10.0",
    "@solana/wallet-adapter-phantom": "^0.1.3"
  },
  "devDependencies": {
    "typescript": "^5.1.6",
    "vite": "^5.1.0",
    "@vitejs/plugin-react": "^5.0.2"
  }
}
EOF

# frontend/tsconfig.json
cat > frontend/tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2021",
    "useDefineForClassFields": true,
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": false,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "types": ["vite/client"]
  },
  "include": ["src"]
}
EOF

# frontend/vite.config.ts
cat > frontend/vite.config.ts <<'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
})
EOF

# frontend/src/main.tsx
cat > frontend/src/main.tsx <<'EOF'
import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App'
import './index.css'

createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
)
EOF

# frontend/src/App.tsx
cat > frontend/src/App.tsx <<'EOF'
import React, { useMemo } from 'react'
import { Connection } from '@solana/web3.js'
import { getProgram } from './solana'
import { WalletProvider, useWallet } from '@solana/wallet-adapter-react'
import { PhantomWalletAdapter } from '@solana/wallet-adapter-wallets'
import { WalletModalProvider, WalletMultiButton } from '@solana/wallet-adapter-react-ui'
import '@solana/wallet-adapter-react-ui/styles.css'
import { PROGRAM_ID } from './programId'

const NETWORK = 'http://localhost:8899'

function InnerApp() {
  const { publicKey, signTransaction, connected } = useWallet()

  const handleInitialize = async () => {
    if (!publicKey) return alert('Conecta tu wallet')
    try {
      const program = getProgram({ publicKey, signTransaction } as any, PROGRAM_ID)
      // Llamada simple a la instrucción 'initialize' generada por Anchor.
      await program.rpc.initialize()
      alert('initialize ejecutado')
    } catch (err) {
      console.error('Error initialize', err)
      alert('Error: ' + (err as any).toString())
    }
  }

  return (
    <div className="container">
      <header>
        <h1>Test Solana - Frontend (React + Vite + Wallet Adapter)</h1>
      </header>
      <main>
        <p>Conecta tu wallet (Phantom) para interactuar con el programa Anchor en localnet.</p>
        <WalletMultiButton />
        <p />
        <button onClick={handleInitialize} disabled={!connected}>
          Ejecutar initialize (ejemplo)
        </button>
        {publicKey && (
          <div style={{ marginTop: 12 }}>
            <strong>Wallet:</strong> {publicKey.toString()}
          </div>
        )}
      </main>
      <footer>
        <small>Desarrollado para el repo txbarlovento-art/test-solana</small>
      </footer>
    </div>
  )
}

export default function App() {
  const wallets = useMemo(() => [new PhantomWalletAdapter()], [])
  const connection = useMemo(() => new Connection(NETWORK), [])

  return (
    <WalletProvider wallets={wallets} autoConnect={false}>
      <WalletModalProvider>
        <InnerApp />
      </WalletModalProvider>
    </WalletProvider>
  )
}
EOF

# frontend/src/solana.ts
cat > frontend/src/solana.ts <<'EOF'
import { Connection, PublicKey } from '@solana/web3.js'
import { AnchorProvider, Program } from '@project-serum/anchor'
import idl from './idl.json'

const NETWORK = 'http://localhost:8899'
const connection = new Connection(NETWORK, 'processed')

export function getProvider(wallet: any) {
  return new AnchorProvider(connection, wallet, AnchorProvider.defaultOptions())
}

export function getProgram(wallet: any, programIdString: string) {
  const provider = getProvider(wallet)
  const programId = new PublicKey(programIdString)
  return new Program(idl as any, programId, provider)
}
EOF

# frontend/src/idl.json (placeholder)
cat > frontend/src/idl.json <<'EOF'
{
  "version": "0.1.0",
  "name": "test_solana",
  "instructions": [
    {
      "name": "initialize",
      "accounts": [],
      "args": []
    }
  ]
}
EOF

# frontend/src/programId.ts
cat > frontend/src/programId.ts <<'EOF'
export const PROGRAM_ID = "ReplaceWithProgramIDxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
EOF

# frontend/src/index.css
cat > frontend/src/index.css <<'EOF'
:root {
  --bg: #0f172a;
  --card: #0b1220;
  --text: #e6eef8;
}

body {
  margin: 0;
  padding: 0;
  font-family: Inter, system-ui, Arial, sans-serif;
  background: linear-gradient(180deg, #071024, #0f172a);
  color: var(--text);
}

.container {
  max-width: 820px;
  margin: 48px auto;
  padding: 24px;
  background: rgba(255,255,255,0.02);
  border-radius: 12px;
}

button {
  padding: 10px 16px;
  border-radius: 8px;
  border: none;
  background: #06b6d4;
  color: #042028;
  font-weight: 600;
  cursor: pointer;
}
EOF

# scripts/sync_idl.sh
cat > scripts/sync_idl.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# scripts/sync_idl.sh
# Ejecuta `anchor build`, copia el IDL al frontend y actualiza el PROGRAM_ID en frontend/src/programId.ts

echo "Ejecutando: anchor build"
anchor build

IDL_PATH="target/idl/test_solana.json"
if [ -f "$IDL_PATH" ]; then
  echo "Copiando $IDL_PATH -> frontend/src/idl.json"
  cp "$IDL_PATH" frontend/src/idl.json
else
  echo "IDL no encontrado en $IDL_PATH"
fi

KEYPAIR="target/deploy/test_solana-keypair.json"
if [ -f "$KEYPAIR" ]; then
  PROG_ID=$(solana-keygen pubkey "$KEYPAIR")
  echo "Escribiendo PROGRAM_ID -> frontend/src/programId.ts"
  cat > frontend/src/programId.ts <<EOF2
export const PROGRAM_ID = "${PROG_ID}";
EOF2
  echo "PROGRAM_ID actualizado: ${PROG_ID}"
else
  echo "Keypair del programa no encontrado en $KEYPAIR"
fi
EOF
chmod +x scripts/sync_idl.sh

# .github/workflows/ci.yml
cat > .github/workflows/ci.yml <<'EOF'
name: CI

on:
  push:
  pull_request: 

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Setup Rust
        run: |
          curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
          source $HOME/.cargo/env
          rustup default stable

      - name: Install Solana CLI
        run: |
          sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
          echo "Exporting Solana PATH"
          echo "$HOME/.local/share/solana/install/active_release/bin" >> $GITHUB_PATH

      - name: Install Anchor CLI
        run: |
          source $HOME/.cargo/env
          cargo install --git https://github.com/coral-xyz/anchor --locked anchor-cli || true
          anchor --version || true

      - name: Build Anchor program
        run: |
          source $HOME/.cargo/env
          anchor build

      - name: Install frontend dependencies
        working-directory: frontend
        run: npm ci

      - name: Build frontend
        working-directory: frontend
        run: npm run build
EOF

# Update README.md (overwrite)
cat > README.md <<'EOF'
Estructura completa del proyecto para desarrollo local y CI

Incluye:
- Backend Anchor: programs/test_solana/
- Frontend React (Vite + TypeScript) en frontend/
- Script scripts/sync_idl.sh para ejecutar `anchor build` y sincronizar el IDL + PROGRAM_ID con el frontend
- Workflow de GitHub Actions (.github/workflows/ci.yml) que compila el programa Anchor y construye el frontend

Cómo empezar (rápido)
1) Instala Solana CLI y Anchor CLI según la documentación oficial.
2) Inicia un validador local:
   solana-test-validator
3) Genera o utiliza tu keypair local para la wallet:
   solana-keygen new --outfile ~/.config/solana/id.json --no-passphrase
4) Configura solana-cli:
   solana config set --url http://localhost:8899 --keypair ~/.config/solana/id.json

Sincronizar IDL y PROGRAM_ID con el frontend
- Desde la raíz del repo ejecuta:
  bash scripts/sync_idl.sh
  Esto hará `anchor build`, copiará target/idl/test_solana.json -> frontend/src/idl.json
  y actualizará frontend/src/programId.ts con la pubkey generada por Anchor.

Arrancar frontend
- Instala dependencias y ejecuta dev server:
  cd frontend
  npm install
  npm run dev

Despliegue local del programa
- Ejecuta anchor build (o usa scripts/sync_idl.sh)
- Comprueba el program id en target/deploy/test_solana-keypair.json:
  solana-keygen pubkey target/deploy/test_solana-keypair.json
- Reemplaza declare_id! en programs/test_solana/src/lib.rs si quieres fijar el ID (opcional).

CI (GitHub Actions)
- El workflow configurado intentará instalar Rust, Solana CLI and Anchor CLI, luego ejecutará `anchor build` y construirá el frontend.

Notas finales
- El frontend usa @solana/wallet-adapter-react + Phantom adapter. Para pruebas locales instala Phantom en tu navegador y conecta a localnet (con el validador local corriendo).
- Si quieres que automatice la creación del Program ID en lib.rs y Anchor.toml después del build, puedo añadir un paso extra en scripts/sync_idl.sh para modificar esos archivos.
EOF

# .gitignore
cat > .gitignore <<'EOF'
target/
**/target/
node_modules/
.DS_Store
.env
/*.key
/*.json
*.so
frontend/node_modules/
frontend/dist/
EOF

git add .
git commit -m "${COMMIT_MSG}"
echo "Haciendo push de la rama ${BRANCH}"
git push --set-upstream origin "${BRANCH}"

echo "Hecho. Crea un Pull Request desde la rama ${BRANCH} a main si deseas revisar antes de mergear."
echo "Si quieres que cree el PR por ti, dímelo y lo intento (necesitaré permisos para crear PRs)."
