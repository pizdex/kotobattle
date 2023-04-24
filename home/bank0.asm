_Start::
	cp BOOTUP_A_CGB
	jp nz, NotCGB

Init::
	di

	call DisableLCD

	ld sp, wStackTop

	ld a, BANK(Func_7f_4000)
	call Bankswitch
	call Func_7f_4000

; Load character set 1
	ld a, $7f
	call Bankswitch
	ld a, 2
	ldh [hRAMBank], a
	ldh [rSVBK], a
	ld a, BANK(Gfx_7f_481d)
	ld hl, Gfx_7f_481d
	ld de, w2d000
	call Func_0f79
; Load character set 2
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
	call ReadJoypad
	call CheckSoftReset
	call Func_02ac
	xor a
	ldh [hff8d], a
.wait
	ldh a, [hff8d]
	or a
	jr z, .wait
	jr .asm_0195

NotCGB:
	ld a, BANK(Func_01_54d3)
	ld [rROMB0], a
	jp Func_01_54d3

CheckSoftReset:
	ldh a, [hJoypadDown]
	cp ~(A_BUTTON + B_BUTTON + START + SELECT)
	ret nz
	jp Init

Func_01be::
	ld hl, wc49d
	ld bc, $5c1
	call ClearBytes

	ld a, $63
	ld [wc4d3], a
	ld a, $72
	ld [wc4d4], a
	ld a, $23
	ld [wc4d5], a
	ld a, $00
	ld [wc4d6], a
	ld a, $00
	ld [wc4d7], a
	ld a, $02
	ld [wc4d8], a
	ld a, $02
	ld [wc4d9], a
	ld a, $01
	ld [wc4da], a
	ld a, $01
	ld [wc4db], a
	ld a, $05
	ld [wc4dc], a
	ret

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
	call hTransferVirtualOAM
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
	rst JumpTable

unk_02af:
	dw Func_02eb
	dw Func_02f4
	dw Func_02fd
	dw Func_030c
	dw Func_0315
	dw Func_031e
	dw Func_0327
	dw Func_0330
	dw Func_0339
	dw Func_0342
	dw Func_034b
	dw Func_0354
	dw Func_035d
	dw Func_0366
	dw Func_036f
	dw Func_0378
	dw Func_0381
	dw Func_038a
	dw Func_0393
	dw Func_039c
	dw Func_03a5
	dw Func_03ae
	dw Func_03b7
	dw Func_03c0
	dw Func_03c9
	dw Func_03d2
	dw Func_03db
	dw Func_03e4
	dw Func_03ed
	dw Func_03f6

Func_02eb::
	ld a, $0f
	call Bankswitch
	call $62f5
	ret

Func_02f4::
	ld a, $02
	call Bankswitch
	call $5128
	ret

Func_02fd::
	ld a, $03
	call Bankswitch
	ld a, $06
	ldh [hRAMBank], a
	ldh [rSVBK], a
	call $41b8
	ret

Func_030c::
	ld a, $04
	call Bankswitch
	call $5b37
	ret

Func_0315::
	ld a, $02
	call Bankswitch
	call $4000
	ret

Func_031e::
	ld a, $06
	call Bankswitch
	call $430a
	ret

Func_0327::
	ld a, $06
	call Bankswitch
	call $7220
	ret

Func_0330::
	ld a, $02
	call Bankswitch
	call $5228
	ret

Func_0339::
	ld a, $04
	call Bankswitch
	call $659c
	ret

Func_0342::
	ld a, $0b
	call Bankswitch
	call $40db
	ret

Func_034b::
	ld a, $05
	call Bankswitch
	call $4f23
	ret

Func_0354::
	ld a, $04
	call Bankswitch
	call $514f
	ret

Func_035d::
	ld a, $02
	call Bankswitch
	call $60db
	ret

Func_0366::
	ld a, $06
	call Bankswitch
	call $4000
	ret

Func_036f::
	ld a, $01
	call Bankswitch
	call $6046
	ret

Func_0378::
	ld a, $04
	call Bankswitch
	call $4000
	ret

Func_0381::
	ld a, $05
	call Bankswitch
	call $4000
	ret

Func_038a::
	ld a, $0f
	call Bankswitch
	call $5b6f
	ret

Func_0393::
	ld a, $08
	call Bankswitch
	call $4000
	ret

Func_039c::
	ld a, $05
	call Bankswitch
	call $6959
	ret

Func_03a5::
	ld a, $01
	call Bankswitch
	call $4000
	ret

Func_03ae::
	ld a, $0f
	call Bankswitch
	call $5229
	ret

Func_03b7::
	ld a, $2b
	call Bankswitch
	call $4082
	ret

Func_03c0::
	ld a, $0f
	call Bankswitch
	call $4cbd
	ret

Func_03c9::
	ld a, $0f
	call Bankswitch
	call $4000
	ret

Func_03d2::
	ld a, $0d
	call Bankswitch
	call $401d
	ret

Func_03db::
	ld a, $0e
	call Bankswitch
	call $4000
	ret

Func_03e4::
	ld a, $77
	call Bankswitch
	call $461c
	ret

Func_03ed::
	ld a, $0e
	call Bankswitch
	call $574a
	ret

Func_03f6::
	ld a, BANK(Func_7e_4000)
	call Bankswitch
	call Func_7e_4000
	ret

INCLUDE "home/joypad.asm"

DisableLCD::
; Ensure LCD is off
	ldh a, [rLCDC]
	and ~LCDCF_ON
	ldh [rLCDC], a
	ret

Bankswitch::
	ldh [hff8e], a
	ld [rROMB0], a
	ldh [hROMBank], a
	ret

FarCopyBytesVRAM::
	di
	ld [rROMB0], a
	call CopyBytesVRAM
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

CopyBytesVRAM::
; Copy bc bytes from hl to de, VRAM safe
	inc b
	inc c
	jr .copy

.wait
	ldh a, [rSTAT]
	and STATF_BUSY
	jr nz, .wait

	ld a, [hli]
	ld [de], a
	inc de
.copy
	dec c
	jr nz, .wait
	dec b
	jr nz, .wait
	ret

Func_0490::
	push bc
	ld h, 0
	ld l, b
	ld b, h
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, bc
	add hl, de
	pop bc
	ret

Func_049e:
	di
	ld [rROMB0], a
	call Func_04ac
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

Func_04ac::
	ld a, $20
	sub b
	ldh [hff92], a

.asm_04b1:
	push bc
.asm_04b2
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .asm_04b2
	ldh a, [hff92]
	ld c, a
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_04b1
	ret

Func_04c1::
	sla a
	sla a
	or b
	sla a
	set 7, a
	ld [de], a
	ret

Func_04cc::
	ld de, rOCPS
	call Func_04c1
	ld de, rOCPD
	jr Func_04d7.wait

Func_04d7::
	ld de, rBCPS
	call Func_04c1
	ld de, rBCPD

.wait
	ldh a, [rSTAT]
	and STATF_BUSY
	jr nz, .wait

	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	ret

Func_04eb::
	ld b, 0
	ld de, rOCPS
	call Func_04c1
	ld de, rOCPD
	jr Func_04f8.asm_0503

Func_04f8::
	ld b, 0
	ld de, rBCPS
	call Func_04c1
	ld de, rBCPD

.asm_0503:
	ld c, 4
.wait
	ldh a, [rSTAT]
	and STATF_BUSY
	jr nz, .wait

	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	dec c
	ret z
	jr .wait

Func_0513::
	ld b, 0
	ld de, rOCPS
	call Func_04c1
	ld de, rOCPD
	jr Func_0520.asm_052b

Func_0520::
	ld b, 0
	ld de, rBCPS
	call Func_04c1
	ld de, rBCPD

.asm_052b:
	ld c, 32
.wait
	ldh a, [rSTAT]
	and STATF_BUSY
	jr nz, .wait

	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	dec c
	ret z
	jr .wait

Func_053b::
	ld d, a
	ld a, c
	di
	ld [rROMB0], a
	ld a, d
	call Func_04cc
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

Func_054c::
	ld d, a
	ld a, c
	di
	ld [rROMB0], a
	ld a, d
	call Func_04d7
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

Func_055d::
	ld c, a
	ld a, b
	di
	ld [rROMB0], a
	ld a, c
	call Func_04eb
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

Func_056e::
	ld c, a
	ld a, b
	di
	ld [rROMB0], a
	ld a, c
	call Func_04f8
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

Func_057f::
	di
	ld [rROMB0], a
	call Func_0513
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

Func_058d::
	di
	ld [rROMB0], a
	call Func_0520
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

Func_059b:
	ldh a, [hff91]
	ldh [hff94], a
	and $0f
	ldh [hff93], a
	ret

Func_05a4:
	push bc
	push hl
	ld hl, .unk_05bd
	ldh a, [hff93]
	inc a
	and $0f
	ldh [hff93], a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld hl, hff94
	add [hl]
	ld [hl], a
	pop hl
	pop bc
	ret

.unk_05bd
	db $f0, $18, $13, $de, $99, $61, $ea, $cc, $42, $8a, $f1, $02, $4e, $88, $9c, $20

Func_05cd::
	ld l, 0
	ld h, a
	ld c, b
	ld b, l
	ld a, 8
.asm_05d4
	add hl, hl
	jr nc, .asm_05d8
	add hl, bc
.asm_05d8
	dec a
	jr nz, .asm_05d4
	ret

Func_05dc::
	ld bc, $0000
.asm_05df
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	inc bc
	jr nc, .asm_05df
	add hl, de
	dec bc
	ret

Func_05eb::
	ld c, 0
.asm_05ed
	sub b
	inc c
	jr nc, .asm_05ed
	add b
	dec c
	ret

Func_05f4::
	ld a, 5
.asm_05f6
	push af
	push de
	ld b, h
	ld c, l
	ld de, .unk_0613
	add a
	ld h, 0
	ld l, a
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld h, b
	ld l, c
	call Func_05dc
	pop de
	ld a, c
	ld [de], a
	inc de
	pop af
	dec a
	jr nz, .asm_05f6
	ret

.unk_0613
	db $00, $00, $01, $00, $0a, $00, $64, $00, $e8, $03, $10, $27

Func_061f::
	ld hl, .unk_0635
	ld b, 3
	push bc
.asm_0625
	ld b, [hl]
	call Func_05eb
	ld b, a
	ld a, c
	ld [de], a
	ld a, b
	pop bc
	dec b
	ret z
	inc hl
	inc de
	push bc
	jr .asm_0625

.unk_0635
	db $64, $0a, $01

Func_0638::
.asm_0638
	ld a, [hli]
	dec b
	jr z, .asm_063f
	and a
	jr z, .asm_0638

.asm_063f
	inc b
	dec hl
	ld c, $b0
.asm_0643
	ld a, c
	add [hl]
	ld [hli], a
	dec b
	jr nz, .asm_0643
	ret

Func_064a:
	ld c, $b0
.asm_064c
	ld a, c
	add [hl]
	ld [hli], a
	dec b
	jr nz, .asm_064c
	ret

Func_0653:
	ld c, a
	ld a, b
	and a
	jr z, .asm_066c
	push de
	ld d, $08
	xor a
.asm_065c
	rl c
	rla
	sub b
	ccf
	jr c, .asm_0665
	add b
	ccf
.asm_0665
	dec d
	jr nz, .asm_065c
	rl c
	pop de
	ret

.asm_066c
	xor a
	ld c, a
	ret

Func_066f::
	add hl, hl
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld h, d
	ld l, e
	ret

Func_0677::
	di
	ld [rROMB0], a
	call Func_066f
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

Func_0685::
	di
	ld [rROMB0], a
	ld b, [hl]
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

Func_0691::
	push af
	push de
	ld de, $03e7
	call Func_00d2
	jr z, .asm_06a3
	call Func_00cd
	jr c, .asm_06a3
	ld hl, $03e7
.asm_06a3
	pop de
	pop af
	ret

Func_06a6::
	ld hl, $0085
	call Func_1046
	ret nz
	ld a, $01
	ld b, $3c
.asm_06b1
	call Func_077d
	ret z
	inc a
	dec b
	jr nz, .asm_06b1
	ld hl, $0085
	call Func_1006
	ret

Func_06c0::
	call Func_06e4
	ret nc

	push hl
	ld a, $01
	ld bc, wc251
.asm_06ca
	call Func_0719
	push af
	ld a, [bc]
	inc d
	cp d
	jr z, .asm_06e0
	jr nc, .asm_06e0

	pop af
	cp $3c
	jr z, .asm_06de

	inc bc
	inc a
	jr .asm_06ca

.asm_06de
	pop hl
	ret

.asm_06e0
	pop af
	pop hl
	ld [hl], a
	ret

Func_06e4:
	ld b, $14
	ld hl, wc295
.asm_06e9
	ld a, [hli]
	cp $38
	jr z, .asm_06f4
	inc hl
	dec b
	jr nz, .asm_06e9
	xor a
	ret

.asm_06f4
	dec hl
	scf
	ret

Func_06f7::
	ld a, [wcbdc]
	cp $10
	ret z
	inc a
	ld [wcbdc], a
	dec a
	ld hl, wcbdd
	add a
	add a
	add a
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld b, $08
	ld c, $a0
.asm_0712
	ld a, [c]
	ld [hli], a
	inc c
	dec b
	jr nz, .asm_0712
	ret

Func_0719::
	ld hl, wc293
	ld e, $15
	ld d, $00
.asm_0720:
	inc hl
	inc hl
	dec e
	ret z
	cp [hl]
	jr nz, .asm_0720
	inc d
	jr .asm_0720

Func_072a::
	push hl
	ld a, l
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	ld de, wc46d
	add hl, de
	and $07
	ld d, $80
.asm_0740
	and a
	jr z, .asm_0748
	srl d
	dec a
	jr .asm_0740

.asm_0748
	ld a, d
	and [hl]
	pop hl
	ret

Func_074c::
	push hl
	push de
	ld a, l
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	ld de, wc415
	add hl, de
	and $07
	ld d, $80
.asm_0763
	and a
	jr z, .asm_076b
	srl d
	dec a
	jr .asm_0763

.asm_076b
	ld a, d
	and [hl]
	pop de
	pop hl
	ret

Func_0770:
	ld b, $14
	ld hl, wc295
.asm_0775
	ld a, [hli]
	inc hl
	ld [de], a
	inc de
	dec b
	jr nz, .asm_0775
	ret

Func_077d::
	ld e, a
	srl e
	srl e
	srl e
	ld d, 0
	ld hl, wc28d
	add hl, de
	ld e, a
	and $07
	ld d, $80
.asm_078f
	and a
	jr z, .asm_0797
	srl d
	dec a
	jr .asm_078f

.asm_0797
	ld a, d
	and [hl]
	ld a, e
	ret

Func_079b::
	push de
	ld a, e
	srl d
	rr e
	srl d
	rr e
	srl d
	rr e
	ld hl, wc46d
	add hl, de
	and $07
	ld d, $80
.asm_07b1
	and a
	jr z, .asm_07b9
	srl d
	dec a
	jr .asm_07b1

.asm_07b9
	ld a, d
	or [hl]
	ld [hl], a
	pop de
	ret

Func_07be::
	push de
	ld a, e
	srl d
	rr e
	srl d
	rr e
	srl d
	rr e
	ld hl, wc415
	add hl, de
	and $07
	ld d, $80
.asm_07d4
	and a
	jr z, .asm_07dc
	srl d
	dec a
	jr .asm_07d4

.asm_07dc
	ld a, d
	or [hl]
	ld [hl], a
	pop de
	ret

Func_07e1::
	ld e, a
	srl e
	srl e
	srl e
	ld d, 0
	ld hl, wc28d
	add hl, de
	ld e, a
	and $07
	ld d, $80
.asm_07f3
	and a
	jr z, .asm_07fb
	srl d
	dec a
	jr .asm_07f3

.asm_07fb
	ld a, d
	or [hl]
	ld [hl], a
	ld a, e
	ret

Func_0800::
	dr $0800, $0862

Func_0862::
	dr $0862, $091a

Func_091a::
	ld a, [hli]
	ld b, h
	ld c, l
	push de
	ld de, unk_0a65
	call PointerTable
	pop de
	inc hl
	ld a, [hl]
	and $01
	ret z
	ld h, b
	ld l, c
	ld a, [hl]
	sub d
	jr nc, .asm_0931
	xor a

.asm_0931
	and a
	ld [hl], a
	ret nz
	xor a
	dec hl
	ld [hl], a
	ld hl, wc200
	ld c, $28
.asm_093c
	ld a, [hl]
	and a
	jr z, .asm_0946
	inc hl
	inc hl
	dec c
	jr nz, .asm_093c
	ret

.asm_0946
	ld d, h
	ld e, l
	inc de
	inc de

.asm_094a
	dec c
	jr z, .asm_0955
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	jr .asm_094a

.asm_0955
	ld a, [wc147]
	and a
	ret z
	dec a
	ld [wc147], a
	ret

Func_095f::
	dr $095f, $09cb

Func_09cb::
	dr $09cb, $09fb

Func_09fb::
	ld de, $7acf
	ld a, $4d
	call Func_0677
	ret

Func_0a04::
	ld a, $29
	ld [rROMB0], a
	ld a, [wc132]
	and $0f
	ld de, $4000
	call PointerTable
	ld hl, wc133
	ld a, [hl]
	inc [hl]
	ld h, 0
	ld l, a
	add hl, de
	ld d, [hl]
	ldh a, [hff8e]
	ld [rROMB0], a
	ld a, d
	ret

unk_0a25:
REPT 32
	dw $7fff
ENDR

unk_0a65:
	dw unk_0ab7
	dw unk_0ab7
	dw unk_0ac1
	dw unk_0acb
	dw unk_0ad5
	dw unk_0adf
	dw unk_0ae9
	dw unk_0af3
	dw unk_0afd
	dw unk_0b07
	dw unk_0b11
	dw unk_0b1b
	dw unk_0b25
	dw unk_0b2f
	dw unk_0b39
	dw unk_0b43
	dw unk_0b4d
	dw unk_0b57
	dw unk_0b61
	dw unk_0b6b
	dw unk_0b75
	dw unk_0b7f
	dw unk_0b89
	dw unk_0b93
	dw unk_0b9d
	dw unk_0ba7
	dw unk_0bb1
	dw unk_0bbb
	dw unk_0bc5
	dw unk_0bcf
	dw unk_0bd9
	dw unk_0be3
	dw unk_0bed
	dw unk_0bf7
	dw unk_0c01
	dw unk_0c0b
	dw unk_0c15
	dw unk_0c1f
	dw unk_0c29
	dw unk_0c33
	dw unk_0c3d

unk_0ab7:
	db $00, $01, $8e, $7e, $5f, $a6, $5a, $a6, $00, $00
unk_0ac1:
	db $00, $01, $57, $86, $31, $0d, $28, $00, $00, $00
unk_0acb:
	db $00, $01, $05, $08, $0d, $28, $5e, $a0, $64, $00
unk_0ad5:
	db $00, $01, $5c, $7e, $77, $19, $02, $40, $07, $00
unk_0adf:
	db $00, $01, $13, $2e, $19, $0c, $4e, $08, $1c, $08
unk_0ae9:
	db $01, $01, $0a, $2b, $0a, $2b, $39, $2e, $33, $00
unk_0af3:
	db $02, $00, $63, $7e, $7f, $52, $19, $11, $36, $00
unk_0afd:
	db $02, $00, $24, $40, $2a, $10, $04, $16, $50, $07
unk_0b07:
	db $03, $01, $74, $58, $a0, $64, $19, $08, $12, $00
unk_0b11:
	db $03, $00, $6c, $8d, $a6, $19, $05, $1f, $23, $28
unk_0b1b:
	db $03, $01, $70, $85, $9e, $79, $19, $03, $10, $00
unk_0b25:
	db $03, $01, $6b, $64, $6b, $64, $19, $1e, $21, $27
unk_0b2f:
	db $03, $01, $5c, $7e, $77, $19, $22, $39, $1f, $00
unk_0b39:
	db $02, $00, $04, $16, $50, $07, $11, $4f, $03, $00
unk_0b43:
	db $04, $01, $6e, $5c, $a0, $5a, $0a, $3e, $0a, $00
unk_0b4d:
	db $04, $01, $7c, $53, $62, $19, $12, $42, $00, $00
unk_0b57:
	db $04, $01, $6f, $95, $a6, $58, $19, $06, $32, $00
unk_0b61:
	db $05, $01, $1b, $06, $28, $19, $12, $40, $00, $00
unk_0b6b:
	db $05, $01, $75, $57, $a0, $97, $19, $06, $0e, $07
unk_0b75:
	db $05, $01, $5a, $64, $89, $6f, $19, $06, $09, $27
unk_0b7f:
	db $05, $01, $18, $21, $29, $10, $02, $26, $03, $00
unk_0b89:
	db $05, $01, $0c, $36, $20, $25, $08, $1e, $0c, $00
unk_0b93:
	db $05, $01, $01, $09, $19, $12, $07, $00, $00, $00
unk_0b9d:
	db $05, $01, $1c, $15, $19, $28, $19, $56, $8e, $7e
unk_0ba7:
	db $05, $01, $5d, $55, $53, $14, $5c, $57, $70, $b4
unk_0bb1:
	db $05, $01, $01, $08, $1f, $19, $35, $13, $2e, $00
unk_0bbb:
	db $05, $01, $5d, $5a, $a0, $95, $00, $00, $00, $00
unk_0bc5:
	db $05, $01, $06, $25, $20, $3d, $22, $00, $00, $00
unk_0bcf:
	db $05, $01, $28, $2e, $33, $51, $72, $00, $00, $00
unk_0bd9:
	db $05, $01, $11, $02, $0b, $15, $6c, $58, $7b, $53
unk_0be3:
	db $01, $01, $51, $72, $39, $1f, $00, $00, $00, $00
unk_0bed:
	db $01, $01, $5b, $7e, $56, $58, $05, $16, $30, $28
unk_0bf7:
	db $01, $01, $10, $1f, $33, $41, $2e, $14, $03, $00
unk_0c01:
	db $05, $00, $8e, $64, $79, $69, $a6, $64, $00, $00
unk_0c0b:
	db $05, $00, $0a, $03, $28, $4d, $08, $90, $a0, $58
unk_0c15:
	db $05, $01, $78, $84, $a6, $90, $b3, $00, $00, $00
unk_0c1f:
	db $05, $01, $78, $84, $a6, $90, $b4, $00, $00, $00
unk_0c29:
	db $05, $01, $78, $84, $a6, $90, $b5, $00, $00, $00
unk_0c33:
	db $05, $01, $78, $84, $a6, $90, $b6, $00, $00, $00
unk_0c3d:
	db $05, $01, $78, $84, $a6, $90, $b7, $00, $00, $00

unk_0c47:
	dr $0c47, $0d11

Func_0d11::
	dr $0d11, $0d7a

Func_0d7a::
	dr $0d7a, $0d8a

Func_0d8a::
	dr $0d8a, $0dfd

Func_0dfd::
	ldh a, [rIF]
	and $f7
	ldh [rIF], a

	ldh a, [rIE]
	and $f7
	ldh [rIE], a

	xor a
	ldh [hfff6], a
	ldh [hfff5], a
	ldh [hfff7], a
	ldh [hfff8], a
	ldh [hfff9], a
	ldh [hfffb], a
	ldh [hfffc], a
	ldh [hfffd], a
	ldh [hfffe], a
	ldh [hfffa], a
	ldh [hfff3], a
	ldh [rSB], a
	ldh [rSC], a
	ld a, $fd
	ldh [hfff4], a
	ld a, $02
	ldh [hfff2], a

	ld hl, wc0a0
	ld bc, $40
	call ClearBytes
	ld hl, wc0e0
	ld bc, $40
	call ClearBytes
	ret

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
; 2bpp decoding?
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
	dr $1006, $1026

Func_1026::
	dr $1026, $1046

Func_1046::
	dr $1046, $1065

Func_1065::
	dr $1065, $1094

Func_1094::
	dr $1094, $118e

Func_118e::
	dr $118e, $122f

Func_122f::
	ld a, [wcbd9]
	and a
	ret z

	xor a
	ld [wcbd9], a
	ld c, $68
	ld hl, wcad6
	ld a, $80
	ld [c], a
	inc c
REPT 64
	ld a, [hli]
	ld [c], a
ENDR
	inc c
	ld a, $80
	ld [c], a
	inc c
REPT 64
	ld a, [hli]
	ld [c], a
ENDR
	ret

Func_1347::
	ld hl, wcbdc
	ld a, [hl]
	and a
	jr z, .ret

	ld [hl], 0
	ld c, a
	ld hl, wcbdd
.asm_1354
	ld a, [hli]
	ldh [rHDMA2], a
	ld a, [hli]
	ldh [rHDMA1], a
	ld a, [hli]
	ld [rROMB0], a
	ld a, [hli]
	ldh [rSVBK], a
	ld a, [hli]
	ldh [rHDMA4], a
	ld a, [hli]
	ldh [rHDMA3], a
	ld a, [hli]
	ldh [rVBK], a
	ld a, [hli]
	ldh [rHDMA5], a
	dec c
	jr nz, .asm_1354
.ret
	ret

Func_1371:
	dr $1371, $13b6

Func_13b6:
	di
	ld [rROMB0], a
	ld a, c
	call Func_1371
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

Func_13c5:
	ld l, a
	ld h, 0
	ld de, wd85d
	add hl, hl
	add hl, de
	xor a
	ld [hli], a
	ld [hli], a
	ret

Func_13d1:
	dr $13d1, $140d

Func_140d::
	dr $140d, $1422

Func_1422::
	di
	ld [rROMB0], a
	call Func_140d
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

Func_1430::
	push hl
	call Func_09fb
	call Func_09cb
	pop hl
	call Func_1451
	call Func_14a1
	call Func_1509
	call Func_1531
	call Func_1574
	call Func_1580
	call Func_15a3
	call Func_15eb
	ret

Func_1451:
	dr $1451, $14a1

Func_14a1::
	dr $14a1, $1509

Func_1509::
	dr $1509, $1531

Func_1531::
	dr $1531, $1574

Func_1574::
	dr $1574, $1580

Func_1580::
	dr $1580, $15a3

Func_15a3::
	dr $15a3, $15eb

Func_15eb::
	dr $15eb, $1628

Func_1628::
	ld b, $40
	call Func_05cd
	ld a, $03
	ldh [rSVBK], a
	ld bc, wd000
	add hl, bc
	ld bc, $40
	di
	call CopyBytesVRAM
	ei
	ldh a, [hRAMBank]
	ldh [rSVBK], a
	ret

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
	ld hl, wce7f
	inc [hl]
	ld hl, wce80
	srl [hl]
	ret nc

	call Func_3be3
.asm_36b8
	ld bc, $0000
.asm_36bb
	ld hl, wce9a
	srl [hl]
	ld hl, wce9c
	add hl, bc
	bit 7, [hl]
	call nz, Func_3704
	inc c
	ld a, c
	and $03
	jr nz, .asm_36bb
	bit 2, c
	jr z, .asm_36da
	ld a, [wce9b]
	bit 0, a
	jr z, .asm_36bb

.asm_36da
	ld a, [wce9a]
	and $0f
	ld e, a
	swap e
	or e
	ld e, a
	ld hl, wcf79
	and [hl]
	ld d, a
	ld a, e
	cpl
	inc hl
	and [hl]
	or d
	ldh [rNR51], a
	ld hl, wce9b
	bit 1, [hl]
	call nz, Func_3b9b
	ld hl, wce7f
	dec [hl]
	jr nz, .asm_36b8

	ld a, $01
	ld [wce80], a
	ret

Func_3704::
	ld hl, wce9a
	set 7, [hl]
	ld hl, wcea4
	add hl, bc
	ld d, [hl]
	ld hl, wceac
	add hl, bc
	ld a, [hl]
	add $43
	ld e, b
.asm_3716
	sub d
	inc e
	jr nc, .asm_3716

	add d
	ld [hl], a
	dec e
	call nz, Func_3733
	ld hl, wce9c
	add hl, bc
	bit 4, [hl]
	call nz, Func_39d3
	ld hl, wce9c
	add hl, bc
	bit 3, [hl]
	call nz, Func_3a32
	ret

Func_3733::
	ld hl, wce9c
	add hl, bc
	bit 0, [hl]
	jr nz, .asm_3755
	bit 6, [hl]
	jr nz, .asm_3755

	ld hl, wced4
	add hl, bc
	ld a, [hl]
	sub e
	ld [hl], a
	jr z, .asm_374c
	jr c, .asm_374c
	jr .asm_3755

.asm_374c
	call Func_3b62
	ld hl, wce9c
	add hl, bc
	set 0, [hl]

.asm_3755:
	ld hl, wcecc
	add hl, bc
	ld a, [hl]
	sub e
	ld [hl], a
	jr z, Func_3769
	ret nc

	cpl
	inc a
	ld e, a
	push de
	call Func_3769
	pop de
	jr Func_3733

Func_3769:
	ld hl, wceb4
	add hl, bc
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hl]
	ld [wcf7c], a
	ld [rROMB0], a

Func_377a::
; Character decoding?
	ld a, [de]
	inc de
	cp $d0
	jr c, .asm_3787
	cp $e0
	jr c, .asm_37fb
	jp Func_3833

.asm_3787:
	cp $7f
	jr z, .asm_37e0

	push af
	push de
	and $7f
	call Func_3949
	ld hl, wce9c
	add hl, bc
	bit 6, [hl]
	res 6, [hl]
	jr nz, .asm_37a8
	set 7, d
	bit 4, [hl]
	call nz, Func_39c6
	bit 3, [hl]
	call nz, Func_3a25

.asm_37a8:
	ld hl, wcedc
	add hl, bc
	add hl, bc
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	call Func_3aaf
	pop de
	pop af
	cp $80
	jr c, .asm_37c0
	ld hl, wce9c
	add hl, bc
	set 6, [hl]

.asm_37c0:
	ld a, [de]
	inc de
	ld hl, wcecc
	add hl, bc
	ld [hl], a
	push de
	ld hl, wcf24
	add hl, bc
	ld e, [hl]
	call Func_3933
	ld hl, wced4
	add hl, bc

.asm_37d4:
	ld [hl], a
	pop de
	ld hl, wce9c
	add hl, bc
	ld a, [hl]
	and $f8
	ld [hl], a
	jr .asm_37f1

.asm_37e0:
	ld a, [de]
	inc de
	ld hl, wcecc
	add hl, bc
	ld [hl], a
	ld hl, wce9c
	add hl, bc
	ld a, [hl]
	and $f8
	set 0, a
	ld [hl], a

.asm_37f1:
	ld hl, wceb4
	add hl, bc
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

.asm_37fb:
	push af
	and $03
	ld hl, wcf51
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	add l
	ld l, a
	ld a, h
	adc 0
	ld h, a
	pop af
	cp $d4
	jr c, .asm_381a

	ld a, [de]
	inc de
	inc [hl]
	cp [hl]
	jr nz, .asm_3822
	ld [hl], 0
	jr Func_3827

.asm_381a:
	inc [hl]
	ld a, [de]
	inc de
	cp [hl]
	jr nz, Func_3827
	ld [hl], 0

.asm_3822
	inc de
	inc de
	jp Func_377a

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
	ld hl, wcf4c
	add hl, bc
	ld [hl], $08
	jp Func_377a

Func_38a6::
	ld a, [de]
	inc de
	push de
	ld e, a
	swap e
	ld hl, wcf14
	add hl, bc
	ld a, [hl]
	and $0f
	or e
	ld [hl], a
	pop de
	jp Func_377a

Func_38b9::
	ld a, [de]
	inc de
	ld hl, wcf1c
	add hl, bc
	ld [hl], a
	jp Func_377a

Func_38c3::
	ld a, [de]
	inc de
	ld hl, wce9c
	add hl, bc
	res 3, [hl]
	push de
	ld e, a
	ld hl, wcf14
	add hl, bc
	ld a, [hl]
	and $f0
	or e
	ld [hl], a
	pop de
	jp Func_377a

Func_38da::
	ld hl, wcf24
	jr Func_3887

Func_38df::
	ld hl, wceec
	jr Func_3887

Func_38e4::
	ld a, [de]
	inc de
	ld hl, wce9c
	add hl, bc
	set 3, [hl]
	ld hl, wcf2c
	add hl, bc
	ld [hl], a
	ld hl, wcf34
	jr Func_3887

Func_38f6::
	ld a, [de]
	inc de
	push de
	ld e, a
	ld hl, .unk_3924
	add hl, bc
	ld d, [hl]
	ld hl, wcf79
	bit 2, c
	jr z, .asm_3907
	inc hl

.asm_3907
	ld a, d
	swap a
	or d
	cpl
	and [hl]
	ld [hl], a
	ld a, $0f
	and e
	jr z, .asm_3916
	ld a, [hl]
	or d
	ld [hl], a

.asm_3916
	ld a, $f0
	and e
	jr z, .asm_3920
	ld a, [hl]
	swap d
	or d
	ld [hl], a

.asm_3920
	pop de
	jp Func_377a

.unk_3924
	db $01, $02, $04, $08
	db $01, $02, $04, $08

Func_392c::
	ld hl, wce9c
	add hl, bc
	ld [hl], 0
	ret

Func_3933::
	push bc
	ld d, b
	ld c, $08
	ld h, b
	ld l, b
.asm_3939
	add hl, hl
	add a
	jr nc, .asm_393e
	add hl, de

.asm_393e
	dec c
	jr nz, .asm_3939
	ld a, l
	and $f0
	or h
	swap a
	pop bc
	ret

Func_3949::
	ld e, a
	ld d, b
	ld a, c
	and $03
	cp $03
	jr z, .asm_397a

	ld hl, $4000
	add hl, de
	add hl, de
	ld a, [wcf7c]
	push af
	ld a, $78
	ld [rROMB0], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop af
	ld [rROMB0], a
	ld hl, wceec
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr nz, .asm_3975
	add e
	ld e, a
	ret nc
	inc d
	ret

.asm_3975
	add e
	ld e, a
	ret c
	dec d
	ret

.asm_397a
	ld hl, wcf1c
	add hl, bc
	ld a, [hl]
	ld hl, .unk_398a
	add hl, de
	add a
	add a
	add a
	or [hl]
	ld e, a
	ld d, b
	ret

.unk_398a:
	db $d7, $d6, $d5, $d4, $c7, $c6, $c5, $d2, $b7, $c3
	db $b5, $b4, $a7, $a6, $a5, $a4, $97, $96, $95, $c0
	db $87, $86, $85, $92, $77, $76, $75, $a0, $67, $73
	db $65, $81, $57, $56, $55, $71, $47, $53, $45, $70
	db $37, $43, $35, $34, $27, $26, $25, $24, $17, $16
	db $15, $14, $07, $06, $05, $04, $03, $11, $01, $00

Func_39c6::
	push hl
	ld hl, wcf04
	add hl, bc
	ld a, [hl]
	ld hl, wcf0c
	add hl, bc
	ld [hl], a
	pop hl
	ret

Func_39d3::
	ld hl, wcf0c

Func_39d6:
	add hl, bc
	dec [hl]
	ret nz

	push hl
	ld hl, wce9c
	add hl, bc
	bit 1, [hl]
	jr nz, .asm_39e4
	set 1, [hl]

.asm_39e4
	ld hl, wcefc
	add hl, bc
	ld a, [hl]
	pop hl
	ld [hl], a
	ld hl, wcef4
	add hl, bc
	ld e, [hl]
	ld hl, wce9c
	add hl, bc
	ld a, [hl]
	xor $04
	ld [hl], a
	ld hl, wcedc
	add hl, bc
	add hl, bc
	bit 2, a
	jr z, .asm_3a0a
	ld a, [hli]
	add e
	ld e, a
	ld a, [hl]
	adc $00
	ld d, a
	jr .asm_3a11

.asm_3a0a
	ld a, [hli]
	sub e
	ld e, a
	ld a, [hl]
	sbc $00
	ld d, a

.asm_3a11
	call Func_3aa3
	push bc
	res 2, c
	ld a, c
	add a
	add a
	add c
	add $13
	ld c, a
	ld a, e
	ld [c], a
	inc c
	ld a, d
	ld [c], a
	pop bc
	ret

Func_3a25::
	ld hl, wcf3c
	add hl, bc
	ld [hl], 1
	ld hl, wcf44
	add hl, bc
	ld [hl], 0
	ret

Func_3a32::
	ld hl, wcf3c
	add hl, bc
	dec [hl]
	ret nz

	push hl
	ld hl, wcf34
	add hl, bc
	ld a, [hl]
	pop hl
	ld [hl], a
	ld hl, wcf44
	add hl, bc
	ld e, [hl]
	ld a, e
	cp $20
	ret nc

	inc [hl]
	ld a, [wcf7c]
	push af
	ld a, $78
	ld [rROMB0], a
	ld hl, wcf2c
	add hl, bc
	ld l, [hl]
	ld h, b
	add hl, hl
	add hl, hl
	add hl, hl

Func_3a5c:
	add hl, hl

Func_3a5d:
	srl e
	push af
	ld d, b
	add hl, de
	ld de, $4312
	add hl, de
	pop af
	ld a, [hl]
	jr nc, .asm_3a6c
	swap a

.asm_3a6c
	and $0f
	ld d, a
	pop af
	ld [wcf7c], a
	ld hl, wcf14
	add hl, bc
	ld a, [hl]
	swap a
	and $0f
	ld e, a
	xor a
	inc d
.asm_3a7f
	add e
	dec d
	jr nz, .asm_3a7f

	call Func_3aa3
	push bc
	and $f0
	push af
	ld hl, wcedd
	add hl, bc
	add hl, bc
	ld e, [hl]
	set 7, e
	res 2, c
	ld a, c
	add a
	add a
	add c
	add $12
	ld c, a
	pop af
	ld [c], a
	inc c
	inc c
	ld a, e
	ld [c], a
	pop bc
	ret

Func_3aa3::
	bit 2, c
	ret z
	ld hl, wce98
	add hl, bc
	bit 7, [hl]
	ret z
	pop hl
	ret

Func_3aaf::
	call Func_3aa3
	ld a, c
	and $03
	jr z, .asm_3ac0
	cp $02
	jr c, .asm_3aec
	jr z, .asm_3b11
	jp Func_3b45

.asm_3ac0
	ld hl, wcedc
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	bit 7, d
	jr z, .asm_3ae5

	res 7, [hl]
	ld hl, wcf4c
	add hl, bc
	ld a, [hl]
	ldh [rNR10], a
	ld hl, wcf1c
	add hl, bc
	ld a, [hl]
	rrca
	rrca
	ldh [rNR11], a
	ld hl, wcf14
	add hl, bc
	ld a, [hl]
	ldh [rNR12], a

.asm_3ae5
	ld a, e
	ldh [rNR13], a
	ld a, d
	ldh [rNR14], a
	ret

.asm_3aec
	ld hl, wcedc
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	bit 7, d
	jr z, .asm_3b0a

	res 7, [hl]
	ld hl, wcf1c
	add hl, bc
	ld a, [hl]
	rrca
	rrca
	ldh [rNR21], a
	ld hl, wcf14
	add hl, bc
	ld a, [hl]
	ldh [rNR22], a

.asm_3b0a
	ld a, e
	ldh [rNR23], a
	ld a, d
	ldh [rNR24], a
	ret

.asm_3b11
	ld hl, wcedc
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	bit 7, d
	jr z, .asm_3b3e

	res 7, [hl]
	ld hl, wcf1c
	add hl, bc
	ld a, [wcf7b]
	cp [hl]
	push de
	ld a, [hl]
	call nz, Func_3b75
	pop de
	ld hl, wcf14
	add hl, bc
	ld a, [hl]
	rrca
	cpl
	add $20
	and $60
	ldh [rNR32], a
	ld a, $80
	ldh [rNR30], a

.asm_3b3e
	ld a, e
	ldh [rNR33], a
	ld a, d
	ldh [rNR34], a
	ret

Func_3b45::
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

Func_3b62::
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
	push bc
	ld [wcf7b], a
	ld l, a
	ld h, 0
REPT 4
	add hl, hl
ENDR
	ld bc, $4252
	add hl, bc
	ld a, $78
	ld [rROMB0], a
	ld c, $30
	ld b, $10
.copy
	ld a, [hli]
	ld [c], a
	inc c
	dec b
	jr nz, .copy

	ld a, [wcf7c]
	ld [rROMB0], a
	pop bc
	ret

Func_3b9b::
	ld hl, wcf4f
	dec [hl]
	ret nz

	dec hl
	ld a, [hli]
	ld [hl], a
	ld hl, wce9b
	bit 2, [hl]
	jr nz, .asm_3bcf
	ld a, [wcf4d]
	and $0f
	jr z, .asm_3bbc

	ld a, [wcf4d]
	sub $11
	ld [wcf4d], a
	ldh [rNR50], a
	ret

.asm_3bbc
	ld hl, wce9b
	res 1, [hl]
	call Func_3d77
	call Func_3dda
	ld a, $77
	ld [wcf4d], a
	ldh [rNR50], a
	ret

.asm_3bcf
	ld hl, wcf4d
	ld a, [hl]
	cp $77
	jr z, .asm_3bdd
	add $11
	ld [hl], a
	ldh [rNR50], a
	ret

.asm_3bdd
	ld hl, wce9b
	res 1, [hl]
	ret

Func_3be3::
	ld a, [wce91]
.asm_3be6:
	ld e, a
	ld a, [wce92]
	cp e
	ret z
	ld d, 0
	ld hl, wce81
	add hl, de
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, b
	swap a
	and $0f
	call Func_3c08
	ld hl, wce91
	ld a, [hl]
	inc a
	and $07
	ld [hl], a
	jr .asm_3be6

Func_3c08::
	ld d, 0
	ld e, a
	ld hl, .unk_3c14
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.unk_3c14
	dw Func_3cbf
	dw Func_3d77
	dw Func_3d8f
	dw Func_3d95
	dw Func_3c24
	dw Func_3db5
	dw Func_3dda
	dw Func_3da4

Func_3c24::
	ld a, b
	and $0f
	ld [wce96], a
	ld a, c
	ld [wce97], a
	ld hl, $4135
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, $78
	ld [rROMB0], a
	ld a, [hli]
	ld [wce93], a
	ld a, [hli]
	ld [wce94], a
	ld a, [hl]
	ld [wcf7c], a
	ld [rROMB0], a
	ld a, [wce93]
	ld l, a
	ld a, [wce94]
	ld h, a
	ld a, [hli]
	ld e, a
	push hl
	ld bc, $0000
	ld a, [wce96]
	ld d, a
.asm_3c5c:
	rrc e
	jr nc, .asm_3c72
	ld hl, wce9c
	add hl, bc
	bit 7, [hl]
	jr z, .asm_3c70
	ld hl, wcf75
	add hl, bc
	ld a, [hl]
	cp d
	jr c, .asm_3c72

.asm_3c70
	set 3, e
.asm_3c72
	inc c
	ld a, 4
	cp c
	jr nz, .asm_3c5c

	ld a, e
	ld [wce95], a
	ld a, [wce95]
	and $0f
	ld e, a
	swap a
	or e
	ld [wcf79], a
	ld hl, wcf71
	ld a, [wce95]
	ld d, a
	ld bc, $0000
.asm_3c92:
	rrc d
	jr nc, .asm_3ca6

	ld hl, wcf75
	add hl, bc
	ld a, [wce96]
	ld [hl], a
	ld hl, wcf71
	add hl, bc
	ld a, [wce97]
	ld [hl], a

.asm_3ca6:
	inc c
	ld a, 4
	cp c
	jr nz, .asm_3c92

	pop hl
	ld a, [wce95]
	ld b, a
	swap b
	ld a, [wce93]
	ld e, a
	ld a, [wce94]
	ld d, a
	ld c, 0
	jr Func_3cf6

Func_3cbf::
	push bc
	call Func_3d77
	pop bc
	ld hl, wcea0
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, wce9b
	res 0, [hl]
	ld hl, $40c0
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, $78
	ld [rROMB0], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld [rROMB0], a
	ld [wcf7c], a
	ld h, d
	ld l, e
	ld a, [hli]
	ld b, a
	swap a
	or b
	ld b, a
	ld [wcf7a], a
	ld c, 4

Func_3cf6::
	rrc b
	jr nc, .asm_3d14
	bit 3, b
	jr z, .asm_3d12
	push bc
	push de
	push hl
	ld a, [hli]
	add e
	ld e, a
	ld a, [hli]
	adc d
	ld d, a
	ld b, $00
	ld a, [wcf7c]
	call Func_3d1b
	pop hl
	pop de
	pop bc

.asm_3d12
	inc hl
	inc hl
.asm_3d14
	inc c
	ld a, c
	and $03
	jr nz, Func_3cf6
	ret

Func_3d1b::
	ld hl, wceb4
	add hl, bc
	add hl, bc
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hl], a
	ld de, $0008
	ld hl, wcea4
	add hl, bc
	ld [hl], $29
	add hl, de
	ld [hl], $00
	ld hl, wcecc
	add hl, bc
	ld [hl], $01
	ld hl, wcf24
	add hl, bc
	ld [hl], $10
	xor a
	ld hl, wcf51
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wceec
	add hl, bc
	ld [hl], a
	ld hl, wcf2c
	add hl, bc
	ld [hl], a
	ld hl, wce9c
	add hl, bc
	ld [hl], $80
	ld hl, wcef4
	add hl, bc
	ld [hl], $05
	add hl, de
	ld [hl], $01
	add hl, de
	ld [hl], $1e
	add hl, de
	add hl, de
	ld [hl], $f0
	add hl, de
	ld [hl], b
	ld a, c
	and $03
	ret nz
	ld hl, wcf4c
	add hl, bc
	ld [hl], $08
	ret

Func_3d77::
	ld bc, $0004
	call Func_3b62
	inc c
	call Func_3b62
	inc c
	call Func_3b62
	inc c
	call Func_3b62
	ld hl, wce9b
	set 0, [hl]
	ret

Func_3d8f::
	ld hl, wce9b
	res 0, [hl]
	ret

Func_3d95::
	ld hl, wce9b
	set 1, [hl]
	res 2, [hl]

Func_3d9c::
	ld a, c
	ld [wcf4e], a
	ld [wcf4f], a
	ret

Func_3da4::
	ld hl, wce9b
	set 1, [hl]
	set 2, [hl]
	res 0, [hl]
	xor a
	ld [wcf4d], a
	ldh [rNR50], a
	jr Func_3d9c

Func_3db5::
	ld a, c
	ld [wce93], a
	ld bc, $0000
.asm_3dbc
	ld hl, wcf71
	add hl, bc
	ld a, [wce93]
	cp [hl]
	jr nz, .asm_3dd3
	ld hl, wce9c
	add hl, bc
	bit 7, [hl]
	jr z, .asm_3dd3
	ld [hl], 0
	call Func_3b62

.asm_3dd3
	inc c
	ld a, 4
	cp c
	jr nz, .asm_3dbc
	ret

Func_3dda::
	ld bc, $0000
.asm_3ddd
	ld hl, wce9c
	add hl, bc
	bit 7, [hl]
	jr z, .asm_3dea
	ld [hl], 0
	call Func_3b62

.asm_3dea
	inc c
	ld a, 4
	cp c
	jr nz, .asm_3ddd
	ret

Func_3df1::
	ld a, [wce9b]
	ret

Func_3df5::
	ld c, a
	ld b, 0
	jr Func_3e20

Func_3dfa::
	ld bc, $1000
	jr Func_3e20

Func_3dff::
	ld bc, $2000
	jr Func_3e20

Func_3e04::
	ld c, a
	ld b, $30
	jr Func_3e20

Func_3e09::
	ld a, $40
	or b
	ld b, a
	jr Func_3e20

Func_3e0f::
	ld c, a
	ld b, $50
	jr Func_3e20

Func_3e14::
	ld bc, $6000
	jr Func_3e20

Func_3e19::
	push bc
	call Func_3df5
	pop bc
	ld b, $70

Func_3e20::
	ld a, [wce92]
	ld e, a
	ld d, 0
	ld hl, wce81
	add hl, de
	add hl, de
	ld [hl], c
	inc hl
	ld [hl], b
	inc a
	and $07
	ld [wce92], a
	ret

Func_3e35::
	di
	ld a, $83
	ldh [rNR52], a
	ld a, $77
	ldh [rNR50], a
	ld a, $33
	ldh [rNR51], a
	ld a, $08
	ldh [rNR10], a
	ld a, $c0
	ldh [rNR11], a
	ld a, $ff
	ldh [rNR13], a
	ld a, $c0
	ldh [rNR21], a
	ld a, $ff
	ldh [rNR23], a
.asm_3e56
	ld a, [hl]
	swap a
	and $f0
	call Func_3e6b
	ld a, [hli]
	and $f0
	call Func_3e6b
	dec bc
	ld a, b
	or c
	jr nz, .asm_3e56
	ei
	ret

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
	ld de, wcea0
	call Func_3f05
	ld de, wcea8
	call Func_3f05
	ld de, wceb0
	call Func_3f05
	ld de, wcec0
	ld b, $0c
	call Func_3f05.asm_3f07
	ld de, wced0
	call Func_3f05
	ld de, wced8
	call Func_3f05
	ld de, wcee4
	ld b, $08
	call Func_3f05.asm_3f07
	ld de, wcef0
	call Func_3f05
	ld de, wcef8
	call Func_3f05
	ld de, wcf00
	call Func_3f05
	ld de, wcf08
	call Func_3f05
	ld de, wcf18
	call Func_3f05
	ld de, wcf20
	call Func_3f05
	ld de, wcf28
	call Func_3f05
	ld de, wcf30
	call Func_3f05
	ld de, wcf38
	call Func_3f05
	ld de, wcf40
	call Func_3f05
	ld de, wcf48
	call Func_3f05
	ld a, [wcf50]
	ld [hli], a
	ld de, wcf61
	ld b, $10
	call Func_3f05.asm_3f07
	ld a, [wcf7a]
	ld [hli], a
	ret

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
	ld de, wcea0
	call Func_3f8f
	ld de, wcea8
	call Func_3f8f
	ld de, wceb0
	call Func_3f8f
	ld de, wcec0
	ld b, $0c
	call Func_3f8f.asm_3f91
	ld de, wced0
	call Func_3f8f
	ld de, wced8
	call Func_3f8f
	ld de, wcee4
	ld b, $08
	call Func_3f8f.asm_3f91
	ld de, wcef0
	call Func_3f8f
	ld de, wcef8
	call Func_3f8f
	ld de, wcf00
	call Func_3f8f
	ld de, wcf08
	call Func_3f8f
	ld de, wcf18
	call Func_3f8f
	ld de, wcf20
	call Func_3f8f
	ld de, wcf28
	call Func_3f8f
	ld de, wcf30
	call Func_3f8f
	ld de, wcf38
	call Func_3f8f
	ld de, wcf40
	call Func_3f8f
	ld de, wcf48
	call Func_3f8f
	ld a, [wcf50]
	ld [hli], a
	ld de, wcf61
	ld b, $10
	call Func_3f8f.asm_3f91
	ld a, [hli]
	ld [wcf7a], a
	ret

Func_3f8f:
	ld b, 4
.asm_3f91
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_3f91
	ret
