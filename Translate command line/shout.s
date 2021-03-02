// Describe the Hardware to the assembler
        .arch   armv6
        .cpu    cortex-a53
        .syntax unified
// externs
        .extern putchar
// Constants
        .equ    NULL,   0x0 
        .equ    EOF,    -1 
        .equ    EXIT_SUCCESS, 0   // success return from main
        .equ    EXIT_FAILURE, 1   // error return from main
        .equ    WSTEP,   4        // step of argv

        .text
        .type   main, %function   // main is a function
        .global main              // export main
        .equ    FP_OFFSET, 12     // (saved reg - 1) * 4
main:
        push    {r4, r5, fp, lr}  // saved registers
        add     fp, sp, FP_OFFSET // set frame pointer

        mov     r5, r1            // save argv pointer
        add     r5, r5, WSTEP     // point to argv[1]

        /*  ADD YOUR CODE HERE */
        mov     r7, r0            //store the length of argv[]
        mov     r8, #1

// for loop
// only three branches and another inner loop in this loop      
loop1:  ldr     r4, [r5]          // for(*r4 = r5[1], r4 != NULL, *r4++){
        add     r8, r8, #1        // count the number of argv[]	
        cmp     r4, NULL
        beq     branch4
        add     r5, r5, WSTEP
        mov     r6, #0

// for loop
// only two branches in the loop
loop2:  ldrb    r0, [r4, r6]      //for(*r0=r4[0], r0 != NULL, *r0++){ 
        cmp     r0, NULL
        beq     branch2
        // if then elif
        cmp	r0, '\t'          // if(r0 == '\t') {
        beq     branch2           // .
        cmp     r0, 'a'           // elif(r0 < 'a'|| r0 > 'z') {
        blt     branch1           // .
        cmp     r0, 'z'
        bgt     branch1           // .
        sub     r0, r0, #32       // convert to lower case 

// only one branch in this branch 
branch1:bl      putchar
        cmp     r0, EOF           // if (r0 == EOF) {       
        beq     branch3           // .
        add     r6, r6, #1        // i+=1
        b       loop2             // }

// only one branch in this branch 
branch2:cmp     r8, r7            // if(r8 == r7){
        beq     branch5           // .
        mov     r0, ' '
        bl      putchar
        b       loop1             // } }

branch3:mov     r0, EXIT_FAILURE 
        b       done              // }

branch4:mov     r0, EXIT_SUCCESS
        b       done              // } }

// only one branch in this branch 
branch5:mov     r0, '\n'
        bl      putchar
        b       branch4           // .

done:
        sub     sp, fp, FP_OFFSET // restore stack frame top
        pop     {r4, r5, fp, lr}  // remove stack frame and restore 
        bx      lr                // return to calling function
        .size   main, (. - main)
.end
