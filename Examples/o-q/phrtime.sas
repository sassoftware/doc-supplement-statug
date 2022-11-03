/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PHRTIME                                             */
/*   TITLE: Clarification of PROC PHREG Time and CLASS Usage    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Time Variable, CLASS Variable, Time-Dependent       */
/*   PROCS: PHREG                                               */
/*    DATA:                                                     */
/*     REF: SAS/STAT User's Guide, PROC PHREG Chapter           */
/*    MISC:                                                     */
/****************************************************************/

data Test;
   input T Status A @@;
   MirrorT = T;
   datalines;
 23        1      1    7        0      1
 23        1      1   10        1      1
 20        0      1   13        0      1
 24        1      1   10        1      1
 18        1      2    6        1      2
 18        0      2    6        1      2
 13        0      2   13        1      2
  9        0      2   15        1      2
  8        1      3    6        1      3
 12        0      3    4        1      3
 11        1      3    8        1      1
  6        1      3    7        1      3
  7        1      3   12        1      3
  9        1      2   15        1      2
  3        1      2   14        0      3
  6        1      1   13        1      2
;

proc phreg data=Test;
   class A;
   model T*Status(0)=T*A;
run;

proc phreg data=Test;
   class A;
   model T*Status(0)=A*MirrorT;
run;

proc phreg data=Test;
   class A;
   model T*Status(0)=A;
run;

proc phreg data=Test;
   class A;
   model T*Status(0)=A;
   if A=3 then A=2;
run;

proc phreg data=Test;
   class A;
   model T*Status(0)=A X;
   X=T*A;
run;

proc phreg data=Test;
   class A;
   model T*Status(0)=A X1 X2;
   X1= T*(A=1);
   X2= T*(A=2);
run;
