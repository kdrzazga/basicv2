1 e=0:ez=0:do=0:printchr$(147):print"1 - dezimalzahl eingeben":print"2 - e-zahl eingeben"2 input x:on x goto 3,43 input "zahl";a:goto 54 input "e-zahl";a$:a$=" "+a$:la=len(a$):goto 65 a$=str$(a):la=len(a$)6 fori=1tola:ifmid$(a$,i,1)="e"thene=1:ez=i:v$=mid$(a$,i+1,1):z=val(mid$(a$,i+2,2))7 next i8 if e=0 then print "zahl ist keine e-zahl.":end9 if x=2 then 1210 if v$="+" then gosub 500:print a:print c$:end11 gosub 800:print a:print c$:end12 if v$="+" then gosub 500:print a$:print c$:end13 gosub 800:print a$:print c$:end500 s1$=mid$(a$,1,ez-1)501 for i=1 to la502 if mid$(a$,i,1)="." then do=i+1503 next i504 for i=1 to z-ez+do:s2$=s2$+"0":next i505 s3$=s1$+s2$506 if do<>0 then 600508 b$=s3$+"000":goto 610600 s4$=mid$(s3$,1,do-2):s5$=mid$(s3$,do,len(s3$))603 b$=s4$+s5$610 gosub 1000:lb=len(b$)611 if mo=0 then gosub 700:return612 if mo=1 then gosub 730:return613 if mo=2 then gosub 760:return620 return700 for i=2 to lb step 3:c$=c$+mid$(b$,i,3)+".":next i701 c$=mid$(c$,1,len(c$)-1):return : rem 900.000.000730 for i=3 to lb step 3:c$=c$+mid$(b$,i,3)+".":next i731 c$=mid$(b$,1,2)+"."+mid$(c$,1,len(c$)-1):return : rem 9.000.000.000760 for i=4 to lb step 3:c$=c$+mid$(b$,i,3)+".":next i761 c$=mid$(b$,1,3)+"."+mid$(c$,1,len(c$)-1):return : rem 900.000.000.000800 c$="0."802 for i=1 to la803 if mid$(a$,i,1)="." then do=i+1804 next i805 if do<>0 then 810806 s1$=mid$(a$,2,ez-2)807 for i=1 to z-1:s2$=s2$+"0":next i808 c$=c$+s2$+s1$:return810 s1$=mid$(a$,2,do-3)+mid$(a$,do,ez-4)811 for i=1 to z-1:s2$=s2$+"0":next i812 c$=c$+s2$+s1$1000 lb=len(b$)-1:rem modulo1001 mo=lb-(int(lb/3)*3)1002 return