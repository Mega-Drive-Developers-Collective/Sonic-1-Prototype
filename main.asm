;
; /-------------------------------------------------------------------------\
; |                     SONIC THE HEDGEHOG PROTOTYPE                        |
; |     Leaked by the famous drx and Hidden Palace on December 31st 2020    |
; |                   Split disassembly - Made by MDDC                      |
; |        With the fantastic help of RepellantMold and DeltaWooloo!        |
; \_________________________________________________________________________/
;
; ===========================================================================
; Segment type: Pure code
; segment "ROM"

ROM		section org(0)
			opt ae-		; temporary!!!
		include "tools/LANG.ASM"
		include "ObjSSTs.asm"

align		macro pos
		dcb.b ((\pos)-(offset(*)%(\pos)))%(\pos),$FF
	endm
; ---------------------------------------------------------------------------
; Header
		dc.l (StackPointer)&$FFFFFF, GameInit, BusErr, AddressErr
		dc.l IllegalInstr, ZeroDiv, ChkInstr, TrapvInstr, PrivilegeViol
		dc.l Trace, LineAEmu, LineFEmu, ErrorException, ErrorException
		dc.l ErrorException, ErrorException, ErrorException, ErrorException
		dc.l ErrorException, ErrorException, ErrorException, ErrorException
		dc.l ErrorException, ErrorException, ErrorException, ErrorTrap
		dc.l ErrorTrap, ErrorTrap, hint, ErrorTrap, vint, ErrorTrap
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap, ErrorTrap
		dc.b 'SEGA MEGA DRIVE '				; Console name
		dc.b '(C)SEGA 1989.JAN'				; Copyright/release date
		dc.b '                                                '; Domestic name
		dc.b '                                                '; International name
		dc.b 'GM 00000000-00'				; Serial code
Checksum:	dc.w 0
		dc.b 'J               '				; I/O support
dword_1A0:	dc.l 0, $7FFFF					; ROM region
		dc.l $FF0000, $FFFFFF				; RAM region
		dc.b '                                                               '
		dc.b ' '
		dc.b 'JU              '				; Region codes
; ---------------------------------------------------------------------------

ErrorTrap:
		nop
		nop
		bra.s	ErrorTrap
; ---------------------------------------------------------------------------

GameInit:
		tst.l	($A10008).l

loc_20C:
		bne.w	loc_306
		tst.w	($A1000C).l
		bne.s	loc_20C
		lea	InitValues(pc),a5
		movem.l	(a5)+,d5-a4
		move.w	-$1100(a1),d0
		andi.w	#$F00,d0
		beq.s	loc_232
		move.l	#'SEGA',$2F00(a1)

loc_232:
		move.w	(a4),d0
		moveq	#0,d0
		movea.l	d0,a6
		move.l	a6,usp
		moveq	#$17,d1

loc_23C:
		move.b	(a5)+,d5
		move.w	d5,(a4)
		add.w	d7,d5
		dbf	d1,loc_23C
		move.l	#$40000080,(a4)
		move.w	d0,(a3)
		move.w	d7,(a1)
		move.w	d7,(a2)

loc_252:
		btst	d0,(a1)
		bne.s	loc_252
		moveq	#$27,d2

loc_258:
		move.b	(a5)+,(a0)+
		dbf	d2,loc_258
		move.w	d0,(a2)
		move.w	d0,(a1)
		move.w	d7,(a2)

loc_264:
		move.l	d0,-(a6)
		dbf	d6,loc_264
		move.l	#$81048F02,(a4)
		move.l	#$C0000000,(a4)
		moveq	#$1F,d3

loc_278:
		move.l	d0,(a3)
		dbf	d3,loc_278
		move.l	#$40000010,(a4)
		moveq	#$13,d4

loc_286:
		move.l	d0,(a3)
		dbf	d4,loc_286
		moveq	#3,d5

loc_28E:
		move.b	(a5)+,$10(a3)
		dbf	d5,loc_28E
		move.w	d0,(a2)
		movem.l	(a6),d0-a6
		move	#$2700,sr
		bra.s	loc_306
; ---------------------------------------------------------------------------

InitValues:	dc.l $8000, $3FFF, $100
		dc.l $A00000					; Z80 RAM
		dc.l $A11100					; Z80 bus release
		dc.l $A11200					; Z80 reset
		dc.l $C00000					; VDP data port
		dc.l $C00004					; VDP command port
		dc.b 4, $14, $30, $3C, 7, $6C, 0, 0, 0, 0, $FF, 0, $81	; VDP commands
		dc.b $37, 0, 1, 1, 0, 0, $FF, $FF, 0, 0, $80
		dc.b $AF, 1, $D7, $1F, $11, $29, 0, $21, $28, 0, $F9, $77	; Z80 commands
		dc.b $ED, $B0, $DD, $E1, $FD, $E1, $ED, $47, $ED, $4F
		dc.b 8, $D9, $F1, $C1, $D1, $E1, 8, $D9, $F1, $D1, $E1
		dc.b $F9, $F3, $ED, $56, $36, $E9, $E9
		dc.b $9F, $BF, $DF, $FF
; ---------------------------------------------------------------------------

loc_306:
		btst	#6,($A1000D).l
		beq.s	DoChecksum
		cmpi.l	#'init',(ChecksumStr).w
		beq.w	loc_36A

DoChecksum:
		movea.l	#ErrorTrap,a0
		movea.l	#(dword_1A0+4),a1
		move.l	(a1),d0
		moveq	#0,d1

loc_32C:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bcc.s	loc_32C
		movea.l	#Checksum,a1
		cmp.w	(a1),d1
		nop
		nop
		lea	(StackPointer).w,a6
		moveq	#0,d7
		move.w	#$7F,d6

loc_348:
		move.l	d7,(a6)+
		dbf	d6,loc_348
		move.b	($A10001).l,d0
		andi.b	#$C0,d0
		move.b	d0,(ConsoleRegion).w
		move.w	#1,(word_FFFFE0).w
		move.l	#'init',(ChecksumStr).w

loc_36A:
		lea	((Chunks)&$FFFFFF).l,a6
		moveq	#0,d7
		move.w	#$3F7F,d6

loc_376:
		move.l	d7,(a6)+
		dbf	d6,loc_376
		bsr.w	vdpInit
		bsr.w	dacInit
		bsr.w	padInit
		move.b	#0,(GameMode).w

ScreensLoop:
		move.b	(GameMode).w,d0
		andi.w	#$1C,d0
		jsr	ScreensArray(pc,d0.w)
		bra.s	ScreensLoop
; ---------------------------------------------------------------------------

ScreensArray:
		bra.w	sSega
; ---------------------------------------------------------------------------
		bra.w	sTitle
; ---------------------------------------------------------------------------
		bra.w	sLevel
; ---------------------------------------------------------------------------
		bra.w	sLevel
; ---------------------------------------------------------------------------
		bra.w	sSpecial
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

ChecksumError:
		bsr.w	vdpInit
		move.l	#$C0000000,($C00004).l
		moveq	#$3F,d7

loc_3C2:
		move.w	#$E,($C00000).l
		dbf	d7,loc_3C2

loc_3CE:
		bra.s	loc_3CE
; ---------------------------------------------------------------------------

BusErr:
		move.b	#2,(byte_FFFC00+$44).w
		bra.s	ErrorAddress
; ---------------------------------------------------------------------------

AddressErr:
		move.b	#4,(byte_FFFC00+$44).w
		bra.s	ErrorAddress
; ---------------------------------------------------------------------------

IllegalInstr:
		move.b	#6,(byte_FFFC00+$44).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ZeroDiv:
		move.b	#8,(byte_FFFC00+$44).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ChkInstr:
		move.b	#$A,(byte_FFFC00+$44).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

TrapvInstr:
		move.b	#$C,(byte_FFFC00+$44).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

PrivilegeViol:
		move.b	#$E,(byte_FFFC00+$44).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

Trace:
		move.b	#$10,(byte_FFFC00+$44).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

LineAEmu:
		move.b	#$12,(byte_FFFC00+$44).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

LineFEmu:
		move.b	#$14,(byte_FFFC00+$44).w
		addq.l	#2,2(sp)
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ErrorException:
		move.b	#0,(byte_FFFC00+$44).w
		bra.s	ErrorNormal
; ---------------------------------------------------------------------------

ErrorAddress:
		move	#$2700,sr
		addq.w	#2,sp
		move.l	(sp)+,(byte_FFFC00+$40).w
		addq.w	#2,sp
		movem.l	d0-a7,(byte_FFFC00).w
		bsr.w	ErrorPrint
		move.l	2(sp),d0
		bsr.w	ErrorPrintAddr
		move.l	(byte_FFFC00+$40).w,d0
		bsr.w	ErrorPrintAddr
		bra.s	loc_472
; ---------------------------------------------------------------------------

ErrorNormal:
		move	#$2700,sr
		movem.l	d0-a7,(byte_FFFC00).w
		bsr.w	ErrorPrint
		move.l	2(sp),d0
		bsr.w	ErrorPrintAddr

loc_472:
		bsr.w	ErrorWaitInput
		movem.l	(byte_FFFC00).w,d0-a7
		move	#$2300,sr
		rte
; ---------------------------------------------------------------------------

ErrorPrint:
		lea	($C00000).l,a6
		move.l	#$78000003,($C00004).l
		lea	(ArtText).l,a0
		move.w	#$27F,d1

@loadart:
		move.w	(a0)+,(a6)
		dbf	d1,@loadart
		moveq	#0,d0
		move.b	(byte_FFFC00+$44).w,d0
		move.w	ErrorMessages(pc,d0.w),d0
		lea	ErrorMessages(pc,d0.w),a0
		move.l	#$46040003,($C00004).l
		moveq	#$12,d1

@loadtext:
		moveq	#0,d0
		move.b	(a0)+,d0
		addi.w	#$790,d0
		move.w	d0,(a6)
		dbf	d1,@loadtext
		rts
; ---------------------------------------------------------------------------

ErrorMessages:	dc.w strErrorException-ErrorMessages, strBusErr-ErrorMessages, strAddressErr-ErrorMessages
		dc.w strIllegalInstr-ErrorMessages, strZeroDiv-ErrorMessages, strChkInstr-ErrorMessages, strTrapvInstr-ErrorMessages
		dc.w strPrivilegeViol-ErrorMessages, strTrace-ErrorMessages, strLineAEmu-ErrorMessages, strLineFEmu-ErrorMessages

strErrorException:dc.b 'ERROR EXCEPTION    '

strBusErr:	dc.b 'BUS ERROR          '

strAddressErr:	dc.b 'ADDRESS ERROR      '

strIllegalInstr:dc.b 'ILLEGAL INSTRUCTION'

strZeroDiv:	dc.b '@ERO DIVIDE        '

strChkInstr:	dc.b 'CHK INSTRUCTION    '

strTrapvInstr:	dc.b 'TRAPV INSTRUCTION  '

strPrivilegeViol:dc.b 'PRIVILEGE VIOLATION'

strTrace:	dc.b 'TRACE              '

strLineAEmu:	dc.b 'LINE 1010 EMULATOR '

strLineFEmu:	dc.b 'LINE 1111 EMULATOR '
		even
; ---------------------------------------------------------------------------

ErrorPrintAddr:
		move.w	#$7CA,(a6)
		moveq	#7,d2

loc_5BA:
		rol.l	#4,d0
		bsr.s	sub_5C4
		dbf	d2,loc_5BA
		rts
; ---------------------------------------------------------------------------

sub_5C4:
		move.w	d0,d1
		andi.w	#$F,d1
		cmpi.w	#$A,d1
		bcs.s	loc_5D2
		addq.w	#7,d1

loc_5D2:
		addi.w	#$7C0,d1
		move.w	d1,(a6)
		rts
; ---------------------------------------------------------------------------

ErrorWaitInput:
		bsr.w	padRead
		cmpi.b	#$20,(padPress1).w
		bne.w	ErrorWaitInput
		rts
; ---------------------------------------------------------------------------
ArtText:	incbin "unsorted/debugtext.unc"
		even
; ---------------------------------------------------------------------------

vint:
		movem.l	d0-a6,-(sp)
		tst.b	(VintRoutine).w
		beq.s	loc_B58
		move.w	($C00004).l,d0
		move.l	#$40000010,($C00004).l
		move.l	(dword_FFF616).w,($C00000).l
		btst	#6,(ConsoleRegion).w
		beq.s	loc_B3C
		move.w	#$700,d0

loc_B38:
		dbf	d0,loc_B38

loc_B3C:
		move.b	(VintRoutine).w,d0
		move.b	#0,(VintRoutine).w
		move.w	#1,(word_FFF648).w
		andi.w	#$3E,d0
		move.w	off_B6A(pc,d0.w),d0
		jsr	off_B6A(pc,d0.w)

loc_B58:
		addq.l	#1,(unk_FFFE0C).w
		jsr	SoundSource
		movem.l	(sp)+,d0-a6
		rte
; ---------------------------------------------------------------------------

nullsub_3:
		rts
; ---------------------------------------------------------------------------

off_B6A:	dc.w nullsub_3-off_B6A, loc_B7E-off_B6A, sub_B90-off_B6A, sub_BAA-off_B6A, loc_BBA-off_B6A
		dc.w loc_CBC-off_B6A, sub_D88-off_B6A, sub_E58-off_B6A, sub_BB0-off_B6A, sub_E70-off_B6A
; ---------------------------------------------------------------------------

loc_B7E:
		bsr.w	sub_E78
		tst.w	(GlobalTimer).w
		beq.w	locret_B8E
		subq.w	#1,(GlobalTimer).w

locret_B8E:
		rts
; ---------------------------------------------------------------------------

sub_B90:
		bsr.w	sub_E78
		bsr.w	sub_43B6
		bsr.w	sub_1438
		tst.w	(GlobalTimer).w
		beq.w	locret_BA8
		subq.w	#1,(GlobalTimer).w

locret_BA8:
		rts
; ---------------------------------------------------------------------------

sub_BAA:
		bsr.w	sub_E78
		rts
; ---------------------------------------------------------------------------

sub_BB0:
		cmpi.b	#$10,(GameMode).w
		beq.w	loc_CBC

loc_BBA:
		bsr.w	padRead
		move.w	#$100,($A11100).l

loc_BC6:
		btst	#0,($A11100).l
		bne.s	loc_BC6
		lea	($C00004).l,a5
		move.l	#$94009340,(a5)
		move.l	#$96FD9580,(a5)
		move.w	#$977F,(a5)
		move.w	#$C000,(a5)
		move.w	#$80,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		lea	($C00004).l,a5
		move.l	#$940193C0,(a5)
		move.l	#$96E69500,(a5)
		move.w	#$977F,(a5)
		move.w	#$7C00,(a5)
		move.w	#$83,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		move.w	#$8407,(a5)
		move.w	(word_FFF624).w,(a5)
		move.w	(word_FFF61E).w,(word_FFF622).w
		lea	($C00004).l,a5
		move.l	#$94019340,(a5)
		move.l	#$96FC9500,(a5)
		move.w	#$977F,(a5)
		move.w	#$7800,(a5)
		move.w	#$83,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		tst.b	(unk_FFF767).w
		beq.s	loc_C7A
		lea	($C00004).l,a5
		move.l	#$94019370,(a5)
		move.l	#$96E49500,(a5)
		move.w	#$977F,(a5)
		move.w	#$7000,(a5)
		move.w	#$83,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		move.b	#0,(unk_FFF767).w

loc_C7A:
		move.w	#0,($A11100).l
		bsr.w	mapLevelLoad
		jsr	sub_1128C
		jsr	UpdateHUD
		bsr.w	loc_1454
		moveq	#0,d0
		move.b	(byte_FFF628).w,d0
		move.b	(byte_FFF629).w,d1
		cmp.b	d0,d1
		bcc.s	loc_CA8
		move.b	d0,(byte_FFF629).w

loc_CA8:
		move.b	#0,(byte_FFF628).w
		tst.w	(GlobalTimer).w
		beq.w	locret_CBA
		subq.w	#1,(GlobalTimer).w

locret_CBA:
		rts
; ---------------------------------------------------------------------------

loc_CBC:
		bsr.w	padRead
		move.w	#$100,($A11100).l

loc_CC8:
		btst	#0,($A11100).l
		bne.s	loc_CC8
		lea	($C00004).l,a5
		move.l	#$94009340,(a5)
		move.l	#$96FD9580,(a5)
		move.w	#$977F,(a5)
		move.w	#$C000,(a5)
		move.w	#$80,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		lea	($C00004).l,a5
		move.l	#$94019340,(a5)
		move.l	#$96FC9500,(a5)
		move.w	#$977F,(a5)
		move.w	#$7800,(a5)
		move.w	#$83,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		lea	($C00004).l,a5
		move.l	#$940193C0,(a5)
		move.l	#$96E69500,(a5)
		move.w	#$977F,(a5)
		move.w	#$7C00,(a5)
		move.w	#$83,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		move.w	#0,($A11100).l
		bsr.w	sSpecialPalCyc
		tst.b	(unk_FFF767).w
		beq.s	loc_D7A
		lea	($C00004).l,a5
		move.l	#$94019370,(a5)
		move.l	#$96E49500,(a5)
		move.w	#$977F,(a5)
		move.w	#$7000,(a5)
		move.w	#$83,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		move.b	#0,(unk_FFF767).w

loc_D7A:
		tst.w	(GlobalTimer).w
		beq.w	locret_D86
		subq.w	#1,(GlobalTimer).w

locret_D86:
		rts
; ---------------------------------------------------------------------------

sub_D88:
		bsr.w	padRead
		move.w	#$100,($A11100).l

loc_D94:
		btst	#0,($A11100).l
		bne.s	loc_D94
		lea	($C00004).l,a5
		move.l	#$94009340,(a5)
		move.l	#$96FD9580,(a5)
		move.w	#$977F,(a5)
		move.w	#$C000,(a5)
		move.w	#$80,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		lea	($C00004).l,a5
		move.l	#$94019340,(a5)
		move.l	#$96FC9500,(a5)
		move.w	#$977F,(a5)
		move.w	#$7800,(a5)
		move.w	#$83,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		lea	($C00004).l,a5
		move.l	#$940193C0,(a5)
		move.l	#$96E69500,(a5)
		move.w	#$977F,(a5)
		move.w	#$7C00,(a5)
		move.w	#$83,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		tst.b	(unk_FFF767).w
		beq.s	loc_E3A
		lea	($C00004).l,a5
		move.l	#$94019370,(a5)
		move.l	#$96E49500,(a5)
		move.w	#$977F,(a5)
		move.w	#$7000,(a5)
		move.w	#$83,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		move.b	#0,(unk_FFF767).w

loc_E3A:
		move.w	#0,($A11100).l
		bsr.w	mapLevelLoad
		jsr	sub_1128C
		jsr	UpdateHUD
		bsr.w	sub_1438
		rts
; ---------------------------------------------------------------------------

sub_E58:
		bsr.w	sub_E78
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		addq.b	#1,(byte_FFF628).w
		move.b	#$E,(VintRoutine).w
		rts
; ---------------------------------------------------------------------------

sub_E70:
		bsr.w	sub_E78
		bra.w	sub_1438
; ---------------------------------------------------------------------------

sub_E78:
		bsr.w	padRead
		move.w	#$100,($A11100).l

loc_E84:
		btst	#0,($A11100).l
		bne.s	loc_E84
		lea	($C00004).l,a5
		move.l	#$94009340,(a5)
		move.l	#$96FD9580,(a5)
		move.w	#$977F,(a5)
		move.w	#$C000,(a5)
		move.w	#$80,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		lea	($C00004).l,a5
		move.l	#$94019340,(a5)
		move.l	#$96FC9500,(a5)
		move.w	#$977F,(a5)
		move.w	#$7800,(a5)
		move.w	#$83,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		lea	($C00004).l,a5
		move.l	#$940193C0,(a5)
		move.l	#$96E69500,(a5)
		move.w	#$977F,(a5)
		move.w	#$7C00,(a5)
		move.w	#$83,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		move.w	#0,($A11100).l
		rts
; ---------------------------------------------------------------------------

hint:
		tst.w	(word_FFF648).w
		beq.s	locret_F3A
		move.l	a5,-(sp)
		lea	($C00004).l,a5
		move.l	#$94009340,(a5)
		move.l	#$96FD95C0,(a5)
		move.w	#$977F,(a5)
		move.w	#$C000,(a5)
		move.w	#$80,(word_FFF644).w
		move.w	(word_FFF644).w,(a5)
		movem.l	(sp)+,a5
		move.w	#0,(word_FFF648).w

locret_F3A:
		rte
; ---------------------------------------------------------------------------
		tst.w	(word_FFF648).w
		beq.s	locret_F7E
		movem.l	d0/a0/a5,-(sp)
		move.w	#0,(word_FFF648).w
		move.w	#$8405,($C00004).l
		move.w	#$857C,($C00004).l
		move.l	#$78000003,($C00004).l
		lea	(byte_FFF800).w,a0
		lea	($C00000).l,a5
		move.w	#$9F,d0

loc_F74:
		move.l	(a0)+,(a5)
		dbf	d0,loc_F74
		movem.l	(sp)+,d0/a0/a5

locret_F7E:
		rte
; ---------------------------------------------------------------------------

padInit:
		move.w	#$100,($A11100).l

loc_F88:
		btst	#0,($A11100).l
		bne.s	loc_F88
		moveq	#$40,d0
		move.b	d0,($A10009).l
		move.b	d0,($A1000B).l
		move.b	d0,($A1000D).l
		move.w	#0,($A11100).l
		rts
; ---------------------------------------------------------------------------

padRead:
		move.w	#$100,($A11100).l

loc_FB8:
		btst	#0,($A11100).l
		bne.s	loc_FB8
		lea	(padHeld1).w,a0
		lea	($A10003).l,a1
		bsr.s	sub_FDC
		addq.w	#2,a1
		bsr.s	sub_FDC
		move.w	#0,($A11100).l
		rts
; ---------------------------------------------------------------------------

sub_FDC:
		move.b	#0,(a1)
		nop
		nop
		move.b	(a1),d0
		lsl.b	#2,d0
		andi.b	#$C0,d0
		move.b	#$40,(a1)
		nop
		nop
		move.b	(a1),d1
		andi.b	#$3F,d1
		or.b	d1,d0
		not.b	d0
		move.b	(a0),d1
		eor.b	d0,d1
		move.b	d0,(a0)+
		and.b	d0,d1
		move.b	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

vdpInit:
		lea	($C00004).l,a0
		lea	($C00000).l,a1
		lea	($1080).l,a2
		moveq	#$12,d7

loc_101E:
		move.w	(a2)+,(a0)
		dbf	d7,loc_101E
		move.w	(vdpInitRegs+2).l,d0
		move.w	d0,(ModeReg2).w
		moveq	#0,d0
		move.l	#$C0000000,($C00004).l
		move.w	#$3F,d7

loc_103E:
		move.w	d0,(a1)
		dbf	d7,loc_103E
		clr.l	(dword_FFF616).w
		clr.l	(dword_FFF61A).w
		move.l	d1,-(sp)
		lea	($C00004).l,a5
		move.w	#$8F01,(a5)
		move.l	#$94FF93FF,(a5)
		move.w	#$9780,(a5)
		move.l	#$40000080,(a5)
		move.w	#0,($C00000).l

loc_1070:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	loc_1070
		move.w	#$8F02,(a5)
		move.l	(sp)+,d1
		rts
; ---------------------------------------------------------------------------

vdpInitRegs:	dc.w $8004, $8134, $8230, $8328, $8407
		dc.w $857C, $8600, $8700, $8800, $8900
		dc.w $8A00, $8B00, $8C81, $8D3F, $8E00
		dc.w $8F02, $9001, $9100, $9200
; ---------------------------------------------------------------------------

sub_10A6:
		lea	($C00004).l,a5
		move.w	#$8F01,(a5)
		move.l	#$940F93FF,(a5)
		move.w	#$9780,(a5)
		move.l	#$40000083,(a5)
		move.w	#0,($C00000).l

loc_10C8:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	loc_10C8
		move.w	#$8F02,(a5)
		lea	($C00004).l,a5
		move.w	#$8F01,(a5)
		move.l	#$940F93FF,(a5)
		move.w	#$9780,(a5)
		move.l	#$60000083,(a5)
		move.w	#0,($C00000).l

loc_10F6:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	loc_10F6
		move.w	#$8F02,(a5)
		move.l	#0,(dword_FFF616).w
		move.l	#0,(dword_FFF61A).w
		lea	(byte_FFF800).w,a1
		moveq	#0,d0
		move.w	#$A0,d1

loc_111C:
		move.l	d0,(a1)+
		dbf	d1,loc_111C
		lea	(ScrollTable).w,a1
		moveq	#0,d0
		move.w	#$100,d1

loc_112C:
		move.l	d0,(a1)+
		dbf	d1,loc_112C
		rts
; ---------------------------------------------------------------------------

dacInit:
		nop
		move.w	#$100,($A11100).l
		move.w	#$100,($A11200).l
		lea	(Z80Driver).l,a0
		lea	($A00000).l,a1
		move.w	#$1C5B,d0

loc_1156:
		move.b	(a0)+,(a1)+
		dbf	d0,loc_1156
		moveq	#0,d0
		lea	($A01FF8).l,a1
		move.b	d0,(a1)+
		move.b	#$80,(a1)+
		move.b	#7,(a1)+
		move.b	#$80,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.w	#0,($A11200).l
		nop
		nop
		nop
		nop
		move.w	#$100,($A11200).l
		move.w	#0,($A11100).l
		rts
; ---------------------------------------------------------------------------
		dc.b 3
		dc.b 0
		dc.b 0
		dc.b $14
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
; ---------------------------------------------------------------------------

PlayMusic:
		move.b	d0,(SoundMemory+$A).w
		rts
; ---------------------------------------------------------------------------

PlaySFX:
		move.b	d0,(SoundMemory+$B).w
		rts
; ---------------------------------------------------------------------------
		move.b	d0,(SoundMemory+$C).w
		rts
; ---------------------------------------------------------------------------

PauseGame:
		nop
		tst.b	(Lives).w
		beq.s	loc_1206
		tst.w	(PauseFlag).w
		bne.s	loc_11CC
		btst	#7,(padPress1).w
		beq.s	locret_120C

loc_11CC:
		move.w	#-1,(PauseFlag).w

loc_11D2:
		move.b	#$10,(VintRoutine).w
		bsr.w	vsync
		btst	#6,(padPress1).w
		beq.s	loc_11EE
		move.b	#4,(GameMode).w
		nop
		bra.s	loc_1206
; ---------------------------------------------------------------------------

loc_11EE:
		btst	#4,(padHeld1).w
		bne.s	loc_120E
		btst	#5,(padPress1).w
		bne.s	loc_120E
		btst	#7,(padPress1).w
		beq.s	loc_11D2

loc_1206:
		move.w	#0,(PauseFlag).w

locret_120C:
		rts
; ---------------------------------------------------------------------------

loc_120E:
		move.w	#1,(PauseFlag).w
		rts
; ---------------------------------------------------------------------------

LoadPlaneMaps:
		lea	($C00000).l,a6
		move.l	#$800000,d4

loc_1222:
		move.l	d0,4(a6)
		move.w	d1,d3

loc_1228:
		move.w	(a1)+,(a6)
		dbf	d3,loc_1228
		add.l	d4,d0
		dbf	d2,loc_1222
		rts
; ---------------------------------------------------------------------------

NemesisDec:
		movem.l	d0-a1/a3-a5,-(sp)
		lea	(sub_12F8).l,a3
		lea	($C00000).l,a4
		bra.s	loc_1252
; ---------------------------------------------------------------------------
		movem.l	d0-a1/a3-a5,-(sp)
		lea	(sub_130E).l,a3

loc_1252:
		lea	(byte_FFAA00).w,a1
		move.w	(a0)+,d2
		lsl.w	#1,d2
		bcc.s	loc_1260
		adda.w	#$A,a3

loc_1260:
		lsl.w	#2,d2
		movea.w	d2,a5
		moveq	#8,d3
		moveq	#0,d2
		moveq	#0,d4
		bsr.w	sub_1324
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		move.w	#$10,d6
		bsr.s	sub_1280
		movem.l	(sp)+,d0-a1/a3-a5
		rts
; ---------------------------------------------------------------------------

sub_1280:
		move.w	d6,d7
		subq.w	#8,d7
		move.w	d5,d1
		lsr.w	d7,d1
		cmpi.b	#$FC,d1
		bcc.s	loc_12CC
		andi.w	#$FF,d1
		add.w	d1,d1
		move.b	(a1,d1.w),d0
		ext.w	d0
		sub.w	d0,d6
		cmpi.w	#9,d6
		bcc.s	loc_12A8
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5

loc_12A8:
		move.b	1(a1,d1.w),d1
		move.w	d1,d0
		andi.w	#$F,d1
		andi.w	#$F0,d0

loc_12B6:
		lsr.w	#4,d0

loc_12B8:
		lsl.l	#4,d4
		or.b	d1,d4
		subq.w	#1,d3
		bne.s	loc_12C6
		jmp	(a3)
; ---------------------------------------------------------------------------

loc_12C2:
		moveq	#0,d4
		moveq	#8,d3

loc_12C6:
		dbf	d0,loc_12B8
		bra.s	sub_1280
; ---------------------------------------------------------------------------

loc_12CC:
		subq.w	#6,d6
		cmpi.w	#9,d6
		bcc.s	loc_12DA
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5

loc_12DA:
		subq.w	#7,d6
		move.w	d5,d1
		lsr.w	d6,d1
		move.w	d1,d0
		andi.w	#$F,d1
		andi.w	#$70,d0
		cmpi.w	#9,d6
		bcc.s	loc_12B6
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5
		bra.s	loc_12B6
; ---------------------------------------------------------------------------

sub_12F8:
		move.l	d4,(a4)
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	loc_12C2
		rts
; ---------------------------------------------------------------------------
		eor.l	d4,d2
		move.l	d2,(a4)
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	loc_12C2
		rts
; ---------------------------------------------------------------------------

sub_130E:
		move.l	d4,(a4)+
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	loc_12C2
		rts
; ---------------------------------------------------------------------------
		eor.l	d4,d2
		move.l	d2,(a4)+
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	loc_12C2
		rts
; ---------------------------------------------------------------------------

sub_1324:
		move.b	(a0)+,d0

loc_1326:
		cmpi.b	#$FF,d0
		bne.s	loc_132E
		rts
; ---------------------------------------------------------------------------

loc_132E:
		move.w	d0,d7

loc_1330:
		move.b	(a0)+,d0
		cmpi.b	#$80,d0
		bcc.s	loc_1326
		move.b	d0,d1
		andi.w	#$F,d7
		andi.w	#$70,d1
		or.w	d1,d7
		andi.w	#$F,d0
		move.b	d0,d1
		lsl.w	#8,d1
		or.w	d1,d7
		moveq	#8,d1
		sub.w	d0,d1
		bne.s	loc_135E
		move.b	(a0)+,d0
		add.w	d0,d0
		move.w	d7,(a1,d0.w)
		bra.s	loc_1330
; ---------------------------------------------------------------------------

loc_135E:
		move.b	(a0)+,d0
		lsl.w	d1,d0
		add.w	d0,d0
		moveq	#1,d5
		lsl.w	d1,d5
		subq.w	#1,d5

loc_136A:
		move.w	d7,(a1,d0.w)
		addq.w	#2,d0
		dbf	d5,loc_136A
		bra.s	loc_1330
; ---------------------------------------------------------------------------

plcAdd:
		movem.l	a1-a2,-(sp)
		lea	(plcArray).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		lea	(plcList).w,a2

loc_138E:
		tst.l	(a2)
		beq.s	loc_1396
		addq.w	#6,a2
		bra.s	loc_138E
; ---------------------------------------------------------------------------

loc_1396:
		move.w	(a1)+,d0
		bmi.s	loc_13A2

loc_139A:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		dbf	d0,loc_139A

loc_13A2:
		movem.l	(sp)+,a1-a2
		rts
; ---------------------------------------------------------------------------

plcReplace:
		movem.l	a1-a2,-(sp)
		lea	(plcArray).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		bsr.s	ClearPLC
		lea	(plcList).w,a2
		move.w	(a1)+,d0
		bmi.s	loc_13CE

loc_13C6:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		dbf	d0,loc_13C6

loc_13CE:
		movem.l	(sp)+,a1-a2
		rts
; ---------------------------------------------------------------------------

ClearPLC:
		lea	(plcList).w,a2
		moveq	#$1F,d0

loc_13DA:
		clr.l	(a2)+
		dbf	d0,loc_13DA
		rts
; ---------------------------------------------------------------------------

ProcessPLC:
		tst.l	(plcList).w
		beq.s	locret_1436
		tst.w	(unk_FFF6F8).w
		bne.s	locret_1436
		movea.l	(plcList).w,a0
		lea	(sub_12F8).l,a3
		lea	(byte_FFAA00).w,a1
		move.w	(a0)+,d2
		bpl.s	loc_1404
		adda.w	#$A,a3

loc_1404:
		andi.w	#$7FFF,d2
		move.w	d2,(unk_FFF6F8).w
		bsr.w	sub_1324
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6
		moveq	#0,d0
		move.l	a0,(plcList).w
		move.l	a3,(unk_FFF6E0).w
		move.l	d0,(unk_FFF6E4).w
		move.l	d0,(unk_FFF6E8).w
		move.l	d0,(unk_FFF6EC).w
		move.l	d5,(unk_FFF6F0).w
		move.l	d6,(unk_FFF6F4).w

locret_1436:
		rts
; ---------------------------------------------------------------------------

sub_1438:
		tst.w	(unk_FFF6F8).w
		beq.w	locret_14D0
		move.w	#9,(unk_FFF6FA).w
		moveq	#0,d0
		move.w	(plcList+4).w,d0
		addi.w	#$120,(plcList+4).w
		bra.s	loc_146C
; ---------------------------------------------------------------------------

loc_1454:
		tst.w	(unk_FFF6F8).w
		beq.s	locret_14D0
		move.w	#3,(unk_FFF6FA).w
		moveq	#0,d0
		move.w	(plcList+4).w,d0
		addi.w	#$60,(plcList+4).w

loc_146C:
		lea	($C00004).l,a4
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(a4)
		subq.w	#4,a4
		movea.l	(plcList).w,a0
		movea.l	(unk_FFF6E0).w,a3
		move.l	(unk_FFF6E4).w,d0
		move.l	(unk_FFF6E8).w,d1
		move.l	(unk_FFF6EC).w,d2
		move.l	(unk_FFF6F0).w,d5
		move.l	(unk_FFF6F4).w,d6
		lea	(byte_FFAA00).w,a1

loc_14A0:
		movea.w	#8,a5
		bsr.w	loc_12C2
		subq.w	#1,(unk_FFF6F8).w
		beq.s	ShiftPLC
		subq.w	#1,(unk_FFF6FA).w
		bne.s	loc_14A0
		move.l	a0,(plcList).w

loc_14B8:
		move.l	a3,(unk_FFF6E0).w
		move.l	d0,(unk_FFF6E4).w
		move.l	d1,(unk_FFF6E8).w
		move.l	d2,(unk_FFF6EC).w
		move.l	d5,(unk_FFF6F0).w
		move.l	d6,(unk_FFF6F4).w

locret_14D0:
		rts
; ---------------------------------------------------------------------------

ShiftPLC:
		lea	(plcList).w,a0
		moveq	#$15,d0

loc_14D8:
		move.l	6(a0),(a0)+
		dbf	d0,loc_14D8
		rts
; ---------------------------------------------------------------------------

sub_14E2:
		lea	(plcArray).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,d1

loc_14F4:
		movea.l	(a1)+,a0
		moveq	#0,d0
		move.w	(a1)+,d0
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,($C00004).l
		bsr.w	NemesisDec
		dbf	d1,loc_14F4
		rts
; ---------------------------------------------------------------------------

EnigmaDec:
		movem.l	d0-d7/a1-a5,-(sp)
		movea.w	d0,a3
		move.b	(a0)+,d0
		ext.w	d0
		movea.w	d0,a5
		move.b	(a0)+,d4
		lsl.b	#3,d4
		movea.w	(a0)+,a2
		adda.w	a3,a2
		movea.w	(a0)+,a4
		adda.w	a3,a4
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6

loc_1534:
		moveq	#7,d0
		move.w	d6,d7
		sub.w	d0,d7
		move.w	d5,d1
		lsr.w	d7,d1
		andi.w	#$7F,d1
		move.w	d1,d2
		cmpi.w	#$40,d1
		bcc.s	loc_154E
		moveq	#6,d0
		lsr.w	#1,d2

loc_154E:
		bsr.w	sub_1682
		andi.w	#$F,d2
		lsr.w	#4,d1
		add.w	d1,d1
		jmp	loc_15AA(pc,d1.w)
; ---------------------------------------------------------------------------

loc_155E:
		move.w	a2,(a1)+
		addq.w	#1,a2
		dbf	d2,loc_155E
		bra.s	loc_1534
; ---------------------------------------------------------------------------

loc_1568:
		move.w	a4,(a1)+
		dbf	d2,loc_1568
		bra.s	loc_1534
; ---------------------------------------------------------------------------

loc_1570:
		bsr.w	sub_15D2

loc_1574:
		move.w	d1,(a1)+
		dbf	d2,loc_1574
		bra.s	loc_1534
; ---------------------------------------------------------------------------

loc_157C:
		bsr.w	sub_15D2

loc_1580:
		move.w	d1,(a1)+
		addq.w	#1,d1
		dbf	d2,loc_1580
		bra.s	loc_1534
; ---------------------------------------------------------------------------

loc_158A:
		bsr.w	sub_15D2

loc_158E:
		move.w	d1,(a1)+
		subq.w	#1,d1
		dbf	d2,loc_158E
		bra.s	loc_1534
; ---------------------------------------------------------------------------

loc_1598:
		cmpi.w	#$F,d2
		beq.s	loc_15BA

loc_159E:
		bsr.w	sub_15D2
		move.w	d1,(a1)+
		dbf	d2,loc_159E
		bra.s	loc_1534
; ---------------------------------------------------------------------------

loc_15AA:
		bra.s	loc_155E
; ---------------------------------------------------------------------------
		bra.s	loc_155E
; ---------------------------------------------------------------------------
		bra.s	loc_1568
; ---------------------------------------------------------------------------
		bra.s	loc_1568
; ---------------------------------------------------------------------------
		bra.s	loc_1570
; ---------------------------------------------------------------------------
		bra.s	loc_157C
; ---------------------------------------------------------------------------
		bra.s	loc_158A
; ---------------------------------------------------------------------------
		bra.s	loc_1598
; ---------------------------------------------------------------------------

loc_15BA:
		subq.w	#1,a0
		cmpi.w	#$10,d6
		bne.s	loc_15C4
		subq.w	#1,a0

loc_15C4:
		move.w	a0,d0
		lsr.w	#1,d0
		bcc.s	loc_15CC
		addq.w	#1,a0

loc_15CC:
		movem.l	(sp)+,d0-d7/a1-a5
		rts
; ---------------------------------------------------------------------------

sub_15D2:
		move.w	a3,d3
		move.b	d4,d1
		add.b	d1,d1
		bcc.s	loc_15E4
		subq.w	#1,d6
		btst	d6,d5
		beq.s	loc_15E4
		ori.w	#$8000,d3

loc_15E4:
		add.b	d1,d1
		bcc.s	loc_15F2
		subq.w	#1,d6
		btst	d6,d5
		beq.s	loc_15F2
		addi.w	#$4000,d3

loc_15F2:
		add.b	d1,d1
		bcc.s	loc_1600
		subq.w	#1,d6
		btst	d6,d5
		beq.s	loc_1600
		addi.w	#$2000,d3

loc_1600:
		add.b	d1,d1
		bcc.s	loc_160E
		subq.w	#1,d6
		btst	d6,d5
		beq.s	loc_160E
		ori.w	#$1000,d3

loc_160E:
		add.b	d1,d1
		bcc.s	loc_161C
		subq.w	#1,d6
		btst	d6,d5
		beq.s	loc_161C
		ori.w	#$800,d3

loc_161C:
		move.w	d5,d1
		move.w	d6,d7
		sub.w	a5,d7
		bcc.s	loc_164C
		move.w	d7,d6
		addi.w	#$10,d6
		neg.w	d7
		lsl.w	d7,d1
		move.b	(a0),d5
		rol.b	d7,d5
		add.w	d7,d7
		and.w	loc_1660(pc,d7.w),d5
		add.w	d5,d1

loc_163A:
		move.w	a5,d0
		add.w	d0,d0
		and.w	loc_1660(pc,d0.w),d1
		add.w	d3,d1
		move.b	(a0)+,d5
		lsl.w	#8,d5
		move.b	(a0)+,d5
		rts
; ---------------------------------------------------------------------------

loc_164C:
		beq.s	loc_165E
		lsr.w	d7,d1
		move.w	a5,d0
		add.w	d0,d0
		and.w	loc_1660(pc,d0.w),d1
		add.w	d3,d1
		move.w	a5,d0
		bra.s	sub_1682
; ---------------------------------------------------------------------------

loc_165E:
		moveq	#$10,d6

loc_1660:
		bra.s	loc_163A
; ---------------------------------------------------------------------------
		dc.w 1, 3, 7, $F, $1F, $3F, $7F, $FF, $1FF, $3FF, $7FF
		dc.w $FFF, $1FFF, $3FFF, $7FFF, $FFFF
; ---------------------------------------------------------------------------

sub_1682:
		sub.w	d0,d6
		cmpi.w	#9,d6
		bcc.s	locret_1690
		addq.w	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5

locret_1690:
		rts
; ---------------------------------------------------------------------------

KosinskiDec:
		subq.l	#2,sp
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

loc_169E:
		lsr.w	#1,d5
		move	sr,d6
		dbf	d4,loc_16B0
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

loc_16B0:
		move	d6,ccr
		bcc.s	loc_16B8
		move.b	(a0)+,(a1)+
		bra.s	loc_169E
; ---------------------------------------------------------------------------

loc_16B8:
		moveq	#0,d3
		lsr.w	#1,d5
		move	sr,d6
		dbf	d4,loc_16CC
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

loc_16CC:
		move	d6,ccr
		bcs.s	loc_16FC
		lsr.w	#1,d5
		dbf	d4,loc_16E0
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

loc_16E0:
		roxl.w	#1,d3
		lsr.w	#1,d5
		dbf	d4,loc_16F2
		move.b	(a0)+,1(sp)
		move.b	(a0)+,(sp)
		move.w	(sp),d5
		moveq	#$F,d4

loc_16F2:
		roxl.w	#1,d3
		addq.w	#1,d3
		moveq	#-1,d2
		move.b	(a0)+,d2
		bra.s	loc_1712
; ---------------------------------------------------------------------------

loc_16FC:
		move.b	(a0)+,d0
		move.b	(a0)+,d1
		moveq	#-1,d2
		move.b	d1,d2
		lsl.w	#5,d2
		move.b	d0,d2
		andi.w	#7,d1
		beq.s	loc_171E
		move.b	d1,d3
		addq.w	#1,d3

loc_1712:
		move.b	(a1,d2.w),d0
		move.b	d0,(a1)+
		dbf	d3,loc_1712
		bra.s	loc_169E
; ---------------------------------------------------------------------------

loc_171E:
		move.b	(a0)+,d1
		beq.s	loc_172E
		cmpi.b	#1,d1
		beq.w	loc_169E
		move.b	d1,d3
		bra.s	loc_1712
; ---------------------------------------------------------------------------

loc_172E:
		addq.l	#2,sp
		rts
; ---------------------------------------------------------------------------

PaletteCycle:
		moveq	#0,d2
		moveq	#0,d0
		move.b	(level).w,d0
		add.w	d0,d0
		move.w	@levels(pc,d0.w),d0
		jmp	@levels(pc,d0.w)
; ---------------------------------------------------------------------------

@levels:	dc.w PalCycGHZ-@levels, PalCycLZ-@levels, PalCycMZ-@levels, PalCycSLZ-@levels
		dc.w PalCycSYZ-@levels, PalCycSBZ-@levels, PalCycEnding-@levels
; ---------------------------------------------------------------------------

PalCycTitle:
		lea	(word_184C).l,a0
		bra.s	loc_1760
; ---------------------------------------------------------------------------

PalCycGHZ:
		lea	(word_186C).l,a0

loc_1760:
		subq.w	#1,(word_FFF634).w
		bpl.s	locret_1786
		move.w	#5,(word_FFF634).w
		move.w	(word_FFF632).w,d0
		addq.w	#1,(word_FFF632).w
		andi.w	#3,d0
		lsl.w	#3,d0
		lea	((Palette+$50)).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)

locret_1786:
		rts
; ---------------------------------------------------------------------------

PalCycLZ:
		rts
; ---------------------------------------------------------------------------
		subq.w	#1,(word_FFF634).w
		bpl.s	locret_17B8
		move.w	#5,(word_FFF634).w
		move.w	(word_FFF632).w,d0
		addq.w	#1,(word_FFF632).w
		andi.w	#3,d0
		lsl.w	#3,d0
		lea	(word_188C).l,a0
		adda.w	d0,a0
		lea	((Palette+$6E)).w,a1
		move.w	(a0)+,(a1)+
		addq.w	#8,a1
		move.w	(a0)+,(a1)+
		move.l	(a0)+,(a1)+

locret_17B8:
		rts
; ---------------------------------------------------------------------------

PalCycMZ:
		rts
; ---------------------------------------------------------------------------

PalCycSLZ:
		subq.w	#1,(word_FFF634).w
		bpl.s	locret_17F6
		move.w	#$F,(word_FFF634).w
		move.w	(word_FFF632).w,d0
		addq.w	#1,d0
		cmpi.w	#6,d0
		bcs.s	loc_17D6
		moveq	#0,d0

loc_17D6:
		move.w	d0,(word_FFF632).w
		move.w	d0,d1
		add.w	d1,d1
		add.w	d1,d0
		add.w	d0,d0
		lea	(word_18F4).l,a0
		lea	((Palette+$56)).w,a1
		move.w	(a0,d0.w),(a1)
		move.l	2(a0,d0.w),4(a1)

locret_17F6:
		rts
; ---------------------------------------------------------------------------

PalCycSYZ:
		subq.w	#1,(word_FFF634).w
		bpl.s	locret_1846
		move.w	#5,(word_FFF634).w
		move.w	(word_FFF632).w,d0
		move.w	d0,d1
		addq.w	#1,(word_FFF632).w
		andi.w	#3,d0
		lsl.w	#3,d0
		lea	(word_1918).l,a0
		lea	((Palette+$6E)).w,a1
		move.l	(a0,d0.w),(a1)+
		move.l	4(a0,d0.w),(a1)
		andi.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		add.w	d1,d1
		lea	(word_1938).l,a0
		lea	((Palette+$76)).w,a1
		move.l	(a0,d1.w),(a1)
		move.w	4(a0,d1.w),6(a1)

locret_1846:
		rts
; ---------------------------------------------------------------------------

PalCycSBZ:
		rts
; ---------------------------------------------------------------------------

PalCycEnding:
		rts
; ---------------------------------------------------------------------------
word_184C:	incbin "unknown/0184C.pal"
		even
word_186C:	incbin "unknown/0186C.pal"
		even
word_188C:	incbin "unknown/0188C.pal"
		even
word_18F4:	incbin "unknown/018F4.pal"
		even
word_1918:	incbin "unknown/01918.pal"
		even
word_1938:	incbin "unknown/01938.pal"
		even
; ---------------------------------------------------------------------------

sub_1950:
		move.w	#$3F,(word_FFF626).w
; ---------------------------------------------------------------------------

sub_1956:
		moveq	#0,d0
		lea	(Palette).w,a0
		move.b	(word_FFF626).w,d0
		adda.w	d0,a0
		moveq	#0,d1
		move.b	(word_FFF626+1).w,d0

loc_1968:
		move.w	d1,(a0)+
		dbf	d0,loc_1968
		move.w	#$14,d4

loc_1972:
		move.b	#$12,(VintRoutine).w
		bsr.w	vsync
		bsr.s	sub_1988
		bsr.w	ProcessPLC
		dbf	d4,loc_1972
		rts
; ---------------------------------------------------------------------------

sub_1988:
		moveq	#0,d0
		lea	(Palette).w,a0
		lea	(PaletteTarget).w,a1
		move.b	(word_FFF626).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(word_FFF626+1).w,d0

loc_199E:
		bsr.s	sub_19A6
		dbf	d0,loc_199E
		rts
; ---------------------------------------------------------------------------

sub_19A6:
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3
		beq.s	loc_19CE
		move.w	d3,d1
		addi.w	#$200,d1
		cmp.w	d2,d1
		bhi.s	loc_19BC
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19BC:
		move.w	d3,d1
		addi.w	#$20,d1
		cmp.w	d2,d1
		bhi.s	loc_19CA
		move.w	d1,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19CA:
		addq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_19CE:
		addq.w	#2,a0
		rts
; ---------------------------------------------------------------------------

sub_19D2:
		move.w	#$3F,(word_FFF626).w
		move.w	#$14,d4

loc_19DC:
		move.b	#$12,(VintRoutine).w
		bsr.w	vsync
		bsr.s	sub_19F2
		bsr.w	ProcessPLC
		dbf	d4,loc_19DC
		rts
; ---------------------------------------------------------------------------

sub_19F2:
		moveq	#0,d0
		lea	(Palette).w,a0
		move.b	(word_FFF626).w,d0
		adda.w	d0,a0
		move.b	(word_FFF626+1).w,d0

loc_1A02:
		bsr.s	sub_1A0A
		dbf	d0,loc_1A02
		rts
; ---------------------------------------------------------------------------

sub_1A0A:
		move.w	(a0),d2
		beq.s	loc_1A36
		move.w	d2,d1
		andi.w	#$E,d1
		beq.s	loc_1A1A
		subq.w	#2,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A1A:
		move.w	d2,d1
		andi.w	#$E0,d1
		beq.s	loc_1A28
		subi.w	#$20,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A28:
		move.w	d2,d1
		andi.w	#$E00,d1
		beq.s	loc_1A36
		subi.w	#$200,(a0)+
		rts
; ---------------------------------------------------------------------------

loc_1A36:
		addq.w	#2,a0
		rts
; ---------------------------------------------------------------------------

sub_1A3A:
		subq.w	#1,(word_FFF634).w
		bpl.s	locret_1A68
		move.w	#3,(word_FFF634).w
		move.w	(word_FFF632).w,d0
		bmi.s	locret_1A68
		subq.w	#2,(word_FFF632).w
		lea	(word_1A6A).l,a0
		lea	((Palette+4)).w,a1
		adda.w	d0,a0
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)+

locret_1A68:
		rts
; ---------------------------------------------------------------------------
word_1A6A:	incbin "unknown/01A6A.pal"
		even
; ---------------------------------------------------------------------------

palLoadFade:
		lea	(PaletteLoadTable).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		adda.w	#$80,a3
		move.w	(a1)+,d7

loc_1ABC:
		move.l	(a2)+,(a3)+
		dbf	d7,loc_1ABC
		rts
; ---------------------------------------------------------------------------

PalLoadNormal:
		lea	(PaletteLoadTable).l,a1
		lsl.w	#3,d0
		adda.w	d0,a1
		movea.l	(a1)+,a2
		movea.w	(a1)+,a3
		move.w	(a1)+,d7

loc_1AD4:
		move.l	(a2)+,(a3)+
		dbf	d7,loc_1AD4
		rts
; ---------------------------------------------------------------------------

PaletteLoadTable:dc.l palSegaBG
		dc.w $FB00, $1F
		dc.l palTitle
		dc.w $FB00, $1F
		dc.l palLevelSel
		dc.w $FB00, $1F
		dc.l palSonic
		dc.w $FB00, 7
		dc.l palGHZ
		dc.w $FB20, $17
		dc.l palLZ
		dc.w $FB20, $17
		dc.l palMZ
		dc.w $FB20, $17
		dc.l palSLZ
		dc.w $FB20, $17
		dc.l palSYZ
		dc.w $FB20, $17
		dc.l palSBZ
		dc.w $FB20, $17
		dc.l palSpecial
		dc.w $FB00, $1F
		dc.l palGHZNight
		dc.w $FB00, $1F
palSegaBG:	incbin "screens/sega/Main.pal"
		even
palTitle:	incbin "screens/title/Main.pal"
		even
palLevelSel:	incbin "screens/title/Level Select.pal"
		even
palSonic:	incbin "levels/shared/Sonic/Sonic.pal"
		even
palGHZ:		incbin "levels/GHZ/Main.pal"
		even
palLZ:		incbin "levels/LZ/Main.pal"
		even
palGHZNight:	incbin "levels/GHZ/Night.pal"
		even
palMZ:		incbin "levels/MZ/Main.pal"
		even
palSLZ:		incbin "levels/SLZ/Main.pal"
		even
palSYZ:		incbin "levels/SYZ/Main.pal"
		even
palSBZ:		incbin "levels/SBZ/Main.pal"
		even
palSpecial:	incbin "screens/special stage/Main.pal"
		even
; ---------------------------------------------------------------------------

vsync:
		move	#$2300,sr

@wait:
		tst.b	(VintRoutine).w
		bne.s	@wait
		rts
; ---------------------------------------------------------------------------

RandomNumber:
		move.l	(RandomSeed).w,d1
		bne.s	@noreset
		move.l	#$2A6D365A,d1

@noreset:
		move.l	d1,d0
		asl.l	#2,d1
		add.l	d0,d1
		asl.l	#3,d1
		add.l	d0,d1
		move.w	d1,d0
		swap	d1
		add.w	d1,d0
		move.w	d0,d1
		swap	d1
		move.l	d1,(RandomSeed).w
		rts
; ---------------------------------------------------------------------------

GetSine:
		andi.w	#$FF,d0
		add.w	d0,d0
		addi.w	#$80,d0
		move.w	SineTable(pc,d0.w),d1
		subi.w	#$80,d0
		move.w	SineTable(pc,d0.w),d0
		rts
; ---------------------------------------------------------------------------
SineTable:	incbin "unsorted/sinetable.dat"
		even
; ---------------------------------------------------------------------------
		movem.l	d1-d2,-(sp)	; garbage
		move.w	d0,d1
		swap	d1
		moveq	#0,d0
		move.w	d0,d1
		moveq	#7,d2

loc_22F4:
		rol.l	#2,d1
		add.w	d0,d0
		addq.w	#1,d0
		sub.w	d0,d1
		bcc.s	loc_230E
		add.w	d0,d1
		subq.w	#1,d0
		dbf	d2,loc_22F4
		lsr.w	#1,d0
		movem.l	(sp)+,d1-d2
		rts
; ---------------------------------------------------------------------------

loc_230E:
		addq.w	#1,d0
		dbf	d2,loc_22F4
		lsr.w	#1,d0
		movem.l	(sp)+,d1-d2
		rts
; ---------------------------------------------------------------------------

GetAngle:
		movem.l	d3-d4,-(sp)
		moveq	#0,d3
		moveq	#0,d4
		move.w	d1,d3
		move.w	d2,d4
		or.w	d3,d4
		beq.s	loc_2378
		move.w	d2,d4
		tst.w	d3
		bpl.w	loc_2336
		neg.w	d3

loc_2336:
		tst.w	d4
		bpl.w	loc_233E
		neg.w	d4

loc_233E:
		cmp.w	d3,d4
		bcc.w	loc_2350
		lsl.l	#8,d4
		divu.w	d3,d4
		moveq	#0,d0
		move.b	AngleTable(pc,d4.w),d0
		bra.s	loc_235A
; ---------------------------------------------------------------------------

loc_2350:
		lsl.l	#8,d3
		divu.w	d4,d3
		moveq	#$40,d0
		sub.b	AngleTable(pc,d3.w),d0

loc_235A:
		tst.w	d1
		bpl.w	loc_2366
		neg.w	d0
		addi.w	#$80,d0

loc_2366:
		tst.w	d2
		bpl.w	loc_2372
		neg.w	d0
		addi.w	#$100,d0

loc_2372:
		movem.l	(sp)+,d3-d4
		rts
; ---------------------------------------------------------------------------

loc_2378:
		move.w	#$40,d0
		movem.l	(sp)+,d3-d4
		rts
; ---------------------------------------------------------------------------
AngleTable:	incbin "unsorted/angletable.dat"
		even
; ---------------------------------------------------------------------------

sSega:
		move.b	#$E0,d0
		bsr.w	PlaySFX
		bsr.w	ClearPLC
		bsr.w	sub_19D2
		lea	($C00004).l,a6
		move.w	#$8004,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$8700,(a6)
		move.w	#$8B00,(a6)
		move.w	(ModeReg2).w,d0
		andi.b	#$BF,d0
		move.w	d0,($C00004).l

loc_24BC:
		bsr.w	sub_10A6
		move.l	#$40000000,($C00004).l
		lea	(ArtSega).l,a0
		bsr.w	NemesisDec
		lea	((Chunks)&$FFFFFF).l,a1
		lea	(MapSega).l,a0
		move.w	#0,d0
		bsr.w	EnigmaDec
		lea	((Chunks)&$FFFFFF).l,a1
		move.l	#$461C0003,d0
		moveq	#$B,d1
		moveq	#3,d2
		bsr.w	LoadPlaneMaps
		moveq	#0,d0
		bsr.w	PalLoadNormal
		move.w	#$28,(word_FFF632).w
		move.w	#0,(word_FFF662).w
		move.w	#0,(word_FFF660).w
		move.w	#$B4,(GlobalTimer).w
		move.w	(ModeReg2).w,d0
		ori.b	#$40,d0
		move.w	d0,($C00004).l

loc_2528:
		move.b	#2,(VintRoutine).w
		bsr.w	vsync
		bsr.w	sub_1A3A
		tst.w	(GlobalTimer).w
		beq.s	loc_2544
		andi.b	#$80,(padPress1).w
		beq.s	loc_2528

loc_2544:
		move.b	#4,(GameMode).w
		rts
; ---------------------------------------------------------------------------

sTitle:
		bsr.w	ClearPLC
		bsr.w	sub_19D2
		lea	($C00004).l,a6
		move.w	#$8004,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$9001,(a6)
		move.w	#$9200,(a6)
		move.w	#$8B03,(a6)
		move.w	#$8720,(a6)
		move.w	(ModeReg2).w,d0
		andi.b	#$BF,d0
		move.w	d0,($C00004).l
		bsr.w	sub_10A6
		lea	(ObjectsList).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

loc_2592:
		move.l	d0,(a1)+
		dbf	d1,loc_2592
		move.l	#$40000001,($C00004).l
		lea	(ArtTitleMain).l,a0
		bsr.w	NemesisDec
		move.l	#$60000001,($C00004).l
		lea	(ArtTitleSonic).l,a0
		bsr.w	NemesisDec
		lea	($C00000).l,a6
		move.l	#$50000003,4(a6)
		lea	(ArtText).l,a5
		move.w	#$28F,d1

loc_25D8:
		move.w	(a5)+,(a6)
		dbf	d1,loc_25D8
		lea	(byte_18A62).l,a1
		move.l	#$42060003,d0
		moveq	#$21,d1
		moveq	#$15,d2
		bsr.w	LoadPlaneMaps
		move.w	#0,(DebugRoutine).w
		move.w	#0,(DemoMode).w
		move.w	#0,(level).w
		bsr.w	LoadLevelBounds
		bsr.w	LevelScroll
		move.l	#$40000000,($C00004).l
		lea	(TilesGHZ_1).l,a0
		bsr.w	NemesisDec
		lea	(BlocksGHZ).l,a0
		lea	(Blocks).w,a4
		move.w	#$5FF,d0

@loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,@loadblocks
		lea	(ChunksGHZ).l,a0
		lea	((Chunks)&$FFFFFF).l,a1
		bsr.w	KosinskiDec
		bsr.w	LoadLayout
		lea	($C00004).l,a5
		lea	($C00000).l,a6
		lea	(unk_FFF708).w,a3
		lea	((Layout+$40)).w,a4
		move.w	#$6000,d2
		bsr.w	sub_47B0
		moveq	#1,d0
		bsr.w	palLoadFade
		move.b	#$8A,d0
		bsr.w	PlaySFX
		move.b	#0,(word_FFFFFA).w
		move.w	#$178,(GlobalTimer).w
		move.b	#$E,(byte_FFD040).w
		move.b	#$F,(byte_FFD080).w
		move.b	#$F,(byte_FFD0C0).w
		move.b	#2,(byte_FFD0C0+$1A).w
		moveq	#0,d0
		bsr.w	plcReplace
		move.w	(ModeReg2).w,d0
		ori.b	#$40,d0
		move.w	d0,($C00004).l
		bsr.w	sub_1950

loc_26AE:
		move.b	#4,(VintRoutine).w
		bsr.w	vsync
		bsr.w	RunObjects
		bsr.w	LevelScroll
		bsr.w	ProcessMaps
		bsr.w	PalCycTitle
		bsr.w	ProcessPLC
		move.w	(ObjectsList+8).w,d0
		addq.w	#2,d0
		move.w	d0,(ObjectsList+8).w
		cmpi.w	#$1C00,d0
		bcs.s	loc_26E4
		move.b	#0,(GameMode).w
		rts
; ---------------------------------------------------------------------------

loc_26E4:
		tst.w	(GlobalTimer).w
		beq.w	loc_27F8
		andi.b	#$80,(padPress1).w
		beq.w	loc_26AE
		btst	#6,(padHeld1).w
		beq.w	loc_27AA
		moveq	#2,d0
		bsr.w	PalLoadNormal
		lea	(ScrollTable).w,a1
		moveq	#0,d0
		move.w	#$DF,d1

loc_2710:
		move.l	d0,(a1)+
		dbf	d1,loc_2710
		move.l	d0,(dword_FFF616).w
		move	#$2700,sr
		lea	($C00000).l,a6
		move.l	#$60000003,($C00004).l
		move.w	#$3FF,d1

loc_2732:
		move.l	d0,(a6)
		dbf	d1,loc_2732
		bsr.w	sub_292C

loc_273C:
		move.b	#4,(VintRoutine).w
		bsr.w	vsync
		bsr.w	sub_28A6
		bsr.w	ProcessPLC
		tst.l	(plcList).w
		bne.s	loc_273C
		andi.b	#$F0,(padPress1).w
		beq.s	loc_273C
		move.w	(LevSelOption).w,d0
		cmpi.w	#$13,d0
		bne.s	loc_2780
		move.w	(LevSelSound).w,d0
		addi.w	#$80,d0
		cmpi.w	#$93,d0
		bcs.s	loc_277A
		cmpi.w	#$A0,d0
		bcs.s	loc_273C

loc_277A:
		bsr.w	PlaySFX
		bra.s	loc_273C
; ---------------------------------------------------------------------------

loc_2780:
		add.w	d0,d0
		move.w	LevSelOrder(pc,d0.w),d0
		bmi.s	loc_273C
		cmpi.w	#$700,d0
		bne.s	loc_2796
		move.b	#$10,(GameMode).w
		rts
; ---------------------------------------------------------------------------

loc_2796:
		andi.w	#$3FFF,d0
		btst	#4,(padHeld1).w
		beq.s	loc_27A6
		move.w	#3,d0

loc_27A6:
		move.w	d0,(level).w

loc_27AA:
		move.b	#$C,(GameMode).w
		move.b	#3,(Lives).w
		moveq	#0,d0
		move.w	d0,(Rings).w
		move.l	d0,(dword_FFFE22).w
		move.l	d0,(dword_FFFE26).w
		move.b	#$E0,d0
		bsr.w	PlaySFX
		rts
; ---------------------------------------------------------------------------

LevSelOrder:	dc.w 0,    1,    2
		dc.w $100, $101, $102
		dc.w $200, $201, $202
		dc.w $300, $301, $302
		dc.w $400, $401, $402
		dc.w $500, $501,$8500
		dc.w $700, $700,$8000
; ---------------------------------------------------------------------------

loc_27F8:
		move.w	#$1E,(GlobalTimer).w

loc_27FE:
		move.b	#4,(VintRoutine).w
		bsr.w	vsync
		bsr.w	LevelScroll
		bsr.w	PaletteCycle
		bsr.w	ProcessPLC
		move.w	(ObjectsList+8).w,d0
		addq.w	#2,d0
		move.w	d0,(ObjectsList+8).w
		cmpi.w	#$1C00,d0
		bcs.s	loc_282C
		move.b	#0,(GameMode).w
		rts
; ---------------------------------------------------------------------------

loc_282C:
		tst.w	(GlobalTimer).w
		bne.w	loc_27FE
		move.b	#$E0,d0
		bsr.w	PlaySFX
		move.w	(DemoNum).w,d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	DemoLevels(pc,d0.w),d0
		move.w	d0,(level).w
		addq.w	#1,(DemoNum).w
		cmpi.w	#6,(DemoNum).w
		bcs.s	loc_2860
		move.w	#0,(DemoNum).w

loc_2860:
		move.w	#1,(DemoMode).w
		move.b	#8,(GameMode).w
		cmpi.w	#$600,d0
		bne.s	loc_2878
		move.b	#$10,(GameMode).w

loc_2878:
		move.b	#3,(Lives).w
		moveq	#0,d0
		move.w	d0,(Rings).w
		move.l	d0,(dword_FFFE22).w
		move.l	d0,(dword_FFFE26).w
		rts
; ---------------------------------------------------------------------------

DemoLevels:	dc.w 0, $600, $200, $600, $400, $600, $300, $600, $200
		dc.w $600, $400, $600
; ---------------------------------------------------------------------------

sub_28A6:
		move.b	(padPress1).w,d1
		andi.b	#3,d1
		bne.s	loc_28B6
		subq.w	#1,(word_FFF666).w
		bpl.s	loc_28F0

loc_28B6:
		move.w	#$B,(word_FFF666).w
		move.b	(padHeld1).w,d1
		andi.b	#3,d1
		beq.s	loc_28F0
		move.w	(LevSelOption).w,d0
		btst	#0,d1
		beq.s	loc_28D6
		subq.w	#1,d0
		bcc.s	loc_28D6
		moveq	#$13,d0

loc_28D6:
		btst	#1,d1
		beq.s	loc_28E6
		addq.w	#1,d0
		cmpi.w	#$14,d0
		bcs.s	loc_28E6
		moveq	#0,d0

loc_28E6:
		move.w	d0,(LevSelOption).w
		bsr.w	sub_292C
		rts
; ---------------------------------------------------------------------------

loc_28F0:
		cmpi.w	#$13,(LevSelOption).w
		bne.s	locret_292A
		move.b	(padPress1).w,d1
		andi.b	#$C,d1
		beq.s	locret_292A
		move.w	(LevSelSound).w,d0
		btst	#2,d1
		beq.s	loc_2912
		subq.w	#1,d0
		bcc.s	loc_2912
		moveq	#79,d0

loc_2912:
		btst	#3,d1
		beq.s	loc_2922
		addq.w	#1,d0
		cmpi.w	#80,d0
		bcs.s	loc_2922
		moveq	#0,d0

loc_2922:
		move.w	d0,(LevSelSound).w
		bsr.w	sub_292C

locret_292A:
		rts
; ---------------------------------------------------------------------------

sub_292C:
		lea	(LevelSelectText).l,a1
		lea	($C00000).l,a6
		move.l	#$62100003,d4
		move.w	#$E680,d3
		moveq	#$13,d1

loc_2944:
		move.l	d4,4(a6)
		bsr.w	sub_29CC
		addi.l	#$800000,d4
		dbf	d1,loc_2944
		moveq	#0,d0
		move.w	(LevSelOption).w,d0
		move.w	d0,d1
		move.l	#$62100003,d4
		lsl.w	#7,d0
		swap	d0
		add.l	d0,d4
		lea	(LevelSelectText).l,a1
		lsl.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		adda.w	d1,a1
		move.w	#$C680,d3
		move.l	d4,4(a6)
		bsr.w	sub_29CC
		move.w	#$E680,d3
		cmpi.w	#$13,(LevSelOption).w
		bne.s	loc_2996
		move.w	#$C680,d3

loc_2996:
		move.l	#$6BB00003,($C00004).l
		move.w	(LevSelSound).w,d0
		addi.w	#$80,d0
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.w	sub_29B8
		move.b	d2,d0
		bsr.w	sub_29B8
		rts
; ---------------------------------------------------------------------------

sub_29B8:
		andi.w	#$F,d0
		cmpi.b	#$A,d0
		bcs.s	loc_29C6
		addi.b	#7,d0

loc_29C6:
		add.w	d3,d0
		move.w	d0,(a6)
		rts
; ---------------------------------------------------------------------------

sub_29CC:
		moveq	#$17,d2

loc_29CE:
		moveq	#0,d0
		move.b	(a1)+,d0
		bpl.s	loc_29DE
		move.w	#0,(a6)
		dbf	d2,loc_29CE
		rts
; ---------------------------------------------------------------------------

loc_29DE:
		add.w	d3,d0
		move.w	d0,(a6)
		dbf	d2,loc_29CE
		rts
; ---------------------------------------------------------------------------

LevelSelectText:dc.b $17, $22, $15, $15, $1E, $FF, $18, $19, $1C, $1C
		dc.b $FF, $10, $1F, $1E, $15, $FF, $23, $24, $11, $17
		dc.b $15, $FF, 1, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $23
		dc.b $24, $11, $17, $15, $FF, 2, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $23, $24, $11, $17, $15, $FF, 3, $FF, $1C
		dc.b $11, $12, $F, $22, $19, $1E, $24, $18, $FF, $10, $1F
		dc.b $1E, $15, $FF, $FF, $23, $24, $11, $17, $15, $FF
		dc.b 1, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $23, $24, $11
		dc.b $17, $15, $FF, 2, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $23, $24, $11, $17, $15, $FF, 3, $FF, $1D, $11, $22
		dc.b $12, $1C, $15, $FF, $10, $1F, $1E, $15, $FF, $FF
		dc.b $FF, $FF, $FF, $23, $24, $11, $17, $15, $FF, 1, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $23, $24, $11, $17
		dc.b $15, $FF, 2, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $23
		dc.b $24, $11, $17, $15, $FF, 3, $FF, $23, $24, $11, $22
		dc.b $FF, $1C, $19, $17, $18, $24, $FF, $10, $1F, $1E
		dc.b $15, $FF, $23, $24, $11, $17, $15, $FF, 1, $28, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $23, $24, $11, $17, $15
		dc.b $FF, 2, $28, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $23, $24
		dc.b $11, $17, $15, $FF, 3, $28, $23, $20, $11, $22, $1B
		dc.b $1C, $19, $1E, $17, $FF, $10, $1F, $1E, $15, $FF
		dc.b $FF, $23, $24, $11, $17, $15, $FF, 1, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $23, $24, $11, $17, $15, $FF
		dc.b 2, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $23, $24, $11
		dc.b $17, $15, $FF, 3, $FF, $13, $1C, $1F, $13, $1B, $FF
		dc.b $27, $1F, $22, $1B, $FF, $10, $1F, $1E, $15, $FF
		dc.b $23, $24, $11, $17, $15, $FF, 1, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $23, $24, $11, $17, $15, $FF, 2, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $23, $24, $11, $17
		dc.b $15, $FF, 3, $28, $23, $20, $15, $13, $19, $11, $1C
		dc.b $FF, $23, $24, $11, $17, $15, $FF, $FF, $FF, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $23, $1F, $25
		dc.b $1E, $14, $FF, $23, $15, $1C, $15, $13, $24, $FF
		dc.b $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		dc.b $FF

MusicList:	dc.b $81, $82, $83, $84, $85, $86
		even
; ---------------------------------------------------------------------------

sLevel:
		move.b	#$E0,d0
		bsr.w	PlaySFX
		move.l	#$70000002,($C00004).l
		lea	(ArtTitleCards).l,a0
		bsr.w	NemesisDec
		bsr.w	ClearPLC
		moveq	#0,d0
		move.b	(level).w,d0
		lsl.w	#4,d0
		lea	(LevelDataArray).l,a2
		lea	(a2,d0.w),a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	loc_2C0A
		bsr.w	plcAdd

loc_2C0A:
		moveq	#1,d0
		bsr.w	plcAdd
		bsr.w	sub_19D2
		bsr.w	sub_10A6
		lea	($C00004).l,a6
		move.w	#$8B03,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$857C,(a6)
		move.w	#0,(word_FFFFE8).w
		move.w	#$8AAF,(word_FFF624).w
		move.w	#$8004,(a6)
		move.w	#$8720,(a6)
		lea	(ObjectsList).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

loc_2C4C:
		move.l	d0,(a1)+
		dbf	d1,loc_2C4C
		lea	(CameraX).w,a1
		moveq	#0,d0
		move.w	#$3F,d1

loc_2C5C:
		move.l	d0,(a1)+
		dbf	d1,loc_2C5C
		lea	((oscValues+2)).w,a1
		moveq	#0,d0
		move.w	#$27,d1

loc_2C6C:
		move.l	d0,(a1)+
		dbf	d1,loc_2C6C
		moveq	#3,d0
		bsr.w	PalLoadNormal
		moveq	#0,d0
		move.b	(level).w,d0
		lea	(MusicList).l,a1
		move.b	(a1,d0.w),d0
		bsr.w	PlayMusic
		move.b	#$34,(byte_FFD080).w

loc_2C92:
		move.b	#$C,(VintRoutine).w
		bsr.w	vsync
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		bsr.w	ProcessPLC
		move.w	(byte_FFD100+8).w,d0
		cmp.w	(byte_FFD100+$30).w,d0
		bne.s	loc_2C92
		tst.l	(plcList).w
		bne.s	loc_2C92
		bsr.w	nullsub_1
		jsr	sub_117C6
		moveq	#3,d0
		bsr.w	palLoadFade
		bsr.w	LoadLevelBounds
		bsr.w	LevelScroll
		bsr.w	LoadLevelData
		bsr.w	sub_31EE
		bsr.w	mapLevelLoadFull
		jsr	nullsub_2
		move.l	#colGHZ,(Collision).w
		cmpi.b	#1,(level).w
		bne.s	loc_2CFA
		move.l	#colLZ,(Collision).w

loc_2CFA:
		cmpi.b	#2,(level).w
		bne.s	loc_2D0A
		move.l	#colMZ,(Collision).w

loc_2D0A:
		cmpi.b	#3,(level).w
		bne.s	loc_2D1A
		move.l	#colSLZ,(Collision).w

loc_2D1A:
		cmpi.b	#4,(level).w
		bne.s	loc_2D2A
		move.l	#colSYZ,(Collision).w

loc_2D2A:
		cmpi.b	#5,(level).w
		bne.s	loc_2D3A
		move.l	#colSBZ,(Collision).w

loc_2D3A:
		move.b	#1,(ObjectsList).w
		move.b	#$21,(byte_FFD040).w
		btst	#6,(padHeld1).w
		beq.s	loc_2D54
		move.b	#1,(word_FFFFFA).w

loc_2D54:
		move.w	#0,(padHeldPlayer).w
		move.w	#0,(padHeld1).w
		bsr.w	LoadObjects
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		moveq	#0,d0
		move.w	d0,(Rings).w
		move.b	d0,(byte_FFFE1B).w
		move.l	d0,(dword_FFFE22).w
		move.b	d0,(byte_FFFE2C).w
		move.b	d0,(byte_FFFE2D).w
		move.b	d0,(byte_FFFE2E).w
		move.b	d0,(byte_FFFE2F).w
		move.w	d0,(DebugRoutine).w
		move.w	d0,(LevelRestart).w
		move.w	d0,(LevelFrames).w
		bsr.w	oscInit
		move.b	#1,(byte_FFFE1F).w
		move.b	#1,(ExtraLifeFlags).w
		move.b	#1,(byte_FFFE1E).w
		move.w	#0,(unk_FFF790).w
		lea	(off_3100).l,a1
		moveq	#0,d0
		move.b	(level).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.b	1(a1),(unk_FFF792).w
		subq.b	#1,(unk_FFF792).w
		move.w	#$708,(GlobalTimer).w
		move.b	#8,(VintRoutine).w
		bsr.w	vsync
		move.w	#$202F,(word_FFF626).w
		bsr.w	sub_1956
		addq.b	#2,(byte_FFD080+$24).w
		addq.b	#4,(byte_FFD0C0+$24).w
		addq.b	#4,(byte_FFD100+$24).w
		addq.b	#4,(byte_FFD140+$24).w

sLevelLoop:
		bsr.w	PauseGame
		move.b	#8,(VintRoutine).w
		bsr.w	vsync
		addq.w	#1,(LevelFrames).w
		bsr.w	sub_3048
		bsr.w	DemoPlayback
		move.w	(padHeld1).w,(padHeldPlayer).w
		bsr.w	RunObjects
		tst.w	(DebugRoutine).w
		bne.s	loc_2E2A
		cmpi.b	#6,(ObjectsList+$24).w
		bcc.s	loc_2E2E

loc_2E2A:
		bsr.w	LevelScroll

loc_2E2E:
		bsr.w	ProcessMaps
		bsr.w	LoadObjects
		bsr.w	PaletteCycle
		bsr.w	ProcessPLC
		bsr.w	oscUpdate
		bsr.w	UpdateTimers
		bsr.w	LoadSignpostPLC
		cmpi.b	#8,(GameMode).w
		beq.s	loc_2E66
		tst.w	(LevelRestart).w
		bne.w	sLevel
		cmpi.b	#$C,(GameMode).w
		beq.w	sLevelLoop
		rts
; ---------------------------------------------------------------------------

loc_2E66:
		tst.w	(LevelRestart).w
		bne.s	loc_2E84
		tst.w	(GlobalTimer).w
		beq.s	loc_2E84
		cmpi.b	#8,(GameMode).w
		beq.w	sLevelLoop
		move.b	#0,(GameMode).w
		rts
; ---------------------------------------------------------------------------

loc_2E84:
		cmpi.b	#8,(GameMode).w
		bne.s	loc_2E92
		move.b	#0,(GameMode).w

loc_2E92:
		move.w	#$3C,(GlobalTimer).w
		move.w	#$3F,(word_FFF626).w

loc_2E9E:
		move.b	#8,(VintRoutine).w
		bsr.w	vsync
		bsr.w	DemoPlayback
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		bsr.w	LoadObjects
		subq.w	#1,(unk_FFF794).w
		bpl.s	loc_2EC8
		move.w	#2,(unk_FFF794).w
		bsr.w	sub_19F2

loc_2EC8:
		tst.w	(GlobalTimer).w
		bne.s	loc_2E9E
		rts
; ---------------------------------------------------------------------------
		lea	(word_2EF4).l,a0
		lea	(byte_FFD400).w,a1
		move.w	#$B,d1

loc_2EDE:
		move.b	#5,(a1)
		move.w	(a0)+,8(a1)
		move.w	(a0)+,$A(a1)
		lea	$40(a1),a1
		dbf	d1,loc_2EDE
		rts
; ---------------------------------------------------------------------------

word_2EF4:	dc.w $158, $148
		dc.w $160, $148
		dc.w $168, $148
		dc.w $170, $148
		dc.w $180, $148
		dc.w $188, $148
		dc.w $190, $148
		dc.w $198, $148
		dc.w $158, $98
		dc.w $160, $98
		dc.w $168, $98
		dc.w $170, $98
; ---------------------------------------------------------------------------
		lea	(word_2F48).l,a0
		lea	(byte_FFD280).w,a1
		move.w	#$33,d1

loc_2F32:
		move.b	#5,(a1)
		move.w	(a0)+,8(a1)
		move.w	(a0)+,$A(a1)
		lea	$40(a1),a1
		dbf	d1,loc_2F32
		rts
; ---------------------------------------------------------------------------

word_2F48:	dc.w $158, $90
		dc.w $160, $90
		dc.w $168, $90
		dc.w $170, $90
		dc.w $180, $90
		dc.w $188, $90
		dc.w $190, $90
		dc.w $198, $90
		dc.w $158, $A0
		dc.w $160, $A0
		dc.w $168, $A0
		dc.w $170, $A0
		dc.w $180, $A0
		dc.w $188, $A0
		dc.w $190, $A0
		dc.w $198, $A0
		dc.w $158, $A8
		dc.w $160, $A8
		dc.w $168, $A8
		dc.w $170, $A8
		dc.w $180, $A8
		dc.w $188, $A8
		dc.w $190, $A8
		dc.w $198, $A8
		dc.w $158, $B0
		dc.w $160, $B0
		dc.w $168, $B0
		dc.w $170, $B0
		dc.w $180, $B0
		dc.w $188, $B0
		dc.w $190, $B0
		dc.w $198, $B0
		dc.w $158, $B8
		dc.w $160, $B8
		dc.w $168, $B8
		dc.w $170, $B8
		dc.w $180, $B8
		dc.w $188, $B8
		dc.w $190, $B8
		dc.w $198, $B8
		dc.w $100, $98
		dc.w $108, $98
		dc.w $110, $98
		dc.w $118, $98
		dc.w $128, $98
		dc.w $130, $98
		dc.w $138, $98
		dc.w $140, $98
		dc.w $128, $A8
		dc.w $130, $A8
		dc.w $138, $A8
		dc.w $140, $A8
; ---------------------------------------------------------------------------
		lea	(byte_FFAA00).w,a0
		move.w	(word_FFF64C).w,d2
		move.w	#$9100,d3
		move.w	#$FF,d7

loc_3028:
		move.w	d2,d0
		bsr.w	GetSine
		asr.w	#4,d0
		bpl.s	loc_3034
		moveq	#0,d0

loc_3034:
		andi.w	#$1F,d0
		move.b	d0,d3
		move.w	d3,(a0)+
		addq.w	#2,d2
		dbf	d7,loc_3028
		addq.w	#2,(word_FFF64C).w
		rts
; ---------------------------------------------------------------------------

sub_3048:
		btst	#0,(padHeld1).w
		beq.s	loc_305E
		addq.w	#1,(unk_FFF71C).w
		tst.b	(word_FFF624+1).w
		beq.s	loc_305E
		subq.b	#1,(word_FFF624+1).w

loc_305E:
		btst	#1,(padHeld1).w
		beq.s	locret_3076
		subq.w	#1,(unk_FFF71C).w
		cmpi.b	#$DF,(word_FFF624+1).w
		beq.s	locret_3076
		addq.b	#1,(word_FFF624+1).w

locret_3076:
		rts
; ---------------------------------------------------------------------------

DemoPlayback:
		tst.w	(DemoMode).w
		bne.s	loc_30B8
		rts
; ---------------------------------------------------------------------------

DemoRecord:
		lea	($80000).l,a1
		move.w	(unk_FFF790).w,d0
		adda.w	d0,a1
		move.b	(padHeld1).w,d0
		cmp.b	(a1),d0
		bne.s	loc_30A2
		addq.b	#1,1(a1)
		cmpi.b	#$FF,1(a1)
		beq.s	loc_30A2
		rts
; ---------------------------------------------------------------------------

loc_30A2:
		move.b	d0,2(a1)
		move.b	#0,3(a1)
		addq.w	#2,(unk_FFF790).w
		andi.w	#$3FF,(unk_FFF790).w
		rts
; ---------------------------------------------------------------------------

loc_30B8:
		tst.b	(padHeld1).w
		bpl.s	loc_30C4
		move.b	#4,(GameMode).w

loc_30C4:
		lea	(off_3100).l,a1
		moveq	#0,d0
		move.b	(level).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.w	(unk_FFF790).w,d0
		adda.w	d0,a1
		move.b	(a1),d0
		lea	(padHeld1).w,a0
		move.b	d0,d1
		move.b	(a0),d2
		eor.b	d2,d0
		move.b	d1,(a0)+
		and.b	d1,d0
		move.b	d0,(a0)+
		subq.b	#1,(unk_FFF792).w
		bcc.s	locret_30FE
		move.b	3(a1),(unk_FFF792).w
		addq.w	#2,(unk_FFF790).w

locret_30FE:
		rts
; ---------------------------------------------------------------------------

off_3100:	dc.l byte_614C6, byte_614C6, byte_614C6, byte_61434, byte_61578
		dc.l byte_61578, byte_6161E
		dc.b 0
		dc.b $8B
		dc.b 8
		dc.b $37					; 7
		dc.b 0
		dc.b $42					; B
		dc.b 8
		dc.b $5C					; \
		dc.b 0
		dc.b $6A					; j
		dc.b 8
		dc.b $5F					; _
		dc.b 0
		dc.b $2F					; /
		dc.b 8
		dc.b $2C					; ,
		dc.b 0
		dc.b $21					; !
		dc.b 8
		dc.b 3
		dc.b $28					; (
		dc.b $30					; 0
		dc.b 8
		dc.b 8
		dc.b 0
		dc.b $2E					; .
		dc.b 8
		dc.b $15
		dc.b 0
		dc.b $F
		dc.b 8
		dc.b $46					; F
		dc.b 0
		dc.b $1A
		dc.b 8
		dc.b $FF
		dc.b 8
		dc.b $CA
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
; ---------------------------------------------------------------------------
		cmpi.b	#6,(level).w
		bne.s	locret_3176
		bsr.w	sub_3178
		lea	((byte_FF0900)&$FFFFFF).l,a1
		bsr.s	sub_3166
		lea	((byte_FF3380)&$FFFFFF).l,a1
; ---------------------------------------------------------------------------

sub_3166:
		lea	(word_3196).l,a0
		move.w	#$1F,d1

loc_3170:
		move.w	(a0)+,(a1)+
		dbf	d1,loc_3170

locret_3176:
		rts
; ---------------------------------------------------------------------------

sub_3178:
		lea	((Chunks)&$FFFFFF).l,a1
		lea	(word_31D6).l,a0
		move.w	#$B,d1

loc_3188:
		move.w	(a0)+,d0
		ori.w	#$2000,(a1,d0.w)
		dbf	d1,loc_3188
		rts
; ---------------------------------------------------------------------------

word_3196:	dc.w $2024, $2808, $2808, $2808, $207B, 0, 0, 0, $2024
		dc.w $2808, $207B, 0, 0, 0, 0, 0, $30C7, $30C7, $30C7
		dc.w $30C7, $30C7, 0, 0, 0, $3024, $3808, $307B, 0, 0
		dc.w 0, 0, 0

word_31D6:	dc.w $517E, $519E, $51BE, $5360, $5362, $5364, $5380, $5382
		dc.w $5384, $53A0, $53A2, $53A4
; ---------------------------------------------------------------------------

sub_31EE:
		cmpi.b	#2,(level).w
		beq.s	loc_321A
		cmpi.b	#3,(level).w
		beq.s	loc_3204
		tst.b	(level).w
		bne.s	locret_3218

loc_3204:
		lea	((Blocks+$1790)).w,a1
		lea	(word_3230).l,a0
		move.w	#$37,d1

loc_3212:
		move.w	(a0)+,(a1)+
		dbf	d1,loc_3212

locret_3218:
		rts
; ---------------------------------------------------------------------------

loc_321A:
		lea	((Blocks+$17A0)).w,a1
		lea	(word_32A0).l,a0
		move.w	#$2F,d1

loc_3228:
		move.w	(a0)+,(a1)+
		dbf	d1,loc_3228
		rts
; ---------------------------------------------------------------------------

word_3230:	dc.w $4378, $4379, $437A, $437B, $437C, $437D, $437E, $437F
		dc.w $235C, $235D, $235E, $235F, $2360, $2361, $2362, $2363
		dc.w $2364, $2365, $2366, $2367, $2368, $2369, $236A, $236B
		dc.w 0, 0, $636C, $636D, 0, 0, $636E, 0, $636F, $6370
		dc.w $6371, $6372, $6373, 0, $6374, 0, $6375, $6376, $4358
		dc.w $4359, $6377, 0, $435A, $435B, $C378, $C379, $C37A
		dc.w $C37B, $C37C, $C37D, $C37E, $C37F

word_32A0:	dc.w $4238, $4234, $62F2, $62F5, $62F3, $62F6, $62F4, $62F7
		dc.w $E2D2, $E2D6, $E2D3, $E2D7, $E2DA, $E2DE, $E2DB, $E2DF
		dc.w $E2D4, $E2D8, $E2D5, $E2D9, $E2DC, $E2E0, $E2DD, $E2E1
		dc.w $E2E2, $E2E4, $E2E3, $E2E5, $E2E6, $E2E8, $E2E7, $E2E9
		dc.w $62EA, $62EE, $62EB, $62EF, $6AEE, $6AEA, $6AEF, $6AEB
		dc.w $62EC, $62F0, $62ED, $62F1, $6AF0, $6AEC, $6AF1, $6AED
; ---------------------------------------------------------------------------

nullsub_1:
		rts
; ---------------------------------------------------------------------------
		move.l	#$5E000002,($C00004).l
		lea	(ArtText).l,a0
		move.w	#$9F,d1
		bsr.s	sub_3326
		lea	(ArtText).l,a0
		adda.w	#$220,a0
		move.w	#$5F,d1
; ---------------------------------------------------------------------------

sub_3326:
		move.w	(a0)+,($C00000).l
		dbf	d1,sub_3326
		rts
; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.b	(a0)+,d0
		ror.w	#1,d0
		lsr.b	#3,d0
		rol.w	#1,d0
		move.b	byte_335C(pc,d0.w),d2
		lsl.w	#8,d2
		moveq	#0,d0
		move.b	(a0)+,d0
		ror.w	#1,d0
		lsr.b	#3,d0
		rol.w	#1,d0
		move.b	byte_335C(pc,d0.w),d2
		move.w	d2,($C00000).l
		dbf	d1,sub_3326
		rts
; ---------------------------------------------------------------------------

byte_335C:	dc.b 0, 6, $60, $66
; ---------------------------------------------------------------------------

oscInit:
		lea	(oscValues).w,a1
		lea	(oscInitTable).l,a2
		moveq	#$20,d1

loc_336C:
		move.w	(a2)+,(a1)+
		dbf	d1,loc_336C
		rts
; ---------------------------------------------------------------------------

oscInitTable:	dc.w $7C, $80, 0, $80, 0, $80, 0, $80, 0, $80, 0, $80
		dc.w 0, $80, 0, $80, 0, $80, 0, $50F0, $11E, $2080, $B4
		dc.w $3080, $10E, $5080, $1C2, $7080, $276, $80, 0, $80
		dc.w 0
; ---------------------------------------------------------------------------

oscUpdate:
		cmpi.b	#6,(ObjectsList+$24).w
		bcc.s	locret_340C
		lea	(oscValues).w,a1
		lea	(oscUpdateTable).l,a2
		move.w	(a1)+,d3
		moveq	#$F,d1

loc_33CC:
		move.w	(a2)+,d2
		move.w	(a2)+,d4
		btst	d1,d3
		bne.s	loc_33EC
		move.w	2(a1),d0
		add.w	d2,d0
		move.w	d0,2(a1)
		add.w	d0,0(a1)
		cmp.b	0(a1),d4
		bhi.s	loc_3402
		bset	d1,d3
		bra.s	loc_3402
; ---------------------------------------------------------------------------

loc_33EC:
		move.w	2(a1),d0
		sub.w	d2,d0
		move.w	d0,2(a1)
		add.w	d0,0(a1)
		cmp.b	0(a1),d4
		bls.s	loc_3402
		bclr	d1,d3

loc_3402:
		addq.w	#4,a1
		dbf	d1,loc_33CC
		move.w	d3,(oscValues).w

locret_340C:
		rts
; ---------------------------------------------------------------------------

oscUpdateTable:	dc.w 2, $10
		dc.w 2, $18
		dc.w 2, $20
		dc.w 2, $30
		dc.w 4, $20
		dc.w 8, 8
		dc.w 8, $40
		dc.w 4, $40
		dc.w 2, $50
		dc.w 2, $50
		dc.w 2, $20
		dc.w 3, $30
		dc.w 5, $50
		dc.w 7, $70
		dc.w 2, $10
		dc.w 2, $10
; ---------------------------------------------------------------------------

UpdateTimers:
		subq.b	#1,(unk_FFFEC0).w
		bpl.s	loc_3464
		move.b	#$B,(unk_FFFEC0).w
		subq.b	#1,(unk_FFFEC1).w
		andi.b	#7,(unk_FFFEC1).w

loc_3464:
		subq.b	#1,(RingTimer).w
		bpl.s	loc_347A
		move.b	#7,(RingTimer).w
		addq.b	#1,(RingFrame).w
		andi.b	#3,(RingFrame).w

loc_347A:
		subq.b	#1,(unk_FFFEC4).w
		bpl.s	loc_3498
		move.b	#7,(unk_FFFEC4).w
		addq.b	#1,(unk_FFFEC5).w
		cmpi.b	#6,(unk_FFFEC5).w
		bcs.s	loc_3498
		move.b	#0,(unk_FFFEC5).w

loc_3498:
		tst.b	(RingLossTimer).w
		beq.s	locret_34BA
		moveq	#0,d0
		move.b	(RingLossTimer).w,d0
		add.w	(RingLossAccumulator).w,d0
		move.w	d0,(RingLossAccumulator).w
		rol.w	#7,d0
		andi.w	#3,d0
		move.b	d0,(RingLossFrame).w
		subq.b	#1,(RingLossTimer).w

locret_34BA:
		rts
; ---------------------------------------------------------------------------

LoadSignpostPLC:
		tst.w	(DebugRoutine).w
		bne.w	locret_34FA
		cmpi.w	#$202,(level).w
		beq.s	loc_34D4
		cmpi.b	#2,(level+1).w
		beq.s	locret_34FA

loc_34D4:
		move.w	(CameraX).w,d0
		move.w	(unk_FFF72A).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0
		blt.s	locret_34FA
		tst.b	(byte_FFFE1E).w
		beq.s	locret_34FA
		cmp.w	(unk_FFF728).w,d1
		beq.s	locret_34FA
		move.w	d1,(unk_FFF728).w
		moveq	#$12,d0
		bra.w	plcReplace
; ---------------------------------------------------------------------------

locret_34FA:
		rts
; ---------------------------------------------------------------------------

sSpecial:
		bsr.w	sub_19D2
		move.w	(ModeReg2).w,d0
		andi.b	#$BF,d0
		move.w	d0,($C00004).l
		bsr.w	sub_10A6
		lea	($C00004).l,a5
		move.w	#$8F01,(a5)
		move.l	#$946F93FF,(a5)
		move.w	#$9780,(a5)
		move.l	#$50000081,(a5)
		move.w	#0,($C00000).l

loc_3534:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	loc_3534
		move.w	#$8F02,(a5)
		moveq	#$14,d0
		bsr.w	sub_14E2
		bsr.w	ssLoadBG
		lea	(ObjectsList).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

loc_3554:
		move.l	d0,(a1)+
		dbf	d1,loc_3554
		lea	(CameraX).w,a1
		moveq	#0,d0
		move.w	#$3F,d1

loc_3564:
		move.l	d0,(a1)+
		dbf	d1,loc_3564
		lea	((oscValues+2)).w,a1
		moveq	#0,d0
		move.w	#$27,d1

loc_3574:
		move.l	d0,(a1)+
		dbf	d1,loc_3574
		lea	(byte_FFAA00).w,a1
		moveq	#0,d0
		move.w	#$7F,d1

loc_3584:
		move.l	d0,(a1)+
		dbf	d1,loc_3584
		moveq	#$A,d0
		bsr.w	palLoadFade
		jsr	sub_10B70
		move.l	#0,(CameraX).w
		move.l	#0,(CameraY).w
		move.b	#9,(ObjectsList).w
		move.w	#$458,(ObjectsList+8).w
		move.w	#$4A0,(ObjectsList+$C).w
		lea	($C00004).l,a6
		move.w	#$8B03,(a6)
		move.w	#$8004,(a6)
		move.w	#$8AAF,(word_FFF624).w
		move.w	#$9011,(a6)
		bsr.w	sSpecialPalCyc
		clr.w	(unk_FFF780).w
		move.w	#$40,(unk_FFF782).w
		move.w	#$89,d0
		bsr.w	PlaySFX
		move.w	#0,(unk_FFF790).w
		lea	(off_3100).l,a1
		moveq	#0,d0
		move.b	(level).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.b	1(a1),(unk_FFF792).w
		subq.b	#1,(unk_FFF792).w
		move.w	#$708,(GlobalTimer).w
		move.w	(ModeReg2).w,d0
		ori.b	#$40,d0
		move.w	d0,($C00004).l
		bsr.w	sub_1950

loc_3620:
		bsr.w	PauseGame
		move.b	#$A,(VintRoutine).w
		bsr.w	vsync
		bsr.w	DemoPlayback
		move.w	(padHeld1).w,(padHeldPlayer).w
		bsr.w	RunObjects
		bsr.w	ProcessMaps
		jsr	sub_10872
		bsr.w	sSpecialAnimateBG
		tst.w	(DemoMode).w
		beq.s	loc_3656
		tst.w	(GlobalTimer).w
		beq.s	loc_3662

loc_3656:
		cmpi.b	#$10,(GameMode).w
		beq.w	loc_3620
		rts
; ---------------------------------------------------------------------------

loc_3662:
		move.b	#0,(GameMode).w
		rts
; ---------------------------------------------------------------------------

ssLoadBG:
		lea	((Chunks)&$FFFFFF).l,a1
		lea	(byte_639B8).l,a0
		move.w	#$4051,d0
		bsr.w	EnigmaDec
		move.l	#$50000001,d3
		lea	((byte_FF0080)&$FFFFFF).l,a2
		moveq	#6,d7

loc_368C:
		move.l	d3,d0
		moveq	#3,d6
		moveq	#0,d4
		cmpi.w	#3,d7
		bcc.s	loc_369A
		moveq	#1,d4

loc_369A:
		moveq	#7,d5

loc_369C:
		movea.l	a2,a1
		eori.b	#1,d4
		bne.s	loc_36B0
		cmpi.w	#6,d7
		bne.s	loc_36C0
		lea	((Chunks)&$FFFFFF).l,a1

loc_36B0:
		movem.l	d0-d4,-(sp)
		moveq	#7,d1
		moveq	#7,d2
		bsr.w	LoadPlaneMaps
		movem.l	(sp)+,d0-d4

loc_36C0:
		addi.l	#$100000,d0
		dbf	d5,loc_369C
		addi.l	#$3800000,d0
		eori.b	#1,d4
		dbf	d6,loc_369A
		addi.l	#$10000000,d3
		bpl.s	loc_36EA
		swap	d3
		addi.l	#$C000,d3
		swap	d3

loc_36EA:
		adda.w	#$80,a2
		dbf	d7,loc_368C
		lea	((Chunks)&$FFFFFF).l,a1
		lea	(byte_6477C).l,a0
		move.w	#$4000,d0
		bsr.w	EnigmaDec
		lea	((Chunks)&$FFFFFF).l,a1
		move.l	#$40000003,d0
		moveq	#$3F,d1
		moveq	#$1F,d2
		bsr.w	LoadPlaneMaps
		lea	((Chunks)&$FFFFFF).l,a1
		move.l	#$50000003,d0
		moveq	#$3F,d1
		moveq	#$3F,d2
		bsr.w	LoadPlaneMaps
		rts
; ---------------------------------------------------------------------------

sSpecialPalCyc:
		tst.w	(PauseFlag).w
		bmi.s	locret_37B4
		subq.w	#1,(unk_FFF79C).w
		bpl.s	locret_37B4
		lea	($C00004).l,a6
		move.w	(unk_FFF79A).w,d0
		addq.w	#1,(unk_FFF79A).w
		andi.w	#$1F,d0
		lsl.w	#2,d0
		lea	(byte_380A).l,a0
		adda.w	d0,a0
		move.b	(a0)+,d0
		bpl.s	loc_3760
		move.w	#$1FF,d0

loc_3760:
		move.w	d0,(unk_FFF79C).w
		moveq	#0,d0
		move.b	(a0)+,d0
		move.w	d0,(unk_FFF7A0).w
		lea	(byte_388A).l,a1
		lea	(a1,d0.w),a1
		move.w	#$8200,d0
		move.b	(a1)+,d0
		move.w	d0,(a6)
		move.b	(a1),(dword_FFF616).w
		move.w	#$8400,d0
		move.b	(a0)+,d0
		move.w	d0,(a6)
		move.l	#$40000010,($C00004).l
		move.l	(dword_FFF616).w,($C00000).l
		moveq	#0,d0
		move.b	(a0)+,d0
		bmi.s	loc_37B6
		lea	(dword_3898).l,a1
		adda.w	d0,a1
		lea	((Palette+$4E)).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+

locret_37B4:
		rts
; ---------------------------------------------------------------------------

loc_37B6:
		move.w	(unk_FFF79E).w,d1
		cmpi.w	#$8A,d0
		bcs.s	loc_37C2
		addq.w	#1,d1

loc_37C2:
		mulu.w	#$2A,d1
		lea	(word_38E0).l,a1
		adda.w	d1,a1
		andi.w	#$7F,d0
		bclr	#0,d0
		beq.s	loc_37E6
		lea	((Palette+$6E)).w,a2
		move.l	(a1),(a2)+
		move.l	4(a1),(a2)+
		move.l	8(a1),(a2)+

loc_37E6:
		adda.w	#$C,a1
		lea	((Palette+$5A)).w,a2
		cmpi.w	#$A,d0
		bcs.s	loc_37FC
		subi.w	#$A,d0
		lea	((Palette+$7A)).w,a2

loc_37FC:
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		adda.w	d0,a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		rts
; ---------------------------------------------------------------------------

byte_380A:	dc.b 3, 0, 7, $92, 3, 0, 7, $90, 3, 0, 7, $8E, 3, 0, 7
		dc.b $8C, 3, 0, 7, $8B, 3, 0, 7, $80, 3, 0, 7, $82, 3
		dc.b 0, 7, $84, 3, 0, 7, $86, 3, 0, 7, $88, 7, 8, 7, 0
		dc.b 7, $A, 7, $C, $FF, $C, 7, $18, $FF, $C, 7, $18, 7
		dc.b $A, 7, $C, 7, 8, 7, 0, 3, 0, 6, $88, 3, 0, 6, $86
		dc.b 3, 0, 6, $84, 3, 0, 6, $82, 3, 0, 6, $81, 3, 0, 6
		dc.b $8A, 3, 0, 6, $8C, 3, 0, 6, $8E, 3, 0, 6, $90, 3
		dc.b 0, 6, $92, 7, 2, 6, $24, 7, 4, 6, $30, $FF, 6, 6
		dc.b $3C, $FF, 6, 6, $3C, 7, 4, 6, $30, 7, 2, 6, $24

byte_388A:	dc.b $10, 1, $18, 0, $18, 1, $20, 0, $20, 1, $28, 0, $28
		dc.b 1

dword_3898:	dc.l $4000600, $6200624, $6640666, $6000820, $A640A68
		dc.l $AA60AAA, $8000C42, $E860ECA, $EEC0EEE, $4000420
		dc.l $6200620, $8640666, $4200620, $8420842, $A860AAA
		dc.l $6200842, $A640C86, $EA80EEE
word_38E0:	incbin "unknown/038E0.pal"
		even
; ---------------------------------------------------------------------------

sSpecialAnimateBG:
		move.w	(unk_FFF7A0).w,d0
		bne.s	loc_39C4
		move.w	#0,(unk_FFF70C).w
		move.w	(unk_FFF70C).w,(dword_FFF616+2).w

loc_39C4:
		cmpi.w	#8,d0
		bcc.s	loc_3A1C
		cmpi.w	#6,d0
		bne.s	loc_39DE
		addq.w	#1,(unk_FFF718).w
		addq.w	#1,(unk_FFF70C).w
		move.w	(unk_FFF70C).w,(dword_FFF616+2).w

loc_39DE:
		moveq	#0,d0
		move.w	(unk_FFF708).w,d0
		neg.w	d0
		swap	d0
		lea	(byte_3A9A).l,a1
		lea	(byte_FFAA00).w,a3
		moveq	#9,d3

loc_39F4:
		move.w	2(a3),d0
		bsr.w	GetSine
		moveq	#0,d2
		move.b	(a1)+,d2
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,(a3)+
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d2,(a3)+
		dbf	d3,loc_39F4
		lea	(byte_FFAA00).w,a3
		lea	(byte_3A86).l,a2
		bra.s	loc_3A4C
; ---------------------------------------------------------------------------

loc_3A1C:
		cmpi.w	#$C,d0
		bne.s	loc_3A42
		subq.w	#1,(unk_FFF718).w
		lea	(byte_FFAB00).w,a3
		move.l	#$18000,d2
		moveq	#6,d1

loc_3A32:
		move.l	(a3),d0
		sub.l	d2,d0
		move.l	d0,(a3)+
		subi.l	#$2000,d2
		dbf	d1,loc_3A32

loc_3A42:
		lea	(byte_FFAB00).w,a3
		lea	(byte_3A92).l,a2

loc_3A4C:
		lea	(ScrollTable).w,a1
		move.w	(unk_FFF718).w,d0
		neg.w	d0
		swap	d0
		moveq	#0,d3
		move.b	(a2)+,d3
		move.w	(unk_FFF70C).w,d2
		neg.w	d2
		andi.w	#$FF,d2
		lsl.w	#2,d2

loc_3A68:
		move.w	(a3)+,d0
		addq.w	#2,a3
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.w	#1,d1

loc_3A72:
		move.l	d0,(a1,d2.w)
		addq.w	#4,d2
		andi.w	#$3FC,d2
		dbf	d1,loc_3A72
		dbf	d3,loc_3A68
		rts
; ---------------------------------------------------------------------------

byte_3A86:	dc.b 9, $28, $18, $10, $28, $18, $10, $30, $18, 8, $10
		dc.b 0

byte_3A92:	dc.b 6, $30, $30, $30, $28, $18, $18, $18

byte_3A9A:	dc.b 8, 2, 4, $FF, 2, 3, 8, $FF, 4, 2, 2, 3, 8, $FD, 4
		dc.b 2, 2, 3, 2, $FF
; ---------------------------------------------------------------------------

LoadLevelBounds:
		moveq	#0,d0
		move.b	d0,(unk_FFF740).w
		move.b	d0,(unk_FFF741).w
		move.b	d0,(unk_FFF746).w
		move.b	d0,(unk_FFF748).w
		move.b	d0,(EventsRoutine).w
		move.w	(level).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	LevelBoundArray(pc,d0.w),a0
		move.w	(a0)+,d0
		move.w	d0,(unk_FFF730).w
		move.l	(a0)+,d0
		move.l	d0,(unk_FFF728).w
		move.l	d0,(unk_FFF720).w
		cmp.w	(unk_FFF728).w,d0
		bne.s	loc_3AF2
		move.b	#1,(unk_FFF740).w

loc_3AF2:
		move.l	(a0)+,d0
		move.l	d0,(unk_FFF72C).w
		move.l	d0,(unk_FFF724).w
		cmp.w	(unk_FFF72C).w,d0
		bne.s	loc_3B08
		move.b	#1,(unk_FFF741).w

loc_3B08:
		move.w	(unk_FFF728).w,d0
		addi.w	#$240,d0
		move.w	d0,(unk_FFF732).w
		move.w	(a0)+,d0
		move.w	d0,(unk_FFF73E).w
		bra.w	loc_3C6E
; ---------------------------------------------------------------------------

LevelBoundArray:
		dc.w 4, 0, $24BF, 0, $300, $60
		dc.w 4, 0, $1EBF, 0, $300, $60
		dc.w 4, 0, $2960, 0, $300, $60
		dc.w 4, 0, $2ABF, 0, $300, $60
		dc.w 4, 0, $17BF, 0, $720, $60
		dc.w 4, 0, $EBF, 0, $720, $60
		dc.w 4, 0, $1EBF, 0, $720, $60
		dc.w 4, 0, $1EBF, 0, $720, $60
		dc.w 4, 0, $17BF, 0, $1D0, $60
		dc.w 4, 0, $1BBF, 0, $520, $60
		dc.w 4, 0, $163F, 0, $720, $60
		dc.w 4, 0, $16BF, 0, $720, $60
		dc.w 4, 0, $1EBF, 0, $640, $60
		dc.w 4, 0, $20BF, 0, $640, $60
		dc.w 4, 0, $1EBF, 0, $6C0, $60
		dc.w 4, 0, $3EC0, 0, $720, $60
		dc.w 4, 0, $22C0, 0, $420, $60
		dc.w 4, 0, $28C0, 0, $520, $60
		dc.w 4, 0, $2EC0, 0, $620, $60
		dc.w 4, 0, $29C0, 0, $620, $60
		dc.w 4, 0, $3EC0, 0, $720, $60
		dc.w 4, 0, $3EC0, 0, $720, $60
		dc.w 4, 0, $3EC0, 0, $720, $60
		dc.w 4, 0, $3EC0, 0, $720, $60
		dc.w 4, 0, $2FFF, 0, $320, $60
		dc.w 4, 0, $2FFF, 0, $320, $60
		dc.w 4, 0, $2FFF, 0, $320, $60
		dc.w 4, 0, $2FFF, 0, $320, $60
; ---------------------------------------------------------------------------

loc_3C6E:
		move.w	(level).w,d0
		cmpi.b	#3,d0
		bne.s	loc_3C7C
		subq.b	#1,(level+1).w

loc_3C7C:
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	StartPositionArray(pc,d0.w),a1
		moveq	#0,d1
		move.w	(a1)+,d1
		move.w	d1,(ObjectsList+8).w
		subi.w	#$A0,d1
		bcc.s	loc_3C94
		moveq	#0,d1

loc_3C94:
		move.w	d1,(CameraX).w
		moveq	#0,d0
		move.w	(a1),d0
		move.w	d0,(ObjectsList+$C).w
		subi.w	#$60,d0
		bcc.s	loc_3CA8
		moveq	#0,d0

loc_3CA8:
		cmp.w	(unk_FFF72E).w,d0
		blt.s	loc_3CB2
		move.w	(unk_FFF72E).w,d0

loc_3CB2:
		move.w	d0,(CameraY).w
		bsr.w	initLevelBG
		moveq	#0,d0
		move.b	(level).w,d0
		lsl.b	#2,d0
		move.l	SpecialChunkArray(pc,d0.w),(unk_FFF7AC).w
		bra.w	LoadLevelUnk
; ---------------------------------------------------------------------------

StartPositionArray:
		dc.w $50, $3B0
		dc.w $50, $FC
		dc.w $50, $3B0
		dc.w $80, $A8
		dc.w $60, $6C
		dc.w $50, $EC
		dc.w $50, $2EC
		dc.w $80, $A8
		dc.w $30, $266
		dc.w $30, $266
		dc.w $30, $166
		dc.w $80, $A8
		dc.w $40, $2EC
		dc.w $40, $16C
		dc.w $40, $16C
		dc.w $80, $A8
		dc.w $30, $3BD
		dc.w $30, $18E
		dc.w $30, $EC
		dc.w $80, $A8
		dc.w $30, $48C
		dc.w $98, $28C
		dc.w $80, $A8
		dc.w $80, $A8
		dc.w $80, $A8
		dc.w $80, $A8
		dc.w $80, $A8
		dc.w $80, $A8

SpecialChunkArray:
		dc.b $B5, $7F, $1F, $20
		dc.b $7F, $7F, $7F, $7F
		dc.b $7F, $7F, $7F, $7F
		dc.b $B5, $A8, $7F, $7F
		dc.b $7F, $7F, $7F, $7F
		dc.b $7F, $7F, $7F, $7F
; ---------------------------------------------------------------------------

LoadLevelUnk:
		moveq	#0,d0
		move.b	(level).w,d0
		lsl.w	#3,d0
		lea	dword_3D6A(pc,d0.w),a1
		lea	(unk_FFF7F0).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		rts
; ---------------------------------------------------------------------------

dword_3D6A:	dc.l $700100, $1000100
		dc.l $8000100, $1000000
		dc.l $8000100, $1000000
		dc.l $8000100, $1000000
		dc.l $8000100, $1000000
		dc.l $8000100, $1000000
; ---------------------------------------------------------------------------

initLevelBG:
		move.w	d0,(unk_FFF70C).w
		move.w	d0,(unk_FFF714).w
		swap	d1
		move.l	d1,(unk_FFF708).w
		move.l	d1,(unk_FFF710).w
		move.l	d1,(unk_FFF718).w
		moveq	#0,d2
		move.b	(level).w,d2
		add.w	d2,d2
		move.w	off_3DC0(pc,d2.w),d2
		jmp	off_3DC0(pc,d2.w)
; ---------------------------------------------------------------------------

off_3DC0:	dc.w InitBGHZ-off_3DC0, initLevelLZ-off_3DC0, initLevelMZ-off_3DC0, initLevelSLZ-off_3DC0
		dc.w initLevelSYZ-off_3DC0, initLevelSBZ-off_3DC0
; ---------------------------------------------------------------------------

InitBGHZ:
		bra.w	HScrollGHZ
; ---------------------------------------------------------------------------

initLevelLZ:
		rts
; ---------------------------------------------------------------------------

initLevelMZ:
		rts
; ---------------------------------------------------------------------------

initLevelSLZ:
		asr.l	#1,d0
		addi.w	#$C0,d0
		move.w	d0,(unk_FFF70C).w
		rts
; ---------------------------------------------------------------------------

initLevelSYZ:
		asl.l	#4,d0
		move.l	d0,d2
		asl.l	#1,d0
		add.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(unk_FFF70C).w
		move.w	d0,(unk_FFF714).w
		rts
; ---------------------------------------------------------------------------

initLevelSBZ:
		rts
; ---------------------------------------------------------------------------

LevelScroll:
		tst.b	(unk_FFF744).w
		bne.s	loc_3E18
		tst.b	(unk_FFF740).w
		bne.w	loc_4258
		bsr.w	camMoveHoriz

loc_3E08:
		tst.b	(unk_FFF741).w
		bne.w	loc_4276
		bsr.w	camMoveVerti

loc_3E14:
		bsr.w	LevelEvents

loc_3E18:
		move.w	(CameraX).w,(dword_FFF61A).w
		move.w	(CameraY).w,(dword_FFF616).w
		move.w	(unk_FFF708).w,(dword_FFF61A+2).w
		move.w	(unk_FFF70C).w,(dword_FFF616+2).w
		move.w	(unk_FFF718).w,(word_FFF620).w
		move.w	(unk_FFF71C).w,(word_FFF61E).w
		moveq	#0,d0
		move.b	(level).w,d0
		add.w	d0,d0
		move.w	@scroll(pc,d0.w),d0
		jmp	@scroll(pc,d0.w)
; ---------------------------------------------------------------------------

@scroll:	dc.w HScrollGHZ-@scroll, HScrollLZ-@scroll, HScrollMZ-@scroll, HScrollSLZ-@scroll
		dc.w HScrollSYZ-@scroll, HScrollSBZ-@scroll
; ---------------------------------------------------------------------------

HScrollGHZ:
		move.w	(unk_FFF73A).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d5
		bsr.w	sub_4298
		bsr.w	sub_4374
		lea	(ScrollTable).w,a1
		move.w	(CameraY).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$26,d0
		move.w	d0,(unk_FFF714).w
		move.w	d0,d4
		bsr.w	sub_4344
		move.w	(unk_FFF70C).w,(dword_FFF616+2).w
		move.w	#$6F,d1
		sub.w	d4,d1
		move.w	(CameraX).w,d0
		cmpi.b	#4,(GameMode).w
		bne.s	loc_3EA8
		moveq	#0,d0

loc_3EA8:
		neg.w	d0
		swap	d0
		move.w	(unk_FFF708).w,d0
		neg.w	d0

loc_3EB2:
		move.l	d0,(a1)+
		dbf	d1,loc_3EB2
		move.w	#$27,d1
		move.w	(unk_FFF710).w,d0
		neg.w	d0

loc_3EC2:
		move.l	d0,(a1)+
		dbf	d1,loc_3EC2
		move.w	(unk_FFF710).w,d0
		addi.w	#0,d0
		move.w	(CameraX).w,d2
		addi.w	#-$200,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$47,d1
		add.w	d4,d1

loc_3EF0:
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,loc_3EF0
		rts
; ---------------------------------------------------------------------------

HScrollLZ:
		lea	(ScrollTable).w,a1
		move.w	#$DF,d1
		move.w	(CameraX).w,d0
		neg.w	d0
		swap	d0
		move.w	(unk_FFF708).w,d0
		move.w	#0,d0
		neg.w	d0

loc_3F1C:
		move.l	d0,(a1)+
		dbf	d1,loc_3F1C
		rts
; ---------------------------------------------------------------------------

HScrollMZ:
		move.w	(unk_FFF73A).w,d4
		ext.l	d4
		asl.l	#6,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d5
		bsr.w	sub_4298
		move.w	#$200,d0
		move.w	(CameraY).w,d1
		subi.w	#$1C8,d1
		bcs.s	loc_3F50
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0

loc_3F50:
		move.w	d0,(unk_FFF714).w
		bsr.w	sub_4344
		move.w	(unk_FFF70C).w,(dword_FFF616+2).w
		lea	(ScrollTable).w,a1
		move.w	#$DF,d1
		move.w	(CameraX).w,d0
		neg.w	d0
		swap	d0
		move.w	(unk_FFF708).w,d0
		neg.w	d0

loc_3F74:
		move.l	d0,(a1)+
		dbf	d1,loc_3F74
		rts
; ---------------------------------------------------------------------------

HScrollSLZ:
		move.w	(unk_FFF73A).w,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	(unk_FFF73C).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	sub_4302
		move.w	(unk_FFF70C).w,(dword_FFF616+2).w
		bsr.w	sub_3FF6
		lea	(byte_FFA800).w,a2
		move.w	(unk_FFF70C).w,d0
		move.w	d0,d2
		subi.w	#$C0,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		lea	(ScrollTable).w,a1
		move.w	#$E,d1
		move.w	(CameraX).w,d0
		neg.w	d0
		swap	d0
		andi.w	#$F,d2
		add.w	d2,d2
		move.w	(a2)+,d0
		jmp	loc_3FD0(pc,d2.w)
; ---------------------------------------------------------------------------

loc_3FCE:
		move.w	(a2)+,d0

loc_3FD0:
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbf	d1,loc_3FCE
		rts
; ---------------------------------------------------------------------------

sub_3FF6:
		lea	(byte_FFA800).w,a1
		move.w	(CameraX).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$1C,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#$1B,d1

loc_401C:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_401C
		move.w	d2,d0
		asr.w	#3,d0
		move.w	#4,d1

loc_4030:
		move.w	d0,(a1)+
		dbf	d1,loc_4030
		move.w	d2,d0
		asr.w	#2,d0
		move.w	#4,d1

loc_403E:
		move.w	d0,(a1)+
		dbf	d1,loc_403E
		move.w	d2,d0
		asr.w	#1,d0
		move.w	#$1D,d1

loc_404C:
		move.w	d0,(a1)+
		dbf	d1,loc_404C
		rts
; ---------------------------------------------------------------------------

HScrollSYZ:
		move.w	(unk_FFF73A).w,d4
		ext.l	d4
		asl.l	#6,d4
		move.w	(unk_FFF73C).w,d5
		ext.l	d5
		asl.l	#4,d5
		move.l	d5,d1
		asl.l	#1,d5
		add.l	d1,d5
		bsr.w	sub_4298
		move.w	(unk_FFF70C).w,(dword_FFF616+2).w
		lea	(ScrollTable).w,a1
		move.w	#$DF,d1
		move.w	(CameraX).w,d0
		neg.w	d0
		swap	d0
		move.w	(unk_FFF708).w,d0
		neg.w	d0

loc_408A:
		move.l	d0,(a1)+
		dbf	d1,loc_408A
		rts
; ---------------------------------------------------------------------------

HScrollSBZ:
		lea	(ScrollTable).w,a1
		move.w	#$DF,d1
		move.w	(CameraX).w,d0
		neg.w	d0
		swap	d0
		move.w	(unk_FFF708).w,d0
		move.w	#0,d0
		neg.w	d0

loc_40AC:
		move.l	d0,(a1)+
		dbf	d1,loc_40AC
		rts
; ---------------------------------------------------------------------------

camMoveHoriz:
		move.w	(CameraX).w,d4
		bsr.s	sub_40E8
		move.w	(CameraX).w,d0
		andi.w	#$10,d0
		move.b	(unk_FFF74A).w,d1
		eor.b	d1,d0
		bne.s	locret_40E6
		eori.b	#$10,(unk_FFF74A).w
		move.w	(CameraX).w,d0
		sub.w	d4,d0
		bpl.s	loc_40E0
		bset	#2,(unk_FFF754).w
		rts
; ---------------------------------------------------------------------------

loc_40E0:
		bset	#3,(unk_FFF754).w

locret_40E6:
		rts
; ---------------------------------------------------------------------------

sub_40E8:
		move.w	(ObjectsList+8).w,d0
		sub.w	(CameraX).w,d0
		subi.w	#$90,d0
		bcs.s	loc_412C
		subi.w	#$10,d0
		bcc.s	loc_4102
		clr.w	(unk_FFF73A).w
		rts
; ---------------------------------------------------------------------------

loc_4102:
		cmpi.w	#$10,d0
		bcs.s	loc_410C
		move.w	#$10,d0

loc_410C:
		add.w	(CameraX).w,d0
		cmp.w	(unk_FFF72A).w,d0
		blt.s	loc_411A
		move.w	(unk_FFF72A).w,d0

loc_411A:
		move.w	d0,d1
		sub.w	(CameraX).w,d1
		asl.w	#8,d1
		move.w	d0,(CameraX).w
		move.w	d1,(unk_FFF73A).w
		rts
; ---------------------------------------------------------------------------

loc_412C:
		add.w	(CameraX).w,d0
		cmp.w	(unk_FFF728).w,d0
		bgt.s	loc_411A
		move.w	(unk_FFF728).w,d0
		bra.s	loc_411A
; ---------------------------------------------------------------------------
		tst.w	d0
		bpl.s	loc_4146
		move.w	#$FFFE,d0
		bra.s	loc_412C
; ---------------------------------------------------------------------------

loc_4146:
		move.w	#2,d0
		bra.s	loc_4102
; ---------------------------------------------------------------------------

camMoveVerti:
		moveq	#0,d1
		move.w	(ObjectsList+$C).w,d0
		sub.w	(CameraY).w,d0
		btst	#2,(ObjectsList+$22).w
		beq.s	loc_4160
		subq.w	#5,d0

loc_4160:
		btst	#1,(ObjectsList+$22).w
		beq.s	loc_4180
		addi.w	#$20,d0
		sub.w	(unk_FFF73E).w,d0
		bcs.s	loc_41BE
		subi.w	#$40,d0
		bcc.s	loc_41BE
		tst.b	(unk_FFF75C).w
		bne.s	loc_41D0
		bra.s	loc_418C
; ---------------------------------------------------------------------------

loc_4180:
		sub.w	(unk_FFF73E).w,d0
		bne.s	loc_4192
		tst.b	(unk_FFF75C).w
		bne.s	loc_41D0

loc_418C:
		clr.w	(unk_FFF73C).w
		rts
; ---------------------------------------------------------------------------

loc_4192:
		cmpi.w	#$60,(unk_FFF73E).w
		bne.s	loc_41AC
		move.w	#$600,d1
		cmpi.w	#6,d0
		bgt.s	loc_4200
		cmpi.w	#$FFFA,d0
		blt.s	loc_41E8
		bra.s	loc_41D6
; ---------------------------------------------------------------------------

loc_41AC:
		move.w	#$200,d1
		cmpi.w	#2,d0
		bgt.s	loc_4200
		cmpi.w	#$FFFE,d0
		blt.s	loc_41E8
		bra.s	loc_41D6
; ---------------------------------------------------------------------------

loc_41BE:
		move.w	#$1000,d1
		cmpi.w	#$10,d0
		bgt.s	loc_4200
		cmpi.w	#$FFF0,d0
		blt.s	loc_41E8
		bra.s	loc_41D6
; ---------------------------------------------------------------------------

loc_41D0:
		moveq	#0,d0
		move.b	d0,(unk_FFF75C).w

loc_41D6:
		moveq	#0,d1
		move.w	d0,d1
		add.w	(CameraY).w,d1
		tst.w	d0
		bpl.w	loc_420A
		bra.w	loc_41F4
; ---------------------------------------------------------------------------

loc_41E8:
		neg.w	d1
		ext.l	d1
		asl.l	#8,d1
		add.l	(CameraY).w,d1
		swap	d1

loc_41F4:
		cmp.w	(unk_FFF72C).w,d1
		bgt.s	loc_4214
		move.w	(unk_FFF72C).w,d1
		bra.s	loc_4214
; ---------------------------------------------------------------------------

loc_4200:
		ext.l	d1
		asl.l	#8,d1
		add.l	(CameraY).w,d1
		swap	d1

loc_420A:
		cmp.w	(unk_FFF72E).w,d1
		blt.s	loc_4214
		move.w	(unk_FFF72E).w,d1

loc_4214:
		move.w	(CameraY).w,d4
		swap	d1
		move.l	d1,d3
		sub.l	(CameraY).w,d3
		ror.l	#8,d3
		move.w	d3,(unk_FFF73C).w
		move.l	d1,(CameraY).w
		move.w	(CameraY).w,d0
		andi.w	#$10,d0
		move.b	(unk_FFF74B).w,d1
		eor.b	d1,d0
		bne.s	locret_4256
		eori.b	#$10,(unk_FFF74B).w
		move.w	(CameraY).w,d0
		sub.w	d4,d0
		bpl.s	loc_4250
		bset	#0,(unk_FFF754).w
		rts
; ---------------------------------------------------------------------------

loc_4250:
		bset	#1,(unk_FFF754).w

locret_4256:
		rts
; ---------------------------------------------------------------------------

loc_4258:
		move.w	(unk_FFF728).w,d0
		moveq	#1,d1
		sub.w	(CameraX).w,d0
		beq.s	loc_426E
		bpl.s	loc_4268
		moveq	#-1,d1

loc_4268:
		add.w	d1,(CameraX).w
		move.w	d1,d0

loc_426E:
		move.w	d0,(unk_FFF73A).w
		bra.w	loc_3E08
; ---------------------------------------------------------------------------

loc_4276:
		move.w	(unk_FFF72C).w,d0
		addi.w	#$20,d0
		moveq	#1,d1
		sub.w	(CameraY).w,d0
		beq.s	loc_4290
		bpl.s	loc_428A
		moveq	#-1,d1

loc_428A:
		add.w	d1,(CameraY).w
		move.w	d1,d0

loc_4290:
		move.w	d0,(unk_FFF73C).w
		bra.w	loc_3E14
; ---------------------------------------------------------------------------

sub_4298:
		move.l	(unk_FFF708).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(unk_FFF708).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(unk_FFF74C).w,d3
		eor.b	d3,d1
		bne.s	loc_42CC
		eori.b	#$10,(unk_FFF74C).w
		sub.l	d2,d0
		bpl.s	loc_42C6
		bset	#2,(unk_FFF756).w
		bra.s	loc_42CC
; ---------------------------------------------------------------------------

loc_42C6:
		bset	#3,(unk_FFF756).w

loc_42CC:
		move.l	(unk_FFF70C).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(unk_FFF70C).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(unk_FFF74D).w,d2
		eor.b	d2,d1
		bne.s	locret_4300
		eori.b	#$10,(unk_FFF74D).w
		sub.l	d3,d0
		bpl.s	loc_42FA
		bset	#0,(unk_FFF756).w
		rts
; ---------------------------------------------------------------------------

loc_42FA:
		bset	#1,(unk_FFF756).w

locret_4300:
		rts
; ---------------------------------------------------------------------------

sub_4302:
		move.l	(unk_FFF708).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(unk_FFF708).w
		move.l	(unk_FFF70C).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(unk_FFF70C).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(unk_FFF74D).w,d2
		eor.b	d2,d1
		bne.s	locret_4342
		eori.b	#$10,(unk_FFF74D).w
		sub.l	d3,d0
		bpl.s	loc_433C
		bset	#0,(unk_FFF756).w
		rts
; ---------------------------------------------------------------------------

loc_433C:
		bset	#1,(unk_FFF756).w

locret_4342:
		rts
; ---------------------------------------------------------------------------

sub_4344:
		move.w	(unk_FFF70C).w,d3
		move.w	d0,(unk_FFF70C).w
		move.w	d0,d1
		andi.w	#$10,d1
		move.b	(unk_FFF74D).w,d2
		eor.b	d2,d1
		bne.s	locret_4372
		eori.b	#$10,(unk_FFF74D).w
		sub.w	d3,d0
		bpl.s	loc_436C
		bset	#0,(unk_FFF756).w
		rts
; ---------------------------------------------------------------------------

loc_436C:
		bset	#1,(unk_FFF756).w

locret_4372:
		rts
; ---------------------------------------------------------------------------

sub_4374:
		move.w	(unk_FFF710).w,d2
		move.w	(unk_FFF714).w,d3
		move.w	(unk_FFF73A).w,d0
		ext.l	d0
		asl.l	#7,d0
		add.l	d0,(unk_FFF710).w
		move.w	(unk_FFF710).w,d0
		andi.w	#$10,d0
		move.b	(unk_FFF74E).w,d1
		eor.b	d1,d0
		bne.s	locret_43B4
		eori.b	#$10,(unk_FFF74E).w
		move.w	(unk_FFF710).w,d0
		sub.w	d2,d0
		bpl.s	loc_43AE
		bset	#2,(unk_FFF758).w
		bra.s	locret_43B4
; ---------------------------------------------------------------------------

loc_43AE:
		bset	#3,(unk_FFF758).w

locret_43B4:
		rts
; ---------------------------------------------------------------------------

sub_43B6:
		lea	($C00004).l,a5
		lea	($C00000).l,a6
		lea	(unk_FFF756).w,a2
		lea	(unk_FFF708).w,a3
		lea	((Layout+$40)).w,a4
		move.w	#$6000,d2
		bsr.w	sub_4484
		lea	(unk_FFF758).w,a2
		lea	(unk_FFF710).w,a3
		bra.w	sub_4524
; ---------------------------------------------------------------------------

mapLevelLoad:
		lea	($C00004).l,a5
		lea	($C00000).l,a6
		lea	(unk_FFF756).w,a2
		lea	(unk_FFF708).w,a3
		lea	((Layout+$40)).w,a4
		move.w	#$6000,d2
		bsr.w	sub_4484
		lea	(unk_FFF758).w,a2
		lea	(unk_FFF710).w,a3
		bsr.w	sub_4524
		lea	(unk_FFF754).w,a2
		lea	(CameraX).w,a3
		lea	(Layout).w,a4
		move.w	#$4000,d2
		tst.b	(a2)
		beq.s	locret_4482
		bclr	#0,(a2)
		beq.s	loc_4438
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4608

loc_4438:
		bclr	#1,(a2)
		beq.s	loc_4452
		move.w	#$E0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		move.w	#$E0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4608

loc_4452:
		bclr	#2,(a2)
		beq.s	loc_4468
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4634

loc_4468:
		bclr	#3,(a2)
		beq.s	locret_4482
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	sub_4634

locret_4482:
		rts
; ---------------------------------------------------------------------------

sub_4484:
		tst.b	(a2)
		beq.w	locret_4522
		bclr	#0,(a2)
		beq.s	loc_44A2
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		moveq	#$1F,d6
		bsr.w	sub_460A

loc_44A2:
		bclr	#1,(a2)
		beq.s	loc_44BE
		move.w	#$E0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		move.w	#$E0,d4
		moveq	#$FFFFFFF0,d5
		moveq	#$1F,d6
		bsr.w	sub_460A

loc_44BE:
		bclr	#2,(a2)
		beq.s	loc_44EE
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		moveq	#$FFFFFFF0,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	loc_44EE
		lsr.w	#4,d6
		cmpi.w	#$F,d6
		bcs.s	loc_44EA
		moveq	#$F,d6

loc_44EA:
		bsr.w	sub_4636

loc_44EE:
		bclr	#3,(a2)
		beq.s	locret_4522
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		bsr.w	sub_4752
		moveq	#$FFFFFFF0,d4
		move.w	#$140,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	locret_4522
		lsr.w	#4,d6
		cmpi.w	#$F,d6
		bcs.s	loc_451E
		moveq	#$F,d6

loc_451E:
		bsr.w	sub_4636

locret_4522:
		rts
; ---------------------------------------------------------------------------

sub_4524:
		tst.b	(a2)
		beq.w	locret_45B0
		bclr	#2,(a2)
		beq.s	loc_456E
		cmpi.w	#$10,(a3)
		bcs.s	loc_456E
		move.w	(unk_FFF7F0).w,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_4752
		move.w	(sp)+,d4
		moveq	#$FFFFFFF0,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	loc_456E
		lsr.w	#4,d6
		subi.w	#$E,d6
		bcc.s	loc_456E
		neg.w	d6
		bsr.w	sub_4636

loc_456E:
		bclr	#3,(a2)
		beq.s	locret_45B0
		move.w	(unk_FFF7F0).w,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#$140,d5
		bsr.w	sub_4752
		move.w	(sp)+,d4
		move.w	#$140,d5
		move.w	(unk_FFF7F0).w,d6
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d6
		blt.s	locret_45B0
		lsr.w	#4,d6
		subi.w	#$E,d6
		bcc.s	locret_45B0
		neg.w	d6
		bsr.w	sub_4636

locret_45B0:
		rts
; ---------------------------------------------------------------------------
		tst.b	(a2)
		beq.s	locret_4606
		bclr	#2,(a2)
		beq.s	loc_45DC
		move.w	#$D0,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		moveq	#$FFFFFFF0,d5
		bsr.w	sub_476E
		move.w	(sp)+,d4
		moveq	#$FFFFFFF0,d5
		moveq	#2,d6
		bsr.w	sub_4636

loc_45DC:
		bclr	#3,(a2)
		beq.s	locret_4606
		move.w	#$D0,d4
		move.w	4(a3),d1
		andi.w	#$FFF0,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#$140,d5
		bsr.w	sub_476E
		move.w	(sp)+,d4
		move.w	#$140,d5
		moveq	#2,d6
		bsr.w	sub_4636

locret_4606:
		rts
; ---------------------------------------------------------------------------

sub_4608:
		moveq	#$15,d6
; ---------------------------------------------------------------------------

sub_460A:
		move.l	#$800000,d7
		move.l	d0,d1

loc_4612:
		movem.l	d4-d5,-(sp)
		bsr.w	sub_4706
		move.l	d1,d0
		bsr.w	sub_4662
		addq.b	#4,d1
		andi.b	#$7F,d1
		movem.l	(sp)+,d4-d5
		addi.w	#$10,d5
		dbf	d6,loc_4612
		rts
; ---------------------------------------------------------------------------

sub_4634:
		moveq	#$F,d6
; ---------------------------------------------------------------------------

sub_4636:
		move.l	#$800000,d7
		move.l	d0,d1

loc_463E:
		movem.l	d4-d5,-(sp)
		bsr.w	sub_4706
		move.l	d1,d0
		bsr.w	sub_4662
		addi.w	#$100,d1
		andi.w	#$FFF,d1
		movem.l	(sp)+,d4-d5
		addi.w	#$10,d4
		dbf	d6,loc_463E
		rts
; ---------------------------------------------------------------------------

sub_4662:
		or.w	d2,d0
		swap	d0
		btst	#4,(a0)
		bne.s	loc_469E
		btst	#3,(a0)
		bne.s	loc_467E
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.l	(a1)+,(a6)
		rts
; ---------------------------------------------------------------------------

loc_467E:
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)
		rts
; ---------------------------------------------------------------------------

loc_469E:
		btst	#3,(a0)
		bne.s	loc_46C0
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$10001000,d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$10001000,d5
		move.l	d5,(a6)
		rts
; ---------------------------------------------------------------------------

loc_46C0:
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$18001800,d4
		swap	d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$18001800,d5
		swap	d5
		move.l	d5,(a6)
		rts
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------
		move.l	d0,(a5)
		move.w	#$2000,d5
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		rts
; ---------------------------------------------------------------------------

sub_4706:
		lea	(Blocks).w,a1
		add.w	4(a3),d4
		add.w	(a3),d5
		move.w	d4,d3
		lsr.w	#1,d3
		andi.w	#$380,d3
		lsr.w	#3,d5
		move.w	d5,d0
		lsr.w	#5,d0
		andi.w	#$7F,d0
		add.w	d3,d0
		moveq	#-1,d3
		move.b	(a4,d0.w),d3
		andi.b	#$7F,d3
		beq.s	locret_4750
		subq.b	#1,d3
		ext.w	d3
		ror.w	#7,d3
		add.w	d4,d4
		andi.w	#$1E0,d4
		andi.w	#$1E,d5
		add.w	d4,d3
		add.w	d5,d3
		movea.l	d3,a0
		move.w	(a0),d3
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		adda.w	d3,a1

locret_4750:
		rts
; ---------------------------------------------------------------------------

sub_4752:
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0
		swap	d0
		move.w	d4,d0
		rts
; ---------------------------------------------------------------------------

sub_476E:
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#2,d0
		swap	d0
		move.w	d4,d0
		rts
; ---------------------------------------------------------------------------

mapLevelLoadFull:
		lea	($C00004).l,a5
		lea	($C00000).l,a6
		lea	(CameraX).w,a3
		lea	(Layout).w,a4
		move.w	#$4000,d2
		bsr.s	sub_47B0
		lea	(unk_FFF708).w,a3
		lea	((Layout+$40)).w,a4
		move.w	#$6000,d2
; ---------------------------------------------------------------------------

sub_47B0:
		moveq	#$FFFFFFF0,d4
		moveq	#$F,d6

loc_47B4:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	sub_4752
		move.w	d1,d4
		moveq	#0,d5
		moveq	#$1F,d6
		bsr.w	sub_460A
		movem.l	(sp)+,d4-d6
		addi.w	#$10,d4
		dbf	d6,loc_47B4
		rts
; ---------------------------------------------------------------------------
		lea	(unk_FFF718).w,a3
		move.w	#$6000,d2
		move.w	#$B0,d4
		moveq	#2,d6

loc_47E6:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	sub_476E
		move.w	d1,d4
		moveq	#0,d5
		moveq	#$1F,d6
		bsr.w	sub_460A
		movem.l	(sp)+,d4-d6
		addi.w	#$10,d4
		dbf	d6,loc_47E6
		rts
; ---------------------------------------------------------------------------

LoadLevelData:
		moveq	#0,d0
		move.b	(level).w,d0
		lsl.w	#4,d0
		lea	(LevelDataArray).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		addq.l	#4,a2
		movea.l	(a2)+,a0
		lea	(Blocks).w,a4
		move.w	#$5FF,d0

@loadblocks:
		move.l	(a0)+,(a4)+
		dbf	d0,@loadblocks
		movea.l	(a2)+,a0
		lea	((Chunks)&$FFFFFF).l,a1
		bsr.w	KosinskiDec
		bsr.w	LoadLayout
		move.w	(a2)+,d0
		move.w	(a2),d0
		andi.w	#$FF,d0
		bsr.w	palLoadFade
		movea.l	(sp)+,a2
		addq.w	#4,a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	locret_485A
		bsr.w	plcAdd

locret_485A:
		rts
; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.b	(Lives).w,d1
		cmpi.b	#2,d1
		bcs.s	loc_4876
		move.b	d1,d0
		subq.b	#1,d0
		cmpi.b	#5,d0
		bcs.s	loc_4876
		move.b	#4,d0

loc_4876:
		lea	($C00000).l,a6
		move.l	#$6CBE0002,($C00004).l
		move.l	#$8579857A,d2
		bsr.s	sub_489E
		move.l	#$6D3E0002,($C00004).l
		move.l	#$857B857C,d2
; ---------------------------------------------------------------------------

sub_489E:
		moveq	#0,d3
		moveq	#3,d1
		sub.w	d0,d1
		bcs.s	loc_48AC

loc_48A6:
		move.l	d3,(a6)
		dbf	d1,loc_48A6

loc_48AC:
		move.w	d0,d1
		subq.w	#1,d1
		bcs.s	locret_48B8

loc_48B2:
		move.l	d2,(a6)
		dbf	d1,loc_48B2

locret_48B8:
		rts
; ---------------------------------------------------------------------------

LoadLayout:
		lea	(Layout).w,a3
		move.w	#$1FF,d1
		moveq	#0,d0

loc_48C4:
		move.l	d0,(a3)+
		dbf	d1,loc_48C4
		lea	(Layout).w,a3
		moveq	#0,d1
		bsr.w	sub_48DA
		lea	((Layout+$40)).w,a3
		moveq	#2,d1
; ---------------------------------------------------------------------------

sub_48DA:
		move.w	(level).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0
		add.w	d1,d0
		lea	(LayoutArray).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1
		move.b	(a1)+,d2

loc_4900:
		move.w	d1,d0
		movea.l	a3,a0

loc_4904:
		move.b	(a1)+,(a0)+
		dbf	d0,loc_4904
		lea	$80(a3),a3
		dbf	d2,loc_4900
		rts
; ---------------------------------------------------------------------------

LevelEvents:
		moveq	#0,d0
		move.b	(level).w,d0
		add.w	d0,d0
		move.w	off_495E(pc,d0.w),d0
		jsr	off_495E(pc,d0.w)
		tst.w	(DebugRoutine).w
		beq.s	loc_4936
		move.w	#0,(unk_FFF72C).w
		move.w	#$720,(unk_FFF726).w

loc_4936:
		moveq	#2,d1
		move.w	(unk_FFF726).w,d0
		sub.w	(unk_FFF72E).w,d0
		beq.s	locret_495C
		bcc.s	loc_4952
		move.w	(CameraY).w,(unk_FFF72E).w
		andi.w	#$FFFE,(unk_FFF72E).w
		neg.w	d1

loc_4952:
		add.w	d1,(unk_FFF72E).w
		move.b	#1,(unk_FFF75C).w

locret_495C:
		rts
; ---------------------------------------------------------------------------

off_495E:	dc.w EventsGHZ-off_495E, EventsNull-off_495E, EventsMZ-off_495E, EventsSLZ-off_495E
		dc.w EventsNull-off_495E, EventsNull-off_495E
; ---------------------------------------------------------------------------

EventsNull:
		rts
; ---------------------------------------------------------------------------

EventsGHZ:
		moveq	#0,d0
		move.b	(level+1).w,d0
		add.w	d0,d0
		move.w	off_497C(pc,d0.w),d0
		jmp	off_497C(pc,d0.w)
; ---------------------------------------------------------------------------

off_497C:	dc.w EventsGHZ1-off_497C, EventsGHZ2-off_497C, EventsGHZ3-off_497C
; ---------------------------------------------------------------------------

EventsGHZ1:
		move.w	#$300,(unk_FFF726).w
		cmpi.w	#$1780,(CameraX).w
		bcs.s	locret_4996
		move.w	#$400,(unk_FFF726).w

locret_4996:
		rts
; ---------------------------------------------------------------------------

EventsGHZ2:
		move.w	#$300,(unk_FFF726).w
		cmpi.w	#$ED0,(CameraX).w
		bcs.s	locret_49C8
		move.w	#$200,(unk_FFF726).w
		cmpi.w	#$1600,(CameraX).w
		bcs.s	locret_49C8
		move.w	#$400,(unk_FFF726).w
		cmpi.w	#$1D60,(CameraX).w
		bcs.s	locret_49C8
		move.w	#$300,(unk_FFF726).w

locret_49C8:
		rts
; ---------------------------------------------------------------------------

EventsGHZ3:
		moveq	#0,d0
		move.b	(EventsRoutine).w,d0
		move.w	off_49D8(pc,d0.w),d0
		jmp	off_49D8(pc,d0.w)
; ---------------------------------------------------------------------------

off_49D8:	dc.w loc_49DE-off_49D8, loc_4A32-off_49D8, loc_4A78-off_49D8
; ---------------------------------------------------------------------------

loc_49DE:
		move.w	#$300,(unk_FFF726).w
		cmpi.w	#$380,(CameraX).w
		bcs.s	locret_4A24
		move.w	#$310,(unk_FFF726).w
		cmpi.w	#$960,(CameraX).w
		bcs.s	locret_4A24
		cmpi.w	#$280,(CameraY).w
		bcs.s	loc_4A26
		move.w	#$400,(unk_FFF726).w
		cmpi.w	#$1380,(CameraX).w
		bcc.s	loc_4A1C
		move.w	#$4C0,(unk_FFF726).w
		move.w	#$4C0,(unk_FFF72E).w

loc_4A1C:
		cmpi.w	#$1700,(CameraX).w
		bcc.s	loc_4A26

locret_4A24:
		rts
; ---------------------------------------------------------------------------

loc_4A26:
		move.w	#$300,(unk_FFF726).w
		addq.b	#2,(EventsRoutine).w
		rts
; ---------------------------------------------------------------------------

loc_4A32:
		cmpi.w	#$960,(CameraX).w
		bcc.s	loc_4A3E
		subq.b	#2,(EventsRoutine).w

loc_4A3E:
		cmpi.w	#$2960,(CameraX).w
		bcs.s	locret_4A76
		bsr.w	ObjectLoad
		bne.s	loc_4A5E
		move.b	#$3D,0(a1)
		move.w	#$2A60,8(a1)
		move.w	#$280,$C(a1)

loc_4A5E:
		move.w	#$8C,d0
		bsr.w	PlayMusic
		move.b	#1,(unk_FFF7AA).w
		addq.b	#2,(EventsRoutine).w
		moveq	#$11,d0
		bra.w	plcAdd
; ---------------------------------------------------------------------------

locret_4A76:
		rts
; ---------------------------------------------------------------------------

loc_4A78:
		move.w	(CameraX).w,(unk_FFF728).w
		rts
; ---------------------------------------------------------------------------

EventsMZ:
		moveq	#0,d0
		move.b	(level+1).w,d0
		add.w	d0,d0
		move.w	off_4A90(pc,d0.w),d0
		jmp	off_4A90(pc,d0.w)
; ---------------------------------------------------------------------------

off_4A90:	dc.w EventsMZ1-off_4A90, EventsMZ2-off_4A90, EventsMZ3-off_4A90
; ---------------------------------------------------------------------------

EventsMZ1:
		moveq	#0,d0
		move.b	(EventsRoutine).w,d0

loc_4A9C:
		move.w	off_4AA4(pc,d0.w),d0
		jmp	off_4AA4(pc,d0.w)
; ---------------------------------------------------------------------------

off_4AA4:	dc.w loc_4AAC-off_4AA4, sub_4ADC-off_4AA4, loc_4B20-off_4AA4, loc_4B42-off_4AA4
; ---------------------------------------------------------------------------

loc_4AAC:
		move.w	#$1D0,(unk_FFF726).w
		cmpi.w	#$700,(CameraX).w
		bcs.s	locret_4ADA
		move.w	#$220,(unk_FFF726).w
		cmpi.w	#$D00,(CameraX).w
		bcs.s	locret_4ADA
		move.w	#$340,(unk_FFF726).w
		cmpi.w	#$340,(CameraY).w
		bcs.s	locret_4ADA
		addq.b	#2,(EventsRoutine).w

locret_4ADA:
		rts
; ---------------------------------------------------------------------------

sub_4ADC:
		cmpi.w	#$340,(CameraY).w
		bcc.s	loc_4AEA
		subq.b	#2,(EventsRoutine).w
		rts
; ---------------------------------------------------------------------------

loc_4AEA:
		move.w	#0,(unk_FFF72C).w
		cmpi.w	#$E00,(CameraX).w
		bcc.s	locret_4B1E
		move.w	#$340,(unk_FFF72C).w
		move.w	#$340,(unk_FFF726).w
		cmpi.w	#$A90,(CameraX).w
		bcc.s	locret_4B1E
		move.w	#$500,(unk_FFF726).w
		cmpi.w	#$370,(CameraY).w
		bcs.s	locret_4B1E
		addq.b	#2,(EventsRoutine).w

locret_4B1E:
		rts
; ---------------------------------------------------------------------------

loc_4B20:
		cmpi.w	#$370,(CameraY).w
		bcc.s	loc_4B2E
		subq.b	#2,(EventsRoutine).w
		rts
; ---------------------------------------------------------------------------

loc_4B2E:
		cmpi.w	#$500,(CameraY).w
		bcs.s	locret_4B40
		move.w	#$500,(unk_FFF72C).w
		addq.b	#2,(EventsRoutine).w

locret_4B40:
		rts
; ---------------------------------------------------------------------------

loc_4B42:
		cmpi.w	#$E70,(CameraX).w
		bcs.s	locret_4B50
		move.w	#0,(unk_FFF72C).w

locret_4B50:
		rts
; ---------------------------------------------------------------------------

EventsMZ2:
		move.w	#$520,(unk_FFF726).w
		cmpi.w	#$1500,(CameraX).w
		bcs.s	locret_4B66
		move.w	#$540,(unk_FFF726).w

locret_4B66:
		rts
; ---------------------------------------------------------------------------

EventsMZ3:
		rts
; ---------------------------------------------------------------------------

EventsSLZ:
		moveq	#0,d0
		move.b	(level+1).w,d0
		add.w	d0,d0
		move.w	off_4B7A(pc,d0.w),d0
		jmp	off_4B7A(pc,d0.w)
; ---------------------------------------------------------------------------

off_4B7A:	dc.w EventsSLZNull-off_4B7A, EventsSLZNull-off_4B7A, EventsSLZNull-off_4B7A
; ---------------------------------------------------------------------------

EventsSLZNull:
		rts
; ---------------------------------------------------------------------------

Obj02:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_4B90(pc,d0.w),d1
		jmp	off_4B90(pc,d1.w)
; ---------------------------------------------------------------------------

off_4B90:	dc.w loc_4B98-off_4B90, loc_4BC8-off_4B90
		dc.w loc_4BEC-off_4B90, loc_4BEC-off_4B90
; ---------------------------------------------------------------------------

loc_4B98:
		addq.b	#2,obRoutine(a0)
		move.w	#$200,obX(a0)
		move.w	#$60,obY(a0)
		move.l	#Map02,obMap(a0)
		move.w	#$64F0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obColProp(a0)
		move.b	#3,obActWid(a0)

loc_4BC8:
		bsr.w	ObjectDisplay
		subq.b	#1,obTimeFrame(a0)
		bpl.s	locret_4BEA
		move.b	#$10,obTimeFrame(a0)
		move.b	obFrame(a0),d0
		addq.b	#1,d0
		cmpi.b	#2,d0
		bcs.s	loc_4BE6
		moveq	#0,d0

loc_4BE6:
		move.b	d0,obFrame(a0)

locret_4BEA:
		rts
; ---------------------------------------------------------------------------

loc_4BEC:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
		include "unknown/Map02.map"
		even
; ---------------------------------------------------------------------------

Obj03:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_4C68(pc,d0.w),d1
		jmp	off_4C68(pc,d1.w)
; ---------------------------------------------------------------------------

off_4C68:	dc.w loc_4C70-off_4C68, loc_4CA6-off_4C68, loc_4CB8-off_4C68, loc_4CB8-off_4C68
; ---------------------------------------------------------------------------

loc_4C70:
		addq.b	#2,obRoutine(a0)
		move.w	#$100,obX(a0)
		move.w	#$40,obY(a0)
		move.l	#Map02,obMap(a0)
		move.w	#$64F0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obColProp(a0)
		move.b	#3,obFrame(a0)
		move.b	#5,obActWid(a0)

loc_4CA6:
		bsr.w	ObjectDisplay
		subq.b	#1,obTimeFrame(a0)
		bpl.s	locret_4CB6
		move.b	#$10,obTimeFrame(a0)

locret_4CB6:
		rts
; ---------------------------------------------------------------------------

loc_4CB8:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

Obj04:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_4CCC(pc,d0.w),d1
		jmp	off_4CCC(pc,d1.w)
; ---------------------------------------------------------------------------

off_4CCC:	dc.w loc_4CD4-off_4CCC, loc_4D04-off_4CCC, loc_4D28-off_4CCC, loc_4D28-off_4CCC
; ---------------------------------------------------------------------------

loc_4CD4:
		addq.b	#2,$24(a0)
		move.w	#$40,$C(a0)
		move.l	#Map02,4(a0)
		move.w	#$2680,2(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obColProp(a0)
		move.b	#2,obFrame(a0)
		move.b	#3,obActWid(a0)

loc_4D04:
		bsr.w	ObjectDisplay
		subq.b	#1,obTimeFrame(a0)
		bpl.s	locret_4D26
		move.b	#$14,obTimeFrame(a0)
		move.b	obFrame(a0),d0
		addq.b	#1,d0
		cmpi.b	#4,d0
		bcs.s	loc_4D22
		moveq	#2,d0

loc_4D22:
		move.b	d0,obFrame(a0)

locret_4D26:
		rts
; ---------------------------------------------------------------------------

loc_4D28:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

Obj05:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_4D3C(pc,d0.w),d1
		jmp	off_4D3C(pc,d1.w)
; ---------------------------------------------------------------------------

off_4D3C:	dc.w loc_4D44-off_4D3C, loc_4D62-off_4D3C, loc_4D68-off_4D3C, loc_4D68-off_4D3C
; ---------------------------------------------------------------------------

loc_4D44:
		addq.b	#2,obRoutine(a0)
		move.l	#Map05,obMap(a0)
		move.w	#$84F0,obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#7,obActWid(a0)

loc_4D62:
		bsr.w	ObjectDisplay
		rts
; ---------------------------------------------------------------------------

loc_4D68:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
		include "unknown/Map05.map"
		even
; ---------------------------------------------------------------------------

Ojb06:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_4DFC(pc,d0.w),d1
		jmp	off_4DFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_4DFC:	dc.w loc_4E04-off_4DFC, loc_4E28-off_4DFC, loc_4E2E-off_4DFC, loc_4E2E-off_4DFC
; ---------------------------------------------------------------------------

loc_4E04:
		addq.b	#2,obRoutine(a0)
		move.w	#$A0,obScreenY(a0)
		move.l	#Map05,obMap(a0)
		move.w	#$8470,obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#7,obActWid(a0)

loc_4E28:
		bsr.w	ObjectDisplay
		rts
; ---------------------------------------------------------------------------

loc_4E2E:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

Obj07:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_4E42(pc,d0.w),d1
		jmp	off_4E42(pc,d1.w)
; ---------------------------------------------------------------------------

off_4E42:	dc.w loc_4E4A-off_4E42, locret_4E4E-off_4E42, loc_4E50-off_4E42, loc_4E50-off_4E42
; ---------------------------------------------------------------------------

loc_4E4A:
		addq.b	#2,obRoutine(a0)

locret_4E4E:
		rts
; ---------------------------------------------------------------------------

loc_4E50:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjBridge:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_4E64(pc,d0.w),d1
		jmp	off_4E64(pc,d1.w)
; ---------------------------------------------------------------------------

off_4E64:	dc.w ObjBridge_Init-off_4E64, loc_4F32-off_4E64, loc_50B2-off_4E64, ObjBridge_Delete-off_4E64, ObjBridge_Delete-off_4E64
		dc.w ObjBridge_Display-off_4E64
; ---------------------------------------------------------------------------

ObjBridge_Init:
		addq.b	#2,obRoutine(a0)
		move.l	#MapBridge,obMap(a0)
		move.w	#$438E,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obActWid(a0)
		move.b	#$80,obPriority(a0)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		move.b	obID(a0),d4
		lea	obSubtype(a0),a2
		moveq	#0,d1
		move.b	(a2),d1
		move.b	#0,(a2)+
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3
		subq.b	#2,d1
		bcs.s	loc_4F32

ObjBridge_MakeLog:
		bsr.w	ObjectLoad
		bne.s	loc_4F32
		addq.b	#1,obSubtype(a0)
		cmp.w	8(a0),d3
		bne.s	loc_4EE6
		addi.w	#$10,d3
		move.w	d2,obY(a0)
		move.w	d2,$3C(a0)
		move.w	a0,d5
		subi.w	#ObjectsList,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		addq.b	#1,obSubtype(a0)

loc_4EE6:
		move.w	a1,d5
		subi.w	#ObjectsList,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,$24(a1)
		move.b	d4,0(a1)
		move.w	d2,$C(a1)
		move.w	d2,$3C(a1)
		move.w	d3,8(a1)
		move.l	#MapBridge,4(a1)
		move.w	#$438E,2(a1)
		move.b	#4,1(a1)
		move.b	#3,$19(a1)
		move.b	#8,$18(a1)
		addi.w	#$10,d3
		dbf	d1,ObjBridge_MakeLog

loc_4F32:
		bsr.s	PtfmBridge
		tst.b	$3E(a0)
		beq.s	loc_4F42
		subq.b	#4,$3E(a0)
		bsr.w	ObjBridge_UpdateBend

loc_4F42:
		bsr.w	ObjectDisplay
		bra.w	ObjBridge_ChkDelete
; ---------------------------------------------------------------------------

PtfmBridge:
		moveq	#0,d1
		move.b	$28(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		add.w	d2,d2
		lea	(ObjectsList).w,a1
		tst.w	$12(a1)
		bmi.w	locret_5048
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		cmp.w	d2,d0
		bcc.w	locret_5048
		bra.s	PtfmNormal2
; ---------------------------------------------------------------------------

PtfmNormal:
		lea	(ObjectsList).w,a1
		tst.w	$12(a1)
		bmi.w	locret_5048
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.w	locret_5048

PtfmNormal2:
		move.w	$C(a0),d0
		subq.w	#8,d0

PtfmNormal3:
		move.w	$C(a1),d2
		move.b	$16(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.w	locret_5048
		cmpi.w	#$FFF0,d0
		bcs.w	locret_5048
		cmpi.b	#6,$24(a1)
		bcc.w	locret_5048
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,$C(a1)
		addq.b	#2,$24(a0)

loc_4FD4:
		btst	#3,$22(a1)
		beq.s	loc_4FFC
		moveq	#0,d0
		move.b	$3D(a1),d0
		lsl.w	#6,d0
		addi.l	#(ObjectsList)&$FFFFFF,d0
		movea.l	d0,a2
		cmpi.b	#4,$24(a2)
		bne.s	loc_4FFC
		subq.b	#2,$24(a2)
		clr.b	$25(a2)

loc_4FFC:
		move.w	a0,d0
		subi.w	#ObjectsList,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0
		move.b	d0,$3D(a1)
		move.b	#0,$26(a1)
		move.w	#0,$12(a1)
		move.w	$10(a1),d0
		asr.w	#2,d0
		sub.w	d0,$10(a1)
		move.w	$10(a1),$14(a1)
		btst	#1,$22(a1)
		beq.s	loc_503C
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	sub_F218
		movea.l	(sp)+,a0

loc_503C:
		bset	#3,$22(a1)
		bset	#3,$22(a0)

locret_5048:
		rts
; ---------------------------------------------------------------------------

PtfmSloped:
		lea	(ObjectsList).w,a1
		tst.w	$12(a1)
		bmi.w	locret_5048
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.s	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	locret_5048
		btst	#0,1(a0)
		beq.s	loc_5074
		not.w	d0
		add.w	d1,d0

loc_5074:
		lsr.w	#1,d0
		moveq	#0,d3
		move.b	(a2,d0.w),d3
		move.w	$C(a0),d0
		sub.w	d3,d0
		bra.w	PtfmNormal3
; ---------------------------------------------------------------------------

PtfmNormalHeight:
		lea	(ObjectsList).w,a1
		tst.w	$12(a1)
		bmi.w	locret_5048
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.w	locret_5048
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.w	locret_5048
		move.w	$C(a0),d0
		sub.w	d3,d0
		bra.w	PtfmNormal3
; ---------------------------------------------------------------------------

loc_50B2:
		bsr.s	ObjBridge_ChkExit
		bsr.w	ObjectDisplay
		bra.w	ObjBridge_ChkDelete
; ---------------------------------------------------------------------------

ObjBridge_ChkExit:
		moveq	#0,d1
		move.b	$28(a0),d1
		lsl.w	#3,d1
		move.w	d1,d2
		addq.w	#8,d1
		bsr.s	PtfmCheckExit2
		bcc.s	locret_50E8
		lsr.w	#4,d0
		move.b	d0,$3F(a0)
		move.b	$3E(a0),d0
		cmpi.b	#$40,d0
		beq.s	loc_50E0
		addq.b	#4,$3E(a0)

loc_50E0:
		bsr.w	ObjBridge_UpdateBend
		bsr.w	ObjBridge_PlayerPos

locret_50E8:
		rts
; ---------------------------------------------------------------------------

PtfmCheckExit:
		move.w	d1,d2
; ---------------------------------------------------------------------------

PtfmCheckExit2:
		add.w	d2,d2
		lea	(ObjectsList).w,a1
		btst	#1,$22(a1)
		bne.s	loc_510A
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.s	loc_510A
		cmp.w	d2,d0
		bcs.s	locret_511C

loc_510A:
		bclr	#3,$22(a1)
		move.b	#2,$24(a0)
		bclr	#3,$22(a0)

locret_511C:
		rts
; ---------------------------------------------------------------------------

ObjBridge_PlayerPos:
		moveq	#0,d0
		move.b	$3F(a0),d0
		move.b	$29(a0,d0.w),d0
		lsl.w	#6,d0
		addi.l	#(ObjectsList)&$FFFFFF,d0
		movea.l	d0,a2
		lea	(ObjectsList).w,a1
		move.w	$C(a2),d0
		subq.w	#8,d0
		moveq	#0,d1
		move.b	$16(a1),d1
		sub.w	d1,d0
		move.w	d0,$C(a1)
		rts
; ---------------------------------------------------------------------------

ObjBridge_UpdateBend:
		move.b	$3E(a0),d0
		bsr.w	GetSine
		move.w	d0,d4
		lea	(byte_5306).l,a4
		moveq	#0,d0
		move.b	$28(a0),d0
		lsl.w	#4,d0
		moveq	#0,d3
		move.b	$3F(a0),d3
		move.w	d3,d2
		add.w	d0,d3
		moveq	#0,d5
		lea	(byte_51F6).l,a5
		move.b	(a5,d3.w),d5
		andi.w	#$F,d3
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		lea	$29(a0),a2

loc_5186:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#(ObjectsList)&$FFFFFF,d0
		movea.l	d0,a1
		moveq	#0,d0
		move.b	(a3)+,d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	$3C(a1),d0
		move.w	d0,$C(a1)
		dbf	d2,loc_5186
		moveq	#0,d0
		move.b	$28(a0),d0
		moveq	#0,d3
		move.b	$3F(a0),d3
		addq.b	#1,d3
		sub.b	d0,d3
		neg.b	d3
		bmi.s	locret_51F4
		move.w	d3,d2
		lsl.w	#4,d3
		lea	(a4,d3.w),a3
		adda.w	d2,a3
		subq.w	#1,d2
		bcs.s	locret_51F4

loc_51CE:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#(ObjectsList)&$FFFFFF,d0
		movea.l	d0,a1
		moveq	#0,d0
		move.b	-(a3),d0
		addq.w	#1,d0
		mulu.w	d5,d0
		mulu.w	d4,d0
		swap	d0
		add.w	$3C(a1),d0
		move.w	d0,$C(a1)
		dbf	d2,loc_51CE

locret_51F4:
		rts
; ---------------------------------------------------------------------------

byte_51F6:	dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 6, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, 6, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, 8, 6, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, $A, 8, 6, 4, 2
		dc.b 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, $A, $A, 8, 6, 4
		dc.b 2, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, $A, $C, $A, 8, 6
		dc.b 4, 2, 0, 0, 0, 0, 0, 2, 4, 6, 8, $A, $C, $C, $A, 8
		dc.b 6, 4, 2, 0, 0, 0, 0, 2, 4, 6, 8, $A, $C, $E, $C, $A
		dc.b 8, 6, 4, 2, 0, 0, 0, 2, 4, 6, 8, $A, $C, $E, $E, $C
		dc.b $A, 8, 6, 4, 2, 0, 0, 2, 4, 6, 8, $A, $C, $E, $10
		dc.b $E, $C, $A, 8, 6, 4, 2, 0, 2, 4, 6, 8, $A, $C, $E
		dc.b $10, $10, $E, $C, $A, 8, 6, 4, 2

byte_5306:	dc.b $FF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b $B5, $FF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b $7E, $DB, $FF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, $61, $B5, $EC, $FF, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, $4A, $93, $CD, $F3, $FF, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, $3E, $7E, $B0, $DB, $F6, $FF, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, $38, $6D, $9D, $C5, $E4, $F8
		dc.b $FF, 0, 0, 0, 0, 0, 0, 0, 0, 0, $31, $61, $8E, $B5
		dc.b $D4, $EC, $FB, $FF, 0, 0, 0, 0, 0, 0, 0, 0, $2B, $56
		dc.b $7E, $A2, $C1, $DB, $EE, $FB, $FF, 0, 0, 0, 0, 0
		dc.b 0, 0, $25, $4A, $73, $93, $B0, $CD, $E1, $F3, $FC
		dc.b $FF, 0, 0, 0, 0, 0, 0, $1F, $44, $67, $88, $A7, $BD
		dc.b $D4, $E7, $F4, $FD, $FF, 0, 0, 0, 0, 0, $1F, $3E
		dc.b $5C, $7E, $98, $B0, $C9, $DB, $EA, $F6, $FD, $FF
		dc.b 0, 0, 0, 0, $19, $38, $56, $73, $8E, $A7, $BD, $D1
		dc.b $E1, $EE, $F8, $FE, $FF, 0, 0, 0, $19, $38, $50, $6D
		dc.b $83, $9D, $B0, $C5, $D8, $E4, $F1, $F8, $FE, $FF
		dc.b 0, 0, $19, $31, $4A, $67, $7E, $93, $A7, $BD, $CD
		dc.b $DB, $E7, $F3, $F9, $FE, $FF, 0, $19, $31, $4A, $61
		dc.b $78, $8E, $A2, $B5, $C5, $D4, $E1, $EC, $F4, $FB
		dc.b $FE, $FF
; ---------------------------------------------------------------------------

ObjBridge_ChkDelete:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjBridge_DeleteAll
		rts
; ---------------------------------------------------------------------------

ObjBridge_DeleteAll:
		moveq	#0,d2
		lea	$28(a0),a2
		move.b	(a2)+,d2
		subq.b	#1,d2
		bcs.s	ObjBridge_GoDelete

loc_5432:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#(ObjectsList)&$FFFFFF,d0
		movea.l	d0,a1
		cmp.w	a0,d0
		beq.s	loc_5448
		bsr.w	ObjectDeleteA1

loc_5448:
		dbf	d2,loc_5432

ObjBridge_GoDelete:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjBridge_Delete:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjBridge_Display:
		bsr.w	ObjectDisplay
		rts
; ---------------------------------------------------------------------------
		include "levels/GHZ/Bridge/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSwingPtfm:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_548A(pc,d0.w),d1
		jmp	off_548A(pc,d1.w)
; ---------------------------------------------------------------------------

off_548A:	dc.w ObjSwingPtfm_Init-off_548A, loc_55C8-off_548A, loc_55E4-off_548A, ObjSwingPtfm_Delete-off_548A
		dc.w ObjSwingPtfm_Delete-off_548A, j_ObjectDisplay-off_548A
; ---------------------------------------------------------------------------

ObjSwingPtfm_Init:
		addq.b	#2,$24(a0)
		move.l	#MapSwingPtfm,4(a0)
		move.w	#$4380,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$18,$18(a0)
		move.b	#8,$16(a0)
		move.w	$C(a0),$38(a0)
		move.w	8(a0),$3A(a0)
		cmpi.b	#3,(level).w
		bne.s	ObjSwingPtfm_NotSYZ
		move.l	#MapSwingPtfmSYZ,4(a0)
		move.w	#$43DC,2(a0)
		move.b	#$20,$18(a0)
		move.b	#$10,$16(a0)
		move.b	#$99,$20(a0)

ObjSwingPtfm_NotSYZ:
		move.b	0(a0),d4
		moveq	#0,d1
		lea	$28(a0),a2
		move.b	(a2),d1
		move.w	d1,-(sp)
		andi.w	#$F,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		addq.b	#8,d3
		move.b	d3,$3C(a0)
		subq.b	#8,d3
		tst.b	$1A(a0)
		beq.s	ObjSwingPtfm_LoadLinks
		addq.b	#8,d3
		subq.w	#1,d1

ObjSwingPtfm_LoadLinks:
		bsr.w	ObjectLoad
		bne.s	loc_5586
		addq.b	#1,$28(a0)
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#$A,$24(a1)
		move.b	d4,0(a1)
		move.l	4(a0),4(a1)
		move.w	2(a0),2(a1)
		bclr	#6,2(a1)
		move.b	#4,1(a1)
		move.b	#4,$19(a1)
		move.b	#8,$18(a1)
		move.b	#1,$1A(a1)
		move.b	d3,$3C(a1)
		subi.b	#$10,d3
		bcc.s	loc_5582
		move.b	#2,$1A(a1)
		bset	#6,2(a1)

loc_5582:
		dbf	d1,ObjSwingPtfm_LoadLinks

loc_5586:
		move.w	a0,d5
		subi.w	#ObjectsList,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.w	#$4080,$26(a0)
		move.w	#$FE00,$3E(a0)
		move.w	(sp)+,d1
		btst	#4,d1
		beq.s	loc_55C8
		move.l	#MapRollingBall,4(a0)
		move.w	#$43AA,2(a0)
		move.b	#1,$1A(a0)
		move.b	#2,$19(a0)
		move.b	#$81,$20(a0)

loc_55C8:
		moveq	#0,d1
		move.b	$18(a0),d1
		moveq	#0,d3
		move.b	$16(a0),d3
		bsr.w	PtfmNormalHeight
		bsr.w	sub_563C
		bsr.w	ObjectDisplay
		bra.w	ObjSwingPtfm_ChkDelete
; ---------------------------------------------------------------------------

loc_55E4:
		moveq	#0,d1
		move.b	$18(a0),d1
		bsr.w	PtfmCheckExit
		move.w	8(a0),-(sp)
		bsr.w	sub_563C
		move.w	(sp)+,d2
		moveq	#0,d3
		move.b	$16(a0),d3
		addq.b	#1,d3
		bsr.w	PtfmSurfaceHeight
		bsr.w	ObjectDisplay
		bra.w	ObjSwingPtfm_ChkDelete
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

PtfmSurfaceHeight:
		lea	(ObjectsList).w,a1
		move.w	$C(a0),d0
		sub.w	d3,d0
		bra.s	loc_5626
; ---------------------------------------------------------------------------

ptfmSurfaceNormal:
		lea	(ObjectsList).w,a1
		move.w	$C(a0),d0
		subi.w	#9,d0

loc_5626:
		moveq	#0,d1
		move.b	$16(a1),d1
		sub.w	d1,d0
		move.w	d0,$C(a1)
		sub.w	8(a0),d2
		sub.w	d2,8(a1)
		rts
; ---------------------------------------------------------------------------

sub_563C:
		move.b	(oscValues+$1A).w,d0
		move.w	#$80,d1
		btst	#0,$22(a0)
		beq.s	loc_5650
		neg.w	d0
		add.w	d1,d0

loc_5650:
		bra.s	loc_5692
; ---------------------------------------------------------------------------

loc_5652:
		tst.b	$3D(a0)
		bne.s	loc_5674
		move.w	$3E(a0),d0
		addq.w	#8,d0
		move.w	d0,$3E(a0)
		add.w	d0,$26(a0)
		cmpi.w	#$200,d0
		bne.s	loc_568E
		move.b	#1,$3D(a0)
		bra.s	loc_568E
; ---------------------------------------------------------------------------

loc_5674:
		move.w	$3E(a0),d0
		subq.w	#8,d0
		move.w	d0,$3E(a0)
		add.w	d0,$26(a0)
		cmpi.w	#$FE00,d0
		bne.s	loc_568E
		move.b	#0,$3D(a0)

loc_568E:
		move.b	$26(a0),d0

loc_5692:
		bsr.w	GetSine
		move.w	$38(a0),d2
		move.w	$3A(a0),d3
		lea	$28(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_56A6:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#(ObjectsList)&$FFFFFF,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	$3C(a1),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,$C(a1)
		move.w	d5,8(a1)
		dbf	d6,loc_56A6
		rts
; ---------------------------------------------------------------------------

ObjSwingPtfm_ChkDelete:
		move.w	$3A(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjSwingPtfm_DeleteAll
		rts
; ---------------------------------------------------------------------------

ObjSwingPtfm_DeleteAll:
		moveq	#0,d2
		lea	$28(a0),a2
		move.b	(a2)+,d2

loc_56FE:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#(ObjectsList)&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,loc_56FE
		rts
; ---------------------------------------------------------------------------

ObjSwingPtfm_Delete:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
; Attributes: thunk

j_ObjectDisplay:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------
		include "levels/shared/SwingPtfm/Main.map"
		even
		include "levels/shared/SwingPtfm/SYZ.map"
		even
; ---------------------------------------------------------------------------

ObjSpikeLogs:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_5788(pc,d0.w),d1
		jmp	off_5788(pc,d1.w)
; ---------------------------------------------------------------------------

off_5788:	dc.w loc_5792-off_5788, loc_5854-off_5788, loc_5854-off_5788, loc_58C2-off_5788, loc_58C8-off_5788
; ---------------------------------------------------------------------------

loc_5792:
		addq.b	#2,$24(a0)
		move.l	#MapSpikeLogs,4(a0)
		move.w	#$4398,2(a0)
		move.b	#7,$22(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#8,$18(a0)
		move.w	$C(a0),d2
		move.w	8(a0),d3
		move.b	0(a0),d4
		lea	$28(a0),a2
		moveq	#0,d1
		move.b	(a2),d1
		move.b	#0,(a2)+
		move.w	d1,d0
		lsr.w	#1,d0
		lsl.w	#4,d0
		sub.w	d0,d3
		subq.b	#2,d1
		bcs.s	loc_5854
		moveq	#0,d6

loc_57E2:
		bsr.w	ObjectLoad
		bne.s	loc_5854
		addq.b	#1,$28(a0)
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+

loc_57FA:
		move.b	#8,$24(a1)
		move.b	d4,0(a1)
		move.w	d2,$C(a1)
		move.w	d3,8(a1)
		move.l	4(a0),4(a1)
		move.w	#$4398,2(a1)
		move.b	#4,1(a1)
		move.b	#3,$19(a1)
		move.b	#8,$18(a1)
		move.b	d6,$3E(a1)
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3
		cmp.w	8(a0),d3
		bne.s	loc_5850
		move.b	d6,$3E(a0)
		addq.b	#1,d6
		andi.b	#7,d6
		addi.w	#$10,d3
		addq.b	#1,$28(a0)

loc_5850:
		dbf	d1,loc_57E2

loc_5854:
		bsr.w	sub_5860
		bsr.w	ObjectDisplay
		bra.w	loc_5880
; ---------------------------------------------------------------------------

sub_5860:
		move.b	(unk_FFFEC1).w,d0
		move.b	#0,$20(a0)
		add.b	$3E(a0),d0
		andi.b	#7,d0
		move.b	d0,$1A(a0)
		bne.s	locret_587E
		move.b	#$84,$20(a0)

locret_587E:
		rts
; ---------------------------------------------------------------------------

loc_5880:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	loc_58A0
		rts
; ---------------------------------------------------------------------------

loc_58A0:
		moveq	#0,d2
		lea	$28(a0),a2
		move.b	(a2)+,d2
		subq.b	#2,d2
		bcs.s	loc_58C2

loc_58AC:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#(ObjectsList)&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,loc_58AC

loc_58C2:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

loc_58C8:
		bsr.w	sub_5860
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------
		include "levels/GHZ/SpikeLogs/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjPlatform:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_5918(pc,d0.w),d1
		jmp	off_5918(pc,d1.w)
; ---------------------------------------------------------------------------

off_5918:	dc.w loc_5922-off_5918, loc_59AE-off_5918, loc_59D2-off_5918, loc_5BCE-off_5918, loc_59C2-off_5918
; ---------------------------------------------------------------------------

loc_5922:
		addq.b	#2,$24(a0)
		move.w	#$4000,2(a0)
		move.l	#MapPlatform1,4(a0)
		move.b	#$20,$18(a0)
		cmpi.b	#4,(level).w
		bne.s	loc_5950
		move.l	#MapPlatform2,4(a0)
		move.b	#$20,$18(a0)

loc_5950:
		cmpi.b	#3,(level).w
		bne.s	loc_5972
		move.l	#MapPlatform3,4(a0)
		move.b	#$20,$18(a0)
		move.w	#$4480,2(a0)
		move.b	#3,$28(a0)

loc_5972:
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.w	$C(a0),$2C(a0)
		move.w	$C(a0),$34(a0)
		move.w	8(a0),$32(a0)
		move.w	#$80,$26(a0)
		moveq	#0,d1
		move.b	$28(a0),d0
		cmpi.b	#$A,d0
		bne.s	loc_59AA
		addq.b	#1,d1
		move.b	#$20,$18(a0)

loc_59AA:
		move.b	d1,$1A(a0)

loc_59AE:
		tst.b	$38(a0)
		beq.s	loc_59B8
		subq.b	#4,$38(a0)

loc_59B8:
		moveq	#0,d1
		move.b	$18(a0),d1
		bsr.w	PtfmNormal

loc_59C2:
		bsr.w	sub_5A1E
		bsr.w	sub_5A04
		bsr.w	ObjectDisplay
		bra.w	loc_5BB0
; ---------------------------------------------------------------------------

loc_59D2:
		cmpi.b	#$40,$38(a0)
		beq.s	loc_59DE
		addq.b	#4,$38(a0)

loc_59DE:
		moveq	#0,d1
		move.b	$18(a0),d1
		bsr.w	PtfmCheckExit
		move.w	8(a0),-(sp)
		bsr.w	sub_5A1E
		bsr.w	sub_5A04
		move.w	(sp)+,d2
		bsr.w	ptfmSurfaceNormal
		bsr.w	ObjectDisplay
		bra.w	loc_5BB0
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

sub_5A04:
		move.b	$38(a0),d0
		bsr.w	GetSine
		move.w	#$400,d1
		muls.w	d1,d0
		swap	d0
		add.w	$2C(a0),d0
		move.w	d0,$C(a0)
		rts
; ---------------------------------------------------------------------------

sub_5A1E:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_5A32(pc,d0.w),d1
		jmp	off_5A32(pc,d1.w)
; ---------------------------------------------------------------------------

off_5A32:	dc.w locret_5A4C-off_5A32, loc_5A5E-off_5A32, loc_5AA4-off_5A32, loc_5ABC-off_5A32, loc_5AE4-off_5A32
		dc.w loc_5A4E-off_5A32, loc_5A94-off_5A32, loc_5B4E-off_5A32, loc_5B7A-off_5A32, locret_5A4C-off_5A32
		dc.w loc_5B92-off_5A32, loc_5A86-off_5A32, loc_5A76-off_5A32
; ---------------------------------------------------------------------------

locret_5A4C:
		rts
; ---------------------------------------------------------------------------

loc_5A4E:
		move.w	$32(a0),d0
		move.b	$26(a0),d1
		neg.b	d1
		addi.b	#$40,d1
		bra.s	loc_5A6A
; ---------------------------------------------------------------------------

loc_5A5E:
		move.w	$32(a0),d0
		move.b	$26(a0),d1
		subi.b	#$40,d1

loc_5A6A:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,8(a0)
		bra.w	loc_5BA8
; ---------------------------------------------------------------------------

loc_5A76:
		move.w	$34(a0),d0
		move.b	(oscValues+$E).w,d1
		neg.b	d1
		addi.b	#$30,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5A86:
		move.w	$34(a0),d0
		move.b	(oscValues+$E).w,d1
		subi.b	#$30,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5A94:
		move.w	$34(a0),d0
		move.b	$26(a0),d1
		neg.b	d1
		addi.b	#$40,d1
		bra.s	loc_5AB0
; ---------------------------------------------------------------------------

loc_5AA4:
		move.w	$34(a0),d0
		move.b	$26(a0),d1
		subi.b	#$40,d1

loc_5AB0:
		ext.w	d1
		add.w	d1,d0
		move.w	d0,$2C(a0)
		bra.w	loc_5BA8
; ---------------------------------------------------------------------------

loc_5ABC:
		tst.w	$3A(a0)
		bne.s	loc_5AD2
		btst	#3,$22(a0)
		beq.s	locret_5AD0
		move.w	#$1E,$3A(a0)

locret_5AD0:
		rts
; ---------------------------------------------------------------------------

loc_5AD2:
		subq.w	#1,$3A(a0)
		bne.s	locret_5AD0
		move.w	#$20,$3A(a0)
		addq.b	#1,$28(a0)
		rts
; ---------------------------------------------------------------------------

loc_5AE4:
		tst.w	$3A(a0)
		beq.s	loc_5B20
		subq.w	#1,$3A(a0)
		bne.s	loc_5B20
		btst	#3,$22(a0)
		beq.s	loc_5B1A
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#2,$24(a1)
		bclr	#3,$22(a0)
		clr.b	$25(a0)
		move.w	$12(a0),$12(a1)

loc_5B1A:
		move.b	#8,$24(a0)

loc_5B20:
		move.l	$2C(a0),d3
		move.w	$12(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d3,$2C(a0)
		addi.w	#$38,$12(a0)
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$2C(a0),d0
		bcc.s	locret_5B4C
		move.b	#6,$24(a0)

locret_5B4C:
		rts
; ---------------------------------------------------------------------------

loc_5B4E:
		tst.w	$3A(a0)
		bne.s	loc_5B6E
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#4,d0
		tst.b	(a2,d0.w)
		beq.s	locret_5B6C
		move.w	#$3C,$3A(a0)

locret_5B6C:
		rts
; ---------------------------------------------------------------------------

loc_5B6E:
		subq.w	#1,$3A(a0)
		bne.s	locret_5B6C
		addq.b	#1,$28(a0)
		rts
; ---------------------------------------------------------------------------

loc_5B7A:
		subq.w	#2,$2C(a0)
		move.w	$34(a0),d0
		subi.w	#$200,d0
		cmp.w	$2C(a0),d0
		bne.s	locret_5B90
		clr.b	$28(a0)

locret_5B90:
		rts
; ---------------------------------------------------------------------------

loc_5B92:
		move.w	$34(a0),d0
		move.b	$26(a0),d1
		subi.b	#$40,d1
		ext.w	d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	d0,$2C(a0)

loc_5BA8:
		move.b	(oscValues+$1A).w,$26(a0)
		rts
; ---------------------------------------------------------------------------

loc_5BB0:
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.s	loc_5BCE
		rts
; ---------------------------------------------------------------------------

loc_5BCE:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------
		include "unknown/05BD2.map"
		include "levels/shared/Platform/1.map"
		include "levels/shared/Platform/2.map"
		include "levels/shared/Platform/3.map"
		even
; ---------------------------------------------------------------------------

ObjRollingBall:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_5C8E(pc,d0.w),d1
		jmp	off_5C8E(pc,d1.w)
; ---------------------------------------------------------------------------

off_5C8E:	dc.w loc_5C98-off_5C8E, loc_5D2C-off_5C8E, loc_5D86-off_5C8E, loc_5E4A-off_5C8E, loc_5CEE-off_5C8E
; ---------------------------------------------------------------------------

loc_5C98:
		move.b	#$18,$16(a0)
		move.b	#$C,$17(a0)
		bsr.w	ObjectFall
		jsr	sub_105F0
		tst.w	d1
		bpl.s	locret_5CEC
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		move.b	#8,$24(a0)
		move.l	#MapRollingBall,4(a0)
		move.w	#$43AA,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$18,$18(a0)
		move.b	#1,$1F(a0)
		bsr.w	sub_5DC8

locret_5CEC:
		rts
; ---------------------------------------------------------------------------

loc_5CEE:
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		btst	#5,$22(a0)
		bne.s	loc_5D14
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bcs.s	loc_5D20

loc_5D14:
		move.b	#2,$24(a0)
		move.w	#$80,$14(a0)

loc_5D20:
		bsr.w	sub_5DC8
		bsr.w	ObjectDisplay
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

loc_5D2C:
		btst	#1,$22(a0)
		bne.w	loc_5D86
		bsr.w	sub_5DC8
		bsr.w	sub_5E50
		bsr.w	ObjectMove
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		jsr	sub_FE12
		cmpi.w	#$20,8(a0)
		bcc.s	loc_5D70
		move.w	#$20,8(a0)
		move.w	#$400,$14(a0)

loc_5D70:
		btst	#1,$22(a0)
		beq.s	loc_5D7E
		move.w	#$FC00,$12(a0)

loc_5D7E:
		bsr.w	ObjectDisplay
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

loc_5D86:
		bsr.w	sub_5DC8
		bsr.w	ObjectMove
		move.w	#$23,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		jsr	sub_F04E
		btst	#1,$22(a0)
		beq.s	loc_5DBE
		move.w	$12(a0),d0
		addi.w	#$28,d0
		move.w	d0,$12(a0)
		bra.s	loc_5DC0
; ---------------------------------------------------------------------------

loc_5DBE:
		nop

loc_5DC0:
		bsr.w	ObjectDisplay
		bra.w	loc_5E2A
; ---------------------------------------------------------------------------

sub_5DC8:
		tst.b	$1A(a0)
		beq.s	loc_5DD6
		move.b	#0,$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_5DD6:
		move.b	$14(a0),d0
		beq.s	loc_5E02
		bmi.s	loc_5E0A
		subq.b	#1,$1E(a0)
		bpl.s	loc_5E02
		neg.b	d0
		addq.b	#8,d0
		bcs.s	loc_5DEC
		moveq	#0,d0

loc_5DEC:
		move.b	d0,$1E(a0)
		move.b	$1F(a0),d0
		addq.b	#1,d0
		cmpi.b	#4,d0
		bne.s	loc_5DFE
		moveq	#1,d0

loc_5DFE:
		move.b	d0,$1F(a0)

loc_5E02:
		move.b	$1F(a0),$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_5E0A:
		subq.b	#1,$1E(a0)
		bpl.s	loc_5E02
		addq.b	#8,d0
		bcs.s	loc_5E16
		moveq	#0,d0

loc_5E16:
		move.b	d0,$1E(a0)
		move.b	$1F(a0),d0
		subq.b	#1,d0
		bne.s	loc_5E24
		moveq	#3,d0

loc_5E24:
		move.b	d0,$1F(a0)
		bra.s	loc_5E02
; ---------------------------------------------------------------------------

loc_5E2A:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

loc_5E4A:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

sub_5E50:
		move.b	$26(a0),d0
		bsr.w	GetSine
		move.w	d0,d2
		muls.w	#$38,d2
		asr.l	#8,d2
		add.w	d2,$14(a0)
		muls.w	$14(a0),d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	$14(a0),d0
		asr.l	#8,d0
		move.w	d0,$12(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels/GHZ/RollingBall/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjCollapsePtfm:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_5EEE(pc,d0.w),d1
		jmp	off_5EEE(pc,d1.w)
; ---------------------------------------------------------------------------

off_5EEE:	dc.w loc_5EFA-off_5EEE, loc_5F2A-off_5EEE, loc_5F4E-off_5EEE, loc_5F7E-off_5EEE, loc_5FDE-off_5EEE
		dc.w sub_5F60-off_5EEE
; ---------------------------------------------------------------------------

loc_5EFA:
		addq.b	#2,$24(a0)
		move.l	#MapCollapsePtfm,4(a0)
		move.w	#$4000,2(a0)
		ori.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#7,$38(a0)
		move.b	#$64,$18(a0)
		move.b	$28(a0),$1A(a0)

loc_5F2A:
		tst.b	$3A(a0)
		beq.s	loc_5F3C
		tst.b	$38(a0)
		beq.w	loc_612A
		subq.b	#1,$38(a0)

loc_5F3C:
		move.w	#$30,d1
		lea	(ObjCollapsePtfm_Slope).l,a2
		bsr.w	PtfmSloped
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_5F4E:
		tst.b	$38(a0)
		beq.w	loc_6130
		move.b	#1,$3A(a0)
		subq.b	#1,$38(a0)
; ---------------------------------------------------------------------------

sub_5F60:
		move.w	#$30,d1
		bsr.w	PtfmCheckExit
		move.w	#$30,d1
		lea	(ObjCollapsePtfm_Slope).l,a2
		move.w	8(a0),d2
		bsr.w	sub_61E0
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_5F7E:
		tst.b	$38(a0)
		beq.s	loc_5FCE
		tst.b	$3A(a0)
		bne.w	loc_5F94
		subq.b	#1,$38(a0)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_5F94:
		subq.b	#1,$38(a0)
		bsr.w	sub_5F60
		lea	(ObjectsList).w,a1
		btst	#3,$22(a1)
		beq.s	loc_5FC0
		tst.b	$38(a0)
		bne.s	locret_5FCC
		bclr	#3,$22(a1)
		bclr	#5,$22(a1)
		move.b	#1,$1D(a1)

loc_5FC0:
		move.b	#0,$3A(a0)
		move.b	#6,$24(a0)

locret_5FCC:
		rts
; ---------------------------------------------------------------------------

loc_5FCE:
		bsr.w	ObjectFall
		bsr.w	ObjectDisplay
		tst.b	1(a0)
		bpl.s	loc_5FDE
		rts
; ---------------------------------------------------------------------------

loc_5FDE:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjCollapseFloor:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_5FF2(pc,d0.w),d1
		jmp	off_5FF2(pc,d1.w)
; ---------------------------------------------------------------------------

off_5FF2:	dc.w loc_5FFE-off_5FF2, loc_603A-off_5FF2, loc_607C-off_5FF2, loc_60A2-off_5FF2, loc_6102-off_5FF2
		dc.w sub_608E-off_5FF2
; ---------------------------------------------------------------------------

loc_5FFE:
		addq.b	#2,$24(a0)
		move.l	#MapCollapseFloor,4(a0)
		move.w	#$42B8,2(a0)
		cmpi.b	#3,(level).w
		bne.s	loc_6022
		move.w	#$44E0,2(a0)
		addq.b	#2,$1A(a0)

loc_6022:
		ori.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#7,$38(a0)
		move.b	#$44,$18(a0)

loc_603A:
		tst.b	$3A(a0)
		beq.s	loc_604C
		tst.b	$38(a0)
		beq.w	loc_6108
		subq.b	#1,$38(a0)

loc_604C:
		move.w	#$20,d1
		bsr.w	PtfmNormal
		tst.b	$28(a0)
		bpl.s	loc_6078
		btst	#3,$22(a1)
		beq.s	loc_6078
		bclr	#0,1(a0)
		move.w	8(a1),d0
		sub.w	8(a0),d0
		bcc.s	loc_6078
		bset	#0,1(a0)

loc_6078:
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_607C:
		tst.b	$38(a0)
		beq.w	loc_610E
		move.b	#1,$3A(a0)
		subq.b	#1,$38(a0)
; ---------------------------------------------------------------------------

sub_608E:
		move.w	#$20,d1
		bsr.w	PtfmCheckExit
		move.w	8(a0),d2
		bsr.w	ptfmSurfaceNormal
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_60A2:
		tst.b	$38(a0)
		beq.s	loc_60F2
		tst.b	$3A(a0)
		bne.w	loc_60B8
		subq.b	#1,$38(a0)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_60B8:
		subq.b	#1,$38(a0)
		bsr.w	sub_608E
		lea	(ObjectsList).w,a1
		btst	#3,$22(a1)
		beq.s	loc_60E4
		tst.b	$38(a0)
		bne.s	locret_60F0
		bclr	#3,$22(a1)
		bclr	#5,$22(a1)
		move.b	#1,$1D(a1)

loc_60E4:
		move.b	#0,$3A(a0)
		move.b	#6,$24(a0)

locret_60F0:
		rts
; ---------------------------------------------------------------------------

loc_60F2:
		bsr.w	ObjectFall
		bsr.w	ObjectDisplay
		tst.b	1(a0)
		bpl.s	loc_6102
		rts
; ---------------------------------------------------------------------------

loc_6102:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

loc_6108:
		move.b	#0,$3A(a0)

loc_610E:
		lea	(ObjCollapseFloor_Delay2).l,a4
		btst	#0,$28(a0)
		beq.s	loc_6122
		lea	(ObjCollapseFloor_Delay3).l,a4

loc_6122:
		moveq	#7,d1
		addq.b	#1,$1A(a0)
		bra.s	loc_613C
; ---------------------------------------------------------------------------

loc_612A:
		move.b	#0,$3A(a0)

loc_6130:
		lea	(ObjCollapseFloor_Delay1).l,a4
		moveq	#$18,d1
		addq.b	#2,$1A(a0)

loc_613C:
		moveq	#0,d0
		move.b	$1A(a0),d0
		add.w	d0,d0
		movea.l	4(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,1(a0)
		move.b	0(a0),d4
		move.b	1(a0),d5
		movea.l	a0,a1
		bra.s	loc_6168
; ---------------------------------------------------------------------------

loc_6160:
		bsr.w	ObjectLoad
		bne.s	loc_61A8
		addq.w	#5,a3

loc_6168:
		move.b	#6,$24(a1)
		move.b	d4,0(a1)
		move.l	a3,4(a1)
		move.b	d5,1(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.w	2(a0),2(a1)
		move.b	$19(a0),$19(a1)
		move.b	$18(a0),$18(a1)
		move.b	(a4)+,$38(a1)
		cmpa.l	a0,a1
		bcc.s	loc_61A4
		bsr.w	ObjectDisplayA1

loc_61A4:
		dbf	d1,loc_6160

loc_61A8:
		bsr.w	ObjectDisplay
		move.w	#$B9,d0
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------

ObjCollapseFloor_Delay1:dc.b $1C, $18, $14, $10, $1A, $16, $12, $E, $A, 6, $18
		dc.b $14, $10, $C, 8, 4, $16, $12, $E, $A, 6, 2, $14, $10
		dc.b $C, 0

ObjCollapseFloor_Delay2:dc.b $1E, $16, $E, 6, $1A, $12, $A, 2

ObjCollapseFloor_Delay3:dc.b $16, $1E, $1A, $12, 6, $E, $A, 2
; ---------------------------------------------------------------------------

sub_61E0:
		lea	(ObjectsList).w,a1
		btst	#3,$22(a1)
		beq.s	locret_6224
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		lsr.w	#1,d0
		btst	#0,1(a0)
		beq.s	loc_6204
		not.w	d0
		add.w	d1,d0

loc_6204:
		moveq	#0,d1
		move.b	(a2,d0.w),d1
		move.w	$C(a0),d0
		sub.w	d1,d0
		moveq	#0,d1
		move.b	$16(a1),d1
		sub.w	d1,d0
		move.w	d0,$C(a1)
		sub.w	8(a0),d2
		sub.w	d2,8(a1)

locret_6224:
		rts
; ---------------------------------------------------------------------------

ObjCollapsePtfm_Slope:dc.b $20, $20, $20, $20, $20, $20, $20, $20, $21, $21
		dc.b $22, $22, $23, $23, $24, $24, $25, $25, $26, $26
		dc.b $27, $27, $28, $28, $29, $29, $2A, $2A, $2B, $2B
		dc.b $2C, $2C, $2D, $2D, $2E, $2E, $2F, $2F, $30, $30
		dc.b $30, $30, $30, $30, $30, $30, $30, $30
		include "unknown/06526.map"
		include "levels/GHZ/CollapsePtfm/Sprite.map"
		include "levels/GHZ/CollapseFloor/Sprite.map"
		even
; ---------------------------------------------------------------------------

Obj1B:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_6634(pc,d0.w),d1
		jmp	off_6634(pc,d1.w)
; ---------------------------------------------------------------------------

off_6634:	dc.w loc_663E-off_6634, loc_6676-off_6634, loc_668A-off_6634, loc_66CE-off_6634, loc_66D6-off_6634
; ---------------------------------------------------------------------------

loc_663E:
		addq.b	#2,$24(a0)
		move.l	#Map1B,4(a0)
		move.w	#$4000,2(a0)
		move.b	#4,1(a0)
		move.b	#$20,$18(a0)
		move.b	#5,$19(a0)
		tst.b	$28(a0)
		bne.s	loc_6676
		move.b	#1,$19(a0)
		move.b	#6,$24(a0)
		rts
; ---------------------------------------------------------------------------

loc_6676:
		move.w	#$20,d1
		move.w	#$FFEC,d3
		bsr.w	PtfmNormalHeight
		bsr.w	ObjectDisplay
		bra.w	loc_66A8
; ---------------------------------------------------------------------------

loc_668A:
		move.w	#$20,d1
		bsr.w	PtfmCheckExit
		move.w	8(a0),d2
		move.w	#$FFEC,d3
		bsr.w	PtfmSurfaceHeight
		bsr.w	ObjectDisplay
		bra.w	loc_66A8
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_66A8:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	loc_66C8
		rts
; ---------------------------------------------------------------------------

loc_66C8:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

loc_66CE:
		bsr.w	ObjectDisplay
		bra.w	loc_66A8
; ---------------------------------------------------------------------------

loc_66D6:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

Map1B:		dc.w byte_66E0-Map1B, byte_66F5-Map1B

byte_66E0:	dc.b 4
		dc.b $F0, $A, 0, $89, $E0
		dc.b $F0, $A, 8, $89, 8
		dc.b $F8, 5, 0, $92, $F8
		dc.b 8, $C, 0, $96, $F0

byte_66F5:	dc.b 4
		dc.b $E8, $F, 0, $9A, $E0
		dc.b $E8, $F, 8, $9A, 0
		dc.b 8, $D, 0, $AA, $E0
		dc.b 8, $D, 8, $AA, 0
; ---------------------------------------------------------------------------

ObjScenery:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_6718(pc,d0.w),d1
		jmp	off_6718(pc,d1.w)
; ---------------------------------------------------------------------------

off_6718:	dc.w loc_6720-off_6718, loc_6750-off_6718, loc_6774-off_6718, loc_6774-off_6718
; ---------------------------------------------------------------------------

loc_6720:
		addq.b	#2,$24(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		mulu.w	#$A,d0
		lea	ObjScenery_Types(pc,d0.w),a1
		move.l	(a1)+,4(a0)
		move.w	(a1)+,2(a0)
		ori.b	#4,1(a0)
		move.b	(a1)+,$1A(a0)
		move.b	(a1)+,$18(a0)
		move.b	(a1)+,$19(a0)
		move.b	(a1)+,$20(a0)

loc_6750:
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	loc_6774
		rts
; ---------------------------------------------------------------------------

loc_6774:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjScenery_Types:dc.l MapScenery
		dc.w $398
		dc.b 0, $10, 4, $82
		dc.l MapScenery
		dc.w $398
		dc.b 1, $14, 4, $83
		dc.l MapScenery
		dc.w $4000
		dc.b 0, $20, 1, 0
		dc.l MapBridge
		dc.w $438E
		dc.b 1, $10, 1, 0
		include "levels/shared/Scenery/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjUnkSwitch:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_67C8(pc,d0.w),d1
		jmp	off_67C8(pc,d1.w)
; ---------------------------------------------------------------------------

off_67C8:	dc.w loc_67CE-off_67C8, loc_67F8-off_67C8, loc_6836-off_67C8
; ---------------------------------------------------------------------------

loc_67CE:
		addq.b	#2,$24(a0)
		move.l	#MapUnkSwitch,4(a0)
		move.w	#$4000,2(a0)
		move.b	#4,1(a0)
		move.w	$C(a0),$30(a0)
		move.b	#$10,$18(a0)
		move.b	#5,$19(a0)

loc_67F8:
		move.w	$30(a0),$C(a0)
		move.w	#$10,d1
		bsr.w	sub_683C
		beq.s	loc_6812
		addq.w	#2,$C(a0)
		moveq	#1,d0
		move.w	d0,(unk_FFF7E0).w

loc_6812:
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	loc_6836
		rts
; ---------------------------------------------------------------------------

loc_6836:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

sub_683C:
		lea	(ObjectsList).w,a1
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.s	loc_6874
		add.w	d1,d1
		cmp.w	d1,d0
		bcc.s	loc_6874
		move.w	$C(a1),d2
		move.b	$16(a1),d1
		ext.w	d1
		add.w	d2,d1
		move.w	$C(a0),d0
		subi.w	#$10,d0
		sub.w	d1,d0
		bhi.s	loc_6874
		cmpi.w	#$FFF0,d0
		bcs.s	loc_6874
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_6874:
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------
		include "unsorted/Uknown Switch.map"
		even
; ---------------------------------------------------------------------------

Obj2A:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_689E(pc,d0.w),d1
		jmp	off_689E(pc,d1.w)
; ---------------------------------------------------------------------------

off_689E:	dc.w loc_68A4-off_689E, loc_68F0-off_689E, loc_6912-off_689E
; ---------------------------------------------------------------------------

loc_68A4:
		addq.b	#2,$24(a0)
		move.l	#Map2A,4(a0)
		move.w	#0,2(a0)
		move.b	#4,1(a0)
		move.w	$C(a0),d0
		subi.w	#$20,d0
		move.w	d0,$30(a0)
		move.b	#$B,$18(a0)
		move.b	#5,$19(a0)
		tst.b	$28(a0)
		beq.s	loc_68F0
		move.b	#1,$1A(a0)
		move.w	#$4000,2(a0)
		move.b	#4,$19(a0)
		addq.b	#2,$24(a0)

loc_68F0:
		tst.w	(unk_FFF7E0).w
		beq.s	loc_6906
		subq.w	#1,$C(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		beq.w	ObjectDelete

loc_6906:
		move.w	#$16,d1
		move.w	#$10,d2
		bsr.w	sub_6936

loc_6912:
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

sub_6936:
		tst.w	(DebugRoutine).w
		bne.w	locret_69A6
		cmpi.b	#6,(ObjectsList+$24).w
		bcc.s	locret_69A6
		bsr.w	sub_69CE
		beq.s	loc_698C
		bmi.w	loc_69A8
		tst.w	d0
		beq.w	loc_6976
		bmi.s	loc_6960
		tst.w	$10(a1)
		bmi.s	loc_6976
		bra.s	loc_6966
; ---------------------------------------------------------------------------

loc_6960:
		tst.w	$10(a1)
		bpl.s	loc_6976

loc_6966:
		sub.w	d0,8(a1)
		move.w	#0,$14(a1)
		move.w	#0,$10(a1)

loc_6976:
		btst	#1,$22(a1)
		bne.s	loc_699A
		bset	#5,$22(a1)
		bset	#5,$22(a0)
		rts
; ---------------------------------------------------------------------------

loc_698C:
		btst	#5,$22(a0)
		beq.s	locret_69A6
		move.w	#1,$1C(a1)

loc_699A:
		bclr	#5,$22(a0)
		bclr	#5,$22(a1)

locret_69A6:
		rts
; ---------------------------------------------------------------------------

loc_69A8:
		tst.w	$12(a1)
		beq.s	loc_69C0
		bpl.s	locret_69BE
		tst.w	d3
		bpl.s	locret_69BE
		sub.w	d3,$C(a1)
		move.w	#0,$12(a1)

locret_69BE:
		rts
; ---------------------------------------------------------------------------

loc_69C0:
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	loc_FD78
		movea.l	(sp)+,a0
		rts
; ---------------------------------------------------------------------------

sub_69CE:
		lea	(ObjectsList).w,a1
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.s	loc_6A28
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_6A28
		move.b	$16(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	$C(a1),d3
		sub.w	$C(a0),d3
		add.w	d2,d3
		bmi.s	loc_6A28
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.s	loc_6A28
		move.w	d0,d5
		cmp.w	d0,d1
		bcc.s	loc_6A10
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_6A10:
		move.w	d3,d1
		cmp.w	d3,d2
		bcc.s	loc_6A1C
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_6A1C:
		cmp.w	d1,d5
		bhi.s	loc_6A24
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_6A24:
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_6A28:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------
		include "unknown/Map2A.map"
		even
; ---------------------------------------------------------------------------

ObjTitleSonic:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_6A64(pc,d0.w),d1
		jmp	off_6A64(pc,d1.w)
; ---------------------------------------------------------------------------

off_6A64:	dc.w loc_6A6C-off_6A64, loc_6AA0-off_6A64, loc_6AB0-off_6A64, loc_6AC6-off_6A64
; ---------------------------------------------------------------------------

loc_6A6C:
		addq.b	#2,$24(a0)
		move.w	#$F0,8(a0)
		move.w	#$DE,$A(a0)
		move.l	#MapTitleSonic,4(a0)
		move.w	#$2300,2(a0)
		move.b	#1,$19(a0)
		move.b	#$1D,$1F(a0)
		lea	(AniTitleSonic).l,a1
		bsr.w	AnimateSprite

loc_6AA0:
		subq.b	#1,$1F(a0)
		bpl.s	locret_6AAE
		addq.b	#2,$24(a0)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

locret_6AAE:
		rts
; ---------------------------------------------------------------------------

loc_6AB0:
		subq.w	#8,$A(a0)
		cmpi.w	#$96,$A(a0)
		bne.s	loc_6AC0
		addq.b	#2,$24(a0)

loc_6AC0:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

loc_6AC6:
		lea	(AniTitleSonic).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

OibjTitleText:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_6AE8(pc,d0.w),d1
		jsr	off_6AE8(pc,d1.w)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

off_6AE8:	dc.w loc_6AEE-off_6AE8, loc_6B1A-off_6AE8, locret_6B18-off_6AE8
; ---------------------------------------------------------------------------

loc_6AEE:
		addq.b	#2,$24(a0)
		move.w	#$D0,8(a0)
		move.w	#$130,$A(a0)
		move.l	#MapTitleText,4(a0)
		move.w	#$200,2(a0)
		cmpi.b	#2,$1A(a0)
		bne.s	loc_6B1A
		addq.b	#2,$24(a0)

locret_6B18:
		rts
; ---------------------------------------------------------------------------

loc_6B1A:
		lea	(AniTitleText).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------
		include "screens/title/TitleSonic/Sprite.ani"
		include "screens/title/TitleText/Sprite.ani"
		even
; ---------------------------------------------------------------------------

AnimateSprite:
		moveq	#0,d0
		move.b	$1C(a0),d0
		cmp.b	$1D(a0),d0
		beq.s	loc_6B54
		move.b	d0,$1D(a0)
		move.b	#0,$1B(a0)
		move.b	#0,$1E(a0)

loc_6B54:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		subq.b	#1,$1E(a0)
		bpl.s	locret_6B94
		move.b	(a1),$1E(a0)
		moveq	#0,d1
		move.b	$1B(a0),d1
		move.b	1(a1,d1.w),d0
		bmi.s	loc_6B96

loc_6B70:
		move.b	d0,d1
		andi.b	#$1F,d0
		move.b	d0,$1A(a0)
		move.b	$22(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,1(a0)
		lsr.b	#5,d1
		eor.b	d0,d1
		or.b	d1,1(a0)
		addq.b	#1,$1B(a0)

locret_6B94:
		rts
; ---------------------------------------------------------------------------

loc_6B96:
		addq.b	#1,d0
		bne.s	loc_6BA6
		move.b	#0,$1B(a0)
		move.b	1(a1),d0
		bra.s	loc_6B70
; ---------------------------------------------------------------------------

loc_6BA6:
		addq.b	#1,d0
		bne.s	loc_6BBA
		move.b	2(a1,d1.w),d0
		sub.b	d0,$1B(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.s	loc_6B70
; ---------------------------------------------------------------------------

loc_6BBA:
		addq.b	#1,d0
		bne.s	loc_6BC4
		move.b	2(a1,d1.w),$1C(a0)

loc_6BC4:
		addq.b	#1,d0
		bne.s	loc_6BCC
		addq.b	#2,$24(a0)

loc_6BCC:
		addq.b	#1,d0
		bne.s	locret_6BDA
		move.b	#0,$1B(a0)
		clr.b	$25(a0)

locret_6BDA:
		rts
; ---------------------------------------------------------------------------
		include "screens/title/TitleText/Sprite.map"
		include "screens/title/TitleSonic/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjBallhog:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_6F3E(pc,d0.w),d1
		jmp	off_6F3E(pc,d1.w)
; ---------------------------------------------------------------------------

off_6F3E:	dc.w loc_6F46-off_6F3E, loc_6F96-off_6F3E, loc_7056-off_6F3E, loc_705C-off_6F3E
; ---------------------------------------------------------------------------

loc_6F46:
		move.b	#$13,$16(a0)
		move.b	#8,$17(a0)
		move.l	#MapBallhog,4(a0)
		move.w	#$2400,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#5,$20(a0)
		move.b	#$C,$18(a0)
		bsr.w	ObjectFall
		jsr	sub_105F0
		tst.w	d1
		bpl.s	locret_6F94
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)

locret_6F94:
		rts
; ---------------------------------------------------------------------------

loc_6F96:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_6FB2(pc,d0.w),d1
		jsr	off_6FB2(pc,d1.w)
		lea	(AniBallhog).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_6FB2:	dc.w loc_6FB6-off_6FB2, loc_701C-off_6FB2
; ---------------------------------------------------------------------------

loc_6FB6:
		subq.w	#1,$30(a0)
		bpl.s	loc_6FE6
		addq.b	#2,$25(a0)
		move.w	#$FF,$30(a0)
		move.w	#$40,$10(a0)
		move.b	#1,$1C(a0)
		bchg	#0,$22(a0)
		bne.s	loc_6FDE
		neg.w	$10(a0)

loc_6FDE:
		move.b	#0,$32(a0)
		rts
; ---------------------------------------------------------------------------

loc_6FE6:
		tst.b	$32(a0)
		bne.s	locret_6FF4
		cmpi.b	#2,$1A(a0)
		beq.s	loc_6FF6

locret_6FF4:
		rts
; ---------------------------------------------------------------------------

loc_6FF6:
		move.b	#1,$32(a0)
		bsr.w	ObjectLoad
		bne.s	locret_701A
		move.b	#$20,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		addi.w	#$10,$C(a1)

locret_701A:
		rts
; ---------------------------------------------------------------------------

loc_701C:
		subq.w	#1,$30(a0)
		bmi.s	loc_7032
		bsr.w	ObjectMove
		jsr	sub_105F0
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_7032:
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)
		tst.b	1(a0)
		bpl.s	locret_7054
		move.b	#2,$1C(a0)

locret_7054:
		rts
; ---------------------------------------------------------------------------

loc_7056:
		bsr.w	ObjectDisplay
		rts
; ---------------------------------------------------------------------------

loc_705C:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjCannonball:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_7070(pc,d0.w),d1
		jmp	off_7070(pc,d1.w)
; ---------------------------------------------------------------------------

off_7070:	dc.w loc_7076-off_7070, loc_70A6-off_7070, loc_70EE-off_7070
; ---------------------------------------------------------------------------

loc_7076:
		addq.b	#2,$24(a0)
		move.l	#MapCannonball,4(a0)
		move.w	#$2418,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$87,$20(a0)
		move.b	#8,$18(a0)
		move.w	#$18,$30(a0)

loc_70A6:
		btst	#7,$22(a0)
		bne.s	loc_70C2
		tst.w	$30(a0)
		bne.s	loc_70D2
		jsr	sub_105F0
		tst.w	d1
		bpl.s	loc_70D6
		add.w	d1,$C(a0)

loc_70C2:
		move.b	#$24,0(a0)
		move.b	#0,$24(a0)
		bra.w	ObjCannonballExplode
; ---------------------------------------------------------------------------

loc_70D2:
		subq.w	#1,$30(a0)

loc_70D6:
		bsr.w	ObjectFall
		bsr.w	ObjectDisplay
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.s	loc_70EE
		rts
; ---------------------------------------------------------------------------

loc_70EE:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjCannonballExplode:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_7102(pc,d0.w),d1
		jmp	off_7102(pc,d1.w)
; ---------------------------------------------------------------------------

off_7102:	dc.w loc_7106-off_7102, loc_7146-off_7102
; ---------------------------------------------------------------------------

loc_7106:
		addq.b	#2,$24(a0)
		move.l	#MapCannonballExplode,4(a0)
		move.w	#$41C,2(a0)
		move.b	#4,1(a0)
		move.b	#2,$19(a0)
		move.b	#0,$20(a0)
		move.b	#$C,$18(a0)
		move.b	#9,$1E(a0)
		move.b	#0,$1A(a0)
		move.w	#$A5,d0
		jsr	(PlaySFX).l

loc_7146:
		subq.b	#1,$1E(a0)
		bpl.s	loc_7160
		move.b	#9,$1E(a0)
		addq.b	#1,$1A(a0)
		cmpi.b	#4,$1A(a0)
		beq.w	ObjectDelete

loc_7160:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

ObjExplode:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_7172(pc,d0.w),d1
		jmp	off_7172(pc,d1.w)
; ---------------------------------------------------------------------------

off_7172:	dc.w loc_7178-off_7172, loc_7194-off_7172, loc_71D4-off_7172
; ---------------------------------------------------------------------------

loc_7178:
		addq.b	#2,$24(a0)
		bsr.w	ObjectLoad
		bne.s	loc_7194
		move.b	#$28,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)

loc_7194:
		addq.b	#2,$24(a0)
		move.l	#MapExplode,4(a0)
		move.w	#$5A0,2(a0)
		move.b	#4,1(a0)
		move.b	#2,$19(a0)
		move.b	#0,$20(a0)
		move.b	#$C,$18(a0)
		move.b	#7,$1E(a0)
		move.b	#0,$1A(a0)
		move.w	#$C1,d0
		jsr	(PlaySFX).l

loc_71D4:
		subq.b	#1,$1E(a0)
		bpl.s	loc_71EE
		move.b	#7,$1E(a0)
		addq.b	#1,$1A(a0)
		cmpi.b	#5,$1A(a0)
		beq.w	ObjectDelete

loc_71EE:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

ObjBombExplode:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_7200(pc,d0.w),d1
		jmp	off_7200(pc,d1.w)
; ---------------------------------------------------------------------------

off_7200:	dc.w loc_7204-off_7200, loc_71D4-off_7200
; ---------------------------------------------------------------------------

loc_7204:
		addq.b	#2,$24(a0)
		move.l	#MapBombExplode,4(a0)
		move.w	#$5A0,2(a0)
		move.b	#4,1(a0)
		move.b	#2,$19(a0)
		move.b	#0,$20(a0)
		move.b	#$C,$18(a0)
		move.b	#7,$1E(a0)
		move.b	#0,$1A(a0)
		move.w	#$C4,d0
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------
		include "levels/GHZ/BallHog/Sprite.ani"
		include "levels/GHZ/BallHog/Sprite.map"
		include "levels/GHZ/BallHog/Cannonball.map"
		include "levels/GHZ/BallHog/CannonballExplode.map"
		include "levels/shared/Explosion/Sprite.map"
		include "levels/shared/Explosion/Bomb.map"
		even
; ---------------------------------------------------------------------------

ObjAnimals:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_732C(pc,d0.w),d1
		jmp	off_732C(pc,d1.w)
; ---------------------------------------------------------------------------

off_732C:	dc.w loc_7382-off_732C, loc_7418-off_732C, loc_7472-off_732C, loc_74A8-off_732C, loc_7472-off_732C
		dc.w loc_7472-off_732C, loc_7472-off_732C, loc_74A8-off_732C, loc_7472-off_732C

byte_733E:	dc.b 0, 1, 2, 3, 4, 5, 6, 3, 4, 1, 0, 5

word_734A:	dc.w $FE00, $FC00
		dc.l MapAnimals1
		dc.w $FE00, $FD00
		dc.l MapAnimals2
		dc.w $FEC0, $FE00
		dc.l MapAnimals1
		dc.w $FF00, $FE80
		dc.l MapAnimals2
		dc.w $FE80, $FD00
		dc.l MapAnimals3
		dc.w $FD00, $FC00
		dc.l MapAnimals2
		dc.w $FD80, $FC80
		dc.l MapAnimals3
; ---------------------------------------------------------------------------

loc_7382:
		addq.b	#2,$24(a0)
		bsr.w	RandomNumber
		andi.w	#1,d0
		moveq	#0,d1
		move.b	(level).w,d1
		add.w	d1,d1
		add.w	d0,d1
		move.b	byte_733E(pc,d1.w),d0
		move.b	d0,$30(a0)
		lsl.w	#3,d0
		lea	word_734A(pc,d0.w),a1
		move.w	(a1)+,$32(a0)
		move.w	(a1)+,$34(a0)
		move.l	(a1)+,4(a0)
		move.w	#$580,2(a0)
		btst	#0,$30(a0)
		beq.s	loc_73C6
		move.w	#$592,2(a0)

loc_73C6:
		move.b	#$C,$16(a0)
		move.b	#4,1(a0)
		bset	#0,1(a0)
		move.b	#6,$19(a0)
		move.b	#8,$18(a0)
		move.b	#7,$1E(a0)
		move.b	#2,$1A(a0)
		move.w	#$FC00,$12(a0)
		tst.b	(unk_FFF7A7).w
		bne.s	loc_7438
		bsr.w	ObjectLoad
		bne.s	loc_7414
		move.b	#$29,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)

loc_7414:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_7418:
		tst.b	1(a0)
		bpl.w	ObjectDelete
		bsr.w	ObjectFall
		tst.w	$12(a0)
		bmi.s	loc_746E
		jsr	sub_105F0
		tst.w	d1
		bpl.s	loc_746E
		add.w	d1,$C(a0)

loc_7438:
		move.w	$32(a0),$10(a0)
		move.w	$34(a0),$12(a0)
		move.b	#1,$1A(a0)
		move.b	$30(a0),d0
		add.b	d0,d0
		addq.b	#4,d0
		move.b	d0,$24(a0)
		tst.b	(unk_FFF7A7).w
		beq.s	loc_746E
		btst	#4,(byte_FFFE0F).w
		beq.s	loc_746E
		neg.w	$10(a0)
		bchg	#0,1(a0)

loc_746E:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_7472:
		bsr.w	ObjectFall
		move.b	#1,$1A(a0)
		tst.w	$12(a0)
		bmi.s	loc_749C
		move.b	#0,$1A(a0)
		jsr	sub_105F0
		tst.w	d1
		bpl.s	loc_749C
		add.w	d1,$C(a0)
		move.w	$34(a0),$12(a0)

loc_749C:
		tst.b	1(a0)
		bpl.w	ObjectDelete
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_74A8:
		bsr.w	ObjectMove
		addi.w	#$18,$12(a0)
		tst.w	$12(a0)
		bmi.s	loc_74CC
		jsr	sub_105F0
		tst.w	d1
		bpl.s	loc_74CC
		add.w	d1,$C(a0)
		move.w	$34(a0),$12(a0)

loc_74CC:
		subq.b	#1,$1E(a0)
		bpl.s	loc_74E2
		move.b	#1,$1E(a0)
		addq.b	#1,$1A(a0)
		andi.b	#1,$1A(a0)

loc_74E2:
		tst.b	1(a0)
		bpl.w	ObjectDelete
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

ObjPoints:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_7500(pc,d0.w),d1
		jsr	off_7500(pc,d1.w)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

off_7500:	dc.w loc_7504-off_7500, loc_752E-off_7500
; ---------------------------------------------------------------------------

loc_7504:
		addq.b	#2,$24(a0)
		move.l	#MapPoints,4(a0)
		move.w	#$2797,2(a0)
		move.b	#4,1(a0)
		move.b	#1,$19(a0)
		move.b	#8,$18(a0)
		move.w	#$FD00,$12(a0)

loc_752E:
		tst.w	$12(a0)
		bpl.w	ObjectDelete
		bsr.w	ObjectMove
		addi.w	#$18,$12(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels/shared/Animals/1.map"
		include "levels/shared/Animals/2.map"
		include "levels/shared/Animals/3.map"
		include "levels/shared/Points/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjCrabmeat:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_75B8(pc,d0.w),d1
		jmp	off_75B8(pc,d1.w)
; ---------------------------------------------------------------------------

off_75B8:	dc.w loc_75C2-off_75B8, loc_7616-off_75B8, loc_7772-off_75B8, loc_7778-off_75B8, loc_77AE-off_75B8
; ---------------------------------------------------------------------------

loc_75C2:
		move.b	#$10,$16(a0)
		move.b	#8,$17(a0)
		move.l	#MapCrabmeat,4(a0)
		move.w	#$400,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#6,$20(a0)
		move.b	#$15,$18(a0)
		bsr.w	ObjectFall
		jsr	sub_105F0
		tst.w	d1
		bpl.s	locret_7614
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)

locret_7614:
		rts
; ---------------------------------------------------------------------------

loc_7616:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_7632(pc,d0.w),d1
		jsr	off_7632(pc,d1.w)
		lea	(AniCrabmeat).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_7632:	dc.w loc_7636-off_7632, loc_76D4-off_7632
; ---------------------------------------------------------------------------

loc_7636:
		subq.w	#1,$30(a0)
		bpl.s	locret_7670
		tst.b	1(a0)
		bpl.s	loc_764A
		bchg	#1,$32(a0)
		bne.s	loc_7672

loc_764A:
		addq.b	#2,$25(a0)
		move.w	#$7F,$30(a0)
		move.w	#$80,$10(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,$1C(a0)
		bchg	#0,$22(a0)
		bne.s	locret_7670
		neg.w	$10(a0)

locret_7670:
		rts
; ---------------------------------------------------------------------------

loc_7672:
		move.w	#$3B,$30(a0)
		move.b	#6,$1C(a0)
		bsr.w	ObjectLoad
		bne.s	loc_76A8
		move.b	#$1F,0(a1)
		move.b	#6,$24(a1)
		move.w	8(a0),8(a1)
		subi.w	#$10,8(a1)
		move.w	$C(a0),$C(a1)
		move.w	#$FF00,$10(a1)

loc_76A8:
		bsr.w	ObjectLoad
		bne.s	locret_76D2
		move.b	#$1F,0(a1)
		move.b	#6,$24(a1)
		move.w	8(a0),8(a1)
		addi.w	#$10,8(a1)
		move.w	$C(a0),$C(a1)
		move.w	#$100,$10(a1)

locret_76D2:
		rts
; ---------------------------------------------------------------------------

loc_76D4:
		subq.w	#1,$30(a0)
		bmi.s	loc_7728
		bsr.w	ObjectMove
		bchg	#0,$32(a0)
		bne.s	loc_770E
		move.w	8(a0),d3
		addi.w	#$10,d3
		btst	#0,$22(a0)
		beq.s	loc_76FA
		subi.w	#$20,d3

loc_76FA:
		jsr	loc_105F4
		cmpi.w	#$FFF8,d1
		blt.s	loc_7728
		cmpi.w	#$C,d1
		bge.s	loc_7728
		rts
; ---------------------------------------------------------------------------

loc_770E:
		jsr	sub_105F0
		add.w	d1,$C(a0)
		move.b	d3,$26(a0)
		bsr.w	sub_7742
		addq.b	#3,d0
		move.b	d0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_7728:
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)

loc_7732:
		move.w	#0,$10(a0)
		bsr.w	sub_7742
		move.b	d0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

sub_7742:
		moveq	#0,d0
		move.b	$26(a0),d3
		bmi.s	loc_775E
		cmpi.b	#6,d3
		bcs.s	locret_775C
		moveq	#1,d0
		btst	#0,$22(a0)
		bne.s	locret_775C
		moveq	#2,d0

locret_775C:
		rts
; ---------------------------------------------------------------------------

loc_775E:
		cmpi.b	#$FA,d3
		bhi.s	locret_7770
		moveq	#2,d0
		btst	#0,$22(a0)
		bne.s	locret_7770
		moveq	#1,d0

locret_7770:
		rts
; ---------------------------------------------------------------------------

loc_7772:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

loc_7778:
		addq.b	#2,$24(a0)
		move.l	#MapCrabmeat,4(a0)
		move.w	#$400,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$87,$20(a0)
		move.b	#8,$18(a0)
		move.w	#$FC00,$12(a0)
		move.b	#7,$1C(a0)

loc_77AE:
		lea	(AniCrabmeat).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectFall
		bsr.w	ObjectDisplay
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.s	loc_77D0
		rts
; ---------------------------------------------------------------------------

loc_77D0:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------
		include "levels/GHZ/Crabmeat/Sprite.ani"
		include "levels/GHZ/Crabmeat/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjBuzzbomber:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_78A6(pc,d0.w),d1
		jmp	off_78A6(pc,d1.w)
; ---------------------------------------------------------------------------

off_78A6:	dc.w loc_78AC-off_78A6, loc_78D6-off_78A6, loc_79E6-off_78A6
; ---------------------------------------------------------------------------

loc_78AC:
		addq.b	#2,$24(a0)
		move.l	#MapBuzzbomber,4(a0)
		move.w	#$444,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#8,$20(a0)
		move.b	#$18,$18(a0)

loc_78D6:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	loc_78F2(pc,d0.w),d1
		jsr	loc_78F2(pc,d1.w)
		lea	(AniBuzzbomber).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_78F2:
		ori.b	#$9A,d4
		subq.w	#1,$32(a0)
		bpl.s	locret_7926
		btst	#1,$34(a0)
		bne.s	loc_7928
		addq.b	#2,$25(a0)
		move.w	#$7F,$32(a0)
		move.w	#$400,$10(a0)
		move.b	#1,$1C(a0)
		btst	#0,$22(a0)
		bne.s	locret_7926
		neg.w	$10(a0)

locret_7926:
		rts
; ---------------------------------------------------------------------------

loc_7928:
		bsr.w	ObjectLoad
		bne.s	locret_798A
		move.b	#$23,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		addi.w	#$1C,$C(a1)
		move.w	#$200,$12(a1)
		move.w	#$200,$10(a1)
		move.w	#$18,d0
		btst	#0,$22(a0)
		bne.s	loc_7964
		neg.w	d0
		neg.w	$10(a1)

loc_7964:
		add.w	d0,8(a1)
		move.b	$22(a0),$22(a1)
		move.w	#$E,$32(a1)
		move.l	a0,$3C(a1)
		move.b	#1,$34(a0)
		move.w	#$3B,$32(a0)
		move.b	#2,$1C(a0)

locret_798A:
		rts
; ---------------------------------------------------------------------------
		subq.w	#1,$32(a0)
		bmi.s	loc_79C2
		bsr.w	ObjectMove
		tst.b	$34(a0)
		bne.s	locret_79E4
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bpl.s	loc_79A8
		neg.w	d0

loc_79A8:
		cmpi.w	#$60,d0
		bcc.s	locret_79E4
		tst.b	1(a0)
		bpl.s	locret_79E4
		move.b	#2,$34(a0)
		move.w	#$1D,$32(a0)
		bra.s	loc_79D4
; ---------------------------------------------------------------------------

loc_79C2:
		move.b	#0,$34(a0)
		bchg	#0,$22(a0)
		move.w	#$3B,$32(a0)

loc_79D4:
		subq.b	#2,$25(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)

locret_79E4:
		rts
; ---------------------------------------------------------------------------

loc_79E6:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjBuzzMissile:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_79FA(pc,d0.w),d1
		jmp	off_79FA(pc,d1.w)
; ---------------------------------------------------------------------------

off_79FA:	dc.w loc_7A04-off_79FA, loc_7A4E-off_79FA, loc_7A6C-off_79FA, loc_7AB2-off_79FA, loc_7AB8-off_79FA
; ---------------------------------------------------------------------------

loc_7A04:
		subq.w	#1,$32(a0)
		bpl.s	sub_7A5E
		addq.b	#2,$24(a0)
		move.l	#MapBuzzMissile,4(a0)
		move.w	#$2444,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#8,$18(a0)
		andi.b	#3,$22(a0)
		tst.b	$28(a0)
		beq.s	loc_7A4E
		move.b	#8,$24(a0)
		move.b	#$87,$20(a0)
		move.b	#1,$1C(a0)
		bra.s	loc_7AC2
; ---------------------------------------------------------------------------

loc_7A4E:
		bsr.s	sub_7A5E
		lea	(AniBuzzMissile).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

sub_7A5E:
		movea.l	$3C(a0),a1
		cmpi.b	#$27,0(a1)
		beq.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7A6C:
		btst	#7,$22(a0)
		bne.s	loc_7AA2
		move.b	#$87,$20(a0)
		move.b	#1,$1C(a0)
		bsr.w	ObjectMove
		lea	(AniBuzzMissile).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectDisplay
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.s	loc_7AB2
		rts
; ---------------------------------------------------------------------------

loc_7AA2:
		move.b	#$24,0(a0)
		move.b	#0,$24(a0)
		bra.w	ObjCannonballExplode
; ---------------------------------------------------------------------------

loc_7AB2:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

loc_7AB8:
		tst.b	1(a0)
		bpl.s	loc_7AB2
		bsr.w	ObjectMove

loc_7AC2:
		lea	(AniBuzzMissile).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectDisplay
		rts
; ---------------------------------------------------------------------------
		include "levels/GHZ/Buzzbomber/Sprite.ani"
		include "levels/GHZ/Buzzbomber/Missile.ani"
		include "levels/GHZ/Buzzbomber/Sprite.map"
		include "levels/GHZ/Buzzbomber/Missile.map"
		even
; ---------------------------------------------------------------------------

ObjRing:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_7BEE(pc,d0.w),d1
		jmp	off_7BEE(pc,d1.w)
; ---------------------------------------------------------------------------

off_7BEE:	dc.w loc_7C18-off_7BEE, loc_7CD0-off_7BEE, loc_7CF8-off_7BEE, loc_7D1E-off_7BEE, loc_7D2C-off_7BEE

byte_7BF8:	dc.b $10, 0
		dc.b $18, 0
		dc.b $20, 0
		dc.b 0, $10
		dc.b 0, $18
		dc.b 0, $20
		dc.b $10, $10
		dc.b $18, $18
		dc.b $20, $20
		dc.b $F0, $10
		dc.b $E8, $18
		dc.b $E0, $20
		dc.b $10, 8
		dc.b $18, $10
		dc.b $F0, 8
		dc.b $E8, $10
; ---------------------------------------------------------------------------

loc_7C18:
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		lea	2(a2,d0.w),a2
		move.b	(a2),d4
		move.b	$28(a0),d1
		move.b	d1,d0
		andi.w	#7,d1
		cmpi.w	#7,d1
		bne.s	loc_7C3A
		moveq	#6,d1

loc_7C3A:
		swap	d1
		move.w	#0,d1
		lsr.b	#4,d0
		add.w	d0,d0
		move.b	byte_7BF8(pc,d0.w),d5
		ext.w	d5
		move.b	byte_7BF8+1(pc,d0.w),d6
		ext.w	d6
		movea.l	a0,a1
		move.w	8(a0),d2
		move.w	$C(a0),d3
		lsr.b	#1,d4
		bcs.s	loc_7CBC
		bclr	#7,(a2)
		bra.s	loc_7C74
; ---------------------------------------------------------------------------

loc_7C64:
		swap	d1
		lsr.b	#1,d4
		bcs.s	loc_7CBC
		bclr	#7,(a2)
		bsr.w	ObjectLoad
		bne.s	loc_7CC8

loc_7C74:
		move.b	#$25,0(a1)
		addq.b	#2,$24(a1)
		move.w	d2,8(a1)
		move.w	8(a0),$32(a1)
		move.w	d3,$C(a1)
		move.l	#MapRing,4(a1)
		move.w	#$27B2,2(a1)
		move.b	#4,1(a1)
		move.b	#2,$19(a1)
		move.b	#$47,$20(a1)
		move.b	#8,$18(a1)
		move.b	$23(a0),$23(a1)
		move.b	d1,$34(a1)

loc_7CBC:
		addq.w	#1,d1
		add.w	d5,d2
		add.w	d6,d3
		swap	d1
		dbf	d1,loc_7C64

loc_7CC8:
		btst	#0,(a2)
		bne.w	ObjectDelete

loc_7CD0:
		move.b	(RingFrame).w,$1A(a0)
		bsr.w	ObjectDisplay
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.s	loc_7D2C
		rts
; ---------------------------------------------------------------------------

loc_7CF8:
		addq.b	#2,$24(a0)
		move.b	#0,$20(a0)
		move.b	#1,$19(a0)
		bsr.w	CollectRing
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		move.b	$34(a0),d1
		bset	d1,2(a2,d0.w)

loc_7D1E:
		lea	(AniRing).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_7D2C:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

CollectRing:
		addq.w	#1,(Rings).w
		ori.b	#1,(ExtraLifeFlags).w
		move.w	#$B5,d0
		cmpi.w	#50,(Rings).w
		bcs.s	loc_7D6A
		bset	#0,(byte_FFFE1B).w
		beq.s	loc_7D5E
		cmpi.w	#100,(Rings).w
		bcs.s	loc_7D6A
		bset	#1,(byte_FFFE1B).w
		bne.s	loc_7D6A

loc_7D5E:
		addq.b	#1,(Lives).w
		addq.b	#1,(byte_FFFE1C).w
		move.w	#$88,d0

loc_7D6A:
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------

ObjRingLoss:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_7D7E(pc,d0.w),d1
		jmp	off_7D7E(pc,d1.w)
; ---------------------------------------------------------------------------

off_7D7E:	dc.w loc_7D88-off_7D7E, loc_7E48-off_7D7E
		dc.w loc_7E9A-off_7D7E, loc_7EAE-off_7D7E
		dc.w loc_7EBC-off_7D7E
; ---------------------------------------------------------------------------

loc_7D88:
		movea.l	a0,a1
		moveq	#0,d5
		move.w	(Rings).w,d5
		moveq	#32,d0
		cmp.w	d0,d5
		bcs.s	loc_7D98
		move.w	d0,d5

loc_7D98:
		subq.w	#1,d5
		move.w	#$288,d4
		bra.s	loc_7DA8
; ---------------------------------------------------------------------------

loc_7DA0:
		bsr.w	ObjectLoad
		bne.w	loc_7E2C

loc_7DA8:
		move.b	#$37,0(a1)
		addq.b	#2,$24(a1)
		move.b	#8,$16(a1)
		move.b	#8,$17(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.l	#MapRing,4(a1)

loc_7DD2:
		move.w	#$27B2,2(a1)
		move.b	#4,1(a1)
		move.b	#2,$19(a1)
		move.b	#$47,$20(a1)
		move.b	#8,$18(a1)
		move.b	#$FF,(RingLossTimer).w
		tst.w	d4
		bmi.s	loc_7E1C
		move.w	d4,d0
		bsr.w	GetSine
		move.w	d4,d2
		lsr.w	#8,d2
		asl.w	d2,d0
		asl.w	d2,d1
		move.w	d0,d2
		move.w	d1,d3
		addi.b	#$10,d4
		bcc.s	loc_7E1C
		subi.w	#$80,d4
		bcc.s	loc_7E1C
		move.w	#$288,d4

loc_7E1C:
		move.w	d2,$10(a1)
		move.w	d3,$12(a1)
		neg.w	d2
		neg.w	d4
		dbf	d5,loc_7DA0

loc_7E2C:
		move.w	#0,(Rings).w
		move.b	#$80,(ExtraLifeFlags).w
		move.b	#0,(byte_FFFE1B).w
		move.w	#$C6,d0
		jsr	(PlaySFX).l

loc_7E48:
		move.b	(RingLossFrame).w,$1A(a0)
		bsr.w	ObjectMove
		addi.w	#$18,$12(a0)
		bmi.s	loc_7E82
		move.b	(byte_FFFE0F).w,d0
		add.b	d7,d0
		andi.b	#3,d0
		bne.s	loc_7E82
		jsr	sub_105F0
		tst.w	d1
		bpl.s	loc_7E82
		add.w	d1,$C(a0)
		move.w	$12(a0),d0
		asr.w	#2,d0
		sub.w	d0,$12(a0)
		neg.w	$12(a0)

loc_7E82:
		tst.b	(RingLossTimer).w
		beq.s	loc_7EBC
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.s	loc_7EBC
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_7E9A:
		addq.b	#2,$24(a0)
		move.b	#0,$20(a0)
		move.b	#1,$19(a0)
		bsr.w	CollectRing

loc_7EAE:
		lea	(AniRing).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_7EBC:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

Obj4B:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_7ECE(pc,d0.w),d1
		jmp	off_7ECE(pc,d1.w)
; ---------------------------------------------------------------------------

off_7ECE:	dc.w loc_7ED6-off_7ECE, loc_7F12-off_7ECE, loc_7F3C-off_7ECE, loc_7F4C-off_7ECE
; ---------------------------------------------------------------------------

loc_7ED6:
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		lea	2(a2,d0.w),a2
		bclr	#7,(a2)
		addq.b	#2,$24(a0)
		move.l	#Map4B,4(a0)
		move.w	#$24EC,2(a0)
		move.b	#4,1(a0)
		move.b	#2,$19(a0)
		move.b	#$52,$20(a0)
		move.b	#$C,$18(a0)

loc_7F12:
		move.b	(RingFrame).w,$1A(a0)
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

loc_7F3C:
		addq.b	#2,$24(a0)
		move.b	#0,$20(a0)
		move.b	#1,$19(a0)

loc_7F4C:
		move.b	#$4A,(byte_FFD1C0).w
		moveq	#$13,d0
		bsr.w	plcAdd
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------
		include "levels/shared/Ring/Sprite.ani"
		include "levels/shared/Ring/Sprite.map"
		include "unknown/Map4B.map"
		even
; ---------------------------------------------------------------------------

ObjMonitor:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_8054(pc,d0.w),d1
		jmp	off_8054(pc,d1.w)
; ---------------------------------------------------------------------------

off_8054:	dc.w loc_805E-off_8054, loc_80C0-off_8054
		dc.w sub_81D2-off_8054, loc_81A4-off_8054
		dc.w loc_81AE-off_8054
; ---------------------------------------------------------------------------

loc_805E:
		addq.b	#2,$24(a0)
		move.b	#$E,$16(a0)
		move.b	#$E,$17(a0)
		move.l	#MapMonitor,4(a0)
		move.w	#$680,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$F,$18(a0)
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	loc_80B4
		move.b	#8,$24(a0)
		move.b	#$B,$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_80B4:
		move.b	#$46,$20(a0)
		move.b	$28(a0),$1C(a0)

loc_80C0:
		move.b	$25(a0),d0
		beq.s	loc_811A
		subq.b	#2,d0
		bne.s	loc_80FA
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		bsr.w	PtfmCheckExit
		btst	#3,$22(a1)
		bne.w	loc_80EA
		clr.b	$25(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80EA:
		move.w	#$10,d3
		move.w	8(a0),d2
		bsr.w	PtfmSurfaceHeight
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_80FA:
		bsr.w	ObjectFall
		jsr	sub_105F0
		tst.w	d1
		bpl.w	loc_81A4
		add.w	d1,$C(a0)
		clr.w	$12(a0)
		clr.b	$25(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_811A:
		move.w	#$1A,d1
		move.w	#$F,d2
		bsr.w	sub_83B4
		beq.w	loc_818A
		tst.w	$12(a1)
		bmi.s	loc_8138
		cmpi.b	#2,$1C(a1)
		beq.s	loc_818A

loc_8138:
		tst.w	d1
		bpl.s	loc_814E
		sub.w	d3,$C(a1)
		bsr.w	loc_4FD4
		move.b	#2,$25(a0)
		bra.w	loc_81A4
; ---------------------------------------------------------------------------

loc_814E:
		tst.w	d0
		beq.w	loc_8174
		bmi.s	loc_815E
		tst.w	$10(a1)
		bmi.s	loc_8174
		bra.s	loc_8164
; ---------------------------------------------------------------------------

loc_815E:
		tst.w	$10(a1)
		bpl.s	loc_8174

loc_8164:
		sub.w	d0,8(a1)
		move.w	#0,$14(a1)
		move.w	#0,$10(a1)

loc_8174:
		btst	#1,$22(a1)
		bne.s	loc_8198
		bset	#5,$22(a1)
		bset	#5,$22(a0)
		bra.s	loc_81A4
; ---------------------------------------------------------------------------

loc_818A:
		btst	#5,$22(a0)
		beq.s	loc_81A4
		move.w	#1,$1C(a1)

loc_8198:
		bclr	#5,$22(a0)
		bclr	#5,$22(a1)

loc_81A4:
		lea	(AniMonitor).l,a1
		bsr.w	AnimateSprite

loc_81AE:
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

sub_81D2:
		addq.b	#2,$24(a0)
		move.b	#0,$20(a0)
		bsr.w	ObjectLoad
		bne.s	loc_81FA
		move.b	#$2E,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	$1C(a0),$1C(a1)

loc_81FA:
		bsr.w	ObjectLoad
		bne.s	loc_8216
		move.b	#$27,0(a1)
		addq.b	#2,$24(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)

loc_8216:
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#9,$1C(a0)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

ObjMonitorItem:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_8242(pc,d0.w),d1
		jsr	off_8242(pc,d1.w)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

off_8242:	dc.w loc_8248-off_8242, loc_8288-off_8242
		dc.w loc_83AA-off_8242
; ---------------------------------------------------------------------------

loc_8248:
		addq.b	#2,$24(a0)
		move.w	#$680,2(a0)
		move.b	#$24,1(a0)
		move.b	#3,$19(a0)
		move.b	#8,$18(a0)
		move.w	#$FD00,$12(a0)
		moveq	#0,d0
		move.b	$1C(a0),d0
		addq.b	#2,d0
		move.b	d0,$1A(a0)
		movea.l	#MapMonitor,a1
		add.b	d0,d0
		adda.w	(a1,d0.w),a1
		addq.w	#1,a1
		move.l	a1,4(a0)

loc_8288:
		tst.w	$12(a0)
		bpl.w	loc_829C
		bsr.w	ObjectMove
		addi.w	#$18,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_829C:
		addq.b	#2,$24(a0)
		move.w	#$1D,$1E(a0)
		move.b	$1C(a0),d0
		cmpi.b	#1,d0
		bne.s	loc_82B2
		rts
; ---------------------------------------------------------------------------

loc_82B2:
		cmpi.b	#2,d0
		bne.s	loc_82CA

loc_82B8:
		addq.b	#1,(Lives).w
		addq.b	#1,(byte_FFFE1C).w
		move.w	#$88,d0
		jmp	(PlayMusic).l
; ---------------------------------------------------------------------------

loc_82CA:
		cmpi.b	#3,d0
		bne.s	loc_82F8
		move.b	#1,(byte_FFFE2E).w
		move.w	#$4B0,(ObjectsList+$34).w
		move.w	#$C00,(unk_FFF760).w
		move.w	#$18,(unk_FFF762).w
		move.w	#$80,(unk_FFF764).w
		move.w	#$E2,d0
		jmp	(PlayMusic).l
; ---------------------------------------------------------------------------

loc_82F8:
		cmpi.b	#4,d0
		bne.s	loc_8314
		move.b	#1,(byte_FFFE2C).w
		move.b	#$38,(byte_FFD180).w
		move.w	#$AF,d0
		jmp	(PlayMusic).l
; ---------------------------------------------------------------------------

loc_8314:
		cmpi.b	#5,d0
		bne.s	loc_8360
		move.b	#1,(byte_FFFE2D).w
		move.w	#$4B0,(ObjectsList+$32).w
		move.b	#$38,(byte_FFD200).w
		move.b	#1,(byte_FFD200+$1C).w
		move.b	#$38,(byte_FFD240).w
		move.b	#2,(byte_FFD240+$1C).w
		move.b	#$38,(byte_FFD280).w
		move.b	#3,(byte_FFD280+$1C).w
		move.b	#$38,(byte_FFD2C0).w
		move.b	#4,(byte_FFD2C0+$1C).w
		move.w	#$87,d0
		jmp	(PlayMusic).l
; ---------------------------------------------------------------------------

loc_8360:
		cmpi.b	#6,d0
		bne.s	loc_83A0
		addi.w	#$A,(Rings).w
		ori.b	#1,(ExtraLifeFlags).w
		cmpi.w	#$32,(Rings).w
		bcs.s	loc_8396
		bset	#0,(byte_FFFE1B).w
		beq.w	loc_82B8
		cmpi.w	#$64,(Rings).w
		bcs.s	loc_8396
		bset	#1,(byte_FFFE1B).w
		beq.w	loc_82B8

loc_8396:
		move.w	#$B5,d0
		jmp	(PlayMusic).l
; ---------------------------------------------------------------------------

loc_83A0:
		cmpi.b	#7,d0
		bne.s	locret_83A8
		nop

locret_83A8:
		rts
; ---------------------------------------------------------------------------

loc_83AA:
		subq.w	#1,$1E(a0)
		bmi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

sub_83B4:
		tst.w	(DebugRoutine).w
		bne.w	loc_8400
		lea	(ObjectsList).w,a1
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.s	loc_8400
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_8400
		move.b	$16(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	$C(a1),d3
		sub.w	$C(a0),d3
		add.w	d2,d3
		bmi.s	loc_8400
		add.w	d2,d2
		cmp.w	d2,d3
		bcc.s	loc_8400
		cmp.w	d0,d1
		bcc.s	loc_83F6
		add.w	d1,d1
		sub.w	d1,d0

loc_83F6:
		cmpi.w	#$10,d3
		bcs.s	loc_8404

loc_83FC:
		moveq	#1,d1
		rts
; ---------------------------------------------------------------------------

loc_8400:
		moveq	#0,d1
		rts
; ---------------------------------------------------------------------------

loc_8404:
		moveq	#0,d1
		move.b	$18(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	8(a1),d1
		sub.w	8(a0),d1
		bmi.s	loc_83FC
		cmp.w	d2,d1
		bcc.s	loc_83FC
		moveq	#-1,d1
		rts
; ---------------------------------------------------------------------------
		include "levels/shared/Monitor/Sprite.ani"
		include "levels/shared/Monitor/Sprite.map"
		even
; ---------------------------------------------------------------------------

RunObjects:
		lea	(ObjectsList).w,a0
		moveq	#$7F,d7
		moveq	#0,d0
		cmpi.b	#6,(ObjectsList+$24).w
		bcc.s	loc_8560
; ---------------------------------------------------------------------------

sub_8546:
		move.b	(a0),d0
		beq.s	loc_8556
		add.w	d0,d0
		add.w	d0,d0
		movea.l	loc_857A+2(pc,d0.w),a1
		jsr	(a1)
		moveq	#0,d0

loc_8556:
		lea	$40(a0),a0
		dbf	d7,sub_8546
		rts
; ---------------------------------------------------------------------------

loc_8560:
		moveq	#$1F,d7
		bsr.s	sub_8546
		moveq	#$5F,d7

loc_8566:
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	loc_8576
		tst.b	1(a0)
		bpl.s	loc_8576
		bsr.w	ObjectDisplay

loc_8576:
		lea	$40(a0),a0

loc_857A:
		dbf	d7,loc_8566
		rts
; ---------------------------------------------------------------------------

AllObjects:	dc.l ObjSonic, Obj02, Obj03, Obj04, Obj05, Ojb06, Obj07
		dc.l ObjectFall, ObjSonicSpecial, ObjectFall, ObjectFall
		dc.l ObjectFall, ObjSignpost, ObjTitleSonic, OibjTitleText
		dc.l ObjAniTest, ObjBridge, ObjSceneryLamp, ObjLavaMaker
		dc.l ObjLavaball, ObjSwingPtfm, ObjectFall, ObjSpikeLogs
		dc.l ObjPlatform, ObjRollingBall, ObjCollapsePtfm, Obj1B
		dc.l ObjScenery, ObjUnkSwitch, ObjBallhog, ObjCrabmeat
		dc.l ObjCannonball, ObjHUD, ObjBuzzbomber, ObjBuzzMissile
		dc.l ObjCannonballExplode, ObjRing, ObjMonitor, ObjExplode
		dc.l ObjAnimals, ObjPoints, Obj2A, ObjChopper, ObjJaws
		dc.l ObjBurrobot, ObjMonitorItem, ObjMZPlatforms, ObjGlassBlock
		dc.l ObjChainPtfm, ObjSwitch, ObjPushBlock, ObjTitleCard
		dc.l ObjFloorLavaball, ObjSpikes, ObjRingLoss, ObjShield
		dc.l ObjGameOver, ObjLevelResults, ObjPurpleRock, ObjSmashWall
		dc.l ObjGHZBoss, ObjCapsule, ObjBombExplode, ObjMotobug
		dc.l ObjSpring, ObjNewtron, ObjRoller, ObjWall, Obj45
		dc.l ObjMZBlocks, ObjBumper, ObjGHZBossBall, ObjWaterfallSnd
		dc.l ObjEntryRingBeta, Obj4B, ObjLavafallMalker, ObjLavafall
		dc.l ObjLavaChase, Obj4F, ObjYardin, ObjSmashBlock, ObjMovingPtfm
		dc.l ObjCollapseFloor, ObjLavaHurt, ObjBasaran, ObjMovingBlocks
		dc.l ObjSpikedBalls, ObjGiantSpikedBalls, ObjSLZMovingPtfm
		dc.l ObjCirclePtfm, ObjStaircasePtfm, ObjSLZGirder, ObjFan
		dc.l ObjSeeSaw
; ---------------------------------------------------------------------------

ObjectFall:
		move.l	8(a0),d2
		move.l	$C(a0),d3
		move.w	$10(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	$12(a0),d0
		addi.w	#$38,d0
		move.w	d0,$12(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,8(a0)
		move.l	d3,$C(a0)
		rts
; ---------------------------------------------------------------------------

ObjectMove:
		move.l	8(a0),d2
		move.l	$C(a0),d3
		move.w	$10(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	$12(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,8(a0)
		move.l	d3,$C(a0)
		rts
; ---------------------------------------------------------------------------

ObjectDisplay:
		lea	(DisplayLists).w,a1
		move.b	$19(a0),d0
		andi.w	#7,d0
		lsl.w	#7,d0
		adda.w	d0,a1
		cmpi.w	#$7E,(a1)
		bcc.s	locret_8768
		addq.w	#2,(a1)
		adda.w	(a1),a1
		move.w	a0,(a1)

locret_8768:
		rts
; ---------------------------------------------------------------------------

ObjectDisplayA1:
		lea	(DisplayLists).w,a2
		move.b	$19(a1),d0
		andi.w	#7,d0
		lsl.w	#7,d0
		adda.w	d0,a2
		cmpi.w	#$7E,(a2)
		bcc.s	locret_8786
		addq.w	#2,(a2)
		adda.w	(a2),a2
		move.w	a1,(a2)

locret_8786:
		rts
; ---------------------------------------------------------------------------

ObjectDelete:
		movea.l	a0,a1

ObjectDeleteA1:
		moveq	#0,d1
		moveq	#$F,d0

@clear:
		move.l	d1,(a1)+
		dbf	d0,@clear
		rts
; ---------------------------------------------------------------------------

off_8796:	dc.l 0, (CameraX)&$FFFFFF, (unk_FFF708)&$FFFFFF, (unk_FFF718)&$FFFFFF
; ---------------------------------------------------------------------------

ProcessMaps:
		lea	(byte_FFF800).w,a2
		moveq	#0,d5
		lea	(DisplayLists).w,a4
		moveq	#7,d7

loc_87B2:
		tst.w	(a4)
		beq.w	loc_8876
		moveq	#2,d6

loc_87BA:
		movea.w	(a4,d6.w),a0
		tst.b	(a0)
		beq.w	loc_886E
		bclr	#7,1(a0)
		move.b	1(a0),d0
		move.b	d0,d4
		andi.w	#$C,d0
		beq.s	loc_8826
		movea.l	off_8796(pc,d0.w),a1
		moveq	#0,d0
		move.b	$18(a0),d0
		move.w	8(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_886E
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.s	loc_886E
		addi.w	#$80,d3
		btst	#4,d4
		beq.s	loc_8830
		moveq	#0,d0
		move.b	$16(a0),d0
		move.w	$C(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	loc_886E
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#$E0,d1
		bge.s	loc_886E
		addi.w	#$80,d2
		bra.s	loc_8848
; ---------------------------------------------------------------------------

loc_8826:
		move.w	$A(a0),d2
		move.w	8(a0),d3
		bra.s	loc_8848
; ---------------------------------------------------------------------------

loc_8830:
		move.w	$C(a0),d2
		sub.w	4(a1),d2
		addi.w	#$80,d2
		cmpi.w	#$60,d2
		bcs.s	loc_886E
		cmpi.w	#$180,d2
		bcc.s	loc_886E

loc_8848:
		movea.l	4(a0),a1
		moveq	#0,d1
		btst	#5,d4
		bne.s	loc_8864
		move.b	$1A(a0),d1
		add.b	d1,d1
		adda.w	(a1,d1.w),a1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_8868

loc_8864:
		bsr.w	sub_8898

loc_8868:
		bset	#7,1(a0)

loc_886E:
		addq.w	#2,d6
		subq.w	#2,(a4)
		bne.w	loc_87BA

loc_8876:
		lea	$80(a4),a4
		dbf	d7,loc_87B2
		move.b	d5,(byte_FFF62C).w
		cmpi.b	#$50,d5
		beq.s	loc_8890
		move.l	#0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_8890:
		move.b	#0,-5(a2)
		rts
; ---------------------------------------------------------------------------

sub_8898:
		movea.w	2(a0),a3
		btst	#0,d4
		bne.s	loc_88DE
		btst	#1,d4
		bne.w	loc_892C
; ---------------------------------------------------------------------------

sub_88AA:
		cmpi.b	#$50,d5
		beq.s	locret_88DC
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_88D6
		addq.w	#1,d0

loc_88D6:
		move.w	d0,(a2)+
		dbf	d1,sub_88AA

locret_88DC:
		rts
; ---------------------------------------------------------------------------

loc_88DE:
		btst	#1,d4
		bne.w	loc_8972

loc_88E6:
		cmpi.b	#$50,d5
		beq.s	locret_892A
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$800,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_8924
		addq.w	#1,d0

loc_8924:
		move.w	d0,(a2)+
		dbf	d1,loc_88E6

locret_892A:
		rts
; ---------------------------------------------------------------------------

loc_892C:
		cmpi.b	#$50,d5
		beq.s	locret_8970
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_896A
		addq.w	#1,d0

loc_896A:
		move.w	d0,(a2)+
		dbf	d1,loc_892C

locret_8970:
		rts
; ---------------------------------------------------------------------------

loc_8972:
		cmpi.b	#$50,d5
		beq.s	locret_89C4
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_89BE
		addq.w	#1,d0

loc_89BE:
		move.w	d0,(a2)+
		dbf	d1,loc_8972

locret_89C4:
		rts
; ---------------------------------------------------------------------------

sub_89C6:
		move.w	8(a0),d0
		sub.w	(CameraX).w,d0
		bmi.s	loc_89EA
		cmpi.w	#$140,d0
		bge.s	loc_89EA
		move.w	$C(a0),d1
		sub.w	(CameraY).w,d1
		bmi.s	loc_89EA
		cmpi.w	#$E0,d1
		bge.s	loc_89EA
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_89EA:
		moveq	#1,d0
		rts
; ---------------------------------------------------------------------------

LoadObjects:
		moveq	#0,d0
		move.b	(unk_FFF76C).w,d0
		move.w	off_89FC(pc,d0.w),d0
		jmp	off_89FC(pc,d0.w)
; ---------------------------------------------------------------------------

off_89FC:	dc.w loc_8A00-off_89FC, loc_8A44-off_89FC
; ---------------------------------------------------------------------------

loc_8A00:
		addq.b	#2,(unk_FFF76C).w
		move.w	(level).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(ObjectListArray).l,a0
		movea.l	a0,a1
		adda.w	(a0,d0.w),a0
		move.l	a0,(unk_FFF770).w
		move.l	a0,(unk_FFF774).w
		adda.w	2(a1,d0.w),a1
		move.l	a1,(unk_FFF778).w
		move.l	a1,(unk_FFF77C).w
		lea	(byte_FFFC00).w,a2
		move.w	#$101,(a2)+
		move.w	#$5E,d0

loc_8A38:
		clr.l	(a2)+
		dbf	d0,loc_8A38
		move.w	#$FFFF,(unk_FFF76E).w

loc_8A44:
		lea	(byte_FFFC00).w,a2
		moveq	#0,d2
		move.w	(CameraX).w,d6
		andi.w	#$FF80,d6
		cmp.w	(unk_FFF76E).w,d6
		beq.w	locret_8B20
		bge.s	loc_8ABA
		move.w	d6,(unk_FFF76E).w
		movea.l	(unk_FFF774).w,a0
		subi.w	#$80,d6
		bcs.s	loc_8A96

loc_8A6A:
		cmp.w	-6(a0),d6
		bge.s	loc_8A96
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.s	loc_8A80
		subq.b	#1,1(a2)
		move.b	1(a2),d2

loc_8A80:
		bsr.w	sub_8B22
		bne.s	loc_8A8A
		subq.w	#6,a0
		bra.s	loc_8A6A
; ---------------------------------------------------------------------------

loc_8A8A:
		tst.b	4(a0)
		bpl.s	loc_8A94
		addq.b	#1,1(a2)

loc_8A94:
		addq.w	#6,a0

loc_8A96:
		move.l	a0,(unk_FFF774).w
		movea.l	(unk_FFF770).w,a0
		addi.w	#$300,d6

loc_8AA2:
		cmp.w	-6(a0),d6
		bgt.s	loc_8AB4
		tst.b	-2(a0)
		bpl.s	loc_8AB0
		subq.b	#1,(a2)

loc_8AB0:
		subq.w	#6,a0
		bra.s	loc_8AA2
; ---------------------------------------------------------------------------

loc_8AB4:
		move.l	a0,(unk_FFF770).w
		rts
; ---------------------------------------------------------------------------

loc_8ABA:
		move.w	d6,(unk_FFF76E).w
		movea.l	(unk_FFF770).w,a0
		addi.w	#$280,d6

loc_8AC6:
		cmp.w	(a0),d6
		bls.s	loc_8ADA
		tst.b	4(a0)
		bpl.s	loc_8AD4
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_8AD4:
		bsr.w	sub_8B22
		beq.s	loc_8AC6

loc_8ADA:
		move.l	a0,(unk_FFF770).w
		movea.l	(unk_FFF774).w,a0
		subi.w	#$300,d6
		bcs.s	loc_8AFA

loc_8AE8:
		cmp.w	(a0),d6
		bls.s	loc_8AFA
		tst.b	4(a0)
		bpl.s	loc_8AF6
		addq.b	#1,1(a2)

loc_8AF6:
		addq.w	#6,a0
		bra.s	loc_8AE8
; ---------------------------------------------------------------------------

loc_8AFA:
		move.l	a0,(unk_FFF774).w
		rts
; ---------------------------------------------------------------------------

loc_8B00:
		movea.l	(unk_FFF778).w,a0
		move.w	(unk_FFF718).w,d0
		addi.w	#$200,d0
		andi.w	#$FF80,d0
		cmp.w	(a0),d0
		bcs.s	locret_8B20
		bsr.w	sub_8B22
		move.l	a0,(unk_FFF778).w
		bra.w	loc_8B00
; ---------------------------------------------------------------------------

locret_8B20:
		rts
; ---------------------------------------------------------------------------

sub_8B22:
		tst.b	4(a0)
		bpl.s	loc_8B36
		bset	#7,2(a2,d2.w)
		beq.s	loc_8B36
		addq.w	#6,a0
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_8B36:
		bsr.w	ObjectLoad
		bne.s	locret_8B70
		move.w	(a0)+,8(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		move.w	d0,$C(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,1(a1)
		move.b	d1,$22(a1)
		move.b	(a0)+,d0
		bpl.s	loc_8B66
		andi.b	#$7F,d0
		move.b	d2,$23(a1)

loc_8B66:
		move.b	d0,0(a1)
		move.b	(a0)+,$28(a1)
		moveq	#0,d0

locret_8B70:
		rts
; ---------------------------------------------------------------------------

ObjectLoad:
		lea	(LevelObjectsList).w,a1
		move.w	#$5F,d0

loc_8B7A:
		tst.b	(a1)
		beq.s	locret_8B86
		lea	$40(a1),a1
		dbf	d0,loc_8B7A

locret_8B86:
		rts
; ---------------------------------------------------------------------------

LoadNextObject:
		movea.l	a0,a1
		move.w	#$F000,d0
		sub.w	a0,d0
		lsr.w	#6,d0
		subq.w	#1,d0
		bcs.s	locret_8BA2

loc_8B96:
		tst.b	(a1)
		beq.s	locret_8BA2
		lea	$40(a1),a1
		dbf	d0,loc_8B96

locret_8BA2:
		rts
; ---------------------------------------------------------------------------

ObjChopper:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_8BB6(pc,d0.w),d1
		jsr	off_8BB6(pc,d1.w)
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_8BB6:	dc.w loc_8BBA-off_8BB6, loc_8BF0-off_8BB6
; ---------------------------------------------------------------------------

loc_8BBA:
		addq.b	#2,$24(a0)
		move.l	#MapChopper,4(a0)
		move.w	#$47B,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#9,$20(a0)
		move.b	#$10,$18(a0)
		move.w	#$F900,$12(a0)
		move.w	$C(a0),$30(a0)

loc_8BF0:
		lea	(AniChopper).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectMove
		addi.w	#$18,$12(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		bcc.s	loc_8C18
		move.w	d0,$C(a0)
		move.w	#$F900,$12(a0)

loc_8C18:
		move.b	#1,$1C(a0)
		subi.w	#$C0,d0
		cmp.w	$C(a0),d0
		bcc.s	locret_8C3A
		move.b	#0,$1C(a0)
		tst.w	$12(a0)
		bmi.s	locret_8C3A
		move.b	#2,$1C(a0)

locret_8C3A:
		rts
; ---------------------------------------------------------------------------
		include "levels/GHZ/Chopper/Sprite.ani"
		even
		include "levels/GHZ/Chopper/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjJaws:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_8C70(pc,d0.w),d1
		jsr	off_8C70(pc,d1.w)
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_8C70:	dc.w loc_8C74-off_8C70, loc_8CA4-off_8C70
; ---------------------------------------------------------------------------

loc_8C74:
		addq.b	#2,$24(a0)
		move.l	#MapJaws,4(a0)
		move.w	#$47B,2(a0)
		move.b	#4,1(a0)
		move.b	#$A,$20(a0)
		move.b	#4,$19(a0)
		move.b	#$10,$18(a0)
		move.w	#$FFC0,$10(a0)

loc_8CA4:
		lea	(AniJaws).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectMove
; ---------------------------------------------------------------------------
		include "levels/LZ/Jaws/Sprite.ani"
		include "levels/LZ/Jaws/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjBurrobot:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_8CFC(pc,d0.w),d1
		jmp	off_8CFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_8CFC:	dc.w loc_8D02-off_8CFC, loc_8D56-off_8CFC, loc_8E46-off_8CFC
; ---------------------------------------------------------------------------

loc_8D02:
		move.b	#$13,$16(a0)
		move.b	#8,$17(a0)
		move.l	#MapBurrobot,4(a0)
		move.w	#$239C,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#5,$20(a0)
		move.b	#$C,$18(a0)
		bset	#0,$22(a0)
		bsr.w	ObjectFall
		bsr.w	sub_105F0
		tst.w	d1
		bpl.s	locret_8D54
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)

locret_8D54:
		rts
; ---------------------------------------------------------------------------

loc_8D56:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_8D72(pc,d0.w),d1
		jsr	off_8D72(pc,d1.w)
		lea	(AniBurrobot).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_8D72:	dc.w loc_8D78-off_8D72, loc_8DA2-off_8D72, loc_8E10-off_8D72
; ---------------------------------------------------------------------------

loc_8D78:
		subq.w	#1,$30(a0)
		bpl.s	locret_8DA0
		addq.b	#2,$25(a0)
		move.w	#$FF,$30(a0)
		move.w	#$80,$10(a0)
		move.b	#1,$1C(a0)
		bchg	#0,$22(a0)
		beq.s	locret_8DA0
		neg.w	$10(a0)

locret_8DA0:
		rts
; ---------------------------------------------------------------------------

loc_8DA2:
		subq.w	#1,$30(a0)
		bmi.s	loc_8DDE
		bsr.w	ObjectMove
		bchg	#0,$32(a0)
		bne.s	loc_8DD4
		move.w	8(a0),d3
		addi.w	#$C,d3
		btst	#0,$22(a0)
		bne.s	loc_8DC8
		subi.w	#$18,d3

loc_8DC8:
		bsr.w	loc_105F4
		cmpi.w	#$C,d1
		bge.s	loc_8DDE
		rts
; ---------------------------------------------------------------------------

loc_8DD4:
		bsr.w	sub_105F0
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_8DDE:
		btst	#2,(byte_FFFE0F).w
		beq.s	loc_8DFE
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_8DFE:
		addq.b	#2,$25(a0)
		move.w	#$FC00,$12(a0)
		move.b	#2,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_8E10:
		bsr.w	ObjectMove
		addi.w	#$18,$12(a0)
		bmi.s	locret_8E44
		move.b	#3,$1C(a0)
		bsr.w	sub_105F0
		tst.w	d1
		bpl.s	locret_8E44
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		move.b	#1,$1C(a0)
		move.w	#$FF,$30(a0)
		subq.b	#2,$25(a0)

locret_8E44:
		rts
; ---------------------------------------------------------------------------

loc_8E46:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
		include "levels/LZ/Burrobot/Sprite.ani"
		even
		include "levels/LZ/Burrobot/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjMZPlatforms:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_8ECE(pc,d0.w),d1
		jmp	off_8ECE(pc,d1.w)
; ---------------------------------------------------------------------------

off_8ECE:	dc.w loc_8EDE-off_8ECE, loc_8F3C-off_8ECE

off_8ED2:	dc.w ObjMZPlatforms_Slope1-off_8ED2
		dc.b 0, $40
		dc.w ObjMZPlatforms_Slope3-off_8ED2
		dc.b 1, $40
		dc.w ObjMZPlatforms_Slope2-off_8ED2
		dc.b 2, $20
; ---------------------------------------------------------------------------

loc_8EDE:
		addq.b	#2,$24(a0)
		move.l	#MapMZPlatforms,4(a0)
		move.w	#$C000,2(a0)
		move.b	#4,1(a0)
		move.b	#5,$19(a0)
		move.w	$C(a0),$2C(a0)
		move.w	8(a0),$2A(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#2,d0

loc_8F10:
		andi.w	#$1C,d0
		lea	off_8ED2(pc,d0.w),a1
		move.w	(a1)+,d0
		lea	off_8ED2(pc,d0.w),a2
		move.l	a2,$30(a0)
		move.b	(a1)+,$1A(a0)
		move.b	(a1),$18(a0)
		andi.b	#$F,$28(a0)
		move.b	#$40,$16(a0)
		bset	#4,1(a0)

loc_8F3C:
		bsr.w	sub_8FA6
		tst.b	$25(a0)
		beq.s	loc_8F7C
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		bsr.w	PtfmCheckExit
		btst	#3,$22(a1)
		bne.w	loc_8F64
		clr.b	$25(a0)
		bra.s	loc_8F9E
; ---------------------------------------------------------------------------

loc_8F64:
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		movea.l	$30(a0),a2
		move.w	8(a0),d2
		bsr.w	sub_61E0
		bra.s	loc_8F9E
; ---------------------------------------------------------------------------

loc_8F7C:
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		move.w	#$20,d2
		cmpi.b	#2,$1A(a0)
		bne.s	loc_8F96
		move.w	#$30,d2

loc_8F96:
		movea.l	$30(a0),a2
		bsr.w	loc_A30C

loc_8F9E:
		bsr.w	ObjectDisplay
		bra.w	loc_90C2
; ---------------------------------------------------------------------------

sub_8FA6:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_8FBA(pc,d0.w),d1
		jmp	off_8FBA(pc,d1.w)
; ---------------------------------------------------------------------------

off_8FBA:	dc.w locret_8FC6-off_8FBA, loc_8FC8-off_8FBA, loc_8FD2-off_8FBA, loc_8FDC-off_8FBA, loc_8FE6-off_8FBA
		dc.w loc_9006-off_8FBA
; ---------------------------------------------------------------------------

locret_8FC6:
		rts
; ---------------------------------------------------------------------------

loc_8FC8:
		move.b	(oscValues+2).w,d0
		move.w	#$20,d1
		bra.s	loc_8FEE
; ---------------------------------------------------------------------------

loc_8FD2:
		move.b	(oscValues+6).w,d0
		move.w	#$30,d1
		bra.s	loc_8FEE
; ---------------------------------------------------------------------------

loc_8FDC:
		move.b	(oscValues+$A).w,d0
		move.w	#$40,d1
		bra.s	loc_8FEE
; ---------------------------------------------------------------------------

loc_8FE6:
		move.b	(oscValues+$E).w,d0
		move.w	#$60,d1

loc_8FEE:
		btst	#3,$28(a0)
		beq.s	loc_8FFA
		neg.w	d0
		add.w	d1,d0

loc_8FFA:
		move.w	$2C(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_9006:
		move.b	$34(a0),d0
		tst.b	$25(a0)
		bne.s	loc_9018
		subq.b	#2,d0
		bcc.s	loc_9024
		moveq	#0,d0
		bra.s	loc_9024
; ---------------------------------------------------------------------------

loc_9018:
		addq.b	#4,d0
		cmpi.b	#$40,d0
		bcs.s	loc_9024
		move.b	#$40,d0

loc_9024:
		move.b	d0,$34(a0)
		jsr	(GetSine).l
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	$2C(a0),d0
		move.w	d0,$C(a0)
		cmpi.b	#$20,$34(a0)
		bne.s	loc_9082
		tst.b	$35(a0)
		bne.s	loc_9082
		move.b	#1,$35(a0)
		bsr.w	LoadNextObject
		bne.s	loc_9082
		move.b	#$35,0(a1)
		move.w	8(a0),8(a1)
		move.w	$2C(a0),$2C(a1)
		addq.w	#8,$2C(a1)
		subq.w	#3,$2C(a1)
		subi.w	#$40,8(a1)
		move.l	$30(a0),$30(a1)
		move.l	a0,$38(a1)
		movea.l	a0,a2
		bsr.s	sub_90A4

loc_9082:
		moveq	#0,d2
		lea	$36(a0),a2
		move.b	(a2)+,d2
		subq.b	#1,d2
		bcs.s	locret_90A2

loc_908E:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.w	#-$3000,d0
		movea.w	d0,a1
		move.w	d1,$3C(a1)
		dbf	d2,loc_908E

locret_90A2:
		rts
; ---------------------------------------------------------------------------

sub_90A4:
		lea	$36(a2),a2
		moveq	#0,d0
		move.b	(a2),d0
		addq.b	#1,(a2)
		lea	1(a2,d0.w),a2
		move.w	a1,d0
		subi.w	#$D000,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0
		move.b	d0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_90C2:
		tst.b	$35(a0)
		beq.s	loc_90CE
		tst.b	1(a0)
		bpl.s	loc_90EE

loc_90CE:
		move.w	$2A(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

loc_90EE:
		moveq	#0,d2

loc_90F0:
		lea	$36(a0),a2
		move.b	(a2),d2
		clr.b	(a2)+
		subq.b	#1,d2
		bcs.s	locret_911E

loc_90FC:
		moveq	#0,d0
		move.b	(a2),d0
		clr.b	(a2)+
		lsl.w	#6,d0
		addi.w	#-$3000,d0
		movea.w	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,loc_90FC
		move.b	#0,$35(a0)

loc_9118:
		move.b	#0,$34(a0)

locret_911E:
		rts
; ---------------------------------------------------------------------------

ObjMZPlatforms_Slope1:dc.b $20, $20, $20, $20, $20
		dc.b $20, $20, $20, $20, $20
		dc.b $20, $20, $20, $20, $21
		dc.b $22, $23, $24, $25, $26
		dc.b $27, $28, $29, $2A, $2B
		dc.b $2C, $2D, $2E, $2F, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $2F, $2E, $2D
		dc.b $2C, $2B, $2A, $29, $28
		dc.b $27, $26, $25, $24, $23
		dc.b $22, $21, $20, $20, $20
		dc.b $20, $20, $20, $20, $20
		dc.b $20, $20, $20, $20, $20
		dc.b $20

ObjMZPlatforms_Slope2:dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30, $30
		dc.b $30, $30, $30, $30

ObjMZPlatforms_Slope3:dc.b $20, $20, $20, $20, $20
		dc.b $20, $21, $22, $23, $24
		dc.b $25, $26, $27, $28, $29
		dc.b $2A, $2B, $2C, $2D, $2E
		dc.b $2F, $30, $31, $32, $33
		dc.b $34, $35, $36, $37, $38
		dc.b $39, $3A, $3B, $3C, $3D
		dc.b $3E, $3F, $40, $40, $40
		dc.b $40, $40, $40, $40, $40
		dc.b $40, $40, $40, $40, $40
		dc.b $40, $40, $40, $40, $40
		dc.b $3F, $3E, $3D, $3C, $3B
		dc.b $3A, $39, $38, $37, $36
		dc.b $35, $34, $33, $32, $31
		dc.b $30, $30, $30, $30, $30
		dc.b $30
; ---------------------------------------------------------------------------

ObjFloorLavaball:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_91F2(pc,d0.w),d1
		jmp	off_91F2(pc,d1.w)
; ---------------------------------------------------------------------------

off_91F2:	dc.w loc_91F8-off_91F2, loc_9240-off_91F2, loc_92BA-off_91F2
; ---------------------------------------------------------------------------

loc_91F8:
		addq.b	#2,$24(a0)
		move.l	#MapLavaball,4(a0)
		move.w	#$345,2(a0)
		move.w	8(a0),$2A(a0)
		move.b	#4,1(a0)
		move.b	#1,$19(a0)
		move.b	#$8B,$20(a0)
		move.b	#8,$18(a0)
		move.w	#$C8,d0
		jsr	(PlaySFX).l
		tst.b	$28(a0)
		beq.s	loc_9240
		addq.b	#2,$24(a0)
		bra.w	loc_92BA
; ---------------------------------------------------------------------------

loc_9240:
		movea.l	$30(a0),a1
		move.w	8(a0),d1
		sub.w	$2A(a0),d1
		addi.w	#$C,d1
		move.w	d1,d0
		lsr.w	#1,d0
		move.b	(a1,d0.w),d0
		neg.w	d0
		add.w	$2C(a0),d0
		move.w	d0,d2
		add.w	$3C(a0),d0
		move.w	d0,$C(a0)
		cmpi.w	#$84,d1
		bcc.s	loc_92B8
		addi.l	#$10000,8(a0)
		cmpi.w	#$80,d1
		bcc.s	loc_92B8
		move.l	8(a0),d0
		addi.l	#$80000,d0
		andi.l	#$FFFFF,d0
		bne.s	loc_92B8
		bsr.w	LoadNextObject
		bne.s	loc_92B8
		move.b	#$35,0(a1)
		move.w	8(a0),8(a1)
		move.w	d2,$2C(a1)
		move.w	$3C(a0),$3C(a1)
		move.b	#1,$28(a1)
		movea.l	$38(a0),a2
		bsr.w	sub_90A4

loc_92B8:
		bra.s	loc_92C6
; ---------------------------------------------------------------------------

loc_92BA:
		move.w	$2C(a0),d0
		add.w	$3C(a0),d0
		move.w	d0,$C(a0)

loc_92C6:
		lea	(AniFloorLavaball).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------
		include "levels/MZ/FloorLavaball/Sprite.ani"
		include "levels/MZ/Platform/Sprite.map"
		include "levels/MZ/FloorLavaball/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjGlassBlock:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_93DE(pc,d0.w),d1
		jsr	off_93DE(pc,d1.w)
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	loc_93D8
		rts
; ---------------------------------------------------------------------------

loc_93D8:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

off_93DE:	dc.w loc_93FA-off_93DE, loc_9498-off_93DE, loc_94B0-off_93DE, loc_94CA-off_93DE, loc_94D8-off_93DE
		dc.w loc_9500-off_93DE

byte_93EA:	dc.b 2, 4, 0
		dc.b 4, $48, 1
		dc.b 6, 4, 2
		even

byte_93F4:	dc.b 8, 0, 3
		dc.b $A, 0, 2
; ---------------------------------------------------------------------------

loc_93FA:
		lea	(byte_93EA).l,a2
		moveq	#2,d1
		cmpi.b	#3,$28(a0)
		bcs.s	loc_9412
		lea	(byte_93F4).l,a2
		moveq	#1,d1

loc_9412:
		movea.l	a0,a1
		bra.s	loc_941C
; ---------------------------------------------------------------------------

loc_9416:
		bsr.w	LoadNextObject
		bne.s	loc_9486

loc_941C:
		move.b	(a2)+,$24(a1)
		move.b	#$30,0(a1)
		move.w	8(a0),8(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	$C(a0),d0
		move.w	d0,$C(a1)
		move.l	#MapGlassBlock,4(a1)
		move.w	#$C38E,2(a1)
		move.b	#4,1(a1)
		move.w	$C(a1),$30(a1)
		move.b	$28(a0),$28(a1)
		move.b	#$20,$18(a1)
		move.b	#4,$19(a1)
		move.b	(a2)+,$1A(a1)
		move.l	a0,$3C(a1)
		dbf	d1,loc_9416
		move.b	#$10,$18(a1)
		move.b	#3,$19(a1)
		addq.b	#8,$28(a1)
		andi.b	#$F,$28(a1)

loc_9486:
		move.w	#$90,$32(a0)
		move.b	#$38,$16(a0)
		bset	#4,1(a0)

loc_9498:
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$24,d2
		move.w	#$24,d3
		move.w	8(a0),d4
		bra.w	sub_A2BC
; ---------------------------------------------------------------------------

loc_94B0:
		movea.l	$3C(a0),a1
		move.w	$32(a1),$32(a0)
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$24,d2
		bra.w	sub_6936
; ---------------------------------------------------------------------------

loc_94CA:
		movea.l	$3C(a0),a1
		move.w	$32(a1),$32(a0)
		bra.w	sub_9514
; ---------------------------------------------------------------------------

loc_94D8:
		bsr.w	sub_9514
		move.w	#$2B,d1
		move.w	#$38,d2
		move.w	#$38,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		cmpi.b	#8,$24(a0)
		beq.s	locret_94FE
		move.b	#8,$24(a0)

locret_94FE:
		rts
; ---------------------------------------------------------------------------

loc_9500:
		movea.l	$3C(a0),a1
		move.w	$32(a1),$32(a0)
		move.w	$C(a1),$30(a0)
		bra.w	*+4
; ---------------------------------------------------------------------------

sub_9514:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_9528(pc,d0.w),d1
		jmp	off_9528(pc,d1.w)
; ---------------------------------------------------------------------------

off_9528:	dc.w locret_9532-off_9528, loc_9534-off_9528, loc_9540-off_9528
		dc.w loc_9550-off_9528, loc_95D6-off_9528
; ---------------------------------------------------------------------------

locret_9532:
		rts
; ---------------------------------------------------------------------------

loc_9534:
		move.b	(oscValues+$12).w,d0
		move.w	#$40,d1
		bra.w	loc_9616
; ---------------------------------------------------------------------------

loc_9540:
		move.b	(oscValues+$12).w,d0
		move.w	#$40,d1
		neg.w	d0
		add.w	d1,d0
		bra.w	loc_9616
; ---------------------------------------------------------------------------

loc_9550:
		btst	#3,$28(a0)
		beq.s	loc_9564
		move.b	(oscValues+$12).w,d0
		subi.w	#$10,d0
		bra.w	loc_9624
; ---------------------------------------------------------------------------

loc_9564:
		btst	#3,$22(a0)
		bne.s	loc_9574
		bclr	#0,$34(a0)
		bra.s	loc_95A8
; ---------------------------------------------------------------------------

loc_9574:
		tst.b	$34(a0)
		bne.s	loc_95A8
		move.b	#1,$34(a0)
		bset	#0,$35(a0)
		beq.s	loc_95A8
		bset	#7,$34(a0)
		move.w	#$10,$36(a0)
		move.b	#$A,$38(a0)
		cmpi.w	#$40,$32(a0)
		bne.s	loc_95A8
		move.w	#$40,$36(a0)

loc_95A8:
		tst.b	$34(a0)
		bpl.s	loc_95D0
		tst.b	$38(a0)
		beq.s	loc_95BA
		subq.b	#1,$38(a0)
		bne.s	loc_95D0

loc_95BA:
		tst.w	$32(a0)
		beq.s	loc_95CA
		subq.w	#1,$32(a0)
		subq.w	#1,$36(a0)
		bne.s	loc_95D0

loc_95CA:
		bclr	#7,$34(a0)

loc_95D0:
		move.w	$32(a0),d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_95D6:
		btst	#3,$28(a0)
		beq.s	loc_95E8
		move.b	(oscValues+$12).w,d0
		subi.w	#$10,d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_95E8:
		tst.b	$34(a0)
		bne.s	loc_9606
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#4,d0
		tst.b	(a2,d0.w)
		beq.s	loc_9610
		move.b	#1,$34(a0)

loc_9606:
		tst.w	$32(a0)
		beq.s	loc_9610
		subq.w	#2,$32(a0)

loc_9610:
		move.w	$32(a0),d0
		bra.s	loc_9624
; ---------------------------------------------------------------------------

loc_9616:
		btst	#3,$28(a0)
		beq.s	loc_9624
		neg.w	d0
		add.w	d1,d0
		lsr.b	#1,d0

loc_9624:
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels/MZ/GlassBlock/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjChainPtfm:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_96C2(pc,d0.w),d1
		jmp	off_96C2(pc,d1.w)
; ---------------------------------------------------------------------------

off_96C2:	dc.w loc_96EA-off_96C2, loc_97D0-off_96C2, loc_9834-off_96C2, loc_9846-off_96C2, loc_9818-off_96C2

byte_96CC:	dc.b 0, 0
		dc.b 1, 0

byte_96D0:	dc.b 2, 0, 0
		dc.b 4, $1C, 1
		dc.b 8, $CC, 3
		dc.b 6, $F0, 2

word_96DC:	dc.w $7000, $A000
		dc.w $5000, $7800
		dc.w $3800, $5800
		dc.w $B800
; ---------------------------------------------------------------------------

loc_96EA:
		moveq	#0,d0
		move.b	$28(a0),d0
		bpl.s	loc_9706
		andi.w	#$7F,d0
		add.w	d0,d0
		lea	byte_96CC(pc,d0.w),a2
		move.b	(a2)+,$3A(a0)
		move.b	(a2)+,d0
		move.b	d0,$28(a0)

loc_9706:
		andi.b	#$F,d0
		add.w	d0,d0
		move.w	word_96DC(pc,d0.w),d2
		tst.w	d0
		bne.s	loc_9718
		move.w	d2,$32(a0)

loc_9718:
		lea	(byte_96D0).l,a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	loc_972C
; ---------------------------------------------------------------------------

loc_9724:
		bsr.w	LoadNextObject
		bne.w	loc_97B0

loc_972C:
		move.b	(a2)+,$24(a1)
		move.b	#$31,0(a1)
		move.w	8(a0),8(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	$C(a0),d0
		move.w	d0,$C(a1)
		move.l	#MapChainPtfm,4(a1)
		move.w	#$300,2(a1)
		move.b	#4,1(a1)
		move.w	$C(a1),$30(a1)
		move.b	$28(a0),$28(a1)
		move.b	#$10,$18(a1)
		move.w	d2,$34(a1)
		move.b	#4,$19(a1)
		move.b	(a2)+,$1A(a1)
		cmpi.b	#1,$1A(a1)
		bne.s	loc_97A2
		subq.w	#1,d1
		move.b	$28(a0),d0
		andi.w	#$F0,d0
		cmpi.w	#$20,d0
		beq.s	loc_972C
		move.b	#$38,$18(a1)
		move.b	#$90,$20(a1)
		addq.w	#1,d1

loc_97A2:
		move.l	a0,$3C(a1)
		dbf	d1,loc_9724
		move.b	#3,$19(a1)

loc_97B0:
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#3,d0
		andi.b	#$E,d0
		lea	byte_97CA(pc,d0.w),a2
		move.b	(a2)+,$18(a0)
		move.b	(a2)+,$1A(a0)
		bra.s	loc_97D0
; ---------------------------------------------------------------------------

byte_97CA:	dc.b $38, 0
		dc.b $30, 9
		dc.b $10, $A
; ---------------------------------------------------------------------------

loc_97D0:
		bsr.w	sub_986A
		move.w	$C(a0),(unk_FFF7A4).w
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		move.w	#$C,d2
		move.w	#$D,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		btst	#3,$22(a0)
		beq.s	loc_9810
		cmpi.b	#$10,$32(a0)
		bcc.s	loc_9810
		movea.l	a0,a2
		lea	(ObjectsList).w,a0
		bsr.w	loc_FD78
		movea.l	a2,a0

loc_9810:
		bsr.w	ObjectDisplay
		bra.w	loc_984A
; ---------------------------------------------------------------------------

loc_9818:
		move.b	#$80,$16(a0)
		bset	#4,1(a0)
		movea.l	$3C(a0),a1
		move.b	$32(a1),d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,$1A(a0)

loc_9834:
		movea.l	$3C(a0),a1
		moveq	#0,d0
		move.b	$32(a1),d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)

loc_9846:
		bsr.w	ObjectDisplay

loc_984A:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

sub_986A:
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_987C(pc,d0.w),d1
		jmp	off_987C(pc,d1.w)
; ---------------------------------------------------------------------------

off_987C:	dc.w loc_988A-off_987C, loc_9926-off_987C, loc_9926-off_987C, loc_99B6-off_987C, loc_9926-off_987C
		dc.w loc_99B6-off_987C, loc_9926-off_987C
; ---------------------------------------------------------------------------

loc_988A:
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$3A(a0),d0
		tst.b	(a2,d0.w)
		beq.s	loc_98DE
		tst.w	(unk_FFF7A4).w
		bpl.s	loc_98A8
		cmpi.b	#$10,$32(a0)
		beq.s	loc_98D6

loc_98A8:
		tst.w	$32(a0)
		beq.s	loc_98D6
		move.b	(byte_FFFE0F).w,d0
		andi.b	#$F,d0
		bne.s	loc_98C8
		tst.b	1(a0)
		bpl.s	loc_98C8
		move.w	#$C7,d0
		jsr	(PlaySFX).l

loc_98C8:
		subi.w	#$80,$32(a0)
		bcc.s	loc_9916
		move.w	#0,$32(a0)

loc_98D6:
		move.w	#0,$12(a0)
		bra.s	loc_9916
; ---------------------------------------------------------------------------

loc_98DE:
		move.w	$34(a0),d1
		cmp.w	$32(a0),d1
		beq.s	loc_9916
		move.w	$12(a0),d0
		addi.w	#$70,$12(a0)
		add.w	d0,$32(a0)
		cmp.w	$32(a0),d1
		bhi.s	loc_9916
		move.w	d1,$32(a0)
		move.w	#0,$12(a0)
		tst.b	1(a0)
		bpl.s	loc_9916
		move.w	#$BD,d0
		jsr	(PlaySFX).l

loc_9916:
		moveq	#0,d0
		move.b	$32(a0),d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_9926:
		tst.w	$36(a0)
		beq.s	loc_996E
		tst.w	$38(a0)
		beq.s	loc_9938
		subq.w	#1,$38(a0)
		bra.s	loc_99B2
; ---------------------------------------------------------------------------

loc_9938:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#$F,d0
		bne.s	loc_9952
		tst.b	1(a0)
		bpl.s	loc_9952
		move.w	#$C7,d0
		jsr	(PlaySFX).l

loc_9952:
		subi.w	#$80,$32(a0)
		bcc.s	loc_99B2
		move.w	#0,$32(a0)
		move.w	#0,$12(a0)
		move.w	#0,$36(a0)
		bra.s	loc_99B2
; ---------------------------------------------------------------------------

loc_996E:
		move.w	$34(a0),d1
		cmp.w	$32(a0),d1
		beq.s	loc_99B2
		move.w	$12(a0),d0
		addi.w	#$70,$12(a0)
		add.w	d0,$32(a0)
		cmp.w	$32(a0),d1
		bhi.s	loc_99B2
		move.w	d1,$32(a0)
		move.w	#0,$12(a0)
		move.w	#1,$36(a0)
		move.w	#$3C,$38(a0)
		tst.b	1(a0)
		bpl.s	loc_99B2
		move.w	#$BD,d0
		jsr	(PlaySFX).l

loc_99B2:
		bra.w	loc_9916
; ---------------------------------------------------------------------------

loc_99B6:
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_99C2
		neg.w	d0

loc_99C2:
		cmpi.w	#$90,d0
		bcc.s	loc_99CC
		addq.b	#1,$28(a0)

loc_99CC:
		bra.w	loc_9916
; ---------------------------------------------------------------------------

Obj45:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_99DE(pc,d0.w),d1
		jmp	off_99DE(pc,d1.w)
; ---------------------------------------------------------------------------

off_99DE:	dc.w loc_99FA-off_99DE, loc_9A8E-off_99DE, loc_9AC4-off_99DE, loc_9AD8-off_99DE, loc_9AB0-off_99DE

byte_99E8:	dc.b 2, 4, 0
		dc.b 4, $E4, 1
		dc.b 8, $34, 3
		dc.b 6, $28, 2

word_99F4:	dc.w $3800, $A000, $5000
; ---------------------------------------------------------------------------

loc_99FA:
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	word_99F4(pc,d0.w),d2
		lea	(byte_99E8).l,a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	loc_9A18
; ---------------------------------------------------------------------------

loc_9A12:
		bsr.w	LoadNextObject
		bne.s	loc_9A88

loc_9A18:
		move.b	(a2)+,$24(a1)
		move.b	#$45,0(a1)
		move.w	$C(a0),$C(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	8(a0),d0
		move.w	d0,8(a1)
		move.l	#Map45,4(a1)
		move.w	#$300,2(a1)
		move.b	#4,1(a1)
		move.w	8(a1),$30(a1)
		move.w	8(a0),$3A(a1)
		move.b	$28(a0),$28(a1)
		move.b	#$20,$18(a1)
		move.w	d2,$34(a1)
		move.b	#4,$19(a1)
		cmpi.b	#1,(a2)
		bne.s	loc_9A76
		move.b	#$91,$20(a1)

loc_9A76:
		move.b	(a2)+,$1A(a1)
		move.l	a0,$3C(a1)
		dbf	d1,loc_9A12
		move.b	#3,$19(a1)

loc_9A88:
		move.b	#$10,$18(a0)

loc_9A8E:
		move.w	8(a0),-(sp)
		bsr.w	sub_9AFC
		move.w	#$17,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	(sp)+,d4
		bsr.w	sub_A2BC
		bsr.w	ObjectDisplay
		bra.w	loc_9ADC
; ---------------------------------------------------------------------------

loc_9AB0:
		movea.l	$3C(a0),a1
		move.b	$32(a1),d0
		addi.b	#$10,d0
		lsr.b	#5,d0
		addq.b	#3,d0
		move.b	d0,$1A(a0)

loc_9AC4:
		movea.l	$3C(a0),a1
		moveq	#0,d0
		move.b	$32(a1),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,8(a0)

loc_9AD8:
		bsr.w	ObjectDisplay

loc_9ADC:
		move.w	$3A(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

sub_9AFC:
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	off_9B0C(pc,d0.w),d1
		jmp	off_9B0C(pc,d1.w)
; ---------------------------------------------------------------------------

off_9B0C:	dc.w loc_9B10-off_9B0C, loc_9B10-off_9B0C
; ---------------------------------------------------------------------------

loc_9B10:
		tst.w	$36(a0)
		beq.s	loc_9B3E
		tst.w	$38(a0)
		beq.s	loc_9B22
		subq.w	#1,$38(a0)
		bra.s	loc_9B72
; ---------------------------------------------------------------------------

loc_9B22:
		subi.w	#$80,$32(a0)
		bcc.s	loc_9B72
		move.w	#0,$32(a0)
		move.w	#0,$10(a0)
		move.w	#0,$36(a0)
		bra.s	loc_9B72
; ---------------------------------------------------------------------------

loc_9B3E:
		move.w	$34(a0),d1
		cmp.w	$32(a0),d1
		beq.s	loc_9B72
		move.w	$10(a0),d0
		addi.w	#$70,$10(a0)
		add.w	d0,$32(a0)
		cmp.w	$32(a0),d1
		bhi.s	loc_9B72
		move.w	d1,$32(a0)
		move.w	#0,$10(a0)
		move.w	#1,$36(a0)
		move.w	#$3C,$38(a0)

loc_9B72:
		moveq	#0,d0
		move.b	$32(a0),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,8(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels/MZ/ChainPtfm/Sprite.map"
		even
		include "unknown/Map45.map"
		even
; ---------------------------------------------------------------------------

ObjSwitch:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_9D72(pc,d0.w),d1
		jmp	off_9D72(pc,d1.w)
; ---------------------------------------------------------------------------

off_9D72:	dc.w loc_9D76-off_9D72, loc_9DAC-off_9D72
; ---------------------------------------------------------------------------

loc_9D76:
		addq.b	#2,$24(a0)
		move.l	#MapSwitch,4(a0)
		move.w	#$4513,2(a0)
		cmpi.b	#2,(level).w
		beq.s	loc_9D96
		move.w	#$513,2(a0)

loc_9D96:
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#4,$19(a0)
		addq.w	#3,$C(a0)

loc_9DAC:
		tst.b	1(a0)
		bpl.s	loc_9E2E
		move.w	#$1B,d1
		move.w	#5,d2
		move.w	#5,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		bclr	#0,$1A(a0)
		move.b	$28(a0),d0
		andi.w	#$F,d0
		lea	(unk_FFF7E0).w,a3
		lea	(a3,d0.w),a3
		tst.b	$28(a0)
		bpl.s	loc_9DE8
		bsr.w	sub_9E58
		bne.s	loc_9DFE

loc_9DE8:
		moveq	#0,d3
		btst	#6,$28(a0)
		beq.s	loc_9DF4
		moveq	#7,d3

loc_9DF4:
		tst.b	$25(a0)
		bne.s	loc_9DFE
		bclr	d3,(a3)
		bra.s	loc_9E14
; ---------------------------------------------------------------------------

loc_9DFE:
		tst.b	(a3)
		bne.s	loc_9E0C
		move.w	#$CD,d0
		jsr	(PlaySFX).l

loc_9E0C:
		bset	#0,$1A(a0)
		bset	d3,(a3)

loc_9E14:
		btst	#5,$28(a0)
		beq.s	loc_9E2E
		subq.b	#1,$1E(a0)
		bpl.s	loc_9E2E
		move.b	#7,$1E(a0)
		bchg	#1,$1A(a0)

loc_9E2E:
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	loc_9E52
		rts
; ---------------------------------------------------------------------------

loc_9E52:
		bsr.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

sub_9E58:
		move.w	8(a0),d2
		move.w	$C(a0),d3
		subi.w	#$10,d2
		subq.w	#8,d3
		move.w	#$20,d4
		move.w	#$10,d5
		lea	(LevelObjectsList).w,a1
		move.w	#$5F,d6

loc_9E76:
		tst.b	1(a1)
		bpl.s	loc_9E82
		cmpi.b	#$33,(a1)
		beq.s	loc_9E90

loc_9E82:
		lea	$40(a1),a1
		dbf	d6,loc_9E76
		moveq	#0,d0

locret_9E8C:
		rts
; ---------------------------------------------------------------------------
		dc.b $10, $10
; ---------------------------------------------------------------------------

loc_9E90:
		moveq	#1,d0
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	locret_9E8C(pc,d0.w),a2
		move.b	(a2)+,d1
		ext.w	d1
		move.w	8(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_9EB2
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_9EB6
		bra.s	loc_9E82
; ---------------------------------------------------------------------------

loc_9EB2:
		cmp.w	d4,d0
		bhi.s	loc_9E82

loc_9EB6:
		move.b	(a2)+,d1
		ext.w	d1
		move.w	$C(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_9ECC
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_9ED0
		bra.s	loc_9E82
; ---------------------------------------------------------------------------

loc_9ECC:
		cmp.w	d5,d0
		bhi.s	loc_9E82

loc_9ED0:
		moveq	#1,d0
		rts
; ---------------------------------------------------------------------------
		include "levels/shared/Switch/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjPushBlock:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_9F10(pc,d0.w),d1
		jmp	off_9F10(pc,d1.w)
; ---------------------------------------------------------------------------

off_9F10:	dc.w loc_9F1A-off_9F10, loc_9F84-off_9F10, loc_A00C-off_9F10

byte_9F16:	dc.b $10, 0
		dc.b $40, 1
; ---------------------------------------------------------------------------

loc_9F1A:
		addq.b	#2,$24(a0)
		move.b	#$F,$16(a0)
		move.b	#$F,$17(a0)
		move.l	#MapPushBlock,4(a0)
		move.w	#$42B8,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		andi.w	#$E,d0
		lea	byte_9F16(pc,d0.w),a2
		move.b	(a2)+,$18(a0)
		move.b	(a2)+,$1A(a0)
		tst.b	$28(a0)
		beq.s	loc_9F68
		move.w	#$C2B8,2(a0)

loc_9F68:
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_9F84
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		bne.w	ObjectDelete

loc_9F84:
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	8(a0),d4
		bsr.w	sub_A14E
		cmpi.w	#$200,(level).w
		bne.s	loc_9FD4
		bclr	#7,$28(a0)
		move.w	8(a0),d0
		cmpi.w	#$A20,d0
		bcs.s	loc_9FD4
		cmpi.w	#$AA1,d0
		bcc.s	loc_9FD4
		move.w	(unk_FFF7A4).w,d0
		subi.w	#$1C,d0
		move.w	d0,$C(a0)
		bset	#7,(unk_FFF7A4).w
		bset	#7,$28(a0)

loc_9FD4:
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.s	loc_9FF6
		rts
; ---------------------------------------------------------------------------

loc_9FF6:
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_A008
		bclr	#0,2(a2,d0.w)

loc_A008:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

loc_A00C:
		move.w	8(a0),-(sp)
		cmpi.b	#4,$25(a0)
		bcc.s	loc_A01C
		bsr.w	ObjectMove

loc_A01C:
		btst	#1,$22(a0)
		beq.s	loc_A05E
		addi.w	#$18,$12(a0)
		bsr.w	sub_105F0
		tst.w	d1
		bpl.w	loc_A05C
		add.w	d1,$C(a0)
		clr.w	$12(a0)
		bclr	#1,$22(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2D2,d0
		bcs.s	loc_A05C
		move.w	$30(a0),d0
		asr.w	#3,d0
		move.w	d0,$10(a0)
		clr.w	$E(a0)

loc_A05C:
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A05E:
		tst.w	$10(a0)
		beq.w	loc_A090
		bmi.s	loc_A078
		moveq	#0,d3
		move.b	$18(a0),d3
		bsr.w	sub_106B2
		tst.w	d1
		bmi.s	loc_A08A
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A078:
		moveq	#0,d3
		move.b	$18(a0),d3
		not.w	d3
		bsr.w	sub_10844
		tst.w	d1
		bmi.s	loc_A08A
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A08A:
		clr.w	$10(a0)
		bra.s	loc_A0A0
; ---------------------------------------------------------------------------

loc_A090:
		addi.l	#$2001,$C(a0)
		cmpi.b	#$A0,$F(a0)
		bcc.s	loc_A0CC

loc_A0A0:
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	(sp)+,d4
		bsr.w	sub_A14E
		cmpi.b	#4,$24(a0)
		beq.s	loc_A0C6
		move.b	#4,$24(a0)

loc_A0C6:
		bsr.s	sub_A0E2
		bra.w	loc_9FD4
; ---------------------------------------------------------------------------

loc_A0CC:
		move.w	(sp)+,d4
		lea	(ObjectsList).w,a1
		bclr	#3,$22(a1)
		bclr	#3,$22(a0)
		bra.w	loc_9FF6
; ---------------------------------------------------------------------------

sub_A0E2:
		cmpi.w	#$201,(level).w
		bne.s	loc_A108
		move.w	#$FFE0,d2
		cmpi.w	#$DD0,8(a0)
		beq.s	loc_A126
		cmpi.w	#$CC0,8(a0)
		beq.s	loc_A126
		cmpi.w	#$BA0,8(a0)
		beq.s	loc_A126
		rts
; ---------------------------------------------------------------------------

loc_A108:
		cmpi.w	#$202,(level).w
		bne.s	locret_A124
		move.w	#$20,d2
		cmpi.w	#$560,8(a0)
		beq.s	loc_A126
		cmpi.w	#$5C0,8(a0)
		beq.s	loc_A126

locret_A124:
		rts
; ---------------------------------------------------------------------------

loc_A126:
		bsr.w	ObjectLoad
		bne.s	locret_A14C
		move.b	#$4C,0(a1)
		move.w	8(a0),8(a1)
		add.w	d2,8(a1)
		move.w	$C(a0),$C(a1)
		addi.w	#$10,$C(a1)
		move.l	a0,$3C(a1)

locret_A14C:
		rts
; ---------------------------------------------------------------------------

sub_A14E:
		move.b	$25(a0),d0
		beq.w	loc_A1DE
		subq.b	#2,d0
		bne.s	loc_A172
		bsr.w	PtfmCheckExit
		btst	#3,$22(a1)
		bne.s	loc_A16C
		clr.b	$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_A16C:
		move.w	d4,d2
		bra.w	PtfmSurfaceHeight
; ---------------------------------------------------------------------------

loc_A172:
		subq.b	#2,d0
		bne.s	loc_A1B8
		bsr.w	ObjectMove
		addi.w	#$18,$12(a0)
		bsr.w	sub_105F0
		tst.w	d1
		bpl.w	locret_A1B6
		add.w	d1,$C(a0)
		clr.w	$12(a0)
		clr.b	$25(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2D2,d0
		bcs.s	locret_A1B6
		move.w	$30(a0),d0
		asr.w	#3,d0
		move.w	d0,$10(a0)
		move.b	#4,$24(a0)
		clr.w	$E(a0)

locret_A1B6:
		rts
; ---------------------------------------------------------------------------

loc_A1B8:
		bsr.w	ObjectMove
		move.w	8(a0),d0
		andi.w	#$C,d0
		bne.w	locret_A29A
		andi.w	#$FFF0,8(a0)
		move.w	$10(a0),$30(a0)
		clr.w	$10(a0)
		subq.b	#2,$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_A1DE:
		bsr.w	loc_A37C
		tst.w	d4
		beq.w	locret_A29A
		bmi.w	locret_A29A
		tst.w	d0
		beq.w	locret_A29A
		bmi.s	loc_A222
		btst	#0,$22(a1)
		bne.w	locret_A29A
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	$18(a0),d3
		bsr.w	sub_106B2
		move.w	(sp)+,d0
		tst.w	d1
		bmi.w	locret_A29A
		addi.l	#loc_10000,8(a0)
		moveq	#1,d0
		move.w	#$40,d1
		bra.s	loc_A24C
; ---------------------------------------------------------------------------

loc_A222:
		btst	#0,$22(a1)
		beq.s	locret_A29A
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	$18(a0),d3
		not.w	d3
		bsr.w	sub_10844
		move.w	(sp)+,d0
		tst.w	d1
		bmi.s	locret_A29A
		subi.l	#loc_10000,8(a0)
		moveq	#-1,d0
		move.w	#$FFC0,d1

loc_A24C:
		lea	(ObjectsList).w,a1
		add.w	d0,8(a1)
		move.w	d1,$14(a1)
		move.w	#0,$10(a1)
		move.w	d0,-(sp)
		move.w	#$A7,d0
		jsr	(PlaySFX).l
		move.w	(sp)+,d0
		tst.b	$28(a0)
		bmi.s	locret_A29A
		move.w	d0,-(sp)
		bsr.w	sub_105F0
		move.w	(sp)+,d0
		cmpi.w	#4,d1
		ble.s	loc_A296
		move.w	#$400,$10(a0)
		tst.w	d0
		bpl.s	loc_A28E
		neg.w	$10(a0)

loc_A28E:
		move.b	#6,$25(a0)
		bra.s	locret_A29A
; ---------------------------------------------------------------------------

loc_A296:
		add.w	d1,$C(a0)

locret_A29A:
		rts
; ---------------------------------------------------------------------------
		include "levels/MZ/PushBlock/Sprite.map"
		even
; ---------------------------------------------------------------------------

sub_A2BC:
		cmpi.b	#6,(ObjectsList+$24).w
		bcc.w	loc_A2FE
		tst.b	$25(a0)
		beq.w	loc_A37C
		move.w	d1,d2
		add.w	d2,d2
		lea	(ObjectsList).w,a1
		btst	#1,$22(a1)
		bne.s	loc_A2EE
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.s	loc_A2EE
		cmp.w	d2,d0
		bcs.s	loc_A302

loc_A2EE:
		bclr	#3,$22(a1)
		bclr	#3,$22(a0)
		clr.b	$25(a0)

loc_A2FE:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A302:
		move.w	d4,d2
		bsr.w	PtfmSurfaceHeight
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A30C:
		tst.w	(DebugRoutine).w
		bne.w	loc_A448
		tst.b	1(a0)
		bpl.w	loc_A42E
		lea	(ObjectsList).w,a1
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.w	loc_A42E
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	loc_A42E
		move.w	d0,d5
		btst	#0,1(a0)
		beq.s	loc_A346
		not.w	d5
		add.w	d3,d5

loc_A346:
		lsr.w	#1,d5
		moveq	#0,d3
		move.b	(a2,d5.w),d3
		sub.b	(a2),d3
		move.w	$C(a0),d5
		sub.w	d3,d5
		move.b	$16(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	$C(a1),d3
		sub.w	d5,d3
		addq.w	#4,d3
		add.w	d2,d3
		bmi.w	loc_A42E
		subq.w	#4,d3
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	loc_A42E
		bra.w	loc_A3CC
; ---------------------------------------------------------------------------

loc_A37C:
		tst.w	(DebugRoutine).w
		bne.w	loc_A448
		tst.b	1(a0)
		bpl.w	loc_A42E
		lea	(ObjectsList).w,a1
		move.w	8(a1),d0
		sub.w	8(a0),d0
		add.w	d1,d0
		bmi.w	loc_A42E
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.w	loc_A42E
		move.b	$16(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	$C(a1),d3
		sub.w	$C(a0),d3
		addq.w	#4,d3
		add.w	d2,d3
		bmi.w	loc_A42E
		subq.w	#4,d3
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bcc.w	loc_A42E

loc_A3CC:
		move.w	d0,d5
		cmp.w	d0,d1
		bcc.s	loc_A3DA
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_A3DA:
		move.w	d3,d1
		cmp.w	d3,d2
		bcc.s	loc_A3E6
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_A3E6:
		cmp.w	d1,d5
		bhi.w	loc_A44C
		tst.w	d0
		beq.s	loc_A40C
		bmi.s	loc_A3FA
		tst.w	$10(a1)
		bmi.s	loc_A40C
		bra.s	loc_A400
; ---------------------------------------------------------------------------

loc_A3FA:
		tst.w	$10(a1)
		bpl.s	loc_A40C

loc_A400:
		move.w	#0,$14(a1)
		move.w	#0,$10(a1)

loc_A40C:
		sub.w	d0,8(a1)
		btst	#1,$22(a1)
		bne.s	loc_A428
		bset	#5,$22(a1)
		bset	#5,$22(a0)
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_A428:
		bsr.s	sub_A43C
		moveq	#1,d4
		rts
; ---------------------------------------------------------------------------

loc_A42E:
		btst	#5,$22(a0)
		beq.s	loc_A448
		move.w	#1,$1C(a1)
; ---------------------------------------------------------------------------

sub_A43C:
		bclr	#5,$22(a0)
		bclr	#5,$22(a1)

loc_A448:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_A44C:
		tst.w	d3
		bmi.s	loc_A458

loc_A450:
		cmpi.w	#$10,d3
		bcs.s	loc_A488
		bra.s	loc_A42E
; ---------------------------------------------------------------------------

loc_A458:
		tst.w	$12(a1)
		beq.s	loc_A472
		bpl.s	loc_A46E
		tst.w	d3
		bpl.s	loc_A46E
		sub.w	d3,$C(a1)
		move.w	#0,$12(a1)

loc_A46E:
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A472:
		btst	#1,$22(a1)
		bne.s	loc_A46E
		move.l	a0,-(sp)
		movea.l	a1,a0
		bsr.w	loc_FD78
		movea.l	(sp)+,a0
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A488:
		moveq	#0,d1
		move.b	$18(a0),d1
		addq.w	#4,d1
		move.w	d1,d2
		add.w	d2,d2
		add.w	8(a1),d1
		sub.w	8(a0),d1
		bmi.s	loc_A4C4
		cmp.w	d2,d1
		bcc.s	loc_A4C4
		tst.w	$12(a1)
		bmi.s	loc_A4C4
		sub.w	d3,$C(a1)
		subq.w	#1,$C(a1)
		bsr.w	loc_4FD4
		move.b	#2,$25(a0)
		bset	#3,$22(a0)
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

loc_A4C4:
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

ObjTitleCard:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_A4D6(pc,d0.w),d1
		jmp	off_A4D6(pc,d1.w)
; ---------------------------------------------------------------------------

off_A4D6:	dc.w loc_A4DE-off_A4D6, loc_A556-off_A4D6, loc_A57C-off_A4D6, loc_A57C-off_A4D6
; ---------------------------------------------------------------------------

loc_A4DE:
		movea.l	a0,a1
		moveq	#0,d0
		move.b	(level).w,d0
		lea	(word_A5E4).l,a3
		lsl.w	#4,d0
		adda.w	d0,a3
		lea	(word_A5D4).l,a2
		moveq	#3,d1

loc_A4F8:
		move.b	#$34,0(a1)
		move.w	(a3),8(a1)
		move.w	(a3)+,$32(a1)
		move.w	(a3)+,$30(a1)
		move.w	(a2)+,$A(a1)
		move.b	(a2)+,$24(a1)
		move.b	(a2)+,d0
		bne.s	loc_A51A
		move.b	(level).w,d0

loc_A51A:
		cmpi.b	#7,d0
		bne.s	loc_A524
		add.b	(level+1).w,d0

loc_A524:
		move.b	d0,$1A(a1)
		move.l	#MapTitleCard,4(a1)
		move.w	#$8580,2(a1)
		move.b	#$78,$18(a1)
		move.b	#0,1(a1)
		move.b	#0,$19(a1)
		move.w	#$3C,$1E(a1)
		lea	$40(a1),a1
		dbf	d1,loc_A4F8

loc_A556:
		moveq	#$10,d1
		move.w	$30(a0),d0
		cmp.w	8(a0),d0
		beq.s	loc_A56A
		bge.s	loc_A566
		neg.w	d1

loc_A566:
		add.w	d1,8(a0)

loc_A56A:
		move.w	8(a0),d0
		bmi.s	locret_A57A
		cmpi.w	#$200,d0
		bcc.s	locret_A57A
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

locret_A57A:
		rts
; ---------------------------------------------------------------------------

loc_A57C:
		tst.w	$1E(a0)
		beq.s	loc_A58A
		subq.w	#1,$1E(a0)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_A58A:
		moveq	#$20,d1
		move.w	$32(a0),d0
		cmp.w	8(a0),d0
		beq.s	loc_A5B0
		bge.s	loc_A59A
		neg.w	d1

loc_A59A:
		add.w	d1,8(a0)
		move.w	8(a0),d0
		bmi.s	locret_A5AE
		cmpi.w	#$200,d0
		bcc.s	locret_A5AE
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

locret_A5AE:
		rts
; ---------------------------------------------------------------------------

loc_A5B0:
		cmpi.b	#4,$24(a0)
		bne.s	loc_A5D0
		moveq	#2,d0
		jsr	(plcAdd).l
		moveq	#0,d0
		move.b	(level).w,d0
		addi.w	#$15,d0
		jsr	(plcAdd).l

loc_A5D0:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

word_A5D4:	dc.w $D0
		dc.b 2, 0
		dc.w $E4
		dc.b 2, 6
		dc.w $EA
		dc.b 2, 7
		dc.w $E0
		dc.b 2, $A

word_A5E4:	dc.w 0, $120, $FEFC, $13C, $414, $154, $214, $154
		dc.w 0, $120, $FEF4, $134, $40C, $14C, $20C, $14C
		dc.w 0, $120, $FEE0, $120, $3F8, $138, $1F8, $138
		dc.w 0, $120, $FEFC, $13C, $414, $154, $214, $154
		dc.w 0, $120, $FEF4, $134, $40C, $14C, $20C, $14C
		dc.w 0, $120, $FF00, $140, $418, $158, $218, $158
; ---------------------------------------------------------------------------

ObjGameOver:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_A652(pc,d0.w),d1
		jmp	off_A652(pc,d1.w)
; ---------------------------------------------------------------------------

off_A652:	dc.w loc_A658-off_A652, loc_A696-off_A652, loc_A6B8-off_A652
; ---------------------------------------------------------------------------

loc_A658:
		tst.l	(plcList).w
		beq.s	loc_A660
		rts
; ---------------------------------------------------------------------------

loc_A660:
		addq.b	#2,$24(a0)
		move.w	#$50,8(a0)
		tst.b	$1A(a0)
		beq.s	loc_A676
		move.w	#$1F0,8(a0)

loc_A676:
		move.w	#$F0,$A(a0)
		move.l	#MapGameOver,4(a0)
		move.w	#$8580,2(a0)
		move.b	#0,1(a0)
		move.b	#0,$19(a0)

loc_A696:
		moveq	#$10,d1
		cmpi.w	#$120,8(a0)
		beq.s	loc_A6AC
		bcs.s	loc_A6A4
		neg.w	d1

loc_A6A4:
		add.w	d1,8(a0)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_A6AC:
		move.w	#$258,$1E(a0)
		addq.b	#2,$24(a0)
		rts
; ---------------------------------------------------------------------------

loc_A6B8:
		move.b	(padPressPlayer).w,d0
		andi.b	#$70,d0
		bne.s	loc_A6D6
		tst.b	$1A(a0)
		bne.s	loc_A6DC
		tst.w	$1E(a0)
		beq.s	loc_A6D6
		subq.w	#1,$1E(a0)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_A6D6:
		move.b	#0,(GameMode).w

loc_A6DC:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

ObjLevelResults:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_A6EE(pc,d0.w),d1
		jmp	off_A6EE(pc,d1.w)
; ---------------------------------------------------------------------------

off_A6EE:	dc.w loc_A6FA-off_A6EE, loc_A74E-off_A6EE, loc_A786-off_A6EE, loc_A794-off_A6EE, loc_A786-off_A6EE
		dc.w loc_A7F2-off_A6EE
; ---------------------------------------------------------------------------

loc_A6FA:
		tst.l	(plcList).w
		beq.s	loc_A702
		rts
; ---------------------------------------------------------------------------

loc_A702:
		movea.l	a0,a1
		lea	(word_A856).l,a2
		moveq	#6,d1

loc_A70C:
		move.b	#$3A,0(a1)
		move.w	(a2)+,8(a1)
		move.w	(a2)+,$30(a1)
		move.w	(a2)+,$A(a1)
		move.b	(a2)+,$24(a1)
		move.b	(a2)+,d0
		cmpi.b	#6,d0
		bne.s	loc_A72E
		add.b	(level+1).w,d0

loc_A72E:
		move.b	d0,$1A(a1)
		move.l	#MapLevelResults,4(a1)
		move.w	#$8580,2(a1)
		move.b	#0,1(a1)
		lea	$40(a1),a1
		dbf	d1,loc_A70C

loc_A74E:
		moveq	#$10,d1
		move.w	$30(a0),d0
		cmp.w	8(a0),d0
		beq.s	loc_A774
		bge.s	loc_A75E
		neg.w	d1

loc_A75E:
		add.w	d1,8(a0)

loc_A762:
		move.w	8(a0),d0
		bmi.s	locret_A772
		cmpi.w	#$200,d0
		bcc.s	locret_A772
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

locret_A772:
		rts
; ---------------------------------------------------------------------------

loc_A774:
		cmpi.b	#4,$1A(a0)
		bne.s	loc_A762
		addq.b	#2,$24(a0)
		move.w	#$B4,$1E(a0)

loc_A786:
		subq.w	#1,$1E(a0)
		bne.s	loc_A790
		addq.b	#2,$24(a0)

loc_A790:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_A794:
		bsr.w	ObjectDisplay
		move.b	#1,(byte_FFFE58).w
		moveq	#0,d0
		tst.w	(word_FFFE54).w
		beq.s	loc_A7B0
		addi.w	#$A,d0
		subi.w	#$A,(word_FFFE54).w

loc_A7B0:
		tst.w	(word_FFFE56).w
		beq.s	loc_A7C0
		addi.w	#$A,d0
		subi.w	#$A,(word_FFFE56).w

loc_A7C0:
		tst.w	d0
		bne.s	loc_A7DA
		move.w	#$C5,d0
		jsr	(PlaySFX).l
		addq.b	#2,$24(a0)
		move.w	#$B4,$1E(a0)

locret_A7D8:
		rts
; ---------------------------------------------------------------------------

loc_A7DA:
		bsr.w	ScoreAdd
		move.b	(byte_FFFE0F).w,d0
		andi.b	#3,d0
		bne.s	locret_A7D8
		move.w	#$CD,d0
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------

loc_A7F2:
		move.b	(level).w,d0
		andi.w	#7,d0
		lsl.w	#3,d0
		move.b	(level+1).w,d1
		andi.w	#3,d1
		add.w	d1,d1
		add.w	d1,d0
		move.w	word_A826(pc,d0.w),d0
		move.w	d0,(level).w
		tst.w	d0
		bne.s	loc_A81C
		move.b	#0,(GameMode).w
		bra.s	loc_A822
; ---------------------------------------------------------------------------

loc_A81C:
		move.w	#1,(LevelRestart).w

loc_A822:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

word_A826:	dc.w 1,    2, $200,    0
		dc.w $101, $102, $200,    0
		dc.w $201, $202, $400,    0
		dc.w 0, $302, $200,    0
		dc.w $300, $402, $500,    0
		dc.w $501, $502,    0,    0

word_A856:	dc.w 4, $124, $BC
		dc.b 2, 0
		dc.w $FEE0, $120, $D0
		dc.b 2, 1
		dc.w $40C, $14C, $D6
		dc.b 2, 6
		dc.w $520, $120, $EC
		dc.b 2, 2
		dc.w $540, $120, $FC
		dc.b 2, 3
		dc.w $560, $120, $10C
		dc.b 2, 4
		dc.w $20C, $14C, $CC
		dc.b 2, 5
		include "levels/shared/TitleCard/Sprite.map"
		even
		include "levels/shared/GameOver/Sprite.map"
		include "levels/shared/LevelResults/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSpikes:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_AB0A(pc,d0.w),d1
		jmp	off_AB0A(pc,d1.w)
; ---------------------------------------------------------------------------

off_AB0A:	dc.w loc_AB1A-off_AB0A, loc_AB64-off_AB0A

byte_AB0E:	dc.b 0, $14
		dc.b 1, $10
		dc.b 2, 4
		dc.b 3, $1C
		dc.b 4, $40
		dc.b 5, $10
; ---------------------------------------------------------------------------

loc_AB1A:
		addq.b	#2,$24(a0)
		move.l	#MapSpikes,4(a0)
		move.w	#$51B,2(a0)
		ori.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	$28(a0),d0
		andi.b	#$F,$28(a0)
		andi.w	#$F0,d0
		lea	(byte_AB0E).l,a1
		lsr.w	#3,d0
		adda.w	d0,a1
		move.b	(a1)+,$1A(a0)
		move.b	(a1)+,$18(a0)
		move.w	8(a0),$30(a0)
		move.w	$C(a0),$32(a0)

loc_AB64:
		bsr.w	sub_AC02
		move.w	#4,d2
		cmpi.b	#5,$1A(a0)
		beq.s	loc_AB80
		cmpi.b	#1,$1A(a0)
		bne.s	loc_AB9E
		move.w	#$14,d2

loc_AB80:
		move.w	#$1B,d1
		move.w	d2,d3
		subq.w	#2,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		tst.b	$25(a0)
		bne.s	loc_ABDE
		cmpi.w	#1,d4
		beq.s	loc_ABBE
		bra.s	loc_ABDE
; ---------------------------------------------------------------------------

loc_AB9E:
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		bsr.w	sub_6936
		tst.w	d4
		bpl.s	loc_ABDE
		tst.w	$12(a1)
		beq.s	loc_ABDE
		tst.w	d3
		bmi.s	loc_ABDE

loc_ABBE:
		move.l	a0,-(sp)
		movea.l	a0,a2
		lea	(ObjectsList).w,a0
		move.l	$C(a0),d3
		move.w	$12(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,$C(a0)
		bsr.w	loc_FCF4
		movea.l	(sp)+,a0

loc_ABDE:
		bsr.w	ObjectDisplay
		move.w	$30(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

sub_AC02:
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	off_AC12(pc,d0.w),d1
		jmp	off_AC12(pc,d1.w)
; ---------------------------------------------------------------------------

off_AC12:	dc.w locret_AC18-off_AC12, loc_AC1A-off_AC12
		dc.w loc_AC2E-off_AC12
; ---------------------------------------------------------------------------

locret_AC18:
		rts
; ---------------------------------------------------------------------------

loc_AC1A:
		bsr.w	sub_AC42
		moveq	#0,d0
		move.b	$34(a0),d0
		add.w	$32(a0),d0
		move.w	d0,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_AC2E:
		bsr.w	sub_AC42
		moveq	#0,d0
		move.b	$34(a0),d0
		add.w	$30(a0),d0
		move.w	d0,8(a0)
		rts
; ---------------------------------------------------------------------------

sub_AC42:
		tst.w	$38(a0)
		beq.s	loc_AC60
		subq.w	#1,$38(a0)
		bne.s	locret_ACA2
		tst.b	1(a0)
		bpl.s	locret_ACA2
		move.w	#$B6,d0
		jsr	(PlaySFX).l
		bra.s	locret_ACA2
; ---------------------------------------------------------------------------

loc_AC60:
		tst.w	$36(a0)
		beq.s	loc_AC82
		subi.w	#$800,$34(a0)
		bcc.s	locret_ACA2
		move.w	#0,$34(a0)
		move.w	#0,$36(a0)
		move.w	#$3C,$38(a0)
		bra.s	locret_ACA2
; ---------------------------------------------------------------------------

loc_AC82:
		addi.w	#$800,$34(a0)
		cmpi.w	#$2000,$34(a0)
		bcs.s	locret_ACA2
		move.w	#$2000,$34(a0)
		move.w	#1,$36(a0)
		move.w	#$3C,$38(a0)

locret_ACA2:
		rts
; ---------------------------------------------------------------------------
		include "levels/shared/Spikes/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjPurpleRock:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_AD1A(pc,d0.w),d1
		jmp	off_AD1A(pc,d1.w)
; ---------------------------------------------------------------------------

off_AD1A:	dc.w loc_AD1E-off_AD1A, loc_AD42-off_AD1A
; ---------------------------------------------------------------------------

loc_AD1E:
		addq.b	#2,$24(a0)
		move.l	#MapPurpleRock,4(a0)
		move.w	#$63D0,2(a0)
		move.b	#4,1(a0)
		move.b	#$13,$18(a0)
		move.b	#4,$19(a0)

loc_AD42:
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$10,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjWaterfallSnd:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_AD88(pc,d0.w),d1
		jmp	off_AD88(pc,d1.w)
; ---------------------------------------------------------------------------

off_AD88:	dc.w loc_AD8C-off_AD88, loc_AD96-off_AD88
; ---------------------------------------------------------------------------

loc_AD8C:
		addq.b	#2,$24(a0)
		move.b	#4,1(a0)

loc_AD96:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#$3F,d0
		bne.s	loc_ADAA
		move.w	#$D0,d0
		jsr	(PlaySFX).l

loc_ADAA:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
		include "levels/GHZ/PurpleRock/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSmashWall:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_ADEA(pc,d0.w),d1
		jsr	off_ADEA(pc,d1.w)
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_ADEA:	dc.w loc_ADF0-off_ADEA, loc_AE1A-off_ADEA, loc_AE92-off_ADEA
; ---------------------------------------------------------------------------

loc_ADF0:
		addq.b	#2,obRoutine(a0)
		move.l	#MapSmashWall,obMap(a0)
		move.w	#$450F,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$10,obPriority(a0)
		move.b	#4,obActWid(a0)
		move.b	obSubtype(a0),obFrame(a0)

loc_AE1A:
		move.w	(ObjectsList+obVelX).w,Smash_speed(a0)
		move.w	#$1B,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	obX(a0),d4
		bsr.w	sub_A2BC
		btst	#5,obStatus(a0)
		bne.s	loc_AE3E

locret_AE3C:
		rts
; ---------------------------------------------------------------------------

loc_AE3E:
		cmpi.b	#2,obAnim(a1)
		bne.s	locret_AE3C
		move.w	Smash_speed(a0),d0
		bpl.s	loc_AE4E
		neg.w	d0

loc_AE4E:
		cmpi.w	#$480,d0
		bcs.s	locret_AE3C
		move.w	Smash_speed(a0),Smash_speed(a1)
		addq.w	#4,obX(a1)
		lea	(ObjSmashWall_FragRight).l,a4
		move.w	obX(a0),d0
		cmp.w	obX(a1),d0
		bcs.s	loc_AE78
		subq.w	#8,obX(a1)
		lea	(ObjSmashWall_FragLeft).l,a4

loc_AE78:
		move.w	obVelX(a1),obInertia(a1)
		bclr	#5,obStatus(a0)
		bclr	#5,obStatus(a1)
		moveq	#7,d1
		move.w	#$70,d2
		bsr.s	ObjectFragment

loc_AE92:
		bsr.w	ObjectMove
		addi.w	#$70,obVelY(a0)
		bsr.w	ObjectDisplay
		tst.b	1(a0)
		bpl.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjectFragment:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		add.w	d0,d0
		movea.l	obMap(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,obRender(a0)
		move.b	0(a0),d4
		move.b	obRender(a0),d5
		movea.l	a0,a1
		bra.s	loc_AED6
; ---------------------------------------------------------------------------

loc_AECE:
		bsr.w	ObjectLoad
		bne.s	loc_AF28
		addq.w	#5,a3

loc_AED6:
		move.b	#4,obRoutine(a1)
		move.b	d4,0(a1)
		move.l	a3,obMap(a1)
		move.b	d5,obRender(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.b	obPriority(a0),obPriority(a1)
		move.w	(a4)+,obVelX(a1)
		move.w	(a4)+,obVelY(a1)
		cmpa.l	a0,a1
		bcc.s	loc_AF24
		move.l	a0,-(sp)
		movea.l	a1,a0
		bsr.w	ObjectMove
		add.w	d2,obVelY(a0)
		movea.l	(sp)+,a0
		bsr.w	ObjectDisplayA1

loc_AF24:
		dbf	d1,loc_AECE

loc_AF28:
		move.w	#$CB,d0
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------

ObjSmashWall_FragRight:dc.w $400, $FB00
		dc.w $600, $FF00
		dc.w $600, $100
		dc.w $400, $500
		dc.w $600, $FA00
		dc.w $800, $FE00
		dc.w $800, $200
		dc.w $600, $600

ObjSmashWall_FragLeft:dc.w $FA00, $FA00
		dc.w $F800, $FE00
		dc.w $F800, $200
		dc.w $FA00, $600
		dc.w $FC00, $FB00
		dc.w $FA00, $FF00
		dc.w $FA00, $100
		dc.w $FC00, $500
		include "levels/GHZ/SmashWall/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjGHZBoss:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_B002(pc,d0.w),d1
		jmp	off_B002(pc,d1.w)
; ---------------------------------------------------------------------------

off_B002:	dc.w loc_B010-off_B002, loc_B07C-off_B002, loc_B2AE-off_B002, loc_B2D6-off_B002

byte_B00A:	dc.b 2, 0
		dc.b 4, 1
		dc.b 6, 7
; ---------------------------------------------------------------------------

loc_B010:
		lea	(byte_B00A).l,a2
		movea.l	a0,a1
		moveq	#2,d1
		bra.s	loc_B022
; ---------------------------------------------------------------------------

loc_B01C:
		bsr.w	LoadNextObject
		bne.s	loc_B064

loc_B022:
		move.b	(a2)+,obRoutine(a1)
		move.b	#$3D,0(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l	#MapGHZBoss,obMap(a1)
		move.w	#$400,obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$20,obPriority(a1)
		move.b	#3,obActWid(a1)
		move.b	(a2)+,obAnim(a1)
		move.l	a0,$34(a1)
		dbf	d1,loc_B01C

loc_B064:
		move.w	8(a0),$30(a0)
		move.w	$C(a0),$38(a0)
		move.b	#$F,obColType(a0)
		move.b	#8,obColProp(a0)

loc_B07C:
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	off_B0AA(pc,d0.w),d1
		jsr	off_B0AA(pc,d1.w)
		lea	(AniGHZBoss).l,a1
		bsr.w	AnimateSprite
		move.b	$22(a0),d0
		andi.b	#3,d0

loc_B09C:
		andi.b	#$FC,1(a0)
		or.b	d0,1(a0)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

off_B0AA:	dc.w loc_B0B6-off_B0AA, loc_B1AE-off_B0AA
		dc.w loc_B1FC-off_B0AA, loc_B236-off_B0AA
		dc.w loc_B25C-off_B0AA, loc_B290-off_B0AA
; ---------------------------------------------------------------------------

loc_B0B6:
		move.w	#$100,$12(a0)
		bsr.w	BossMove
		cmpi.w	#$338,$38(a0)
		bne.s	loc_B0D2
		move.w	#0,$12(a0)
		addq.b	#2,$25(a0)

loc_B0D2:
		move.b	$3F(a0),d0
		jsr	(GetSine).l
		asr.w	#6,d0
		add.w	$38(a0),d0
		move.w	d0,$C(a0)
		move.w	$30(a0),8(a0)
		addq.b	#2,$3F(a0)
		cmpi.b	#8,$25(a0)
		bcc.s	locret_B136
		tst.b	$22(a0)
		bmi.s	loc_B138
		tst.b	$20(a0)
		bne.s	locret_B136
		tst.b	$3E(a0)
		bne.s	loc_B11A
		move.b	#$20,$3E(a0)
		move.w	#$AC,d0
		jsr	(PlaySFX).l

loc_B11A:
		lea	((Palette+$22)).w,a1
		moveq	#0,d0
		tst.w	(a1)
		bne.s	loc_B128
		move.w	#$EEE,d0

loc_B128:
		move.w	d0,(a1)
		subq.b	#1,$3E(a0)
		bne.s	locret_B136
		move.b	#$F,$20(a0)

locret_B136:
		rts
; ---------------------------------------------------------------------------

loc_B138:
		move.b	#8,$25(a0)
		move.w	#$B3,$3C(a0)
		rts
; ---------------------------------------------------------------------------

sub_B146:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#7,d0
		bne.s	locret_B186
		bsr.w	ObjectLoad
		bne.s	locret_B186
		move.b	#$3F,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,8(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,$C(a1)

locret_B186:
		rts
; ---------------------------------------------------------------------------

BossMove:
		move.l	$30(a0),d2
		move.l	$38(a0),d3
		move.w	$10(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.w	$12(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d3
		move.l	d2,$30(a0)
		move.l	d3,$38(a0)
		rts
; ---------------------------------------------------------------------------

loc_B1AE:
		move.w	#$FF00,$10(a0)
		move.w	#$FFC0,$12(a0)
		bsr.w	BossMove
		cmpi.w	#$2A00,$30(a0)
		bne.s	loc_B1F8
		move.w	#0,$10(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$25(a0)
		bsr.w	LoadNextObject
		bne.s	loc_B1F2
		move.b	#$48,0(a1)
		move.w	$30(a0),8(a1)
		move.w	$38(a0),$C(a1)
		move.l	a0,$34(a1)

loc_B1F2:
		move.w	#$77,$3C(a0)

loc_B1F8:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B1FC:
		subq.w	#1,$3C(a0)
		bpl.s	loc_B226
		addq.b	#2,$25(a0)
		move.w	#$3F,$3C(a0)
		move.w	#$100,$10(a0)
		cmpi.w	#$2A00,$30(a0)
		bne.s	loc_B226
		move.w	#$7F,$3C(a0)
		move.w	#$40,$10(a0)

loc_B226:
		btst	#0,$22(a0)
		bne.s	loc_B232
		neg.w	$10(a0)

loc_B232:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B236:
		subq.w	#1,$3C(a0)
		bmi.s	loc_B242
		bsr.w	BossMove
		bra.s	loc_B258
; ---------------------------------------------------------------------------

loc_B242:
		bchg	#0,$22(a0)
		move.w	#$3F,$3C(a0)
		subq.b	#2,$25(a0)
		move.w	#0,$10(a0)

loc_B258:
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B25C:
		subq.w	#1,$3C(a0)
		bmi.s	loc_B266
		bra.w	sub_B146
; ---------------------------------------------------------------------------

loc_B266:
		bset	#0,$22(a0)
		bclr	#7,$22(a0)
		move.w	#$400,$10(a0)
		move.w	#$FFC0,$12(a0)
		addq.b	#2,$25(a0)
		tst.b	(unk_FFF7A7).w
		bne.s	locret_B28E
		move.b	#1,(unk_FFF7A7).w

locret_B28E:
		rts
; ---------------------------------------------------------------------------

loc_B290:
		cmpi.w	#$2AC0,(unk_FFF72A).w
		beq.s	loc_B29E
		addq.w	#2,(unk_FFF72A).w
		bra.s	loc_B2A6
; ---------------------------------------------------------------------------

loc_B29E:
		tst.b	1(a0)
		bpl.w	ObjectDelete

loc_B2A6:
		bsr.w	BossMove
		bra.w	loc_B0D2
; ---------------------------------------------------------------------------

loc_B2AE:
		movea.l	$34(a0),a1
		cmpi.b	#$A,$25(a1)
		bne.s	loc_B2C2
		tst.b	1(a0)
		bpl.w	ObjectDelete

loc_B2C2:
		move.b	#1,$1C(a0)
		tst.b	$20(a1)
		bne.s	loc_B2D4
		move.b	#5,$1C(a0)

loc_B2D4:
		bra.s	loc_B2FC
; ---------------------------------------------------------------------------

loc_B2D6:
		movea.l	$34(a0),a1
		cmpi.b	#$A,$25(a1)
		bne.s	loc_B2EA
		tst.b	1(a0)
		bpl.w	ObjectDelete

loc_B2EA:
		move.b	#7,$1C(a0)
		move.w	$10(a1),d0
		beq.s	loc_B2FC
		move.b	#8,$1C(a0)

loc_B2FC:
		movea.l	$34(a0),a1
		move.w	8(a1),8(a0)
		move.w	$C(a1),$C(a0)
		move.b	$22(a1),$22(a0)
		lea	(AniGHZBoss).l,a1
		bsr.w	AnimateSprite
		move.b	$22(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,1(a0)
		or.b	d0,1(a0)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

ObjGHZBossBall:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_B340(pc,d0.w),d1
		jmp	off_B340(pc,d1.w)
; ---------------------------------------------------------------------------

off_B340:	dc.w loc_B34A-off_B340, loc_B404-off_B340, loc_B462-off_B340, loc_B49E-off_B340, loc_B4B8-off_B340
; ---------------------------------------------------------------------------

loc_B34A:
		addq.b	#2,$24(a0)
		move.w	#$4080,$26(a0)
		move.w	#$FE00,$3E(a0)
		move.l	#MapGHZBossBall,4(a0)
		move.w	#$46C,2(a0)
		lea	$28(a0),a2
		move.b	#0,(a2)+
		moveq	#5,d1
		movea.l	a0,a1
		bra.s	loc_B3AC
; ---------------------------------------------------------------------------

loc_B376:
		bsr.w	LoadNextObject
		bne.s	loc_B3D6
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	#$48,0(a1)
		move.b	#6,$24(a1)
		move.l	#MapSwingPtfm,4(a1)
		move.w	#$380,2(a1)
		move.b	#1,$1A(a1)
		addq.b	#1,$28(a0)

loc_B3AC:
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#4,1(a1)
		move.b	#8,$18(a1)
		move.b	#6,$19(a1)
		move.l	$34(a0),$34(a1)
		dbf	d1,loc_B376

loc_B3D6:
		move.b	#8,$24(a1)
		move.l	#$5E7A,4(a1)
		move.w	#$43AA,2(a1)
		move.b	#1,$1A(a1)
		move.b	#5,$19(a1)
		move.b	#$81,$20(a1)
		rts
; ---------------------------------------------------------------------------

byte_B3FE:	dc.b 0, $10, $20, $30, $40, $60
; ---------------------------------------------------------------------------

loc_B404:
		lea	(byte_B3FE).l,a3
		lea	$28(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_B412:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#(ObjectsList)&$FFFFFF,d4
		movea.l	d4,a1
		move.b	(a3)+,d0
		cmp.b	$3C(a1),d0
		beq.s	loc_B42C
		addq.b	#1,$3C(a1)

loc_B42C:
		dbf	d6,loc_B412
		cmp.b	$3C(a1),d0
		bne.s	loc_B446
		movea.l	$34(a0),a1
		cmpi.b	#6,$25(a1)
		bne.s	loc_B446
		addq.b	#2,$24(a0)

loc_B446:
		cmpi.w	#$20,$32(a0)
		beq.s	loc_B452
		addq.w	#1,$32(a0)

loc_B452:
		bsr.w	sub_B46E
		move.b	$26(a0),d0
		bsr.w	loc_5692
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_B462:
		bsr.w	sub_B46E
		bsr.w	loc_5652
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

sub_B46E:
		movea.l	$34(a0),a1
		move.w	8(a1),$3A(a0)
		move.w	$C(a1),d0
		add.w	$32(a0),d0
		move.w	d0,$38(a0)
		move.b	$22(a1),$22(a0)
		tst.b	$22(a1)
		bpl.s	locret_B49C
		move.b	#$3F,0(a0)
		move.b	#0,$24(a0)

locret_B49C:
		rts
; ---------------------------------------------------------------------------

loc_B49E:
		movea.l	$34(a0),a1
		tst.b	$22(a1)
		bpl.s	loc_B4B4
		move.b	#$3F,0(a0)
		move.b	#0,$24(a0)

loc_B4B4:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_B4B8:
		moveq	#0,d0
		tst.b	$1A(a0)
		bne.s	loc_B4C2
		addq.b	#1,d0

loc_B4C2:
		move.b	d0,$1A(a0)
		movea.l	$34(a0),a1
		tst.b	$22(a1)
		bpl.w	ObjectDisplay
		move.b	#0,$20(a0)
		bsr.w	sub_B146
		subq.b	#1,$3C(a0)
		bpl.s	loc_B4EE
		move.b	#$3F,0(a0)
		move.b	#0,$24(a0)

loc_B4EE:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------
		include "levels/GHZ/Boss/Sprite.ani"
		include "levels/GHZ/Boss/Sprite.map"
		even
		include "levels/GHZ/Boss/Ball.map"
		even
; ---------------------------------------------------------------------------

ObjCapsule:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_B66C(pc,d0.w),d1
		jsr	off_B66C(pc,d1.w)
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

off_B66C:	dc.w loc_B68C-off_B66C, loc_B6D6-off_B66C
		dc.w loc_B710-off_B66C, loc_B760-off_B66C
		dc.w loc_B760-off_B66C, loc_B760-off_B66C
		dc.w loc_B7C6-off_B66C, loc_B7FA-off_B66C

byte_B67C:	dc.b 2, $20, 4, 0
		dc.b 4, $C, 5, 1
		dc.b 6, $10, 4, 3
		dc.b 8, $10, 3, 5
; ---------------------------------------------------------------------------

loc_B68C:
		move.l	#MapCapsule,4(a0)
		move.w	#$49D,2(a0)
		move.b	#4,1(a0)
		move.w	$C(a0),$30(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsl.w	#2,d0
		lea	byte_B67C(pc,d0.w),a1
		move.b	(a1)+,$24(a0)
		move.b	(a1)+,$18(a0)
		move.b	(a1)+,$19(a0)
		move.b	(a1)+,$1A(a0)
		cmpi.w	#8,d0
		bne.s	locret_B6D4
		move.b	#6,$20(a0)
		move.b	#8,$21(a0)

locret_B6D4:
		rts
; ---------------------------------------------------------------------------

loc_B6D6:
		cmpi.b	#2,(unk_FFF7A7).w
		beq.s	loc_B6F2
		move.w	#$2B,d1
		move.w	#$18,d2
		move.w	#$18,d3
		move.w	8(a0),d4
		bra.w	sub_A2BC
; ---------------------------------------------------------------------------

loc_B6F2:
		tst.b	$25(a0)
		beq.s	loc_B708
		clr.b	$25(a0)
		bclr	#3,(ObjectsList+$22).w
		bset	#1,(ObjectsList+$22).w

loc_B708:
		move.b	#2,$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_B710:
		move.w	#$17,d1
		move.w	#8,d2
		move.w	#8,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		lea	(AniCapsule).l,a1
		bsr.w	AnimateSprite
		move.w	$30(a0),$C(a0)
		tst.b	$25(a0)
		beq.s	locret_B75E
		addq.w	#8,$C(a0)
		move.b	#$A,$24(a0)
		move.w	#$3C,$1E(a0)
		clr.b	(byte_FFFE1E).w
		clr.b	$25(a0)
		bclr	#3,(ObjectsList+$22).w
		bset	#1,(ObjectsList+$22).w

locret_B75E:
		rts
; ---------------------------------------------------------------------------

loc_B760:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#7,d0
		bne.s	loc_B7A0
		bsr.w	ObjectLoad
		bne.s	loc_B7A0
		move.b	#$3F,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,8(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,$C(a1)

loc_B7A0:
		subq.w	#1,$1E(a0)
		bne.s	locret_B7C4
		move.b	#2,(unk_FFF7A7).w
		move.b	#$C,$24(a0)
		move.b	#9,$1A(a0)
		move.w	#$B4,$1E(a0)
		addi.w	#$20,$C(a0)

locret_B7C4:
		rts
; ---------------------------------------------------------------------------

loc_B7C6:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#7,d0
		bne.s	loc_B7E8
		bsr.w	ObjectLoad
		bne.s	loc_B7E8
		move.b	#$28,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)

loc_B7E8:
		subq.w	#1,$1E(a0)
		bne.s	locret_B7F8
		addq.b	#2,$24(a0)
		move.w	#$3C,$1E(a0)

locret_B7F8:
		rts
; ---------------------------------------------------------------------------

loc_B7FA:
		subq.w	#1,$1E(a0)
		bne.s	locret_B808
		bsr.w	sub_C81C
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

locret_B808:
		rts
; ---------------------------------------------------------------------------
		include "levels/shared/Capsule/Sprite.ani"
		include "levels/shared/Capsule/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjMotobug:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_B890(pc,d0.w),d1
		jmp	off_B890(pc,d1.w)
; ---------------------------------------------------------------------------

off_B890:	dc.w loc_B898-off_B890, loc_B8FA-off_B890, loc_B9D8-off_B890, loc_B9E6-off_B890
; ---------------------------------------------------------------------------

loc_B898:
		move.l	#MapMotobug,4(a0)
		move.w	#$4F0,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$14,$18(a0)
		tst.b	$1C(a0)
		bne.s	loc_B8F2
		move.b	#$E,$16(a0)
		move.b	#8,$17(a0)
		move.b	#$C,$20(a0)
		bsr.w	ObjectFall
		bsr.w	sub_105F0
		tst.w	d1
		bpl.s	locret_B8F0
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)
		bchg	#0,$22(a0)

locret_B8F0:
		rts
; ---------------------------------------------------------------------------

loc_B8F2:
		addq.b	#4,$24(a0)
		bra.w	loc_B9D8
; ---------------------------------------------------------------------------

loc_B8FA:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_B94E(pc,d0.w),d1
		jsr	off_B94E(pc,d1.w)
		lea	(AniMotobug).l,a1
		bsr.w	AnimateSprite

ObjectChkDespawn:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	loc_B938
		cmpi.w	#$280,d0
		bhi.w	loc_B938
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_B938:
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_B94A
		bclr	#7,2(a2,d0.w)

loc_B94A:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

off_B94E:	dc.w loc_B952-off_B94E, loc_B976-off_B94E
; ---------------------------------------------------------------------------

loc_B952:
		subq.w	#1,$30(a0)
		bpl.s	locret_B974
		addq.b	#2,$25(a0)
		move.w	#$FF00,$10(a0)
		move.b	#1,$1C(a0)
		bchg	#0,$22(a0)
		bne.s	locret_B974
		neg.w	$10(a0)

locret_B974:
		rts
; ---------------------------------------------------------------------------

loc_B976:
		bsr.w	ObjectMove
		bsr.w	sub_105F0
		cmpi.w	#$FFF8,d1
		blt.s	loc_B9C0
		cmpi.w	#$C,d1
		bge.s	loc_B9C0
		add.w	d1,$C(a0)
		subq.b	#1,$33(a0)
		bpl.s	locret_B9BE
		move.b	#$F,$33(a0)
		bsr.w	ObjectLoad
		bne.s	locret_B9BE
		move.b	#$40,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	$22(a0),$22(a1)
		move.b	#2,$1C(a1)

locret_B9BE:
		rts
; ---------------------------------------------------------------------------

loc_B9C0:
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------

loc_B9D8:
		lea	(AniMotobug).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_B9E6:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------
		include "levels/GHZ/Motobug/Sprite.ani"
		include "levels/GHZ/Motobug/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSpring:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_BAA0(pc,d0.w),d1
		jsr	off_BAA0(pc,d1.w)
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

off_BAA0:	dc.w loc_BAB8-off_BAA0, sub_BB2E-off_BAA0, loc_BB84-off_BAA0, sub_BB8E-off_BAA0, sub_BB9A-off_BAA0
		dc.w loc_BC1C-off_BAA0, sub_BC26-off_BAA0, loc_BC32-off_BAA0, loc_BC98-off_BAA0, loc_BCA2-off_BAA0

word_BAB4:	dc.w -$1000, -$A00
; ---------------------------------------------------------------------------

loc_BAB8:
		addq.b	#2,$24(a0)
		move.l	#MapSpring,4(a0)
		move.w	#$523,2(a0)
		ori.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#4,$19(a0)
		move.b	$28(a0),d0
		btst	#4,d0
		beq.s	loc_BB04
		move.b	#8,$24(a0)
		move.b	#1,$1C(a0)
		move.b	#3,$1A(a0)
		move.w	#$533,2(a0)
		move.b	#8,$18(a0)

loc_BB04:
		btst	#5,d0
		beq.s	loc_BB16
		move.b	#$E,$24(a0)
		bset	#1,$22(a0)

loc_BB16:
		btst	#1,d0
		beq.s	loc_BB22
		bset	#5,2(a0)

loc_BB22:
		andi.w	#$F,d0
		move.w	word_BAB4(pc,d0.w),$30(a0)
		rts
; ---------------------------------------------------------------------------

sub_BB2E:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		tst.b	$25(a0)
		bne.s	loc_BB4A
		rts
; ---------------------------------------------------------------------------

loc_BB4A:
		addq.b	#2,$24(a0)
		addq.w	#8,$C(a1)
		move.w	$30(a0),$12(a1)
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#$10,$1C(a1)
		move.b	#2,$24(a1)
		bclr	#3,$22(a0)
		clr.b	$25(a0)
		move.w	#$CC,d0
		jsr	(PlaySFX).l

loc_BB84:
		lea	(AniSpring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

sub_BB8E:
		move.b	#1,$1D(a0)
		subq.b	#4,$24(a0)
		rts
; ---------------------------------------------------------------------------

sub_BB9A:
		move.w	#$13,d1
		move.w	#$E,d2
		move.w	#$F,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		cmpi.b	#2,$24(a0)
		bne.s	loc_BBBC
		move.b	#8,$24(a0)

loc_BBBC:
		btst	#5,$22(a0)
		bne.s	loc_BBC6
		rts
; ---------------------------------------------------------------------------

loc_BBC6:
		addq.b	#2,$24(a0)
		move.w	$30(a0),$10(a1)
		addq.w	#8,8(a1)
		btst	#0,$22(a0)
		bne.s	loc_BBE6
		subi.w	#$10,8(a1)
		neg.w	$10(a1)

loc_BBE6:
		move.w	#$F,$3E(a1)
		move.w	$10(a1),$14(a1)
		bchg	#0,$22(a1)
		btst	#2,$22(a1)
		bne.s	loc_BC06
		move.b	#0,$1C(a1)

loc_BC06:
		bclr	#5,$22(a0)
		bclr	#5,$22(a1)
		move.w	#$CC,d0
		jsr	(PlaySFX).l

loc_BC1C:
		lea	(AniSpring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

sub_BC26:
		move.b	#2,$1D(a0)
		subq.b	#4,$24(a0)
		rts
; ---------------------------------------------------------------------------

loc_BC32:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		cmpi.b	#2,$24(a0)
		bne.s	loc_BC54
		move.b	#$E,$24(a0)

loc_BC54:
		tst.b	$25(a0)
		bne.s	locret_BC5E
		tst.w	d4
		bmi.s	loc_BC60

locret_BC5E:
		rts
; ---------------------------------------------------------------------------

loc_BC60:
		addq.b	#2,$24(a0)
		subq.w	#8,$C(a1)
		move.w	$30(a0),$12(a1)
		neg.w	$12(a1)
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#2,$24(a1)
		bclr	#3,$22(a0)
		clr.b	$25(a0)
		move.w	#$CC,d0
		jsr	(PlaySFX).l

loc_BC98:
		lea	(AniSpring).l,a1
		bra.w	AnimateSprite
; ---------------------------------------------------------------------------

loc_BCA2:
		move.b	#1,$1D(a0)
		subq.b	#4,$24(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels/shared/Spring/Sprite.ani"
		include "levels/shared/Spring/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjNewtron:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_BD26(pc,d0.w),d1
		jmp	off_BD26(pc,d1.w)
; ---------------------------------------------------------------------------

off_BD26:	dc.w loc_BD2C-off_BD26, loc_BD5C-off_BD26, loc_BEC6-off_BD26
; ---------------------------------------------------------------------------

loc_BD2C:
		addq.b	#2,$24(a0)
		move.l	#MapNewtron,4(a0)
		move.w	#$249B,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$14,$18(a0)
		move.b	#$10,$16(a0)
		move.b	#8,$17(a0)

loc_BD5C:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_BD78(pc,d0.w),d1
		jsr	off_BD78(pc,d1.w)
		lea	(AniNewtron).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_BD78:	dc.w loc_BD82-off_BD78, loc_BDC4-off_BD78, loc_BE38-off_BD78, loc_BE58-off_BD78, loc_BE5E-off_BD78
; ---------------------------------------------------------------------------

loc_BD82:
		bset	#0,$22(a0)
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_BD9A
		neg.w	d0
		bclr	#0,$22(a0)

loc_BD9A:
		cmpi.w	#$80,d0
		bcc.s	locret_BDC2
		addq.b	#2,$25(a0)
		move.b	#1,$1C(a0)
		tst.b	$28(a0)
		beq.s	locret_BDC2
		move.w	#$49B,2(a0)
		move.b	#8,$25(a0)
		move.b	#4,$1C(a0)

locret_BDC2:
		rts
; ---------------------------------------------------------------------------

loc_BDC4:
		cmpi.b	#4,$1A(a0)
		bcc.s	loc_BDE4
		bset	#0,$22(a0)
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bcc.s	locret_BDE2
		bclr	#0,$22(a0)

locret_BDE2:
		rts
; ---------------------------------------------------------------------------

loc_BDE4:
		cmpi.b	#1,$1A(a0)
		bne.s	loc_BDF2
		move.b	#$C,$20(a0)

loc_BDF2:
		bsr.w	ObjectFall
		bsr.w	sub_105F0
		tst.w	d1
		bpl.s	locret_BE36
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$25(a0)
		move.b	#2,$1C(a0)
		btst	#5,2(a0)
		beq.s	loc_BE1E
		addq.b	#1,$1C(a0)

loc_BE1E:
		move.b	#$D,$20(a0)
		move.w	#$200,$10(a0)
		btst	#0,$22(a0)
		bne.s	locret_BE36
		neg.w	$10(a0)

locret_BE36:
		rts
; ---------------------------------------------------------------------------

loc_BE38:
		bsr.w	ObjectMove

loc_BE3C:
		bsr.w	sub_105F0
		cmpi.w	#$FFF8,d1
		blt.s	loc_BE52
		cmpi.w	#$C,d1
		bge.s	loc_BE52
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_BE52:
		addq.b	#2,$25(a0)
		rts
; ---------------------------------------------------------------------------

loc_BE58:
		bsr.w	ObjectMove
		rts
; ---------------------------------------------------------------------------

loc_BE5E:
		cmpi.b	#1,$1A(a0)
		bne.s	loc_BE6C
		move.b	#$C,$20(a0)

loc_BE6C:
		cmpi.b	#2,$1A(a0)
		bne.s	locret_BEC4
		tst.b	$32(a0)
		bne.s	locret_BEC4
		move.b	#1,$32(a0)
		bsr.w	ObjectLoad
		bne.s	locret_BEC4
		move.b	#$23,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		subq.w	#8,$C(a1)
		move.w	#$200,$10(a1)
		move.w	#$14,d0
		btst	#0,$22(a0)
		bne.s	loc_BEB4
		neg.w	d0
		neg.w	$10(a1)

loc_BEB4:
		add.w	d0,8(a1)
		move.b	$22(a0),$22(a1)
		move.b	#1,$28(a1)

locret_BEC4:
		rts
; ---------------------------------------------------------------------------

loc_BEC6:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------
		include "levels/GHZ/Newtron/Sprite.ani"
		include "levels/GHZ/Newtron/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjRoller:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_BFB8(pc,d0.w),d1
		jmp	off_BFB8(pc,d1.w)
; ---------------------------------------------------------------------------

off_BFB8:	dc.w loc_BFBE-off_BFB8, loc_C00C-off_BFB8, loc_C0B0-off_BFB8
; ---------------------------------------------------------------------------

loc_BFBE:
		move.b	#$E,$16(a0)
		move.b	#8,$17(a0)
		bsr.w	ObjectFall
		bsr.w	sub_105F0
		tst.w	d1
		bpl.s	locret_C00A
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)
		move.l	#MapRoller,4(a0)
		move.w	#$24B8,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$10,$18(a0)
		move.b	#$8E,$20(a0)

locret_C00A:
		rts
; ---------------------------------------------------------------------------

loc_C00C:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_C028(pc,d0.w),d1
		jsr	off_C028(pc,d1.w)
		lea	(AniRoller).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_C028:	dc.w loc_C030-off_C028, loc_C052-off_C028, loc_C060-off_C028, loc_C08E-off_C028
; ---------------------------------------------------------------------------

loc_C030:
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bcs.s	locret_C050
		cmpi.w	#$20,d0
		bcc.s	locret_C050
		addq.b	#2,$25(a0)
		move.b	#1,$1C(a0)
		move.w	#$400,$10(a0)

locret_C050:
		rts
; ---------------------------------------------------------------------------

loc_C052:
		cmpi.b	#2,$1C(a0)
		bne.s	locret_C05E
		addq.b	#2,$25(a0)

locret_C05E:
		rts
; ---------------------------------------------------------------------------

loc_C060:
		bsr.w	ObjectMove
		bsr.w	sub_105F0
		cmpi.w	#$FFF8,d1
		blt.s	loc_C07A
		cmpi.w	#$C,d1
		bge.s	loc_C07A
		add.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_C07A:
		addq.b	#2,$25(a0)
		bset	#0,$32(a0)
		beq.s	locret_C08C
		move.w	#$FA00,$12(a0)

locret_C08C:
		rts
; ---------------------------------------------------------------------------

loc_C08E:
		bsr.w	ObjectFall
		tst.w	$12(a0)
		bmi.s	locret_C0AE
		bsr.w	sub_105F0
		tst.w	d1
		bpl.s	locret_C0AE
		add.w	d1,$C(a0)
		subq.b	#2,$25(a0)

loc_C0A8:
		move.w	#0,$12(a0)

locret_C0AE:
		rts
; ---------------------------------------------------------------------------

loc_C0B0:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------
		include "levels/shared/Roller/Sprite.ani"
		even
		include "levels/shared/Roller/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjWall:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_C10A(pc,d0.w),d1
		jmp	off_C10A(pc,d1.w)
; ---------------------------------------------------------------------------

off_C10A:	dc.w loc_C110-off_C10A, loc_C148-off_C10A, loc_C154-off_C10A
; ---------------------------------------------------------------------------

loc_C110:
		addq.b	#2,$24(a0)
		move.l	#MapWall,4(a0)
		move.w	#$434C,2(a0)
		ori.b	#4,1(a0)
		move.b	#8,$18(a0)
		move.b	#6,$19(a0)
		move.b	$28(a0),$1A(a0)
		bclr	#4,$1A(a0)
		beq.s	loc_C148
		addq.b	#2,$24(a0)
		bra.s	loc_C154
; ---------------------------------------------------------------------------

loc_C148:
		move.w	#$13,d1
		move.w	#$28,d2
		bsr.w	sub_6936

loc_C154:
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
		include "levels/GHZ/Wall/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjLavaMaker:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_C1D0(pc,d0.w),d1
		jsr	off_C1D0(pc,d1.w)
		bra.w	loc_C2E6
; ---------------------------------------------------------------------------

off_C1D0:	dc.w loc_C1DA-off_C1D0, loc_C1FA-off_C1D0

byte_C1D4:	dc.b $1E, $3C, $5A, $78, $96, $B4
; ---------------------------------------------------------------------------

loc_C1DA:
		addq.b	#2,$24(a0)
		move.b	$28(a0),d0
		lsr.w	#4,d0
		andi.w	#$F,d0
		move.b	byte_C1D4(pc,d0.w),$1F(a0)
		move.b	$1F(a0),$1E(a0)
		andi.b	#$F,$28(a0)

loc_C1FA:
		subq.b	#1,$1E(a0)
		bne.s	locret_C22A
		move.b	$1F(a0),$1E(a0)
		bsr.w	sub_89C6
		bne.s	locret_C22A
		bsr.w	ObjectLoad
		bne.s	locret_C22A
		move.b	#$14,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	$28(a0),$28(a1)

locret_C22A:
		rts
; ---------------------------------------------------------------------------

ObjLavaball:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_C23E(pc,d0.w),d1
		jsr	off_C23E(pc,d1.w)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

off_C23E:	dc.w loc_C254-off_C23E, loc_C2C8-off_C23E, j_ObjectDelete-off_C23E

word_C244:	dc.w $FC00, $FB00, $FA00, $F900, $FE00, $200, $FE00, $200
; ---------------------------------------------------------------------------

loc_C254:
		addq.b	#2,$24(a0)
		move.b	#8,$16(a0)
		move.b	#8,$17(a0)
		move.l	#MapLavaball,4(a0)
		move.w	#$345,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$8B,$20(a0)
		move.w	$C(a0),$30(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	word_C244(pc,d0.w),$12(a0)
		move.b	#8,$18(a0)
		cmpi.b	#6,$28(a0)
		bcs.s	loc_C2BE
		move.b	#$10,$18(a0)
		move.b	#2,$1C(a0)
		move.w	$12(a0),$10(a0)
		move.w	#0,$12(a0)

loc_C2BE:
		move.w	#$AE,d0
		jsr	(PlaySFX).l

loc_C2C8:
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	off_C306(pc,d0.w),d1
		jsr	off_C306(pc,d1.w)
		bsr.w	ObjectMove
		lea	(AniLavaball).l,a1
		bsr.w	AnimateSprite

loc_C2E6:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

off_C306:	dc.w loc_C318-off_C306, loc_C318-off_C306, loc_C318-off_C306, loc_C318-off_C306, loc_C340-off_C306
		dc.w loc_C362-off_C306, loc_C384-off_C306, loc_C3A8-off_C306, locret_C3CC-off_C306
; ---------------------------------------------------------------------------

loc_C318:
		addi.w	#$18,$12(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		bcc.s	loc_C32C
		addq.b	#2,$24(a0)

loc_C32C:
		bclr	#1,$22(a0)
		tst.w	$12(a0)
		bpl.s	locret_C33E
		bset	#1,$22(a0)

locret_C33E:
		rts
; ---------------------------------------------------------------------------

loc_C340:
		bset	#1,$22(a0)
		bsr.w	sub_10776
		tst.w	d1
		bpl.s	locret_C360
		move.b	#8,$28(a0)
		move.b	#1,$1C(a0)
		move.w	#0,$12(a0)

locret_C360:
		rts
; ---------------------------------------------------------------------------

loc_C362:
		bclr	#1,$22(a0)
		bsr.w	sub_105F0
		tst.w	d1
		bpl.s	locret_C382
		move.b	#8,$28(a0)
		move.b	#1,$1C(a0)
		move.w	#0,$12(a0)

locret_C382:
		rts
; ---------------------------------------------------------------------------

loc_C384:
		bset	#0,$22(a0)
		moveq	#$FFFFFFF8,d3
		bsr.w	sub_10844
		tst.w	d1
		bpl.s	locret_C3A6
		move.b	#8,$28(a0)
		move.b	#3,$1C(a0)
		move.w	#0,$10(a0)

locret_C3A6:
		rts
; ---------------------------------------------------------------------------

loc_C3A8:
		bclr	#0,$22(a0)
		moveq	#8,d3
		bsr.w	sub_106B2
		tst.w	d1
		bpl.s	locret_C3CA
		move.b	#8,$28(a0)
		move.b	#3,$1C(a0)
		move.w	#0,$10(a0)

locret_C3CA:
		rts
; ---------------------------------------------------------------------------

locret_C3CC:
		rts
; ---------------------------------------------------------------------------
; Attributes: thunk

j_ObjectDelete:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------
		include "levels/MZ/LavaBall/Sprite.ani"
		even
; ---------------------------------------------------------------------------

ObjMZBlocks:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_C3FC(pc,d0.w),d1
		jmp	off_C3FC(pc,d1.w)
; ---------------------------------------------------------------------------

off_C3FC:	dc.w loc_C400-off_C3FC, loc_C43C-off_C3FC
; ---------------------------------------------------------------------------

loc_C400:
		addq.b	#2,$24(a0)
		move.b	#$F,$16(a0)
		move.b	#$F,$17(a0)
		move.l	#MapMZBlocks,4(a0)
		move.w	#$4000,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		move.b	#$10,$18(a0)
		move.w	$C(a0),$30(a0)
		move.w	#$5C0,$32(a0)

loc_C43C:
		tst.b	1(a0)
		bpl.s	loc_C46A
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_C48E(pc,d0.w),d1
		jsr	off_C48E(pc,d1.w)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC

loc_C46A:
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

off_C48E:	dc.w locret_C498-off_C48E, loc_C4B2-off_C48E, loc_C49A-off_C48E, loc_C4D2-off_C48E
		dc.w loc_C50E-off_C48E
; ---------------------------------------------------------------------------

locret_C498:
		rts
; ---------------------------------------------------------------------------

loc_C49A:
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_C4A6
		neg.w	d0

loc_C4A6:
		cmpi.w	#$90,d0
		bcc.s	loc_C4B2
		move.b	#3,$28(a0)

loc_C4B2:
		moveq	#0,d0
		move.b	(oscValues+$16).w,d0
		btst	#3,$28(a0)
		beq.s	loc_C4C6
		neg.w	d0
		addi.w	#$10,d0

loc_C4C6:
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_C4D2:
		bsr.w	ObjectMove
		addi.w	#$18,$12(a0)
		bsr.w	sub_105F0
		tst.w	d1
		bpl.w	locret_C50C
		add.w	d1,$C(a0)
		clr.w	$12(a0)
		move.w	$C(a0),$30(a0)
		move.b	#4,$28(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2E8,d0
		bcc.s	locret_C50C
		move.b	#0,$28(a0)

locret_C50C:
		rts
; ---------------------------------------------------------------------------

loc_C50E:
		moveq	#0,d0

loc_C510:
		move.b	(oscValues+$12).w,d0
		lsr.w	#3,d0
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels/MZ/Blocks/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSceneryLamp:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_C538(pc,d0.w),d1
		jmp	off_C538(pc,d1.w)
; ---------------------------------------------------------------------------

off_C538:	dc.w loc_C53C-off_C538, loc_C560-off_C538
; ---------------------------------------------------------------------------

loc_C53C:
		addq.b	#2,$24(a0)
		move.l	#MapSceneryLamp,4(a0)
		move.w	#0,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#6,$19(a0)

loc_C560:
		subq.b	#1,$1E(a0)
		bpl.s	loc_C57E
		move.b	#7,$1E(a0)
		addq.b	#1,$1A(a0)
		cmpi.b	#6,$1A(a0)
		bcs.s	loc_C57E
		move.b	#0,$1A(a0)

loc_C57E:
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
		include "levels/SYZ/SceneryLamp/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjBumper:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_C5FE(pc,d0.w),d1
		jmp	off_C5FE(pc,d1.w)
; ---------------------------------------------------------------------------

off_C5FE:	dc.w loc_C602-off_C5FE, loc_C62C-off_C5FE
; ---------------------------------------------------------------------------

loc_C602:
		addq.b	#2,$24(a0)
		move.l	#MapBumper,4(a0)
		move.w	#$380,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#1,$19(a0)
		move.b	#$D7,$20(a0)

loc_C62C:
		tst.b	$21(a0)
		beq.s	loc_C684
		clr.b	$21(a0)
		lea	(ObjectsList).w,a1
		move.w	8(a0),d1
		move.w	$C(a0),d2
		sub.w	8(a1),d1
		sub.w	$C(a1),d2
		jsr	(GetAngle).l
		jsr	(GetSine).l
		muls.w	#$F900,d1
		asr.l	#8,d1
		move.w	d1,$10(a1)
		muls.w	#$F900,d0
		asr.l	#8,d0
		move.w	d0,$12(a1)
		bset	#1,$22(a1)
		clr.b	$3C(a1)
		move.b	#1,$1C(a0)
		move.w	#$B4,d0
		jsr	(PlaySFX).l

loc_C684:
		lea	(AniBumper).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0

loc_C6A8:
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
		include "levels/SYZ/Bumper/Sprite.ani"
		even
		include "levels/SYZ/Bumper/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSignpost:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_C726(pc,d0.w),d1
		jsr	off_C726(pc,d1.w)
		lea	(AniSignpost).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

off_C726:	dc.w loc_C72E-off_C726, loc_C752-off_C726, loc_C77C-off_C726, loc_C814-off_C726
; ---------------------------------------------------------------------------

loc_C72E:
		addq.b	#2,$24(a0)
		move.l	#MapSignpost,4(a0)
		move.w	#$680,2(a0)
		move.b	#4,1(a0)
		move.b	#$18,$18(a0)
		move.b	#4,$19(a0)

loc_C752:
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bcs.s	locret_C77A
		cmpi.w	#$20,d0
		bcc.s	locret_C77A
		move.w	#$CF,d0
		jsr	(PlayMusic).l
		clr.b	(byte_FFFE1E).w
		move.w	(unk_FFF72A).w,(unk_FFF728).w
		addq.b	#2,$24(a0)

locret_C77A:
		rts
; ---------------------------------------------------------------------------

loc_C77C:
		subq.w	#1,$30(a0)
		bpl.s	loc_C798
		move.w	#$3C,$30(a0)
		addq.b	#1,$1C(a0)
		cmpi.b	#3,$1C(a0)
		bne.s	loc_C798
		addq.b	#2,$24(a0)

loc_C798:
		subq.w	#1,$32(a0)
		bpl.s	locret_C802
		move.w	#$B,$32(a0)
		moveq	#0,d0
		move.b	$34(a0),d0
		addq.b	#2,$34(a0)
		andi.b	#$E,$34(a0)
		lea	byte_C804(pc,d0.w),a2
		bsr.w	ObjectLoad
		bne.s	locret_C802
		move.b	#$25,0(a1)
		move.b	#6,$24(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	8(a0),d0
		move.w	d0,8(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	$C(a0),d0
		move.w	d0,$C(a1)
		move.l	#$7F64,4(a1)
		move.w	#$27B2,2(a1)
		move.b	#4,1(a1)
		move.b	#2,$19(a1)
		move.b	#8,$18(a1)

locret_C802:
		rts
; ---------------------------------------------------------------------------

byte_C804:	dc.b $E8, $F0
		dc.b 8, 8
		dc.b $F0, 0
		dc.b $18, $F8
		dc.b 0, $F8
		dc.b $10, 0
		dc.b $E8, 8
		dc.b $18, $10
; ---------------------------------------------------------------------------

loc_C814:
		tst.w	(DebugRoutine).w
		bne.w	locret_C880
; ---------------------------------------------------------------------------

sub_C81C:
		tst.b	(byte_FFD600).w
		bne.s	locret_C880
		move.w	(unk_FFF72A).w,(unk_FFF728).w
		clr.b	(byte_FFFE2D).w
		clr.b	(byte_FFFE1E).w
		move.b	#$3A,(byte_FFD600).w
		moveq	#$10,d0
		jsr	(plcReplace).l
		move.b	#1,(byte_FFFE58).w
		moveq	#0,d0
		move.b	(dword_FFFE22+1).w,d0
		mulu.w	#$3C,d0
		moveq	#0,d1
		move.b	(dword_FFFE22+2).w,d1
		add.w	d1,d0
		divu.w	#$F,d0
		moveq	#$14,d1
		cmp.w	d1,d0
		bcs.s	loc_C862
		move.w	d1,d0

loc_C862:
		add.w	d0,d0
		move.w	word_C882(pc,d0.w),(word_FFFE54).w
		move.w	(Rings).w,d0
		mulu.w	#$A,d0
		move.w	d0,(word_FFFE56).w
		move.w	#$8E,d0
		jsr	(PlaySFX).l

locret_C880:
		rts
; ---------------------------------------------------------------------------

word_C882:	dc.w $1388, $3E8, $1F4, $190, $12C, $12C, $C8, $C8, $64
		dc.w $64, $64, $64, $32, $32, $32, $32, $A, $A, $A, $A
		dc.w 0
		include "levels/shared/Signpost/Sprite.ani"
		include "levels/shared/Signpost/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjLavafallMalker:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_C926(pc,d0.w),d1
		jsr	off_C926(pc,d1.w)
		bra.w	loc_CB28
; ---------------------------------------------------------------------------

off_C926:	dc.w loc_C932-off_C926, loc_C95C-off_C926, loc_C9CE-off_C926, loc_C982-off_C926, loc_C9DA-off_C926
		dc.w loc_C9EA-off_C926
; ---------------------------------------------------------------------------

loc_C932:
		addq.b	#2,$24(a0)
		move.l	#MapLavafall,4(a0)
		move.w	#$E3A8,2(a0)
		move.b	#4,1(a0)
		move.b	#1,$19(a0)
		move.b	#$38,$18(a0)
		move.w	#$78,$34(a0)

loc_C95C:
		subq.w	#1,$32(a0)
		bpl.s	locret_C980
		move.w	$34(a0),$32(a0)
		move.w	(ObjectsList+$C).w,d0
		move.w	$C(a0),d1
		cmp.w	d1,d0
		bcc.s	locret_C980
		subi.w	#$170,d1
		cmp.w	d1,d0
		bcs.s	locret_C980
		addq.b	#2,$24(a0)

locret_C980:
		rts
; ---------------------------------------------------------------------------

loc_C982:
		addq.b	#2,$24(a0)
		bsr.w	LoadNextObject
		bne.s	loc_C9A8
		move.b	#$4D,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	$28(a0),$28(a1)
		move.l	a0,$3C(a1)

loc_C9A8:
		move.b	#1,$1C(a0)
		tst.b	$28(a0)
		beq.s	loc_C9BC
		move.b	#4,$1C(a0)
		bra.s	loc_C9DA
; ---------------------------------------------------------------------------

loc_C9BC:
		movea.l	$3C(a0),a1
		bset	#1,$22(a1)
		move.w	#$FA80,$12(a1)
		bra.s	loc_C9DA
; ---------------------------------------------------------------------------

loc_C9CE:
		tst.b	$28(a0)
		beq.s	loc_C9DA
		addq.b	#2,$24(a0)
		rts
; ---------------------------------------------------------------------------

loc_C9DA:
		lea	(AniLavaFallMaker).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectDisplay
		rts
; ---------------------------------------------------------------------------

loc_C9EA:
		move.b	#0,$1C(a0)
		move.b	#2,$24(a0)
		tst.b	$28(a0)
		beq.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjLavafall:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_CA12(pc,d0.w),d1
		jsr	off_CA12(pc,d1.w)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

off_CA12:	dc.w loc_CA1E-off_CA12, loc_CB0A-off_CA12, sub_CB8C-off_CA12, loc_CBEA-off_CA12

word_CA1A:	dc.w $FB00, 0
; ---------------------------------------------------------------------------

loc_CA1E:
		addq.b	#2,$24(a0)
		move.w	$C(a0),$30(a0)
		tst.b	$28(a0)
		beq.s	loc_CA34
		subi.w	#$250,$C(a0)

loc_CA34:
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	word_CA1A(pc,d0.w),$12(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bsr.s	sub_CA50
		bra.s	loc_CAA0
; ---------------------------------------------------------------------------

sub_CA4A:
		bsr.w	LoadNextObject
		bne.s	loc_CA9A
; ---------------------------------------------------------------------------

sub_CA50:
		move.b	#$4D,0(a1)
		move.l	#MapLavafall,4(a1)
		move.w	#$63A8,2(a1)
		move.b	#4,1(a1)
		move.b	#$20,$18(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	$28(a0),$28(a1)
		move.b	#1,$19(a1)
		move.b	#5,$1C(a1)
		tst.b	$28(a0)
		beq.s	loc_CA9A
		move.b	#2,$1C(a1)

loc_CA9A:
		dbf	d1,sub_CA4A
		rts
; ---------------------------------------------------------------------------

loc_CAA0:
		addi.w	#$60,$C(a1)
		move.w	$30(a0),$30(a1)
		addi.w	#$60,$30(a1)
		move.b	#$93,$20(a1)
		move.b	#$80,$16(a1)
		bset	#4,1(a1)
		addq.b	#4,$24(a1)
		move.l	a0,$3C(a1)
		tst.b	$28(a0)
		beq.s	loc_CB00
		moveq	#0,d1
		bsr.w	sub_CA4A
		addq.b	#2,$24(a1)
		bset	#4,2(a1)
		addi.w	#$100,$C(a1)
		move.b	#0,$19(a1)
		move.w	$30(a0),$30(a1)
		move.l	$3C(a0),$3C(a1)
		move.b	#0,$28(a0)

loc_CB00:
		move.w	#$C8,d0
		jsr	(PlaySFX).l

loc_CB0A:
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		move.w	off_CB48(pc,d0.w),d1
		jsr	off_CB48(pc,d1.w)
		bsr.w	ObjectMove
		lea	(AniLavaFallMaker).l,a1
		bsr.w	AnimateSprite

loc_CB28:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

off_CB48:	dc.w loc_CB4C-off_CB48, loc_CB6C-off_CB48
; ---------------------------------------------------------------------------

loc_CB4C:
		addi.w	#$18,$12(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		bcc.s	locret_CB6A
		addq.b	#4,$24(a0)
		movea.l	$3C(a0),a1
		move.b	#3,$1C(a1)

locret_CB6A:
		rts
; ---------------------------------------------------------------------------

loc_CB6C:
		addi.w	#$18,$12(a0)
		move.w	$30(a0),d0
		cmp.w	$C(a0),d0
		bcc.s	locret_CB8A
		addq.b	#4,$24(a0)
		movea.l	$3C(a0),a1
		move.b	#1,$1C(a1)

locret_CB8A:
		rts
; ---------------------------------------------------------------------------

sub_CB8C:
		movea.l	$3C(a0),a1
		cmpi.b	#6,$24(a1)
		beq.w	loc_CBEA
		move.w	$C(a1),d0
		addi.w	#$60,d0
		move.w	d0,$C(a0)
		sub.w	$30(a0),d0
		neg.w	d0
		moveq	#8,d1
		cmpi.w	#$40,d0
		bge.s	loc_CBB6
		moveq	#$B,d1

loc_CBB6:
		cmpi.w	#$80,d0
		ble.s	loc_CBBE
		moveq	#$E,d1

loc_CBBE:
		subq.b	#1,$1E(a0)
		bpl.s	loc_CBDC
		move.b	#7,$1E(a0)
		addq.b	#1,$1B(a0)
		cmpi.b	#2,$1B(a0)
		bcs.s	loc_CBDC
		move.b	#0,$1B(a0)

loc_CBDC:
		move.b	$1B(a0),d0
		add.b	d1,d0
		move.b	d0,$1A(a0)
		bra.w	loc_CB28
; ---------------------------------------------------------------------------

loc_CBEA:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

ObjLavaChase:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_CBFC(pc,d0.w),d1
		jmp	off_CBFC(pc,d1.w)
; ---------------------------------------------------------------------------

off_CBFC:	dc.w loc_CC06-off_CBFC, loc_CC66-off_CBFC, loc_CCA2-off_CBFC, loc_CD00-off_CBFC, loc_CD1C-off_CBFC
; ---------------------------------------------------------------------------

loc_CC06:
		addq.b	#2,$24(a0)
		movea.l	a0,a1
		moveq	#1,d1
		bra.s	loc_CC16
; ---------------------------------------------------------------------------

loc_CC10:
		bsr.w	LoadNextObject
		bne.s	loc_CC58

loc_CC16:
		move.b	#$4E,0(a1)
		move.l	#MapLavaChase,4(a1)
		move.w	#$63A8,2(a1)
		move.b	#4,1(a1)
		move.b	#$50,$18(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	#1,$19(a1)
		move.b	#0,$1C(a1)
		move.b	#$94,$20(a1)
		move.l	a0,$3C(a1)

loc_CC58:
		dbf	d1,loc_CC10
		addq.b	#6,$24(a1)
		move.b	#4,$1A(a1)

loc_CC66:
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_CC72
		neg.w	d0

loc_CC72:
		cmpi.w	#$E0,d0
		bcc.s	loc_CC92
		move.w	(ObjectsList+$C).w,d0
		sub.w	$C(a0),d0
		bcc.s	loc_CC84
		neg.w	d0

loc_CC84:
		cmpi.w	#$60,d0
		bcc.s	loc_CC92
		move.b	#1,$36(a0)
		bra.s	loc_CCA2
; ---------------------------------------------------------------------------

loc_CC92:
		tst.b	$36(a0)
		beq.s	loc_CCA2
		move.w	#$100,$10(a0)
		addq.b	#2,$24(a0)

loc_CCA2:
		cmpi.w	#$6A0,8(a0)
		bne.s	loc_CCB2
		clr.w	$10(a0)
		clr.b	$36(a0)

loc_CCB2:
		lea	(AniLavaChase).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectMove
		bsr.w	ObjectDisplay
		tst.b	$36(a0)
		bne.s	locret_CCE6
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.s	loc_CCE8

locret_CCE6:
		rts
; ---------------------------------------------------------------------------

loc_CCE8:
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		bclr	#7,2(a2,d0.w)
		move.b	#8,$24(a0)
		rts
; ---------------------------------------------------------------------------

loc_CD00:
		movea.l	$3C(a0),a1
		cmpi.b	#8,$24(a1)
		beq.s	loc_CD1C
		move.w	8(a1),8(a0)
		subi.w	#$80,8(a0)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_CD1C:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

ObjLavaHurt:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_CD2E(pc,d0.w),d1
		jmp	off_CD2E(pc,d1.w)
; ---------------------------------------------------------------------------

off_CD2E:	dc.w loc_CD36-off_CD2E, loc_CD6C-off_CD2E

byte_CD32:	dc.b $96, $94, $95, 0
; ---------------------------------------------------------------------------

loc_CD36:
		addq.b	#2,$24(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		move.b	byte_CD32(pc,d0.w),$20(a0)
		move.l	#MapLavaHurt,4(a0)
		move.w	#$8680,2(a0)
		move.b	#4,1(a0)
		move.b	#$80,$18(a0)
		move.b	#4,$19(a0)
		move.b	$28(a0),$1A(a0)

loc_CD6C:
		tst.w	(DebugRoutine).w
		beq.s	loc_CD76
		bsr.w	ObjectDisplay

loc_CD76:
		cmpi.b	#6,(ObjectsList+$24).w
		bcc.s	loc_CD84
		bset	#7,1(a0)

loc_CD84:
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	ObjectDelete
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
		include "levels/MZ/LavaHurt/Sprite.map"
		include "levels/MZ/LavaFall/Maker.ani"
		include "levels/MZ/LavaChase/Sprite.ani"
		include "levels/MZ/LavaFall/Sprite.map"
		include "levels/MZ/LavaChase/Sprite.map"
		even
; ---------------------------------------------------------------------------

Obj4F:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_D202(pc,d0.w),d1
		jmp	off_D202(pc,d1.w)
; ---------------------------------------------------------------------------

off_D202:	dc.w loc_D20A-off_D202, loc_D246-off_D202, loc_D274-off_D202, loc_D2C8-off_D202
; ---------------------------------------------------------------------------

loc_D20A:
		addq.b	#2,$24(a0)
		move.l	#Map4F,4(a0)
		move.w	#$24E4,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$C,$18(a0)
		move.b	#$14,$16(a0)
		move.b	#2,$20(a0)
		tst.b	$28(a0)
		beq.s	loc_D246
		move.w	#$300,d2
		bra.s	loc_D24A
; ---------------------------------------------------------------------------

loc_D246:
		move.w	#$E0,d2

loc_D24A:
		move.w	#$100,d1
		bset	#0,1(a0)
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_D268
		neg.w	d0
		neg.w	d1
		bclr	#0,1(a0)

loc_D268:
		cmp.w	d2,d0
		bcc.s	loc_D274
		move.w	d1,$10(a0)
		addq.b	#2,$24(a0)

loc_D274:
		bsr.w	ObjectFall
		move.b	#1,$1A(a0)
		tst.w	$12(a0)
		bmi.s	loc_D2AE
		move.b	#0,$1A(a0)
		bsr.w	sub_105F0
		tst.w	d1
		bpl.s	loc_D2AE
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$2D2,d0
		bcs.s	loc_D2A4
		addq.b	#2,$24(a0)
		bra.s	loc_D2AE
; ---------------------------------------------------------------------------

loc_D2A4:
		add.w	d1,$C(a0)
		move.w	#$FC00,$12(a0)

loc_D2AE:
		bsr.w	sub_D2DA
		beq.s	loc_D2C4
		neg.w	$10(a0)
		bchg	#0,1(a0)
		bchg	#0,$22(a0)

loc_D2C4:
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

loc_D2C8:
		bsr.w	ObjectFall
		bsr.w	ObjectDisplay
		tst.b	1(a0)
		bpl.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

sub_D2DA:
		move.w	(LevelFrames).w,d0
		add.w	d7,d0
		andi.w	#3,d0
		bne.s	loc_D308
		moveq	#0,d3
		move.b	$18(a0),d3
		tst.w	$10(a0)
		bmi.s	loc_D2FE
		bsr.w	sub_106B2
		tst.w	d1
		bpl.s	loc_D308

loc_D2FA:
		moveq	#1,d0
		rts
; ---------------------------------------------------------------------------

loc_D2FE:
		not.w	d3
		bsr.w	sub_10844
		tst.w	d1
		bmi.s	loc_D2FA

loc_D308:
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------
		include "unknown/Map4F.map"
		even
; ---------------------------------------------------------------------------

ObjYardin:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_D334(pc,d0.w),d1
		jmp	off_D334(pc,d1.w)
; ---------------------------------------------------------------------------

off_D334:	dc.w loc_D338-off_D334, loc_D38C-off_D334
; ---------------------------------------------------------------------------

loc_D338:
		move.l	#MapYardin,4(a0)
		move.w	#$247B,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$14,$18(a0)
		move.b	#$11,$16(a0)
		move.b	#8,$17(a0)
		move.b	#$CC,$20(a0)
		bsr.w	ObjectFall
		bsr.w	sub_105F0
		tst.w	d1
		bpl.s	locret_D38A
		add.w	d1,$C(a0)
		move.w	#0,$12(a0)
		addq.b	#2,$24(a0)
		bchg	#0,$22(a0)

locret_D38A:
		rts
; ---------------------------------------------------------------------------

loc_D38C:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_D3A8(pc,d0.w),d1
		jsr	off_D3A8(pc,d1.w)
		lea	(AniYardin).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_D3A8:	dc.w loc_D3AC-off_D3A8, loc_D3D0-off_D3A8
; ---------------------------------------------------------------------------

loc_D3AC:
		subq.w	#1,$30(a0)
		bpl.s	locret_D3CE
		addq.b	#2,$25(a0)
		move.w	#$FF00,$10(a0)
		move.b	#1,$1C(a0)
		bchg	#0,$22(a0)
		bne.s	locret_D3CE
		neg.w	$10(a0)

locret_D3CE:
		rts
; ---------------------------------------------------------------------------

loc_D3D0:
		bsr.w	ObjectMove
		bsr.w	sub_105F0
		cmpi.w	#$FFF8,d1
		blt.s	loc_D3F0
		cmpi.w	#$C,d1
		bge.s	loc_D3F0
		add.w	d1,$C(a0)
		bsr.w	sub_D2DA
		bne.s	loc_D3F0
		rts
; ---------------------------------------------------------------------------

loc_D3F0:
		subq.b	#2,$25(a0)
		move.w	#$3B,$30(a0)
		move.w	#0,$10(a0)
		move.b	#0,$1C(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels/shared/Yardin/Sprite.ani"
		include "levels/shared/Yardin/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSmashBlock:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_D4D4(pc,d0.w),d1
		jsr	off_D4D4(pc,d1.w)
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_D4D4:	dc.w loc_D4DA-off_D4D4, loc_D504-off_D4D4, loc_D580-off_D4D4
; ---------------------------------------------------------------------------

loc_D4DA:
		addq.b	#2,$24(a0)
		move.l	#MapSmashBlock,4(a0)
		move.w	#$42B8,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#4,$19(a0)
		move.b	$28(a0),$1A(a0)

loc_D504:
		move.b	(ObjectsList+$1C).w,$32(a0)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		btst	#3,$22(a0)
		bne.s	loc_D528

locret_D526:
		rts
; ---------------------------------------------------------------------------

loc_D528:
		cmpi.b	#2,$32(a0)
		bne.s	locret_D526
		bset	#2,$22(a1)
		move.b	#$E,$16(a1)
		move.b	#7,$17(a1)
		move.b	#2,$1C(a1)
		move.w	#$FD00,$12(a1)
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#2,$24(a1)
		bclr	#3,$22(a0)
		clr.b	$25(a0)
		move.b	#1,$1A(a0)
		lea	(ObjSmashBlock_Frag).l,a4
		moveq	#3,d1
		move.w	#$38,d2
		bsr.w	ObjectFragment

loc_D580:
		bsr.w	ObjectMove
		addi.w	#$38,$12(a0)
		bsr.w	ObjectDisplay
		tst.b	1(a0)
		bpl.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

ObjSmashBlock_Frag:dc.w $FE00, $FE00, $FF00, $FF00, $200, $FE00, $100, $FF00
		include "levels/GHZ/SmashBlock/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjMovingPtfm:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_D5FC(pc,d0.w),d1
		jsr	off_D5FC(pc,d1.w)
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

off_D5FC:	dc.w loc_D606-off_D5FC, loc_D648-off_D5FC, loc_D658-off_D5FC

byte_D602:	dc.b $10, 0
		dc.b $20, 1
; ---------------------------------------------------------------------------

loc_D606:
		addq.b	#2,$24(a0)
		move.l	#MapMovingPtfm,4(a0)
		move.w	#$42B8,2(a0)
		move.b	#4,1(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	byte_D602(pc,d0.w),a2
		move.b	(a2)+,$18(a0)
		move.b	(a2)+,$1A(a0)
		move.b	#4,$19(a0)
		move.w	8(a0),$32(a0)
		move.w	$C(a0),$30(a0)

loc_D648:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmNormal).l
		bra.w	sub_D674
; ---------------------------------------------------------------------------

loc_D658:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmCheckExit).l
		move.w	8(a0),-(sp)
		bsr.w	sub_D674
		move.w	(sp)+,d2
		jmp	(ptfmSurfaceNormal).l
; ---------------------------------------------------------------------------

sub_D674:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_D688(pc,d0.w),d1
		jmp	off_D688(pc,d1.w)
; ---------------------------------------------------------------------------

off_D688:	dc.w locret_D690-off_D688, loc_D692-off_D688, loc_D6B2-off_D688, loc_D6C0-off_D688
; ---------------------------------------------------------------------------

locret_D690:
		rts
; ---------------------------------------------------------------------------

loc_D692:
		move.b	(oscValues+$E).w,d0
		subi.b	#$60,d1
		btst	#0,$22(a0)
		beq.s	loc_D6A6
		neg.w	d0
		add.w	d1,d0

loc_D6A6:
		move.w	$32(a0),d1
		sub.w	d0,d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_D6B2:
		cmpi.b	#4,$24(a0)
		bne.s	locret_D6BE
		addq.b	#1,$28(a0)

locret_D6BE:
		rts
; ---------------------------------------------------------------------------

loc_D6C0:
		moveq	#0,d3
		move.b	$18(a0),d3
		bsr.w	sub_106B2
		tst.w	d1
		bmi.s	loc_D6DA
		addq.w	#1,8(a0)
		move.w	8(a0),$32(a0)
		rts
; ---------------------------------------------------------------------------

loc_D6DA:
		clr.b	$28(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels/GHZ/MovingPtfm/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjBasaran:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_D704(pc,d0.w),d1
		jmp	off_D704(pc,d1.w)
; ---------------------------------------------------------------------------

off_D704:	dc.w loc_D708-off_D704, loc_D738-off_D704
; ---------------------------------------------------------------------------

loc_D708:
		addq.b	#2,$24(a0)
		move.l	#MapBasaran,4(a0)
		move.w	#$84B8,2(a0)
		move.b	#4,1(a0)
		move.b	#$C,$16(a0)
		move.b	#2,$19(a0)
		move.b	#$B,$20(a0)
		move.b	#$10,$18(a0)

loc_D738:
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	off_D754(pc,d0.w),d1
		jsr	off_D754(pc,d1.w)
		lea	(AniBasaran).l,a1
		bsr.w	AnimateSprite
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_D754:	dc.w loc_D75C-off_D754, sub_D798-off_D754, sub_D7DA-off_D754, sub_D816-off_D754
; ---------------------------------------------------------------------------

loc_D75C:
		move.w	#$80,d2
		bsr.w	sub_D844
		bcc.s	locret_D796
		move.w	(ObjectsList+$C).w,d0
		move.w	d0,$36(a0)
		sub.w	$C(a0),d0
		bcs.s	locret_D796
		cmpi.w	#$80,d0
		bcc.s	locret_D796
		tst.w	(DebugRoutine).w
		bne.s	locret_D796
		move.b	(byte_FFFE0F).w,d0
		add.b	d7,d0
		andi.b	#7,d0
		bne.s	locret_D796
		move.b	#1,$1C(a0)
		addq.b	#2,$25(a0)

locret_D796:
		rts
; ---------------------------------------------------------------------------

sub_D798:
		bsr.w	ObjectMove
		addi.w	#$18,$12(a0)
		move.w	#$80,d2
		bsr.w	sub_D844
		move.w	$36(a0),d0
		sub.w	$C(a0),d0
		bcs.s	loc_D7D0
		cmpi.w	#$10,d0
		bcc.s	locret_D7CE
		move.w	d1,$10(a0)
		move.w	#0,$12(a0)
		move.b	#2,$1C(a0)
		addq.b	#2,$25(a0)

locret_D7CE:
		rts
; ---------------------------------------------------------------------------

loc_D7D0:
		tst.b	1(a0)
		bpl.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

sub_D7DA:
		move.b	(byte_FFFE0F).w,d0
		andi.b	#$F,d0
		bne.s	loc_D7EE
		move.w	#$C0,d0
		jsr	(PlaySFX).l

loc_D7EE:
		bsr.w	ObjectMove
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_D7FE
		neg.w	d0

loc_D7FE:
		cmpi.w	#$80,d0
		bcs.s	locret_D814
		move.b	(byte_FFFE0F).w,d0
		add.b	d7,d0
		andi.b	#7,d0
		bne.s	locret_D814
		addq.b	#2,$25(a0)

locret_D814:
		rts
; ---------------------------------------------------------------------------

sub_D816:
		bsr.w	ObjectMove
		subi.w	#$18,$12(a0)
		bsr.w	sub_10776
		tst.w	d1
		bpl.s	locret_D842
		sub.w	d1,$C(a0)
		andi.w	#$FFF8,8(a0)
		clr.w	$10(a0)
		clr.w	$12(a0)
		clr.b	$1C(a0)
		clr.b	$25(a0)

locret_D842:
		rts
; ---------------------------------------------------------------------------

sub_D844:
		move.w	#$100,d1
		bset	#0,$22(a0)
		move.w	(ObjectsList+8).w,d0
		sub.w	8(a0),d0
		bcc.s	loc_D862
		neg.w	d0
		neg.w	d1
		bclr	#0,$22(a0)

loc_D862:
		cmp.w	d2,d0
		rts
; ---------------------------------------------------------------------------
		bsr.w	ObjectMove
		bsr.w	ObjectDisplay
		tst.b	1(a0)
		bpl.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
		include "levels/MZ/Basaran/Sprite.ani"
		include "levels/MZ/Basaran/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjMovingBlocks:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_D8E2(pc,d0.w),d1
		jmp	off_D8E2(pc,d1.w)
; ---------------------------------------------------------------------------

off_D8E2:	dc.w loc_D8F2-off_D8E2, loc_D9AC-off_D8E2

byte_D8E6:	dc.b $10, $10
		dc.b $20, $20
		dc.b $10, $20
		dc.b $20, $1A
		dc.b $10, $27
		dc.b $10, $10
; ---------------------------------------------------------------------------

loc_D8F2:
		addq.b	#2,$24(a0)
		move.l	#MapMovingBlocks,4(a0)
		move.w	#$4000,2(a0)
		cmpi.b	#3,(level).w
		bne.s	loc_D912
		move.w	#$4480,2(a0)

loc_D912:
		move.b	#4,1(a0)
		move.b	#3,$19(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		lsr.w	#3,d0
		andi.w	#$E,d0
		lea	byte_D8E6(pc,d0.w),a2
		move.b	(a2)+,$18(a0)
		move.b	(a2),$16(a0)
		lsr.w	#1,d0
		move.b	d0,$1A(a0)
		move.w	8(a0),$34(a0)
		move.w	$C(a0),$30(a0)
		moveq	#0,d0
		move.b	(a2),d0
		add.w	d0,d0
		move.w	d0,$3A(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		subq.w	#8,d0
		bcs.s	loc_D974
		lsl.w	#2,d0
		lea	((oscValues+$2C)).w,a2
		lea	(a2,d0.w),a2
		tst.w	(a2)
		bpl.s	loc_D974
		bchg	#0,$22(a0)

loc_D974:
		move.b	$28(a0),d0
		bpl.s	loc_D9AC
		andi.b	#$F,d0
		move.b	d0,$3C(a0)
		move.b	#5,$28(a0)
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_D9AC
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		beq.s	loc_D9AC
		move.b	#6,$28(a0)
		clr.w	$3A(a0)

loc_D9AC:
		move.w	8(a0),-(sp)
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_DA08(pc,d0.w),d1
		jsr	off_DA08(pc,d1.w)
		move.w	(sp)+,d4
		tst.b	1(a0)
		bpl.s	loc_D9E4
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	$16(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		bsr.w	sub_A2BC

loc_D9E4:
		bsr.w	ObjectDisplay
		move.w	$34(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------

off_DA08:	dc.w locret_DA20-off_DA08, loc_DA22-off_DA08, loc_DA2E-off_DA08, loc_DA50-off_DA08
		dc.w loc_DA5C-off_DA08, loc_DA7C-off_DA08, loc_DAD0-off_DA08, loc_DB2A-off_DA08, loc_DB5C-off_DA08
		dc.w loc_DB6E-off_DA08, loc_DB7E-off_DA08, loc_DB8E-off_DA08
; ---------------------------------------------------------------------------

locret_DA20:
		rts
; ---------------------------------------------------------------------------

loc_DA22:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(oscValues+$A).w,d0
		bra.s	loc_DA38
; ---------------------------------------------------------------------------

loc_DA2E:
		move.w	#$80,d1
		moveq	#0,d0
		move.b	(oscValues+$1E).w,d0

loc_DA38:
		btst	#0,$22(a0)
		beq.s	loc_DA44
		neg.w	d0
		add.w	d1,d0

loc_DA44:
		move.w	$34(a0),d1
		sub.w	d0,d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_DA50:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(oscValues+$A).w,d0
		bra.s	loc_DA62
; ---------------------------------------------------------------------------

loc_DA5C:
		moveq	#0,d0
		move.b	(oscValues+$1E).w,d0

loc_DA62:
		btst	#0,$22(a0)
		beq.s	loc_DA70
		neg.w	d0
		addi.w	#$80,d0

loc_DA70:
		move.w	$30(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DA7C:
		tst.b	$38(a0)
		bne.s	loc_DA9A
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$3C(a0),d0
		btst	#0,(a2,d0.w)
		beq.s	loc_DAA4
		move.b	#1,$38(a0)

loc_DA9A:
		tst.w	$3A(a0)
		beq.s	loc_DAB4
		subq.w	#2,$3A(a0)

loc_DAA4:
		move.w	$3A(a0),d0
		move.w	$30(a0),d1
		add.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DAB4:
		addq.b	#1,$28(a0)
		clr.b	$38(a0)
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_DAA4
		bset	#0,2(a2,d0.w)
		bra.s	loc_DAA4
; ---------------------------------------------------------------------------

loc_DAD0:
		tst.b	$38(a0)
		bne.s	loc_DAEC
		lea	(unk_FFF7E0).w,a2
		moveq	#0,d0
		move.b	$3C(a0),d0
		tst.b	(a2,d0.w)
		bpl.s	loc_DAFE
		move.b	#1,$38(a0)

loc_DAEC:
		moveq	#0,d0
		move.b	$16(a0),d0
		add.w	d0,d0
		cmp.w	$3A(a0),d0
		beq.s	loc_DB0E
		addq.w	#2,$3A(a0)

loc_DAFE:
		move.w	$3A(a0),d0
		move.w	$30(a0),d1
		add.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DB0E:
		subq.b	#1,$28(a0)
		clr.b	$38(a0)
		lea	(byte_FFFC00).w,a2
		moveq	#0,d0
		move.b	$23(a0),d0
		beq.s	loc_DAFE
		bclr	#0,2(a2,d0.w)
		bra.s	loc_DAFE
; ---------------------------------------------------------------------------

loc_DB2A:
		tst.b	$38(a0)
		bne.s	loc_DB40
		tst.b	(unk_FFF7EF).w
		beq.s	locret_DB5A
		move.b	#1,$38(a0)
		clr.w	$3A(a0)

loc_DB40:
		addq.w	#1,8(a0)
		move.w	8(a0),$34(a0)
		addq.w	#1,$3A(a0)
		cmpi.w	#$380,$3A(a0)
		bne.s	locret_DB5A
		clr.b	$28(a0)

locret_DB5A:
		rts
; ---------------------------------------------------------------------------

loc_DB5C:
		move.w	#$10,d1
		moveq	#0,d0
		move.b	(oscValues+$2A).w,d0
		lsr.w	#1,d0
		move.w	(oscValues+$2C).w,d3
		bra.s	loc_DB9C
; ---------------------------------------------------------------------------

loc_DB6E:
		move.w	#$30,d1
		moveq	#0,d0
		move.b	(oscValues+$2E).w,d0
		move.w	(oscValues+$30).w,d3
		bra.s	loc_DB9C
; ---------------------------------------------------------------------------

loc_DB7E:
		move.w	#$50,d1
		moveq	#0,d0
		move.b	(oscValues+$32).w,d0
		move.w	(oscValues+$34).w,d3
		bra.s	loc_DB9C
; ---------------------------------------------------------------------------

loc_DB8E:
		move.w	#$70,d1
		moveq	#0,d0
		move.b	(oscValues+$36).w,d0
		move.w	(oscValues+$38).w,d3

loc_DB9C:
		tst.w	d3
		bne.s	loc_DBAA
		addq.b	#1,$22(a0)
		andi.b	#3,$22(a0)

loc_DBAA:
		move.b	$22(a0),d2
		andi.b	#3,d2
		bne.s	loc_DBCA
		sub.w	d1,d0
		add.w	$34(a0),d0
		move.w	d0,8(a0)
		neg.w	d1
		add.w	$30(a0),d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DBCA:
		subq.b	#1,d2
		bne.s	loc_DBE8
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		addq.w	#1,d1
		add.w	$34(a0),d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_DBE8:
		subq.b	#1,d2
		bne.s	loc_DC06
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	$34(a0),d0
		move.w	d0,8(a0)
		addq.w	#1,d1
		add.w	$30(a0),d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DC06:
		sub.w	d1,d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		neg.w	d1
		add.w	$34(a0),d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels/shared/MovingBlocks/Sprite.map"
		even
; ---------------------------------------------------------------------------

ObjSpikedBalls:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_DC88(pc,d0.w),d1
		jmp	off_DC88(pc,d1.w)
; ---------------------------------------------------------------------------

off_DC88:	dc.w loc_DC8E-off_DC88, loc_DD6C-off_DC88, loc_DE08-off_DC88
; ---------------------------------------------------------------------------

loc_DC8E:
		addq.b	#2,$24(a0)
		move.l	#MapSpikedBalls,4(a0)
		move.w	#$3BA,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#8,$18(a0)
		move.w	8(a0),$3A(a0)
		move.w	$C(a0),$38(a0)
		move.b	#$98,$20(a0)
		move.b	$28(a0),d1
		andi.b	#$F0,d1
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,$3E(a0)
		move.b	$22(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,$26(a0)
		lea	$29(a0),a2
		move.b	$28(a0),d1
		andi.w	#7,d1
		move.b	#0,(a2)+
		move.w	d1,d3
		lsl.w	#4,d3
		move.b	d3,$3C(a0)
		subq.w	#1,d1
		bcs.s	loc_DD5E
		btst	#3,$28(a0)
		beq.s	loc_DD0A
		subq.w	#1,d1
		bcs.s	loc_DD5E

loc_DD0A:
		bsr.w	ObjectLoad
		bne.s	loc_DD5E
		addq.b	#1,$29(a0)
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#4,$24(a1)
		move.b	0(a0),0(a1)
		move.l	4(a0),4(a1)
		move.w	2(a0),2(a1)
		move.b	1(a0),1(a1)
		move.b	$19(a0),$19(a1)
		move.b	$18(a0),$18(a1)
		move.b	$20(a0),$20(a1)
		subi.b	#$10,d3
		move.b	d3,$3C(a1)
		dbf	d1,loc_DD0A

loc_DD5E:
		move.w	a0,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+

loc_DD6C:
		bsr.w	sub_DD74
		bra.w	loc_DDC6
; ---------------------------------------------------------------------------

sub_DD74:
		move.w	$3E(a0),d0
		add.w	d0,$26(a0)
		move.b	$26(a0),d0
		jsr	(GetSine).l
		move.w	$38(a0),d2
		move.w	$3A(a0),d3
		lea	$29(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_DD96:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#(ObjectsList)&$FFFFFF,d4
		movea.l	d4,a1
		moveq	#0,d4
		move.b	$3C(a1),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,$C(a1)
		move.w	d5,8(a1)
		dbf	d6,loc_DD96
		rts
; ---------------------------------------------------------------------------

loc_DDC6:
		move.w	$3A(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	loc_DDE8
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_DDE8:
		moveq	#0,d2
		lea	$29(a0),a2
		move.b	(a2)+,d2

loc_DDF0:
		moveq	#0,d0
		move.b	(a2)+,d0
		lsl.w	#6,d0
		addi.l	#(ObjectsList)&$FFFFFF,d0
		movea.l	d0,a1
		bsr.w	ObjectDeleteA1
		dbf	d2,loc_DDF0
		rts
; ---------------------------------------------------------------------------

loc_DE08:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------
		include "unsorted/MapSpikedBalls.map"
		even
; ---------------------------------------------------------------------------

ObjGiantSpikedBalls:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_DE22(pc,d0.w),d1
		jmp	off_DE22(pc,d1.w)
; ---------------------------------------------------------------------------

off_DE22:	dc.w loc_DE26-off_DE22, loc_DE80-off_DE22
; ---------------------------------------------------------------------------

loc_DE26:
		addq.b	#2,$24(a0)
		move.l	#MapGiantSpikedBalls,4(a0)
		move.w	#$396,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$18,$18(a0)
		move.w	8(a0),$3A(a0)
		move.w	$C(a0),$38(a0)
		move.b	#$86,$20(a0)
		move.b	$28(a0),d1
		andi.b	#$F0,d1
		ext.w	d1
		asl.w	#3,d1
		move.w	d1,$3E(a0)
		move.b	$22(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,$26(a0)
		move.b	#$50,$3C(a0)

loc_DE80:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_DEB6(pc,d0.w),d1
		jsr	off_DEB6(pc,d1.w)
		move.w	$3A(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

off_DEB6:	dc.w locret_DEBE-off_DEB6, loc_DEC0-off_DEB6, loc_DEE2-off_DEB6, loc_DF06-off_DEB6
; ---------------------------------------------------------------------------

locret_DEBE:
		rts
; ---------------------------------------------------------------------------

loc_DEC0:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(oscValues+$E).w,d0
		btst	#0,$22(a0)
		beq.s	loc_DED6
		neg.w	d0
		add.w	d1,d0

loc_DED6:
		move.w	$3A(a0),d1
		sub.w	d0,d1
		move.w	d1,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_DEE2:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(oscValues+$E).w,d0
		btst	#0,$22(a0)
		beq.s	loc_DEFA
		neg.w	d0
		addi.w	#$80,d0

loc_DEFA:
		move.w	$38(a0),d1
		sub.w	d0,d1
		move.w	d1,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_DF06:
		move.w	$3E(a0),d0
		add.w	d0,$26(a0)
		move.b	$26(a0),d0
		jsr	(GetSine).l
		move.w	$38(a0),d2
		move.w	$3A(a0),d3
		moveq	#0,d4
		move.b	$3C(a0),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,$C(a0)
		move.w	d5,8(a0)
		rts
; ---------------------------------------------------------------------------
		include "unsorted/MapGiantSpikedBalls.map"
		even
; ---------------------------------------------------------------------------

ObjSLZMovingPtfm:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_DF9A(pc,d0.w),d1
		jsr	off_DF9A(pc,d1.w)
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

off_DF9A:	dc.w loc_DFC2-off_DF9A, loc_E03A-off_DF9A, loc_E04A-off_DF9A, loc_E194-off_DF9A

byte_DFA2:	dc.b $28, 0
		dc.b $10, 1
		dc.b $20, 1
		dc.b $34, 1
		dc.b $10, 3
		dc.b $20, 3
		dc.b $34, 3
		dc.b $14, 1
		dc.b $24, 1
		dc.b $2C, 1
		dc.b $14, 3
		dc.b $24, 3
		dc.b $2C, 3
		dc.b $20, 5
		dc.b $20, 7
		dc.b $30, 9
; ---------------------------------------------------------------------------

loc_DFC2:
		addq.b	#2,$24(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		bpl.s	loc_DFE6
		addq.b	#4,$24(a0)
		andi.w	#$7F,d0
		mulu.w	#6,d0
		move.w	d0,$3C(a0)
		move.w	d0,$3E(a0)
		addq.l	#4,sp
		rts
; ---------------------------------------------------------------------------

loc_DFE6:
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	byte_DFA2(pc,d0.w),a2
		move.b	(a2)+,$18(a0)
		move.b	(a2)+,$1A(a0)
		moveq	#0,d0
		move.b	$28(a0),d0
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	byte_DFA2+2(pc,d0.w),a2
		move.b	(a2)+,d0
		lsl.w	#2,d0
		move.w	d0,$3C(a0)
		move.b	(a2)+,$28(a0)
		move.l	#MapSLZMovingPtfm,4(a0)
		move.w	#$4480,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.w	8(a0),$32(a0)
		move.w	$C(a0),$30(a0)

loc_E03A:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmNormal).l
		bra.w	sub_E06E
; ---------------------------------------------------------------------------

loc_E04A:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmCheckExit).l
		move.w	8(a0),-(sp)
		bsr.w	sub_E06E
		move.w	(sp)+,d2
		tst.b	0(a0)
		beq.s	locret_E06C
		jmp	(ptfmSurfaceNormal).l
; ---------------------------------------------------------------------------

locret_E06C:
		rts
; ---------------------------------------------------------------------------

sub_E06E:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	off_E082(pc,d0.w),d1
		jmp	off_E082(pc,d1.w)
; ---------------------------------------------------------------------------

off_E082:	dc.w locret_E096-off_E082, loc_E098-off_E082, loc_E0A6-off_E082, loc_E098-off_E082
		dc.w loc_E0BA-off_E082, loc_E098-off_E082, loc_E0CC-off_E082, loc_E098-off_E082, loc_E0EE-off_E082
		dc.w loc_E110-off_E082
; ---------------------------------------------------------------------------

locret_E096:
		rts
; ---------------------------------------------------------------------------

loc_E098:
		cmpi.b	#4,$24(a0)
		bne.s	locret_E0A4
		addq.b	#1,$28(a0)

locret_E0A4:
		rts
; ---------------------------------------------------------------------------

loc_E0A6:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0BA:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0CC:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		asr.w	#1,d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		move.w	$34(a0),d0
		add.w	$32(a0),d0
		move.w	d0,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_E0EE:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		asr.w	#1,d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		move.w	$34(a0),d0
		neg.w	d0
		add.w	$32(a0),d0
		move.w	d0,8(a0)
		rts
; ---------------------------------------------------------------------------

loc_E110:
		bsr.w	sub_E14A
		move.w	$34(a0),d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,$C(a0)
		tst.b	$28(a0)
		beq.w	loc_E12C
		rts
; ---------------------------------------------------------------------------

loc_E12C:
		btst	#3,$22(a0)
		beq.s	loc_E146
		bset	#1,$22(a1)
		bclr	#3,$22(a1)
		move.b	#2,$24(a1)

loc_E146:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

sub_E14A:
		move.w	$38(a0),d0
		tst.b	$3A(a0)
		bne.s	loc_E160
		cmpi.w	#$800,d0
		bcc.s	loc_E168
		addi.w	#$10,d0
		bra.s	loc_E168
; ---------------------------------------------------------------------------

loc_E160:
		tst.w	d0
		beq.s	loc_E168
		subi.w	#$10,d0

loc_E168:
		move.w	d0,$38(a0)
		ext.l	d0
		asl.l	#8,d0
		add.l	$34(a0),d0
		move.l	d0,$34(a0)
		swap	d0
		move.w	$3C(a0),d2
		cmp.w	d2,d0
		bls.s	loc_E188
		move.b	#1,$3A(a0)

loc_E188:
		add.w	d2,d2
		cmp.w	d2,d0
		bne.s	locret_E192
		clr.b	$28(a0)

locret_E192:
		rts
; ---------------------------------------------------------------------------

loc_E194:
		subq.w	#1,$3C(a0)
		bne.s	loc_E1BE
		move.w	$3E(a0),$3C(a0)
		bsr.w	ObjectLoad
		bne.s	loc_E1BE
		move.b	#$59,0(a1)
		move.w	8(a0),8(a1)
		move.w	$C(a0),$C(a1)
		move.b	#$E,$28(a1)

loc_E1BE:
		addq.l	#4,sp
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
		include "levels/SLZ/MovingPtfm/Srite.map"
		even
; ---------------------------------------------------------------------------

ObjCirclePtfm:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_E222(pc,d0.w),d1
		jsr	off_E222(pc,d1.w)
		move.w	$32(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

off_E222:	dc.w loc_E228-off_E222, loc_E258-off_E222, loc_E268-off_E222
; ---------------------------------------------------------------------------

loc_E228:
		addq.b	#2,$24(a0)
		move.l	#MapCirclePtfm,4(a0)
		move.w	#$4480,2(a0)
		move.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$18,$18(a0)
		move.w	8(a0),$32(a0)
		move.w	$C(a0),$30(a0)

loc_E258:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmNormal).l
		bra.w	sub_E284
; ---------------------------------------------------------------------------

loc_E268:
		moveq	#0,d1
		move.b	$18(a0),d1
		jsr	(PtfmCheckExit).l
		move.w	8(a0),-(sp)
		bsr.w	sub_E284
		move.w	(sp)+,d2
		jmp	(ptfmSurfaceNormal).l
; ---------------------------------------------------------------------------

sub_E284:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#$C,d0
		lsr.w	#1,d0
		move.w	off_E298(pc,d0.w),d1
		jmp	off_E298(pc,d1.w)
; ---------------------------------------------------------------------------

off_E298:	dc.w loc_E29C-off_E298, loc_E2DA-off_E298
; ---------------------------------------------------------------------------

loc_E29C:
		move.b	(oscValues+$22).w,d1
		subi.b	#$50,d1
		ext.w	d1
		move.b	(oscValues+$26).w,d2
		subi.b	#$50,d2
		ext.w	d2
		btst	#0,$28(a0)
		beq.s	loc_E2BC
		neg.w	d1
		neg.w	d2

loc_E2BC:
		btst	#1,$28(a0)
		beq.s	loc_E2C8
		neg.w	d1
		exg	d1,d2

loc_E2C8:
		add.w	$32(a0),d1
		move.w	d1,8(a0)
		add.w	$30(a0),d2
		move.w	d2,$C(a0)
		rts
; ---------------------------------------------------------------------------

loc_E2DA:
		move.b	(oscValues+$22).w,d1
		subi.b	#$50,d1
		ext.w	d1
		move.b	(oscValues+$26).w,d2
		subi.b	#$50,d2
		ext.w	d2
		btst	#0,$28(a0)
		beq.s	loc_E2FA
		neg.w	d1
		neg.w	d2

loc_E2FA:
		btst	#1,$28(a0)
		beq.s	loc_E306
		neg.w	d1
		exg	d1,d2

loc_E306:
		neg.w	d1
		add.w	$32(a0),d1
		move.w	d1,8(a0)
		add.w	$30(a0),d2
		move.w	d2,$C(a0)
		rts
; ---------------------------------------------------------------------------
		include "levels/SLZ/CirclePtfm/Srite.map"
		even
; ---------------------------------------------------------------------------

ObjStaircasePtfm:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_E358(pc,d0.w),d1
		jsr	off_E358(pc,d1.w)
		move.w	$30(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

off_E358:	dc.w loc_E35E-off_E358, loc_E3DE-off_E358, loc_E3F2-off_E358
; ---------------------------------------------------------------------------

loc_E35E:
		addq.b	#2,$24(a0)
		moveq	#$38,d3
		moveq	#1,d4
		btst	#0,$22(a0)
		beq.s	loc_E372
		moveq	#$3B,d3
		moveq	#-1,d4

loc_E372:
		move.w	8(a0),d2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	loc_E38A
; ---------------------------------------------------------------------------

loc_E37C:
		bsr.w	LoadNextObject
		bne.w	loc_E3DE
		move.b	#4,$24(a1)

loc_E38A:
		move.b	#$5B,0(a1)
		move.l	#MapStaircasePtfm,4(a1)
		move.w	#$4480,2(a1)
		move.b	#4,1(a1)
		move.b	#3,$19(a1)
		move.b	#$10,$18(a1)
		move.b	$28(a0),$28(a1)
		move.w	d2,8(a1)
		move.w	$C(a0),$C(a1)
		move.w	8(a0),$30(a1)
		move.w	$C(a1),$32(a1)
		addi.w	#$20,d2
		move.b	d3,$37(a1)
		move.l	a0,$3C(a1)
		add.b	d4,d3
		dbf	d1,loc_E37C

loc_E3DE:
		moveq	#0,d0
		move.b	$28(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		move.w	off_E43A(pc,d0.w),d1
		jsr	off_E43A(pc,d1.w)

loc_E3F2:
		movea.l	$3C(a0),a2
		moveq	#0,d0
		move.b	$37(a0),d0
		move.b	(a2,d0.w),d0
		add.w	$32(a0),d0
		move.w	d0,$C(a0)
		moveq	#0,d1
		move.b	$18(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	8(a0),d4
		bsr.w	sub_A2BC
		tst.b	d4
		bpl.s	loc_E42A
		move.b	d4,$36(a2)

loc_E42A:
		btst	#3,$22(a0)
		beq.s	locret_E438
		move.b	#1,$36(a2)

locret_E438:
		rts
; ---------------------------------------------------------------------------

off_E43A:	dc.w loc_E442-off_E43A, loc_E4A8-off_E43A, loc_E464-off_E43A, loc_E4A8-off_E43A
; ---------------------------------------------------------------------------

loc_E442:
		tst.w	$34(a0)
		bne.s	loc_E458
		cmpi.b	#1,$36(a0)
		bne.s	locret_E456
		move.w	#$1E,$34(a0)

locret_E456:
		rts
; ---------------------------------------------------------------------------

loc_E458:
		subq.w	#1,$34(a0)
		bne.s	locret_E456
		addq.b	#1,$28(a0)
		rts
; ---------------------------------------------------------------------------

loc_E464:
		tst.w	$34(a0)
		bne.s	loc_E478
		tst.b	$36(a0)
		bpl.s	locret_E476
		move.w	#$3C,$34(a0)

locret_E476:
		rts
; ---------------------------------------------------------------------------

loc_E478:
		subq.w	#1,$34(a0)
		bne.s	loc_E484
		addq.b	#1,$28(a0)
		rts
; ---------------------------------------------------------------------------

loc_E484:
		lea	$38(a0),a1
		move.w	$34(a0),d0
		lsr.b	#2,d0
		andi.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		eori.b	#1,d0
		move.b	d0,(a1)+
		rts
; ---------------------------------------------------------------------------

loc_E4A8:
		lea	$38(a0),a1
		cmpi.b	#$80,(a1)
		beq.s	locret_E4D0
		addq.b	#1,(a1)
		moveq	#0,d1
		move.b	(a1)+,d1
		swap	d1
		lsr.l	#1,d1
		move.l	d1,d2
		lsr.l	#1,d1
		move.l	d1,d3
		add.l	d2,d3
		swap	d1
		swap	d2
		swap	d3
		move.b	d3,(a1)+
		move.b	d2,(a1)+
		move.b	d1,(a1)+

locret_E4D0:
		rts
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------
		include "levels/SLZ/StaircasePtfm/Srite.map"
		even
; ---------------------------------------------------------------------------

ObjSLZGirder:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_E4EA(pc,d0.w),d1
		jmp	off_E4EA(pc,d1.w)
; ---------------------------------------------------------------------------

off_E4EA:	dc.w loc_E4EE-off_E4EA, loc_E506-off_E4EA
; ---------------------------------------------------------------------------

loc_E4EE:
		addq.b	#2,$24(a0)
		move.l	#MapSLZGirder,4(a0)
		move.w	#$83CC,2(a0)
		move.b	#$10,$18(a0)

loc_E506:
		move.l	(CameraX).w,d1
		add.l	d1,d1
		swap	d1
		neg.w	d1
		move.w	d1,8(a0)
		move.l	(CameraY).w,d1
		add.l	d1,d1
		swap	d1
		andi.w	#$3F,d1
		neg.w	d1
		addi.w	#$100,d1
		move.w	d1,$A(a0)
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------
		include "levels/SLZ/Girder/Srite.map"
		even
; ---------------------------------------------------------------------------

ObjFan:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_E56C(pc,d0.w),d1
		jmp	off_E56C(pc,d1.w)
; ---------------------------------------------------------------------------

off_E56C:	dc.w loc_E570-off_E56C, loc_E594-off_E56C
; ---------------------------------------------------------------------------

loc_E570:
		addq.b	#2,$24(a0)
		move.l	#MapFan,4(a0)
		move.w	#$43A0,2(a0)
		move.b	#4,1(a0)
		move.b	#$10,$18(a0)
		move.b	#4,$19(a0)

loc_E594:
		btst	#1,$28(a0)
		bne.s	loc_E5B6
		subq.w	#1,$30(a0)
		bpl.s	loc_E5B6
		move.w	#$78,$30(a0)
		bchg	#0,$32(a0)
		beq.s	loc_E5B6
		move.w	#$B4,$30(a0)

loc_E5B6:
		tst.b	$32(a0)
		bne.w	loc_E64E
		lea	(ObjectsList).w,a1
		move.w	8(a1),d0
		sub.w	8(a0),d0
		btst	#0,$22(a0)
		bne.s	loc_E5D4
		neg.w	d0

loc_E5D4:
		addi.w	#$50,d0
		cmpi.w	#$F0,d0
		bcc.s	loc_E61C
		move.w	$C(a1),d1
		addi.w	#$60,d1
		sub.w	$C(a0),d1
		bcs.s	loc_E61C
		cmpi.w	#$70,d1
		bcc.s	loc_E61C
		subi.w	#$50,d0
		bcc.s	loc_E5FC
		not.w	d0
		add.w	d0,d0

loc_E5FC:
		addi.w	#$60,d0
		btst	#0,$22(a0)
		bne.s	loc_E60A
		neg.w	d0

loc_E60A:
		neg.b	d0
		asr.w	#4,d0
		btst	#0,$28(a0)
		beq.s	loc_E618
		neg.w	d0

loc_E618:
		add.w	d0,8(a1)

loc_E61C:
		subq.b	#1,$1E(a0)
		bpl.s	loc_E64E
		move.b	#0,$1E(a0)
		addq.b	#1,$1B(a0)
		cmpi.b	#3,$1B(a0)
		bcs.s	loc_E63A
		move.b	#0,$1B(a0)

loc_E63A:
		moveq	#0,d0
		btst	#0,$28(a0)
		beq.s	loc_E646
		moveq	#2,d0

loc_E646:
		add.b	$1B(a0),d0
		move.b	d0,$1A(a0)

loc_E64E:
		bsr.w	ObjectDisplay
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	(CameraX).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	ObjectDelete
		rts
; ---------------------------------------------------------------------------
		include "levels/SLZ/Fan/Srite.map"
		even
; ---------------------------------------------------------------------------

ObjSeeSaw:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_E6B0(pc,d0.w),d1
		jsr	off_E6B0(pc,d1.w)
		bra.w	ObjectChkDespawn
; ---------------------------------------------------------------------------

off_E6B0:	dc.w loc_E6B6-off_E6B0, loc_E6DA-off_E6B0, loc_E706-off_E6B0
; ---------------------------------------------------------------------------

loc_E6B6:
		addq.b	#2,$24(a0)
		move.l	#MapSeesaw,4(a0)
		move.w	#$374,2(a0)
		ori.b	#4,1(a0)
		move.b	#4,$19(a0)
		move.b	#$30,$18(a0)

loc_E6DA:
		lea	(ObjSeeSaw_SlopeTilt).l,a2
		btst	#0,$1A(a0)
		beq.s	loc_E6EE
		lea	(ObjSeeSaw_SlopeLine).l,a2

loc_E6EE:
		lea	(ObjectsList).w,a1
		move.w	#$30,d1
		jsr	(PtfmSloped).l
		btst	#3,(a0)
		beq.s	locret_E704
		nop

locret_E704:
		rts
; ---------------------------------------------------------------------------

loc_E706:
		bsr.w	sub_E738
		lea	(ObjSeeSaw_SlopeTilt).l,a2
		btst	#0,$1A(a0)
		beq.s	loc_E71E
		lea	(ObjSeeSaw_SlopeLine).l,a2

loc_E71E:
		move.w	#$30,d1
		jsr	(PtfmCheckExit).l
		move.w	#$30,d1
		move.w	8(a0),d2
		jsr	(sub_61E0).l
		rts
; ---------------------------------------------------------------------------

sub_E738:
		moveq	#2,d1
		lea	(ObjectsList).w,a1
		move.w	8(a0),d0
		sub.w	8(a1),d0
		bcc.s	loc_E74C
		neg.w	d0
		moveq	#0,d1

loc_E74C:
		cmpi.w	#8,d0
		bcc.s	loc_E754
		moveq	#1,d1

loc_E754:
		move.b	d1,$1A(a0)
		bclr	#0,1(a0)
		btst	#1,$1A(a0)
		beq.s	locret_E76C
		bset	#0,1(a0)

locret_E76C:
		rts
; ---------------------------------------------------------------------------

ObjSeeSaw_SlopeTilt:dc.b $24, $24, $26, $28, $2A, $2C, $2A, $28, $26, $24
		dc.b $23, $22, $21, $20, $1F, $1E, $1D, $1C, $1B, $1A
		dc.b $19, $18, $17, $16, $15, $14, $13, $12, $11, $10
		dc.b $F, $E, $D, $C, $B, $A, 9, 8, 7, 6, 5, 4, 3, 2, 2
		dc.b 2, 2, 2

ObjSeeSaw_SlopeLine:dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15, $15, $15
		dc.b $15, $15, $15, $15, $15, $15, $15, $15
		include "levels/SLZ/Seesaw/Srite.map"
		even
; ---------------------------------------------------------------------------

ObjSonic:
		tst.w	(DebugRoutine).w
		bne.w	DebugMode
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	off_E826(pc,d0.w),d1
		jmp	off_E826(pc,d1.w)
; ---------------------------------------------------------------------------

off_E826:	dc.w loc_E830-off_E826, loc_E872-off_E826, loc_F2BC-off_E826, loc_F31A-off_E826, loc_F3B8-off_E826
; ---------------------------------------------------------------------------

loc_E830:
		addq.b	#2,obRoutine(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.l	#MapSonic,obMap(a0)
		move.w	#$780,obGfx(a0)
		move.b	#2,obActWid(a0)
		move.b	#obPriority,obPriority(a0)
		move.b	#obMap,obRender(a0)
		move.w	#$600,(unk_FFF760).w
		move.w	#$C,(unk_FFF762).w
		move.w	#$40,(unk_FFF764).w

loc_E872:
		andi.w	#$7FF,obY(a0)
		andi.w	#$7FF,(CameraY).w
		tst.w	(word_FFFFFA).w
		beq.s	loc_E892
		btst	#4,(padPressPlayer).w
		beq.s	loc_E892
		move.w	#1,(DebugRoutine).w

loc_E892:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		andi.w	#6,d0
		move.w	off_E8C8(pc,d0.w),d1
		jsr	off_E8C8(pc,d1.w)
		bsr.s	sub_E8D6
		bsr.w	sub_E952
		move.b	(unk_FFF768).w,obFrontAngle(a0)
		move.b	(unk_FFF76A).w,obRearAngle(a0)
		bsr.w	ObjSonic_Animate
		bsr.w	TouchObjects
		bsr.w	ObjSonic_SpecialChunk
		bsr.w	ObjSonic_DynTiles
		rts
; ---------------------------------------------------------------------------

off_E8C8:	dc.w sub_E96C-off_E8C8, sub_E98E-off_E8C8, loc_E9A8-off_E8C8, loc_E9C6-off_E8C8

MusicList2:	dc.b $81, $82, $83, $84, $85, $86
; ---------------------------------------------------------------------------

sub_E8D6:
		move.w	flashtime(a0),d0
		beq.s	loc_E8E4
		subq.w	#1,flashtime(a0)
		lsr.w	#3,d0
		bcc.s	loc_E8E8

loc_E8E4:
		bsr.w	ObjectDisplay

loc_E8E8:
		tst.b	(byte_FFFE2D).w
		beq.s	loc_E91C
		tst.w	invtime(a0)
		beq.s	loc_E91C
		subq.w	#1,invtime(a0)
		bne.s	loc_E91C
		tst.b	(unk_FFF7AA).w
		bne.s	loc_E916
		moveq	#0,d0
		move.b	(level).w,d0

loc_E906:
		lea	(MusicList2).l,a1
		move.b	(a1,d0.w),d0
		jsr	(PlayMusic).l

loc_E916:
		move.b	#0,(byte_FFFE2D).w

loc_E91C:
		tst.b	(byte_FFFE2E).w
		beq.s	locret_E950
		tst.w	shoetime(a0)
		beq.s	locret_E950
		subq.w	#1,shoetime(a0)
		bne.s	locret_E950
		move.w	#$600,(unk_FFF760).w
		move.w	#$C,(unk_FFF762).w
		move.w	#$40,(unk_FFF764).w
		move.b	#0,(byte_FFFE2E).w
		move.w	#$E3,d0
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------

locret_E950:
		rts
; ---------------------------------------------------------------------------

sub_E952:
		move.w	(unk_FFF7A8).w,d0
		lea	(SonicPosTable).w,a1
		lea	(a1,d0.w),a1
		move.w	obX(a0),(a1)+
		move.w	obY(a0),(a1)+
		addq.b	#4,(unk_FFF7A9).w
		rts
; ---------------------------------------------------------------------------

sub_E96C:
		bsr.w	sub_EEAC
		bsr.w	sub_EF88
		bsr.w	sub_E9E0
		bsr.w	sub_EE4C
		bsr.w	sub_EDFA
		bsr.w	ObjectMove
		bsr.w	sub_FE12
		bsr.w	sub_EFFA
		rts
; ---------------------------------------------------------------------------

sub_E98E:
		bsr.w	sub_EF58
		bsr.w	sub_ED3E
		bsr.w	sub_EDFA
		bsr.w	ObjectFall
		bsr.w	sub_F032
		bsr.w	sub_F04E
		rts
; ---------------------------------------------------------------------------

loc_E9A8:
		bsr.w	sub_EEAC
		bsr.w	sub_EFBE
		bsr.w	sub_EC62
		bsr.w	sub_EDFA
		bsr.w	ObjectMove
		bsr.w	sub_FE12
		bsr.w	sub_EFFA
		rts
; ---------------------------------------------------------------------------

loc_E9C6:
		bsr.w	sub_EF58
		bsr.w	sub_ED3E
		bsr.w	sub_EDFA
		bsr.w	ObjectFall
		bsr.w	sub_F032
		bsr.w	sub_F04E
		rts
; ---------------------------------------------------------------------------

sub_E9E0:
		move.w	(unk_FFF760).w,d6
		move.w	(unk_FFF762).w,d5
		move.w	(unk_FFF764).w,d4
		tst.w	obLRLock(a0)
		bne.w	loc_EAA0
		btst	#2,(padHeldPlayer).w
		beq.s	loc_EA00
		bsr.w	sub_EB90

loc_EA00:
		btst	#3,(padHeldPlayer).w
		beq.s	loc_EA0C
		bsr.w	sub_EBFC

loc_EA0C:
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.w	loc_EAD8
		tst.w	$14(a0)
		bne.w	loc_EAD8
		bclr	#5,obAngle(a0)
		move.b	#5,obAnim(a0)
		btst	#3,obStatus(a0)
		beq.s	loc_EA6E
		moveq	#0,d0
		move.b	obPlatformID(a0),d0
		lsl.w	#6,d0
		lea	(ObjectsList).w,a1
		lea	(a1,d0.w),a1
		tst.b	obStatus(a1)
		bmi.s	loc_EAA0
		moveq	#0,d1
		move.b	obPriority(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2
		add.w	obX(a0),d1
		sub.w	obX(a1),d1
		cmpi.w	#4,d1
		blt.s	loc_EA92
		cmp.w	d2,d1
		bge.s	loc_EA82
		bra.s	loc_EAA0
; ---------------------------------------------------------------------------

loc_EA6E:
		jsr	sub_105F0
		cmpi.w	#$C,d1
		blt.s	loc_EAA0
		cmpi.b	#3,obFrontAngle(a0)
		bne.s	loc_EA8A

loc_EA82:
		bclr	#0,obStatus(a0)
		bra.s	loc_EA98
; ---------------------------------------------------------------------------

loc_EA8A:
		cmpi.b	#3,obRearAngle(a0)
		bne.s	loc_EAA0

loc_EA92:
		bset	#0,obStatus(a0)

loc_EA98:
		move.b	#6,obAnim(a0)
		bra.s	loc_EAD8
; ---------------------------------------------------------------------------

loc_EAA0:
		btst	#0,(padHeldPlayer).w
		beq.s	loc_EABC
		move.b	#7,obAnim(a0)
		cmpi.w	#$C8,(unk_FFF73E).w
		beq.s	loc_EAEA
		addq.w	#2,(unk_FFF73E).w
		bra.s	loc_EAEA
; ---------------------------------------------------------------------------

loc_EABC:
		btst	#1,(padHeldPlayer).w
		beq.s	loc_EAD8
		move.b	#8,obAnim(a0)
		cmpi.w	#8,(unk_FFF73E).w
		beq.s	loc_EAEA
		subq.w	#2,(unk_FFF73E).w
		bra.s	loc_EAEA
; ---------------------------------------------------------------------------

loc_EAD8:
		cmpi.w	#$60,(unk_FFF73E).w
		beq.s	loc_EAEA
		bcc.s	loc_EAE6
		addq.w	#4,(unk_FFF73E).w

loc_EAE6:
		subq.w	#2,(unk_FFF73E).w

loc_EAEA:
		move.b	(padHeldPlayer).w,d0
		andi.b	#$C,d0
		bne.s	loc_EB16
		move.w	obInertia(a0),d0
		beq.s	loc_EB16
		bmi.s	loc_EB0A
		sub.w	d5,d0
		bcc.s	loc_EB04
		move.w	#0,d0

loc_EB04:
		move.w	d0,obInertia(a0)
		bra.s	loc_EB16
; ---------------------------------------------------------------------------

loc_EB0A:
		add.w	d5,d0
		bcc.s	loc_EB12
		move.w	#0,d0

loc_EB12:
		move.w	d0,obInertia(a0)

loc_EB16:
		move.b	obAngle(a0),d0
		jsr	(GetSine).l
		muls.w	obInertia(a0),d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	obInertia(a0),d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)

loc_EB34:
		move.b	#$40,d1
		tst.w	obInertia(a0)
		beq.s	locret_EB8E
		bmi.s	loc_EB42
		neg.w	d1

loc_EB42:
		move.b	obAngle(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	sub_104CE
		move.w	(sp)+,d0
		tst.w	d1
		bpl.s	locret_EB8E
		move.w	#0,obInertia(a0)
		bset	#5,obStatus(a0)
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	loc_EB8A
		cmpi.b	#$40,d0
		beq.s	loc_EB84
		cmpi.b	#$80,d0
		beq.s	loc_EB7E
		add.w	d1,obVelX(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB7E:
		sub.w	d1,obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB84:
		sub.w	d1,obVelX(a0)
		rts
; ---------------------------------------------------------------------------

loc_EB8A:
		add.w	d1,obVelY(a0)

locret_EB8E:
		rts
; ---------------------------------------------------------------------------

sub_EB90:
		move.w	obInertia(a0),d0
		beq.s	loc_EB98
		bpl.s	loc_EBC4

loc_EB98:
		bset	#0,obStatus(a0)
		bne.s	loc_EBAC
		bclr	#5,obStatus(a0)
		move.b	#1,obNextAni(a0)

loc_EBAC:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_EBB8
		move.w	d1,d0

loc_EBB8:
		move.w	d0,obInertia(a0)
		move.b	#0,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_EBC4:
		sub.w	d4,d0
		bcc.s	loc_EBCC
		move.w	#$FF80,d0

loc_EBCC:
		move.w	d0,obInertia(a0)
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EBFA
		cmpi.w	#$400,d0
		blt.s	locret_EBFA
		move.b	#$D,obAnim(a0)
		bclr	#0,obStatus(a0)
		move.w	#$A4,d0
		jsr	(PlaySFX).l

locret_EBFA:
		rts
; ---------------------------------------------------------------------------

sub_EBFC:
		move.w	obInertia(a0),d0
		bmi.s	loc_EC2A
		bclr	#0,obStatus(a0)
		beq.s	loc_EC16
		bclr	#5,obStatus(a0)
		move.b	#1,obNextAni(a0)

loc_EC16:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_EC1E
		move.w	d6,d0

loc_EC1E:
		move.w	d0,obInertia(a0)
		move.b	#0,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_EC2A:
		add.w	d4,d0
		bcc.s	loc_EC32
		move.w	#$80,d0

loc_EC32:
		move.w	d0,obInertia(a0)
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EC60
		cmpi.w	#$FC00,d0
		bgt.s	locret_EC60
		move.b	#$D,obAnim(a0)
		bset	#0,obStatus(a0)
		move.w	#$A4,d0
		jsr	(PlaySFX).l

locret_EC60:
		rts
; ---------------------------------------------------------------------------

sub_EC62:
		move.w	(unk_FFF760).w,d6
		asl.w	#1,d6
		move.w	(unk_FFF762).w,d5
		asr.w	#1,d5
		move.w	(unk_FFF764).w,d4
		asr.w	#2,d4
		tst.w	obLRLock(a0)
		bne.s	loc_EC92
		btst	#2,(padHeldPlayer).w
		beq.s	loc_EC86
		bsr.w	sub_ECF8

loc_EC86:
		btst	#3,(padHeldPlayer).w
		beq.s	loc_EC92
		bsr.w	sub_ED1C

loc_EC92:
		move.w	obInertia(a0),d0
		beq.s	loc_ECB4
		bmi.s	loc_ECA8
		sub.w	d5,d0
		bcc.s	loc_ECA2
		move.w	#0,d0

loc_ECA2:
		move.w	d0,obInertia(a0)
		bra.s	loc_ECB4
; ---------------------------------------------------------------------------

loc_ECA8:
		add.w	d5,d0
		bcc.s	loc_ECB0
		move.w	#0,d0

loc_ECB0:
		move.w	d0,obInertia(a0)

loc_ECB4:
		tst.w	obInertia(a0)
		bne.s	loc_ECD6
		bclr	#2,obStatus(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.b	#5,obAnim(a0)
		subq.w	#5,obY(a0)

loc_ECD6:
		move.b	obAngle(a0),d0
		jsr	(GetSine).l
		muls.w	obInertia(a0),d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	obInertia(a0),d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)
		bra.w	loc_EB34
; ---------------------------------------------------------------------------

sub_ECF8:
		move.w	obInertia(a0),d0
		beq.s	loc_ED00
		bpl.s	loc_ED0E

loc_ED00:
		bset	#0,obStatus(a0)
		move.b	#2,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_ED0E:
		sub.w	d4,d0
		bcc.s	loc_ED16
		move.w	#$FF80,d0

loc_ED16:
		move.w	d0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

sub_ED1C:
		move.w	obInertia(a0),d0
		bmi.s	loc_ED30
		bclr	#0,obStatus(a0)
		move.b	#2,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_ED30:
		add.w	d4,d0
		bcc.s	loc_ED38
		move.w	#$80,d0

loc_ED38:
		move.w	d0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

sub_ED3E:
		move.w	(unk_FFF760).w,d6
		move.w	(unk_FFF762).w,d5
		asl.w	#1,d5
		btst	#4,obStatus(a0)
		bne.s	loc_ED88
		move.w	obVelX(a0),d0
		btst	#2,(padHeld1).w
		beq.s	loc_ED6E
		bset	#0,obStatus(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.s	loc_ED6E
		move.w	d1,d0

loc_ED6E:
		btst	#3,(padHeld1).w
		beq.s	loc_ED84
		bclr	#0,obStatus(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.s	loc_ED84
		move.w	d6,d0

loc_ED84:
		move.w	d0,obVelX(a0)

loc_ED88:
		cmpi.w	#$60,(unk_FFF73E).w
		beq.s	loc_ED9A
		bcc.s	loc_ED96
		addq.w	#4,(unk_FFF73E).w

loc_ED96:
		subq.w	#2,(unk_FFF73E).w

loc_ED9A:
		cmpi.w	#$FC00,obVelY(a0)
		bcs.s	locret_EDC8
		move.w	obVelX(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.s	locret_EDC8
		bmi.s	loc_EDBC
		sub.w	d1,d0
		bcc.s	loc_EDB6
		move.w	#0,d0

loc_EDB6:
		move.w	d0,obVelX(a0)
		rts
; ---------------------------------------------------------------------------

loc_EDBC:
		sub.w	d1,d0
		bcs.s	loc_EDC4
		move.w	#0,d0

loc_EDC4:
		move.w	d0,obVelX(a0)

locret_EDC8:
		rts
; ---------------------------------------------------------------------------
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_EDF8
		bsr.w	sub_106E0
		tst.w	d1
		bpl.s	locret_EDF8
		move.w	#0,obInertia(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		move.b	#$B,obAnim(a0)

locret_EDF8:
		rts
; ---------------------------------------------------------------------------

sub_EDFA:
		move.l	obX(a0),d1
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	(unk_FFF728).w,d0
		addi.w	#$10,d0
		cmp.w	d1,d0
		bhi.s	loc_EE34
		move.w	(unk_FFF72A).w,d0
		addi.w	#$128,d0
		cmp.w	d1,d0
		bls.s	loc_EE34
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.w	loc_FD78
		rts
; ---------------------------------------------------------------------------

loc_EE34:
		move.w	d0,obX(a0)
		move.w	#0,obScreenY(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

sub_EE4C:
		move.w	obInertia(a0),d0
		bpl.s	loc_EE54
		neg.w	d0

loc_EE54:
		cmpi.w	#$80,d0
		bcs.s	locret_EE6C
		move.b	(padHeldPlayer).w,d0
		andi.b	#$C,d0
		bne.s	locret_EE6C
		btst	#1,(padHeldPlayer).w
		bne.s	loc_EE6E

locret_EE6C:
		rts
; ---------------------------------------------------------------------------

loc_EE6E:
		btst	#2,obStatus(a0)
		beq.s	loc_EE78
		rts
; ---------------------------------------------------------------------------

loc_EE78:
		bset	#2,obStatus(a0)
		move.b	#$E,obHeight(a0)
		move.b	#7,obWidth(a0)
		move.b	#2,obAnim(a0)
		addq.w	#5,obY(a0)
		move.w	#$BE,d0
		jsr	(PlaySFX).l
		tst.w	obInertia(a0)
		bne.s	locret_EEAA
		move.w	#$200,obInertia(a0)

locret_EEAA:
		rts
; ---------------------------------------------------------------------------

sub_EEAC:
		move.b	(padPressPlayer).w,d0
		andi.b	#$70,d0
		beq.w	locret_EF46
		moveq	#0,d0
		move.b	obAngle(a0),d0
		addi.b	#-$80,d0
		bsr.w	sub_10520
		cmpi.w	#6,d1
		blt.w	locret_EF46
		moveq	#0,d0
		move.b	obAngle(a0),d0
		subi.b	#$40,d0
		jsr	(GetSine).l
		muls.w	#$680,d1
		asr.l	#8,d1
		add.w	d1,$10(a0)
		muls.w	#$680,d0
		asr.l	#8,d0
		add.w	d0,obVelY(a0)
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		addq.l	#4,sp
		move.b	#1,obJumping(a0)
		move.w	#$A0,d0
		jsr	(PlaySFX).l
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		tst.b	(byte_FFD600).w
		bne.s	loc_EF48
		btst	#2,obStatus(a0)
		bne.s	loc_EF50
		move.b	#$E,obHeight(a0)
		move.b	#7,obWidth(a0)
		move.b	#2,obAnim(a0)
		bset	#2,obStatus(a0)
		addq.w	#5,obY(a0)

locret_EF46:
		rts
; ---------------------------------------------------------------------------

loc_EF48:
		move.b	#$13,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

loc_EF50:
		bset	#4,obStatus(a0)
		rts
; ---------------------------------------------------------------------------

sub_EF58:
		tst.b	obJumping(a0)
		beq.s	loc_EF78
		cmpi.w	#$FC00,obVelY(a0)
		bge.s	locret_EF76
		move.b	(padHeldPlayer).w,d0
		andi.b	#$70,d0
		bne.s	locret_EF76
		move.w	#$FC00,obVelY(a0)

locret_EF76:
		rts
; ---------------------------------------------------------------------------

loc_EF78:
		cmpi.w	#$F040,obVelY(a0)
		bge.s	locret_EF86
		move.w	#$F040,obVelY(a0)

locret_EF86:
		rts
; ---------------------------------------------------------------------------

sub_EF88:
		move.b	obAngle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_EFBC
		move.b	obAngle(a0),d0
		jsr	(GetSine).l
		muls.w	#$20,d0
		asr.l	#8,d0
		tst.w	obInertia(a0)
		beq.s	locret_EFBC
		bmi.s	loc_EFB8
		tst.w	d0
		beq.s	locret_EFB6
		add.w	d0,obInertia(a0)

locret_EFB6:
		rts
; ---------------------------------------------------------------------------

loc_EFB8:
		add.w	d0,obInertia(a0)

locret_EFBC:
		rts
; ---------------------------------------------------------------------------

sub_EFBE:
		move.b	obAngle(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$C0,d0
		bcc.s	locret_EFF8
		move.b	obAngle(a0),d0
		jsr	(GetSine).l
		muls.w	#$50,d0
		asr.l	#8,d0
		tst.w	obInertia(a0)
		bmi.s	loc_EFEE
		tst.w	d0
		bpl.s	loc_EFE8
		asr.l	#2,d0

loc_EFE8:
		add.w	d0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_EFEE:
		tst.w	d0
		bmi.s	loc_EFF4
		asr.l	#2,d0

loc_EFF4:
		add.w	d0,obInertia(a0)

locret_EFF8:
		rts
; ---------------------------------------------------------------------------

sub_EFFA:
		nop
		tst.w	obLRLock(a0)
		bne.s	loc_F02C
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.s	locret_F02A
		move.w	obInertia(a0),d0
		bpl.s	loc_F018
		neg.w	d0

loc_F018:
		cmpi.w	#$280,d0
		bcc.s	locret_F02A
		bset	#1,obStatus(a0)
		move.w	#$1E,obLRLock(a0)

locret_F02A:
		rts
; ---------------------------------------------------------------------------

loc_F02C:
		subq.w	#1,obLRLock(a0)
		rts
; ---------------------------------------------------------------------------

sub_F032:
		move.b	obAngle(a0),d0
		beq.s	locret_F04C
		bpl.s	loc_F042
		addq.b	#2,d0
		bcc.s	loc_F040
		moveq	#0,d0

loc_F040:
		bra.s	loc_F048
; ---------------------------------------------------------------------------

loc_F042:
		subq.b	#2,d0
		bcc.s	loc_F048
		moveq	#0,d0

loc_F048:
		move.b	d0,obAngle(a0)

locret_F04C:
		rts
; ---------------------------------------------------------------------------

sub_F04E:
		move.w	obVelX(a0),d1
		move.w	obVelY(a0),d2
		jsr	(GetAngle).l
		subi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_F104
		cmpi.b	#$80,d0
		beq.w	loc_F160
		cmpi.b	#$C0,d0
		beq.w	loc_F1BC

loc_F07C:
		bsr.w	sub_1081A
		tst.w	d1
		bpl.s	loc_F08E
		sub.w	d1,obX(a0)
		move.w	#0,obVelX(a0)

loc_F08E:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F0A0
		add.w	d1,obX(a0)
		move.w	#0,obVelX(a0)

loc_F0A0:
		bsr.w	loc_10548
		tst.w	d1
		bpl.s	locret_F102
		move.b	obVelY(a0),d0
		addq.b	#8,d0
		neg.b	d0
		cmp.b	d0,d1
		blt.s	locret_F102
		add.w	d1,$C(a0)
		move.b	d3,obAngle(a0)
		bsr.w	sub_F218
		move.b	#0,obAnim(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_F0E0
		move.w	#0,obVelY(a0)
		move.w	obVelX(a0),obInertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_F0E0:
		move.w	#0,obVelX(a0)
		cmpi.w	#$FC0,obVelY(a0)
		ble.s	loc_F0F4
		move.w	#$FC0,obVelY(a0)

loc_F0F4:
		move.w	obVelY(a0),obInertia(a0)
		tst.b	d3
		bpl.s	locret_F102
		neg.w	obInertia(a0)

locret_F102:
		rts
; ---------------------------------------------------------------------------

loc_F104:
		bsr.w	sub_1081A
		tst.w	d1
		bpl.s	loc_F11E
		sub.w	d1,obX(a0)
		move.w	#0,obVelX(a0)
		move.w	obVelY(a0),obInertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_F11E:
		bsr.w	sub_106E0
		tst.w	d1
		bpl.s	loc_F132
		sub.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_F132:
		tst.w	obVelY(a0)
		bmi.s	locret_F15E
		bsr.w	loc_10548
		tst.w	d1
		bpl.s	locret_F15E
		add.w	d1,obY(a0)
		move.b	d3,obAngle(a0)
		bsr.w	sub_F218
		move.b	#0,obAnim(a0)
		move.w	#0,obVelY(a0)
		move.w	obVelX(a0),obInertia(a0)

locret_F15E:
		rts
; ---------------------------------------------------------------------------

loc_F160:
		bsr.w	sub_1081A
		tst.w	d1
		bpl.s	loc_F172
		sub.w	d1,obX(a0)
		move.w	#0,obVelX(a0)

loc_F172:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F184
		add.w	d1,obX(a0)
		move.w	#0,obVelX(a0)

loc_F184:
		bsr.w	sub_106E0
		tst.w	d1
		bpl.s	locret_F1BA
		sub.w	d1,obY(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.s	loc_F1A4
		move.w	#0,obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1A4:
		move.b	d3,obAngle(a0)
		bsr.w	sub_F218
		move.w	obVelY(a0),obInertia(a0)
		tst.b	d3
		bpl.s	locret_F1BA
		neg.w	obInertia(a0)

locret_F1BA:
		rts
; ---------------------------------------------------------------------------

loc_F1BC:
		bsr.w	sub_1068C
		tst.w	d1
		bpl.s	loc_F1D6
		add.w	d1,obX(a0)
		move.w	#0,obVelX(a0)
		move.w	obVelY(a0),obInertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1D6:
		bsr.w	sub_106E0
		tst.w	d1
		bpl.s	loc_F1EA
		sub.w	d1,obY(a0)
		move.w	#0,obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_F1EA:
		tst.w	obVelY(a0)
		bmi.s	locret_F216
		bsr.w	loc_10548
		tst.w	d1
		bpl.s	locret_F216
		add.w	d1,obY(a0)
		move.b	d3,obAngle(a0)
		bsr.w	sub_F218
		move.b	#0,obAnim(a0)
		move.w	#0,obVelY(a0)
		move.w	obVelX(a0),obInertia(a0)

locret_F216:
		rts
; ---------------------------------------------------------------------------

sub_F218:
		btst	#4,obStatus(a0)
		beq.s	loc_F226
		nop
		nop
		nop

loc_F226:
		bclr	#5,obStatus(a0)
		bclr	#1,obStatus(a0)
		bclr	#4,obStatus(a0)
		btst	#2,obStatus(a0)
		beq.s	loc_F25C
		bclr	#2,obStatus(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.b	#0,obAnim(a0)
		subq.w	#5,obY(a0)

loc_F25C:
		move.w	#0,obLRLock(a0)
		move.b	#0,obJumping(a0)
		rts
; ---------------------------------------------------------------------------
		lea	(byte_FFD400).w,a1
		move.w	obX(a0),d0
		bsr.w	sub_F290
		lea	(byte_FFD500).w,a1
		move.w	obY(a0),d0
		bsr.w	sub_F290
		lea	(byte_FFD600).w,a1
		move.w	obInertia(a0),d0
		bsr.w	sub_F290
		rts
; ---------------------------------------------------------------------------

sub_F290:
		swap	d0
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$1A(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$5A(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$9A(a1)
		rol.l	#4,d0
		andi.b	#$F,d0
		move.b	d0,$DA(a1)
		rts
; ---------------------------------------------------------------------------

loc_F2BC:
		bsr.w	sub_F2DE
		bsr.w	ObjectMove
		addi.w	#$30,obVelY(a0)
		bsr.w	sub_EDFA
		bsr.w	sub_E952
		bsr.w	ObjSonic_Animate
		bsr.w	ObjSonic_DynTiles
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

sub_F2DE:
		move.w	(unk_FFF72E).w,d0
		addi.w	#$E0,d0
		cmp.w	$C(a0),d0
		bcs.w	loc_FD78
		bsr.w	loc_F07C
		btst	#1,obStatus(a0)
		bne.s	locret_F318
		moveq	#0,d0
		move.w	d0,obVelY(a0)
		move.w	d0,obVelX(a0)
		move.w	d0,obInertia(a0)
		move.b	#0,obAnim(a0)
		subq.b	#2,obRoutine(a0)
		move.w	#$78,flashtime(a0)

locret_F318:
		rts
; ---------------------------------------------------------------------------

loc_F31A:
		bsr.w	sub_F332
		bsr.w	ObjectFall
		bsr.w	sub_E952
		bsr.w	ObjSonic_Animate
		bsr.w	ObjSonic_DynTiles
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

sub_F332:
		move.w	(unk_FFF72E).w,d0
		addi.w	#$100,d0
		cmp.w	$C(a0),d0
		bcc.w	locret_F3AE
		move.w	#$FFC8,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		addq.b	#1,(byte_FFFE1C).w
		subq.b	#1,(Lives).w
		bne.s	loc_F380
		move.w	#0,obRestartTimer(a0)
		move.b	#$39,(byte_FFD080).w
		move.b	#$39,(byte_FFD0C0).w
		move.b	#1,(byte_FFD0C0+obFrame).w
		move.w	#$8F,d0
		jsr	(PlaySFX).l
		moveq	#3,d0
		jmp	(plcAdd).l
; ---------------------------------------------------------------------------

loc_F380:
		move.w	#$3C,obRestartTimer(a0)
		rts
; ---------------------------------------------------------------------------
		move.b	(padPressPlayer).w,d0
		andi.b	#$70,d0
		beq.s	locret_F3AE
		andi.b	#$40,d0
		bne.s	loc_F3B0
		move.b	#0,obAnim(a0)
		subq.b	#4,obRoutine(a0)
		move.w	obOnWheel(a0),obY(a0)
		move.w	#$78,flashtime(a0)

locret_F3AE:
		rts
; ---------------------------------------------------------------------------

loc_F3B0:
		move.w	#1,(LevelRestart).w
		rts
; ---------------------------------------------------------------------------

loc_F3B8:
		tst.w	obRestartTimer(a0)
		beq.s	locret_F3CA
		subq.w	#1,obRestartTimer(a0)
		bne.s	locret_F3CA
		move.w	#1,(LevelRestart).w

locret_F3CA:
		rts
; ---------------------------------------------------------------------------
		dc.b $12, 9, $A, $12, 9, $A, $12, 9, $A, $12, 9, $A, $12
		dc.b 9, $A, $12, 9, $12, $E, 7, $A, $E, 7, $A
; ---------------------------------------------------------------------------

ObjSonic_SpecialChunk:
		cmpi.b	#3,(level).w
		beq.s	loc_F3F4
		tst.b	(level).w
		bne.w	locret_F490

loc_F3F4:
		move.w	$C(a0),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	obX(a0),d1
		move.w	d1,d2
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0
		lea	(Layout).w,a1
		move.b	(a1,d0.w),d1
		cmp.b	(unk_FFF7AE).w,d1
		beq.w	loc_EE6E
		cmp.b	(unk_FFF7AF).w,d1
		beq.w	loc_EE6E
		cmp.b	(unk_FFF7AC).w,d1
		beq.s	loc_F448
		cmp.b	(unk_FFF7AD).w,d1
		beq.s	loc_F438
		bclr	#6,obRender(a0)
		rts
; ---------------------------------------------------------------------------

loc_F438:
		btst	#1,obStatus(a0)
		beq.s	loc_F448
		bclr	#6,obRender(a0)
		rts
; ---------------------------------------------------------------------------

loc_F448:
		cmpi.b	#$2C,d2
		bcc.s	loc_F456
		bclr	#6,obRender(a0)
		rts
; ---------------------------------------------------------------------------

loc_F456:
		cmpi.b	#$E0,d2
		bcs.s	loc_F464
		bset	#6,obRender(a0)
		rts
; ---------------------------------------------------------------------------

loc_F464:
		btst	#6,obRender(a0)
		bne.s	loc_F480
		move.b	$26(a0),d1
		beq.s	locret_F490
		cmpi.b	#$80,d1
		bhi.s	locret_F490
		bset	#6,obRender(a0)
		rts
; ---------------------------------------------------------------------------

loc_F480:
		move.b	$26(a0),d1
		cmpi.b	#$80,d1
		bls.s	locret_F490
		bclr	#6,obRender(a0)

locret_F490:
		rts
; ---------------------------------------------------------------------------

ObjSonic_Animate:
		lea	(AniSonic).l,a1
		moveq	#0,d0
		move.b	obAnim(a0),d0
		cmp.b	obNextAni(a0),d0
		beq.s	loc_F4B4
		move.b	d0,obNextAni(a0)
		move.b	#0,obAniFrame(a0)
		move.b	#0,obTimeFrame(a0)

loc_F4B4:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.s	ObjSonic_AnimateCmd
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		subq.b	#1,obTimeFrame(a0)
		bpl.s	locret_F4EE
		move.b	d0,obTimeFrame(a0)
; ---------------------------------------------------------------------------

sub_F4DA:
		moveq	#0,d1
		move.b	obAniFrame(a0),d1
		move.b	obRender(a1,d1.w),d0
		bmi.s	loc_F4F0

loc_F4E6:
		move.b	d0,obFrame(a0)
		addq.b	#1,obAniFrame(a0)

locret_F4EE:
		rts
; ---------------------------------------------------------------------------

loc_F4F0:
		addq.b	#1,d0
		bne.s	loc_F500
		move.b	#0,obAniFrame(a0)
		move.b	obRender(a1),d0
		bra.s	loc_F4E6
; ---------------------------------------------------------------------------

loc_F500:
		addq.b	#1,d0
		bne.s	loc_F514
		move.b	obGfx(a1,d1.w),d0
		sub.b	d0,obAniFrame(a0)
		sub.b	d0,d1
		move.b	obRender(a1,d1.w),d0
		bra.s	loc_F4E6
; ---------------------------------------------------------------------------

loc_F514:
		addq.b	#1,d0
		bne.s	locret_F51E
		move.b	obGfx(a1,d1.w),obAnim(a0)

locret_F51E:
		rts
; ---------------------------------------------------------------------------

ObjSonic_AnimateCmd:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	locret_F4EE
		addq.b	#1,d0
		bne.w	loc_F5A0
		moveq	#0,d1
		move.b	obAngle(a0),d0
		move.b	obStatus(a0),d2
		andi.b	#1,d2
		bne.s	loc_F53E
		not.b	d0

loc_F53E:
		addi.b	#$10,d0
		bpl.s	loc_F546
		moveq	#3,d1

loc_F546:
		andi.b	#$FC,obRender(a0)
		eor.b	d1,d2
		or.b	d2,obRender(a0)
		btst	#5,obStatus(a0)
		bne.w	loc_F5E4
		lsr.b	#4,d0
		andi.b	#6,d0
		move.w	obInertia(a0),d2
		bpl.s	loc_F56A
		neg.w	d2

loc_F56A:
		lea	(byte_F654).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_F582
		lea	(byte_F64C).l,a1
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0

loc_F582:
		add.b	d0,d0
		move.b	d0,d3
		neg.w	d2
		addi.w	#$800,d2
		bpl.s	loc_F590
		moveq	#0,d2

loc_F590:
		lsr.w	#8,d2
		move.b	d2,obTimeFrame(a0)
		bsr.w	sub_F4DA
		add.b	d3,obFrame(a0)
		rts
; ---------------------------------------------------------------------------

loc_F5A0:
		addq.b	#1,d0
		bne.s	loc_F5E4
		move.w	obInertia(a0),d2
		bpl.s	loc_F5AC
		neg.w	d2

loc_F5AC:
		lea	(byte_F664).l,a1
		cmpi.w	#$600,d2
		bcc.s	loc_F5BE
		lea	(byte_F65C).l,a1

loc_F5BE:
		neg.w	d2
		addi.w	#$400,d2
		bpl.s	loc_F5C8
		moveq	#0,d2

loc_F5C8:
		lsr.w	#8,d2
		move.b	d2,obTimeFrame(a0)
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		bra.w	sub_F4DA
; ---------------------------------------------------------------------------

loc_F5E4:
		move.w	obInertia(a0),d2
		bmi.s	loc_F5EC
		neg.w	d2

loc_F5EC:
		addi.w	#$800,d2
		bpl.s	loc_F5F4
		moveq	#0,d2

loc_F5F4:
		lsr.w	#6,d2
		move.b	d2,$1E(a0)

loc_F5FA:
		lea	(byte_F66C).l,a1
		move.b	obStatus(a0),d1
		andi.b	#1,d1
		andi.b	#$FC,obRender(a0)
		or.b	d1,obRender(a0)
		bra.w	sub_F4DA
; ---------------------------------------------------------------------------
		include "levels/shared/Sonic/Srite.ani"
		even
; ---------------------------------------------------------------------------

ObjSonic_DynTiles:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		cmp.b	(unk_FFF766).w,d0
		beq.s	locret_F744
		move.b	d0,(unk_FFF766).w
		lea	(DynMapSonic).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.b	#1,d1
		bmi.s	locret_F744
		lea	(SonicArtBuf).w,a3
		move.b	#1,(unk_FFF767).w

loc_F71A:
		moveq	#0,d2
		move.b	(a2)+,d2
		move.w	d2,d0
		lsr.b	#4,d0
		lsl.w	#8,d2
		move.b	(a2)+,d2
		lsl.w	#5,d2
		lea	(ArtSonic).l,a1
		adda.l	d2,a1

loc_F730:
		movem.l	(a1)+,d2-d6/a4-a6
		movem.l	d2-d6/a4-a6,(a3)
		lea	obColType(a3),a3
		dbf	d0,loc_F730

loc_F740:
		dbf	d1,loc_F71A

locret_F744:
		rts
; ---------------------------------------------------------------------------

ObjShield:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_F754(pc,d0.w),d1
		jmp	off_F754(pc,d1.w)
; ---------------------------------------------------------------------------

off_F754:	dc.w loc_F75A-off_F754, loc_F792-off_F754, loc_F7C6-off_F754
; ---------------------------------------------------------------------------

loc_F75A:
		addq.b	#2,obRoutine(a0)
		move.l	#MapShield,obMap(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obActWid(a0)
		move.b	#$10,obPriority(a0)
		tst.b	obAnim(a0)
		bne.s	loc_F786
		move.w	#$541,obGfx(a0)
		rts
; ---------------------------------------------------------------------------

loc_F786:
		addq.b	#2,obRoutine(a0)
		move.w	#$55C,obGfx(a0)
		rts
; ---------------------------------------------------------------------------

loc_F792:
		tst.b	(byte_FFFE2D).w
		bne.s	locret_F7C0
		tst.b	(byte_FFFE2C).w
		beq.s	loc_F7C2
		move.w	(ObjectsList+obX).w,obX(a0)
		move.w	(ObjectsList+obY).w,obY(a0)
		move.b	(ObjectsList+obStatus).w,obStatus(a0)
		lea	(AniShield).l,a1
		jsr	(AnimateSprite).l
		bsr.w	ObjectDisplay

locret_F7C0:
		rts
; ---------------------------------------------------------------------------

loc_F7C2:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

loc_F7C6:
		tst.b	(byte_FFFE2D).w
		beq.s	loc_F836
		move.w	(unk_FFF7A8).w,d0
		move.b	obAnim(a0),d1
		subq.b	#1,d1
		bra.s	loc_F7F0
; ---------------------------------------------------------------------------
		lsl.b	#4,d1
		addq.b	#4,d1
		sub.b	d1,d0
		move.b	flashtime(a0),d1
		sub.b	d1,d0
		addq.b	#4,d1
		andi.b	#$F,d1
		move.b	d1,flashtime(a0)
		bra.s	loc_F810
; ---------------------------------------------------------------------------

loc_F7F0:
		lsl.b	#3,d1
		move.b	d1,d2
		add.b	d1,d1
		add.b	d2,d1
		addq.b	#4,d1
		sub.b	d1,d0
		move.b	flashtime(a0),d1
		sub.b	d1,d0
		addq.b	#4,d1
		cmpi.b	#$18,d1
		bcs.s	loc_F80C
		moveq	#0,d1

loc_F80C:
		move.b	d1,flashtime(a0)

loc_F810:
		lea	(SonicPosTable).w,a1
		lea	(a1,d0.w),a1
		move.w	(a1)+,obX(a0)
		move.w	(a1)+,obY(a0)
		move.b	(ObjectsList+obStatus).w,obStatus(a0)
		lea	(AniShield).l,a1
		jsr	(AnimateSprite).l
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_F836:
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

ObjEntryRingBeta:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_F848(pc,d0.w),d1
		jmp	off_F848(pc,d1.w)
; ---------------------------------------------------------------------------

off_F848:	dc.w loc_F84E-off_F848, loc_F880-off_F848, loc_F8C0-off_F848
; ---------------------------------------------------------------------------

loc_F84E:
		tst.l	(plcList).w
		beq.s	loc_F856
		rts
; ---------------------------------------------------------------------------

loc_F856:
		addq.b	#2,obRoutine(a0)
		move.l	#MapEntryRingBeta,obMap(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obActWid(a0)
		move.b	#$38,obPriority(a0)
		move.w	#$541,obGfx(a0)
		move.w	#$78,flashtime(a0)

loc_F880:
		move.w	(ObjectsList+obX).w,obX(a0)
		move.w	(ObjectsList+obY).w,obY(a0)
		move.b	(ObjectsList+obStatus).w,obStatus(a0)
		lea	(AniEntryRingBeta).l,a1
		jsr	(AnimateSprite).l
		cmpi.b	#2,obFrame(a0)
		bne.s	loc_F8BC
		tst.b	(ObjectsList).w
		beq.s	loc_F8BC
		move.b	#0,(ObjectsList).w
		move.w	#$A8,d0
		jsr	(PlaySFX).l

loc_F8BC:
		bra.w	ObjectDisplay
; ---------------------------------------------------------------------------

loc_F8C0:
		subq.w	#1,flashtime(a0)
		bne.s	locret_F8D0
		move.b	#1,(ObjectsList).w
		bra.w	ObjectDelete
; ---------------------------------------------------------------------------

locret_F8D0:
		rts
; ---------------------------------------------------------------------------
		include "levels/shared/Shield/Shield.ani"
		include "levels/shared/Shield/Shield.map"
		even
		include "levels/shared/SpecialRing/Sprite.ani"
		include "levels/shared/SpecialRing/Sprite.map"
		even
; ---------------------------------------------------------------------------

TouchObjects:
		nop
		moveq	#0,d5
		move.b	obHeight(a0),d5
		subq.b	#3,d5
		move.w	obX(a0),d2
		move.w	obY(a0),d3
		subq.w	#8,d2
		sub.w	d5,d3
		move.w	#$10,d4
		add.w	d5,d5
		lea	(LevelObjectsList).w,a1
		move.w	#$5F,d6

loc_FB6E:
		tst.b	obRender(a1)
		bpl.s	loc_FB7A
		move.b	obColType(a1),d0
		bne.s	loc_FBB8

loc_FB7A:
		lea	$40(a1),a1
		dbf	d6,loc_FB6E
		moveq	#0,d0

locret_FB84:
		rts
; ---------------------------------------------------------------------------
		dc.b $14, $14
		dc.b $C, $14
		dc.b $14, $C
		dc.b 4, $10
		dc.b $C, $12
		dc.b $10, $10
		dc.b 6, 6
		dc.b $18, $C
		dc.b $C, $10
		dc.b $10, $C
		dc.b 8, 8
		dc.b $14, $10
		dc.b $14, 8
		dc.b $E, $E
		dc.b $18, $18
		dc.b $28, $10
		dc.b $10, $18
		dc.b $C, $20
		dc.b $20, $70
		dc.b $40, $20
		dc.b $80, $20
		dc.b $20, $20
		dc.b 8, 8
		dc.b 4, 4
		dc.b $20, 8
; ---------------------------------------------------------------------------

loc_FBB8:
		andi.w	#$3F,d0
		add.w	d0,d0
		lea	locret_FB84(pc,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	obX(a1),d0
		sub.w	d1,d0
		sub.w	d2,d0
		bcc.s	loc_FBD8
		add.w	d1,d1
		add.w	d1,d0
		bcs.s	loc_FBDC
		bra.s	loc_FB7A
; ---------------------------------------------------------------------------

loc_FBD8:
		cmp.w	d4,d0
		bhi.s	loc_FB7A

loc_FBDC:
		moveq	#0,d1
		move.b	(a2)+,d1
		move.w	$C(a1),d0
		sub.w	d1,d0
		sub.w	d3,d0
		bcc.s	loc_FBF2
		add.w	d1,d1
		add.w	d0,d1
		bcs.s	loc_FBF6
		bra.s	loc_FB7A
; ---------------------------------------------------------------------------

loc_FBF2:
		cmp.w	d5,d0
		bhi.s	loc_FB7A

loc_FBF6:
		move.b	obColType(a1),d1
		andi.b	#$C0,d1
		beq.w	loc_FC6A
		cmpi.b	#$C0,d1
		beq.w	loc_FDC4
		tst.b	d1
		bmi.w	loc_FCE0
		move.b	obColType(a1),d0
		andi.b	#$3F,d0
		cmpi.b	#6,d0
		beq.s	loc_FC2E
		cmpi.w	#$5A,obRestartTimer(a0)
		bcc.w	locret_FC2C
		addq.b	#2,obRoutine(a1)

locret_FC2C:
		rts
; ---------------------------------------------------------------------------

loc_FC2E:
		tst.w	obVelYa0)
		bpl.s	loc_FC58
		move.w	$C(a0),d0
		subi.w	#$10,d0
		cmp.w	$C(a1),d0
		bcs.s	locret_FC68
		neg.w	obVelY(a0)
		move.w	#$FE80,obVelY(a1)
		tst.b	ob2ndRout(a1)
		bne.s	locret_FC68
		addq.b	#4,ob2ndRout(a1)
		rts
; ---------------------------------------------------------------------------

loc_FC58:
		cmpi.b	#2,obAnim(a0)
		bne.s	locret_FC68
		neg.w	obVelY(a0)
		addq.b	#2,obRoutine(a1)

locret_FC68:
		rts
; ---------------------------------------------------------------------------

loc_FC6A:
		tst.b	(byte_FFFE2D).w
		bne.s	loc_FC78
		cmpi.b	#2,obAnim(a0)
		bne.s	loc_FCE0

loc_FC78:
		tst.b	obColProp(a1)
		beq.s	loc_FCA2
		neg.w	obVelX(a0)
		neg.w	obVelY(a0)
		asr	obVelX(a0)
		asr	obVelY(a0)
		move.b	#0,obColType(a1)
		subq.b	#1,obColProp(a1)
		bne.s	locret_FCA0
		bset	#7,obStatus(a1)

locret_FCA0:
		rts
; ---------------------------------------------------------------------------

loc_FCA2:
		bset	#7,obStatus(a1)
		moveq	#$A,d0
		bsr.w	ScoreAdd
		move.b	#$27,obID(a1)
		move.b	#0,obRoutine(a1)
		tst.w	obVelY(a0)
		bmi.s	loc_FCD0
		move.w	obY(a0),d0
		cmp.w	obY(a1),d0
		bcc.s	loc_FCD8
		neg.w	obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCD0:
		addi.w	#$100,obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCD8:
		subi.w	#$100,obVelY(a0)
		rts
; ---------------------------------------------------------------------------

loc_FCE0:
		tst.b	(byte_FFFE2D).w
		beq.s	loc_FCEA

loc_FCE6:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_FCEA:
		nop
		tst.w	flashtime(a0)
		bne.s	loc_FCE6
		movea.l	a1,a2

loc_FCF4:
		tst.b	(byte_FFFE2C).w
		bne.s	loc_FD18
		tst.w	(Rings).w
		beq.s	loc_FD72
		bsr.w	ObjectLoad
		bne.s	loc_FD18
		move.b	#$37,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

loc_FD18:
		move.b	#0,(byte_FFFE2C).w
		move.b	#4,obRoutine(a0)
		bsr.w	sub_F218
		bset	#1,obStatus(a0)
		move.w	#$FC00,obVelY(a0)
		move.w	#$FE00,obVelX(a0)
		move.w	obX(a0),d0
		cmp.w	obX(a2),d0
		bcs.s	loc_FD48
		neg.w	obVelX(a0)

loc_FD48:
		move.w	#0,obInertia(a0)
		move.b	#$1A,obAnim(a0)
		move.w	#$258,$30(a0)
		move.w	#$A3,d0
		cmpi.b	#$36,(a2)
		bne.s	loc_FD68
		move.w	#$A6,d0

loc_FD68:
		jsr	(PlaySFX).l
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_FD72:
		tst.w	(word_FFFFFA).w
		bne.s	loc_FD18

loc_FD78:
		tst.w	(DebugRoutine).w
		bne.s	loc_FDC0
		move.b	#6,obRoutine(a0)
		bsr.w	sub_F218
		bset	#1,obStatus(a0)
		move.w	#$F900,obVelY(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,obInertia(a0)
		move.w	obY(a0),$38(a0)
		move.b	#$18,obAnim(a0)
		move.w	#$A3,d0
		cmpi.b	#$36,(a2)
		bne.s	loc_FDBA
		move.w	#$A6,d0

loc_FDBA:
		jsr	(PlaySFX).l

loc_FDC0:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

loc_FDC4:
		move.b	obColType(a1),d1
		andi.b	#$3F,d1
		cmpi.b	#$C,d1
		beq.s	loc_FDDA
		cmpi.b	#$17,d1
		beq.s	loc_FE0C
		rts
; ---------------------------------------------------------------------------

loc_FDDA:
		sub.w	d0,d5
		cmpi.w	#8,d5
		bcc.s	loc_FE08
		move.w	obX(a1),d0
		subq.w	#4,d0
		btst	#0,obStatus(a1)
		beq.s	loc_FDF4
		subi.w	#$10,d0

loc_FDF4:
		sub.w	d2,d0
		bcc.s	loc_FE00
		addi.w	#$18,d0
		bcs.s	loc_FE04
		bra.s	loc_FE08
; ---------------------------------------------------------------------------

loc_FE00:
		cmp.w	d4,d0
		bhi.s	loc_FE08

loc_FE04:
		bra.w	loc_FCE0
; ---------------------------------------------------------------------------

loc_FE08:
		bra.w	loc_FC6A
; ---------------------------------------------------------------------------

loc_FE0C:
		addq.b	#1,obColProp(a1)
		rts
; ---------------------------------------------------------------------------

sub_FE12:
		btst	#3,obStatus(a0)
		beq.s	loc_FE26
		moveq	#0,d0
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
		rts
; ---------------------------------------------------------------------------

loc_FE26:
		moveq	#3,d0
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_100B0
		cmpi.b	#$80,d0
		beq.w	loc_10014
		cmpi.b	#$C0,d0
		beq.w	loc_FF7E
		move.w	$C(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		bsr.w	sub_FF52
		tst.w	d1
		beq.s	locret_FEC6
		bpl.s	loc_FEC8
		cmpi.w	#$FFF2,d1
		blt.s	locret_FEE8
		add.w	d1,$C(a0)

locret_FEC6:
		rts
; ---------------------------------------------------------------------------

loc_FEC8:
		cmpi.w	#$E,d1
		bgt.s	loc_FED4
		add.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_FED4:
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		move.b	#1,obNextAni(a0)
		rts
; ---------------------------------------------------------------------------

locret_FEE8:
		rts
; ---------------------------------------------------------------------------
		move.l	obX(a0),d2
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2
		move.l	d2,obX(a0)
		move.w	#$38,d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,obY(a0)
		rts
; ---------------------------------------------------------------------------

locret_FF0C:
		rts
; ---------------------------------------------------------------------------
		move.l	obY(a0),d3
		move.w	obVelY(a0),d0
		subi.w	#$38,d0
		move.w	d0,obVelY(a0)
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d3,obY(a0)
		rts
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------

sub_FF2C:
		move.l	obX(a0),d2
		move.l	obY(a0),d3
		move.w	obVelX(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d2

loc_FF3E:
		move.w	obVelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		sub.l	d0,d3
		move.l	d2,obX(a0)
		move.l	d3,obY(a0)
		rts
; ---------------------------------------------------------------------------

sub_FF52:
		move.b	(unk_FFF76A).w,d2
		cmp.w	d0,d1
		ble.s	loc_FF60
		move.b	(unk_FFF768).w,d2
		move.w	d0,d1

loc_FF60:
		btst	#0,d2

loc_FF64:
		bne.s	loc_FF6C
		move.b	d2,obAngle(a0)
		rts
; ---------------------------------------------------------------------------

loc_FF6C:
		move.b	obAngle(a0),d2
		addi.b	#$20,d2
		andi.b	#$C0,d2
		move.b	d2,obAngle(a0)
		rts
; ---------------------------------------------------------------------------

loc_FF7E:
		move.w	$C(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0

loc_FF88:
		move.b	obWidth(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_102FC
		move.w	d1,-(sp)

loc_FFAE:
		move.w	$C(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5

loc_FFD6:
		bsr.w	sub_102FC
		move.w	(sp)+,d0
		bsr.w	sub_FF52
		tst.w	d1
		beq.s	locret_FFF2
		bpl.s	loc_FFF4
		cmpi.w	#$FFF2,d1
		blt.w	locret_FF0C
		add.w	d1,obX(a0)

locret_FFF2:
		rts
; ---------------------------------------------------------------------------

loc_FFF4:
		cmpi.w	#$E,d1
		bgt.s	loc_10000
		add.w	d1,obX(a0)

locret_FFFE:
		rts
; ---------------------------------------------------------------------------

loc_10000:
		bset	#1,$22(a0)
		bclr	#5,$22(a0)
		move.b	#1,$1D(a0)
		rts
; ---------------------------------------------------------------------------

loc_10014:
		move.w	$C(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		bsr.w	sub_FF52
		tst.w	d1
		beq.s	locret_1008E
		bpl.s	loc_10090
		cmpi.w	#$FFF2,d1
		blt.w	locret_FEE8
		sub.w	d1,obY(a0)

locret_1008E:
		rts
; ---------------------------------------------------------------------------

loc_10090:
		cmpi.w	#$E,d1
		bgt.s	loc_1009C
		sub.w	d1,obY(a0)
		rts
; ---------------------------------------------------------------------------

loc_1009C:
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		move.b	#1,obNextAni(a0)
		rts
; ---------------------------------------------------------------------------

loc_100B0:
		move.w	$C(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	sub_102FC
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	sub_102FC
		move.w	(sp)+,d0
		bsr.w	sub_FF52
		tst.w	d1
		beq.s	locret_1012A
		bpl.s	loc_1012C
		cmpi.w	#$FFF2,d1
		blt.w	locret_FF0C
		sub.w	d1,obX(a0)

locret_1012A:
		rts
; ---------------------------------------------------------------------------

loc_1012C:
		cmpi.w	#$E,d1
		bgt.s	loc_10138
		sub.w	d1,obX(a0)
		rts
; ---------------------------------------------------------------------------

loc_10138:
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		move.b	#1,obNextAni(a0)
		rts
; ---------------------------------------------------------------------------

sub_1014C:
		move.w	d2,d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.w	d3,d1
		lsr.w	#8,d1
		andi.w	#$7F,d1
		add.w	d1,d0
		moveq	#-1,d1
		lea	(Layout).w,a1
		move.b	(a1,d0.w),d1
		beq.s	loc_10186
		bmi.s	loc_1018A
		subq.b	#1,d1
		ext.w	d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1

loc_10186:
		movea.l	d1,a1
		rts
; ---------------------------------------------------------------------------

loc_1018A:
		andi.w	#$7F,d1
		btst	#6,1(a0)
		beq.s	loc_101A2
		addq.w	#1,d1
		cmpi.w	#$29,d1
		bne.s	loc_101A2
		move.w	#$51,d1

loc_101A2:
		subq.b	#1,d1
		ror.w	#7,d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1
		movea.l	d1,a1
		rts
; ---------------------------------------------------------------------------

sub_101BE:
		bsr.s	sub_1014C
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_101CE
		btst	d5,d4
		bne.s	loc_101DC

loc_101CE:
		add.w	a3,d2
		bsr.w	sub_10264
		sub.w	a3,d2
		addi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

loc_101DC:
		movea.l	(Collision).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_101CE
		lea	(byte_68000).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$B,d4
		beq.s	loc_10202
		not.w	d1
		neg.b	(a4)

loc_10202:
		btst	#$C,d4
		beq.s	loc_10212
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_10212:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(byte_68100).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4
		beq.s	loc_1022E
		neg.w	d0

loc_1022E:
		tst.w	d0
		beq.s	loc_101CE
		bmi.s	loc_1024A
		cmpi.b	#$10,d0
		beq.s	loc_10256
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_1024A:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_101CE

loc_10256:
		sub.w	a3,d2
		bsr.w	sub_10264
		add.w	a3,d2
		subi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

sub_10264:
		bsr.w	sub_1014C
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_10276
		btst	d5,d4
		bne.s	loc_10284

loc_10276:
		move.w	#$F,d1
		move.w	d2,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_10284:
		movea.l	(Collision).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_10276
		lea	(byte_68000).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d3,d1
		btst	#$B,d4
		beq.s	loc_102AA
		not.w	d1
		neg.b	(a4)

loc_102AA:
		btst	#$C,d4
		beq.s	loc_102BA
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_102BA:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(byte_68100).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$C,d4
		beq.s	loc_102D6
		neg.w	d0

loc_102D6:
		tst.w	d0
		beq.s	loc_10276
		bmi.s	loc_102EC
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_102EC:
		move.w	d2,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_10276
		not.w	d1
		rts
; ---------------------------------------------------------------------------

sub_102FC:
		bsr.w	sub_1014C
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_1030E
		btst	d5,d4
		bne.s	loc_1031C

loc_1030E:
		add.w	a3,d3
		bsr.w	sub_103A4
		sub.w	a3,d3
		addi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

loc_1031C:
		movea.l	(Collision).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_1030E
		lea	(byte_68000).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	loc_1034A
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_1034A:
		btst	#$B,d4
		beq.s	loc_10352
		neg.b	(a4)

loc_10352:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(byte_69100).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_1036E
		neg.w	d0

loc_1036E:
		tst.w	d0
		beq.s	loc_1030E
		bmi.s	loc_1038A
		cmpi.b	#$10,d0
		beq.s	loc_10396
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_1038A:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_1030E

loc_10396:
		sub.w	a3,d3
		bsr.w	sub_103A4
		add.w	a3,d3
		subi.w	#$10,d1
		rts
; ---------------------------------------------------------------------------

sub_103A4:
		bsr.w	sub_1014C
		move.w	(a1),d0
		move.w	d0,d4
		andi.w	#$7FF,d0
		beq.s	loc_103B6
		btst	d5,d4
		bne.s	loc_103C4

loc_103B6:
		move.w	#$F,d1
		move.w	d3,d0
		andi.w	#$F,d0
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_103C4:
		movea.l	(Collision).w,a2
		move.b	(a2,d0.w),d0
		andi.w	#$FF,d0
		beq.s	loc_103B6
		lea	(byte_68000).l,a2
		move.b	(a2,d0.w),(a4)
		lsl.w	#4,d0
		move.w	d2,d1
		btst	#$C,d4
		beq.s	loc_103F2
		not.w	d1
		addi.b	#$40,(a4)
		neg.b	(a4)
		subi.b	#$40,(a4)

loc_103F2:
		btst	#$B,d4
		beq.s	loc_103FA
		neg.b	(a4)

loc_103FA:
		andi.w	#$F,d1
		add.w	d0,d1
		lea	(byte_69100).l,a2
		move.b	(a2,d1.w),d0
		ext.w	d0
		eor.w	d6,d4
		btst	#$B,d4
		beq.s	loc_10416
		neg.w	d0

loc_10416:
		tst.w	d0
		beq.s	loc_103B6
		bmi.s	loc_1042C
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		move.w	#$F,d1
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

loc_1042C:
		move.w	d3,d1
		andi.w	#$F,d1
		add.w	d1,d0
		bpl.w	loc_103B6
		not.w	d1
		rts
; ---------------------------------------------------------------------------

nullsub_2:
		rts
; ---------------------------------------------------------------------------
		lea	(byte_68100).l,a1
		lea	(byte_68100).l,a2
		move.w	#$FF,d3

loc_1044E:
		moveq	#$10,d5
		move.w	#$F,d2

loc_10454:
		moveq	#0,d4
		move.w	#$F,d1

loc_1045A:
		move.w	(a1)+,d0
		lsr.l	d5,d0
		addx.w	d4,d4
		dbf	d1,loc_1045A
		move.w	d4,(a2)+
		suba.w	#$20,a1
		subq.w	#1,d5
		dbf	d2,loc_10454
		adda.w	#$20,a1
		dbf	d3,loc_1044E
		lea	(byte_68100).l,a1
		lea	(byte_69100).l,a2
		bsr.s	sub_10492
		lea	(byte_68100).l,a1
		lea	(byte_68100).l,a2
; ---------------------------------------------------------------------------

sub_10492:
		move.w	#$FFF,d3

loc_10496:
		moveq	#0,d2
		move.w	#$F,d1
		move.w	(a1)+,d0
		beq.s	loc_104C4
		bmi.s	loc_104AE

loc_104A2:
		lsr.w	#1,d0
		bcc.s	loc_104A8
		addq.b	#1,d2

loc_104A8:
		dbf	d1,loc_104A2
		bra.s	loc_104C6
; ---------------------------------------------------------------------------

loc_104AE:
		cmpi.w	#$FFFF,d0
		beq.s	loc_104C0

loc_104B4:
		lsl.w	#1,d0
		bcc.s	loc_104BA
		subq.b	#1,d2

loc_104BA:
		dbf	d1,loc_104B4
		bra.s	loc_104C6
; ---------------------------------------------------------------------------

loc_104C0:
		move.w	#$10,d0

loc_104C4:
		move.w	d0,d2

loc_104C6:
		move.b	d2,(a2)+
		dbf	d3,loc_10496
		rts
; ---------------------------------------------------------------------------

sub_104CE:
		move.l	obX(a0),d3
		move.l	obY(a0),d2
		move.w	obVelX(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d3
		move.w	obVelY(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d2
		swap	d2
		swap	d3
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
		move.b	d0,d1
		addi.b	#$20,d0
		andi.b	#$C0,d0
		beq.w	loc_105C8
		cmpi.b	#$80,d0
		beq.w	loc_10754
		andi.b	#$38,d1
		bne.s	loc_10514
		addq.w	#8,d2

loc_10514:
		cmpi.b	#$40,d0
		beq.w	loc_10822
		bra.w	loc_10694
; ---------------------------------------------------------------------------

sub_10520:
		move.b	d0,(unk_FFF768).w
		move.b	d0,(unk_FFF76A).w
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_107AE
		cmpi.b	#$80,d0
		beq.w	sub_106E0
		cmpi.b	#$C0,d0
		beq.w	loc_10628

loc_10548:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		move.b	#0,d2

loc_105A8:
		move.b	(unk_FFF76A).w,d3
		cmp.w	d0,d1
		ble.s	loc_105B6
		move.b	(unk_FFF768).w,d3
		move.w	d0,d1

loc_105B6:
		btst	#0,d3
		beq.s	locret_105BE
		move.b	d2,d3

locret_105BE:
		rts
; ---------------------------------------------------------------------------
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_105C8:
		addi.w	#$A,d2
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	#0,d2

loc_105E2:
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_105EE
		move.b	d2,d3

locret_105EE:
		rts
; ---------------------------------------------------------------------------

sub_105F0:
		move.w	obX(a0),d3

loc_105F4:
		move.w	obY(a0),d2
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		lea	(unk_FFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	sub_101BE
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_10626
		move.b	#0,d3

locret_10626:
		rts
; ---------------------------------------------------------------------------

loc_10628:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	sub_102FC
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	sub_102FC
		move.w	(sp)+,d0
		move.b	#$C0,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------

sub_1068C:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_10694:
		addi.w	#$A,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	sub_102FC
		move.b	#$C0,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

sub_106B2:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
		lea	(unk_FFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	sub_102FC
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_106DE
		move.b	#$C0,d3

locret_106DE:
		rts
; ---------------------------------------------------------------------------

sub_106E0:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.w	d1,-(sp)
		move.w	$C(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.w	(sp)+,d0
		move.b	#$80,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_10754:
		subi.w	#$A,d2
		eori.w	#$F,d2
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	#$80,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

sub_10776:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	sub_101BE
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_107AC
		move.b	#$80,d3

locret_107AC:
		rts
; ---------------------------------------------------------------------------

loc_107AE:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	sub_102FC
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(unk_FFF76A).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	sub_102FC
		move.w	(sp)+,d0
		move.b	#$40,d2
		bra.w	loc_105A8
; ---------------------------------------------------------------------------

sub_1081A:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_10822:
		subi.w	#$A,d3
		eori.w	#$F,d3
		lea	(unk_FFF768).w,a4
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	sub_102FC
		move.b	#$40,d2
		bra.w	loc_105E2
; ---------------------------------------------------------------------------

sub_10844:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
		lea	(unk_FFF768).w,a4
		move.b	#0,(a4)
		movea.w	#$FFF0,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	sub_102FC
		move.b	(unk_FFF768).w,d3
		btst	#0,d3
		beq.s	locret_10870
		move.b	#$40,d3

locret_10870:
		rts
; ---------------------------------------------------------------------------

sub_10872:
		bsr.w	sub_109AE
		bsr.w	loc_10AE2
		move.w	d5,-(sp)
		lea	(byte_FF8000).w,a1
		move.b	(unk_FFF780).w,d0
		andi.b	#$FC,d0
		jsr	(GetSine).l
		move.w	d0,d4
		move.w	d1,d5
		muls.w	#$18,d4
		muls.w	#$18,d5
		moveq	#0,d2
		move.w	(CameraX).w,d2
		divu.w	#$18,d2
		swap	d2
		neg.w	d2
		addi.w	#-$B4,d2
		moveq	#0,d3
		move.w	(CameraY).w,d3
		divu.w	#$18,d3
		swap	d3
		neg.w	d3
		addi.w	#-$B4,d3
		move.w	#$F,d7

loc_108C2:
		movem.w	d0-d2,-(sp)
		movem.w	d0-d1,-(sp)
		neg.w	d0
		muls.w	d2,d1
		muls.w	d3,d0
		move.l	d0,d6
		add.l	d1,d6
		movem.w	(sp)+,d0-d1
		muls.w	d2,d0
		muls.w	d3,d1
		add.l	d0,d1
		move.l	d6,d2
		move.w	#$F,d6

loc_108E4:
		move.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		move.l	d1,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		add.l	d5,d2
		add.l	d4,d1
		dbf	d6,loc_108E4
		movem.w	(sp)+,d0-d2
		addi.w	#$18,d3
		dbf	d7,loc_108C2
		move.w	(sp)+,d5
		lea	((Chunks)&$FFFFFF).l,a0
		moveq	#0,d0
		move.w	(CameraY).w,d0
		divu.w	#$18,d0
		mulu.w	#$80,d0
		adda.l	d0,a0
		moveq	#0,d0
		move.w	(CameraX).w,d0
		divu.w	#$18,d0
		adda.w	d0,a0
		lea	(byte_FF8000).w,a4
		move.w	#$F,d7

loc_10930:
		move.w	#$F,d6

loc_10934:
		moveq	#0,d0
		move.b	(a0)+,d0
		beq.s	loc_10986
		move.w	(a4),d3
		addi.w	#$120,d3
		cmpi.w	#$70,d3
		bcs.s	loc_10986
		cmpi.w	#$1D0,d3
		bcc.s	loc_10986
		move.w	2(a4),d2
		addi.w	#$F0,d2
		cmpi.w	#$70,d2
		bcs.s	loc_10986
		cmpi.w	#$170,d2
		bcc.s	loc_10986
		lea	((byte_FF4000)&$FFFFFF).l,a5
		lsl.w	#3,d0
		lea	(a5,d0.w),a5
		movea.l	(a5)+,a1
		move.w	(a5)+,d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		movea.w	(a5)+,a3
		moveq	#0,d1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_10986
		jsr	sub_88AA

loc_10986:
		addq.w	#4,a4
		dbf	d6,loc_10934
		lea	$70(a0),a0
		dbf	d7,loc_10930
		move.b	d5,(byte_FFF62C).w
		cmpi.b	#$50,d5
		beq.s	loc_109A6
		move.l	#0,(a2)
		rts
; ---------------------------------------------------------------------------

loc_109A6:
		move.b	#0,-5(a2)
		rts
; ---------------------------------------------------------------------------

sub_109AE:
		lea	((byte_FF400C)&$FFFFFF).l,a1
		moveq	#0,d0
		move.b	(unk_FFF780).w,d0
		lsr.b	#2,d0
		andi.w	#$F,d0
		moveq	#$F,d1

loc_109C2:
		move.w	d0,(a1)
		addq.w	#8,a1
		dbf	d1,loc_109C2
		subq.b	#1,(RingTimer).w
		bpl.s	loc_109E0
		move.b	#7,(RingTimer).w
		addq.b	#1,(RingFrame).w
		andi.b	#3,(RingFrame).w

loc_109E0:
		move.b	(RingFrame).w,1(a1)
		addq.w	#8,a1
		addq.w	#8,a1
		subq.b	#1,(unk_FFFEC4).w
		bpl.s	loc_10A02
		move.b	#7,(unk_FFFEC4).w
		bra.s	loc_10A02
; ---------------------------------------------------------------------------
		addq.b	#1,(unk_FFFEC5).w
		andi.b	#1,(unk_FFFEC5).w

loc_10A02:
		move.b	(unk_FFFEC5).w,1(a1)
		addq.w	#8,a1
		move.b	(unk_FFFEC5).w,1(a1)
		subq.b	#1,(unk_FFFEC0).w
		bpl.s	loc_10A26
		move.b	#7,(unk_FFFEC0).w
		subq.b	#1,(unk_FFFEC1).w
		andi.b	#3,(unk_FFFEC1).w

loc_10A26:
		lea	((byte_FF402E)&$FFFFFF).l,a1
		lea	(word_10A8C).l,a0
		moveq	#0,d0
		move.b	(unk_FFFEC1).w,d0
		add.w	d0,d0
		lea	(a0,d0.w),a0
		move.w	(a0),(a1)
		move.w	obGfx(a0),obX(a1)
		move.w	obMap(a0),obVelX(a1)
		move.w	obMap+2(a0),obPriority(a1)
		adda.w	#$10,a0
		adda.w	#$20,a1
		move.w	(a0),(a1)
		move.w	obGfx(a0),obX(a1)
		move.w	obMap(a0),obVelX(a1)
		move.w	obMap+2(a0),obPriority(a1)
		adda.w	#$10,a0
		adda.w	#$20,a1
		move.w	(a0),(a1)
		move.w	obGfx(a0),obX(a1)
		move.w	obMap(a0),obVelX(a1)
		move.w	obMap+2(a0),obPriority(a1)
		rts
; ---------------------------------------------------------------------------

word_10A8C:	dc.w $142, $142, $142, $2142
		dc.w $142, $142, $142, $142
		dc.w $2142, $2142, $2142, $142
		dc.w $2142, $2142, $2142, $2142
		dc.w $4142, $4142, $4142, $2142
		dc.w $4142, $4142, $4142, $4142
		dc.w $6142, $6142, $6142, $2142
		dc.w $6142, $6142, $6142, $6142
; ---------------------------------------------------------------------------

sub_10ACC:
		lea	((byte_FF4400)&$FFFFFF).l,a2
		move.w	#$1F,d0

loc_10AD6:
		tst.b	(a2)
		beq.s	locret_10AE0
		addq.w	#8,a2
		dbf	d0,loc_10AD6

locret_10AE0:
		rts
; ---------------------------------------------------------------------------

loc_10AE2:
		lea	((byte_FF4400)&$FFFFFF).l,a0
		move.w	#$1F,d7

loc_10AEC:
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	loc_10AFA
		lsl.w	#2,d0
		movea.l	loc_10AFC+2(pc,d0.w),a1
		jsr	(a1)

loc_10AFA:
		addq.w	#8,a0

loc_10AFC:
		dbf	d7,loc_10AEC
		rts
; ---------------------------------------------------------------------------
		dc.l loc_10B0A, loc_10B3A
; ---------------------------------------------------------------------------

loc_10B0A:
		subq.b	#1,obGfx(a0)
		bpl.s	locret_10B32
		move.b	#5,obGfx(a0)
		moveq	#0,d0
		move.b	obGfx+1(a0),d0
		addq.b	#1,obGfx+1(a0)
		movea.l	4(a0),a1
		move.b	byte_10B34(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_10B32
		clr.l	(a0)
		clr.l	obMap(a0)

locret_10B32:
		rts
; ---------------------------------------------------------------------------

byte_10B34:	dc.b $17, $18, $19, $1A, 0, 0
; ---------------------------------------------------------------------------

loc_10B3A:
		subq.b	#1,obGfx(a0)
		bpl.s	locret_10B68
		move.b	#7,obGfx(a0)
		moveq	#0,d0
		move.b	obGfx+1(a0),d0
		addq.b	#1,obGfx+1(a0)
		movea.l	obMap(a0),a1
		move.b	byte_10B6A(pc,d0.w),d0
		bne.s	loc_10B66
		clr.l	(a0)
		clr.l	obMap(a0)
		move.b	#$12,(a1)
		rts
; ---------------------------------------------------------------------------

loc_10B66:
		move.b	d0,(a1)

locret_10B68:
		rts
; ---------------------------------------------------------------------------

byte_10B6A:	dc.b $1B, $1C, $1B, $1C, 0, 0
; ---------------------------------------------------------------------------

sub_10B70:
		lea	((Chunks)&$FFFFFF).l,a1
		move.w	#$FFF,d0

loc_10B7A:
		clr.l	(a1)+
		dbf	d0,loc_10B7A
		lea	((byte_FF172E)&$FFFFFF).l,a1
		lea	(byte_6AB08).l,a0
		moveq	#$23,d1

loc_10B8E:
		moveq	#8,d2

loc_10B90:
		move.l	(a0)+,(a1)+
		dbf	d2,loc_10B90
		lea	$5C(a1),a1
		dbf	d1,loc_10B8E
		lea	((byte_FF4008)&$FFFFFF).l,a1
		lea	(off_10BD0).l,a0
		moveq	#$1B,d1

loc_10BAC:
		move.l	(a0)+,(a1)+
		move.w	#0,(a1)+
		move.b	-4(a0),-1(a1)
		move.w	(a0)+,(a1)+
		dbf	d1,loc_10BAC
		lea	((byte_FF4400)&$FFFFFF).l,a1
		move.w	#$3F,d1

loc_10BC8:
		clr.l	(a1)+
		dbf	d1,loc_10BC8
		rts
; ---------------------------------------------------------------------------

off_10BD0:	dc.l off_63000
		dc.w $142
		dc.l off_63000
		dc.w $2142
		dc.l off_63000
		dc.w $4142
		dc.l off_63000
		dc.w $6142
		dc.l off_63000
		dc.w $142
		dc.l off_63000
		dc.w $142
		dc.l off_63000
		dc.w $142
		dc.l off_63000
		dc.w $142
		dc.l off_63000
		dc.w $2142
		dc.l off_63000
		dc.w $2142
		dc.l off_63000
		dc.w $2142
		dc.l off_63000
		dc.w $2142
		dc.l off_63000
		dc.w $4142
		dc.l off_63000
		dc.w $4142
		dc.l off_63000
		dc.w $4142
		dc.l off_63000
		dc.w $4142
		dc.l MapRing
		dc.w $27B2
		dc.l MapBumper
		dc.w $23B
		dc.l off_10C78
		dc.w $251
		dc.l off_10C88
		dc.w $251
		dc.l off_10C78
		dc.w $263
		dc.l off_10C88
		dc.w $263
		dc.l $4007F64
		dc.w $27B2
		dc.l $5007F64
		dc.w $27B2
		dc.l $6007F64
		dc.w $27B2
		dc.l $7007F64
		dc.w $27B2
		dc.l $100C6C2
		dc.w $23B
		dc.l $200C6C2
		dc.w $23B

off_10C78:	dc.w byte_10C7C-off_10C78, byte_10C82-off_10C78

byte_10C7C:	dc.b 1
		dc.b $F4, $A, 0, 0, $F4

byte_10C82:	dc.b 1
		dc.b $F4, $A, $20, 0, $F4

off_10C88:	dc.w byte_10C8C-off_10C88, byte_10C92-off_10C88

byte_10C8C:	dc.b 1
		dc.b $F4, $A, 0, 9, $F4

byte_10C92:	dc.b 1
		dc.b $F4, $A, $20, 9, $F4
; ---------------------------------------------------------------------------
		lea	((byte_FF1020)&$FFFFFF).l,a1
		lea	(byte_6AB08).l,a0
		moveq	#$3F,d1

loc_10CA6:
		moveq	#$F,d2

loc_10CA8:
		move.l	(a0)+,(a1)+
		dbf	d2,loc_10CA8
		lea	$40(a1),a1
		dbf	d1,loc_10CA6
		rts
; ---------------------------------------------------------------------------

ObjSonicSpecial:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_10CC6(pc,d0.w),d1
		jmp	off_10CC6(pc,d1.w)
; ---------------------------------------------------------------------------

off_10CC6:	dc.w loc_10CCE-off_10CC6, loc_10D0A-off_10CC6, loc_10EF8-off_10CC6, loc_10F3C-off_10CC6
; ---------------------------------------------------------------------------

loc_10CCE:
		addq.b	#2,obRoutine(a0)
		move.b	#$E,obHeight(a0)
		move.b	#7,obWidth(a0)
		move.l	#MapSonic,obMap(a0)
		move.w	#$780,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#0,obActWid(a0)
		move.b	#2,obAnim(a0)
		bset	#2,obStatus(a0)
		bset	#1,obStatus(a0)

loc_10D0A:
		move.b	#0,flashtime(a0)
		moveq	#0,d0
		move.b	obStatus(a0),d0
		andi.w	#2,d0
		move.w	off_10D2E(pc,d0.w),d1
		jsr	off_10D2E(pc,d1.w)
		jsr	ObjSonic_DynTiles
		jmp	ObjectDisplay
; ---------------------------------------------------------------------------

off_10D2E:	dc.w loc_10D32-off_10D2E, loc_10D40-off_10D2E
; ---------------------------------------------------------------------------

loc_10D32:
		bsr.w	sub_10E8A
		bsr.w	sub_10D94
		bsr.w	sub_10F7C
		bra.s	loc_10D48
; ---------------------------------------------------------------------------

loc_10D40:
		bsr.w	sub_10D94
		bsr.w	sub_10F7C

loc_10D48:
		bsr.w	sub_1107C
		bsr.w	sub_110DE
		jsr	ObjectMove
		bsr.w	sub_10ECE
		btst	#6,(padHeld1).w
		beq.s	loc_10D66
		subq.w	#2,(unk_FFF782).w

loc_10D66:
		btst	#4,(padHeld1).w
		beq.s	loc_10D72
		addq.w	#2,(unk_FFF782).w

loc_10D72:
		btst	#7,(padPress1).w
		beq.s	loc_10D80
		move.w	#0,(unk_FFF782).w

loc_10D80:
		move.w	(unk_FFF780).w,d0
		add.w	(unk_FFF782).w,d0
		move.w	d0,(unk_FFF780).w
		jsr	ObjSonic_Animate
		rts
; ---------------------------------------------------------------------------

sub_10D94:
		btst	#2,(padHeldPlayer).w
		beq.s	loc_10DA0
		bsr.w	sub_10E2C

loc_10DA0:
		btst	#3,(padHeldPlayer).w
		beq.s	loc_10DAC
		bsr.w	sub_10E5C

loc_10DAC:
		move.b	(padHeldPlayer).w,d0
		andi.b	#$C,d0
		bne.s	loc_10DDC
		move.w	obInertia(a0),d0
		beq.s	loc_10DDC
		bmi.s	loc_10DCE
		subi.w	#$C,d0
		bcc.s	loc_10DC8
		move.w	#0,d0

loc_10DC8:
		move.w	d0,obInertia(a0)
		bra.s	loc_10DDC
; ---------------------------------------------------------------------------

loc_10DCE:
		addi.w	#$C,d0
		bcc.s	loc_10DD8
		move.w	#0,d0

loc_10DD8:
		move.w	d0,$14(a0)

loc_10DDC:
		move.b	(unk_FFF780).w,d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		neg.b	d0
		jsr	(GetSine).l
		muls.w	obInertia(a0),d1
		add.l	d1,8(a0)
		muls.w	obInertia(a0),d0
		add.l	d0,$C(a0)
		movem.l	d0-d1,-(sp)
		move.l	obY(a0),d2
		move.l	obX(a0),d3
		bsr.w	sub_1100E
		beq.s	loc_10E26
		movem.l	(sp)+,d0-d1
		sub.l	d1,obX(a0)
		sub.l	d0,obY(a0)
		move.w	#0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_10E26:
		movem.l	(sp)+,d0-d1
		rts
; ---------------------------------------------------------------------------

sub_10E2C:
		bset	#0,obStatus(a0)
		move.w	obInertia(a0),d0
		beq.s	loc_10E3A
		bpl.s	loc_10E4E

loc_10E3A:
		subi.w	#$C,d0
		cmpi.w	#$F800,d0
		bgt.s	loc_10E48
		move.w	#$F800,d0

loc_10E48:
		move.w	d0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

loc_10E4E:
		subi.w	#$40,d0
		bcc.s	loc_10E56
		nop

loc_10E56:
		move.w	d0,obInertia(a0)
		rts
; ---------------------------------------------------------------------------

sub_10E5C:
		bclr	#0,obStatus(a0)
		move.w	obInertia(a0),d0
		bmi.s	loc_10E7C
		addi.w	#$C,d0
		cmpi.w	#$800,d0
		blt.s	loc_10E76
		move.w	#$800,d0

loc_10E76:
		move.w	d0,obInertia(a0)
		bra.s	locret_10E88
; ---------------------------------------------------------------------------

loc_10E7C:
		addi.w	#$40,d0
		bcc.s	loc_10E84
		nop

loc_10E84:
		move.w	d0,obInertia(a0)

locret_10E88:
		rts
; ---------------------------------------------------------------------------

sub_10E8A:
		move.b	(padPressPlayer).w,d0
		andi.b	#$20,d0
		beq.s	locret_10ECC
		move.b	(unk_FFF780).w,d0
		andi.b	#$FC,d0
		neg.b	d0
		subi.b	#$40,d0
		jsr	(GetSine).l
		muls.w	#$700,d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	#$700,d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)
		bset	#1,obStatus(a0)
		move.w	#$A0,d0
		jsr	(PlaySFX).l

locret_10ECC:
		rts
; ---------------------------------------------------------------------------

sub_10ECE:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		move.w	(CameraX).w,d0
		subi.w	#$A0,d3
		bcs.s	loc_10EE6
		sub.w	d3,d0
		sub.w	d0,(CameraX).w

loc_10EE6:
		move.w	(CameraY).w,d0
		subi.w	#$70,d2
		bcs.s	locret_10EF6
		sub.w	d2,d0
		sub.w	d0,(CameraY).w

locret_10EF6:
		rts
; ---------------------------------------------------------------------------

loc_10EF8:
		addi.w	#$40,(unk_FFF782).w
		cmpi.w	#$3000,(unk_FFF782).w
		blt.s	loc_10F1C
		move.w	#0,(unk_FFF782).w
		move.w	#$4000,(unk_FFF780).w
		addq.b	#2,$24(a0)
		move.w	#$12C,$38(a0)

loc_10F1C:
		move.w	(unk_FFF780).w,d0
		add.w	(unk_FFF782).w,d0
		move.w	d0,(unk_FFF780).w
		bsr.w	ObjSonic_Animate
		jsr	ObjSonic_DynTiles
		bsr.w	sub_10ECE
		jmp	ObjectDisplay
; ---------------------------------------------------------------------------

loc_10F3C:
		subq.w	#1,$38(a0)
		bne.s	loc_10F66
		clr.w	(unk_FFF780).w
		move.w	#$40,(unk_FFF782).w
		move.w	#$458,(ObjectsList+obX).w
		move.w	#$4A0,(ObjectsList+obY).w
		clr.b	obRoutine(a0)
		move.l	a0,-(sp)
		jsr	sub_10B70
		movea.l	(sp)+,a0

loc_10F66:
		jsr	ObjSonic_Animate
		jsr	ObjSonic_DynTiles
		bsr.w	sub_10ECE
		jmp	ObjectDisplay
; ---------------------------------------------------------------------------

sub_10F7C:
		move.l	obY(a0),d2
		move.l	obX(a0),d3
		move.b	(unk_FFF780).w,d0
		andi.b	#$FC,d0
		jsr	(GetSine).l
		move.w	$10(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d0
		add.l	d4,d0
		move.w	$12(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d1
		add.l	d4,d1
		add.l	d0,d3
		bsr.w	sub_1100E
		beq.s	loc_10FD6
		sub.l	d0,d3
		moveq	#0,d0
		move.w	d0,$10(a0)
		bclr	#1,$22(a0)
		add.l	d1,d2
		bsr.w	sub_1100E
		beq.s	loc_10FEC
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_10FD6:
		add.l	d1,d2
		bsr.w	sub_1100E
		beq.s	loc_10FFA
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,$12(a0)
		bclr	#1,$22(a0)

loc_10FEC:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,$10(a0)
		move.w	d1,$12(a0)
		rts
; ---------------------------------------------------------------------------

loc_10FFA:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,$10(a0)
		move.w	d1,$12(a0)
		bset	#1,$22(a0)
		rts
; ---------------------------------------------------------------------------

sub_1100E:
		lea	((Chunks)&$FFFFFF).l,a1
		moveq	#0,d4
		swap	d2
		move.w	d2,d4
		swap	d2
		addi.w	#$44,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		swap	d3
		move.w	d3,d4
		swap	d3
		addi.w	#$14,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		moveq	#0,d5
		move.b	(a1)+,d4
		bsr.s	sub_11056
		move.b	(a1)+,d4
		bsr.s	sub_11056
		adda.w	#$7E,a1
		move.b	(a1)+,d4
		bsr.s	sub_11056
		move.b	(a1)+,d4
		bsr.s	sub_11056
		tst.b	d5
		rts
; ---------------------------------------------------------------------------

sub_11056:
		beq.s	locret_1105E
		cmpi.b	#$11,d4
		bne.s	loc_11060

locret_1105E:
		rts
; ---------------------------------------------------------------------------

loc_11060:
		cmpi.b	#$12,d4
		bcs.s	loc_11078
		cmpi.b	#$17,d4
		bcc.s	locret_1105E
		move.b	d4,$30(a0)
		move.l	a1,$32(a0)
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

loc_11078:
		moveq	#-1,d5
		rts
; ---------------------------------------------------------------------------

sub_1107C:
		lea	((Chunks)&$FFFFFF).l,a1
		moveq	#0,d4
		move.w	$C(a0),d4
		addi.w	#$50,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		move.w	8(a0),d4
		addi.w	#$20,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		move.b	(a1),d4
		bne.s	loc_110AE
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_110AE:
		cmpi.b	#$11,d4
		bne.s	loc_110D0
		bsr.w	sub_10ACC
		bne.s	loc_110C2
		move.b	#1,(a2)
		move.l	a1,4(a2)

loc_110C2:
		move.w	#$B5,d0
		jsr	(PlaySFX).l
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_110D0:
		cmpi.b	#$12,d4
		bne.s	loc_110DA
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

loc_110DA:
		moveq	#-1,d4
		rts
; ---------------------------------------------------------------------------

sub_110DE:
		move.b	$30(a0),d0
		bne.s	loc_110FE
		subq.b	#1,$36(a0)
		bpl.s	loc_110F0
		move.b	#0,$36(a0)

loc_110F0:
		subq.b	#1,$37(a0)
		bpl.s	locret_110FC
		move.b	#0,$37(a0)

locret_110FC:
		rts
; ---------------------------------------------------------------------------

loc_110FE:
		cmpi.b	#$12,d0
		bne.s	loc_11176
		move.l	$32(a0),d1
		subi.l	#$FF0001,d1
		move.w	d1,d2
		andi.w	#$7F,d1
		mulu.w	#$18,d1
		subi.w	#$14,d1
		lsr.w	#7,d2
		andi.w	#$7F,d2
		mulu.w	#$18,d2
		subi.w	#$44,d2
		sub.w	obX(a0),d1
		sub.w	obY(a0),d2
		jsr	(GetAngle).l
		jsr	(GetSine).l
		muls.w	#$FB00,d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	#$FB00,d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)
		bset	#1,obStatus(a0)
		bsr.w	sub_10ACC
		bne.s	loc_1116C
		move.b	#2,(a2)
		move.l	$32(a0),d0
		subq.l	#1,d0
		move.l	d0,obMap(a2)

loc_1116C:
		move.w	#$B4,d0
		jmp	(PlaySFX).l
; ---------------------------------------------------------------------------

loc_11176:
		cmpi.b	#$14,d0
		bne.s	loc_11182
		addq.b	#2,obRoutine(a0)
		rts
; ---------------------------------------------------------------------------

loc_11182:
		cmpi.b	#$15,d0
		bne.s	loc_111A8
		tst.b	$36(a0)
		bne.s	locret_111C0
		move.b	#$1E,$36(a0)
		btst	#6,(unk_FFF783).w
		beq.s	loc_111A2
		asl	(unk_FFF782).w
		rts
; ---------------------------------------------------------------------------

loc_111A2:
		asr	(unk_FFF782).w
		rts
; ---------------------------------------------------------------------------

loc_111A8:
		cmpi.b	#$16,d0
		bne.s	locret_111C0
		tst.b	$37(a0)
		bne.s	locret_111C0
		move.b	#$1E,$37(a0)
		neg.w	(unk_FFF782).w
		rts
; ---------------------------------------------------------------------------

locret_111C0:
		rts
; ---------------------------------------------------------------------------

ObjAniTest:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_111D0(pc,d0.w),d1
		jmp	off_111D0(pc,d1.w)
; ---------------------------------------------------------------------------

off_111D0:	dc.w loc_111D8-off_111D0, loc_11202-off_111D0, loc_11286-off_111D0, loc_11286-off_111D0
; ---------------------------------------------------------------------------

loc_111D8:
		addq.b	#2,obRoutine(a0)
		move.b	#$12,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.l	#MapSonic,obMap(a0)
		move.w	#$780,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#2,obActWid(a0)

loc_11202:
		bsr.w	sub_11210
		bsr.w	ObjSonic_DynTiles
		jmp	ObjectDisplay
; ---------------------------------------------------------------------------

sub_11210:
		move.b	(padHeldPlayer).w,d4
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#1,d1
		btst	#0,d4
		beq.s	loc_11226
		sub.w	d1,d2

loc_11226:
		btst	#1,d4
		beq.s	loc_1122E
		add.w	d1,d2

loc_1122E:
		btst	#2,d4
		beq.s	loc_11236
		sub.w	d1,d3

loc_11236:
		btst	#3,d4
		beq.s	loc_1123E
		add.w	d1,d3

loc_1123E:
		move.w	d2,obY(a0)
		move.w	d3,obX(a0)
		btst	#4,(padPressPlayer).w
		beq.s	loc_11264
		move.b	obRender(a0),d0
		move.b	d0,d1
		addq.b	#1,d0
		andi.b	#3,d0
		andi.b	#$FC,d1
		or.b	d1,d0
		move.b	d0,obRender(a0)

loc_11264:
		btst	#5,(padPressPlayer).w
		beq.s	loc_1127E
		addq.b	#1,obAnim(a0)
		cmpi.b	#$19,obAnim(a0)
		bcs.s	loc_1127E
		move.b	#0,obAnim(a0)

loc_1127E:
		jsr	ObjSonic_Animate
		rts
; ---------------------------------------------------------------------------

loc_11286:
		jmp	ObjectDelete
; ---------------------------------------------------------------------------

sub_1128C:
		tst.w	(PauseFlag).w
		bmi.s	locret_112A8
		lea	($C00000).l,a6
		moveq	#0,d0
		move.b	(level).w,d0
		add.w	d0,d0
		move.w	off_112AA(pc,d0.w),d0
		jmp	off_112AA(pc,d0.w)
; ---------------------------------------------------------------------------

locret_112A8:
		rts
; ---------------------------------------------------------------------------

off_112AA:	dc.w loc_112B8-off_112AA, locret_11482-off_112AA, loc_11376-off_112AA, locret_11482-off_112AA
		dc.w locret_11482-off_112AA, locret_11482-off_112AA, locret_11482-off_112AA
; ---------------------------------------------------------------------------

loc_112B8:
		subq.b	#1,(unk_FFF7B1).w
		bpl.s	loc_112EE
		move.b	#5,(unk_FFF7B1).w
		lea	(byte_6B018).l,a1
		move.b	(unk_FFF7B0).w,d0
		addq.b	#1,(unk_FFF7B0).w
		andi.w	#1,d0
		beq.s	loc_112DC
		lea	$100(a1),a1

loc_112DC:
		move.l	#$6F000001,($C00004).l
		move.w	#7,d1
		bra.w	sub_11484
; ---------------------------------------------------------------------------

loc_112EE:
		subq.b	#1,(unk_FFF7B3).w
		bpl.s	loc_11324
		move.b	#$F,(unk_FFF7B3).w
		lea	(byte_6B218).l,a1
		move.b	(unk_FFF7B2).w,d0
		addq.b	#1,(unk_FFF7B2).w
		andi.w	#1,d0
		beq.s	loc_11312
		lea	$200(a1),a1

loc_11312:
		move.l	#$6B800001,($C00004).l
		move.w	#$F,d1
		bra.w	sub_11484
; ---------------------------------------------------------------------------

loc_11324:
		subq.b	#1,(unk_FFF7B5).w
		bpl.s	locret_11370
		move.b	#7,(unk_FFF7B5).w
		move.b	(unk_FFF7B4).w,d0
		addq.b	#1,(unk_FFF7B4).w
		andi.w	#3,d0
		move.b	byte_11372(pc,d0.w),d0
		btst	#0,d0
		bne.s	loc_1134C
		move.b	#$7F,(unk_FFF7B5).w

loc_1134C:
		lsl.w	#7,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.l	#$6D800001,($C00004).l
		lea	(byte_6B618).l,a1
		lea	(a1,d0.w),a1
		move.w	#$B,d1
		bsr.w	sub_11484

locret_11370:
		rts
; ---------------------------------------------------------------------------

byte_11372:	dc.b 0, 1, 2, 1
; ---------------------------------------------------------------------------

loc_11376:
		subq.b	#1,(unk_FFF7B1).w
		bpl.s	loc_113B4
		move.b	#$13,(unk_FFF7B1).w
		lea	(byte_6BA98).l,a1
		moveq	#0,d0
		move.b	(unk_FFF7B0).w,d0
		addq.b	#1,d0
		cmpi.b	#3,d0
		bne.s	loc_11398
		moveq	#0,d0

loc_11398:
		move.b	d0,(unk_FFF7B0).w
		mulu.w	#$100,d0
		adda.w	d0,a1
		move.l	#$5C400001,($C00004).l
		move.w	#7,d1
		bsr.w	sub_11484

loc_113B4:
		subq.b	#1,(unk_FFF7B3).w
		bpl.s	loc_11412
		move.b	#1,(unk_FFF7B3).w
		moveq	#0,d0
		move.b	(unk_FFF7B0).w,d0
		lea	(byte_6BD98).l,a4
		ror.w	#7,d0
		adda.w	d0,a4
		move.l	#$5A400001,($C00004).l
		moveq	#0,d3
		move.b	(unk_FFF7B2).w,d3
		addq.b	#1,(unk_FFF7B2).w
		move.b	(oscValues+$A).w,d3
		move.w	#3,d2

loc_113EC:
		move.w	d3,d0
		add.w	d0,d0
		andi.w	#$1E,d0
		lea	(off_1149A).l,a3
		move.w	(a3,d0.w),d0
		lea	(a3,d0.w),a3
		movea.l	a4,a1
		move.w	#$1F,d1
		jsr	(a3)
		addq.w	#4,d3
		dbf	d2,loc_113EC
		rts
; ---------------------------------------------------------------------------

loc_11412:
		subq.b	#1,(unk_FFF7B5).w
		bpl.w	locret_11480
		move.b	#7,(unk_FFF7B5).w
		lea	(byte_6C398).l,a1
		moveq	#0,d0
		move.b	(unk_FFF7B4).w,d0
		addq.b	#1,d0
		cmpi.b	#5,d0
		bne.s	loc_11436
		moveq	#0,d0

loc_11436:
		move.b	d0,(unk_FFF7B4).w
		mulu.w	#$100,d0
		adda.w	d0,a1
		move.l	#$5D400001,($C00004).l
		move.w	#7,d1
		bsr.w	sub_11484
		lea	(byte_6C998).l,a1
		moveq	#0,d0
		move.b	(unk_FFF7B6).w,d0
		addq.b	#1,(unk_FFF7B6).w
		andi.b	#3,(unk_FFF7B6).w
		mulu.w	#$C0,d0
		adda.w	d0,a1
		move.l	#$5E400001,($C00004).l
		move.w	#5,d1
		bra.w	sub_11484
; ---------------------------------------------------------------------------

locret_11480:
		rts
; ---------------------------------------------------------------------------

locret_11482:
		rts
; ---------------------------------------------------------------------------

sub_11484:
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		move.l	(a1)+,(a6)
		dbf	d1,sub_11484
		rts
; ---------------------------------------------------------------------------

off_1149A:	dc.w loc_114BA-off_1149A, loc_114C6-off_1149A, loc_114DC-off_1149A, loc_114EA-off_1149A
		dc.w loc_11500-off_1149A, loc_1150E-off_1149A, loc_11524-off_1149A, loc_11532-off_1149A
		dc.w loc_11548-off_1149A, loc_11556-off_1149A, loc_1156C-off_1149A, loc_1157A-off_1149A
		dc.w loc_11590-off_1149A, loc_1159E-off_1149A, loc_115B4-off_1149A, loc_115C6-off_1149A
; ---------------------------------------------------------------------------

loc_114BA:
		move.l	(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_114BA
		rts
; ---------------------------------------------------------------------------

loc_114C6:
		move.l	2(a1),d0
		move.b	1(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_114C6
		rts
; ---------------------------------------------------------------------------

loc_114DC:
		move.l	2(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_114DC
		rts
; ---------------------------------------------------------------------------

loc_114EA:
		move.l	4(a1),d0
		move.b	3(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_114EA
		rts
; ---------------------------------------------------------------------------

loc_11500:
		move.l	4(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11500
		rts
; ---------------------------------------------------------------------------

loc_1150E:
		move.l	6(a1),d0
		move.b	5(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_1150E
		rts
; ---------------------------------------------------------------------------

loc_11524:
		move.l	6(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11524
		rts
; ---------------------------------------------------------------------------

loc_11532:
		move.l	8(a1),d0
		move.b	7(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11532
		rts
; ---------------------------------------------------------------------------

loc_11548:
		move.l	8(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11548
		rts
; ---------------------------------------------------------------------------

loc_11556:
		move.l	$A(a1),d0
		move.b	9(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11556
		rts
; ---------------------------------------------------------------------------

loc_1156C:
		move.l	$A(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_1156C
		rts
; ---------------------------------------------------------------------------

loc_1157A:
		move.l	$C(a1),d0
		move.b	$B(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_1157A
		rts
; ---------------------------------------------------------------------------

loc_11590:
		move.l	$C(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_11590
		rts
; ---------------------------------------------------------------------------

loc_1159E:
		move.l	$C(a1),d0
		rol.l	#8,d0
		move.b	0(a1),d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_1159E
		rts
; ---------------------------------------------------------------------------

loc_115B4:
		move.w	$E(a1),(a6)
		move.w	0(a1),(a6)
		lea	$10(a1),a1
		dbf	d1,loc_115B4
		rts
; ---------------------------------------------------------------------------

loc_115C6:
		move.l	0(a1),d0
		move.b	$F(a1),d0
		ror.l	#8,d0
		move.l	d0,(a6)
		lea	$10(a1),a1
		dbf	d1,loc_115C6
		rts
; ---------------------------------------------------------------------------

ObjHUD:
		moveq	#0,d0
		move.b	obStatus(a0),d0
		move.w	off_115EA(pc,d0.w),d1
		jmp	off_115EA(pc,d1.w)
; ---------------------------------------------------------------------------

off_115EA:	dc.w loc_115EE-off_115EA, loc_11618-off_115EA
; ---------------------------------------------------------------------------

loc_115EE:
		addq.b	#2,obRoutine(a0)
		move.w	#$90,obX(a0)
		move.w	#$108,obScreenY(a0)
		move.l	#MapHUD,obMap(a0)
		move.w	#$6CA,obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#0,obActWid(a0)

loc_11618:
		jmp	ObjectDisplay
; ---------------------------------------------------------------------------
		include "levels/shared/HUD/Sprite.map"
		even
; ---------------------------------------------------------------------------

ScoreAdd:
		move.b	#1,(byte_FFFE1F).w
		lea	(unk_FFFE50).w,a2
		lea	(dword_FFFE26).w,a3
		add.l	d0,(a3)
		move.l	#999999,d1
		cmp.l	(a3),d1
		bhi.w	loc_1166E
		move.l	d1,(a3)
		move.l	d1,(a2)

loc_1166E:
		move.l	(a3),d0
		cmp.l	(a2),d0
		bcs.w	locret_11678
		move.l	d0,(a2)

locret_11678:
		rts
; ---------------------------------------------------------------------------

UpdateHUD:
		tst.w	(word_FFFFFA).w
		bne.w	loc_11746
		tst.b	(byte_FFFE1F).w
		beq.s	loc_1169A
		clr.b	(byte_FFFE1F).w
		move.l	#$5C800003,d0
		move.l	(dword_FFFE26).w,d1
		bsr.w	sub_1187E

loc_1169A:
		tst.b	(ExtraLifeFlags).w
		beq.s	loc_116BA
		bpl.s	loc_116A6
		bsr.w	sub_117B2

loc_116A6:
		clr.b	(ExtraLifeFlags).w
		move.l	#$5F400003,d0
		moveq	#0,d1
		move.w	(Rings).w,d1
		bsr.w	sub_11874

loc_116BA:
		tst.b	(byte_FFFE1E).w
		beq.s	loc_1170E
		tst.w	(PauseFlag).w
		bmi.s	loc_1170E
		lea	(dword_FFFE26).w,a1
		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		bcs.s	loc_1170E
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		bcs.s	loc_116EE
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#9,(a1)
		bcs.s	loc_116EE
		move.b	#9,(a1)

loc_116EE:
		move.l	#$5E400003,d0
		moveq	#0,d1
		move.b	(dword_FFFE22+1).w,d1
		bsr.w	sub_118F4
		move.l	#$5EC00003,d0
		moveq	#0,d1
		move.b	(dword_FFFE22+2).w,d1
		bsr.w	sub_118FE

loc_1170E:
		tst.b	(byte_FFFE1C).w
		beq.s	loc_1171C
		clr.b	(byte_FFFE1C).w
		bsr.w	sub_119BA

loc_1171C:
		tst.b	(byte_FFFE58).w
		beq.s	locret_11744
		clr.b	(byte_FFFE58).w
		move.l	#$6E000002,($C00004).l
		moveq	#0,d1
		move.w	(word_FFFE54).w,d1
		bsr.w	sub_11958
		moveq	#0,d1
		move.w	(word_FFFE56).w,d1
		bsr.w	sub_11958

locret_11744:
		rts
; ---------------------------------------------------------------------------

loc_11746:
		bsr.w	sub_1181E
		tst.b	(ExtraLifeFlags).w
		beq.s	loc_1176A
		bpl.s	loc_11756
		bsr.w	sub_117B2

loc_11756:
		clr.b	(ExtraLifeFlags).w
		move.l	#$5F400003,d0
		moveq	#0,d1
		move.w	(Rings).w,d1
		bsr.w	sub_11874

loc_1176A:
		move.l	#$5EC00003,d0
		moveq	#0,d1
		move.b	(byte_FFF62C).w,d1
		bsr.w	sub_118FE
		tst.b	(byte_FFFE1C).w
		beq.s	loc_11788
		clr.b	(byte_FFFE1C).w
		bsr.w	sub_119BA

loc_11788:
		tst.b	(byte_FFFE58).w
		beq.s	locret_117B0
		clr.b	(byte_FFFE58).w
		move.l	#$6E000002,($C00004).l
		moveq	#0,d1
		move.w	(word_FFFE54).w,d1
		bsr.w	sub_11958
		moveq	#0,d1
		move.w	(word_FFFE56).w,d1
		bsr.w	sub_11958

locret_117B0:
		rts
; ---------------------------------------------------------------------------

sub_117B2:
		move.l	#$5F400003,($C00004).l
		lea	byte_1181A(pc),a2
		move.w	#2,d2
		bra.s	loc_117E2
; ---------------------------------------------------------------------------

sub_117C6:
		lea	($C00000).l,a6
		bsr.w	sub_119BA
		move.l	#$5C400003,($C00004).l
		lea	byte_1180E(pc),a2
		move.w	#$E,d2

loc_117E2:
		lea	byte_11A26(pc),a1

loc_117E6:
		move.w	#$F,d1
		move.b	(a2)+,d0
		bmi.s	loc_11802
		ext.w	d0
		lsl.w	#5,d0
		lea	(a1,d0.w),a3

loc_117F6:
		move.l	(a3)+,(a6)
		dbf	d1,loc_117F6

loc_117FC:
		dbf	d2,loc_117E6
		rts
; ---------------------------------------------------------------------------

loc_11802:
		move.l	#0,(a6)
		dbf	d1,loc_11802
		bra.s	loc_117FC
; ---------------------------------------------------------------------------

byte_1180E:	dc.b $16, $FF, $FF, $FF, $FF, $FF, $FF, 0, 0, $14, 0, 0

byte_1181A:	dc.b $FF, $FF, 0, 0
; ---------------------------------------------------------------------------

sub_1181E:
		move.l	#$5C400003,($C00004).l
		move.w	(CameraX).w,d1
		swap	d1
		move.w	(ObjectsList+8).w,d1
		bsr.s	sub_1183E
		move.w	(CameraY).w,d1
		swap	d1
		move.w	(ObjectsList+$C).w,d1
; ---------------------------------------------------------------------------

sub_1183E:
		moveq	#7,d6
		lea	(ArtText).l,a1

loc_11846:
		rol.w	#4,d1
		move.w	d1,d2
		andi.w	#$F,d2
		cmpi.w	#$A,d2
		bcs.s	loc_11856
		addq.w	#7,d2

loc_11856:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		swap	d1
		dbf	d6,loc_11846
		rts
; ---------------------------------------------------------------------------

sub_11874:
		lea	(dword_118E8).l,a2
		moveq	#2,d6
		bra.s	loc_11886
; ---------------------------------------------------------------------------

sub_1187E:
		lea	(dword_118DC).l,a2
		moveq	#5,d6

loc_11886:
		moveq	#0,d4
		lea	byte_11A26(pc),a1

loc_1188C:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_11890:
		sub.l	d3,d1
		bcs.s	loc_11898
		addq.w	#1,d2
		bra.s	loc_11890
; ---------------------------------------------------------------------------

loc_11898:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_118A2
		move.w	#1,d4

loc_118A2:
		tst.w	d4
		beq.s	loc_118D0
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_118D0:
		addi.l	#$400000,d0
		dbf	d6,loc_1188C
		rts
; ---------------------------------------------------------------------------

dword_118DC:	dc.l 100000
		dc.l 10000
dword_118E4:	dc.l 1000
dword_118E8:	dc.l 100
dword_118EC:	dc.l 10
dword_118F0:	dc.l 1
; ---------------------------------------------------------------------------

sub_118F4:
		lea	(dword_118F0).l,a2
		moveq	#0,d6
		bra.s	loc_11906
; ---------------------------------------------------------------------------

sub_118FE:
		lea	(dword_118EC).l,a2
		moveq	#1,d6

loc_11906:
		moveq	#0,d4
		lea	byte_11A26(pc),a1

loc_1190C:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_11910:
		sub.l	d3,d1
		bcs.s	loc_11918
		addq.w	#1,d2
		bra.s	loc_11910
; ---------------------------------------------------------------------------

loc_11918:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_11922
		move.w	#1,d4

loc_11922:
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		addi.l	#$400000,d0
		dbf	d6,loc_1190C
		rts
; ---------------------------------------------------------------------------

sub_11958:
		lea	(dword_118E4).l,a2
		moveq	#3,d6
		moveq	#0,d4
		lea	byte_11A26(pc),a1

loc_11966:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1196A:
		sub.l	d3,d1
		bcs.s	loc_11972
		addq.w	#1,d2
		bra.s	loc_1196A
; ---------------------------------------------------------------------------

loc_11972:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1197C
		move.w	#1,d4

loc_1197C:
		tst.w	d4
		beq.s	loc_119AC
		lsl.w	#6,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_119A6:
		dbf	d6,loc_11966
		rts
; ---------------------------------------------------------------------------

loc_119AC:
		moveq	#$F,d5

loc_119AE:
		move.l	#0,(a6)
		dbf	d5,loc_119AE
		bra.s	loc_119A6
; ---------------------------------------------------------------------------

sub_119BA:
		move.l	#$7BA00003,d0
		moveq	#0,d1
		move.b	(Lives).w,d1
		lea	(dword_118EC).l,a2
		moveq	#1,d6
		moveq	#0,d4
		lea	byte_11D26(pc),a1

loc_119D4:
		move.l	d0,4(a6)
		moveq	#0,d2
		move.l	(a2)+,d3

loc_119DC:
		sub.l	d3,d1
		bcs.s	loc_119E4
		addq.w	#1,d2
		bra.s	loc_119DC
; ---------------------------------------------------------------------------

loc_119E4:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_119EE
		move.w	#1,d4

loc_119EE:
		tst.w	d4
		beq.s	loc_11A14

loc_119F2:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_11A08:
		addi.l	#$400000,d0
		dbf	d6,loc_119D4
		rts
; ---------------------------------------------------------------------------

loc_11A14:
		tst.w	d6
		beq.s	loc_119F2
		moveq	#7,d5

loc_11A1A:
		move.l	#0,(a6)
		dbf	d5,loc_11A1A
		bra.s	loc_11A08
; ---------------------------------------------------------------------------

byte_11A26:	dc.b 0, 0, 0, 0, 0, $66, $66, $10, 6, $66, $66, $61, 6
		dc.b $61, $16, $61, 6, $61, 6, $61, 6, $61, 6, $61, 6
		dc.b $61, 6, $61, 6, $61, 6, $61, 6, $61, 6, $61, 6, $66
		dc.b $66, $61, 0, $66, $66, $10, 0, $11, $11, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 6, $61, 0, 0, $66, $61, 0, 0, 6, $61, 0, 0
		dc.b 6, $61, 0, 0, 6, $61, 0, 0, 6, $61, 0, 0, 6, $61
		dc.b 0, 0, 6, $61, 0, 0, 6, $61, 0, 0, 6, $61, 0, 0, 1
		dc.b $11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, $66, $66, $10, 6, $66, $66, $61
		dc.b 6, $61, $16, $61, 1, $11, $66, $61, 0, 6, $66, $10
		dc.b 0, $66, $61, 0, 0, $66, $10, 0, 6, $66, $10, 0, 6
		dc.b $66, $66, $61, 6, $66, $66, $61, 1, $11, $11, $11
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, $66, $66, $10, 6, $66, $66, $61, 6, $61
		dc.b $16, $61, 1, $11, 6, $61, 0, 6, $66, $10, 0, 6, $66
		dc.b $10, 0, 1, $16, $61, 6, $61, 6, $61, 6, $66, $66
		dc.b $61, 0, $66, $66, $10, 0, $11, $11, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, $66, $10, 0, 6, $66, $10, 0, 6, $66, $10, 0, $66
		dc.b $66, $10, 0, $61, $66, $10, 6, $61, $66, $10, 6, $66
		dc.b $66, $61, 6, $66, $66, $61, 1, $11, $66, $11, 0, 0
		dc.b $66, $10, 0, 0, $11, $10, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, $66, $66, $61
		dc.b 6, $66, $66, $61, 6, $61, $11, $11, 6, $61, 0, 0
		dc.b 6, $66, $66, $10, 6, $66, $66, $61, 1, $11, $16, $61
		dc.b 6, $61, 6, $61, 6, $66, $66, $61, 1, $66, $66, $10
		dc.b 0, $11, $11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, $66, $66, $10, 6, $66
		dc.b $66, $61, 6, $61, $16, $61, 6, $61, 1, $11, 6, $66
		dc.b $66, $10, 6, $66, $66, $61, 6, $61, $16, $61, 6, $61
		dc.b 6, $61, 6, $66, $66, $61, 0, $66, $66, $10, 0, $11
		dc.b $11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 6, $66, $66, $61, 6, $66, $66, $61
		dc.b 1, $11, $16, $61, 0, 0, $66, $10, 0, 0, $66, $10
		dc.b 0, 0, $66, $10, 0, 6, $61, 0, 0, 6, $61, 0, 0, 6
		dc.b $61, 0, 0, 6, $61, 0, 0, 1, $11, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $66
		dc.b $66, $10, 6, $66, $66, $61, 6, $61, $16, $61, 6, $61
		dc.b 6, $61, 0, $66, $66, $10, 0, $66, $66, $10, 6, $61
		dc.b $16, $61, 6, $61, 6, $61, 6, $66, $66, $61, 0, $66
		dc.b $66, $10, 0, $11, $11, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $66, $66, $10
		dc.b 6, $66, $66, $61, 6, $61, $16, $61, 6, $61, 6, $61
		dc.b 6, $66, $66, $61, 0, $66, $66, $61, 0, $11, $16, $61
		dc.b 6, $61, 6, $61, 6, $66, $66, $61, 0, $66, $66, $10
		dc.b 0, $11, $11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 6, $61, 0, 0, 6, $61, 0, 0, 1, $11, 0, 0, 0, 0, 0
		dc.b 0, 6, $61, 0, 0, 6, $61, 0, 0, 1, $11, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0, 0, 0, 0, 0, $F, $FF, $FF, $F1, $F, $FF
		dc.b $FF, $F1, $F, $F1, $11, $11, $F, $F1, 0, 0, $F, $FF
		dc.b $FF, $10, $F, $FF, $FF, $10, $F, $F1, $11, $10, $F
		dc.b $F1, 0, 0, $F, $FF, $FF, $F1, $F, $FF, $FF, $F1, 1
		dc.b $11, $11, $11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		dc.b 0, 0, 0, 0

byte_11D26:	dc.b 0, 0, 0, 0, 0, $66, $66, $10, 6, $61, $16, $61, 6
		dc.b $61, 6, $61, 6, $61, 6, $61, 6, $61, 6, $61, 0, $66
		dc.b $66, $10, 0, $11, $11, 0, 0, 0, 0, 0, 0, 6, $61, 0
		dc.b 0, $66, $61, 0, 0, $16, $61, 0, 0, 6, $61, 0, 0, 6
		dc.b $61, 0, 0, 6, $61, 0, 0, 1, $11, 0, 0, 0, 0, 0, 0
		dc.b $66, $66, $10, 0, $11, $16, $61, 0, 0, $66, $11, 0
		dc.b 6, $61, $10, 0, $66, $11, $10, 6, $66, $66, $61, 1
		dc.b $11, $11, $11, 0, 0, 0, 0, 0, $66, $66, $10, 0, $11
		dc.b $16, $61, 0, 6, $66, $10, 0, 1, $16, $61, 6, $61
		dc.b 6, $61, 0, $66, $66, $10, 0, $11, $11, 0, 0, 0, 0
		dc.b 0, 0, 0, $66, $10, 0, 6, $66, $10, 0, $61, $66, $10
		dc.b 6, $61, $66, $10, 6, $66, $66, $61, 1, $11, $66, $11
		dc.b 0, 0, $11, $10, 0, 0, 0, 0, 6, $66, $66, $61, 6, $61
		dc.b $11, $11, 6, $66, $66, $10, 1, $11, $16, $61, 6, $61
		dc.b 6, $61, 0, $66, $66, $10, 0, $11, $11, 0, 0, 0, 0
		dc.b 0, 0, $66, $66, $10, 6, $61, $11, $10, 6, $66, $66
		dc.b $10, 6, $61, $16, $61, 6, $61, 6, $61, 0, $66, $66
		dc.b $10, 0, $11, $11, 0, 0, 0, 0, 0, 6, $66, $66, $61
		dc.b 1, $11, $16, $61, 0, 0, $66, $10, 0, 6, $61, 0, 0
		dc.b $66, $10, 0, 0, $66, $10, 0, 0, $11, $10, 0, 0, 0
		dc.b 0, 0, 0, $66, $66, $10, 6, $61, $16, $61, 0, $66
		dc.b $66, $10, 6, $61, $16, $61, 6, $61, 6, $61, 0, $66
		dc.b $66, $10, 0, $11, $11, 0, 0, 0, 0, 0, 0, $66, $66
		dc.b $10, 6, $61, $16, $61, 6, $61, 6, $61, 0, $66, $66
		dc.b $61, 0, $11, $16, $61, 0, $66, $66, $10, 0, $11, $11
		dc.b 0
; ---------------------------------------------------------------------------

DebugMode:
		moveq	#0,d0
		move.b	(DebugRoutine).w,d0
		move.w	off_11E74(pc,d0.w),d1
		jmp	off_11E74(pc,d1.w)
; ---------------------------------------------------------------------------

off_11E74:	dc.w loc_11E78-off_11E74, loc_11EB8-off_11E74
; ---------------------------------------------------------------------------

loc_11E78:
		addq.b	#2,(DebugRoutine).w
		move.b	#0,$1A(a0)
		move.b	#0,$1C(a0)
		moveq	#0,d0
		move.b	(level).w,d0
		lea	(DebugLists).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		cmp.b	(byte_FFFE06).w,d6
		bhi.s	loc_11EA8
		move.b	#0,(byte_FFFE06).w

loc_11EA8:
		bsr.w	sub_11FCE
		move.b	#$C,(byte_FFFE0A).w
		move.b	#1,(byte_FFFE0B).w

loc_11EB8:
		moveq	#0,d0
		move.b	(level).w,d0
		lea	(DebugLists).l,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		bsr.w	sub_11ED6
		jmp	ObjectDisplay
; ---------------------------------------------------------------------------

sub_11ED6:
		moveq	#0,d4
		move.w	#1,d1
		move.b	(padPress1).w,d4
		bne.s	loc_11F0E
		tst.b	(padHeld1).w
		bne.s	loc_11EF6
		move.b	#$C,(byte_FFFE0A).w
		move.b	#$F,(byte_FFFE0B).w
		rts
; ---------------------------------------------------------------------------

loc_11EF6:
		subq.b	#1,(byte_FFFE0A).w
		bne.s	loc_11F12
		move.b	#1,(byte_FFFE0A).w
		addq.b	#1,(byte_FFFE0B).w
		bne.s	loc_11F0E
		move.b	#$FF,(byte_FFFE0B).w

loc_11F0E:
		move.b	(padHeld1).w,d4

loc_11F12:
		moveq	#0,d1
		move.b	(byte_FFFE0B).w,d1
		addq.w	#1,d1
		swap	d1
		asr.l	#4,d1
		move.l	$C(a0),d2
		move.l	8(a0),d3
		btst	#0,d4
		beq.s	loc_11F32
		sub.l	d1,d2
		bcc.s	loc_11F32
		moveq	#0,d2

loc_11F32:
		btst	#1,d4
		beq.s	loc_11F48
		add.l	d1,d2
		cmpi.l	#$7FF0000,d2
		bcs.s	loc_11F48
		move.l	#$7FF0000,d2

loc_11F48:
		btst	#2,d4
		beq.s	loc_11F54
		sub.l	d1,d3
		bcc.s	loc_11F54
		moveq	#0,d3

loc_11F54:
		btst	#3,d4
		beq.s	loc_11F5C
		add.l	d1,d3

loc_11F5C:
		move.l	d2,$C(a0)
		move.l	d3,8(a0)
		btst	#6,(padPressPlayer).w
		beq.s	loc_11F80
		addq.b	#1,(byte_FFFE06).w
		cmp.b	(byte_FFFE06).w,d6
		bhi.s	loc_11F7C
		move.b	#0,(byte_FFFE06).w

loc_11F7C:
		bra.w	sub_11FCE
; ---------------------------------------------------------------------------

loc_11F80:
		btst	#5,(padPressPlayer).w
		beq.s	loc_11FA4
		jsr	ObjectLoad
		bne.s	loc_11FA4
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obMap(a0),obID(a1)
		rts
; ---------------------------------------------------------------------------

loc_11FA4:
		btst	#4,(padPressPlayer).w
		beq.s	locret_11FCC
		moveq	#0,d0
		move.w	d0,(DebugRoutine).w
		move.l	#MapSonic,(ObjectsList+obMap).w
		move.w	#$780,(ObjectsList+obGfx).w
		move.b	d0,(ObjectsList+obAnim).w
		move.w	d0,$A(a0)
		move.w	d0,$E(a0)

locret_11FCC:
		rts
; ---------------------------------------------------------------------------

sub_11FCE:
		moveq	#0,d0
		move.b	(byte_FFFE06).w,d0
		lsl.w	#3,d0
		move.l	(a2,d0.w),obMap(a0)
		move.w	obMap+2(a2,d0.w),obGfx(a0)
		move.b	obMap+1(a2,d0.w),obFrame(a0)
		rts
; ---------------------------------------------------------------------------

DebugLists:	dc.w word_11FF6-DebugLists, word_12060-DebugLists, word_1207A-DebugLists, word_12104-DebugLists
		dc.w word_1216E-DebugLists, word_121D8-DebugLists

word_11FF6:	dc.w $D
		dc.l ($25<<24)|MapRing
		dc.b 0, 0, $27, $B2
		dc.l ($26<<24)|MapMonitor
		dc.b 0, 0, 6, $80
		dc.l ($1F<<24)|MapCrabmeat
		dc.b 0, 0, 4, 0
		dc.l ($22<<24)|MapBuzzbomber
		dc.b 0, 0, 4, $44
		dc.l ($2B<<24)|MapChopper
		dc.b 0, 0, 4, $7B
		dc.l ($36<<24)|MapSpikes
		dc.b 0, 0, 5, $1B
		dc.l ($18<<24)|MapPlatform1
		dc.b 0, 0, $40, 0
		dc.l ($3B<<24)|MapPurpleRock
		dc.b 0, 0, $63, $D0
		dc.l ($40<<24)|MapMotobug
		dc.b 0, 0, 4, $F0
		dc.l ($41<<24)|MapSpring
		dc.b 0, 0, 5, $23
		dc.l ($42<<24)|MapNewtron
		dc.b 0, 0, $24, $9B
		dc.l ($44<<24)|MapWall
		dc.b 0, 0, $43, $4C
		dc.l ($19<<24)|MapRollingBall
		dc.b 0, 0, $43, $AA

word_12060:	dc.w 3
		dc.l ($25<<24)|MapRing
		dc.b 0, 0, $27, $B2
		dc.l ($26<<24)|MapMonitor
		dc.b 0, 0, 6, $80
		dc.l ($1F<<24)|MapCrabmeat
		dc.b 0, 0, 4, 0

word_1207A:	dc.w $11
		dc.l ($25<<24)|MapRing
		dc.b 0, 0, $27, $B2
		dc.l ($26<<24)|MapMonitor
		dc.b 0, 0, 6, $80
		dc.l ($22<<24)|MapBuzzbomber
		dc.b 0, 0, 4, $44
		dc.l ($36<<24)|MapSpikes
		dc.b 0, 0, 5, $1B
		dc.l ($41<<24)|MapSpring
		dc.b 0, 0, 5, $23
		dc.l ($13<<24)|MapLavaball
		dc.b 0, 0, 3, $45
		dc.l ($46<<24)|MapMZBlocks
		dc.b 0, 0, $40, 0
		dc.l ($4C<<24)|MapLavafall
		dc.b 0, 0, $63, $A8
		dc.l ($4E<<24)|MapLavaChase
		dc.b 0, 0, $63, $A8
		dc.l ($33<<24)|MapPushBlock
		dc.b 0, 0, $42, $B8
		dc.l ($4F<<24)|Map4F
		dc.b 0, 0, 4, $E4
		dc.l ($50<<24)|MapYardin
		dc.b 0, 0, 4, $7B
		dc.l ($51<<24)|MapSmashBlock
		dc.b 0, 0, $42, $B8
		dc.l ($52<<24)|MapMovingPtfm
		dc.b 0, 0, 2, $B8
		dc.l ($53<<24)|MapCollapseFloor
		dc.b 0, 0, $62, $B8
		dc.l ($54<<24)|MapLavaHurt
		dc.b 0, 0, $86, $80
		dc.l ($55<<24)|MapBasaran
		dc.b 0, 0, $24, $B8

word_12104:	dc.w $D
		dc.l ($25<<24)|MapRing
		dc.b 0, 0, $27, $B2
		dc.l ($26<<24)|MapMonitor
		dc.b 0, 0, 6, $80
		dc.l ($59<<24)|MapSLZMovingPtfm
		dc.b 0, 0, $44, $80
		dc.l ($53<<24)|MapCollapseFloor
		dc.b 0, 2, $44, $E0
		dc.l ($18<<24)|MapPlatform3
		dc.b 0, 0, $44, $80
		dc.l ($5A<<24)|MapCirclePtfm
		dc.b 0, 0, $44, $80
		dc.l ($5B<<24)|MapStaircasePtfm
		dc.b 0, 0, $44, $80
		dc.l ($5D<<24)|MapFan
		dc.b 0, 0, $43, $A0
		dc.l ($5E<<24)|MapSeesaw
		dc.b 0, 0, 3, $74
		dc.l ($41<<24)|MapSpring
		dc.b 0, 0, 5, $23
		dc.l ($13<<24)|MapLavaball
		dc.b 0, 0, 3, $45
		dc.l ($1F<<24)|MapCrabmeat
		dc.b 0, 0, 4, 0
		dc.l ($22<<24)|MapBuzzbomber
		dc.b 0, 0, 4, $44

word_1216E:	dc.w $D
		dc.l ($25<<24)|MapRing
		dc.b 0, 0, $27, $B2
		dc.l ($26<<24)|MapMonitor
		dc.b 0, 0, 6, $80
		dc.l ($36<<24)|MapSpikes
		dc.b 0, 0, 5, $1B
		dc.l ($41<<24)|MapSpring
		dc.b 0, 0, 5, $23
		dc.l ($43<<24)|MapRoller
		dc.b 0, 0, $24, $B8
		dc.l ($12<<24)|MapSceneryLamp
		dc.b 0, 0, 0, 0
		dc.l ($47<<24)|MapBumper
		dc.b 0, 0, 3, $80
		dc.l ($1F<<24)|MapCrabmeat
		dc.b 0, 0, 4, 0
		dc.l ($22<<24)|MapBuzzbomber
		dc.b 0, 0, 4, $44
		dc.l ($50<<24)|MapYardin
		dc.b 0, 0, 4, $7B
		dc.l ($18<<24)|MapPlatform2
		dc.b 0, 0, $40, 0
		dc.l ($56<<24)|MapMovingBlocks
		dc.b 0, 0, $40, 0
		dc.l ($32<<24)|MapSwitch
		dc.b 0, 0, 5, $13

word_121D8:	dc.w 3
		dc.l ($25<<24)|MapRing
		dc.b 0, 0, $27, $B2
		dc.l ($26<<24)|MapMonitor
		dc.b 0, 0, 6, $80
		dc.l ($1F<<24)|MapCrabmeat
		dc.b 0, 0, 4, 0
		dc.l ($1E<<24)|MapBallhog
		dc.b 0, 0, $24, 0
		dc.l ($2C<<24)|MapJaws
		dc.b 0, 0, 4, $7B
		dc.l ($2D<<24)|MapBurrobot
		dc.b 0, 0, $24, $7B

LevelDataArray:	dc.l ($4<<24)|TilesGHZ_2, ($5<<24)|BlocksGHZ, ChunksGHZ
		dc.b 0, $81, 4, 4
		dc.l ($6<<24)|TilesLZ, ($7<<24)|BlocksLZ, ChunksLZ
		dc.b 0, $82, 5, 5
		dc.l ($8<<24)|TilesMZ, ($9<<24)|BlocksMZ, ChunksMZ
		dc.b 0, $83, 6, 6
		dc.l ($A<<24)|TilesSLZ, ($B<<24)|BlocksSLZ, ChunksSLZ
		dc.b 0, $84, 7, 7
		dc.l ($C<<24)|TilesSYZ, ($D<<24)|BlocksSYZ, ChunksSYZ
		dc.b 0, $85, 8, 8
		dc.l ($E<<24)|TilesSBZ, ($F<<24)|BlocksSBZ, ChunksSBZ
		dc.b 0, $86, 9, 9

plcArray:	dc.w word_122A0-plcArray, word_122C0-plcArray, word_122D4-plcArray, plcGameOver-plcArray
		dc.w plcGHZ1-plcArray, plzGHZ2-plcArray, plcLZ1-plcArray, plcLZ2-plcArray, plcMZ1-plcArray
		dc.w plcMZ2-plcArray, plzSLZ1-plcArray, plcSLZ2-plcArray, plzSYZ1-plcArray, plcSYZ2-plcArray
		dc.w plcSBZ1-plcArray, plcSBZ2-plcArray, plcTitleCards-plcArray, word_12484-plcArray
		dc.w plcSignPosts-plcArray, plcFlash-plcArray, word_124A8-plcArray, word_1251C-plcArray
		dc.w word_1252A-plcArray, word_12538-plcArray, word_12546-plcArray, word_12554-plcArray
		dc.w word_12562-plcArray

word_122A0:	dc.w 4
		dc.l ArtSmoke
		dc.w $F400
		dc.l ArtHUD
		dc.w $D940
		dc.l ArtLives
		dc.w $FA80
		dc.l ArtRings
		dc.w $F640
		dc.l byte_2E6C8
		dc.w $F2E0

word_122C0:	dc.w 2
		dc.l ArtMonitors
		dc.w $D000
		dc.l ArtShield
		dc.w $A820
		dc.l ArtInvinStars
		dc.w $AB80

word_122D4:	dc.w 0
		dc.l ArtExplosions
		dc.w $B400

plcGameOver:	dc.w 0
		dc.l ArtGameOver
		dc.w $B000

plcGHZ1:	dc.w $B
		dc.l TilesGHZ_1
		dc.w 0
		dc.l TilesGHZ_2
		dc.w $39A0
		dc.l byte_27400
		dc.w $6B00
		dc.l ArtPurpleRock
		dc.w $7A00
		dc.l ArtCrabmeat
		dc.w $8000
		dc.l ArtBuzzbomber
		dc.w $8880
		dc.l ArtChopper
		dc.w $8F60
		dc.l ArtNewtron
		dc.w $9360
		dc.l ArtMotobug
		dc.w $9E00
		dc.l ArtSpikes
		dc.w $A360
		dc.l ArtSpringHoriz
		dc.w $A460
		dc.l ArtSpringVerti
		dc.w $A660

plzGHZ2:	dc.w 5
		dc.l byte_2744A
		dc.w $7000
		dc.l ArtBridge
		dc.w $71C0
		dc.l ArtSpikeLogs
		dc.w $7300
		dc.l byte_27698
		dc.w $7540
		dc.l ArtSmashWall
		dc.w $A1E0
		dc.l ArtWall
		dc.w $6980

plcLZ1:		dc.w 0
		dc.l TilesLZ
		dc.w 0

plcLZ2:		dc.w 0
		dc.l ArtJaws
		dc.w $99C0

plcMZ1:		dc.w 9
		dc.l TilesMZ
		dc.w 0
		dc.l ArtChainPtfm
		dc.w $6000
		dc.l byte_2827A
		dc.w $68A0
		dc.l byte_2744A
		dc.w $7000
		dc.l byte_2816E
		dc.w $71C0
		dc.l byte_28558
		dc.w $7500
		dc.l ArtBuzzbomber
		dc.w $8880
		dc.l ArtYardin
		dc.w $8F60
		dc.l ArtBasaran
		dc.w $9700
		dc.l ArtSplats
		dc.w $9C80

plcMZ2:		dc.w 4
		dc.l ArtButtonMZ
		dc.w $A260
		dc.l ArtSpikes
		dc.w $A360
		dc.l ArtSpringHoriz
		dc.w $A460
		dc.l ArtSpringVerti
		dc.w $A660
		dc.l byte_28E6E
		dc.w $5700

plzSLZ1:	dc.w $A
		dc.l TilesSLZ
		dc.w 0
		dc.l byte_2827A
		dc.w $68A0
		dc.l ArtCrabmeat
		dc.w $8000
		dc.l ArtBuzzbomber
		dc.w $8880
		dc.l byte_297B6
		dc.w $9000
		dc.l byte_29D4A
		dc.w $9C00
		dc.l ArtMotobug
		dc.w $9E00
		dc.l byte_294DA
		dc.w $A260
		dc.l ArtSpikes
		dc.w $A360
		dc.l ArtSpringHoriz
		dc.w $A460
		dc.l ArtSpringVerti
		dc.w $A660

plcSLZ2:	dc.w 3
		dc.l ArtSeesaw
		dc.w $6E80
		dc.l ArtFan
		dc.w $7400
		dc.l byte_2953C
		dc.w $7980
		dc.l byte_2961E
		dc.w $7B80

plzSYZ1:	dc.w 4
		dc.l TilesSYZ
		dc.w 0
		dc.l ArtCrabmeat
		dc.w $8000
		dc.l ArtBuzzbomber
		dc.w $8880
		dc.l ArtYardin
		dc.w $8F60
		dc.l byte_2BC04
		dc.w $9700

plcSYZ2:	dc.w 6
		dc.l ArtBumper
		dc.w $7000
		dc.l byte_2A104
		dc.w $72C0
		dc.l byte_29FC0
		dc.w $7740
		dc.l ArtButton
		dc.w $A1E0
		dc.l ArtSpikes
		dc.w $A360
		dc.l ArtSpringHoriz
		dc.w $A460
		dc.l ArtSpringVerti
		dc.w $A660

plcSBZ1:	dc.w 0
		dc.l TilesSBZ
		dc.w 0

plcSBZ2:	dc.w 0
		dc.l ArtJaws
		dc.w $99C0

plcTitleCards:	dc.w 0
		dc.l ArtTitleCards
		dc.w $B000

word_12484:	dc.w 2
		dc.l byte_60000
		dc.w $8000
		dc.l byte_60864
		dc.w $8D80
		dc.l byte_60BB0
		dc.w $93A0

plcSignPosts:	dc.w 0
		dc.l ArtSignPost
		dc.w $D000

plcFlash:	dc.w 0
		dc.l ArtFlash
		dc.w $A820

word_124A8:	dc.w $B
		dc.l byte_64A7C
		dc.w 0
		dc.l ArtSpecialAnimals
		dc.w $A20
		dc.l ArtSpecialBlocks
		dc.w $2840
		dc.l ArtBumper
		dc.w $4760
		dc.l ArtSpecialGoal
		dc.w $4A20
		dc.l ArtSpecialUpDown
		dc.w $4C60
		dc.l ArtSpecialR
		dc.w $5E00
		dc.l ArtSpecial1up
		dc.w $6E00
		dc.l ArtSpecialStars
		dc.w $7E00
		dc.l byte_65432
		dc.w $8E00
		dc.l ArtSpecialSkull
		dc.w $9E00
		dc.l ArtSpecialU
		dc.w $AE00
		dc.l ArtSpecialEmerald
		dc.w 0
		dc.l ArtSpecialZone1
		dc.w 0
		dc.l ArtSpecialZone2
		dc.w 0
		dc.l ArtSpecialZone3
		dc.w 0
		dc.l ArtSpecialZone4
		dc.w 0
		dc.l ArtSpecialZone5
		dc.w 0
		dc.l ArtSpecialZone6
		dc.w 0

word_1251C:	dc.w 1
		dc.l ArtAnimalPocky
		dc.w $B000
		dc.l ArtAnimalCucky
		dc.w $B240

word_1252A:	dc.w 1
		dc.l ArtAnimalPecky
		dc.w $B000
		dc.l ArtAnimalRocky
		dc.w $B240

word_12538:	dc.w 1
		dc.l ArtAnimalPicky
		dc.w $B000
		dc.l ArtAnimalFlicky
		dc.w $B240

word_12546:	dc.w 1
		dc.l ArtAnimalRicky
		dc.w $B000
		dc.l ArtAnimalRocky
		dc.w $B240

word_12554:	dc.w 1
		dc.l ArtAnimalPicky
		dc.w $B000
		dc.l ArtAnimalCucky
		dc.w $B240

word_12562:	dc.w 1
		dc.l ArtAnimalPocky
		dc.w $B000
		dc.l ArtAnimalFlicky
		dc.w $B240
		align	$8000					; Unnecessary alignment
		incbin "unknown/18000.dat"
		even
ArtSega:	incbin "screens/sega/Main.nem"
		even
MapSega:	incbin "unknown/18A56.eni"
		even
byte_18A62:	incbin "unknown/18A62.unc"
		even
ArtTitleMain:	incbin "screens/title/Main.nem"
		even
ArtTitleSonic:	incbin "screens/title/Sonic.nem"
		even
		include "levels/shared/Sonic/sprite.map"
		include "levels/shared/Sonic/dynamic.map"
ArtSonic:	incbin "levels/shared/Sonic/Art.unc"
		even

byte_1C8EF:
ArtSmoke:	incbin "unsorted/smoke.nem"
		even
ArtShield:	incbin "levels/shared/Shield/Shield.nem"
		even
ArtInvinStars:	incbin "levels/shared/Shield/Stars.nem"
		even
ArtFlash:	incbin "unsorted/flash.nem"
		even
byte_27400:	incbin "unsorted/ghz flower stalk.nem"
		even
byte_2744A:	incbin "unsorted/ghz swing.nem"
		even
ArtBridge:	incbin "levels/GHZ/Bridge/Art.nem"
		even
byte_27698:	incbin "unsorted/ghz checkered ball.nem"
		even
ArtSpikes:	incbin "levels/shared/Spikes/Art.nem"
		even
ArtSpikeLogs:	incbin "levels/GHZ/SpikeLogs/Art.nem"
		even
ArtPurpleRock:	incbin "levels/GHZ/PurpleRock/Art.nem"
		even
ArtSmashWall:	incbin "levels/GHZ/SmashWall/Art.nem"
		even
ArtWall:	incbin "levels/GHZ/Wall/Art.nem"
		even
ArtChainPtfm:	incbin "levels/MZ/ChainPtfm/Art.nem"
		even
ArtButtonMZ:	incbin "levels/shared/Button/Art MZ.nem"
		even
byte_2816E:	incbin "unsorted/mz piston.nem"
		even
byte_2827A:	incbin "unsorted/mz fire ball.nem"
		even
byte_28558:	incbin "unsorted/mz lava.nem"
		even
byte_28E6E:	incbin "unsorted/mz pushable block.nem"
		even
ArtSeesaw:	incbin "levels/SLZ/Seesaw/Art.nem"
		even
ArtFan:		incbin "levels/SLZ/Fan/Art.nem"
		even
byte_294DA:	incbin "unsorted/slz platform.nem"
		even
byte_2953C:	incbin "unsorted/slz girders.nem"
		even
byte_2961E:	incbin "unsorted/slz spiked platforms.nem"
		even
byte_297B6:	incbin "unsorted/slz misc platforms.nem"
		even
byte_29D4A:	incbin "unsorted/slz metal block.nem"
		even
ArtBumper:	incbin "levels/SYZ/Bumper/Art.nem"
		even
byte_29FC0:	incbin "unsorted/syz small spiked ball.nem"
		even
ArtButton:	incbin "levels/shared/Button/Art.nem"
		even
byte_2A104:	incbin "unsorted/swinging spiked ball.nem"
		even
ArtCrabmeat:	incbin "levels/GHZ/Crabmeat/Art.nem"
		even
ArtBuzzbomber:	incbin "levels/GHZ/Buzzbomber/Art.nem"
		even
ArtChopper:	incbin "levels/GHZ/Chopper/Art.nem"
		even
ArtJaws:	incbin "levels/LZ/Jaws/Art.nem"
		even
byte_2BC04:	incbin "unsorted/roller.nem"
		even
ArtMotobug:	incbin "levels/GHZ/Motobug/Art.nem"
		even
ArtNewtron:	incbin "levels/GHZ/Newtron/Art.nem"
		even
ArtYardin:	incbin "levels/shared/Yardin/Art.nem"
		even
ArtBasaran:	incbin "levels/MZ/Basaran/Art.nem"
		even
ArtSplats:	incbin "levels/shared/Splats/Art.nem"
		even
ArtTitleCards:	incbin "levels/shared/Title Cards/Art.nem"
		even
ArtHUD:		incbin "levels/shared/HUD/Main.nem"
		even
ArtLives:	incbin "levels/shared/HUD/Lives.nem"
		even
ArtRings:	incbin "levels/shared/Rings/Art.nem"
		even
ArtMonitors:	incbin "levels/shared/Monitors/Art.nem"
		even
ArtExplosions:	incbin "levels/shared/Explosions/Art.nem"
		even
byte_2E6C8:	incbin "unsorted/score points.nem"
		even
ArtGameOver:	incbin "levels/shared/GameOver/Art.nem"
		even
ArtSpringHoriz:	incbin "levels/shared/Springs/Art Horizontal.nem"
		even
ArtSpringVerti:	incbin "levels/shared/Springs/Art Vertical.nem"
		even
ArtSignPost:	incbin "levels/shared/Signpost/Art.nem"
		even
ArtAnimalPocky:	incbin "levels/shared/Animals/Pocky.nem"
		even
ArtAnimalCucky:	incbin "levels/shared/Animals/Cucky.nem"
		even
ArtAnimalPecky:	incbin "levels/shared/Animals/Pecky.nem"
		even
ArtAnimalRocky:	incbin "levels/shared/Animals/Rocky.nem"
		even
ArtAnimalPicky:	incbin "levels/shared/Animals/Picky.nem"
		even
ArtAnimalFlicky:incbin "levels/shared/Animals/Flicky.nem"
		even
ArtAnimalRicky:	incbin "levels/shared/Animals/Ricky.nem"
		even
		align	$8000					; Unnecessary alignment
BlocksGHZ:	incbin "levels/GHZ/Blocks.unc"
		even
TilesGHZ_1:	incbin "levels/GHZ/Tiles1.nem"
		even
TilesGHZ_2:	incbin "levels/GHZ/Tiles2.nem"
		even
ChunksGHZ:	incbin "levels/GHZ/Chunks.kos"
		even
BlocksLZ:	incbin "levels/LZ/Blocks.unc"
		even
TilesLZ:	incbin "levels/LZ/Tiles.nem"
		even
ChunksLZ:	incbin "levels/LZ/Chunks.kos"
		even
BlocksMZ:	incbin "levels/MZ/Blocks.unc"
		even
TilesMZ:	incbin "levels/MZ/Tiles.nem"
		even
ChunksMZ:	incbin "levels/MZ/Chunks.kos"
		even
BlocksSLZ:	incbin "levels/SLZ/Blocks.unc"
		even
TilesSLZ:	incbin "levels/SLZ/Tiles.nem"
		even
ChunksSLZ:	incbin "levels/SLZ/Chunks.kos"
		even
BlocksSYZ:	incbin "levels/SYZ/Blocks.unc"
		even
TilesSYZ:	incbin "levels/SYZ/Tiles.nem"
		even
ChunksSYZ:	incbin "levels/SYZ/Chunks.kos"
		even
BlocksSBZ:	incbin "levels/SBZ/Blocks.unc"
		even
TilesSBZ:	incbin "levels/SBZ/Tiles.nem"
		even
ChunksSBZ:	incbin "levels/SBZ/Chunks.kos"
		even
byte_60000:	incbin "unknown/60000.dat"
		even
byte_60864:	incbin "unknown/60864.dat"
		even
byte_60BB0:	incbin "unknown/60BB0.dat"
		even
byte_61434:	incbin "unknown/61434.dat"
		even
byte_614C6:	incbin "unknown/614C6.dat"
		even
byte_61578:	incbin "unknown/61578.dat"
		even
byte_6161E:	incbin "unknown/6161E.dat"
		even

off_63000:	dc.w byte_63020-off_63000, byte_63026-off_63000, byte_6302C-off_63000, byte_63032-off_63000
		dc.w byte_63038-off_63000, byte_6303E-off_63000, byte_63044-off_63000, byte_6304A-off_63000
		dc.w byte_63050-off_63000, byte_63056-off_63000, byte_6305C-off_63000, byte_63062-off_63000
		dc.w byte_63068-off_63000, byte_6306E-off_63000, byte_63074-off_63000, byte_6307A-off_63000

byte_63020:	dc.b 1
		dc.b $F4, $A, 0, 0, $F4

byte_63026:	dc.b 1
		dc.b $F0, $F, 0, 9, $F0

byte_6302C:	dc.b 1
		dc.b $F0, $F, 0, $19, $F0

byte_63032:	dc.b 1
		dc.b $F0, $F, 0, $29, $F0

byte_63038:	dc.b 1
		dc.b $F0, $F, 0, $39, $F0

byte_6303E:	dc.b 1
		dc.b $F0, $F, 0, $49, $F0

byte_63044:	dc.b 1
		dc.b $F0, $F, 0, $59, $F0

byte_6304A:	dc.b 1
		dc.b $F0, $F, 0, $69, $F0

byte_63050:	dc.b 1
		dc.b $F0, $F, 0, $79, $F0

byte_63056:	dc.b 1
		dc.b $F0, $F, 0, $89, $F0

byte_6305C:	dc.b 1
		dc.b $F0, $F, 0, $99, $F0

byte_63062:	dc.b 1
		dc.b $F0, $F, 0, $A9, $F0

byte_63068:	dc.b 1
		dc.b $F0, $F, 0, $B9, $F0

byte_6306E:	dc.b 1
		dc.b $F0, $F, 0, $C9, $F0

byte_63074:	dc.b 1
		dc.b $F0, $F, 0, $D9, $F0

byte_6307A:	dc.b 1
		dc.b $F0, $F, 0, $E9, $F0
ArtSpecialBlocks:incbin "screens/special stage/Art Blocks.nem"
		even
byte_639B8:	incbin "unknown/639B8.eni"
		even
ArtSpecialAnimals:incbin "screens/special stage/Art Animals.nem"
		even
byte_6477C:	incbin "unknown/6477C.eni"
		even
byte_64A7C:	incbin "screens/special stage/ss bg misc.nem"
		even
ArtSpecialGoal:	incbin "screens/special stage/Art Goal.nem"
		even
ArtSpecialR:	incbin "screens/special stage/Art R Block.nem"
		even
ArtSpecialSkull:incbin "screens/special stage/Art Skull.nem"
		even
ArtSpecialU:	incbin "screens/special stage/Art U Block.nem"
		even
ArtSpecial1up:	incbin "screens/special stage/Art 1up.nem"
		even
ArtSpecialStars:incbin "screens/special stage/Art Stars.nem"
		even
byte_65432:	incbin "screens/special stage/ss red white.nem"
		even
ArtSpecialZone1:incbin "screens/special stage/Art Zone 1.nem"
		even
ArtSpecialZone2:incbin "screens/special stage/Art Zone 2.nem"
		even
ArtSpecialZone3:incbin "screens/special stage/Art Zone 3.nem"
		even
ArtSpecialZone4:incbin "screens/special stage/Art Zone 4.nem"
		even
ArtSpecialZone5:incbin "screens/special stage/Art Zone 5.nem"
		even
ArtSpecialZone6:incbin "screens/special stage/Art Zone 6.nem"
		even
ArtSpecialUpDown:incbin "screens/special stage/Art Up Down.nem"
		even
ArtSpecialEmerald:incbin "screens/special stage/Art Emerald.nem"
		even
		align	$8000					; Unnecessary alignment
byte_68000:	incbin "unknown/68000.dat"
		even
byte_68100:	incbin "unknown/68100.dat"
		even
byte_69100:	incbin "unknown/69100.dat"
		even
colGHZ:		incbin "levels/GHZ/Collision.dat"
		even
colLZ:		incbin "levels/LZ/Collision.dat"
		even
colMZ:		incbin "levels/MZ/Collision.dat"
		even
colSLZ:		incbin "levels/SLZ/Collision.dat"
		even
colSYZ:		incbin "levels/SYZ/Collision.dat"
		even
colSBZ:		incbin "levels/SBZ/Collision.dat"
		even
byte_6AB08:	incbin "unknown/6AB08.dat"
		even
byte_6B018:	incbin "unknown/6B018.dat"
		even
byte_6B218:	incbin "unknown/6B218.dat"
		even
byte_6B618:	incbin "unknown/6B618.dat"
		even
byte_6BA98:	incbin "unknown/6BA98.dat"
		even
byte_6BD98:	incbin "unknown/6BD98.dat"
		even
byte_6C398:	incbin "unknown/6C398.dat"
		even
byte_6C998:	incbin "unknown/6C998.dat"
		even

LayoutArray:	dc.w LayoutGHZ1FG-LayoutArray, LayoutGHZ1BG-LayoutArray, LayoutGHZ1Unk-LayoutArray
		dc.w LayoutGHZ2FG-LayoutArray, LayoutGHZ2BG-LayoutArray, byte_6CF3C-LayoutArray
		dc.w LayoutGHZ3FG-LayoutArray, LayoutGHZ3BG-LayoutArray, byte_6D084-LayoutArray
		dc.w byte_6D088-LayoutArray, byte_6D088-LayoutArray, byte_6D088-LayoutArray
		dc.w LayoutLZ1FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D190-LayoutArray
		dc.w LayoutLZ2FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D216-LayoutArray
		dc.w LayoutLZ3FG-LayoutArray, LayoutLZBG-LayoutArray, byte_6D31C-LayoutArray
		dc.w byte_6D320-LayoutArray, byte_6D320-LayoutArray, byte_6D320-LayoutArray
		dc.w LayoutMZ1FG-LayoutArray, LayoutMZ1BG-LayoutArray, LayoutMZ1FG-LayoutArray
		dc.w LayoutMZ2FG-LayoutArray, LayoutMZ2BG-LayoutArray, byte_6D614-LayoutArray
		dc.w LayoutMZ3FG-LayoutArray, LayoutMZ3BG-LayoutArray, byte_6D7DC-LayoutArray
		dc.w byte_6D7E0-LayoutArray, byte_6D7E0-LayoutArray, byte_6D7E0-LayoutArray
		dc.w LayoutSLZ1FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w LayoutSLZ2FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w LayoutSLZ3FG-LayoutArray, LayoutSLZBG-LayoutArray, byte_6DBE4-LayoutArray
		dc.w byte_6DBE4-LayoutArray, byte_6DBE4-LayoutArray, byte_6DBE4-LayoutArray
		dc.w LayoutSYZ1FG-LayoutArray, LayoutSYZBG-LayoutArray, byte_6DCD8-LayoutArray
		dc.w LayoutSYZ2FG-LayoutArray, LayoutSYZBG-LayoutArray, byte_6DDDA-LayoutArray
		dc.w LayoutSYZ3FG-LayoutArray, LayoutSYZBG-LayoutArray, byte_6DF30-LayoutArray
		dc.w byte_6DF34-LayoutArray, byte_6DF34-LayoutArray, byte_6DF34-LayoutArray
		dc.w LayoutSBZ1FG-LayoutArray, LayoutSBZ2FG-LayoutArray, LayoutSBZ2FG-LayoutArray
		dc.w LayoutSBZ2FG-LayoutArray, LayoutSBZ2BG-LayoutArray, LayoutSBZ2BG-LayoutArray
		dc.w byte_6E340-LayoutArray, byte_6E340-LayoutArray, byte_6E340-LayoutArray
		dc.w byte_6E344-LayoutArray, byte_6E344-LayoutArray, byte_6E344-LayoutArray
		dc.w LayoutEnding1FG-LayoutArray, LayoutEnding1BG-LayoutArray, LayoutEnding1BG-LayoutArray
		dc.w byte_6E3CE-LayoutArray, byte_6E3CE-LayoutArray, byte_6E3CE-LayoutArray
		dc.w byte_6E3D2-LayoutArray, byte_6E3D2-LayoutArray, byte_6E3D2-LayoutArray
		dc.w byte_6E3D6-LayoutArray, byte_6E3D6-LayoutArray, byte_6E3D6-LayoutArray
LayoutGHZ1FG:	incbin "levels/GHZ/Foreground 1.unc"
		even
LayoutGHZ1BG:	incbin "levels/GHZ/Background 1.unc"
		even

LayoutGHZ1Unk:	dc.b 0, 0, 0, 0
LayoutGHZ2FG:	incbin "levels/GHZ/Foreground 2.unc"
		even
LayoutGHZ2BG:	incbin "levels/GHZ/Background 2.unc"
		even

byte_6CF3C:	dc.b 0, 0, 0, 0
LayoutGHZ3FG:	incbin "levels/GHZ/Foreground 3.unc"
		even
LayoutGHZ3BG:	incbin "levels/GHZ/Background 3.unc"
		even

byte_6D084:	dc.b 0, 0, 0, 0

byte_6D088:	dc.b 0, 0, 0, 0
LayoutLZ1FG:	incbin "levels/LZ/Foreground 1.unc"
		even
LayoutLZBG:	incbin "levels/LZ/Background.unc"
		even

byte_6D190:	dc.b 0, 0, 0, 0
LayoutLZ2FG:	incbin "levels/LZ/Foreground 2.unc"
		even

byte_6D216:	dc.b 0, 0, 0, 0
LayoutLZ3FG:	incbin "levels/LZ/Foreground 3.unc"
		even

byte_6D31C:	dc.b 0, 0, 0, 0

byte_6D320:	dc.b 0, 0, 0, 0
LayoutMZ1FG:	incbin "levels/MZ/Foreground 1.unc"
		even
LayoutMZ1BG:	incbin "levels/MZ/Background 1.unc"
		even
LayoutMZ2FG:	incbin "levels/MZ/Foreground 2.unc"
		even
LayoutMZ2BG:	incbin "levels/MZ/Background 2.unc"
		even

byte_6D614:	dc.b 0, 0, 0, 0
LayoutMZ3FG:	incbin "levels/MZ/Foreground 3.unc"
		even
LayoutMZ3BG:	incbin "levels/MZ/Background 3.unc"
		even

byte_6D7DC:	dc.b 0, 0, 0, 0

byte_6D7E0:	dc.b 0, 0, 0, 0
LayoutSLZ1FG:	incbin "levels/SLZ/Foreground 1.unc"
		even
LayoutSLZBG:	incbin "levels/SLZ/Background.unc"
		even
LayoutSLZ2FG:	incbin "levels/SLZ/Foreground 2.unc"
		even
LayoutSLZ3FG:	incbin "levels/SLZ/Foreground 3.unc"
		even

byte_6DBE4:	dc.b 0, 0, 0, 0
LayoutSYZ1FG:	incbin "levels/SYZ/Foreground 1.unc"
		even
LayoutSYZBG:	incbin "levels/SYZ/Background.unc"
		even

byte_6DCD8:	dc.b 0, 0, 0, 0
LayoutSYZ2FG:	incbin "levels/SYZ/Foreground 2.unc"
		even

byte_6DDDA:	dc.b 0, 0, 0, 0
LayoutSYZ3FG:	incbin "levels/SYZ/Foreground 3.unc"
		even

byte_6DF30:	dc.b 0, 0, 0, 0

byte_6DF34:	dc.b 0, 0, 0, 0
LayoutSBZ1FG:	incbin "levels/SBZ/Foreground 1.unc"
		even
LayoutSBZ2FG:	incbin "levels/SBZ/Foreground 2.unc"
		even
LayoutSBZ2BG:	incbin "levels/SBZ/Background 2.unc"
		even

byte_6E340:	dc.b 0, 0, 0, 0

byte_6E344:	dc.b 0, 0, 0, 0
LayoutEnding1FG:incbin "levels/Ending/Foreground 1.unc"
		even

LayoutEnding1BG:dc.b 0, 0, 0, 0

byte_6E3CE:	dc.b 0, 0, 0, 0

byte_6E3D2:	dc.b 0, 0, 0, 0

byte_6E3D6:	dc.b 0, 0, 0, 0
		align	$8000					; Unnecessary alignment

ObjectListArray:dc.w ObjListGHZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListGHZ2-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListGHZ3-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListGHZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListLZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListLZ2-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListLZ3-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListLZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListMZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListMZ2-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListMZ3-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListMZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSLZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSLZ2-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSLZ3-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSLZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSYZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSYZ2-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSYZ3-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSYZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSBZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSBZ2-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSBZ3-ObjectListArray, ObjListNull-ObjectListArray
		dc.w ObjListSBZ1-ObjectListArray, ObjListNull-ObjectListArray
		dc.w $FFFF, 0, 0
ObjListGHZ1:	incbin "levels/GHZ/Objects 1.unc"
		even
ObjListGHZ2:	incbin "levels/GHZ/Objects 2.unc"
		even
ObjListGHZ3:	incbin "levels/GHZ/Objects 3.unc"
		even
ObjListLZ1:	incbin "levels/LZ/Objects 1.unc"
		even
ObjListLZ2:	incbin "levels/LZ/Objects 2.unc"
		even
ObjListLZ3:	incbin "levels/LZ/Objects 3.unc"
		even
ObjListMZ1:	incbin "levels/MZ/Objects 1.unc"
		even
ObjListMZ2:	incbin "levels/MZ/Objects 2.unc"
		even
ObjListMZ3:	incbin "levels/MZ/Objects 3.unc"
		even
ObjListSLZ1:	incbin "levels/SLZ/Objects 1.unc"
		even
ObjListSLZ2:	incbin "levels/SLZ/Objects 2.unc"
		even
ObjListSLZ3:	incbin "levels/SLZ/Objects 3.unc"
		even
ObjListSYZ1:	incbin "levels/SYZ/Objects 1.unc"
		even
ObjListSYZ2:	incbin "levels/SYZ/Objects 2.unc"
		even
ObjListSYZ3:	incbin "levels/SYZ/Objects 3.unc"
		even
ObjListSBZ1:	incbin "levels/SBZ/Objects 1.unc"
		even
ObjListSBZ2:	incbin "levels/SBZ/Objects 2.unc"
		even
ObjListSBZ3:	incbin "levels/SBZ/Objects 3.unc"
		even

ObjListNull:	dc.w $FFFF, 0, 0
		align	$4000					; Unnecessary alignment

mSoundPriorities:dc.l mSoundPrioList

mSpecialSFXPtr:	dc.l mSpecialSFXList

mMusicPtr:	dc.l mMusicList

mSFXPtr:	dc.l mSFXList

off_74010:	dc.l byte_74110

mVolEnvPtr:	dc.l mVolEnvList
		dc.l $A0
		dc.l SoundSource

mSpeedTempos:	dc.l mSpeedTempoList

mVolEnvList:	dc.l byte_74048, byte_7405F, byte_74066, byte_74077, byte_74091
		dc.l byte_74082, byte_740BB, byte_740D7, byte_740FF

byte_74048:	dc.b 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5
		dc.b 5, 6, 6, 6, 7, $83

byte_7405F:	dc.b 0, 2, 4, 6, 8, $10, $83

byte_74066:	dc.b 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, $83

byte_74077:	dc.b 0, 0, 2, 3, 4, 4, 5, 5, 5, 6, $83

byte_74082:	dc.b 3, 3, 3, 2, 2, 2, 2, 1, 1, 1, 0, 0, 0, 0, $83

byte_74091:	dc.b 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1
		dc.b 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3
		dc.b 3, 3, 3, 3, 3, 3, 4, $83

byte_740BB:	dc.b 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3
		dc.b 3, 3, 4, 4, 4, 5, 5, 5, 6, 7, $83

byte_740D7:	dc.b 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3
		dc.b 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6
		dc.b 6, 6, 7, 7, 7, $83

byte_740FF:	dc.b 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, $C, $D, $E
		dc.b $F, $83

byte_74110:	dc.b $D, 1, 7, 4, 1, 1, 1, 4, 2, 1, 2, 4, 8, 1, 6, 4

mSpeedTempoList:dc.b 7, $72, $73, $26, $15, 8, $FF, 5

mMusicList:	dc.l mGHZ, mLZ, mMZ, mSLZ, mSYZ, mSBZ, mInvincibility
		dc.l mExtraLife, mSS, mTitle, mEnding, mBoss, mFZ, mResults
		dc.l mGameOver, mContinue, mCredits

mSoundPrioList:	dcb.b $1F,$80
		dcb.b $30,$70
		dcb.b $16,$80
		dc.b 0
; ---------------------------------------------------------------------------

SoundSource:
		move.w	#$100,($A11100).l

loc_741DA:
		btst	#0,($A11100).l
		bne.s	loc_741DA
		btst	#7,($A01FFD).l
		beq.s	loc_74202
		move.w	#0,($A11100).l
		nop
		nop
		nop
		nop
		nop
		bra.s	SoundSource
; ---------------------------------------------------------------------------

loc_74202:
		lea	((SoundMemory)&$FFFFFF).l,a6
		clr.b	$E(a6)
		tst.b	3(a6)
		bne.w	loc_745C6
		subq.b	#1,1(a6)
		bne.s	loc_7421E
		jsr	sub_74D60(pc)

loc_7421E:
		move.b	4(a6),d0
		beq.s	loc_74228
		jsr	sub_74C3C(pc)

loc_74228:
		tst.b	$24(a6)
		beq.s	loc_74232
		jsr	sub_74DB6(pc)

loc_74232:
		tst.w	$A(a6)
		beq.s	loc_7423C
		jsr	sub_74678(pc)

loc_7423C:
		lea	$40(a6),a5
		tst.b	(a5)
		bpl.s	loc_74248
		jsr	sub_742C2(pc)

loc_74248:
		clr.b	8(a6)
		moveq	#5,d7

loc_7424E:
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_7425A
		jsr	sub_74350(pc)

loc_7425A:
		dbf	d7,loc_7424E
		moveq	#2,d7

loc_74260:
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_7426C
		jsr	sub_74F5C(pc)

loc_7426C:
		dbf	d7,loc_74260
		move.b	#$80,$E(a6)
		moveq	#2,d7

loc_74278:
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_74284
		jsr	sub_74350(pc)

loc_74284:
		dbf	d7,loc_74278
		moveq	#2,d7

loc_7428A:
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_74296
		jsr	sub_74F5C(pc)

loc_74296:
		dbf	d7,loc_7428A
		move.b	#$40,$E(a6)
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_742AC
		jsr	sub_74350(pc)

loc_742AC:
		adda.w	#$30,a5
		tst.b	(a5)
		bpl.s	loc_742B8
		jsr	sub_74F5C(pc)

loc_742B8:
		move.w	#0,($A11100).l
		rts
; ---------------------------------------------------------------------------

sub_742C2:
		subq.b	#1,$E(a5)
		bne.s	locret_74326
		move.b	#$80,8(a6)
		movea.l	4(a5),a4

loc_742D2:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	loc_742E2
		jsr	sub_75184(pc)
		bra.s	loc_742D2
; ---------------------------------------------------------------------------

loc_742E2:
		tst.b	d5
		bpl.s	loc_742F8
		move.b	d5,$10(a5)
		move.b	(a4)+,d5
		bpl.s	loc_742F8
		subq.w	#1,a4
		move.b	$F(a5),$E(a5)
		bra.s	loc_742FC
; ---------------------------------------------------------------------------

loc_742F8:
		jsr	sub_743CA(pc)

loc_742FC:
		move.l	a4,4(a5)
		btst	#2,(a5)
		bne.s	locret_74326
		moveq	#0,d0
		move.b	$10(a5),d0
		cmpi.b	#$80,d0
		beq.s	locret_74326
		btst	#3,d0
		bne.s	loc_74328
		tst.b	($A01FF6).l
		bne.s	locret_74326
		move.b	d0,($A01FFF).l

locret_74326:
		rts
; ---------------------------------------------------------------------------

loc_74328:
		subi.b	#$88,d0
		move.b	byte_74348(pc,d0.w),d0
		tst.b	($A01FF6).l
		bne.s	locret_74346
		move.b	d0,($A00000|TimpaniPitch).l
		move.b	#$83,($A01FFF).l

locret_74346:
		rts
; ---------------------------------------------------------------------------

byte_74348:	dc.b $12, $15, $1C, $1D, $FF, $FF, $FF, $FF
; ---------------------------------------------------------------------------

sub_74350:
		subq.b	#1,$E(a5)
		bne.s	loc_7436A
		bclr	#4,(a5)
		jsr	sub_74376(pc)
		jsr	sub_744A2(pc)
		jsr	loc_74518(pc)
		bra.w	loc_74E10
; ---------------------------------------------------------------------------

loc_7436A:
		jsr	sub_74428(pc)
		jsr	sub_74450(pc)
		bra.w	loc_744AE
; ---------------------------------------------------------------------------

sub_74376:
		movea.l	4(a5),a4
		bclr	#1,(a5)

loc_7437E:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	loc_7438E
		jsr	sub_75184(pc)
		bra.s	loc_7437E
; ---------------------------------------------------------------------------

loc_7438E:
		jsr	sub_74E2C(pc)
		tst.b	d5
		bpl.s	loc_743A4
		jsr	sub_743AC(pc)
		move.b	(a4)+,d5
		bpl.s	loc_743A4
		subq.w	#1,a4
		bra.w	sub_743EA
; ---------------------------------------------------------------------------

loc_743A4:
		jsr	sub_743CA(pc)
		bra.w	sub_743EA
; ---------------------------------------------------------------------------

sub_743AC:
		subi.b	#$80,d5
		beq.s	loc_743E2
		add.b	8(a5),d5
		andi.w	#$7F,d5
		lsl.w	#1,d5
		lea	word_74E9C(pc),a0
		move.w	(a0,d5.w),d6
		move.w	d6,$10(a5)
		rts
; ---------------------------------------------------------------------------

sub_743CA:
		move.b	d5,d0
		move.b	2(a5),d1

loc_743D0:
		subq.b	#1,d1
		beq.s	loc_743D8
		add.b	d5,d0
		bra.s	loc_743D0
; ---------------------------------------------------------------------------

loc_743D8:
		move.b	d0,$F(a5)
		move.b	d0,$E(a5)
		rts
; ---------------------------------------------------------------------------

loc_743E2:
		bset	#1,(a5)
		clr.w	$10(a5)
; ---------------------------------------------------------------------------

sub_743EA:
		move.l	a4,4(a5)
		move.b	$F(a5),$E(a5)
		btst	#4,(a5)
		bne.s	locret_74426
		move.b	$13(a5),$12(a5)
		clr.b	$C(a5)
		btst	#3,(a5)
		beq.s	locret_74426
		movea.l	$14(a5),a0
		move.b	(a0)+,$18(a5)
		move.b	(a0)+,$19(a5)
		move.b	(a0)+,$1A(a5)
		move.b	(a0)+,d0
		lsr.b	#1,d0
		move.b	d0,$1B(a5)
		clr.w	$1C(a5)

locret_74426:
		rts
; ---------------------------------------------------------------------------

sub_74428:
		tst.b	$12(a5)
		beq.s	locret_7444E
		subq.b	#1,$12(a5)
		bne.s	locret_7444E
		bset	#1,(a5)
		tst.b	1(a5)
		bmi.w	loc_74448
		jsr	sub_74E2C(pc)
		addq.w	#4,sp
		rts
; ---------------------------------------------------------------------------

loc_74448:
		jsr	sub_750CA(pc)
		addq.w	#4,sp

locret_7444E:
		rts
; ---------------------------------------------------------------------------

sub_74450:
		addq.w	#4,sp
		btst	#3,(a5)
		beq.s	locret_744A0
		tst.b	$18(a5)
		beq.s	loc_74464
		subq.b	#1,$18(a5)
		rts
; ---------------------------------------------------------------------------

loc_74464:
		subq.b	#1,$19(a5)
		beq.s	loc_7446C
		rts
; ---------------------------------------------------------------------------

loc_7446C:
		movea.l	$14(a5),a0
		move.b	1(a0),$19(a5)
		tst.b	$1B(a5)
		bne.s	loc_74488
		move.b	3(a0),$1B(a5)
		neg.b	$1A(a5)
		rts
; ---------------------------------------------------------------------------

loc_74488:
		subq.b	#1,$1B(a5)
		move.b	$1A(a5),d6
		ext.w	d6
		add.w	$1C(a5),d6
		move.w	d6,$1C(a5)
		add.w	$10(a5),d6
		subq.w	#4,sp

locret_744A0:
		rts
; ---------------------------------------------------------------------------

sub_744A2:
		btst	#1,(a5)
		bne.s	locret_744E0
		move.w	$10(a5),d6
		beq.s	loc_744E2

loc_744AE:
		move.b	$1E(a5),d0
		ext.w	d0
		add.w	d0,d6
		btst	#2,(a5)
		bne.s	locret_744E0
		tst.b	$F(a6)
		beq.s	loc_744CA
		cmpi.b	#2,1(a5)
		beq.s	loc_744E8

loc_744CA:
		move.w	d6,d1
		lsr.w	#8,d1
		move.b	#$A4,d0
		jsr	sub_74E50(pc)
		move.b	d6,d1
		move.b	#$A0,d0
		jsr	sub_74E50(pc)

locret_744E0:
		rts
; ---------------------------------------------------------------------------

loc_744E2:
		bset	#1,(a5)
		rts
; ---------------------------------------------------------------------------

loc_744E8:
		lea	byte_74510(pc),a1
		lea	$10(a6),a2
		moveq	#3,d7

loc_744F2:
		move.w	d6,d1
		move.w	(a2)+,d0
		add.w	d0,d1
		move.w	d1,d3
		lsr.w	#8,d1
		move.b	(a1)+,d0
		jsr	sub_74E5C(pc)
		move.b	d3,d1
		move.b	(a1)+,d0
		jsr	sub_74E5C(pc)
		dbf	d7,loc_744F2
		rts
; ---------------------------------------------------------------------------

byte_74510:	dc.b $AD, $A9, $AC, $A8, $AE, $AA, $A6, $A2
; ---------------------------------------------------------------------------

loc_74518:
		btst	#1,(a5)
		bne.s	locret_7452A
		moveq	#0,d0
		move.b	$1F(a5),d0
		lsl.w	#1,d0
		jmp	locret_7452A(pc,d0.w)
; ---------------------------------------------------------------------------

locret_7452A:
		rts
; ---------------------------------------------------------------------------
		bra.s	loc_74556
; ---------------------------------------------------------------------------
		bra.s	loc_7454C
; ---------------------------------------------------------------------------
		bra.s	loc_7454C
; ---------------------------------------------------------------------------
		btst	#1,(a5)
		bne.s	locret_74544
		moveq	#0,d0
		move.b	$1F(a5),d0
		lsl.w	#1,d0
		jmp	locret_74544(pc,d0.w)
; ---------------------------------------------------------------------------

locret_74544:
		rts
; ---------------------------------------------------------------------------
		rts
; ---------------------------------------------------------------------------
		bra.s	loc_74556
; ---------------------------------------------------------------------------
		bra.s	loc_74556
; ---------------------------------------------------------------------------

loc_7454C:
		move.b	$23(a5),$24(a5)
		clr.b	$21(a5)

loc_74556:
		move.b	$24(a5),d0
		cmp.b	$23(a5),d0
		bne.s	loc_7457E
		move.b	$22(a5),d3
		cmp.b	$21(a5),d3
		bpl.s	loc_74576
		cmpi.b	#2,$1F(a5)
		beq.s	locret_745AE
		clr.b	$21(a5)

loc_74576:
		clr.b	$24(a5)
		addq.b	#1,$21(a5)

loc_7457E:
		moveq	#0,d0
		move.b	$20(a5),d0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	off_745B0(pc,d0.w),a0
		moveq	#0,d0
		move.b	$21(a5),d0
		subq.w	#1,d0
		move.b	(a0,d0.w),d1
		move.b	$A(a5),d0
		andi.b	#$37,d0
		or.b	d0,d1
		move.b	#$B4,d0
		jsr	sub_74E44(pc)
		addq.b	#1,$24(a5)

locret_745AE:
		rts
; ---------------------------------------------------------------------------

off_745B0:	dc.l byte_745BC, byte_745BE, byte_745C1

byte_745BC:	dc.b $40, $80

byte_745BE:	dc.b $40, $C0, $80

byte_745C1:	dc.b $C0, $80, $C0, $40, 0
; ---------------------------------------------------------------------------

loc_745C6:
		bmi.s	loc_7460A
		cmpi.b	#2,3(a6)
		beq.w	loc_74674
		move.b	#2,3(a6)
		moveq	#2,d2
		move.b	#$B4,d0
		moveq	#0,d1

loc_745E0:
		jsr	sub_74E5C(pc)
		jsr	sub_74E80(pc)
		addq.b	#1,d0
		dbf	d2,loc_745E0
		moveq	#2,d2
		moveq	#$28,d0

loc_745F2:
		move.b	d2,d1
		jsr	sub_74E5C(pc)
		addq.b	#4,d1
		jsr	sub_74E5C(pc)
		dbf	d2,loc_745F2
		jsr	sub_750E0(pc)
		bra.w	loc_742B8
; ---------------------------------------------------------------------------

loc_7460A:
		clr.b	3(a6)
		moveq	#$30,d3
		lea	$40(a6),a5
		moveq	#6,d4

loc_74616:
		btst	#7,(a5)
		beq.s	loc_7462E
		btst	#2,(a5)
		bne.s	loc_7462E
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	sub_74E50(pc)

loc_7462E:
		adda.w	d3,a5
		dbf	d4,loc_74616
		lea	$220(a6),a5
		moveq	#2,d4

loc_7463A:
		btst	#7,(a5)
		beq.s	loc_74652
		btst	#2,(a5)
		bne.s	loc_74652
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	sub_74E50(pc)

loc_74652:
		adda.w	d3,a5
		dbf	d4,loc_7463A
		lea	$340(a6),a5
		btst	#7,(a5)
		beq.s	loc_74674
		btst	#2,(a5)
		bne.s	loc_74674
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	sub_74E50(pc)

loc_74674:
		bra.w	loc_742B8
; ---------------------------------------------------------------------------

sub_74678:
		movea.l	(mSoundPriorities).l,a0
		lea	$A(a6),a1
		move.b	0(a6),d3
		moveq	#2,d4

loc_74688:
		move.b	(a1),d0
		move.b	d0,d1
		clr.b	(a1)+
		subi.b	#$81,d0
		bcs.s	loc_746A6
		andi.w	#$7F,d0
		move.b	(a0,d0.w),d2
		cmp.b	d3,d2
		bcs.s	loc_746A6
		move.b	d2,d3
		move.b	d1,9(a6)

loc_746A6:
		dbf	d4,loc_74688
		tst.b	d3
		bmi.s	loc_746B2
		move.b	d3,0(a6)

loc_746B2:
		moveq	#0,d7
		move.b	9(a6),d7
		move.b	#$80,9(a6)
		cmpi.b	#$80,d7
		beq.s	locret_746FC
		bcs.w	loc_74CFE
		cmpi.b	#$9F,d7
		bls.w	loc_74730
		cmpi.b	#$A0,d7
		bcs.w	locret_746FC
		cmpi.b	#$CF,d7
		bls.w	loc_74920
		cmpi.b	#$D0,d7
		bcs.w	locret_746FC
		cmpi.b	#$D7,d7
		bcs.w	loc_74A4C
		cmpi.b	#$E0,d7
		bcs.s	loc_7471C
		cmpi.b	#$E5,d7
		bls.s	loc_746FE

locret_746FC:
		rts
; ---------------------------------------------------------------------------

loc_746FE:
		subi.b	#$E0,d7
		lsl.w	#2,d7
		jmp	loc_74708(pc,d7.w)
; ---------------------------------------------------------------------------

loc_74708:
		bra.w	loc_74C1E
; ---------------------------------------------------------------------------
		bra.w	sub_74B10
; ---------------------------------------------------------------------------
		bra.w	loc_74D90
; ---------------------------------------------------------------------------
		bra.w	loc_74DA4
; ---------------------------------------------------------------------------
		bra.w	sub_74BB4
; ---------------------------------------------------------------------------

loc_7471C:
		addi.b	#$B1,d7
		move.b	d7,($A01FFF).l
		nop
		nop
		nop
		clr.b	(a0)+
		rts
; ---------------------------------------------------------------------------

loc_74730:
		cmpi.b	#$88,d7
		bne.s	loc_7477E
		tst.b	$27(a6)
		bne.w	loc_74910
		lea	$40(a6),a5
		moveq	#9,d0

loc_74744:
		bclr	#2,(a5)
		adda.w	#$30,a5
		dbf	d0,loc_74744
		lea	$220(a6),a5
		moveq	#5,d0

loc_74756:
		bclr	#7,(a5)
		adda.w	#$30,a5
		dbf	d0,loc_74756
		movea.l	a6,a0
		lea	$3A0(a6),a1
		move.w	#$87,d0

loc_7476C:
		move.l	(a0)+,(a1)+
		dbf	d0,loc_7476C
		move.b	#$80,$27(a6)
		clr.b	0(a6)
		bra.s	loc_74786
; ---------------------------------------------------------------------------

loc_7477E:
		clr.b	$27(a6)
		clr.b	$26(a6)

loc_74786:
		jsr	sub_74D2A(pc)
		movea.l	(mSpeedTempos).l,a4
		subi.b	#$81,d7
		move.b	(a4,d7.w),$29(a6)
		movea.l	(mMusicPtr).l,a4
		lsl.w	#2,d7
		movea.l	(a4,d7.w),a4
		moveq	#0,d0
		move.w	(a4),d0
		add.l	a4,d0
		move.l	d0,$18(a6)
		move.b	5(a4),d0
		move.b	d0,$28(a6)
		tst.b	$2A(a6)
		beq.s	loc_747C2
		move.b	$29(a6),d0

loc_747C2:
		move.b	d0,2(a6)
		move.b	d0,1(a6)
		moveq	#0,d1
		movea.l	a4,a3
		addq.w	#6,a4
		moveq	#0,d7
		move.b	2(a3),d7
		beq.w	loc_7486E
		subq.b	#1,d7
		move.b	#$C0,d1
		move.b	4(a3),d4
		moveq	#$30,d6
		move.b	#1,d5
		lea	$40(a6),a1
		lea	byte_74914(pc),a2

loc_747F2:
		bset	#7,(a1)
		move.b	(a2)+,1(a1)
		move.b	d4,2(a1)
		move.b	d6,$D(a1)
		move.b	d1,$A(a1)
		move.b	d5,$E(a1)
		moveq	#0,d0
		move.w	(a4)+,d0
		add.l	a3,d0
		move.l	d0,4(a1)
		move.w	(a4)+,8(a1)
		adda.w	d6,a1
		dbf	d7,loc_747F2
		cmpi.b	#7,2(a3)
		bne.s	loc_74832
		moveq	#$2B,d0
		moveq	#0,d1
		jsr	sub_74E5C(pc)
		bra.w	loc_7486E
; ---------------------------------------------------------------------------

loc_74832:
		moveq	#$28,d0
		moveq	#6,d1
		jsr	sub_74E5C(pc)
		move.b	#$42,d0
		moveq	#$7F,d1
		jsr	sub_74E80(pc)
		move.b	#$4A,d0
		moveq	#$7F,d1
		jsr	sub_74E80(pc)
		move.b	#$46,d0
		moveq	#$7F,d1
		jsr	sub_74E80(pc)
		move.b	#$4E,d0
		moveq	#$7F,d1
		jsr	sub_74E80(pc)
		move.b	#$B6,d0
		move.b	#$C0,d1
		jsr	sub_74E80(pc)

loc_7486E:
		moveq	#0,d7
		move.b	3(a3),d7
		beq.s	loc_748AE
		subq.b	#1,d7
		lea	$190(a6),a1
		lea	byte_7491C(pc),a2

loc_74880:
		bset	#7,(a1)
		move.b	(a2)+,1(a1)
		move.b	d4,2(a1)
		move.b	d6,$D(a1)
		move.b	d5,$E(a1)
		moveq	#0,d0
		move.w	(a4)+,d0
		add.l	a3,d0
		move.l	d0,4(a1)
		move.w	(a4)+,8(a1)
		move.b	(a4)+,d0
		move.b	(a4)+,$B(a1)
		adda.w	d6,a1
		dbf	d7,loc_74880

loc_748AE:
		lea	$220(a6),a1
		moveq	#5,d7

loc_748B4:
		tst.b	(a1)
		bpl.w	loc_748D6
		moveq	#0,d0
		move.b	1(a1),d0
		bmi.s	loc_748C8
		subq.b	#2,d0
		lsl.b	#2,d0
		bra.s	loc_748CA
; ---------------------------------------------------------------------------

loc_748C8:
		lsr.b	#3,d0

loc_748CA:
		lea	off_74A0C(pc),a0
		movea.l	(a0,d0.w),a0
		bset	#2,(a0)

loc_748D6:
		adda.w	d6,a1
		dbf	d7,loc_748B4
		tst.w	$340(a6)
		bpl.s	loc_748E8
		bset	#2,$100(a6)

loc_748E8:
		tst.w	$370(a6)
		bpl.s	loc_748F4
		bset	#2,$1F0(a6)

loc_748F4:
		lea	$70(a6),a5
		moveq	#5,d4

loc_748FA:
		jsr	sub_74E2C(pc)
		adda.w	d6,a5
		dbf	d4,loc_748FA
		moveq	#2,d4

loc_74906:
		jsr	sub_750CA(pc)
		adda.w	d6,a5
		dbf	d4,loc_74906

loc_74910:
		addq.w	#4,sp
		rts
; ---------------------------------------------------------------------------

byte_74914:	dc.b 6, 0, 1, 2, 4, 5, 6, 0

byte_7491C:	dc.b $80, $A0, $C0, 0
; ---------------------------------------------------------------------------

loc_74920:
		tst.b	$27(a6)
		bne.w	locret_74A0A
		cmpi.b	#$B5,d7
		bne.s	loc_7493E
		tst.b	$2B(a6)
		bne.s	loc_74938
		move.b	#$CE,d7

loc_74938:
		bchg	#0,$2B(a6)

loc_7493E:
		cmpi.b	#$A7,d7
		bne.s	loc_74952
		tst.b	$2C(a6)
		bne.w	locret_74A0A
		move.b	#$80,$2C(a6)

loc_74952:
		movea.l	(mSFXPtr).l,a0
		subi.b	#$A0,d7
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,$1C(a6)
		move.b	(a1)+,d5
		move.b	(a1)+,d7
		subq.b	#1,d7
		moveq	#$30,d6

loc_74976:
		moveq	#0,d3
		move.b	1(a1),d3
		move.b	d3,d4
		bmi.s	loc_74992
		subq.w	#2,d3
		lsl.w	#2,d3
		lea	off_74A0C(pc),a5
		movea.l	(a5,d3.w),a5
		bset	#2,(a5)
		bra.s	loc_749B8
; ---------------------------------------------------------------------------

loc_74992:
		lsr.w	#3,d3
		movea.l	off_74A0C(pc,d3.w),a5
		bset	#2,(a5)
		cmpi.b	#$C0,d4
		bne.s	loc_749B8
		move.b	d4,d0
		ori.b	#$1F,d0
		move.b	d0,($C00011).l
		bchg	#5,d0
		move.b	d0,($C00011).l

loc_749B8:
		movea.l	off_74A2C(pc,d3.w),a5
		movea.l	a5,a2
		moveq	#$B,d0

loc_749C0:
		clr.l	(a2)+
		dbf	d0,loc_749C0
		move.w	(a1)+,(a5)
		move.b	d5,2(a5)
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,4(a5)
		move.w	(a1)+,8(a5)
		move.b	#1,$E(a5)
		move.b	d6,$D(a5)
		tst.b	d4
		bmi.s	loc_749EE
		move.b	#$C0,$A(a5)

loc_749EE:
		dbf	d7,loc_74976
		tst.b	$250(a6)
		bpl.s	loc_749FE
		bset	#2,$340(a6)

loc_749FE:
		tst.b	$310(a6)
		bpl.s	locret_74A0A
		bset	#2,$370(a6)

locret_74A0A:
		rts
; ---------------------------------------------------------------------------

off_74A0C:	dc.l (SoundMemory+$D0)&$FFFFFF, 0, (SoundMemory+$100)&$FFFFFF
		dc.l (SoundMemory+$130)&$FFFFFF, (SoundMemory+$190)&$FFFFFF, (SoundMemory+$1C0)&$FFFFFF
		dc.l (SoundMemory+$1F0)&$FFFFFF, (SoundMemory+$1F0)&$FFFFFF

off_74A2C:	dc.l (SoundMemory+$220)&$FFFFFF, 0, (SoundMemory+$250)&$FFFFFF
		dc.l (SoundMemory+$280)&$FFFFFF, (SoundMemory+$2B0)&$FFFFFF, (SoundMemory+$2E0)&$FFFFFF
		dc.l (SoundMemory+$310)&$FFFFFF, (SoundMemory+$310)&$FFFFFF
; ---------------------------------------------------------------------------

loc_74A4C:
		tst.b	$27(a6)
		bne.w	locret_74AF6
		movea.l	(mSpecialSFXPtr).l,a0
		subi.b	#$D0,d7
		lsl.w	#2,d7
		movea.l	(a0,d7.w),a3
		movea.l	a3,a1
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,$20(a6)
		move.b	(a1)+,d5
		move.b	(a1)+,d7
		subq.b	#1,d7
		moveq	#$30,d6

loc_74A78:
		move.b	1(a1),d4
		bmi.s	loc_74A8A
		bset	#2,$100(a6)
		lea	$340(a6),a5
		bra.s	loc_74A94
; ---------------------------------------------------------------------------

loc_74A8A:
		bset	#2,$1F0(a6)
		lea	$370(a6),a5

loc_74A94:
		movea.l	a5,a2
		moveq	#$B,d0

loc_74A98:
		clr.l	(a2)+
		dbf	d0,loc_74A98
		move.w	(a1)+,(a5)
		move.b	d5,2(a5)
		moveq	#0,d0
		move.w	(a1)+,d0
		add.l	a3,d0
		move.l	d0,4(a5)
		move.w	(a1)+,8(a5)
		move.b	#1,$E(a5)
		move.b	d6,$D(a5)
		tst.b	d4
		bmi.s	loc_74AC6
		move.b	#$C0,$A(a5)

loc_74AC6:
		dbf	d7,loc_74A78
		tst.b	$250(a6)
		bpl.s	loc_74AD6
		bset	#2,$340(a6)

loc_74AD6:
		tst.b	$310(a6)
		bpl.s	locret_74AF6
		bset	#2,$370(a6)
		ori.b	#$1F,d4
		move.b	d4,($C00011).l
		bchg	#5,d4
		move.b	d4,($C00011).l

locret_74AF6:
		rts
; ---------------------------------------------------------------------------
		dc.l (SoundMemory+$100)&$FFFFFF, (SoundMemory+$1F0)&$FFFFFF, (SoundMemory+$250)&$FFFFFF
		dc.l (SoundMemory+$310)&$FFFFFF, (SoundMemory+$340)&$FFFFFF, (SoundMemory+$370)&$FFFFFF
; ---------------------------------------------------------------------------

sub_74B10:
		clr.b	0(a6)
		moveq	#$27,d0
		moveq	#0,d1
		jsr	sub_74E5C(pc)
		lea	$220(a6),a5
		moveq	#5,d7

loc_74B22:
		tst.b	(a5)
		bpl.w	loc_74BAA
		bclr	#7,(a5)
		moveq	#0,d3
		move.b	1(a5),d3
		bmi.s	loc_74B74
		jsr	sub_74E2C(pc)
		cmpi.b	#4,d3
		bne.s	loc_74B4E
		tst.b	$340(a6)
		bpl.s	loc_74B4E
		lea	$340(a6),a5
		movea.l	$20(a6),a1
		bra.s	loc_74B60
; ---------------------------------------------------------------------------

loc_74B4E:
		subq.b	#2,d3
		lsl.b	#2,d3
		lea	off_74A0C(pc),a0
		movea.l	a5,a3
		movea.l	(a0,d3.w),a5
		movea.l	$18(a6),a1

loc_74B60:
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	sub_753F8(pc)
		movea.l	a3,a5
		bra.s	loc_74BAA
; ---------------------------------------------------------------------------

loc_74B74:
		jsr	sub_750CA(pc)
		lea	$370(a6),a0
		cmpi.b	#$E0,d3
		beq.s	loc_74B92
		cmpi.b	#$C0,d3
		beq.s	loc_74B92
		lsr.b	#3,d3
		lea	off_74A0C(pc),a0
		movea.l	(a0,d3.w),a0

loc_74B92:
		bclr	#2,(a0)
		bset	#1,(a0)
		cmpi.b	#$E0,1(a0)
		bne.s	loc_74BAA
		move.b	$26(a0),($C00011).l

loc_74BAA:
		adda.w	#$30,a5
		dbf	d7,loc_74B22
		rts
; ---------------------------------------------------------------------------

sub_74BB4:
		lea	$340(a6),a5
		tst.b	(a5)
		bpl.s	loc_74BE6
		bclr	#7,(a5)
		btst	#2,(a5)
		bne.s	loc_74BE6
		jsr	loc_74E38(pc)
		lea	$100(a6),a5
		bclr	#2,(a5)
		bset	#1,(a5)
		tst.b	(a5)
		bpl.s	loc_74BE6
		movea.l	$18(a6),a1
		move.b	$B(a5),d0
		jsr	sub_753F8(pc)

loc_74BE6:
		lea	$370(a6),a5
		tst.b	(a5)
		bpl.s	locret_74C1C
		bclr	#7,(a5)
		btst	#2,(a5)
		bne.s	locret_74C1C
		jsr	loc_750D0(pc)
		lea	$1F0(a6),a5
		bclr	#2,(a5)
		bset	#1,(a5)
		tst.b	(a5)
		bpl.s	locret_74C1C
		cmpi.b	#$E0,1(a5)
		bne.s	locret_74C1C
		move.b	$26(a5),($C00011).l

locret_74C1C:
		rts
; ---------------------------------------------------------------------------

loc_74C1E:
		jsr	sub_74B10(pc)
		jsr	sub_74BB4(pc)
		move.b	#3,6(a6)
		move.b	#$28,4(a6)
		clr.b	$40(a6)
		clr.b	$2A(a6)
		rts
; ---------------------------------------------------------------------------

sub_74C3C:
		move.b	6(a6),d0
		beq.s	loc_74C48
		subq.b	#1,6(a6)
		rts
; ---------------------------------------------------------------------------

loc_74C48:
		subq.b	#1,4(a6)
		beq.w	loc_74CFE
		move.b	#3,6(a6)
		lea	$70(a6),a5
		moveq	#5,d7

loc_74C5C:
		tst.b	(a5)
		bpl.s	loc_74C70
		addq.b	#1,9(a5)
		bpl.s	loc_74C6C
		bclr	#7,(a5)
		bra.s	loc_74C70
; ---------------------------------------------------------------------------

loc_74C6C:
		jsr	sub_7545E(pc)

loc_74C70:
		adda.w	#$30,a5
		dbf	d7,loc_74C5C
		moveq	#2,d7

loc_74C7A:
		tst.b	(a5)
		bpl.s	loc_74C98
		addq.b	#1,9(a5)
		cmpi.b	#$10,9(a5)
		bcs.s	loc_74C90
		bclr	#7,(a5)
		bra.s	loc_74C98
; ---------------------------------------------------------------------------

loc_74C90:
		move.b	9(a5),d6
		jsr	sub_75082(pc)

loc_74C98:
		adda.w	#$30,a5
		dbf	d7,loc_74C7A
		rts
; ---------------------------------------------------------------------------

sub_74CA2:
		moveq	#3,d4
		moveq	#$40,d3
		moveq	#$7F,d1

loc_74CA8:
		move.b	d3,d0
		jsr	sub_74E50(pc)
		addq.b	#4,d3
		dbf	d4,loc_74CA8
		moveq	#3,d4
		move.b	#$80,d3
		moveq	#$F,d1

loc_74CBC:
		move.b	d3,d0
		jsr	sub_74E50(pc)
		addq.b	#4,d3
		dbf	d4,loc_74CBC
		rts
; ---------------------------------------------------------------------------

sub_74CCA:
		moveq	#2,d2
		moveq	#$28,d0

loc_74CCE:
		move.b	d2,d1
		jsr	sub_74E5C(pc)
		addq.b	#4,d1
		jsr	sub_74E5C(pc)
		dbf	d2,loc_74CCE
		moveq	#$40,d0
		moveq	#$7F,d1
		moveq	#2,d3

loc_74CE4:
		moveq	#3,d2

loc_74CE6:
		jsr	sub_74E5C(pc)
		jsr	sub_74E80(pc)
		addq.w	#4,d0
		dbf	d2,loc_74CE6
		subi.b	#$F,d0
		dbf	d3,loc_74CE4
		rts
; ---------------------------------------------------------------------------

loc_74CFE:
		moveq	#$2B,d0
		move.b	#$80,d1
		jsr	sub_74E5C(pc)
		moveq	#$27,d0
		moveq	#0,d1
		jsr	sub_74E5C(pc)
		movea.l	a6,a0
		move.w	#$E3,d0

loc_74D16:
		clr.l	(a0)+
		dbf	d0,loc_74D16
		move.b	#$80,9(a6)
		jsr	sub_74CCA(pc)
		bra.w	sub_750E0
; ---------------------------------------------------------------------------

sub_74D2A:
		movea.l	a6,a0
		move.b	0(a6),d1
		move.b	$27(a6),d2
		move.b	$2A(a6),d3
		move.b	$26(a6),d4
		move.w	#$87,d0

loc_74D40:
		clr.l	(a0)+
		dbf	d0,loc_74D40
		move.b	d1,0(a6)
		move.b	d2,$27(a6)
		move.b	d3,$2A(a6)
		move.b	d4,$26(a6)
		move.b	#$80,9(a6)
		bra.w	sub_750E0
; ---------------------------------------------------------------------------

sub_74D60:
		move.b	2(a6),1(a6)
		addq.b	#1,$4E(a6)
		addq.b	#1,$7E(a6)
		addq.b	#1,$AE(a6)
		addq.b	#1,$DE(a6)
		addq.b	#1,$10E(a6)
		addq.b	#1,$13E(a6)
		addq.b	#1,$16E(a6)
		addq.b	#1,$19E(a6)
		addq.b	#1,$1CE(a6)
		addq.b	#1,$1FE(a6)
		rts
; ---------------------------------------------------------------------------

loc_74D90:
		move.b	$29(a6),2(a6)
		move.b	$29(a6),1(a6)
		move.b	#$80,$2A(a6)
		rts
; ---------------------------------------------------------------------------

loc_74DA4:
		move.b	$28(a6),2(a6)
		move.b	$28(a6),1(a6)
		clr.b	$2A(a6)
		rts
; ---------------------------------------------------------------------------

sub_74DB6:
		tst.b	$25(a6)
		beq.s	loc_74DC2
		subq.b	#1,$25(a6)
		rts
; ---------------------------------------------------------------------------

loc_74DC2:
		tst.b	$26(a6)
		beq.s	loc_74E04
		subq.b	#1,$26(a6)
		move.b	#2,$25(a6)
		lea	$70(a6),a5
		moveq	#5,d7

loc_74DD8:
		tst.b	(a5)
		bpl.s	loc_74DE4
		subq.b	#1,9(a5)
		jsr	sub_7545E(pc)

loc_74DE4:
		adda.w	#$30,a5
		dbf	d7,loc_74DD8
		moveq	#2,d7

loc_74DEE:
		tst.b	(a5)
		bpl.s	loc_74DFA
		subq.b	#1,9(a5)
		jsr	sub_75082(pc)

loc_74DFA:
		adda.w	#$30,a5
		dbf	d7,loc_74DEE
		rts
; ---------------------------------------------------------------------------

loc_74E04:
		bclr	#2,$40(a6)
		clr.b	$24(a6)
		rts
; ---------------------------------------------------------------------------

loc_74E10:
		btst	#1,(a5)
		bne.s	locret_74E2A
		btst	#2,(a5)
		bne.s	locret_74E2A
		moveq	#$28,d0
		move.b	1(a5),d1
		ori.b	#$F0,d1
		bra.w	sub_74E5C
; ---------------------------------------------------------------------------

locret_74E2A:
		rts
; ---------------------------------------------------------------------------

sub_74E2C:
		btst	#4,(a5)
		bne.s	locret_74E42
		btst	#2,(a5)
		bne.s	locret_74E42

loc_74E38:
		moveq	#$28,d0
		move.b	1(a5),d1
		bra.w	sub_74E5C
; ---------------------------------------------------------------------------

locret_74E42:
		rts
; ---------------------------------------------------------------------------

sub_74E44:
		btst	#2,(a5)
		bne.s	locret_74E4E
		bra.w	sub_74E50
; ---------------------------------------------------------------------------

locret_74E4E:
		rts
; ---------------------------------------------------------------------------

sub_74E50:
		btst	#2,1(a5)
		bne.s	loc_74E76
		add.b	1(a5),d0
; ---------------------------------------------------------------------------

sub_74E5C:
		lea	($A04000).l,a0

loc_74E62:
		btst	#7,(a0)
		bne.s	loc_74E62
		move.b	d0,(a0)

loc_74E6A:
		btst	#7,(a0)
		bne.s	loc_74E6A
		move.b	d1,1(a0)
		rts
; ---------------------------------------------------------------------------

loc_74E76:
		move.b	1(a5),d2
		bclr	#2,d2
		add.b	d2,d0
; ---------------------------------------------------------------------------

sub_74E80:
		lea	($A04000).l,a0

loc_74E86:
		btst	#7,(a0)
		bne.s	loc_74E86
		move.b	d0,2(a0)

loc_74E90:
		btst	#7,(a0)
		bne.s	loc_74E90
		move.b	d1,3(a0)
		rts
; ---------------------------------------------------------------------------

word_74E9C:	dc.w $25E, $284, $2AB, $2D3, $2FE, $32D, $35C, $38F, $3C5
		dc.w $3FF, $43C, $47C, $A5E, $A84, $AAB, $AD3, $AFE, $B2D
		dc.w $B5C, $B8F, $BC5, $BFF, $C3C, $C7C,$125E,$1284,$12AB
		dc.w $12D3,$12FE,$132D,$135C,$138F,$13C5,$13FF,$143C,$147C
		dc.w $1A5E,$1A84,$1AAB,$1AD3,$1AFE,$1B2D,$1B5C,$1B8F,$1BC5
		dc.w $1BFF,$1C3C,$1C7C,$225E,$2284,$22AB,$22D3,$22FE,$232D
		dc.w $235C,$238F,$23C5,$23FF,$243C,$247C,$2A5E,$2A84,$2AAB
		dc.w $2AD3,$2AFE,$2B2D,$2B5C,$2B8F,$2BC5,$2BFF,$2C3C,$2C7C
		dc.w $325E,$3284,$32AB,$32D3,$32FE,$332D,$335C,$338F,$33C5
		dc.w $33FF,$343C,$347C,$3A5E,$3A84,$3AAB,$3AD3,$3AFE,$3B2D
		dc.w $3B5C,$3B8F,$3BC5,$3BFF,$3C3C,$3C7C
; ---------------------------------------------------------------------------

sub_74F5C:
		subq.b	#1,$E(a5)
		bne.s	loc_74F72
		bclr	#4,(a5)
		jsr	sub_74F84(pc)
		jsr	sub_74FE8(pc)
		bra.w	loc_7503A
; ---------------------------------------------------------------------------

loc_74F72:
		jsr	sub_74428(pc)
		jsr	sub_75032(pc)
		jsr	sub_74450(pc)
		jsr	sub_74FEE(pc)
		rts
; ---------------------------------------------------------------------------

sub_74F84:
		bclr	#1,(a5)
		movea.l	4(a5),a4

loc_74F8C:
		moveq	#0,d5
		move.b	(a4)+,d5
		cmpi.b	#$E0,d5
		bcs.s	loc_74F9C
		jsr	sub_75184(pc)
		bra.s	loc_74F8C
; ---------------------------------------------------------------------------

loc_74F9C:
		tst.b	d5
		bpl.s	loc_74FB0
		jsr	sub_74FB8(pc)
		move.b	(a4)+,d5
		tst.b	d5
		bpl.s	loc_74FB0
		subq.w	#1,a4
		bra.w	sub_743EA
; ---------------------------------------------------------------------------

loc_74FB0:
		jsr	sub_743CA(pc)
		bra.w	sub_743EA
; ---------------------------------------------------------------------------

sub_74FB8:
		subi.b	#$81,d5
		bcs.s	loc_74FD6
		add.b	8(a5),d5
		andi.w	#$7F,d5
		lsl.w	#1,d5
		lea	word_750F8(pc),a0
		move.w	(a0,d5.w),$10(a5)
		bra.w	sub_743EA
; ---------------------------------------------------------------------------

loc_74FD6:
		bset	#1,(a5)
		move.w	#$FFFF,$10(a5)
		jsr	sub_743EA(pc)
		bra.w	sub_750CA
; ---------------------------------------------------------------------------

sub_74FE8:
		move.w	$10(a5),d6
		bmi.s	loc_7502C
; ---------------------------------------------------------------------------

sub_74FEE:
		move.b	$1E(a5),d0
		ext.w	d0
		add.w	d0,d6
		btst	#2,(a5)
		bne.s	locret_7502A
		btst	#1,(a5)
		bne.s	locret_7502A
		move.b	1(a5),d0
		cmpi.b	#$E0,d0
		bne.s	loc_75010
		move.b	#$C0,d0

loc_75010:
		move.w	d6,d1
		andi.b	#$F,d1
		or.b	d1,d0
		lsr.w	#4,d6
		andi.b	#$3F,d6
		move.b	d0,($C00011).l
		move.b	d6,($C00011).l

locret_7502A:
		rts
; ---------------------------------------------------------------------------

loc_7502C:
		bset	#1,(a5)
		rts
; ---------------------------------------------------------------------------

sub_75032:
		tst.b	$B(a5)
		beq.w	locret_750A2

loc_7503A:
		move.b	9(a5),d6
		moveq	#0,d0
		move.b	$B(a5),d0
		beq.s	sub_75082
		movea.l	(mVolEnvPtr).l,a0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a0,d0.w),a0
		move.b	$C(a5),d0
		move.b	(a0,d0.w),d0
		addq.b	#1,$C(a5)
		btst	#7,d0
		beq.s	loc_75078
		cmpi.b	#$83,d0
		beq.s	loc_750B2
		cmpi.b	#$85,d0
		beq.s	loc_750B8
		cmpi.b	#$80,d0
		beq.s	loc_750C2

loc_75078:
		add.w	d0,d6
		cmpi.b	#$10,d6
		bcs.s	sub_75082
		moveq	#$F,d6
; ---------------------------------------------------------------------------

sub_75082:
		btst	#1,(a5)
		bne.s	locret_750A2
		btst	#2,(a5)
		bne.s	locret_750A2
		btst	#4,(a5)
		bne.s	loc_750A4

loc_75094:
		or.b	1(a5),d6
		addi.b	#$10,d6
		move.b	d6,($C00011).l

locret_750A2:
		rts
; ---------------------------------------------------------------------------

loc_750A4:
		tst.b	$13(a5)
		beq.s	loc_75094
		tst.b	$12(a5)
		bne.s	loc_75094
		rts
; ---------------------------------------------------------------------------

loc_750B2:
		subq.b	#1,$C(a5)
		rts
; ---------------------------------------------------------------------------

loc_750B8:
		move.b	1(a0,d0.w),$C(a5)
		bra.w	loc_7503A
; ---------------------------------------------------------------------------

loc_750C2:
		clr.b	$C(a5)
		bra.w	loc_7503A
; ---------------------------------------------------------------------------

sub_750CA:
		btst	#2,(a5)
		bne.s	locret_750DE

loc_750D0:
		move.b	1(a5),d0
		ori.b	#$1F,d0
		move.b	d0,($C00011).l

locret_750DE:
		rts
; ---------------------------------------------------------------------------

sub_750E0:
		lea	($C00011).l,a0
		move.b	#$9F,(a0)
		move.b	#$BF,(a0)
		move.b	#$DF,(a0)
		move.b	#$FF,(a0)
		rts
; ---------------------------------------------------------------------------

word_750F8:	dc.w $356,$326,$2F9,$2CE,$2A5,$280,$25C,$23A,$21A,$1FB
		dc.w $1DF,$1C4,$1AB,$193,$17D,$167,$153,$140,$12E,$11D
		dc.w $10D, $FE, $EF, $E2, $D6, $C9, $BE, $B4, $A9, $A0
		dc.w $97, $8F, $87, $7F, $78, $71, $6B, $65, $5F, $5A
		dc.w $55, $50, $4B, $47, $43, $40, $3C, $39, $36, $33
		dc.w $30, $2D, $2B, $28, $26, $24, $22, $20, $1F, $1D
		dc.w $1B, $1A, $18, $17, $16, $15, $13, $12, $11,   0
; ---------------------------------------------------------------------------

sub_75184:
		subi.w	#$E0,d5
		lsl.w	#2,d5
		jmp	loc_7518E(pc,d5.w)
; ---------------------------------------------------------------------------

loc_7518E:
		bra.w	loc_7521C
; ---------------------------------------------------------------------------
		bra.w	loc_7523C
; ---------------------------------------------------------------------------
		bra.w	loc_75242
; ---------------------------------------------------------------------------
		bra.w	loc_75248
; ---------------------------------------------------------------------------
		bra.w	loc_7527A
; ---------------------------------------------------------------------------
		bra.w	loc_7532C
; ---------------------------------------------------------------------------
		bra.w	loc_7533C
; ---------------------------------------------------------------------------
		bra.w	loc_75346
; ---------------------------------------------------------------------------
		bra.w	loc_7534C
; ---------------------------------------------------------------------------
		bra.w	loc_75356
; ---------------------------------------------------------------------------
		bra.w	loc_753A8
; ---------------------------------------------------------------------------
		bra.w	loc_753B2
; ---------------------------------------------------------------------------
		bra.w	loc_753B8
; ---------------------------------------------------------------------------
		bra.w	loc_753C0
; ---------------------------------------------------------------------------
		bra.w	loc_753C8
; ---------------------------------------------------------------------------
		bra.w	loc_753D0
; ---------------------------------------------------------------------------
		bra.w	loc_754DA
; ---------------------------------------------------------------------------
		bra.w	loc_754FC
; ---------------------------------------------------------------------------
		bra.w	loc_75502
; ---------------------------------------------------------------------------
		bra.w	loc_755C4
; ---------------------------------------------------------------------------
		bra.w	loc_755DE
; ---------------------------------------------------------------------------
		bra.w	loc_755E4
; ---------------------------------------------------------------------------
		bra.w	loc_755EA
; ---------------------------------------------------------------------------
		bra.w	loc_755F6
; ---------------------------------------------------------------------------
		bra.w	loc_75610
; ---------------------------------------------------------------------------
		bra.w	loc_75622
; ---------------------------------------------------------------------------
		bra.w	loc_75636
; ---------------------------------------------------------------------------
		bra.w	loc_7563C
; ---------------------------------------------------------------------------
		bra.w	loc_75644
; ---------------------------------------------------------------------------
		bra.w	loc_7565A
; ---------------------------------------------------------------------------
		bra.w	loc_7568C
; ---------------------------------------------------------------------------
		moveq	#0,d0
		move.b	(a4)+,d0
		lsl.w	#2,d0
		jmp	loc_75214(pc,d0.w)
; ---------------------------------------------------------------------------

loc_75214:
		bra.w	loc_756A8
; ---------------------------------------------------------------------------
		bra.w	loc_756A8
; ---------------------------------------------------------------------------

loc_7521C:
		move.b	(a4)+,d1
		tst.b	1(a5)
		bmi.s	locret_7523A
		move.b	$A(a5),d0
		andi.b	#$37,d0
		or.b	d0,d1
		move.b	d1,$A(a5)
		move.b	#$B4,d0
		bra.w	sub_74E44
; ---------------------------------------------------------------------------

locret_7523A:
		rts
; ---------------------------------------------------------------------------

loc_7523C:
		move.b	(a4)+,$1E(a5)
		rts
; ---------------------------------------------------------------------------

loc_75242:
		move.b	(a4)+,7(a6)
		rts
; ---------------------------------------------------------------------------

loc_75248:
		movea.l	(off_74010).l,a0
		moveq	#0,d0
		move.b	(a4)+,d0
		subq.b	#1,d0
		lsl.w	#2,d0
		adda.w	d0,a0
		bset	#3,(a5)
		move.l	a0,$14(a5)
		move.b	(a0)+,$18(a5)
		move.b	(a0)+,$19(a5)
		move.b	(a0)+,$1A(a5)
		move.b	(a0)+,d0
		lsr.b	#1,d0
		move.b	d0,$1B(a5)
		clr.w	$1C(a5)
		rts
; ---------------------------------------------------------------------------

loc_7527A:
		movea.l	a6,a0
		lea	$3A0(a6),a1
		move.w	#$87,d0

loc_75284:
		move.l	(a1)+,(a0)+
		dbf	d0,loc_75284
		bset	#2,$40(a6)
		movea.l	a5,a3
		move.b	#$28,d6
		sub.b	$26(a6),d6
		moveq	#5,d7
		lea	$70(a6),a5

loc_752A0:
		btst	#7,(a5)
		beq.s	loc_752C2
		bset	#1,(a5)
		add.b	d6,9(a5)
		btst	#2,(a5)
		bne.s	loc_752C2
		moveq	#0,d0
		move.b	$B(a5),d0
		movea.l	$18(a6),a1
		jsr	sub_753F8(pc)

loc_752C2:
		adda.w	#$30,a5
		dbf	d7,loc_752A0
		moveq	#2,d7

loc_752CC:
		btst	#7,(a5)
		beq.s	loc_752DE
		bset	#1,(a5)
		jsr	sub_750CA(pc)
		add.b	d6,9(a5)

loc_752DE:
		adda.w	#$30,a5
		dbf	d7,loc_752CC
		movea.l	a3,a5
		move.b	#$80,$24(a6)
		move.b	#$28,$26(a6)
		clr.b	$27(a6)
		addq.w	#8,sp
		rts
; ---------------------------------------------------------------------------
		jsr	sub_74CA2(pc)
		bra.w	loc_75502
; ---------------------------------------------------------------------------
		move.b	(a4)+,$1F(a5)
		beq.s	loc_75320
		move.b	(a4)+,$20(a5)
		move.b	(a4)+,$21(a5)
		move.b	(a4)+,$22(a5)
		move.b	(a4),$23(a5)
		move.b	(a4)+,$24(a5)
		rts
; ---------------------------------------------------------------------------

loc_75320:
		move.b	#$B4,d0
		move.b	$A(a5),d1
		bra.w	sub_74E44
; ---------------------------------------------------------------------------

loc_7532C:
		move.b	(a4)+,d0
		tst.b	1(a5)
		bpl.s	loc_7533C
		add.b	d0,9(a5)
		addq.w	#1,a4
		rts
; ---------------------------------------------------------------------------

loc_7533C:
		move.b	(a4)+,d0
		add.b	d0,9(a5)
		bra.w	sub_7545E
; ---------------------------------------------------------------------------

loc_75346:
		bset	#4,(a5)
		rts
; ---------------------------------------------------------------------------

loc_7534C:
		move.b	(a4),$12(a5)
		move.b	(a4)+,$13(a5)
		rts
; ---------------------------------------------------------------------------

loc_75356:
		movea.l	$18(a6),a1
		beq.s	loc_75360
		movea.l	$1C(a6),a1

loc_75360:
		move.b	(a4),d3
		adda.w	#9,a0
		lea	byte_753A4(pc),a2
		moveq	#3,d6

loc_7536C:
		move.b	(a1)+,d1
		move.b	(a2)+,d0
		btst	#7,d3
		beq.s	loc_7537E
		bset	#7,d1
		jsr	sub_74E44(pc)

loc_7537E:
		lsl.w	#1,d3
		dbf	d6,loc_7536C
		move.b	(a4)+,d1
		moveq	#$22,d0
		jsr	sub_74E5C(pc)
		move.b	(a4)+,d1
		move.b	$A(a5),d0
		andi.b	#$C0,d0
		or.b	d0,d1
		move.b	d1,$A(a5)
		move.b	#$B4,d0
		bra.w	sub_74E44
; ---------------------------------------------------------------------------

byte_753A4:	dc.b $60, $68, $64, $6C
; ---------------------------------------------------------------------------

loc_753A8:
		move.b	(a4),2(a6)
		move.b	(a4)+,1(a6)
		rts
; ---------------------------------------------------------------------------

loc_753B2:
		move.b	(a4)+,$A(a6)
		rts
; ---------------------------------------------------------------------------

loc_753B8:
		move.b	(a4)+,d0
		add.b	d0,9(a5)
		rts
; ---------------------------------------------------------------------------

loc_753C0:
		move.b	#0,$2C(a6)
		rts
; ---------------------------------------------------------------------------

loc_753C8:
		move.b	(a4)+,d0
		move.b	(a4)+,d1
		bra.w	sub_74E5C
; ---------------------------------------------------------------------------

loc_753D0:
		moveq	#0,d0
		move.b	(a4)+,d0
		move.b	d0,$B(a5)
		btst	#2,(a5)
		bne.w	locret_75454
		movea.l	$18(a6),a1
		tst.b	$E(a6)
		beq.s	sub_753F8
		movea.l	$1C(a6),a1
		tst.b	$E(a6)
		bmi.s	sub_753F8
		movea.l	$20(a6),a1
; ---------------------------------------------------------------------------

sub_753F8:
		subq.w	#1,d0
		bmi.s	loc_75406
		move.w	#$19,d1

loc_75400:
		adda.w	d1,a1
		dbf	d0,loc_75400

loc_75406:
		move.b	(a1)+,d1
		move.b	d1,$25(a5)
		move.b	d1,d4
		move.b	#$B0,d0
		jsr	sub_74E50(pc)
		lea	sub_754C2(pc),a2
		moveq	#$13,d3

loc_7541C:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		jsr	sub_74E50(pc)
		dbf	d3,loc_7541C
		moveq	#3,d5
		andi.w	#7,d4
		move.b	byte_75456(pc,d4.w),d4
		move.b	9(a5),d3

loc_75436:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4
		bcc.s	loc_75440
		add.b	d3,d1

loc_75440:
		jsr	sub_74E50(pc)
		dbf	d5,loc_75436
		move.b	#$B4,d0
		move.b	$A(a5),d1
		jsr	sub_74E50(pc)

locret_75454:
		rts
; ---------------------------------------------------------------------------

byte_75456:	dc.b 8, 8, 8, 8, $A, $E, $E, $F
; ---------------------------------------------------------------------------

sub_7545E:
		btst	#2,(a5)
		bne.s	locret_754C0
		moveq	#0,d0
		move.b	$B(a5),d0
		movea.l	$18(a6),a1
		tst.b	$E(a6)
		beq.s	loc_75482
		movea.l	$1C(a6),a1
		tst.b	$E(a6)
		bmi.s	loc_75482
		movea.l	$20(a6),a1

loc_75482:
		subq.w	#1,d0
		bmi.s	loc_75490
		move.w	#$19,d1

loc_7548A:
		adda.w	d1,a1
		dbf	d0,loc_7548A

loc_75490:
		adda.w	#$15,a1
		lea	byte_754D6(pc),a2
		move.b	$25(a5),d0
		andi.w	#7,d0
		move.b	byte_75456(pc,d0.w),d4
		move.b	9(a5),d3
		bmi.s	locret_754C0
		moveq	#3,d5

loc_754AC:
		move.b	(a2)+,d0
		move.b	(a1)+,d1
		lsr.b	#1,d4
		bcc.s	loc_754BC
		add.b	d3,d1
		bcs.s	loc_754BC
		jsr	sub_74E50(pc)

loc_754BC:
		dbf	d5,loc_754AC

locret_754C0:
		rts
; ---------------------------------------------------------------------------

sub_754C2:
		move.w	(oscUpdateTable+$2E).w,d0
		addq.w	#8,(a0)+
		addq.w	#2,(a4)+
		bra.s	loc_75534
; ---------------------------------------------------------------------------
		bcc.s	loc_7553A
; ---------------------------------------------------------------------------
		dc.b $70, $78, $74, $7C
		dc.b $80, $88, $84, $8C

byte_754D6:	dc.b $40, $48, $44, $4C
; ---------------------------------------------------------------------------

loc_754DA:
		bset	#3,(a5)
		move.l	a4,$14(a5)
		move.b	(a4)+,$18(a5)
		move.b	(a4)+,$19(a5)
		move.b	(a4)+,$1A(a5)
		move.b	(a4)+,d0
		lsr.b	#1,d0
		move.b	d0,$1B(a5)
		clr.w	$1C(a5)
		rts
; ---------------------------------------------------------------------------

loc_754FC:
		bset	#3,(a5)
		rts
; ---------------------------------------------------------------------------

loc_75502:
		bclr	#7,(a5)
		bclr	#4,(a5)
		tst.b	1(a5)
		bmi.s	loc_7551E
		tst.b	8(a6)
		bmi.w	loc_755C0
		jsr	sub_74E2C(pc)
		bra.s	loc_75522
; ---------------------------------------------------------------------------

loc_7551E:
		jsr	sub_750CA(pc)

loc_75522:
		tst.b	$E(a6)
		bpl.w	loc_755C0
		clr.b	0(a6)
		moveq	#0,d0
		move.b	1(a5),d0

loc_75534:
		bmi.s	loc_7558A
		lea	off_74A0C(pc),a0

loc_7553A:
		movea.l	a5,a3
		cmpi.b	#4,d0
		bne.s	loc_75552
		tst.b	$340(a6)
		bpl.s	loc_75552
		lea	$340(a6),a5
		movea.l	$20(a6),a1
		bra.s	loc_75562
; ---------------------------------------------------------------------------

loc_75552:
		subq.b	#2,d0
		lsl.b	#2,d0
		movea.l	(a0,d0.w),a5
		tst.b	(a5)
		bpl.s	loc_75572
		movea.l	$18(a6),a1

loc_75562:
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	sub_753F8(pc)

loc_75572:
		movea.l	a3,a5
		cmpi.b	#2,1(a5)
		bne.s	loc_755C0
		clr.b	$F(a6)
		moveq	#0,d1
		moveq	#$27,d0
		jsr	sub_74E5C(pc)
		bra.s	loc_755C0
; ---------------------------------------------------------------------------

loc_7558A:
		lea	$370(a6),a0
		tst.b	(a0)
		bpl.s	loc_7559E
		cmpi.b	#$E0,d0
		beq.s	loc_755A8
		cmpi.b	#$C0,d0
		beq.s	loc_755A8

loc_7559E:
		lea	off_74A0C(pc),a0
		lsr.b	#3,d0
		movea.l	(a0,d0.w),a0

loc_755A8:
		bclr	#2,(a0)
		bset	#1,(a0)
		cmpi.b	#$E0,1(a0)
		bne.s	loc_755C0
		move.b	$26(a0),($C00011).l

loc_755C0:
		addq.w	#8,sp
		rts
; ---------------------------------------------------------------------------

loc_755C4:
		move.b	#$E0,1(a5)
		move.b	(a4)+,$26(a5)
		btst	#2,(a5)
		bne.s	locret_755DC
		move.b	-1(a4),($C00011).l

locret_755DC:
		rts
; ---------------------------------------------------------------------------

loc_755DE:
		bclr	#3,(a5)
		rts
; ---------------------------------------------------------------------------

loc_755E4:
		move.b	(a4)+,$B(a5)
		rts
; ---------------------------------------------------------------------------

loc_755EA:
		move.b	(a4)+,d0
		lsl.w	#8,d0
		move.b	(a4)+,d0
		adda.w	d0,a4
		subq.w	#1,a4
		rts
; ---------------------------------------------------------------------------

loc_755F6:
		moveq	#0,d0
		move.b	(a4)+,d0
		move.b	(a4)+,d1
		tst.b	$28(a5,d0.w)
		bne.s	loc_75606
		move.b	d1,$28(a5,d0.w)

loc_75606:
		subq.b	#1,$28(a5,d0.w)
		bne.s	loc_755EA
		addq.w	#2,a4
		rts
; ---------------------------------------------------------------------------

loc_75610:
		moveq	#0,d0
		move.b	$D(a5),d0
		subq.b	#4,d0
		move.l	a4,(a5,d0.w)
		move.b	d0,$D(a5)
		bra.s	loc_755EA
; ---------------------------------------------------------------------------

loc_75622:
		moveq	#0,d0
		move.b	$D(a5),d0
		movea.l	(a5,d0.w),a4
		addq.w	#2,a4
		addq.b	#4,d0
		move.b	d0,$D(a5)
		rts
; ---------------------------------------------------------------------------

loc_75636:
		move.b	(a4)+,2(a5)
		rts
; ---------------------------------------------------------------------------

loc_7563C:
		move.b	(a4)+,d0
		add.b	d0,8(a5)
		rts
; ---------------------------------------------------------------------------

loc_75644:
		lea	$40(a6),a0
		move.b	(a4)+,d0
		moveq	#$30,d1
		moveq	#9,d2

loc_7564E:
		move.b	d0,2(a0)
		adda.w	d1,a0
		dbf	d2,loc_7564E
		rts
; ---------------------------------------------------------------------------

loc_7565A:
		bclr	#7,(a5)
		bclr	#4,(a5)
		jsr	sub_74E2C(pc)
		tst.b	$250(a6)
		bmi.s	loc_75688
		movea.l	a5,a3
		lea	$100(a6),a5
		movea.l	$18(a6),a1
		bclr	#2,(a5)
		bset	#1,(a5)
		move.b	$B(a5),d0
		jsr	sub_753F8(pc)
		movea.l	a3,a5

loc_75688:
		addq.w	#8,sp
		rts
; ---------------------------------------------------------------------------

loc_7568C:
		lea	$10(a6),a0
		moveq	#7,d0

loc_75692:
		move.b	(a4)+,(a0)+
		dbf	d0,loc_75692
		move.b	#$80,$F(a6)
		move.b	#$27,d0
		moveq	#$40,d1
		bra.w	sub_74E5C
; ---------------------------------------------------------------------------

loc_756A8:
		lea	byte_756C8(pc),a1
		moveq	#3,d3

loc_756AE:
		move.b	(a1)+,d0
		move.b	(a4)+,d1
		bset	#3,d1
		jsr	sub_74E44(pc)
		move.b	(a1)+,d0
		moveq	#$1F,d1
		jsr	sub_74E44(pc)
		dbf	d3,loc_756AE
		rts
; ---------------------------------------------------------------------------

byte_756C8:	dc.b $90, $50, $98, $58
		dc.b $94, $54, $9C, $5C
Z80Driver:	include "sound/Z80/DAC Driver.asm"
		even
mGHZ:		incbin "sound/music/GHZ.ssf"
		even
mLZ:		incbin "sound/music/LZ.ssf"
		even
mMZ:		incbin "sound/music/MZ.ssf"
		even
mSLZ:		incbin "sound/music/SLZ.ssf"
		even
mSYZ:		incbin "sound/music/SYZ.ssf"
		even
mSBZ:		incbin "sound/music/SBZ.ssf"
		even
mInvincibility:	incbin "sound/music/Invincibility.ssf"
		even
mExtraLife:	incbin "sound/music/ExtraLife.ssf"
		even
mSS:		incbin "sound/music/SpecialStage.ssf"
		even
mTitle:		incbin "sound/music/TitleScreen.ssf"
		even
mEnding:	incbin "sound/music/Ending.ssf"
		even
mBoss:		incbin "sound/music/Boss.ssf"
		even
mFZ:		incbin "sound/music/FZ.ssf"
		even
mResults:	incbin "sound/music/Results.ssf"
		even
mGameOver:	incbin "sound/music/GameOver.ssf"
		even
mContinue:	incbin "sound/music/Continue.ssf"
		even
mCredits:	incbin "sound/music/Credits.ssf"
		even

mSFXList:	dc.l sA0, sA1, sA2, sA3, sA4, sA5, sA6, sA7
		dc.l sA8, sA9, sAA, sAB, sAC, sAD, sAE, sAF
		dc.l sB0, sB1, sB2, sB3, sB4, sB5, sB6, sB7
		dc.l sB8, sB9, sBA, sBB, sBC_, sBD, sBE, sBF
		dc.l sC0, sC1, sC2, sC3, sC4, sC5, sC6, sC7
		dc.l sC8, sC9, sCA, sCB, sCC_, sCD, sCE, sCF_

mSpecialSFXList:dc.l sD0, sD1, sD2
sA0:		incbin "sound/sfx/A0.ssf"
		even
sA1:		incbin "sound/sfx/A1.ssf"
		even
sA2:		incbin "sound/sfx/A2.ssf"
		even
sA3:		incbin "sound/sfx/A3.ssf"
		even
sA4:		incbin "sound/sfx/A4.ssf"
		even
sA5:		incbin "sound/sfx/A5.ssf"
		even
sA6:		incbin "sound/sfx/A6.ssf"
		even
sA7:		incbin "sound/sfx/A7.ssf"
		even
sA8:		incbin "sound/sfx/A8.ssf"
		even
sA9:		incbin "sound/sfx/A9.ssf"
		even
sAA:		incbin "sound/sfx/AA.ssf"
		even
sAB:		incbin "sound/sfx/AB.ssf"
		even
sAC:		incbin "sound/sfx/AC.ssf"
		even
sAD:		incbin "sound/sfx/AD.ssf"
		even
sAE:		incbin "sound/sfx/AE.ssf"
		even
sAF:		incbin "sound/sfx/AF.ssf"
		even
sB0:		incbin "sound/sfx/B0.ssf"
		even
sB1:		incbin "sound/sfx/B1.ssf"
		even
sB2:		incbin "sound/sfx/B2.ssf"
		even
sB3:		incbin "sound/sfx/B3.ssf"
		even
sB4:		incbin "sound/sfx/B4.ssf"
		even
sB5:		incbin "sound/sfx/B5.ssf"
		even
sB6:		incbin "sound/sfx/B6.ssf"
		even
sB7:		incbin "sound/sfx/B7.ssf"
		even
sB8:		incbin "sound/sfx/B8.ssf"
		even
sB9:		incbin "sound/sfx/B9.ssf"
		even
sBA:		incbin "sound/sfx/BA.ssf"
		even
sBB:		incbin "sound/sfx/BB.ssf"
		even
sBC_:		incbin "sound/sfx/BC.ssf"
		even
sBD:		incbin "sound/sfx/BD.ssf"
		even
sBE:		incbin "sound/sfx/BE.ssf"
		even
sBF:		incbin "sound/sfx/BF.ssf"
		even
sC0:		incbin "sound/sfx/C0.ssf"
		even
sC1:		incbin "sound/sfx/C1.ssf"
		even
sC2:		incbin "sound/sfx/C2.ssf"
		even
sC3:		incbin "sound/sfx/C3.ssf"
		even
sC4:		incbin "sound/sfx/C4.ssf"
		even
sC5:		incbin "sound/sfx/C5.ssf"
		even
sC6:		incbin "sound/sfx/C6.ssf"
		even
sC7:		incbin "sound/sfx/C7.ssf"
		even
sC8:		incbin "sound/sfx/C8.ssf"
		even
sC9:		incbin "sound/sfx/C9.ssf"
		even
sCA:		incbin "sound/sfx/CA.ssf"
		even
sCB:		incbin "sound/sfx/CB.ssf"
		even
sCC_:		incbin "sound/sfx/CC.ssf"
		even
sCD:		incbin "sound/sfx/CD.ssf"
		even
sCE:		incbin "sound/sfx/CE.ssf"
		even
sCF_:		incbin "sound/sfx/CF.ssf"
		even
sD0:		incbin "sound/sfx/D0.ssf"
		even
sD1:		incbin "sound/sfx/D1.ssf"
		even
sD2:		incbin "sound/sfx/D2.ssf"
		even
		align	$8000					; Unnecessary alignment
; end of 'ROM'
; ===========================================================================
; Segment type: Regular
; segment "RAM"
RAM		section bss, org($FFFF0000), size($10000)
Chunks:		ds.b $80					; note to self: sort this out later

byte_FF0080:	ds.b $880
byte_FF0900:	ds.b $720
byte_FF1020:	ds.b $70E
byte_FF172E:	ds.b $1C52
byte_FF3380:	ds.b $C80
byte_FF4000:	ds.b 8
byte_FF4008:	ds.l 1
byte_FF400C:	ds.b $22
byte_FF402E:	ds.b $3D2
byte_FF4400:	ds.b $3C00
byte_FF8000:	ds.b $2400
Layout:		ds.b $400
byte_FFA800:	ds.b $200
byte_FFAA00:	ds.b $100
byte_FFAB00:	ds.b $100
DisplayLists:	ds.b $400
Blocks:		ds.b $1800
SonicArtBuf:	ds.b $300
SonicPosTable:	ds.b $100
ScrollTable:	ds.b $400
ObjectsList:	ds.b $40
byte_FFD040:	ds.b $40
byte_FFD080:	ds.b $40
byte_FFD0C0:	ds.b $40
byte_FFD100:	ds.b $40
byte_FFD140:	ds.b $40
byte_FFD180:	ds.b $40
byte_FFD1C0:	ds.b $40
byte_FFD200:	ds.b $40
byte_FFD240:	ds.b $40
byte_FFD280:	ds.b $40
byte_FFD2C0:	ds.b $40
		ds.b $40
		ds.b $40
		ds.b $40
		ds.b $40
byte_FFD400:	ds.b $40
		ds.b $40
		ds.b $40
		ds.b $40
byte_FFD500:	ds.b $40
		ds.b $40
		ds.b $40
		ds.b $40
byte_FFD600:	ds.b $40
		ds.b $40
		ds.b $40
		ds.b $40
		ds.b $40
		ds.b $40
		ds.b $40
		ds.b $40
LevelObjectsList:ds.b $1800
SoundMemory:	ds.b $600
GameMode:	ds.b 1
		ds.b 1
padHeldPlayer:	ds.b 1
padPressPlayer:	ds.b 1
padHeld1:	ds.b 1
padPress1:	ds.b 1
padPress2:	ds.b 1
padHeld2:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
ModeReg2:	ds.w 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
GlobalTimer:	ds.w 1
dword_FFF616:	ds.l 1
dword_FFF61A:	ds.l 1
word_FFF61E:	ds.w 1
word_FFF620:	ds.w 1
word_FFF622:	ds.w 1
word_FFF624:	ds.w 1
word_FFF626:	ds.w 1
byte_FFF628:	ds.b 1
byte_FFF629:	ds.b 1
VintRoutine:	ds.b 1
		ds.b 1
byte_FFF62C:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
word_FFF632:	ds.w 1
word_FFF634:	ds.w 1
RandomSeed:	ds.l 1
PauseFlag:	ds.w 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
word_FFF644:	ds.w 1
		ds.b 1
		ds.b 1
word_FFF648:	ds.w 1
		ds.b 1
		ds.b 1
word_FFF64C:	ds.w 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
word_FFF660:	ds.w 1
word_FFF662:	ds.w 1
		ds.b 1
		ds.b 1
word_FFF666:	ds.w 1
LevSelOption:	ds.w 1
LevSelSound:	ds.w 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
plcList:	ds.b $60
unk_FFF6E0:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF6E4:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF6E8:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF6EC:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF6F0:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF6F4:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF6F8:	ds.b 1
		ds.b 1
unk_FFF6FA:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
CameraX:	ds.l 1
CameraY:	ds.l 1
unk_FFF708:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF70C:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF710:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF714:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF718:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF71C:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF720:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF724:	ds.b 1
		ds.b 1
unk_FFF726:	ds.b 1
		ds.b 1
unk_FFF728:	ds.b 1
		ds.b 1
unk_FFF72A:	ds.b 1
		ds.b 1
unk_FFF72C:	ds.b 1
		ds.b 1
unk_FFF72E:	ds.b 1
		ds.b 1
unk_FFF730:	ds.b 1
		ds.b 1
unk_FFF732:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF73A:	ds.b 1
		ds.b 1
unk_FFF73C:	ds.b 1
		ds.b 1
unk_FFF73E:	ds.b 1
		ds.b 1
unk_FFF740:	ds.b 1
unk_FFF741:	ds.b 1
EventsRoutine:	ds.b 1
		ds.b 1
unk_FFF744:	ds.b 1
		ds.b 1
unk_FFF746:	ds.b 1
		ds.b 1
unk_FFF748:	ds.b 1
		ds.b 1
unk_FFF74A:	ds.b 1
unk_FFF74B:	ds.b 1
unk_FFF74C:	ds.b 1
unk_FFF74D:	ds.b 1
unk_FFF74E:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF754:	ds.b 1
		ds.b 1
unk_FFF756:	ds.b 1
		ds.b 1
unk_FFF758:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF75C:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF760:	ds.b 1
		ds.b 1
unk_FFF762:	ds.b 1
		ds.b 1
unk_FFF764:	ds.b 1
		ds.b 1
unk_FFF766:	ds.b 1
unk_FFF767:	ds.b 1
unk_FFF768:	ds.b 1
		ds.b 1
unk_FFF76A:	ds.b 1
		ds.b 1
unk_FFF76C:	ds.b 1
		ds.b 1
unk_FFF76E:	ds.b 1
		ds.b 1
unk_FFF770:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF774:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF778:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF77C:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF780:	ds.b 1
		ds.b 1
unk_FFF782:	ds.b 1
unk_FFF783:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF790:	ds.b 1
		ds.b 1
unk_FFF792:	ds.b 1
		ds.b 1
unk_FFF794:	ds.b 1
		ds.b 1
Collision:	ds.l 1
unk_FFF79A:	ds.b 1
		ds.b 1
unk_FFF79C:	ds.b 1
		ds.b 1
unk_FFF79E:	ds.b 1
		ds.b 1
unk_FFF7A0:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF7A4:	ds.b 1
		ds.b 1
		ds.b 1
unk_FFF7A7:	ds.b 1
unk_FFF7A8:	ds.b 1
unk_FFF7A9:	ds.b 1
unk_FFF7AA:	ds.b 1
		ds.b 1
unk_FFF7AC:	ds.b 1
unk_FFF7AD:	ds.b 1
unk_FFF7AE:	ds.b 1
unk_FFF7AF:	ds.b 1
unk_FFF7B0:	ds.b 1
unk_FFF7B1:	ds.b 1
unk_FFF7B2:	ds.b 1
unk_FFF7B3:	ds.b 1
unk_FFF7B4:	ds.b 1
unk_FFF7B5:	ds.b 1
unk_FFF7B6:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF7E0:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFF7EF:	ds.b 1
unk_FFF7F0:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
byte_FFF800:	ds.b $280
		ds.b $80					; unused??

Palette:	ds.b $80
PaletteTarget:	ds.b $80
byte_FFFC00:	ds.b $100
		ds.b $100					; stack data!

StackPointer:	ds.w 1
LevelRestart:	ds.w 1
LevelFrames:	ds.w 1
byte_FFFE06:	ds.b 1
		ds.b 1
DebugRoutine:	ds.w 1
byte_FFFE0A:	ds.b 1
byte_FFFE0B:	ds.b 1
unk_FFFE0C:	ds.b 1
		ds.b 1
		ds.b 1
byte_FFFE0F:	ds.b 1
level:		ds.w 1
Lives:		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
byte_FFFE1B:	ds.b 1
byte_FFFE1C:	ds.b 1
ExtraLifeFlags:	ds.b 1
byte_FFFE1E:	ds.b 1
byte_FFFE1F:	ds.b 1
Rings:		ds.w 1
dword_FFFE22:	ds.l 1
dword_FFFE26:	ds.l 1
		ds.b 1
		ds.b 1
byte_FFFE2C:	ds.b 1
byte_FFFE2D:	ds.b 1
byte_FFFE2E:	ds.b 1
byte_FFFE2F:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFFE50:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
word_FFFE54:	ds.w 1
word_FFFE56:	ds.w 1
byte_FFFE58:	ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
oscValues:	ds.b $42
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
unk_FFFEC0:	ds.b 1
unk_FFFEC1:	ds.b 1
RingTimer:	ds.b 1
RingFrame:	ds.b 1
unk_FFFEC4:	ds.b 1
unk_FFFEC5:	ds.b 1
RingLossTimer:	ds.b 1
RingLossFrame:	ds.b 1
RingLossAccumulator:ds.w 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
word_FFFFE0:	ds.w 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
word_FFFFE8:	ds.w 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
DemoMode:	ds.w 1
DemoNum:	ds.w 1
		ds.b 1
		ds.b 1
		ds.b 1
		ds.b 1
ConsoleRegion:	ds.b 1
		ds.b 1
word_FFFFFA:	ds.w 1
ChecksumStr:	ds.l 1
; end of 'RAM'
