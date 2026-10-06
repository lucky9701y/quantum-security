/*
# Create BB84 simulation runs table

1. New Tables
- `bb84_simulation_runs` stores public, shareable simulation results for the hackathon demo.
- `id` (uuid, primary key) uniquely identifies a completed run.
- `created_at` (timestamptz) records when the run was saved.
- `attack` (text) stores the selected channel model.
- `noise_percent` (numeric) stores the configured channel noise.
- `qubits` (integer) stores the number of transmitted qubits.
- `qber` (numeric) stores the measured quantum bit error rate.
- `secret_rate` (numeric) stores the asymptotic secret key rate.
- `final_key_bits` (integer) stores the length of the extracted key.
- `secure` (boolean) records whether the run stayed below the abort threshold.

2. Security
- Row level security is enabled.
- This is an intentionally shared, no-sign-in demo history, so anonymous and authenticated visitors may read and insert runs.
- Update and delete are intentionally not exposed to the browser because completed run records are immutable.

3. Important Notes
- The table is append-only from the client perspective.
- No account identifiers or private payloads are stored.
*/

CREATE TABLE IF NOT EXISTS bb84_simulation_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz NOT NULL DEFAULT now(),
  attack text NOT NULL,
  noise_percent numeric NOT NULL DEFAULT 0,
  qubits integer NOT NULL,
  qber numeric NOT NULL,
  secret_rate numeric NOT NULL,
  final_key_bits integer NOT NULL,
  secure boolean NOT NULL DEFAULT true
);

ALTER TABLE bb84_simulation_runs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can view BB84 runs" ON bb84_simulation_runs;
CREATE POLICY "Public can view BB84 runs"
ON bb84_simulation_runs FOR SELECT
TO anon, authenticated
USING (true);

DROP POLICY IF EXISTS "Public can create BB84 runs" ON bb84_simulation_runs;
CREATE POLICY "Public can create BB84 runs"
ON bb84_simulation_runs FOR INSERT
TO anon, authenticated
WITH CHECK (true);

DROP POLICY IF EXISTS "Public cannot update BB84 runs" ON bb84_simulation_runs;
CREATE POLICY "Public cannot update BB84 runs"
ON bb84_simulation_runs FOR UPDATE
TO anon, authenticated
USING (false)
WITH CHECK (false);

DROP POLICY IF EXISTS "Public cannot delete BB84 runs" ON bb84_simulation_runs;
CREATE POLICY "Public cannot delete BB84 runs"
ON bb84_simulation_runs FOR DELETE
TO anon, authenticated
USING (false);

CREATE INDEX IF NOT EXISTS bb84_simulation_runs_created_at_idx
ON bb84_simulation_runs (created_at DESC);