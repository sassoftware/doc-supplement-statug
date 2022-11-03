/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SEQTGS                                              */
/*   TITLE: Getting Started Example for PROC SEQTEST            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential test                               */
/*   PROCS: SEQDESIGN, SEQTEST, REG                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SEQTEST, GETTING STARTED EXAMPLE               */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;
proc seqdesign altref=-10.0;
   TwoSidedOBrienFleming: design nstages=4
                          method=obf
                          ;
   samplesize model=twosamplemean(stddev=20);
   ods output Boundary=Bnd_LDL;
run;

data ldl;
   do j=1 to 86;
      Trt=0;  Ldl= 20*rannor(960303);
      Ldl= int( 100*Ldl) / 100;  output;
      Trt=1;  Ldl= -7.8 + 20*rannor(960303);
      Ldl= int( 100*Ldl) / 100;  output;
   end;
run;
data ldl_1;
   set ldl;
   if j <= 22;
run;
data ldl_2;
   set ldl;
   if j <= 43;
run;
data ldl_3;
   set ldl;
   if j <= 65;
run;

proc print data=ldl_1(obs=10);
   var Trt Ldl;
   title 'First 10 Obs in the Trial Data';
run;

proc reg data=LDL_1;
   model Ldl=Trt;
   ods output ParameterEstimates=Parms_LDL1;
run;

data Parms_LDL1;
   set Parms_LDL1;
   if Variable='Trt';
   _Scale_='MLE';
   _Stage_= 1;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
run;

proc print data=Parms_LDL1;
   title 'Statistics Computed at Stage 1';
run;

proc seqtest Boundary=Bnd_LDL
             Parms(Testvar=Trt)=Parms_LDL1
             infoadj=prop
             ;
   ods output Test=Test_LDL1;
run;

proc reg data=LDL_2;
   model Ldl=Trt;
   ods output ParameterEstimates=Parms_LDL2;
run;

data Parms_LDL2;
   set Parms_LDL2;
   if Variable='Trt';
   _Scale_='MLE';
   _Stage_= 2;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
run;

proc print data=Parms_LDL2;
   title 'Statistics Computed at Stage 2';
run;

proc seqtest Boundary=Test_LDL1
             Parms(Testvar=Trt)=Parms_LDL2
             infoadj=prop
             ;
   ods output Test=Test_LDL2;
run;

proc reg data=LDL_3;
   model Ldl=Trt;
   ods output ParameterEstimates=Parms_LDL3;
run;

data Parms_LDL3;
   set Parms_LDL3;
   if Variable='Trt';
   _Scale_='MLE';
   _Stage_= 3;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
run;

proc print data=Parms_LDL3;
   title 'Statistics Computed at Stage 3';
run;

proc seqtest Boundary=Test_LDL2
             Parms(Testvar=Trt)=Parms_LDL3
             infoadj=prop
             ;
   ods output Test=Test_LDL3;
run;
