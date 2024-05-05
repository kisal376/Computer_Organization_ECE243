.define LED_ADDRESS 0x1000
.define SW_ADDRESS 0x3000

// Read SW switches and display on LEDs
        mvt   r3, #LED_ADDRESS        // point to LED port
        mvt   r4, #SW_ADDRESS         // point to SW port
MAIN:   ld    r0, [r4]                // read SW values
        sub   r2, r0
        bne   LDDOWNCOUNTER
        add   r5, #0
        beq   ENUPCOUNTER
        sub   r5, #1
        b     MAIN
LDDOWNCOUNTER: mv r5, r0
        mv    r2, r0
        add   r5, #0
        beq   ENUPCOUNTER
        sub   r5, #1
        b     MAIN
ENUPCOUNTER: add  r6, #1
        st    r6, [r3]                // light up LEDs
        mv    r5, r0
        b     MAIN
