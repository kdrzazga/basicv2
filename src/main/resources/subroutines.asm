;###################################
START		RTS

;###################################
END			RTS

;###################################
REALOUT		LDA #<X_REG
			LDY #>X_REG
			JSR $BBA2
			JSR $BDDD
			JSR $B487
			JSR $AB21
			JSR $AB3B
			RTS

;###################################
REALOUTBRK  LDA #<X_REG
			LDY #>X_REG
			JSR $BBA2
			JSR $BDDD
			JSR $B487
			JSR $AB21
			JSR $AB3B
LINEBREAK	LDA #$0D
			JSR $FFD2
			RTS

;###################################
ARRAYACCESS_INTEGER
			LDA G_REG
			STA TMP_ZP
			LDA G_REG+1
			STA TMP_ZP+1
INTARRAY2	LDA #<X_REG
			LDY #>X_REG
			JSR $BBA2
			JSR $B1AA
			TAX
			TYA
			ASL
			STA TMP2_ZP
			TXA
			ROL
			STA TMP2_ZP+1
			LDA TMP_ZP
			CLC
			ADC #3
			BCC NOPV2AAI
			INC TMP_ZP+1
NOPV2AAI	CLC
			ADC TMP2_ZP
			STA TMP_ZP
			LDA TMP_ZP+1
			ADC TMP2_ZP+1
			STA TMP_ZP+1
			LDY #1
			LDA (TMP_ZP),Y
			TAX
			DEY
			LDA (TMP_ZP),Y
			TAY
			TXA
			JSR $B391
			LDX #<X_REG
			LDY #>X_REG
			; FAC to (X/Y)
			JSR $BBD7
			RTS
; #######
ARRAYACCESS_REAL
			LDA G_REG
			STA TMP_ZP
			LDA G_REG+1
			STA TMP_ZP+1
REALARRAY2	LDA #<X_REG
			LDY #>X_REG
			JSR $BBA2
			JSR $B1AA
			STY TMP3_ZP
			STA TMP3_ZP+1
			TAX
			TYA
			ASL
			TAY
			TXA
			ROL
			TAX
			TYA
			ASL
			STA TMP2_ZP
			TXA
			ROL
			STA TMP2_ZP+1
			LDA TMP_ZP
			CLC
			ADC #3
			BCC NOPV2AAR
			INC TMP_ZP+1
NOPV2AAR	CLC
			ADC TMP3_ZP
			STA TMP_ZP
			LDA TMP_ZP+1
			ADC TMP3_ZP+1
			STA TMP_ZP+1
			LDA TMP_ZP
			CLC
			ADC TMP2_ZP
			STA TMP3_ZP
			LDA TMP_ZP+1
			ADC TMP2_ZP+1
			STA TMP3_ZP+1
			LDX #<X_REG
			STX TMP_ZP
			LDY #>X_REG
			STY TMP_ZP+1
			JSR COPY3_XY
			RTS

;###################################
ARRAYSTORE_INTEGER
			LDA G_REG
			STA TMP_ZP
			LDA G_REG+1
			STA TMP_ZP+1
INTARRAY1	LDA #<X_REG
			LDY #>X_REG
			JSR $BBA2
			JSR $B1AA
			TAX
			TYA
			ASL
			STA TMP2_ZP
			TXA
			ROL
			STA TMP2_ZP+1
			LDA TMP_ZP
			CLC
			ADC #3
			BCC NOPV2ASI
			INC TMP_ZP+1
NOPV2ASI	CLC
			ADC TMP2_ZP
			STA TMP_ZP
			LDA TMP_ZP+1
			ADC TMP2_ZP+1
			STA TMP_ZP+1
			LDA #<Y_REG
			LDY #>Y_REG
			JSR $BBA2
			JSR $B1AA
			STY TMP3_ZP
			LDY #1
			STA (TMP_ZP),Y
			DEY
			LDA TMP3_ZP
			STA (TMP_ZP),Y
			RTS
; #######
ARRAYSTORE_REAL
			LDA G_REG
			STA TMP_ZP
			LDA G_REG+1
			STA TMP_ZP+1
REALARRAY1	LDA #<X_REG
			LDY #>X_REG
			JSR $BBA2
			JSR $B1AA
			STY TMP3_ZP
			STA TMP3_ZP+1
			TAX
			TYA
			ASL
			TAY
			TXA
			ROL
			TAX
			TYA
			ASL
			STA TMP2_ZP
			TXA
			ROL
			STA TMP2_ZP+1
			LDA TMP_ZP
			CLC
			ADC #3
			BCC NOPV2ASR
			INC TMP_ZP+1
NOPV2ASR	CLC
			ADC TMP3_ZP
			STA TMP_ZP
			LDA TMP_ZP+1
			ADC TMP3_ZP+1
			STA TMP_ZP+1
			LDA TMP_ZP
			CLC
			ADC TMP2_ZP
			STA TMP_ZP
			LDA TMP_ZP+1
			ADC TMP2_ZP+1
			STA TMP_ZP+1
			LDA #<Y_REG
			STA TMP3_ZP
			LDY #>Y_REG
			STY TMP3_ZP+1
			JSR COPY3_XY
			RTS

;###################################
INITFOR		LDA FORSTACKP
			STA TMP_ZP
			LDA FORSTACKP+1
			STA TMP_ZP+1
			LDY #0
			LDA A_REG
			STA (TMP_ZP),Y
			INY
			LDA A_REG+1
			STA (TMP_ZP),Y
			INY
			LDA JUMP_TARGET
			STA (TMP_ZP),Y
			INY
			LDA JUMP_TARGET+1
			STA (TMP_ZP),Y
			INY
			STY TMP3_ZP
			JSR INCTMPZP
			JSR POPREAL
			LDX TMP_ZP
			LDY TMP_ZP+1
			; FAC to (X/Y)
			JSR $BBD7
			JSR $BC2B
			STA TMP_FLAG
			LDY #5
			STY TMP3_ZP
			JSR INCTMPZP
			JSR POPREAL
			LDX TMP_ZP
			LDY TMP_ZP+1
			; FAC to (X/Y)
			JSR $BBD7
			LDY #5
			STY TMP3_ZP
			JSR INCTMPZP
			LDY #0
			LDA TMP_FLAG
			STA (TMP_ZP),Y
			INY
			LDA #1
			STA (TMP_ZP),Y
			INY
			LDA #15
			STA (TMP_ZP),Y
			LDY #3
			STY TMP3_ZP
			JSR INCTMPZP
			LDA TMP_ZP
			STA FORSTACKP
			LDA TMP_ZP+1
			STA FORSTACKP+1
			RTS

;###################################
NEXT		LDA FORSTACKP
			STA TMP_ZP
			LDA FORSTACKP+1
			STA TMP_ZP+1
SEARCHFOR	LDA TMP_ZP
			STA TMP3_REG
			LDA TMP_ZP+1
			STA TMP3_REG+1
			LDA #2
			STA TMP3_ZP
			JSR DECTMPZP
			LDY #0
			LDA (TMP_ZP),Y
			BNE NOGOSUB
			BRK
NOGOSUB
			INY
			LDA (TMP_ZP),Y
			STA TMP3_ZP
			JSR DECTMPZP
			DEY
			LDA A_REG
			BEQ LOW0
CMPFOR		CMP (TMP_ZP),Y
			BNE SEARCHFOR
			LDA A_REG+1
			INY
			CMP (TMP_ZP),Y
			BEQ FOUNDFOR
			JMP SEARCHFOR
LOW0		LDX A_REG+1
			BEQ FOUNDFOR
			JMP CMPFOR
FOUNDFOR	LDA TMP_ZP
			STA TMP2_REG
			LDA TMP_ZP+1
			STA TMP2_REG+1
VARREAL
			LDY #0
			STY A_REG+1 ; Has to be done anyway...so we can do it here as well
			LDA (TMP_ZP),Y
			TAX
			INY
			LDA (TMP_ZP),Y
			TAY
			TXA
			JSR $BBA2

CALCNEXT	LDA TMP_ZP
			CLC
			ADC #4
			STA TMP_ZP
			BCC NOPV2IN
			INC TMP_ZP+1
NOPV2IN		STA TMP_REG
			LDY TMP_ZP+1
			STY TMP_REG+1
			JSR $B867   ;M-ADD

			LDA TMP2_REG
			STA TMP_ZP
			LDA TMP2_REG+1
			STA TMP_ZP+1
STOREREAL
			LDY #0
			LDA (TMP_ZP),Y
			TAX
			INY
			LDA (TMP_ZP),Y
			TAY
			JSR $BBD7	;FAC TO (X/Y)

CMPFOR		LDA #5
			STA TMP3_ZP
			JSR INCTMPREG
			LDA TMP_REG
			LDY TMP_REG+1
			JSR $BC5B 	;CMPFAC
			BEQ LOOPING

			PHA
			LDY #14
			LDA (TMP_ZP),Y
			BEQ STEPZERO
			ROL
STEPZERO	BCC STEPPOS
STEPNEG		PLA
			ROL
			BCC LOOPING
			JMP EXITLOOP

STEPPOS		PLA
			ROL
			BCC EXITLOOP
			JMP LOOPING

LOOPING		LDA TMP3_REG
			STA FORSTACKP
			LDA TMP3_REG+1
			STA FORSTACKP+1
			LDA TMP2_REG
			CLC
			ADC #2
			STA TMP2_REG
			BCC NOPV4IN
			INC TMP2_REG+1
NOPV4IN		LDY #0
			STY A_REG
			STA TMP_ZP
			LDA TMP2_REG+1
			STA TMP_ZP+1
			LDA (TMP_ZP),Y
			STA JUMP_TARGET
			INY
			LDA (TMP_ZP),Y
			STA JUMP_TARGET+1
			RTS

EXITLOOP	LDA TMP2_REG
			STA FORSTACKP
			LDA TMP2_REG+1
			STA FORSTACKP+1
			LDA #1
			STA A_REG
			RTS

;###################################
RETURN		LDA FORSTACKP
			STA TMP_ZP
			LDA FORSTACKP+1
			STA TMP_ZP+1
SEARCHGOSUB	LDA #2
			STA TMP3_ZP
			JSR DECTMPZP
			LDY #0
			LDA (TMP_ZP),Y
			BEQ FOUNDGOSUB
			INY
			LDA (TMP_ZP),Y
			STA TMP3_ZP
			JSR DECTMPZP
			JMP SEARCHGOSUB
FOUNDGOSUB
			LDA TMP_ZP
			STA FORSTACKP
			LDA TMP_ZP+1
			STA FORSTACKP+1
			RTS

;###################################
GOSUB		LDA FORSTACKP
			STA TMP_ZP
			LDA FORSTACKP+1
			STA TMP_ZP+1
			LDY #0
			LDA #0
			STA (TMP_ZP),Y
			INY
			STA (TMP_ZP),Y
			INY
			STY TMP3_ZP
			JSR INCTMPZP
			LDA TMP_ZP
			STA FORSTACKP
			LDA TMP_ZP+1
			STA FORSTACKP+1
			RTS

;###################################
COMPACT		RTS

;###################################
GETSTR		RTS

;###################################
SEQ			RTS

;###################################
READNUMBER	RTS

;###################################
PUSHREAL	LDX FPSTACKP
			LDY FPSTACKP+1
			JSR $BBD7
			LDA FPSTACKP
			CLC
			ADC #5
			STA FPSTACKP
			BCC NOPVPUR
			INC FPSTACKP+1
NOPVPUR		RTS

;###################################
PUSHINT		LDX FPSTACKP
			STX TMP2_ZP
			LDX FPSTACKP+1
			STX TMP2_ZP+1
			LDA TMP_ZP
			LDY #0
			STA (TMP2_ZP),Y
			LDA TMP_ZP+1
			INY
			STA (TMP2_ZP),Y
			LDA TMP2_ZP
			CLC
			ADC #2
			STA FPSTACKP
			LDA TMP2_ZP+1
			ADC #0
			STA FPSTACKP+1
			RTS

;###################################
POPREAL		LDA FPSTACKP
			SEC
			SBC #5
			STA FPSTACKP
			BCS NOPVPR
			DEC FPSTACKP+1
NOPVPR		LDA FPSTACKP
			LDY FPSTACKP+1
			JSR $BBA2
			RTS

;###################################
POPINT		LDA FPSTACKP
			SEC
			SBC #2
			STA FPSTACKP
			LDA FPSTACKP+1
			SBC #0
			STA FPSTACKP+1
			LDX FPSTACKP
			STX TMP2_ZP
			LDX FPSTACKP+1
			STX TMP2_ZP+1
			LDY #0
			LDA (TMP2_ZP),Y
			STA TMP_ZP
			INY
			LDA (TMP2_ZP),Y
			STA TMP_ZP+1
			RTS
			
;### HELPER #######################
;###################################
DECTMPZP    LDA TMP_ZP
			SEC
			SBC TMP3_ZP
			STA TMP_ZP
			BCS NOPV1
			DEC TMP_ZP+1
NOPV1		RTS

;###################################
INCTMPZP	LDA TMP_ZP
			CLC
			ADC TMP3_ZP
			STA TMP_ZP
			BCC NOPV2
			INC TMP_ZP+1
NOPV2		RTS

;###################################
INCTMPREG	LDA TMP_REG
			CLC
			ADC TMP3_ZP
			STA TMP_REG
			BCC NOPV3
			INC TMP_REG+1
NOPV3		RTS

;###################################
INCTMP2REG	LDA TMP2_REG
			CLC
			ADC TMP3_ZP
			STA TMP2_REG
			BCC NOPV4
			INC TMP2_REG+1
NOPV4		RTS
;###################################
STORE_AY	STA TMP3_ZP
			STY TMP3_ZP+1
			RTS
;###################################
COPY2_XY	STX TMP_ZP
			STY TMP_ZP+1
COPY3_XY	LDY #0
			LDA (TMP3_ZP),Y
			STA (TMP_ZP),Y
			INY
			LDA (TMP3_ZP),Y
			STA (TMP_ZP),Y
			INY
			LDA (TMP3_ZP),Y
			STA (TMP_ZP),Y
			INY
			LDA (TMP3_ZP),Y
			STA (TMP_ZP),Y
			INY
			LDA (TMP3_ZP),Y
			STA (TMP_ZP),Y
			RTS
;###################################


