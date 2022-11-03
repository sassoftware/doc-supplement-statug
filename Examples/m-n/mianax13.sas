/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIANAX13                                            */
/*   TITLE: Documentation Example 13 for PROC MIANALYZE         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple imputation                                 */
/*   PROCS: MI, MIANALYZE, REG                                  */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MIANALYZE, EXAMPLE 13                          */
/*    MISC:                                                     */
/****************************************************************/

data Mono2;
   do Trt=0 to 1;
   do j=1 to 5;
      y0=10 + rannor(99);
      y1= y0 + 0.75*Trt + rannor(99);
      if (ranuni(99) < 0.3) then y1=.;
      output;
   end; end;
   do Trt=0 to 1;
   do j=1 to 45;
      y0=10 + rannor(99);
      y1= y0 + 0.75*Trt + rannor(99);
      if (ranuni(99) < 0.3) then y1=.;
      output;
   end; end;
   drop j;
run;

proc print data=mono2(obs=10);
   var Trt Y0 Y1;
   title 'First 10 Obs in the Trial Data';
run;

proc mi data=Mono2 seed=14823 out=outmi;
   class Trt;
   monotone reg;
   var Trt y0 y1;
run;

ods select none;
proc reg data=outmi;
   model y1= Trt y0;
   by  _Imputation_;
   ods output parameterestimates=regparms;
run;
ods select all;

proc mianalyze parms=regparms;
   modeleffects Trt;
run;

/*---------------------------------------------------------*/
/*--- Performs multiple imputation analysis             ---*/
/*--- for specified shift parameters:                   ---*/
/*--- data= input data set                              ---*/
/*--- smin= min shift parameter                         ---*/
/*--- smax= max shift parameter                         ---*/
/*--- sinc= increment of the shift parameter            ---*/
/*--- outparms= output reg parameters                   ---*/
/*---------------------------------------------------------*/
%macro miparms( data=, smin=, smax=, sinc=, outparms=);
ods select none;

data &outparms;
   set _null_;
run;

/*------------ # of shift values ------------*/
%let ncase= %sysevalf( (&smax-&smin)/&sinc, ceil );

/*---- Multiple imputation analysis for each shift ----*/
%do jc=0 %to &ncase;
   %let sj= %sysevalf( &smin + &jc * &sinc);

  /*---- Generates 25 imputed data sets ----*/
   proc mi data=&data seed=14823 out=outmi;
      class Trt;
      monotone reg;
      mnar adjust( y1 / shift=&sj  adjustobs=(Trt='1') );
      var Trt y0 y1;
   run;

  /*------ Perform reg test -------*/
   proc reg data=outmi;
      model y1= Trt y0;
      by  _Imputation_;
      ods output parameterestimates=regparm;
   run;

  /*------ Combine reg results -------*/
   proc mianalyze parms=regparm;
      modeleffects Trt;
      ods output parameterestimates=miparm;
   run;

   data miparm;
      set miparm;
      Shift= &sj;
      keep Shift Probt;
   run;

  /*----- Output multiple imputation results ----*/
   data &outparms;
      set &outparms miparm;
   run;

%end;

ods select all;
%mend miparms;

%miparms( data=Mono2, smin=-3, smax=0, sinc=0.1, outparms=parm1);

title 'P-value Plot';
proc sgplot data=parm1;
   series x=Shift y=Probt / lineattrs=graphfit(color=blue);
   refline 0.05 / axis=y lineattrs=graphfit(thickness=1px pattern=shortdash);
   xaxis label="Shift Parameter";
   yaxis label="P-value";
run;

%miparms( data=Mono2, smin=-1.6, smax=-1.5, sinc=0.01, outparms=parm2);

proc print label data=parm2;
   var Shift Probt;
   title 'P-values for Shift Parameters';
   label Probt='Pr > |t|';
   format Probt 8.4;
run;
