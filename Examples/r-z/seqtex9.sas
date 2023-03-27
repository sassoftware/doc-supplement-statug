/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqtex9                                             */
/*   TITLE: Documentation Example 9 for PROC SEQTEST            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential test                               */
/*   PROCS: SEQDESIGN, SEQTEST,                                 */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.15 errspend
               ;
   NonbindingDesign: design nstages=4
                     method=obf
                     alt=upper
                     stop=both(betaboundary=nonbinding)
                     alpha=0.025
                     ;
   samplesize model=twosamplefreq(nullprop=0.6 test=prop);
ods output Boundary=Bnd_Count;
run;

data count;
   do j=1 to 222;
      Trt=0;
      Resp= ranbin( 2128921, 1, 0.6);
      output;
      Trt=1;
      if (j <= 56)       then Resp= ranbin( 2128921, 1, 0.70);
      else if (j <= 111) then Resp= ranbin( 2128921, 1, 0.70);
      else               Resp= ranbin( 128921, 1, 0.84);
      output;
   end;
run;
data count_1;
   set count;
   if (j <= 56);
run;
data count_2;
   set count;
   if (j <= 111);
run;
data count_3;
   set count;
   if (j <= 166);
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
             betaboundary=nonbinding
             infoadj=none
             errspendmin=0.001
             errspend
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
             betaboundary=nonbinding
             infoadj=none
             ;
ods output Test=Test_Count2;
run;

proc genmod data=Count_3;
   model Resp= Trt;
ods output ParameterEstimates=Parms_Count3;
run;

data Parms_Count3;
   set Parms_Count3;
   if Parameter='Trt';
   _Scale_='MLE';
   _Stage_= 3;
   keep _Scale_ _Stage_ Parameter Estimate StdErr;
run;

proc print data=Parms_Count3;
   title 'Statistics Computed at Stage 3';
run;

proc seqtest Boundary=Test_Count2
             Parms(Testvar=Trt)=Parms_Count3
             betaboundary=nonbinding
             ;
ods output Test=Test_Count3;
run;

