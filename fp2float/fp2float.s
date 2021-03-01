// Describe the Hardware to the assembler
        .arch   armv6
        .cpu    cortex-a53
        .syntax unified

        .text                       // start of the text segment

        /////////////////////////////////////////////////////////
        // function FP2float
        /////////////////////////////////////////////////////////

        .type   FP2float, %function // define as a function
        .global FP2float            // export function name
        .equ    FP_OFF_FP2, 28      // (regs - 1) * 4

FP2float:
        push    {r4-r9, fp, lr}     // use r4-r9 for variables
        add     fp, sp, FP_OFF_FP2  // locate our frame pointer
        
        /////////////////////////////////////////////////////////
        // do not edit anything in this function above this line
        // your code goes Below this comment
        // Store return value (results) in r0
        /////////////////////////////////////////////////////////
        cmp r0, #0
        beq branch1
        cmp r0, #128
        beq branch1
        lsr r4, r0, #7 //store sign bit in r4
        lsl r4, r4, #31
        lsl r5, r0, #25 //store exponent in r5
        lsr r5, r5, #29
        sub r5, r5, #3
        add r5, r5, #127
       	lsl r5, r5, #23
	lsl r6, r0, #28 //store mantissa in r6
        lsr r6, r6, #9
	mov r7, r4 //store temporary in r7
        add r7, r7, r5
        add r7, r7, r6
        mov r0, r7
	branch1: bl zeroFP2float

        /////////////////////////////////////////////////////////
        // your code goes ABOVE this comment
        // do not edit anything in this function below this line
        /////////////////////////////////////////////////////////

        sub     sp, fp, FP_OFF_FP2  // restore sp
        pop     {r4-r9,fp, lr}      // restore saved registers
        bx      lr                  // function return 
        .size   FP2float,(. - FP2float)


        /////////////////////////////////////////////////////////
        // function zeroFP2float
        /////////////////////////////////////////////////////////

        .type   zeroFP2float, %function // define as a function
        .global FP2float                // export function name
        .equ    FP_OFF_ZER, 4           // (regs - 1) * 4

zeroFP2float:
        push    {fp, lr}            // use r0-r3 for variables
        add     fp, sp, FP_OFF_ZER  // locate our frame pointer
        
        /////////////////////////////////////////////////////////
        // do not edit anything in this function above this line
        // your code goes Below this comment
        // Store return value (results) in r0
        /////////////////////////////////////////////////////////
        cmp r0, #0
        beq branch2
        cmp r0, #128
        beq branch2
        b branch3
        branch2: lsl r0, r0, #24	
        branch3:


        /////////////////////////////////////////////////////////
        // your code goes ABOVE this comment
        // do not edit anything in this function below this line
        /////////////////////////////////////////////////////////

        sub     sp, fp, FP_OFF_ZER  // restore sp
        pop     {fp, lr}            // restore saved registers
        bx      lr                  // function return
        .size   zeroFP2float,(. - zeroFP2float)
.end
