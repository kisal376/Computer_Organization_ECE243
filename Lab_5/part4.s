/* Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
 *    Parameters: R0 = the decimal value of the digit to be displayed
 *    Returns: R0 = bit patterm to be written to the HEX display
 */

SEG7_CODE:  PUSH	{R1}
			MOV     R1, #BIT_CODES  
            ADD     R1, R0         // index into the BIT_CODES "array"
            LDRB    R0, [R1]       // load the bit pattern (to be returned)
			POP		{R1}
            MOV     PC, LR              

BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111
            .skip   2      // pad with 2 bytes to maintain word alignment

/* Program that counts consecutive 1's */

          .text                   // executable code follows
          .global _start
		  .equ KEY_BASE , 0xFF200050
		  .equ HEX_BASE_0TO3 , 0xFF200020
		  .equ TIMER_BASE , 0xFFFEC600
		  .equ LOAD, 2000000
		  
_start:		LDR		R12, =KEY_BASE
			LDR		R11, =HEX_BASE_0TO3
			LDR		R10, =TIMER_BASE
			LDR		R9, =LOAD
			MOV		R8, #0b011
			STR		R9, [R10]
			STR		R8, [R10, #0X8]
			MOV		R2, #0	
			MOV		R3, #0
			MOV		R4, #0
			STR		R2, [R11]

POLL:		LDR		R1, [R12, #0XC]
			ANDS	R1, #0b01
			BNE		KEY0_PRESS
			LDR		R1, [R12, #0XC]
			ANDS	R1, #0b010
			BNE		KEY1_PRESS
			LDR		R1, [R12, #0XC]
			ANDS	R1, #0b0100
			BNE		KEY2_PRESS
			LDR		R1, [R12, #0XC]
			ANDS	R1, #0b01000
			BNE		KEY3_PRESS
			LDR		R1, [R10, #0XC]
			ANDS	R1, #0b01
			BNE		TIMER_DONE
			B		POLL

KEY0_PRESS:	MOV		R0, #0b01
			STR		R0, [R12, #0XC]
			EOR		R2, #1
			B		POLL
			
KEY1_PRESS:	MOV		R0, #0b010
			STR		R0, [R12, #0XC]
			EOR		R2, #1
			B		POLL
			
KEY2_PRESS:	MOV		R0, #0b0100
			STR		R0, [R12, #0XC]
			EOR		R2, #1
			B		POLL
			
KEY3_PRESS:	MOV		R0, #0b01000
			STR		R0, [R12, #0XC]
			EOR		R2, #1
			B		POLL
			
TIMER_DONE:	MOV		R0, #0b01
			STR		R0, [R10, #0XC]
			CMP 	R2, #1
			BEQ		COUNTER
			B		POLL

COUNTER:	CMP		R3, #99
			MOVEQ	R3, #0
			ADDNE	R3, #1
			ADDEQ	R4, #1
			CMP		R4, #59
			MOVEQ	R4, #0
			MOV		R0, R3
			PUSH 	{R2}
			BL		DIVIDE
			BL		SEG7_CODE
			MOV		R2, R0
			MOV		R0,	R1
			BL		SEG7_CODE
			LSL		R0, #8
			ORR		R2, R0, R2
			PUSH	{R2}
			MOV		R0, R4
			BL		DIVIDE
			BL		SEG7_CODE
			MOV		R2, R0
			MOV		R0,	R1
			BL		SEG7_CODE
			LSL		R0, #8
			ORR		R2, R0, R2
			LSL		R2, #16
			POP		{R0}
			ORR		R0, R0, R2			
			STR		R0, [R11]
			POP		{R2}
			B		POLL
			
DIVIDE:     PUSH   	{R2}
			MOV     R2, #0
CONT:       CMP     R0, #10
            BLT     DIV_END
            SUB     R0, #10
            ADD     R2, #1
            B       CONT
DIV_END:    MOV     R1, R2// quotient in R1 (remainder in R0)
			POP 	{R2}
            MOV     PC, LR



.end
