// Store symbols to RAM
MOV R0, #10			// -|
MOV 0, R0			// Store in RAM
MOV R0, #11			// |-
MOV 1, R0			// Store in RAM
MOV R0, #12			// -
MOV 2, R0 			// Store in RAM
MOV R0, #13			// =
MOV 3, R0 			// Store in RAM
MOV R0, #14		    // OFF
MOV 4, R0 			// Store in RAM

// Initialize value for operator 1, 2
START: MOV R0, #0
MOV 5, R0 	// ones of op1
MOV 6, R0 			// tens of op1
MOV 7, R0  			// sign of op1
MOV 8, R0 			// ones of op2
MOV 9, R0  			// tens of op2
MOV 10, R0 			// sign of op2

// Setup ones and tens (not necessary)
JZ S0, SETUP_ONES
MOV R5, #1
MOV R6, #0
JMP TEN_SET 
SETUP_ONES: MOV R5, #0
MOV R6, #1
TEN_SET: JZ S1, SETUP_TENS
MOV R7, #1
MOV R8, #0
JMP TBD
SETUP_TENS: MOV R7, #0
MOV R8, #1

MOV R3, #1		// Same as below
MOV R4, #0		// Sign of OP1, 2 auxiliary

// Input Loop
TBD: JZ S7, EQUAL 			// Evaluate switch, jump to eval loop
JZ S4, MINUS   				// Operator switch
MOV R0, 0 					// Get + symbol
MOV R1, 1
JMP SHOW_OPERATOR
MINUS: MOV R0, 2 			// Get - symbol
MOV R1, 2
SHOW_OPERATOR: 7SEG 7, R0 	// Show the operator
7SEG 6, R1

JZ S3, OP1 					// Operand selector switch
MOV R10, 8
MOV R11, 9
MOV R12, 10
MOV R13, #1
JMP CH_INC
OP1: MOV R10, 5
MOV R11, 6
MOV R12, 7
MOV R13, #0


CH_INC: JZ S0, ONES_0 		// Ones increase switch
ADD R10, R6
MOV R5, #1
MOV R6, #0
JMP ONES_SHOW
ONES_0: ADD R10, R5
MOV R5, #0
MOV R6, #1
ONES_SHOW: MOV R0, #10
SUB R0, R10
JZ R0, O_10
JMP ONES_OUT
O_10: MOV R10, #0
ONES_OUT: 7SEG 0, R10

JZ S1, TENS_0  				// Tens increase switch
ADD R11, R8
MOV R7, #1
MOV R8, #0
JMP TENS_SHOW
TENS_0: ADD R11, R7
MOV R7, #0
MOV R8, #1
TENS_SHOW: MOV R0, #10
SUB R0, R11
JZ R0, T_10
JMP TENS_OUT
T_10: MOV R11, #0
TENS_OUT: 7SEG 1, R11

JZ S2, SIGN_CH  			// Operand sign switch
ADD R12, R3
MOV R3, #0
MOV R4, #1
JMP OP_SIGN
SIGN_CH: ADD R12, R4
MOV R3, #1
MOV R4, #0

OP_SIGN: MOV R0, #1
AND R12, R0 		 	// R12 &= 1, suppress all bits except bit 0
JZ R12, OP_MINUS
MOV R0, 0
MOV R1, 1
JMP OP_S_SHOW
OP_MINUS: MOV R0, 2
MOV R1, 2
OP_S_SHOW: 7SEG 3, R0
7SEG 2, R1

// Store back to RAM
JZ R13, OP1_STORE
MOV 8, R10
MOV 9, R11
MOV 10, R12
MOV R1, #2
JMP OP_NUM
OP1_STORE: MOV 5, R10
MOV 6, R11
MOV 7, R12
MOV R1, #1

OP_NUM: MOV R0, #0
7SEG 5, R0
7SEG 4, R1

JMP TBD  			// End of Input Loop

// Evaluate loop

// Show equal sign '=='
EQUAL: MOV R0, 3
7SEG 7, R0
7SEG 6, R0
MOV R0, 4 
7SEG 3, R0		// Turn off LED 3

// Get OP1
MOV R3, #1
MOV R4, 5
MOV R0, #0
LP_O1: JZ R4, EXIT_O1
ADD R0, R3 	          	// Add ones to R0
SUB R4, R3
JMP LP_O1

EXIT_O1:MOV R3, #10
MOV R5, #1
MOV R4, 6
LP_T1: JZ R4, EXIT_T1
ADD R0, R3 				// Add tens to R0
SUB R4, R5
JMP LP_T1

// Check sign of OP1
EXIT_T1: MOV R3, 7
JZ R3, INV_1			// Jump if OP1 < 0
MOV 20, R0
JMP AF_INV_1
INV_1: MOV R1, #0
SUB R1, R0
MOV 20, R1
AF_INV_1: MOV R11, 20

// Convert OP2
MOV R3, #1
MOV R4, 8
MOV R0, #0
LP_O2: JZ R4, EXIT_O2
ADD R0, R3 				// Add ones to R0
SUB R4, R3
JMP LP_O2

EXIT_O2:MOV R3, #10
MOV R5, #1
MOV R4, 9
LP_T2: JZ R4, EXIT_T2
ADD R0, R3 				// Add tens to R0
SUB R4, R5
JMP LP_T2

// Check sign of OP2
EXIT_T2: MOV R3, 10
JZ R3, INV_2			// Jump if OP2 < 0
MOV 20, R0
JMP AF_INV_2
INV_2: MOV R1, #0
SUB R1, R0
MOV 20, R1
AF_INV_2: MOV R12, 20

// Perform arithmetic
JZ S4, SUBTRACT
ADD R11, R12
JMP RENDER // test, RENDER
SUBTRACT: SUB R11, R12

// Get Sign of result
RENDER: BGTZ R11, POSI
JZ R11, POSI
MOV R0, 2
MOV R1, 2
MOV R12, #0					// Get the absolute
SUB R12, R11
MOV 11, R12
MOV R11, 11
JMP SHOW_RES_SIGN
POSI: MOV R0, 0
MOV R1, 1
SHOW_RES_SIGN: 7SEG 5, R0
7SEG 4, R1

// Get Hundreds of result
MOV R0, #100
SUB R0, R11
BGTZ R0, HUNDREDS_ZERO
MOV R1, #1
MOV R0, #100
SUB R11, R0
JMP SHOW_HUNDREDS
HUNDREDS_ZERO: MOV R1, #0
SHOW_HUNDREDS: 7SEG 2, R1

// Get Tens of result
MOV R0, #0
MOV R1, #10
MOV R2, #10
MOV R4, #1
FIND_TENS: MOV 11, R1
MOV R3, 11
SUB R3, R11
BGTZ R3, TEN_STOP
ADD R1, R2
ADD R0, R4
JMP FIND_TENS
TEN_STOP: 7SEG 1, R0
SUB R1, R2
SUB R11, R1

// Get Ones of result
7SEG 0, R11

HERE: JZ S7, HERE
JMP START