; 2bpp decompression
; see tools/decompress.py and tools/compress.py for a python implementation

Decompress_CopyBytesDirectly::
; Copy a bytes directly from de to hl
	and $3f
	inc a
	ld b, a
	srl b
	jr nc, .even
; odd length
	ld a, [de]
	inc de
	ld [hli], a

.even
	jp z, Func_0f79.next_byte

.copy
REPT 2
	ld a, [de]
	inc de
	ld [hli], a
ENDR
	dec b
	jr z, Func_0f79.next_byte

REPT 2
	ld a, [de]
	inc de
	ld [hli], a
ENDR
	dec b
	jr z, Func_0f79.next_byte

REPT 2
	ld a, [de]
	inc de
	ld [hli], a
ENDR
	dec b
	jr z, Func_0f79.next_byte

REPT 2
	ld a, [de]
	inc de
	ld [hli], a
ENDR
	dec b
	jr nz, .copy

; Next byte
	ld a, [de]
	bit 7, a
	jr nz, Decompress_CopyProcessedBytes
	bit 6, a
	jp nz, Func_0f79.repeat_1_byte
	jr Func_0f79.repeat_2_bytes

Decompress_CopyProcessedBytes::
	inc de
	bit 6, a
	jr nz, Decompress_CopyBytesDirectly

; Repeat previous bytes
	and $3f
	ld b, a
	ld a, [de]
	inc de
	add l
	ld c, a
	ld a, [de]
	inc de
	adc h
	push de
	ld d, a
	ld e, c
REPT 4
	ld a, [de]
	ld [hli], a
	inc de
ENDR
	srl b
	jr nc, .even
; odd length
	ld a, [de]
	ld [hli], a
	inc de

.even
	jr z, .next_byte

.copy
REPT 2
	ld a, [de]
	ld [hli], a
	inc de
ENDR
	dec b
	jr z, .next_byte
REPT 2
	ld a, [de]
	ld [hli], a
	inc de
ENDR
	dec b
	jr nz, .copy

.next_byte
	pop de
	ld a, [de]
	bit 7, a
	jr nz, Decompress_CopyProcessedBytes
	bit 6, a
	jr nz, Func_0f79.repeat_1_byte
	jr Func_0f79.repeat_2_bytes

Func_0f79::
; 2bpp decompression entry
	push hl
	di
	ldh [hROMBank], a
	ld [rROMB0], a
	ei
	xor a
	ld [rROMB1], a
; swap hl and de
	ld a, e
	ld e, l
	ld l, a
	ld a, h
	ld h, d
	ld d, a

.next_byte
	ld a, [de]
	bit 7, a
	jr nz, Decompress_CopyProcessedBytes
	bit 6, a
	jr nz, .repeat_1_byte

.repeat_2_bytes:
; Copy the same 2 bytes
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
	jr z, .next_byte

.copy_2
	ld [hli], a
	ld [hli], a
	dec b
	jr z, .next_byte
	ld [hli], a
	ld [hli], a
	dec b
	jr z, .next_byte
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .copy_2

; Next byte
	ld a, [de]
	bit 7, a
	jp nz, Decompress_CopyProcessedBytes
	bit 6, a
	jr nz, .repeat_1_byte
	jr .repeat_2_bytes

.repeat_1_byte:
; Copy the same byte
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
REPT 2
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
ENDR

.copy_1
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	dec c
	jr z, .nextbyte_1
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	dec c
	jr nz, .copy_1

.nextbyte_1
	pop de
	inc de
	ld a, [de]
	bit 7, a
	jp nz, Decompress_CopyProcessedBytes
	bit 6, a
	jr nz, .repeat_1_byte
	jr .repeat_2_bytes

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
