/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIANAX12                                            */
/*   TITLE: Documentation Example 12 for PROC MIANALYZE         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple imputation                                 */
/*   PROCS: MI, MIANALYZE, REG                                  */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MIANALYZE, EXAMPLE 12                          */
/*    MISC:                                                     */
/****************************************************************/

data Mono1;
   do Trt=0 to 1;
   do j=1 to 5;
      y0=10 + rannor(999);
      y1= y0 + Trt + rannor(999);
      if (ranuni(999) < 0.3) then y1=.;
      output;
   end; end;

   do Trt=0 to 1;
   do j=1 to 45;
      y0=10 + rannor(999);
      y1= y0 + Trt + rannor(999);
      if (ranuni(999) < 0.3) then y1=.;
      output;
   end; end;
   drop j;
run;

proc print data=Mono1(obs=10);
   var Trt Y0 Y1;
   title 'First 10 Obs in the Trial Data';
run;

proc mi data=Mono1 seed=14823 nimpute=20 out=outex12a;
   class Trt;
   monotone reg;
   var Trt y0 y1;
run;

ods select none;
proc reg data=outex12a;
   model y1= Trt y0;
   by  _Imputation_;
   ods output parameterestimates=regparms;
run;
ods select all;

proc mianalyze parms=regparms;
   modeleffects Trt;
run;

proc mi data=Mono1 seed=14823 nimpute=20 out=outex12b;
   class Trt;
   monotone reg;
   mnar model( y1 /modelobs=(Trt='0'));
   var y0 y1;
run;

ods select none;
proc reg data=outex12b;
   model y1= Trt y0;
   by _Imputation_;
   ods output parameterestimates=regparms;
run;
ods select all;

proc mianalyze parms=regparms;
   modeleffects Trt;
run;
