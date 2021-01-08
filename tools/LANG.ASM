; MADE BY NATSUMI 2017

; DEFINE HELPERS
ztemp =		0		; TEMPORARY REGISTER
zundoc =	1		; SET TO 0 TO USE UNDOCUMENTED OPCODES
z80regstr	EQUS "a b c d e h l bc de hl sp af ix iy i r ixh ixl iyh iyl (bc) (de) (hl) (sp) af' (ix) (iy)"

; EASILY MAKE SECTIONS
z80prog	macro obj
	if narg=0
		OBJEND
z80prg =	0
		MEXIT		; exit macro here
	endif

	PUSHO			; push options
	OPT AN+			; allow use of 100H instead of $100
	OPT M-			; do not print better macro info. Comment out for large text dump.
	OPT D-			; make sure EQU/SET do not descope local lables

zfutureobj =	\obj
zfuturepos =	offset(*)
zfuturec =	0

	if narg=1
		OBJ \obj
z80prg =	1
	else
		inform 0,"Invalid num of args!"
	endif
    endm

; CREATE A LITTLE-ENDIAN Z80 ABSOLUTE ADDRESS
z80word	macro word
	dc.b ((\word)&$FF), ((\word)>>8&$FF)
    endm

; SAVES THE RÈGISTER ID TO ZTEMP
zgetreg	macro reg, err
	if strlen("\reg")=0
		inform \err,"The register must not be empty!"
		mexit
	endif

ztemp = instr("\z80regstr", "\reg")

	if (ztemp<>0)&(ztemp<55)
ztemp =		(z\reg)

	elseif ztemp=56
ztemp =		zbcr

	elseif ztemp=61
ztemp =		zder

	elseif ztemp=66
ztemp =		zhlr

	elseif ztemp=71
ztemp =		zspr

	elseif ztemp=76
ztemp =		zaf2

	elseif ztemp=79
ztemp =		zixr

	elseif ztemp=85
ztemp =		ziyr

	else

		if instr("\reg", "(ix+")<>0|instr("\reg", "(ix-")<>0
ztemp =		zixp

		elseif instr("\reg", "(iy+")<>0|instr("\reg", "(iy-")<>0
ztemp =		ziyp

		else
ztemp =			-1

			local a, cc, p
a =			0
p =			1
d =			0
			while a=0
				if p>strlen("\reg")
ztemp =					-2
a =					1

				else
cc					substr p,p,"\reg"
					if '\cc'='('
d =						d+1

					elseif '\cc'=')'
d =						d-1

					elseif ('\cc'<>' ')&('\cc'<>'	')
						if d<1
a =							1
						endif
					endif
				endif
p =				p+1
			endw
		endif
	endif
    endm

; PLACES THE SIGNED OFFSET INTO ROM, AND QUEUES A CHECK
zindoff	macro reg, byte
	local off
off	substr 4, strlen("\reg")-1, "\reg"
		dc.b \byte, off
    endm

zjrfuture macro off, byte
		dc.b \byte, off
    endm

; QUEUES SIGNED VALUES TO BE FIXED
zfuture	macro byte
zfuturec =	zfuturec+1
		local p,v
p =		offset(*)-2
v =		\byte
		pushp "\#v"
		pushp "\#p"
    endm

; Define equates for registers
zb = 	0
zc =	1
zd =	2
ze =	3
zh =	4
zl =	5
za =	7
zbc =	8
zde =	9
zhl =	$A
zsp =	$B
zbcr =	$18
zder =	$19
zhlr =	$1A
zspr =	$1B
zix =	$20
ziy =	$21
zixr =	$22
ziyr =	$23
zixp =	$24
ziyp =	$25
zixh =	$28
zixl =	$29
ziyh =	$2A
ziyl =	$2B
zaf =	$30
zaf2 =	$31
zi =	$38
zr =	$39


; Define instructions

db	macro val
	dc.b \_
    endm

dsb	macro num, val
	dcb.b \_
    endm

dw	macro val
	rept narg
		dc.b ((\val)&$FF), ((\val)>>8&$FF)
		shift
	endr
    endm

bw	macro val
	rept narg
		dc.b ((\val)>>8&$FF), ((\val)&$FF)
		shift
	endr
    endm

dsw	macro num, val
	rept \num
		dc.b ((\val)&$FF), ((\val)>>8&$FF)
		shift
	endr
    endm

bsw	macro num, val
	rept \num
		dc.b ((\val)>>8&$FF), ((\val)&$FF)
		shift
	endr
    endm

rlc	macro reg, reg2
	zgetreg \reg, 0

	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	if narg=2
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		if (ztemp=zixp)
			dc.b $DD

		elseif (ztemp=ziyp)
			dc.b $FD

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif

		zindoff \reg, $CD
		zgetreg \reg2, 0

		if (ztemp>=0)&(ztemp<=za)
			dc.b $00+ztemp

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif
		mexit
	endif

	if (ztemp>=0)&(ztemp<=za)
		dc.b $CB, $00+ztemp		; rlc a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $CB, $06			; rlc (hl)

	elseif ztemp=zixp
		dc.b $DD			; rlc (ix+*)
		zindoff \reg, $CB
		dc.b $06

	elseif ztemp=ziyp
		dc.b $FD			; rlc (iy+*)
		zindoff \reg, $CB
		dc.b $06

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

rrc	macro reg
	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if narg=2
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		if (ztemp=zixp)
			dc.b $DD

		elseif (ztemp=ziyp)
			dc.b $FD

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif

		zindoff \reg, $CD
		zgetreg \reg2, 0

		if (ztemp>=0)&(ztemp<=za)
			dc.b $08+ztemp

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif
		mexit
	endif

	if (ztemp>=0)&(ztemp<=za)
		dc.b $CB, $08+ztemp		; rrc a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $CB, $0E			; rrc (hl)

	elseif ztemp=zixp
		dc.b $DD			; rrc (ix+*)
		zindoff \reg, $CB
		dc.b $0E

	elseif ztemp=ziyp
		dc.b $FD			; rrc (iy+*)
		zindoff \reg, $CB
		dc.b $0E

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

rl	macro reg
	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if narg=2
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		if (ztemp=zixp)
			dc.b $DD

		elseif (ztemp=ziyp)
			dc.b $FD

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif

		zindoff \reg, $CD
		zgetreg \reg2, 0

		if (ztemp>=0)&(ztemp<=za)
			dc.b $10+ztemp

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif
		mexit
	endif

	if (ztemp>=0)&(ztemp<=za)
		dc.b $CB, $10+ztemp		; rl a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $CB, $16			; rl (hl)

	elseif ztemp=zixp
		dc.b $DD			; rl (ix+*)
		zindoff \reg, $CB
		dc.b $16

	elseif ztemp=ziyp
		dc.b $FD			; rl (iy+*)
		zindoff \reg, $CB
		dc.b $16

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

rr	macro reg
	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if narg=2
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		if (ztemp=zixp)
			dc.b $DD

		elseif (ztemp=ziyp)
			dc.b $FD

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif

		zindoff \reg, $CD
		zgetreg \reg2, 0

		if (ztemp>=0)&(ztemp<=za)
			dc.b $18+ztemp

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif
		mexit
	endif

	if (ztemp>=0)&(ztemp<=za)
		dc.b $CB, $18+ztemp		; rr a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $CB, $1E			; rr (hl)

	elseif ztemp=zixp
		dc.b $DD			; rr (ix+*)
		zindoff \reg, $CB
		dc.b $1E

	elseif ztemp=ziyp
		dc.b $FD			; rr (iy+*)
		zindoff \reg, $CB
		dc.b $1E

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

sla	macro reg
	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if narg=2
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		if (ztemp=zixp)
			dc.b $DD

		elseif (ztemp=ziyp)
			dc.b $FD

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif

		zindoff \reg, $CD
		zgetreg \reg2, 0

		if (ztemp>=0)&(ztemp<=za)
			dc.b $20+ztemp

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif
		mexit
	endif

	if (ztemp>=0)&(ztemp<=za)
		dc.b $CB, $20+ztemp		; sla a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $CB, $26			; sla (hl)

	elseif ztemp=zixp
		dc.b $DD			; sla (ix+*)
		zindoff \reg, $CB
		dc.b $26

	elseif ztemp=ziyp
		dc.b $FD			; sla (iy+*)
		zindoff \reg, $CB
		dc.b $26

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

sra	macro reg
	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if narg=2
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		if (ztemp=zixp)
			dc.b $DD

		elseif (ztemp=ziyp)
			dc.b $FD

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif

		zindoff \reg, $CD
		zgetreg \reg2, 0

		if (ztemp>=0)&(ztemp<=za)
			dc.b $28+ztemp

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif
		mexit
	endif

	if (ztemp>=0)&(ztemp<=za)
		dc.b $CB, $28+ztemp		; sra a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $CB, $2E			; sra (hl)

	elseif ztemp=zixp
		dc.b $DD			; sra (ix+*)
		zindoff \reg, $CB
		dc.b $2E

	elseif ztemp=ziyp
		dc.b $FD			; sra (iy+*)
		zindoff \reg, $CB
		dc.b $2E

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

sll	macro reg
	if zundoc
		inform 2,"Undocumented opcodes are not enabled."
	endif

	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if narg=2
		if (ztemp=zixp)
			dc.b $DD

		elseif (ztemp=ziyp)
			dc.b $FD

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif

		zindoff \reg, $CD
		zgetreg \reg2, 0

		if (ztemp>=0)&(ztemp<=za)
			dc.b $30+ztemp

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif
		mexit
	endif

	if (ztemp>=0)&(ztemp<=za)
		dc.b $CB, $30+ztemp		; sll a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $CB, $36			; sll (hl)

	elseif ztemp=zixp
		dc.b $DD			; sll (ix+*)
		zindoff \reg, $CB
		dc.b $36

	elseif ztemp=ziyp
		dc.b $FD			; sll (iy+*)
		zindoff \reg, $CB
		dc.b $36

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

srl	macro reg
	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if narg=2
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		if (ztemp=zixp)
			dc.b $DD

		elseif (ztemp=ziyp)
			dc.b $FD

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif

		zindoff \reg, $CD
		zgetreg \reg2, 0

		if (ztemp>=0)&(ztemp<=za)
			dc.b $38+ztemp

		else
			inform 2,"Invalid or unsupported register combination '\reg' and '\reg2'!"
		endif
		mexit
	endif

	if (ztemp>=0)&(ztemp<=za)
		dc.b $CB, $38+ztemp		; sra a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $CB, $3E			; sra (hl)

	elseif ztemp=zixp
		dc.b $DD			; sra (ix+*)
		zindoff \reg, $CB
		dc.b $3E

	elseif ztemp=ziyp
		dc.b $FD			; sra (iy+*)
		zindoff \reg, $CB
		dc.b $3E

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

bit	macro bit, reg
	if narg<>2
		inform 2,"Incorrect number of arguments!"
	endif

	if (\bit<0)|(\bit>7)
		inform 2,"Invalid bit '\bit'!"
	endif

	zgetreg \reg, 0

	if (ztemp>=0)&(ztemp<=za)
		dc.b $CB, $40+ztemp+(\bit*$08)	; bit 0-7,a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $CB, $46+(\bit*$08)	; bit 0-7,(hl)

	elseif ztemp=zixp
		dc.b $DD			; bit 0-7,(ix+*)
		zindoff \reg, $CB
		dc.b $46+(\bit*$08)

	elseif ztemp=ziyp
		dc.b $FD			; bit 0-7,(iy+*)
		zindoff \reg, $CB
		dc.b $46+(\bit*$08)

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

res	macro bit, reg, reg2
	if narg>3
		inform 2,"Incorrect number of arguments!"
	endif

	if (\bit<0)|(\bit>7)
		inform 2,"Invalid bit '\bit'!"
	endif

	zgetreg \reg, 0

	if (ztemp>=0)&(ztemp<=za)
		dc.b $CB, $80+ztemp+(\bit*$08)	; res 0-7,a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $CB, $86+(\bit*$08)	; res 0-7,(hl)

	elseif (ztemp=zixp)|(ztemp=ziyp)
		dc.b $DD+((ztemp-zixp)*$20)	; res 0-7,(ix/iy+*),  , a, b, c, d, e, h, l
		zindoff \reg, $CB

		if narg=3
			if zundoc
				inform 2,"Undocumented opcodes are not enabled."
			endif

			zgetreg \reg2, 0
			if (ztemp<0)|(ztemp>za)
				inform 2,"Invalid or unsupported register '\reg2'!"
			endif
		else
ztemp =			6
		endif

		dc.b $80+(\bit*$08)+ztemp

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

zset	macro bit, reg
	if narg>3
		inform 2,"Incorrect number of arguments!"
	endif

	if (\bit<0)|(\bit>7)
		inform 2,"Invalid bit '\bit'!"
	endif

	zgetreg \reg, 0

	if (ztemp>=0)&(ztemp<=za)
		dc.b $CB, $C0+ztemp+(\bit*$08)	; set 0-7,a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $CB, $C6+(\bit*$08)	; set 0-7,(hl)

	elseif (ztemp=zixp)|(ztemp=ziyp)
		dc.b $DD+((ztemp-zixp)*$20)	; set 0-7,(ix/iy+*),  , a, b, c, d, e, h, l
		zindoff \reg, $CB

		if narg=3
			if zundoc
				inform 2,"Undocumented opcodes are not enabled."
			endif

			zgetreg \reg2, 0
			if (ztemp<0)|(ztemp>za)
				inform 2,"Invalid or unsupported register '\reg2'!"
			endif
		else
ztemp =			6
		endif

		dc.b $C0+(\bit*$08)+ztemp

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

im	macro im
	if narg<>1
		inform 2,"Incorrect number of arguments!"
	endif

	if "\im"="0/1"
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		dc.b $ED, $4E		; im 0/1

	elseif (\im<0)|(\im>2)
		inform 2,"Interrupt mode must only be 0, 1 or 2!"

	elseif \im=2
		dc.b $ED, $5E		; im 2
	else
		dc.b $ED, $46+(\im*$10); im 0 or 1
	endif
    endm

rst	macro addr
	if narg<>1
		inform 2,"Incorrect number of arguments!"
	endif

	if (\addr&7)=0
		if \addr>$48|\addr<0
			inform 2,"Invalid address! Must be at least 0 and at most $38!"
		else
			dc.b $C7+\addr	; RST *
		endif
	else
		inform 2,"Address must be aligned by $8!"
	endif
    endm

inc	macro reg
	if narg<>1
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 2

	if ztemp<=za
		dc.b $04+(ztemp*$08)		; inc a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $34			; inc (hl)

	elseif (ztemp>=zbc)&(ztemp<=zsp)
		dc.b $03+((ztemp-zbc)*$10)	; inc bc, de, hl or sp

	elseif ztemp=zix
		dc.b $DD, $23			; inc ix

	elseif ztemp=ziy
		dc.b $FD, $23			; inc iy

	elseif ztemp=zixp
		dc.b $DD			; inc ix+
		zindoff \reg, $34

	elseif ztemp=ziyp
		dc.b $FD			; inc iy+
		zindoff \reg, $34

	elseif (ztemp>=zixh)&(ztemp<=ziyl)
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		dc.b $DD+((ztemp&$02)*$10), $24+((ztemp&$01)*$08); inc ixh, ixl, iyh, iyl

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

dec	macro reg
	if narg<>1
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 2

	if ztemp<=za
		dc.b $05+(ztemp*$08)		; dec a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $35			; dec (hl)

	elseif (ztemp>=zbc)&(ztemp<=zsp)
		dc.b $0B+((ztemp-zbc)*$10)	; dec bc, de, hl or sp

	elseif ztemp=zix
		dc.b $DD, $2B			; dec ix

	elseif ztemp=ziy
		dc.b $FD, $2B			; dec iy

	elseif ztemp=zixp
		dc.b $DD			; dec ix+
		zindoff \reg, $35

	elseif ztemp=ziyp
		dc.b $FD			; dec iy+
		zindoff \reg, $35

	elseif (ztemp>=zixh)&(ztemp<=ziyl)
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		dc.b $FD+((ztemp&$02)*$10), $24+((ztemp&$01)*$08); dec ixh, ixl, iyh, iyl

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

zsub	macro reg
	if narg<>1
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if ztemp=-1
		dc.b $D6			; sub a,*
		dc.b \reg

	elseif ztemp<=za
		dc.b $90+ztemp			; sub a,a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $96			; sub a,(hl)

	elseif ztemp=zixp
		dc.b $DD			; sub a,(ix+*)
		zindoff \reg, $96

	elseif ztemp=ziyp
		dc.b $FD			; sub a,(iy+*)
		zindoff \reg, $96

	elseif (ztemp>=zixh)&(ztemp<=ziyl)
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		dc.b $DD+((ztemp&$02)*$10), $94+(ztemp&$01); sub a,ixh, ixl, iyh, iyl

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

zand	macro reg
	if narg<>1
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if ztemp=-1
		dc.b $E6			; and a,*
		dc.b \reg

	elseif ztemp<=za
		dc.b $A0+ztemp			; and a,a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $A6			; and a,(hl)

	elseif ztemp=zixp
		dc.b $DD			; and a,(ix+*)
		zindoff \reg, $A6

	elseif ztemp=ziyp
		dc.b $FD			; and a,(iy+*)
		zindoff \reg, $A6

	elseif (ztemp>=zixh)&(ztemp<=ziyl)
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		dc.b $DD+((ztemp&$02)*$10), $A4+(ztemp&$01); and a,ixh, ixl, iyh, iyl

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

zor	macro reg
	if narg<>1
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if ztemp=-1
		dc.b $F6			; or a,*
		dc.b \reg

	elseif ztemp<=za
		dc.b $B0+ztemp			; or a,a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $B6			; or a,(hl)

	elseif ztemp=zixp
		dc.b $DD			; or a,(ix+*)
		zindoff \reg, $B6

	elseif ztemp=ziyp
		dc.b $FD			; or a,(iy+*)
		zindoff \reg, $B6

	elseif (ztemp>=zixh)&(ztemp<=ziyl)
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		dc.b $DD+((ztemp&$02)*$10), $B4+(ztemp&$01); or a,ixh, ixl, iyh, iyl

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

xor	macro reg
	if narg<>1
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if ztemp=-1
		dc.b $EE			; xor a,*
		dc.b \reg

	elseif ztemp<=za
		dc.b $A8+ztemp			; xor a,a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $B6			; xor a,(hl)

	elseif ztemp=zixp
		dc.b $DD			; xor a,(ix+*)
		zindoff \reg, $AE

	elseif ztemp=ziyp
		dc.b $FD			; xor a,(iy+*)
		zindoff \reg, $AE

	elseif (ztemp>=zixh)&(ztemp<=ziyl)
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		dc.b $DD+((ztemp&$02)*$10), $AC+(ztemp&$01); xor a,ixh, ixl, iyh, iyl

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

cp	macro reg
	if narg<>1
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if ztemp=-1
		dc.b $FE			; cp a,*
		dc.b \reg

	elseif ztemp<=za
		dc.b $B8+ztemp			; cp a,a, b, c, d, e, h or l

	elseif ztemp=zhlr
		dc.b $BE			; cp a,(hl)

	elseif ztemp=zixp
		dc.b $DD			; cp a,(ix+*)
		zindoff \reg, $BE

	elseif ztemp=ziyp
		dc.b $FD			; cp a,(iy+*)
		zindoff \reg, $BE

	elseif (ztemp>=zixh)&(ztemp<=ziyl)
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		dc.b $DD+((ztemp&$02)*$10), $BC+(ztemp&$01); cp a,ixh, ixl, iyh, iyl

	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

zadd	macro reg1, reg2
	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg1, 0
ztemp1 =	ztemp

	if narg>1
		zgetreg \reg2, 0
	endif

	if ((narg=1)&((ztemp<=za)|(ztemp=zhlr)|(ztemp=zixp)|(ztemp=ziyp)))|(ztemp1=za)|(ztemp1=zixp)|(ztemp1=ziyp); this complex piece of shit just checks if we omitted the a param
		if (ztemp1=zixp)|(ztemp=zixp)
			if ztemp1=za
				shift
			endif

			dc.b $DD		; add a,(ix+*)
			zindoff \reg1, $86

		elseif (ztemp1=ziyp)|(ztemp=ziyp)
			if ztemp1=za
				shift
			endif

			dc.b $FD		; add a,(iy+*)
			zindoff \reg1, $86

		elseif ztemp=zhlr
			dc.b $86		; add a,(hl)

		elseif ztemp=-1
			if ztemp1=za
				shift
			endif

			dc.b $C6		; add a,*
			dc.b \reg1

		elseif ztemp<=za
			dc.b $80+ztemp		; add a,a, b, c, d, e, h or l

		elseif (ztemp>=zixh)&(ztemp<=ziyl)
			if zundoc
				inform 2,"Undocumented opcodes are not enabled."
			endif

			dc.b $DD+((ztemp&$02)*$10), $84+(ztemp&$01); add a,ixh, ixl, iyh, iyl

		else
			inform 2,"Invalid or unsupported register combination: a, \reg2!"
		endif

	elseif ((narg=1)&(ztemp>=zbc)&(ztemp<=zsp))|(ztemp1=zhl)	; this piece of shit just checks if we omitted the hl param
		dc.b $09+((ztemp-zbc)*$10)	; add hl,bc, de, hl or sp

	elseif ztemp1=zix
		dc.b $DD

		if ztemp=zbc
			dc.b $09		; add ix,bc

		elseif ztemp=zde
			dc.b $19		; add ix,de

		elseif ztemp=zix
			dc.b $29		; add ix,ix

		elseif ztemp=zsp
			dc.b $39		; add ix,sp

		else
			inform 2,"Invalid or unsupported register combination: ix, \reg2!"
		endif

	elseif ztemp1=ziy
		dc.b $FD

		if ztemp=zbc
			dc.b $09		; add iy,bc

		elseif ztemp=zde
			dc.b $19		; add iy,de

		elseif ztemp=ziy
			dc.b $29		; add iy,iy

		elseif ztemp=zsp
			dc.b $39		; add iy,sp

		else
			inform 2,"Invalid or unsupported register combination: iy, \reg2!"
		endif

	else
		inform 2,"Invalid or unsupported register '\reg1'!"
	endif
    endm

adc	macro reg1, reg2
	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg1, 0
ztemp1 =	ztemp

	if narg>1
		zgetreg \reg2, 0
	endif

	if ((narg=1)&((ztemp<=za)|(ztemp=zhlr)|(ztemp=zixp)|(ztemp=ziyp)))|(ztemp1=za)|(ztemp1=zixp)|(ztemp1=ziyp); this complex piece of shit just checks if we omitted the a param
		if (ztemp1=zixp)|(ztemp=zixp)
			if ztemp1=za
				shift
			endif

			dc.b $DD		; adc a,(ix+*)
			zindoff \reg1, $8E

		elseif (ztemp1=ziyp)|(ztemp=ziyp)
			if ztemp1=za
				shift
			endif

			dc.b $FD		; adc a,(iy+*)
			zindoff \reg1, $8E

		elseif ztemp=zhlr
			dc.b $8E		; adc a,(hl)

		elseif ztemp=-1
			if ztemp1=za
				shift
			endif

			dc.b $CE		; adc a,*
			dc.b \reg1

		elseif ztemp<=za
			dc.b $88+ztemp		; adc a,a, b, c, d, e, h or l

		elseif (ztemp>=zixh)&(ztemp<=ziyl)
			if zundoc
				inform 2,"Undocumented opcodes are not enabled."
			endif

			dc.b $DD+((ztemp&$02)*$10), $8C+(ztemp&$01); adc a,ixh, ixl, iyh, iyl

		else
			inform 2,"Invalid or unsupported register combination: a, \reg2!"
		endif

	elseif ((narg=1)&(ztemp>=zbc)&(ztemp<=zsp))|(ztemp1=zhl)	; this piece of shit just checks if we omitted the hl param
		dc.b $ED, $4A+((ztemp-zbc)*$10)	; adc hl,bc, de, hl or sp

	else
		inform 2,"Invalid or unsupported register '\reg1'!"
	endif
    endm

sbc	macro reg1, reg2
	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg1, 0
ztemp1 =	ztemp

	if narg>1
		zgetreg \reg2, 0
	endif

	if ((narg=1)&((ztemp<=za)|(ztemp=zhlr)|(ztemp=zixp)|(ztemp=ziyp)))|(ztemp1=za)|(ztemp1=zixp)|(ztemp1=ziyp); this complex piece of shit just checks if we omitted the a param
		if (ztemp1=zixp)|(ztemp=zixp)
			if ztemp1=za
				shift
			endif

			dc.b $DD		; sbc a,(ix+*)
			zindoff \reg1, $9E

		elseif (ztemp1=ziyp)|(ztemp=ziyp)
			if ztemp1=za
				shift
			endif

			dc.b $FD		; sbc a,(iy+*)
			zindoff \reg1, $9E

		elseif ztemp=zhlr
			dc.b $9E		; sbc a,(hl)

		elseif ztemp=-1
			if ztemp1=za
				shift
			endif

			dc.b $DE		; sbc a,*
			dc.b \reg1

		elseif ztemp<=za
			dc.b $98+ztemp		; sbc a,a, b, c, d, e, h or l

		elseif (ztemp>=zixh)&(ztemp<=ziyl)
			if zundoc
				inform 2,"Undocumented opcodes are not enabled."
			endif

			dc.b $DD+((ztemp&$02)*$10), $9C+(ztemp&$01); sbc a,ixh, ixl, iyh, iyl

		else
			inform 2,"Invalid or unsupported register combination: a, \reg2!"
		endif

	elseif ((narg=1)&(ztemp>=zbc)&(ztemp<=zsp))|(ztemp1=zhl)	; this piece of shit just checks if we omitted the hl param
		dc.b $ED, $42+((ztemp-zbc)*$10)	; sbc hl,bc, de, hl or sp

	else
		inform 2,"Invalid or unsupported register '\reg1'!"
	endif
    endm

pop	macro reg
	if narg<>1
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 2

	if (ztemp>=zbc)&(ztemp<=zhl)
		dc.b $C1+((ztemp-zbc)*$10); pop bc, de or hl

	elseif ztemp=zaf
		dc.b $F1		; pop af
	elseif ztemp=zix
		dc.b $DD, $E1		; pop ix
	elseif ztemp=ziy
		dc.b $FD, $E1		; pop iy
	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

push	macro reg
	if narg<>1
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 2

	if (ztemp>=zbc)&(ztemp<=zhl)
		dc.b $C5+((ztemp-zbc)*$10); pop bc, de or hl

	elseif ztemp=zaf
		dc.b $F5		; pop af
	elseif ztemp=zix
		dc.b $DD, $E5		; pop ix
	elseif ztemp=ziy
		dc.b $FD, $E5		; pop iy
	else
		inform 2,"Invalid or unsupported register '\reg'!"
	endif
    endm

ex	macro reg1, reg2
	if narg<>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg1, 0
zreg1 =	ztemp
	zgetreg \reg2, 0

	if ((zreg1=zaf)|(zreg1=zaf2))&((ztemp=zaf)|(ztemp=zaf2))
		dc.b $08			; ex af,af' & ex af',af & ex af,af

	elseif ((zreg1=zde)|(zreg1=zhl))&((ztemp=zde)|(ztemp=zhl))
		dc.b $EB			; ex de,hl & ex hl,de

	elseif ((zreg1=zspr)|(zreg1=zhl))&((ztemp=zspr)|(ztemp=zhl))
		dc.b $E3			; ex (sp),hl & ex hl,(sp)

	elseif ((zreg1=zix)|(zreg1=zspr))&((ztemp=zix)|(ztemp=zspr))
		dc.b $DD,$E3			; ex (sp),ix & ex ix,(sp)

	elseif ((zreg1=ziy)|(zreg1=zspr))&((ztemp=ziy)|(ztemp=zspr))
		dc.b $FD,$E3			; ex (sp),iy & ex iy,(sp)
	else
		inform 2,"Invalid or unsupported register combination '\reg1' and '\reg2'!"
	endif
    endm

out	macro port, reg
	if narg<>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if instr("\port", "(c)")<>0
		if (ztemp=-1)&(instr("\port", "0")<>0)
			if zundoc
				inform 2,"Undocumented opcodes are not enabled."
			endif

			dc.b $ED, $71		; out (c),0

		elseif ztemp<=za
			dc.b $ED, $41+(ztemp*$08)		; out (c),a, b, c, d, e, h or l
		else
			inform 2,"Invalid or unsupported register '\reg'!"
		endif

	elseif ztemp=za
		dc.b $D3, \port		; out (*),a

	else
		inform 2,"Invalid or unsupported port '\port'!"
	endif
    endm

in	macro reg, port
	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg, 0

	if instr("\port", "(c)")<>0
		if narg=1
			if zundoc
				inform 2,"Undocumented opcodes are not enabled."
			endif

			dc.b $ED, $70		; in (c)

		elseif ztemp<=za
			dc.b $ED, $40+(ztemp*$08)		; in a, b, c, d, e, h or l,(c)
		else
			inform 2,"Invalid or unsupported register '\reg'!"
		endif

	elseif ztemp=za
		dc.b $D3, \port		; in a,(*)

	else
		inform 2,"Invalid or unsupported port '\port'!"
	endif
    endm

ld	macro reg1, reg2
	if narg>2
		inform 2,"Incorrect number of arguments!"
	endif

	zgetreg \reg1, 0
zreg1 =	ztemp
	zgetreg \reg2, 0
zreg2 =	ztemp

	if zreg1=-2
		if zreg2=za
			dc.b $32			; ld (**),a
			z80word \reg1

		elseif zreg2=zhl
			dc.b $22			; ld (**),hl
			z80word \reg1

		elseif (zreg2>=zbc)&(zreg2<=zsp)
			dc.b $ED, $43+((zreg2-zbc)*$10)	; ld (**),bc, de, sp
			z80word \reg1

		elseif zreg2=zix
			dc.b $DD, $22			; ld (**),ix
			z80word \reg1

		elseif zreg2=ziy
			dc.b $FD, $22			; ld (**),iy
			z80word \reg1

		else
			inform 2,"Invalid or unsupported register combination '\reg1' and '\reg2'!"
		endif

	elseif zreg2=-1
		if (zreg1<=za)
			dc.b $06+(zreg1*$08), \reg2	; ld a, b, c, d, e, h or l,*

		elseif zreg1=zhlr
			dc.b $36, \reg2			; ld (hl),*

		elseif (zreg1>=zbc)&(zreg1<=zsp)
			dc.b $01+((zreg1-zbc)*$10)	; ld bc, de, hl, sp,**
			z80word \reg2

		elseif zreg1=zix
			dc.b $DD, $21			; ld ix,**
			z80word \reg2

		elseif zreg1=ziy
			dc.b $FD, $21			; ld iy,**
			z80word \reg2

		elseif zreg1=zixp
			dc.b $DD			; ld (ix+*),*
			zindoff \reg1, $36
			dc.b \reg2

		elseif zreg1=ziyp
			dc.b $FD			; ld (iy+*),*
			zindoff \reg1, $36
			dc.b \reg2

		elseif (zreg1>=zixh)&(zreg1<=ziyl)
			if zundoc
				inform 2,"Undocumented opcodes are not enabled."
			endif

			dc.b $DD+((zreg1&$02)*$10), $26+((zreg1&$01)*$08), \reg2; ld ixh, ixl, iyh, iyl,*

		else
			inform 2,"Invalid or unsupported register combination '\reg1' and '\reg2'!"
		endif

	elseif zreg2=-2
		if (zreg1=za)
			dc.b $3A			; ld a,(**)
			z80word \reg2

		elseif zreg1=zhl
			dc.b $2A			; ld hl,(**)
			z80word \reg2

		elseif (zreg1>=zbc)&(zreg1<=zsp)
			dc.b $ED, $4B+((zreg1-zbc)*$10)	; ld bc, de, hl, sp,(**)
			z80word \reg2

		elseif zreg1=zix
			dc.b $DD, $2A			; ld ix,(**)
			z80word \reg2

		elseif zreg1=ziy
			dc.b $FD, $2A			; ld iy,(**)
			z80word \reg2

		else
			inform 2,"Invalid or unsupported register combination '\reg1' and '\reg2'!"
		endif

	elseif (zreg1<=za)&(zreg2<=za)
		dc.b $40+(zreg1*$08)+zreg2		; ld a, b, c, d, e, h or l,a, b, c, d, e, h or l

	elseif (zreg1=za)&(zreg2=zbcr)
		dc.b $0A				; ld a,(bc)

	elseif (zreg1=za)&(zreg2=zder)
		dc.b $1A				; ld a,(de)

	elseif (zreg1<=za)&(zreg2=zhlr)
		dc.b $46+(zreg1*$08)			; ld a, b, c, d, e, h or l,(hl)

	elseif (zreg1=zhlr)&(zreg2<=za)
		dc.b $70+zreg2				; ld (hl),a, b, c, d, e, h or l

	elseif (zreg1<=za)&(zreg2=zixp)
		dc.b $DD				; ld a, b, c, d, e, h or l,(ix+*)
		zindoff \reg2, $46+(zreg1*$08)

	elseif (zreg1<=za)&(zreg2=ziyp)
		dc.b $FD				; ld a, b, c, d, e, h or l,(iy+*)
		zindoff \reg2, $46+(zreg1*$08)

	elseif (zreg2<=za)&(zreg1=zixp)
		dc.b $DD				; ld (ix+*),a, b, c, d, e, h or l
		zindoff \reg1, $70+zreg2

	elseif (zreg2<=za)&(zreg1=ziyp)
		dc.b $FD				; ld (iy+*),a, b, c, d, e, h or l
		zindoff \reg1, $70+zreg2

	elseif (zreg1=zbcr)&(zreg2=za)
		dc.b $02				; ld (bc),a

	elseif (zreg1=zder)&(zreg2=za)
		dc.b $12				; ld (de),a

	elseif (zreg1=zsp)&(zreg2=zhl)
		dc.b $F9				; ld sp,hl

	elseif (zreg1=zi)&(zreg2=za)
		dc.b $ED, $47				; ld i,a

	elseif (zreg2=zi)&(zreg1=za)
		dc.b $ED, $57				; ld a,i

	elseif (zreg1=zr)&(zreg2=za)
		dc.b $ED, $4F				; ld r,a

	elseif (zreg2=zr)&(zreg1=za)
		dc.b $ED, $5F				; ld a,r

	elseif (zreg1=zsp)&(zreg2=zix)
		dc.b $DD, $F9				; ld sp, ix

	elseif (zreg1=zsp)&(zreg2=ziy)
		dc.b $FD, $F9				; ld sp, iy

	elseif (zreg1>=zixh)&(zreg1<=ziyl)&((zreg2<=za)&(zreg2<>zh)&(zreg2<>zl))
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		dc.b $DD+((zreg1&$02)*$10), $60+((zreg1&$01)*$08)+zreg2; ld ixh, ixl, iyh, iyl,a, b, c, d, e

	elseif (zreg2>=zixh)&(zreg2>=ziyl)&((zreg1<=za)&(zreg1<>zh)&(zreg1<>zl))
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		dc.b $DD+((zreg2&$02)*$10), $44+(zreg2&$01)+(zreg1*$08); ld a, b, c, d, e,ixh, ixl, iyh, iyl

	elseif (zreg1>=zixh)&(zreg1<=ziyl)&(zreg2>=zixh)&(zreg2>=ziyl)
		if zundoc
			inform 2,"Undocumented opcodes are not enabled."
		endif

		if ((zreg1&$02)<>(zreg2&$02))
			inform 2,"Invalid or unsupported register combination '\reg1' and '\reg2'!"
			mexit
		endif

		dc.b $DD+((zreg1&$02)*$10), $60+((zreg1&$01)*$08)+(zreg2&$01); ld ixh, ixl, iyh, iyl,ixh, ixl, iyh, iyl

	else
		inform 2,"Invalid or unsupported register combination '\reg1' and '\reg2'!"
	endif
    endm

djnz	macro addr
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	zjrfuture \addr-*-2, $10
    endm

jr	macro cond, off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	if narg=1
		zjrfuture \cond-*-2, $18
	else
		jr\cond \off
	endif
    endm

jrnz	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	zjrfuture \off-*-2, $20
    endm

jrnc	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	zjrfuture \off-*-2, $30
    endm

jrz	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	zjrfuture \off-*-2, $28
    endm

jrc	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	zjrfuture \off-*-2, $38
    endm

jp	macro cond, off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	if narg=1
		zgetreg \cond, 0

		if ztemp=zhlr
			dc.b $E9		; jp (hl)

		elseif ztemp=zixr
			dc.b $DD, $E9		; jp (ix)

		elseif ztemp=ziyr
			dc.b $FD, $E9		; jp (iy)

		else
			dc.b $C3		; jp **
			z80word \cond
		endif
	else
		jp\cond \off
	endif
    endm

jpnz	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $C2
	z80word \off
    endm

jpnc	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $D2
	z80word \off
    endm

jpz	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $CA
	z80word \off
    endm

jpc	macro off
	dc.b $DA
	z80word \off
    endm

jppo	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $E2
	z80word \off
    endm

jpp	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $F2
	z80word \off
    endm

jppe	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $EA
	z80word \off
    endm

jpm	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $FA
	z80word \off
    endm

call	macro cond, off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	if narg=1
		dc.b $CD
		z80word \cond
	else
		call\cond \off
	endif
    endm

callnz	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $C4
	z80word \off
    endm

callz	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $CC
	z80word \off
    endm

callnc	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $D4
	z80word \off
    endm

callc	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $DC
	z80word \off
    endm

callpo	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $E4
	z80word \off
    endm

callpe	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $EC
	z80word \off
    endm

callp	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $F4
	z80word \off
    endm

callm	macro off
	if narg=0
		inform 2,"No jump address supplied!"
	endif

	dc.b $FC
	z80word \off
    endm

ret	macro cond
	if narg=0
		dc.b $C9
	else
		ret\cond
	endif
    endm

retnz	macro
	dc.b $C0
    endm

retz	macro
	dc.b $C8
    endm

retnc	macro
	dc.b $D0
    endm

retc	macro
	dc.b $D8
    endm

retpo	macro
	dc.b $E0
    endm

retpe	macro
	dc.b $E8
    endm

retp	macro
	dc.b $F0
    endm

retm	macro
	dc.b $F8
    endm

di	macro
		move	#$2700,sr	; THIS IS HERE, IF YOU WANNA USE DI IN 68K CODE ;)
    endm

ei	macro
		move	#$2300,sr	; THIS IS HERE, IF YOU WANNA USE EI IN 68K CODE ;)
    endm

halt	macro
		stop	#$2700		; THIS IS HERE, IF YOU WANNA USE HALT IN 68K CODE ;)
    endm

znop	macro
	dc.b $00
    endm

rlca	macro
	dc.b $07
    endm

rla	macro
	dc.b $17
    endm

daa	macro
	dc.b $27
    endm

scf	macro
	dc.b $37
    endm

rrca	macro
	dc.b $0F
    endm

rra	macro
	dc.b $1F
    endm

cpl	macro
	dc.b $2F
    endm

ccf	macro
	dc.b $3F
    endm

exx	macro
	dc.b $D9
    endm

zneg	macro
	dc.b $ED, $44
    endm

retn	macro
	dc.b $ED, $45
    endm

reti	macro
	dc.b $ED, $4D
    endm

rrd	macro
	dc.b $ED, $67
    endm

rld	macro
	dc.b $ED, $6F
    endm

ldi	macro
	dc.b $ED, $A0
    endm

cpi	macro
	dc.b $ED, $A1
    endm

ini	macro
	dc.b $ED, $A2
    endm

outi	macro
	dc.b $ED, $A3
    endm

ldd	macro
	dc.b $ED, $A8
    endm

cpd	macro
	dc.b $ED, $A9
    endm

ind	macro
	dc.b $ED, $AA
    endm

outd	macro
	dc.b $ED, $AB
    endm

ldir	macro
	dc.b $ED, $B0
    endm

cpir	macro
	dc.b $ED, $B1
    endm

inir	macro
	dc.b $ED, $B2
    endm

otir	macro
	dc.b $ED, $B3
    endm

lddr	macro
	dc.b $ED, $B8
    endm

cpdr	macro
	dc.b $ED, $B9
    endm

indr	macro
	dc.b $ED, $BA
    endm

otdr	macro
	dc.b $ED, $BB
    endm
