# Verification Report – (13,8) Hamming Encoder

## Design Under Test
- Module: hamming_encoder
- Function: (13,8) Hamming code generation with overall parity
- Type: Pure combinational logic

## Verification Goals
- Validate correct parity generation
- Validate correct bit placement
- Ensure no uninitialized or unstable outputs

## Test Summary

| Test ID| Test Name                | Description                              | Status |
|-------:|--------------------------|------------------------------------------|--------|
| 4.1    | Sanity & Bring-up        | Basic vectors and visual inspection      | PASS   |
| 4.2    | Exhaustive Encode-Decode | All 256 input combinations               | PASS   |
| 4.3    | Single-Bit Error Inject  | Correction of all 13 bit positions       | PASS   |
| 4.4    | Double-Bit Error Detect  | Detection without correction             | PASS   |

****************************************************************************************************************************
## 4.1 Sanity & Bring-up Test
****************************************************************************************************************************
### Objective
Verify basic functionality of the encoder for representative input patterns and ensure stable, X-free outputs.

### Test Method
- Apply selected input vectors
- Allow combinational logic to settle
- Display encoded output with grouped bit formatting

### Test Vectors

| Input (hex) | Encoded Output (grouped) |
|-------------|--------------------------|
| 00          | 0_0000_0_000_0_000        |
| FF          | 0_1111_0_111_0_111        |
| AF          | 1_1010_0_111_0_101        |
| AB          | 0_1010_0_101_1_111        |
| BA          | 0_1011_1_101_1_001        |
| AA          | 1_1010_0_101_1_000        |
| 11          | 0_0001_1_000_0_110        |
| 82          | 0_1000_1_001_0_001        |

### Observations
- All outputs are stable and deterministic
- No X or Z values observed
- Parity bits vary as expected across input patterns
- Bit grouping confirms correct placement of parity and data bits

### Result
PASS

### Implementation Notes
- Testbench: hamming_encoder_tb.sv
- Output formatting uses grouped $display for readability
- Waveform dump generated: hamming_encoder.vcd

### Evidence
- Simulation completed without errors
- Representative outputs shown above
- Full waveform available in VCD file


****************************************************************************************************************************
## 4.2 Exhaustive Encode–Decode Test (Golden Path)

Status: PASS

Objective

To verify that the Hamming encoder and decoder together form a correct identity mapping for all valid inputs, ensuring that encoded data can be decoded back to the original value without any error indication, when no bit errors are present.

Design Under Test
Encoder: hamming_encoder
Decoder: hamming_decoder
Code Type: (13,8) Hamming code with overall parity (SECDED)
Operation Mode: No error injection (clean codewords)

Test Method

Apply all possible 8-bit input values (0x00 to 0xFF) to the encoder.
Feed the encoder output directly into the decoder.
Allow combinational logic to settle before sampling outputs.

For each input vector, check:
The decoded output matches the original input.
The decoder error flag remains deasserted.
The testbench is self-checking and terminates immediately upon the first failure.

Test Conditions
Simulation Tool: Icarus Verilog
Timescale: 1 ns / 1 ps
Delay for settle: 1 ns between stimulus and observation
Clocking: None (pure combinational path)

Pass Criteria
For every input value in the range 0x00–0xFF:
data_out == data_in
error == 0

RESULT
Metric				Value
Total input vectors tested	256
Decode mismatches		0
False error flags		0

SIMULATION OUTPUT
Starting 4.2 Exhaustive Encode–Decode Test
PASS: 4.2 Exhaustive Encode–Decode Test
****************************************************************************************************************************

## 4.3 Single-Bit Error Injection (Correction Test)

Status: PASS

Summary:
- Injected single-bit errors at all 13 bit positions
- Verified error flag assertion for all cases
- Verified correct data recovery for all cases
- No correction failures or missed detections observed

Total correction cases tested:
- 256 inputs × 13 bit positions = 3328 case
****************************************************************************************************************************
4.4 Double-Bit Error Detection Test (DED)
Objective
To verify that the Hamming decoder reliably detects all double-bit errors in the encoded codeword and does not perform any correction, thereby preventing silent data corruption.
This test validates the DED (Double Error Detection) property of the SECDED implementation.

Design Under Test
Encoder: hamming_encoder
Decoder: hamming_decoder
Code Type: (13,8) Hamming code with overall parity (SECDED)
Operation Mode: Double-bit error injection

Test Method
Generate a valid Hamming codeword using the encoder for a given 8-bit input.
Inject a double-bit error by flipping two distinct bits in the 13-bit encoded output.
Apply the corrupted codeword to the decoder.

Repeat the test for:
All valid 8-bit input values
All unique pairs of bit positions in the 13-bit codeword

For each injected double-bit error, check:
The decoder asserts the error flag.
The decoder does not attempt correction.
The decoded output is not trusted (i.e., must not silently match the original input).
The testbench is fully self-checking and halts immediately upon detecting any violation.

Error Injection Strategy
Two distinct bit positions (bit_pos1, bit_pos2) are flipped using:
corrupted_code = code_out ^ ((1 << bit_pos1) | (1 << bit_pos2))


Bit position constraints:
0 ≤ bit_pos1 < bit_pos2 < 13

This ensures:
Exactly two bits are flipped
No overlap with single-bit error cases

Test Conditions
Simulation Tool: Icarus Verilog
Timescale: 1 ns / 1 ps
Delay for settle: 1 ns after error injection
Clocking: None (pure combinational logic)

Pass Criteria

For every tested input and every double-bit error combination:
error == 1
Decoder does not perform correction
Decoder output must not be assumed correct
No silent data correction is allowed
Any case where the decoder outputs the original data after a double-bit error is considered a test failure, even if the error flag is asserted.

Results-
Metric						Value
Codeword bits					13
Double-bit combinations per input		C(13,2) = 78
Total input values tested			256
Total double-bit error cases			19,968
Missed error detections				0
Silent corrections observed			0


Simulation output confirms successful completion:

Starting 4.4 Double-Bit Error Detection Test
PASS: 4.4 Double-Bit Error Detection Test

Result
PASS

Observations

All injected double-bit errors were detected.
No correction was applied for any double-bit error case.
Syndrome aliasing cases were correctly handled by blocking correction.
The decoder correctly prioritizes error detection over accidental correction.
No silent data corruption was observed.

Conclusion

The double-bit error detection test confirms that the Hamming decoder correctly implements the DED requirement of SECDED. All double-bit errors are reliably detected, and the decoder safely refrains from performing correction when error certainty is lost. This ensures robust protection against silent data corruption and completes full functional verification of the ECC design.
*****************************************************************************************************************************