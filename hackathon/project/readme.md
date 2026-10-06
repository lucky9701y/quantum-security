# QKD Lab — BB84 Quantum Key Distribution Simulator

An interactive hackathon project that demonstrates how the BB84 quantum key distribution protocol can create a shared secret key while making eavesdropping observable.

## What this project demonstrates

- End-to-end BB84 simulation from preparation through privacy amplification
- Alice and Bob choosing random bits and measurement bases
- Basis reconciliation and sifted-key generation
- QBER measurement over the sifted key
- Asymptotic secret key rate using the binary entropy bound
- Shor–Preskill abort threshold visualization at approximately 11%
- Intercept–resend attack simulation
- Beam-splitter / entanglement-inspired probing model
- Adjustable transmission size and channel noise
- Secure-key preview with copy interaction
- Persisted experiment history using Supabase
- Post-quantum cryptography comparison with ML-KEM / Kyber

## Product experience

QKD Lab is organized as a focused research workspace:

- **Live lab** shows the quantum channel, Alice, Bob, the attacker model, and live protocol metrics.
- **Experiment controls** let the presenter change the channel model, transmission volume, and noise level.
- **Protocol trace** explains the four stages: prepare, transmit, sift, and privacy amplify.
- **Sifted key** displays a short preview of the reconciled key material.
- **Recent experiment runs** provides a shared history of saved experiments.
- **PQC context** explains how QKD complements, rather than replaces, post-quantum cryptography.

## Running the project

Install the project dependencies, then start the Vite development environment through the workspace tooling.

The project can also be built for production with:

```bash
npm run build
```

Useful validation scripts:

```bash
npm run typecheck
npm run lint
```

## Simulation model

The simulator generates a random classical bit and a random basis for each transmitted qubit. Bob independently selects a measurement basis. A bit remains in the sifted key only when Alice and Bob used the same basis.

The simulator models disturbance as follows:

- **Clean channel:** no attack-induced errors
- **Intercept–resend:** approximately 25% QBER on matching-basis measurements
- **Beam-splitter probe:** approximately 12% QBER on matching-basis measurements
- **Channel noise:** an additional configurable error probability from 0% to 10%

The reported asymptotic secret key rate is calculated as:

```text
R = max(0, 1 − 2H₂(QBER))
```

where `H₂` is the binary entropy function. The final key preview applies an additional illustrative privacy-amplification reduction to make the post-processing stage visible in the demo.

## Data persistence

Completed simulations are saved as append-only records in the `bb84_simulation_runs` Supabase table. The stored fields include:

- Attack model
- Channel noise
- Number of qubits
- Measured QBER
- Secret key rate
- Final key length
- Accepted or aborted status
- Creation time

The table uses row-level security. This is a shared, no-sign-in hackathon workspace: visitors may view and create experiment records, while browser updates and deletes are blocked.

## Technology

- React
- TypeScript
- Vite
- Tailwind CSS
- Lucide React
- Supabase

## Important scope note

This is an educational and presentation simulator, not a production QKD implementation. Real-world deployments also require authenticated classical communication, calibrated quantum hardware, finite-key security analysis, composable security proofs, device-specific noise models, and operational key management.

## Suggested demo flow

1. Open **Live lab** with the clean channel selected.
2. Run a simulation and point out the low QBER and accepted key.
3. Switch to **Intercept–resend**.
4. Run the simulation again and compare the QBER and channel decision.
5. Increase channel noise to show how environmental disturbance affects the key.
6. Open **PQC context** to explain why QKD and ML-KEM can be viewed as complementary layers of a future-ready security strategy.
