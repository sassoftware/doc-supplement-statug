/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIEX16                                              */
/*   TITLE: Documentation Example 16 for PROC MI                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple imputation                                 */
/*   PROCS: MI                                                  */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MI, EXAMPLE 16                                 */
/*    MISC:                                                     */
/****************************************************************/

data Fcs1;
   do Trt=0 to 1;
   do j=1 to 5;
      y0=10 + rannor(99);
      y1= y0 + 0.9*Trt + rannor(99);
      y2= y0 + 0.9*Trt + rannor(99);
      if (ranuni(99) < 0.3) then y1=.;
      else if (ranuni(99) < 0.3) then y2=.;
      output;
   end; end;
   do Trt=0 to 1;
   do j=1 to 45;
      y0=10 + rannor(99);
      y1= y0 + 0.9*Trt + rannor(99);
      y2= y0 + 0.9*Trt + rannor(99);
      if (ranuni(99) < 0.3) then y1=.;
      else if (ranuni(99) < 0.3) then y2=.;
      output;
   end; end;
   drop j;
run;

proc print data=Fcs1(obs=10);
   var Trt Y0 Y1 Y2;
   title 'First 10 Obs in the Trial Data';
run;

proc mi data=Fcs1 seed=52387 out=outex16;
   class Trt;
   fcs nbiter=25 reg( /details);
   mnar adjust( y1 /shift=-0.4 adjustobs=(Trt='1'))
        adjust( y2 /shift=-0.5 adjustobs=(Trt='1'));
   var Trt y0 y1 y2;
run;

proc print data=outex16(obs=10);
   var _Imputation_ Trt y0 y1 y2;
   title 'First 10 Observations of the Imputed Data Set';
run;
