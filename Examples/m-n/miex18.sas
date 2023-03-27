/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIEX18                                              */
/*   TITLE: Documentation Example 18 for PROC MI                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple imputation                                 */
/*   PROCS: MI                                                  */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MI, EXAMPLE 18                                 */
/*    MISC:                                                     */
/****************************************************************/

data Mono3;
   do Trt=0 to 1;
   do j=1 to 5;
      y0=10 + rannor(999);
      y1= y0 + 0.9*Trt + rannor(999);
      if (ranuni(999) < 0.3) then y1=.;
      output;
   end; end;
   do Trt=0 to 1;
   do j=1 to 45;
      y0=10 + rannor(999);
      y1= y0 + 0.9*Trt + rannor(999);
      if (ranuni(999) < 0.3) then y1=.;
      output;
   end; end;
   drop j;
run;

proc print data=mono3(obs=10);
   var Trt Y0 Y1;
   title 'First 10 Obs in the Trial Data';
run;

proc iml;

   nimpute= 10;
   call randseed( 15323);
   mean= { -0.5 -1};
   cov= { 0.01 0.001 , 0.001 0.01};

  /*---- Simulate nimpute bivariate normal variates ----*/
   d= randnormal( nimpute, mean, cov);

   impu= j(nimpute, 1, 0);
   do j=1 to nimpute;  impu[j,]= j;  end;
   delta= impu || d;

  /*--- Output shift parameters for groups ----*/
   create parm1 from delta[colname={_Imputation_ Shift_C Shift_T}];
   append from delta;
quit;

proc print data=parm1;
   var _Imputation_ Shift_C Shift_T;
   title 'Shift Parameters for Imputations';
run;

proc mi data=Mono3 seed=1423741 nimpute=10 out=outex18;
   class Trt;
   monotone reg;
   mnar adjust( y1 / adjustobs=(Trt='0') parms(shift=shift_c)=parm1)
        adjust( y1 / adjustobs=(Trt='1') parms(shift=shift_t)=parm1);
   var Trt y0 y1;
run;

proc print data=outex18(obs=10);
   var _Imputation_ Trt Y0 Y1;
   title 'First 10 Observations of the Imputed Data Set';
run;

