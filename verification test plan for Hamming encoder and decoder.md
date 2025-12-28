verification test plan for Hamming encoder and decoder

->(13,8) Hamming Encoder \& Decoder with Overall Parity

Scope: Functional correctness, error detection, error correction

Out of scope: Timing closure, physical implementation, soft-error rate modeling



**1. Verification Objectives (what “done” means)**



The design shall:

Correctly encode all 8-bit input data into a 13-bit Hamming code.

Correctly decode valid codewords with no error.

Correctly detect and correct any single-bit error.

Correctly detect but not correct double-bit errors.

Correctly flag errors using the error signal.

Never corrupt data silently.

If any silent corruption occurs → verification fails.



**2. Design Interfaces Under Test**

Encoder

Inputs: data\_in\[7:0]

Outputs: code\_out\[12:0]



Decoder

Inputs: hamming\_bits\[12:0]

Outputs:data\_out\[7:0]

error (error indication)



**3. Testbench Strategy**

**Self-checking testbench**

**Golden reference model** implemented in SystemVerilog/Python-like logic 

No manual waveform inspection required to declare pass/fail

Exhaustive testing where feasible



**4. Test Categories \& Test Cases**



&nbsp;	**4.1 Sanity \& Bring-up Tests**

&nbsp;	Purpose: Ensure basic connectivity and logic sanity.

&nbsp;	

&nbsp;	Tests:

&nbsp;	Apply data\_in = 8'h00

&nbsp;	Apply data\_in = 8'hFF

&nbsp;	Apply alternating patterns (8'hAA, 8'h55)



&nbsp;	Expected:

&nbsp;	Encoder produces deterministic output

&nbsp;	Decoder returns original data

&nbsp;	error = 0



&nbsp;	Pass criteria:

&nbsp;	No X/Z values

&nbsp;	No mismatches



&nbsp;	**4.2 Exhaustive Encode–Decode Test (Golden Path)**

	Purpose: Prove correctness without errors.



&nbsp;	Tests:

&nbsp;	Loop data\_in from 0x00 to 0xFF (256 cases)

&nbsp;	Encode → Decode without modifying codeword



&nbsp;	Expected:

&nbsp;	data\_out == data\_in

&nbsp;	error == 0

&nbsp;	Coverage:

&nbsp;	100% input space

&nbsp;	All parity combinations exercised



&nbsp;	**4.3 Single-Bit Error Injection (Correction Test)**



&nbsp;	Purpose: Validate correction logic.



&nbsp;	Tests:

&nbsp;	For each data\_in (0–255):

&nbsp;	Encode to code\_out

&nbsp;	Flip one bit at a time (positions 0–12)

&nbsp;	Feed corrupted codeword to decoder

&nbsp;	Total cases: **256 × 13 = 3328 tests**



&nbsp;	Expected:

&nbsp;	data\_out == original data\_in

&nbsp;	error == 1



&nbsp;	***Special cases:***

&nbsp;	Flip parity bits

&nbsp;	Flip data bits

&nbsp;	Flip overall parity bit



&nbsp;	***Pass criteria:***

&nbsp;	All single-bit errors corrected

&nbsp;	No false negatives



	**4.4 Double-Bit Error Detection Test**

&nbsp;	Purpose: Ensure no silent corruption.

&nbsp;	

&nbsp;	Tests:

&nbsp;	For selected data\_in values:

&nbsp;	Flip two bits simultaneously

&nbsp;	Feed to decoder



	***Expected:***

&nbsp;	error == 1

&nbsp;	data\_out may be incorrect (acceptable)

&nbsp;	Must not falsely claim “no error”



&nbsp;	Pass criteria:

&nbsp;	No double-bit error passes as clean

&nbsp;	This is critical. Silent failure = design failure



	**4.5 Parity-Only Error Test**

&nbsp;	Purpose: Validate overall parity handling.



&nbsp;	Tests:

&nbsp;	Flip only p0

&nbsp;	No other bits flipped

&nbsp;	

&nbsp;	Expected:

&nbsp;	error == 1

&nbsp;	data\_out == original

&nbsp;	This verifies your SECDED behavior.



	**4.6 Stability / Glitch Test**

&nbsp;	Purpose: Catch unintended latches or sensitivity bugs.

&nbsp;	Tests:

&nbsp;	Randomly toggle inputs

&nbsp;	Hold inputs stable for multiple cycles



&nbsp;	Expected:

&nbsp;	Outputs change only as function of inputs

&nbsp;	No memory behavior

&nbsp;	No latching



**5. Assertions (must-haves)**

	Add SystemVerilog assertions such as:

&nbsp;	No silent failure-	

&nbsp;	**if (error == 0) assert(data\_out == expected\_data);**



&nbsp;	Correction guarantee-

	**single\_bit\_error |-> data\_out == expected\_data;**

Assertions turn bugs into immediate failures, not waveform archaeology.



**Functional coverage:**



All 256 input values

All 13 single-bit positions

Parity-bit-only errors

Data-bit errors

Double-bit error scenarios



**Coverage exit criteria:**



100% encoder input coverage

100% single-bit error position coverage

All error classes exercised



**7. Non-goals (explicitly stated)**

This test plan does not:

Prove MTBF

Model radiation effects

Verify physical placement

Guarantee timing closure



**8. Deliverables**

Self-checking testbench

Simulation log with pass/fail summary

Coverage report

Known limitations documented





