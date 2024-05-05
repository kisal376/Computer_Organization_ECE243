/* Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
 *    Parameters: R0 = the decimal value of the digit to be displayed
 *    Returns: R0 = bit patterm to be written to the HEX display
 */

SEG7_CODE:  MOV     R1, #BIT_CODES  
            ADD     R1, R0         // index into the BIT_CODES "array"
            LDRB    R0, [R1]       // load the bit pattern (to be returned)
            MOV     PC, LR              

BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2      // pad with 2 bytes to maintain word alignment

/* Program that counts consecutive 1's */

          .text                   // executable code follows
          .global _start
_start:
		  MOV 	  R0, #0
		  PUSH	  {R0}
		  PUSH	  {R0}
		  PUSH	  {R0}
          MOV     R3, #TEST_NUM   // load the data word ...
		  SUB	  R3, #4
NEXT:     LDR     R1, [R3, #4]!   // into R1
		  POP	  {R7}
		  CMP	  R7, #0xffffffff
		  ADDNE	  R7, #1
		  POP	  {R6}
		  POP	  {R5}
		  MOV	  R12, #0
		  CMP	  R5, R8
		  MOVHI	  R8, R5
		  CMP	  R6, R9
		  MOVHI	  R9, R6
		  CMP	  R7, R10
		  MOVHI	  R10, R7
		  CMP     R1, #0          // Check if the entered number is 0 or not
          BNE     ONES
	      B       DISPLAY

ONES:     MOV     R0, #0          // R5 will hold the result
		  MOV	  R4, R1		  // Prevent number from changing
LOOPONE:  CMP     R4, #0          // loop until the data contains no more 1's
		  PUSHEQ  {R0}
          BEQ     ZEROS
          LSR     R2, R4, #1      // perform SHIFT, followed by AND
          AND     R4, R4, R2
          ADD     R0, #1          // count the string length so far
          B       LOOPONE

ZEROS:    MOV     R0, #0          // R6 will hold the result
		  CMP	  R12, #0
		  BNE	  NEXT
		  MOV	  R4, R1		  // Prevent number from changing
LOOPZERO: CMP     R4, #0xffffffff // loop until the data contains no more 0's
		  PUSHEQ  {R0}
          BEQ     ALTERNATE
          LSL     R2, R4, #1      // perform SHIFT, followed by OR
		  ADD	  R2, #1
          ORR     R4, R4, R2
          ADD     R0, #1          // count the string length so far
          B       LOOPZERO

ALTERNATE:ASR     R2, R1, #1      // perform SHIFT, followed by OR
          EOR     R1, R1, R2
		  MOV	  R12, #1
		  B		  ONES


/* Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4 */
DISPLAY:    LDR     R8, =0xFF200020 // base address of HEX3-HEX0
            MOV     R0, R5          // display R5 on HEX1-0
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            MOV     R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R0, #8
            ORR     R4, R0
			
            MOV     R0, R6          // display R5 on HEX1-0
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            LSL     R0, #16
            ORR     R4, R0
            MOV     R0, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R0, #24
            ORR     R4, R0

            STR     R4, [R8]        // display the numbers from R6 and R5
            LDR     R8, =0xFF200030 // base address of HEX5-HEX4
            MOV     R0, R7          // display R5 on HEX1-0
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            MOV     R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R0, #8
            ORR     R4, R0
            STR     R4, [R8]        // display the number from R7
END:        B       END


DIVIDE:     MOV    R2, #0
CONT:       CMP    R0, #10
            BLT    DIV_END
            SUB    R0, #10
            ADD    R2, #1
            B      CONT
DIV_END:    MOV    R1, R2     // quotient in R1 (remainder in R0)
            MOV    PC, LR
		  
TEST_NUM: .word   0x103fe00f // 9
		  .word   0xffffffff // 32
		  .word   0x01010101 // 1
		  .word   0xfffffffe // 31
		  .word   0x02020202 // 1
		  .word   0x03030303 // 2
		  .word   0xf3f00000 // 6
		  .word   0x7fffffff // 31
		  .word   0x00000000 // 0
		  

          .end
