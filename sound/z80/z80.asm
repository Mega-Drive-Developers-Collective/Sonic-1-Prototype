		include "LANG.ASM"
		org 0
		z80prog 0

Z80Start:
                di
                di
                di
                ld      sp, 1FF4h
                xor     a
                ld      (1FFDh), a
                ld      a, (1FFBh)
                rlca
                ld      (6000h), a
                ld      b, 8
                ld      a, (1FFAh)

BnkSwitchLoop:                          ; CODE XREF: ROM:001A↓j
                ld      (6000h), a
                rrca
                djnz    BnkSwitchLoop
                jr      CheckSamples
; ---------------------------------------------------------------------------
DeltaArray:     db 0, 1, 2, 4, 8, 10h, 20h, 40h, 80h, 0FFh, 0FEh, 0FCh
                db 0F8h, 0F0h, 0E0h, 0C0h
; ---------------------------------------------------------------------------

CheckSamples:                           ; CODE XREF: ROM:001C↑j
                                        ; ROM:0158↓j ...
                ld      hl, 1FFFh

WaitDACLoop:                            ; CODE XREF: ROM:0033↓j
                                        ; ROM:00F2↓j
                ld      a, (hl)
                zor     a
                jp      p, WaitDACLoop
                push    af
                push    hl
                ld      a, 80h
                ld      (1FFDh), a
                ld      hl, 4000h
                ld      (hl), 2Bh ; '+'
                inc     hl
                ld      (hl), 80h
                xor     a
                ld      (1FFDh), a
                dec     hl
                ld      ix, 1FFCh
                ld      d, 0
                exx
                pop     hl
                ld      (1FF6h), a
                pop     af
                ld      (1FF7h), a
                zsub     81h
                ld      (hl), a
                ld      de, 0
                ld      iy, 160h
                cp      6
                jr      c, loc_73
                ld      (1FF7h), a
                ld      (1FF6h), a
                ld      iy, (1FF8h)
                zsub     7

loc_73:                                 ; CODE XREF: ROM:0065↑j
                zadd     a, a
                zadd     a, a
                ld      c, a
                zadd     a, a
                zadd     a, c
                ld      c, a
                ld      b, 0
                zadd     iy, bc
                ld      e, (iy+0)
                ld      d, (iy+1)
                ld      a, (1FF7h)
                zor      a
                jp      m, loc_8F
                ld      hl, (1FF8h)
                zadd     hl, de
                ex      de, hl

loc_8F:                                 ; CODE XREF: ROM:0087↑j
                ld      c, (iy+2)
                ld      b, (iy+3)
                ld      a, (iy+4)
                ld      (1FFEh), a
                exx
                ld      c, 80h
                exx

loc_9F:                                 ; CODE XREF: ROM:00F9↓j
                                        ; ROM:0130↓j ...
                ld      hl, 1FFFh
                ld      a, (de)
                zand     0F0h
                rrca
                rrca
                rrca
                rrca
                zadd     a, 1Eh
                exx
                ld      e, a
                ld      a, (de)
                zadd     a, c
                ld      c, a
                ld      a, 80h
                ld      (1FFDh), a
                ld      b, (iy+0Bh)

loc_B8:                                 ; CODE XREF: ROM:00BA↓j
                bit     7, (hl)
                jr      nz, loc_B8
                ld      (hl), 2Ah ; '*'
                inc     hl
                xor     a
                ld      (hl), c
                ld      (1FFDh), a
                dec     hl

loc_C5:                                 ; CODE XREF: ROM:loc_C5↓j
                djnz    *
                exx
                ld      a, (de)
                zand     0Fh
                zadd     a, 1Eh
                exx
                ld      e, a
                ld      a, (de)
                zadd     a, c
                ld      c, a
                ld      a, 80h
                ld      (1FFDh), a
                ld      b, (iy+0Bh)

loc_DA:                                 ; CODE XREF: ROM:00DC↓j
                bit     7, (hl)
                jr      nz, loc_DA
                ld      (hl), 2Ah ; '*'
                inc     hl
                xor     a
                ld      (hl), c
                ld      (1FFDh), a
                dec     hl

loc_E7:                                 ; CODE XREF: ROM:loc_E7↓j
                djnz    *
                exx
                bit     7, (iy+5)
                jr      nz, loc_F5
                bit     7, (hl)
                jp      nz, WaitDACLoop

loc_F5:                                 ; CODE XREF: ROM:00EE↑j
                inc     de
                dec     bc
                ld      a, c
                zor      b
                jp      nz, loc_9F
                ld      a, (1FFEh)
                zor      a
                jp      z, loc_153
                exx
                jp      p, loc_10C
                zand     7Fh
                ld      (ix+0), c

loc_10C:                                ; CODE XREF: ROM:0104↑j
                dec     a
                ld      (1FFEh), a
                jr      z, loc_133
                ld      c, (ix+0)
                exx
                ld      l, (iy+6)
                ld      h, (iy+7)
                ld      b, h
                ld      c, l
                ld      e, (iy+0)
                ld      d, (iy+1)
                ld      hl, (1FF8h)
                zadd     hl, de
                ld      e, (iy+2)
                ld      d, (iy+3)
                zadd     hl, de
                ex      de, hl
                jp      loc_9F
; ---------------------------------------------------------------------------

loc_133:                                ; CODE XREF: ROM:0110↑j
                ld      c, (ix+0)
                exx
                ld      c, (iy+8)
                ld      b, (iy+9)
                ld      l, (iy+2)
                ld      h, (iy+3)
                ld      e, (iy+0)
                ld      d, (iy+1)
                zadd     hl, de
                ld      de, (1FF8h)
                zadd     hl, de
                ex      de, hl
                jp      loc_9F
; ---------------------------------------------------------------------------

loc_153:                                ; CODE XREF: ROM:0100↑j
                ld      hl, 1FF6h
                ld      a, (hl)
                zor      a
                jp      m, CheckSamples
                xor     a
                ld      (hl), a
                jp      CheckSamples
; ---------------------------------------------------------------------------
DACList:        dw dacKick
                dw (dacKick_End-dacKick)
                dw 0
                dw 0
                dw 0
                db 0
                db 14h
                dw dacSnare
                dw (dacSnare_End-dacSnare)
                dw 0
                dw 0
                dw 0
                db 0
                db 1
                dw dacTimpani
                dw (dacTimpani_End-dacTimpani)
                dw 0
                dw 0
                dw 0
                db 0
TimpaniPitch:   db 1Bh
dacKick:	incbin "sound/Z80/Kick.dac"
dacKick_End:	even
dacSnare:       incbin "sound/Z80/Snare.dac"
dacSnare_End:	even
dacTimpani:     incbin "sound/Z80/Timpani.dac"
dacTimpani_End:	even
EndOfDriver:
		inform 0,"The timpani pitch byte is %s", "$A00000+\$TimpaniPitch"
		inform 0,"Remember to set that in loc_74328."

		z80prog