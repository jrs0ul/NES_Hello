.segment "CHARS"
	.incbin "tiles.chr"

.segment "HEADER"
	.byte 'N','E','S', $1A
	.byte $01
	.byte $01
	.byte %00000000
	.byte $0, $0, $0, $0, $0, $0
	
.segment "VECTORS"
	.word nmi, reset, 0
	
.segment "RODATA"

palette:
	.byte $0F,$16,$21,$14, $0F,$16,$21,$14, $0F,$16,$21,$14, $0F,$16,$21,$14 ;background
	.byte $0F,$16,$20,$14, $0F,$16,$20,$14, $0F,$16,$20,$14, $0F,$16,$20,$14 ;sprites
	
.segment "ZEROPAGE"

Buttons:
	.res 1

.segment "BSS"

hello_Y:
	.res 1
hello_X:
	.res 1
	
	
.segment "CODE"



reset:
	sei
	cld
	ldx #255
	txs
	inx 
	stx $2000
	stx $2001
	stx $4010

vblankwait1:
	bit $2002
	bpl vblankwait1
	
clearmemory:
	lda #0
	sta $0000, x
	sta $0100, x
	sta $0300, x
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x
	lda #$FE
	sta $0200, x
	
	inx
	bne clearmemory

vblankwait2:
	bit $2002
	bpl vblankwait2
	
	
	jsr LoadPalette
	
	lda #100
	sta hello_Y
	sta hello_X
	
	
	jsr CreateWorld
	


	lda #%10010000
	sta $2000
	
	lda #%00011110
	sta $2001


	
forever:
	jmp forever
	
;----------------------------	
nmi:
	lda #$00
	sta $2003
	lda #$02
	sta $4014

	jsr ReadController
	jsr UpdateHello

	lda #0
	sta $2006
	sta $2006

	lda #%10010000
	sta $2000
	lda #%00011110
	sta $2001

	rti
	
;------------SUBROUTINES-----------------
LoadPalette:

	lda $2002
	
	lda #$3F
	sta $2006
	lda #$00
	sta $2006
	
	
	ldx #0
@loop:

	lda palette, x
	
	sta $2007
	
	inx
	cpx #32
	bne @loop
	
	rts
;--------------------------	
ReadController:
	lda #1
	sta $4016
	lda #0
	sta $4016
	
	ldx #8
@loop:
	lda $4016
	lsr
	rol Buttons
	dex
	bne @loop
	
	rts
;--------------------------
CreateWorld:

	lda $2002
	lda #$22
	sta $2006
	lda #$4B
	sta $2006
	
	ldx #1
@loop:	
	stx $2007
	inx
	cpx #6
	bcc @loop
	
	rts

;------------------------
UpdateHello:

	lda Buttons
	and #%00000001
	beq @checkLeft
	
	inc hello_X

@checkLeft:
	lda Buttons
	and #%00000010
	beq @checkDown
	
	dec hello_X
	
@checkDown:
	lda Buttons
	and #%00000100
	beq @checkUp
	
	inc hello_Y

@checkUp:
	lda Buttons
	and #%00001000
	beq @updateSprites
	
	dec hello_Y
	
@updateSprites:

	lda hello_Y
	sta $200
	lda #0
	sta $201
	sta $202
	lda hello_X
	sta $203
	
	lda hello_Y
	sta $204
	lda #1
	sta $205
	sta $206
	lda hello_X
	clc
	adc #8
	sta $207
	
	lda hello_Y
	sta $208
	lda #2
	sta $209
	sta $20A
	lda hello_X
	clc
	adc #16
	sta $20B
	
	lda hello_Y
	sta $20C
	lda #2
	sta $20D
	sta $20E
	lda hello_X
	clc
	adc #24
	sta $20F
	
	lda hello_Y
	sta $210
	lda #3
	sta $211
	sta $212
	lda hello_X
	clc
	adc #32
	sta $213
	
	
	
	rts
