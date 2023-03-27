/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqtex1                                             */
/*   TITLE: Documentation Example 1 for PROC SEQTEST            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential test                               */
/*   PROCS: SEQDESIGN, SEQTEST, GENMOD                          */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.15
               boundaryscale=mle
               ;
   OBrienFleming: design method=obf
                         nstages=4
                         alt=upper
                         stop=both
                         alpha=0.025
                         ;
   samplesize model=twosamplefreq(nullprop=0.6 test=prop);
   ods output Boundary=Bnd_Count;
run;

data count;
   do j=1 to 215;
      Trt=0;
      Resp= ranbin( 312511, 1, 0.55);
      output;
      Trt=1;
      Resp= ranbin( 312511, 1, 0.74);
      output;
   end;
run;
data count_1;
   set count;
   if (j <= 54);
run;
data count_2;
   set count;
   if (j <= 108);
run;
proc print data=count(obs=10);
   var Trt Resp;
   title 'First 10 Obs in the Trial Data';
run;

proc genmod data=count_1;
   model Resp= Trt;
   ods output ParameterEstimates=Parms_Count1;
run;

data Parms_Count1;
   set Parms_Count1;
   if Parameter='Trt';
   _Scale_='MLE';
   _Stage_= 1;
   keep _Scale_ _Stage_ Parameter Estimate StdErr;
run;

proc print data=Parms_Count1;
   title 'Statistics Computed at Stage 1';
run;

proc seqtest Boundary=Bnd_Count
             Parms(Testvar=Trt)=Parms_Count1
             infoadj=none
             errspendmin=0.001
             boundaryscale=mle
             errspend
             plots=errspend
             ;
   ods output Test=Test_Count1;
run;

proc genmod data=Count_2;
   model Resp= Trt;
   ods output ParameterEstimates=Parms_Count2;
run;

data Parms_Count2;
   set Parms_Count2;
   if Parameter='Trt';
   _Scale_='MLE';
   _Stage_= 2;
   keep _Scale_ _Stage_ Parameter Estimate StdErr;
run;

proc print data=Parms_Count2;
   title 'Statistics Computed at Stage 2';
run;

proc seqtest Boundary=Test_Count1
             Parms(Testvar=Trt)=Parms_Count2
             infoadj=none
             boundaryscale=mle
             ;
   ods output Test=Test_Count2;
run;

