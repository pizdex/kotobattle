Func_0f_4000::
	dr $3c000, $3c01b

Func_0f_401b:
	dr $3c01b, $3ccbd

Func_0f_4cbd::
	dr $3ccbd, $3d229

Func_0f_5229::
	dr $3d229, $3db6f

Func_0f_5b6f::
	dr $3db6f, $3e2f5

Func_0f_62f5::
	dr $3e2f5, $3e7fb

Func_0f_67fb:
	ld hl, $d146
	ld de, unk_0f_79a2
	ld b, 8
	ld c, 6
	call PlaceTilemap
	ld hl, $d446
	ld de, unk_0f_79d2
	ld b, 8
	ld c, 6
	call PlaceTilemap

	ld a, [$d682]
	and a
	jr nz, .asm_6833

	ld d, $0e
	ld hl, $d488
	ld bc, 5
	call FillBytes
	ld d, $0e
	ld hl, $d4a8
	ld bc, 5
	call FillBytes
	jr .asm_6844

.asm_6833
	ld a, [wc1fe]
	and a
	jr nz, .asm_6844
	ld d, $0e
	ld hl, $d4a8
	ld bc, 5
	call FillBytes

.asm_6844
	ld a, [$d680]
	ld de, $d167
	jr Func_0f_686c

Func_0f_684c:
	dr $3e84c, $3e86c

Func_0f_686c:
	dr $3e86c, $3e899

Func_0f_6899:
	dr $3e899, $3f9a2

unk_0f_79a2:
	dr $3f9a2, $3f9d2

unk_0f_79d2:
	dr $3f9d2, $40000
