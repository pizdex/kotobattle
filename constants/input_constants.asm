; joypad buttons
	const_def
	const D_RIGHT_F  ; 0
	const D_LEFT_F   ; 1
	const D_UP_F     ; 2
	const D_DOWN_F   ; 3
	const A_BUTTON_F ; 4
	const B_BUTTON_F ; 5
	const SELECT_F   ; 6
	const START_F    ; 7

NO_INPUT   EQU %00000000
D_RIGHT    EQU 1 << D_RIGHT_F
D_LEFT     EQU 1 << D_LEFT_F
D_UP       EQU 1 << D_UP_F
D_DOWN     EQU 1 << D_DOWN_F
A_BUTTON   EQU 1 << A_BUTTON_F
B_BUTTON   EQU 1 << B_BUTTON_F
SELECT     EQU 1 << SELECT_F
START      EQU 1 << START_F

BUTTONS    EQU A_BUTTON | B_BUTTON | SELECT | START
D_PAD      EQU D_RIGHT | D_LEFT | D_UP | D_DOWN

R_DPAD     EQU %00100000
R_BUTTONS  EQU %00010000
