/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PLANEX4                                             */
/*   TITLE: Example 4 for PROC PLAN                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Latin square design, orthogonal array               */
/*   PROCS: PLAN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PLAN, EXAMPLE 4.                               */
/*    MISC:                                                     */
/****************************************************************/

/* A Latin square design ---------------------------------------*/
title 'Latin Square Design';
proc plan seed=37430;
   factors Row=4 ordered Col=4 ordered / noprint;
   treatments Tmt=4 cyclic;
   output out=LatinSquare
          Row cvals=('Day 1' 'Day 2' 'Day 3' 'Day 4') random
          Col cvals=('Lab 1' 'Lab 2' 'Lab 3' 'Lab 4') random
          Tmt nvals=(      0     100     250     450) random;
quit;
proc sort data=LatinSquare out=LatinSquare;
   by Row Col;
run;
proc transpose data= LatinSquare(rename=(Col=_NAME_))
               out =tLatinSquare(drop=_NAME_);
   by Row;
   var Tmt;
run;
proc print data=tLatinSquare noobs;
run;
data Unrandomized;
   do Row = 1 to 4;
      do Col = 1 to 4;
         input Tmt @@;
         output;
      end;
   end;
   datalines;
1 2 3 4
2 1 4 3
3 4 1 2
4 3 2 1
;
proc plan seed=37430;
   factors Row = 4;
   output data=  Unrandomized  out=Randomized1;
run;
   factors Col = 4;
   output data=  Randomized1   out=Randomized2;
run;
   factors Tmt = 4;
   output data=  Randomized2   out=Randomized3;
run;

proc sort data=Randomized3;
   by Row Col;
run;
proc transpose data= Randomized3 out =tLatinSquare2(drop=_NAME_);
   by Row;
   var Tmt;
run;
proc print data=tLatinSquare2 noobs;
run;
