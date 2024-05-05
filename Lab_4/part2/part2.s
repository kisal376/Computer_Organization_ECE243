/* Program that counts consecutive 1's */

          .text                   // executable code follows
          .global _start
_start:
          MOV     R3, #TEST_NUM   // load the data word ...
		  SUB	  R3, #4
NEXT:     LDR     R1, [R3, #4]!    // into R1
		  CMP     R1, #0          // Check if the entered number is 0 or not
          BNE     ONES
END:      B       END

ONES:     MOV     R0, #0          // R0 will hold the result
LOOP:     CMP     R1, #0          // loop until the data contains no more 1's
          BEQ     NEXT
          LSR     R2, R1, #1      // perform SHIFT, followed by AND
          AND     R1, R1, R2
          ADD     R0, #1          // count the string length so far
          B       LOOP


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
