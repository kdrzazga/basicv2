100 GRON 320,200:BUFFERMODE 1
400 FOR W = 0 TO 4*3.1415 STEP 0.05
405 COLOR 0,0,0:CLEAR:COLOR 255,255,255
410 A=0:B=0:C=0
420 F1 = 20 : F2 = 5 : F3 = 8
430 V1 = 160 : V2 = 100
440 CO = COS(W) : SI = SIN(W)
610 SY=-0.5 : SX=-0.05 
620 FOR CT=1 TO 2 
630 FOR YR=3 TO -4 STEP SY
640 FOR XR=3 TO -3 STEP SX
650 ZR=YR*YR-XR*XR 
660 X=F1*(A+XR) + F3*(YR+C)*CO + V1
670 Y=F2*(B+ZR) + F3*(YR+C)*SI + V2
680 PLOT X,Y
690 NEXT XR,YR
700 SY=-0.05 : SX=-0.5
710 NEXT CT
750 FLIP:LIMIT 40
800 NEXT W
1000 GROFF

