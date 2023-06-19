Func_7f_4000::
	call InitRegisters
	call WriteOAMDMACodeToHRAM
	call SetDoubleSpeed
	call ClearRAM

	ld a, $01
	ldh [rIE], a

	xor a
	ldh [hff8d], a
	ldh [hRAMBank], a
	ldh [hffa8], a
	ldh [hff91], a
	ldh [hff9d], a
	ldh [hff9e], a
	ldh [hff9f], a
	ldh [hffa9], a
	ldh [hffaa], a
	ldh [hffab], a
	ldh [hffac], a
	ldh [hffad], a
	ldh [hffae], a
	ldh [hffaf], a
	ldh [hffb0], a
	ldh [hffb1], a
	ldh [hffb2], a
	ldh [hffb3], a
	ldh [hffb4], a
	ldh [hffb5], a
	ldh [hffb6], a
	ldh [hffb7], a
	ldh [hffb8], a
	ldh [hffb9], a
	ldh [hffba], a
	ldh [hffbb], a
	ldh [hffbc], a
	ldh [hffbd], a
	ld [wc1d2], a
	ld [wc1d3], a
	ld [wc1d4], a
	ld [wc1d5], a
	ld [wc1d6], a
	ld [wc1dc], a
	call Func_0dfd

	ld a, BANK(w7d926)
	ldh [hRAMBank], a
	ldh [rSVBK], a
	xor a
	ld [w7d926], a
	ld a, $01
	ldh [hRAMBank], a
	ldh [rSVBK], a
	ret

InitRegisters:
	xor a
	ld [rROMB1], a
	ldh [rVBK], a
	ldh [rSVBK], a
	ldh [rTAC], a
	ldh [rIF], a
	ldh [rIE], a
	ldh [rSCY], a
	ldh [rSCX], a
	ldh [rWY], a
	ld a, $07
	ldh [rWX], a
	ret

WriteOAMDMACodeToHRAM:
	ld c, LOW(hTransferVirtualOAM)
	ld b, 10
	ld hl, .OAMDMACode
.copy
	ld a, [hli]
	ld [c], a
	inc c
	dec b
	jr nz, .copy
	ret

.OAMDMACode:
; This code is defined in ROM, but
; copied to and called from HRAM.
LOAD "OAM DMA", HRAM[$ff80]
hTransferVirtualOAM::
	ld a, $c0
	ldh [rDMA], a ; start DMA transfer
	ld a, 40 ; delay for 4*40 = 160 cycles
.wait
	dec a        ; 1 cycle
	jr nz, .wait ; 3 cycles
	ret
ENDL

ClearRAM:
; Clear VRAM bank 0
	ld hl, vTiles0
	ld bc, $1800
	call ClearBytes
	ld hl, vBGMap0
	ld bc, $0800
	call ClearBytes

; Clear VRAM bank 1
	ld a, $01
	ldh [rVBK], a
	ld hl, vTiles3
	ld bc, $1800
	call ClearBytes
	ld d, $08
	ld hl, vBGMap2
	ld bc, $0800
	call FillBytes

; Clear WRAM0
	ld hl, $c000
	ld bc, $0f00
	call ClearBytes
; Clear WRAM1 - WRAM7
	ld d, $07
.clearbank:
	ld a, d
	ldh [rSVBK], a
	ld hl, $d000
	ld bc, $1000
	call ClearBytes
	dec d
	jr nz, .clearbank
	ret

SetDoubleSpeed:
	ld hl, rKEY1
	bit 7, [hl] ; KEY1F_DBLSPEED
	jr nz, .ret

; Set to double
	set 0, [hl] ; KEY1F_PREPARE
	xor a
	ldh [rIF], a
	ldh [rIE], a
; Reset joypad
	ld a, $30
	ldh [rP1], a
	stop

.ret
	ret

unk_7f_40fa::
	dr $1fc0fa, $1fc1ee

Gfx_7f_41ee::
	INCBIN "gfx/encoded/encoded_7f_41ee.kb"

Gfx_7f_481d::
	INCBIN "gfx/encoded/encoded_7f_481d.kb"

Gfx_7f_511d::
	INCBIN "gfx/encoded/encoded_7f_511d.kb"

Gfx_7f_5d70:
	INCBIN "gfx/encoded/encoded_7f_5d70.kb"

unk_7f_5e2d:
	dr $1fde2d, $1fee08

Gfx_7f_6e08:
	INCBIN "gfx/encoded/encoded_7f_6e08.kb"

unk_7f_6f57:
	dr $1fef57, $200000
