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
		  .equ KEY_BASE , 0xFF200050
		  .equ HEX_BASE_0TO3 , 0xFF200020
		  
_start:		LDR		R12, =KEY_BASE
			LDR		R11, =HEX_BASE_0TO3

POLL:		LDR		R1, [R12]
			ANDS	R1, #0b01
			BNE		KEY0_PRESS
			LDR		R1, [R12]
			ANDS	R1, #0b010
			BNE		KEY1_PRESS
			LDR		R1, [R12]
			ANDS	R1, #0b0100
			BNE		KEY2_PRESS
			LDR		R1, [R12]
			ANDS	R1, #0b01000
			BNE		KEY3_PRESS
			B		POLL

KEY0_PRESS:	BL		RELEASE0
			MOV		R0, #0
			MOV		R3,	#0
			BL		SEG7_CODE
			STR		R0, [R11]
			B		POLL
			
KEY1_PRESS:	BL		RELEASE1
			CMP		R3, #9
			ADDNE	R3, #1
			MOV		R0, R3
			LDR		R1, [R11]
			CMP		R1, #0
			MOVEQ	R0, #0
			CMP		R1, #0
			MOVEQ	R3, #0
			BL		SEG7_CODE
			STR		R0, [R11]
			B		POLL
			
KEY2_PRESS:	BL		RELEASE2
			CMP		R3, #0
			SUBNE	R3, #1
			MOV		R0, R3
			LDR		R1, [R11]
			CMP		R1, #0
			MOVEQ	R0, #0
			CMP		R1, #0
			MOVEQ	R3, #0
			BL		SEG7_CODE
			STR		R0, [R11]
			B		POLL
			
KEY3_PRESS:	BL		RELEASE3
			MOV		R0, #0
			STR		R0, [R11]
			B		POLL

RELEASE0:	LDR		R1, [R12]
			ANDS	R1, #0b01
			MOVEQ	PC, LR
			B		RELEASE0
			
RELEASE1:	LDR		R1, [R12]
			ANDS	R1, #0b010
			MOVEQ	PC, LR
			B		RELEASE1
			
RELEASE2:	LDR		R1, [R12]
			ANDS	R1, #0b0100
			MOVEQ	PC, LR
			B		RELEASE2
			
RELEASE3:	LDR		R1, [R12]
			ANDS	R1, #0b01000
			MOVEQ	PC, LR
			B		RELEASE3

		  
/* Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4 */
//DISPLAY:    LDR     R2, =HEX_BASE_0TO3 // base address of HEX3-HEX0
            
//END:        B       END


.end
