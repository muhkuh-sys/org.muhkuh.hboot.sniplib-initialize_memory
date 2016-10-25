	.section .init_code, "ax"
	.arm

	.global start

@--------------------------------------

  .func start

start:
	stmfd   sp!, {r0, r3, r4, r5, r6, r7, r8, r9}

	@ Copy the fill value from r2 to r3-r9.
	mov     r3, r2
	mov     r4, r2
	mov     r5, r2
	mov     r6, r2
	mov     r7, r2
	mov     r8, r2
	mov     r9, r2

	@ Clear the complete area with the fill value.
fill_loop:
	stmia   r0!, {r2-r9}

	cmp     r0, r1
	bmi     fill_loop

	@ Return to the ROM loader.
	ldmfd   sp!, {r0, r3, r4, r5, r6, r7, r8, r9}
	bx      lr

  .endfunc

@--------------------------------------

  .end

