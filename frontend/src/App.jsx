import React, { useState } from 'react'

export default function App() {
  const [walletAddress, setWalletAddress] = useState(null)

  async function connectWallet() {
    try {
      if (window.solana && window.solana.isPhantom) {
        const resp = await window.solana.connect()
        setWalletAddress(resp.publicKey.toString())
      } else {
        alert('Instala Phantom Wallet para conectar (o usa otra wallet compatible)')
      }
    } catch (err) {
      console.error('Error conectando wallet:', err)
    }
  }

  return (
    <div className="container">
      <header>
        <h1>Test Solana - Frontend (React + Vite)</h1>
      </header>
      <main>
        <p>Conecta tu wallet para interactuar con el programa Anchor en localnet.</p>
        {walletAddress ? (
          <div>
            <strong>Wallet:</strong> {walletAddress}
          </div>
        ) : (
          <button onClick={connectWallet}>Conectar Wallet (Phantom)</button>
        )}
      </main>
      <footer>
        <small>Desarrollado para el repo txbarlovento-art/test-solana</small>
      </footer>
    </div>
  )
}
