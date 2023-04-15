_Start::
	cp BOOTUP_A_CGB
	jp nz, NotCGB

Func_0155::
	di
	call Func_045f
	ld sp, $cfff

	ld a, BANK(Func_7f_4000)
	call Bankswitch
	call Func_7f_4000

	ld a, $7f
	call Bankswitch
	ld a, 2
	ldh [hRAMBank], a
	ldh [rSVBK], a
	ld a, BANK(Gfx_7f_481d)
	ld hl, Gfx_7f_481d
	ld de, w2d000
	call Func_0f79

	ld a, 3
	ldh [hRAMBank], a
	ldh [rSVBK], a
	ld a, BANK(Gfx_7f_511d)
	ld hl, Gfx_7f_511d
	ld de, w3d000
	call Func_0f79

	call Func_3680
	call Func_01be

	ld a, $0e
	ldh [hffa8], a
.asm_0195:
	xor a
	ldh [hff95], a
	call Func_0d7a
	call Joypad
	call Func_01b6
	call Func_02ac
	xor a
	ldh [hff8d], a
.wait
	ldh a, [hff8d]
	or a
	jr z, .wait
	jr .asm_0195

NotCGB::
	ld a, BANK(Func_01_54d3)
	ld [rROMB0], a
	jp Func_01_54d3

Func_01b6::
	ldh a, [hJoypadDown]
	cp $0f
	ret nz
	jp Func_0155

Func_01be::
	dr $01be, $01fa

VBlank::
	push af
	push bc
	push de
	push hl

	call Func_0d8a
	call Func_1347
	call Func_1065
	call Func_122f

	ldh a, [hff9d]
	and a
	jr z, .asm_023a

	ldh a, [hff9e]
	ldh [rSVBK], a
	xor a
	ldh [rVBK], a
	ld hl, rHDMA1
; $d000
	ld a, $d0
	ld [hli], a ; HDMA1
	xor a
	ld [hli], a ; HDMA2
; $9800
	ld a, $98
	ld [hli], a ; HDMA3
	xor a
	ld [hli], a ; HDMA4
	ld a, 35
	ld [hli], a ; HDMA5

	ld a, 1
	ldh [rVBK], a
	ld hl, rHDMA1
; $d300
	ld a, $d3
	ld [hli], a ; HDMA1
	xor a
	ld [hli], a ; HDMA2
; $9800
	ld a, $98
	ld [hli], a ; HDMA3
	xor a
	ld [hli], a ; HDMA4
	ld a, 35
	ld [hli], a ; HDMA5

.asm_023a:
	ldh a, [hff9f]
	and a
	jr z, .asm_0256

	ld a, 5
	ldh [rSVBK], a
	xor a
	ldh [rVBK], a
	ld hl, rHDMA1
; $d600
	ld a, $d6
	ld [hli], a ; HDMA1
	xor a
	ld [hli], a ; HDMA2
; $9c00
	ld a, $9c
	ld [hli], a ; HDMA3
	xor a
	ld [hli], a ; HDMA4
	ld a, 29
	ld [hli], a ; HDMA5

.asm_0256:
	call hff80
	call Func_36ab
	ldh a, [hRAMBank]
	ldh [rSVBK], a
	ldh a, [hROMBank]
	ld [rROMB0], a
	ld hl, hff91
	inc [hl]
	ld a, $01
	ldh [hff8d], a

	pop hl
	pop de
	pop bc
	pop af
	reti

LCD::
	push af
	push bc
	push de
	push hl

	di
	ldh a, [hff99]
	and a
	jr z, .asm_0286

	ld [rROMB0], a
	ldh a, [hff9a]
	ld h, a
	ldh a, [hff9b]
	ld l, a
	jp hl

.asm_0286
	ldh a, [hROMBank]
	ld [rROMB0], a
	ei

	pop hl
	pop de
	pop bc
	pop af
	reti

Func_0291::
	ld hl, hff99
	ld [hl], b
	ld hl, hff9a
	ld [hl], d
	inc hl
	ld [hl], e
	ld hl, rSTAT
	or [hl]
	ld [hl], a
	xor a
	ldh [rLYC], a
	ldh [rIF], a
	ldh a, [rIE]
	or $02
	ldh [rIE], a
	ret

Func_02ac::
	ldh a, [hffa8]
	rst Jumptable

unk_02af:
	dw Func_02eb
	dw $02f4
	dw $02fd
	dw $030c
	dw $0315
	dw $031e
	dw $0327
	dw $0330
	dw $0339
	dw $0342
	dw $034b
	dw $0354
	dw $035d
	dw $0366
	dw $036f
	dw $0378
	dw $0381
	dw $038a
	dw $0393
	dw $039c
	dw $03a5
	dw $03ae
	dw $03b7
	dw $03c0
	dw $03c9
	dw $03d2
	dw $03db
	dw $03e4
	dw $03ed
	dw Func_03f6

Func_02eb::
	dr $02eb, $03f6

Func_03f6::
	ld a, BANK(Func_7e_4000)
	call Bankswitch
	call Func_7e_4000
	ret

Joypad::
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
	dr $0430, $045f

Func_045f::
	dr $045f, $0466

Bankswitch::
	ldh [hff8e], a
	ld [rROMB0], a
	ldh [hROMBank], a
	ret

Func_046e::
	dr $046e, $0d7a

Func_0d7a::
	dr $0d7a, $0d8a

Func_0d8a::
	dr $0d8a, $0e3f

Func_0e3f::
	ld a, $fe
	ldh [rSB], a
	ld a, $81
	ldh [rSC], a
	ret

Serial::
	dr $0e48, $0f34

Func_0f34::
	dr $0f34, $0f79

Func_0f79::
; Probably something to do with 2bpp decoding
	push hl
	di
	ldh [hROMBank], a
	ld [rROMB0], a
	ei
	xor a
	ld [rROMB1], a
	ld a, e
	ld e, l
	ld l, a
	ld a, h
	ld h, d
	ld d, a
.asm_0f8b
	ld a, [de]
	bit 7, a
	jr nz, Func_0f34
	bit 6, a
	jr nz, .asm_0fc0

.asm_0f94:
	and $3f
	jr z, .asm_0ff0
	inc de
	ld b, a
	ld a, [de]
	inc de
	ld [hli], a
	ld [hli], a
	srl b
	jr nc, .asm_0fa3
	ld [hli], a

.asm_0fa3
	jr z, .asm_0f8b

.asm_0fa5
	ld [hli], a
	ld [hli], a
	dec b
	jr z, .asm_0f8b
	ld [hli], a
	ld [hli], a
	dec b
	jr z, .asm_0f8b
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .asm_0fa5

	ld a, [de]
	bit 7, a
	jp nz, Func_0f34
	bit 6, a
	jr nz, .asm_0fc0
	jr .asm_0f94

.asm_0fc0
	inc de
	and $3f
	inc a
	ld c, a
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	push de
	ld e, a
	ld d, b
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a

.asm_0fd4
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	dec c
	jr z, .asm_0fe2
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	dec c
	jr nz, .asm_0fd4

.asm_0fe2
	pop de
	inc de
	ld a, [de]
	bit 7, a
	jp nz, Func_0f34
	bit 6, a
	jr nz, .asm_0fc0
	jr .asm_0f94

.asm_0ff0
	pop bc
	inc de
	ld a, e
	ld e, l
	ld l, a
	sub c
	ld c, a
	ld a, d
	ld d, h
	ld h, a
	sbc b
	ld b, a
	di
	ldh a, [hff8e]
	ld [rROMB0], a
	ldh [hROMBank], a
	ei
	ret

Func_1006::
	dr $1006, $1065

Func_1065::
	dr $1065, $122f

Func_122f::
	dr $122f, $1347

Func_1347::
	dr $1347, $1628

Func_1628::
	dr $1628, $1642

SECTION "Home 2", ROM0[$3680]

Func_3680::
	xor a
	ld hl, wce9c
	ld b, $04
.asm_3686
	ld [hli], a
	dec b
	jr nz, .asm_3686
	ld [wce9b], a
	ld [wce7f], a
	ldh [rNR30], a
	ld [wce91], a
	ld [wce92], a
	cpl
	ld [wcf7b], a
	ldh [rNR52], a
	ld a, $01
	ld [wce80], a
	ld a, $77
	ld [wcf4d], a
	ldh [rNR50], a
	ret

Func_36ab::
	dr $36ab, $3704

Func_3704::
	dr $3704, $3733

Func_3733::
	dr $3733, $377a

Func_377a::
	dr $377a, $3827

Func_3827::
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	inc de
	ld h, a
	add hl, de
	ld e, l
	ld d, h
	jp Func_377a

Func_3833:
	sub $f0
	push bc
	add a
	ld c, a
	ld hl, .unk_3841
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.unk_3841
	dw Func_3864
	dw Func_386d
	dw Func_388e
	dw Func_3876
	dw Func_3898
	dw Func_389d
	dw Func_38a6
	dw Func_38b9
	dw Func_38c3
	dw Func_38da
	dw Func_38df
	dw Func_3827
	dw Func_38f6
	dw Func_38e4
	dw Func_3861
	dw Func_392c

Func_3861::
	jp Func_377a

Func_3864::
	ld hl, wce9c
	add hl, bc
	set 4, [hl]
	jp Func_377a

Func_386d::
	ld hl, wce9c
	add hl, bc
	res 4, [hl]
	jp Func_377a

Func_3876::
	ld a, [de]
	inc de
	ld hl, wcef4
	add hl, bc
	ld [hl], a
	ld a, [de]
	inc de
	ld hl, wcefc
	add hl, bc
	ld [hl], a
	ld hl, wcf04

Func_3887::
	ld a, [de]
	inc de
	add hl, bc
	ld [hl], a
	jp Func_377a

Func_388e::
	ld a, [de]
	inc de
	ld hl, wcea4
	add hl, bc
	ld [hl], a
	jp Func_377a

Func_3898::
	ld hl, wcf4c
	jr Func_3887

Func_389d::
	dr $389d, $38a6

Func_38a6::
	dr $38a6, $38b9

Func_38b9::
	dr $38b9, $38c3

Func_38c3::
	dr $38c3, $38da

Func_38da::
	dr $38da, $38df

Func_38df::
	dr $38df, $38e4

Func_38e4::
	dr $38e4, $38f6

Func_38f6::
	dr $38f6, $392c

Func_392c::
	ld hl, wce9c
	add hl, bc
	ld [hl], 0
	ret

Func_3933::
	dr $3933, $39d3

Func_39d3::
	dr $39d3, $3a32

Func_3a32::
	dr $3a32, $3aa3

Func_3aa3::
	dr $3aa3, $3b45

Func_3b45:
	ld hl, wcedd
	add hl, bc
	add hl, bc
	ld a, [hl]
	bit 7, a
	ret z

	ld hl, wcf14
	add hl, bc
	ld a, [hl]
	ldh [rNR42], a
	ld hl, wcedc
	add hl, bc
	add hl, bc
	ld a, [hl]
	ldh [rNR43], a
	ld a, $80
	ldh [rNR44], a
	ret

Func_3b62:
	call Func_3aa3
	push bc
	ld hl, .unk_3b71
	res 2, c
	add hl, bc
	ld c, [hl]
	xor a
	ld [c], a
	pop bc
	ret

.unk_3b71
	db $12, $17, $1a, $21

Func_3b75::
	dr $3b75, $3be3

Func_3be3::
	dr $3be3, $3d1b

Func_3d1b::
	dr $3d1b, $3d77

Func_3d77::
	dr $3d77, $3df1

Func_3df1::
	ld a, [wce9b]
	ret

Func_3df5::
	dr $3df5, $3e35

Func_3e35::
	dr $3e35, $3e6b

Func_3e6b::
	ld d, a
.asm_3e6c
	ldh a, [rDIV]
	bit 0, a
	jr nz, .asm_3e6c
.asm_3e72
	ldh a, [rDIV]
	bit 0, a
	jr z, .asm_3e72

	ld a, d
	ldh [rNR12], a
	ldh [rNR22], a
	ld a, $87
	ldh [rNR14], a
	ldh [rNR24], a
	ret

Func_3e84::
	dr $3e84, $3f05

Func_3f05::
	ld b, 4
.asm_3f07
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .asm_3f07
	ret

Func_3f0e::
	dr $3f0e, $3f8f

Func_3f8f:
	ld b, 4
.asm_3f91
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_3f91
	ret
