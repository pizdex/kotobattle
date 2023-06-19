ReadJoypad::
; We can only get four inputs at a time.
; We take d-pad first for no particular reason.
	ld a, R_DPAD
	ldh [rP1], a
; Read two times to give the request time to take.
	ldh a, [rP1]
	ldh a, [rP1]
; The Joypad register output is in the lo nybble (inversed).
; We make the hi nybble of our new container d-pad input.
	cpl
	and $0f
	swap a
; We'll keep this in b for now.
	ld b, a

; Buttons make 8 total inputs (A, B, Select, Start).
; We can fit this into one byte.
	ld a, R_BUTTONS
	ldh [rP1], a
; Wait for input to stabilize.
REPT 6
	ldh a, [rP1]
ENDR
; Buttons take the lo nybble.
	cpl
	and $0f
	or b
	ld c, a

; To get the delta we xor the last frame's input with the new one.
	ldh a, [hJoypadDown]
	xor c
; Newly pressed this frame:
	and c
	ldh [hJoypadPressed], a
; Currently pressed:
	ld a, c
	ldh [hJoypadDown], a

; Reset the joypad register since we're done with it.
	ld a, $30
	ldh [rP1], a
	ret

Func_0430:
	ldh a, [hJoypadPressed]
	ld b, $00
	ld c, $08
	ld hl, wc149
.asm_0439
	inc hl
	rrca
	rr b
	bit 7, b
	jr z, .asm_0443
	ld [hl], $10
.asm_0443
	dec c
	jr nz, .asm_0439

	ldh a, [hJoypadDown]
	ld e, $08
.asm_044a
	rlca
	jr nc, .asm_0454
	ccf
	dec [hl]
	jr nz, .asm_0454
	ld [hl], $05
	scf

.asm_0454
	rl c
	dec hl
	dec e
	jr nz, .asm_044a
	ld a, c
	or b
	ldh [hff8c], a
	ret
