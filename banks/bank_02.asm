unk_02_4000:
	dr $8000, $913c

Func_02_513c:
; Place tilemaps
	ld hl, $d000
	ld de, unk_02_5adb
	ld b, 20
	ld c, 5
	call PlaceTilemap
	ld hl, $d300
	ld de, unk_02_5b3f
	ld b, 20
	ld c, 5
	call PlaceTilemap

	call Func_02_54cb
	call Func_02_5738
	call Func_02_55d6
	call Func_02_572a
	ld a, $18
	ldh [hff97], a
	ld a, $10
	ldh [hff96], a
	call Func_02_5771
	ld de, $d06e
	call Func_02_56f0
	ret

Func_02_5174:
	xor a
	ldh [rVBK], a
	ld a, 2
	ld hl, image_02_69d9
	ld de, $8000
	ld bc, $110
	call FarCopyBytesVRAM

	ld a, $07
	ldh [hRAMBank], a
	ldh [rSVBK], a
	ld a, $7f
	ld hl, $7c77
	ld de, wcb56
	ld bc, $40
	call FarCopyBytes16
	ld hl, $609b
	ld de, wcb96
	ld c, $40
	call CopyBytes8

	ld a, $03
	ld [wcbda], a
	xor a
	ld [wcbdb], a
	ld [$d7ca], a
	ld [$d7cb], a
	ld [$d7cc], a
	ld [$d8fc], a
	ld [$d8fb], a
	ld hl, $d7cd
	ld bc, $08
	call ClearBytes

	ld a, $04
	ld [$d7c9], a
	ld a, $07
	ldh [hff9e], a
	ld a, $01
	ldh [hff9d], a
	ld a, $c3
	ldh [rLCDC], a
	ld a, $01
	ldh [hffaa], a
	ld a, $02
	call Func_3df5
	jp Func_02_513c

Func_02_51e2:
	dr $91e2, $94cb

Func_02_54cb:
	dr $94cb, $95d6

Func_02_55d6:
	dr $95d6, $96f0

Func_02_56f0:
	dr $96f0, $972a

Func_02_572a:
	dr $972a, $9738

Func_02_5738:
	dr $9738, $9771

Func_02_5771:
	dr $9771, $9adb

unk_02_5adb:
	dr $9adb, $9b3f

unk_02_5b3f:
	dr $9b3f, $a9d9

image_02_69d9:
	dr $a9d9, $c000
