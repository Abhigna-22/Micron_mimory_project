# Verification Report – (13,8) Hamming Encoder (SECDED)

This document presents the functional verification results for a **(13,8) Hamming Encoder with overall parity**, implementing **SECDED (Single Error Correction, Double Error Detection)**.  
The design is purely combinational and has been verified using exhaustive simulation and fault injection techniques.

---

## 1. Design Under Test

- **Module**: `hamming_encoder`
- **Function**: (13,8) Hamming code generation with overall parity
- **ECC Type**: SECDED
- **Logic Type**: Pure combinational logic

---

## 2. Verification Goals

- Validate correct parity bit generation  
- Validate correct placement of data and parity bits  
- Ensure stable, deterministic, X-free outputs  
- Verify correct behavior under single-bit and double-bit error conditions  

---

## 3. Test Summary

| Test ID | Test Name                  | Description                                | Status |
|-------:|----------------------------|--------------------------------------------|--------|
| 4.1    | Sanity & Bring-up          | Basic vectors and visual inspection        | PASS   |
| 4.2    | Exhaustive Encode–Decode   | All 256 input combinations                 | PASS   |
| 4.3    | Single-Bit Error Injection | Correction of all 13 bit positions         | PASS   |
| 4.4    | Double-Bit Error Detection | Detection without correction (DED)         | PASS   |

---

## 4.1 Sanity & Bring-up Test

### Objective
Verify basic encoder functionality using representative input patterns and confirm stable, X-free outputs.

### Test Method
- Apply selected 8-bit input vectors  
- Allow combinational logic to settle  
- Display encoded output using grouped bit formatting  

### Test Vectors

| Input (Hex) | Encoded Output (Grouped) |
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
- Parity bits vary correctly across input patterns  
- Grouped formatting confirms correct bit placement  

### Result
**PASS**

### Implementation Notes
- Testbench: `hamming_encoder_tb.sv`
- Grouped `$display` formatting used for readability
- Waveform dump generated: `hamming_encoder.vcd`

---

## 4.2 Exhaustive Encode–Decode Test (Golden Path)

### Status
**PASS**

### Objective
Verify that the encoder and decoder together form a correct identity mapping for all valid inputs when no bit errors are present.

### Design Under Test
- **Encoder**: `hamming_encoder`
- **Decoder**: `hamming_decoder`
- **Code Type**: (13,8) Hamming code with overall parity (SECDED)
- **Operation Mode**: No error injection (clean codewords)

### Test Method
- Apply all possible 8-bit inputs (0x00–0xFF) to the encoder  
- Feed the encoder output directly into the decoder  
- Allow combinational logic to settle before observation  

### Checks per Input
- Decoded output matches original input  
- Decoder error flag remains deasserted  
- Testbench is fully self-checking and halts on first failure  

### Test Conditions
- Simulator: Icarus Verilog  
- Timescale: 1 ns / 1 ps  
- Settle delay: 1 ns  
- Clocking: None (pure combinational path)  

### Pass Criteria
For every input value:
data_out == data_in
error == 0


### Results

| Metric | Value |
|------|-------|
| Total input vectors tested | 256 |
| Decode mismatches | 0 |
| False error flags | 0 |

### Simulation Output
Starting 4.2 Exhaustive Encode–Decode Test
PASS: 4.2 Exhaustive Encode–Decode Test

---

## 4.3 Single-Bit Error Injection Test (SEC)

### Status
**PASS**

### Summary
- Single-bit errors injected at all 13 codeword bit positions  
- Error flag asserted for all injected cases  
- Correct data recovery verified for all cases  
- No missed detections or correction failures  

### Coverage
- **256 inputs × 13 bit positions = 3328 test cases**

---

## 4.4 Double-Bit Error Detection Test (DED)

### Status
**PASS**

### Objective
Verify that all double-bit errors are reliably detected and that no correction is performed, preventing silent data corruption.

### Design Under Test
- **Encoder**: `hamming_encoder`
- **Decoder**: `hamming_decoder`
- **Code Type**: (13,8) Hamming code with overall parity (SECDED)
- **Operation Mode**: Double-bit error injection

### Test Method
1. Generate a valid codeword using the encoder  
2. Flip two distinct bits in the 13-bit encoded output  
3. Apply the corrupted codeword to the decoder  

### Error Injection Strategy
```verilog
corrupted_code = code_out ^ ((1 << bit_pos1) | (1 << bit_pos2));
```

### Bit Constraints
0 ≤ bit_pos1 < bit_pos2 < 13
Ensures exactly two flipped bits
No overlap with single-bit error cases


### Checks per Case
Decoder asserts the error flag
Decoder does not attempt correction
Output must not be trusted
No silent data correction allowed


### Test Conditions

Simulator: Icarus Verilog
Timescale: 1 ns / 1 ps
Settle delay: 1 ns
Clocking: None (pure combinational logic)


### Results
Metric	Value
Codeword bits	13
Double-bit combinations per input	C(13,2) = 78
Total input values tested	256
Total double-bit error cases	19,968
Missed detections	0
Silent corrections	0

### Simulation Output
```
Starting 4.4 Double-Bit Error Detection Test
PASS: 4.4 Double-Bit Error Detection Test
```
### Observations
All injected double-bit errors were detected
No correction was applied in any double-bit scenario
Syndrome aliasing cases correctly blocked correction
Error detection safely dominates over correction logic
No silent data corruption observed

### Conclusion

The verification confirms that the (13,8) Hamming SECDED implementation is functionally correct and robust.
Single-bit errors are always corrected, double-bit errors are always detected, and silent data corruption is fully prevented.
This completes full functional verification of the ECC design.



