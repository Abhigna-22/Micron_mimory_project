# (13,8) Hamming Encoder – Verification Report

This repository contains the functional verification results for a **(13,8) Hamming Encoder with overall parity (SECDED)**.  
The design is purely combinational and has been validated using exhaustive and fault-injection–based testbenches.

---

## Design Under Test

- **Module**: `hamming_encoder`
- **Function**: (13,8) Hamming code generation with overall parity
- **ECC Type**: SECDED (Single Error Correction, Double Error Detection)
- **Logic Type**: Pure combinational

---

## Verification Goals

- Validate correct parity generation  
- Validate correct placement of data and parity bits  
- Ensure stable, deterministic, X-free outputs  
- Verify correct behavior under single-bit and double-bit error conditions  

---

## Test Summary

| Test ID | Test Name                  | Description                                | Status |
|-------:|----------------------------|--------------------------------------------|--------|
| 4.1    | Sanity & Bring-up          | Basic vectors and visual inspection        | PASS   |
| 4.2    | Exhaustive Encode-Decode   | All 256 input combinations                 | PASS   |
| 4.3    | Single-Bit Error Injection | Correction across all 13 bit positions    | PASS   |
| 4.4    | Double-Bit Error Detection | Detection without correction (DED)         | PASS   |

---

## 4.1 Sanity & Bring-up Test

### Objective
Verify basic encoder functionality using representative input patterns and ensure stable, deterministic outputs.

### Test Method
- Apply selected 8-bit input vectors  
- Allow combinational logic to settle  
- Display encoded output with grouped bit formatting  

### Test Vectors

| Input (hex) | Encoded Output (grouped) |
|------------:|--------------------------|
| 00 | 0_0000_0_000_0_000 |
| FF | 0_1111_0_111_0_111 |
| AF | 1_1010_0_111_0_101 |
| AB | 0_1010_0_101_1_111 |
| BA | 0_1011_1_101_1_001 |
| AA | 1_1010_0_101_1_000 |
| 11 | 0_0001_1_000_0_110 |
| 82 | 0_1000_1_001_0_001 |

### Observations
- All outputs are stable and deterministic  
- No X or Z values observed  
- Parity bits vary correctly across patterns  
- Bit grouping confirms correct placement  

### Result
**PASS**

### Implementation Notes
- Testbench: `hamming_encoder_tb.sv`
- Readable grouped `$display` formatting
- Waveform dump: `hamming_encoder.vcd`

---

## 4.2 Exhaustive Encode–Decode Test (Golden Path)

### Status
**PASS**

### Objective
Verify that the encoder–decoder pair forms an identity mapping for all valid inputs when no errors are present.

### Design Under Test
- **Encoder**: `hamming_encoder`
- **Decoder**: `hamming_decoder`
- **Code Type**: (13,8) SECDED
- **Mode**: No error injection

### Test Method
- Apply all 256 possible 8-bit inputs (0x00–0xFF)
- Feed encoder output directly to decoder
- Allow combinational logic to settle

### Checks per Vector
- `data_out == data_in`
- `error == 0`

### Test Conditions
- Simulator: Icarus Verilog
- Timescale: 1 ns / 1 ps
- Settle delay: 1 ns
- Clocking: None (pure combinational)

### Results

| Metric | Value |
|------|-------|
| Total vectors tested | 256 |
| Decode mismatches | 0 |
| False error flags | 0 |

### Simulation Output
