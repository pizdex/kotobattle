; rst vectors (called through the rst instruction)

SECTION "rst0", ROM0[$0000]
JumpTable::
; pc = [(a * 2) + de]
	add a
	pop hl
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld h, [hl]
; SECTION "rst8", ROM0[$0008]
	ld l, a
	jp hl

SECTION "rst10", ROM0[$0010]
Func_0010::
	ldh a, [hff8e]
	ldh [hffc3], a
	ld a, b
	ldh [hff8e], a
	ld [rROMB0], a
	ld bc, $001f
	push bc
	jp hl

Func_001f::
	ldh a, [hffc3]
	ldh [hff8e], a
	ld [rROMB0], a
	ret

	db $1f

SECTION "rst28", ROM0[$0028]
Func_0028::
	ld c, 0
.asm_002a
	ld a, [hli]
	cp b
	jr z, .ret
	ld [de], a
	inc de
	inc c
	jr .asm_002a

.ret
	ret


; Game Boy hardware interrupts

SECTION "vblank", ROM0[$0040]
	jp VBlank
	db $b8

SECTION "lcd", ROM0[$0048]
	jp LCD
	db $b8

SECTION "timer", ROM0[$0050]
	reti
	db $72

SECTION "serial", ROM0[$0058]
	jp Serial
	db $b8

SECTION "joypad", ROM0[$0060]
	reti

PointerTable::
; hl = [(a * 2) + de]
	ld h, 0
	ld l, a
	add hl, hl
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld h, d
	ld l, e
	ret

FarPointerTable::
	di
	ld [rROMB0], a
	ld a, b
	call PointerTable
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

FarCopyBytes16::
	di
	ld [rROMB0], a
	call CopyBytes16
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

CopyBytes16::
	inc b
	inc c
	jr .start

.copy
	ld a, [hli]
	ld [de], a
	inc de
.start
	dec c
	jr nz, .copy
	dec b
	jr nz, .copy
	ret

FarCopyBytes8::
	di
	ld [rROMB0], a
	call CopyBytes8
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

CopyBytes8::
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, CopyBytes8
	ret

ClearBytes::
	xor a
	inc b
	inc c
	jr .start

.clear
	ld [hli], a
.start
	dec c
	jr nz, .clear
	dec b
	jr nz, .clear
	ret

FillBytes::
	ld a, d
	inc b
	inc c
	jr .asm_00bf

.asm_00be
	ld [hli], a
.asm_00bf
	dec c
	jr nz, .asm_00be
	dec b
	jr nz, .asm_00be
	ret

Func_00c6::
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	ret

Func_00cd::
	ld a, l
	sub e
	ld a, h
	sbc d
	ret

Func_00d2:
	ld a, h
	cp d
	ret nz
	ld a, l
	cp e
	ret nz
	ret

Func_00d9::
	bit 7, a
	ret z
	cpl
	inc a
	ret

Func_00df::
	di
	ld [rROMB0], a
	rst Func_0028
	ldh a, [hff8e]
	ld [rROMB0], a
	ei
	ret

	db $7e


SECTION "Header", ROM0[$0100]

Start::
	nop
	jp _Start

; The Game Boy cartridge header data is patched over by rgbfix.
; This makes sure it doesn't get used for anything else.

	ds $0150 - @, $00
