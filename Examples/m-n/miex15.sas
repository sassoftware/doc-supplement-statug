/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIEX15                                              */
/*   TITLE: Documentation Example 15 for PROC MI                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple imputation                                 */
/*   PROCS: MI                                                  */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MI, EXAMPLE 15                                 */
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

proc mi data=Mono1 seed=14823 nimpute=15 out=outex15;
   class Trt;
   monotone reg (/details);
   mnar model( y1 / modelobs= (Trt='0'));
   var y0 y1;
run;

proc print data=outex15(obs=10);
   title 'First 10 Observations of the Imputed Data Set';
run;
