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
END:      B       END

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
