/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SURPHCLT                                            */
/*   TITLE: Time and CLASS Usage                                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Time Variable, CLASS Variable, Time-Dependent       */
/*   PROCS: SURVEYPHREG                                         */
/*    DATA:                                                     */
/*     REF: PROC SURVEYPHREG, Time and CLASS                    */
/*    MISC:                                                     */
/****************************************************************/

data Test;
   input T Status A W S @@;
   MirrorT = T;
   datalines;
 23    1    1   10   1    7    0   1   20   2
 23    1    1   10   1   10    1   1   20   2
 20    0    1   10   1   13    0   1   20   2
 24    1    1   10   1   10    1   1   20   2
 18    1    2   10   1    6    1   2   20   2
 18    0    2   10   1    6    1   2   20   2
 13    0    2   10   1   13    1   2   20   2
  9    0    2   10   1   15    1   2   20   2
  8    1    3   10   1    6    1   3   20   2
 12    0    3   10   1    4    1   3   20   2
 11    1    3   10   1    8    1   1   20   2
  6    1    3   10   1    7    1   3   20   2
  7    1    3   10   1   12    1   3   20   2
  9    1    2   10   1   15    1   2   20   2
  3    1    2   10   1   14    0   3   20   2
  6    1    1   10   1   13    1   2   20   2
;

proc surveyphreg data=Test;
   weight W;
   strata S;
   class A;
   model T*Status(0)=A;
run;

proc surveyphreg data=Test;
   weight W;
   strata S;
   class A;
   model T*Status(0)=A;
   if A=3 then A=2;
run;

proc surveyphreg data=Test;
   class A;
   model T*Status(0)=A X;
   X=T*A;
run;

proc surveyphreg data=Test;
   class A;
   model T*Status(0)=A X1 X2;
   X1= T*(A=1);
   X2= T*(A=2);
run;
