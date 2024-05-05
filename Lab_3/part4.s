/* Program that converts a binary number to decimal */
           
           .text               // executable code follows
           .global _start
_start:
            MOV    R4, #N
            MOV    R5, #Digits  // R5 points to the decimal digits storage location
            LDR    R4, [R4]     // R4 holds N
            MOV    R0, R4       // parameter for DIVIDE goes in R0
            BL     DIVIDE
			STRB   R9, [R5, #3]	//Thousands digit is now in R9
			STRB   R8, [R5, #2]	//Hundreds digit is now in R8
            STRB   R7, [R5, #1] // Tens digit is now in R7
            STRB   R0, [R5]     // Ones digit is in R0
END:        B      END

/* Subroutine to perform the integer division R0 / 10.
 * Returns: quotient in R1, and remainder in R0 */
DIVIDE:     MOV    R7, #0	//store tens digit
			MOV	   R8, #0	//store hundreds digit
			MOV	   R9, #0	//store thousands digit
CONT:       CMP    R0, #1000	//checking if number is less than 1000
			BLT	   DIV_HUN		//if less than 1000 go to DIV_HUN
			SUB	   R0, #1000
			ADD    R9, #1		//incrementing thousands digit
			B	   CONT			//return to the top
DIV_HUN:	CMP    R0, #100		//checking is number is less than 100
			BLT	   DIV_TEN		//if less than 100 go to DIV_TEN
			SUB	   R0, #100
			ADD    R8, #1		//incrementing hundreds digit
			B	   CONT			//return to the top
DIV_TEN:	CMP	   R0, #10		//checking if number is less than 10
            BLT    DIV_END		//if less than 10 go to DIN_END
            SUB    R0, #10
            ADD    R7, #1		//incrementing tens digit
            B      CONT			//return to top
DIV_END:	MOV    PC, LR		//return to main

N:          .word  4176         // the decimal number to be converted
Digits:     .space 4          // storage space for the decimal digits

            .end
