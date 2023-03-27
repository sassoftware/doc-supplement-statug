/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqtex8                                             */
/*   TITLE: Documentation Example 8 for PROC SEQTEST            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential test                               */
/*   PROCS: SEQDESIGN, SEQTEST, LOGISTIC                        */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.5;
   TwoSidedErrorSpending: design method=errfuncpow
                                 method(loweralpha)=errfuncpow(rho=1)
                                 method(upperalpha)=errfuncpow(rho=3)
                                 nstages=3
                                 stop=both;
   samplesize model=logistic( prop=0.4 xvariance=0.5345);
   ods output Boundary=Bnd_Dose;
run;

data dose;
   do j=1 to 93;
      do Dose=0, 1, 3, 6;
         LDose= log(Dose+1);
         gg= 0.4 + 0.12*LDose;
         Resp= ranbin( 960303, 1, gg);
         output;
      end;
   end;
run;
data dose_1;
   set dose;
   if (j <= 31);
run;
data dose_2;
   set dose;
   if (j <= 62);
run;
data dose_3;
   set dose;
   if (j <= 93);
run;
proc print data=dose_1(obs=10);
   var Resp Dose LDose;
   title 'First 10 Obs in the Trial Data';
run;

proc logistic data=Dose_1;
   model Resp(event='1')= LDose;
   ods output ParameterEstimates=Parms_Dose1;
run;

data Parms_Dose1;
   set Parms_Dose1;
   if Variable='LDose';
   _Scale_='MLE';
   _Stage_= 1;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
run;

proc print data=Parms_Dose1;
   title 'Statistics Computed at Stage 1';
run;

proc seqtest Boundary=Bnd_Dose
             Parms(testvar=LDose)=Parms_Dose1
             infoadj=prop
             order=mle
             boundaryscale=mle
             ;
   ods output Test=Test_Dose1;
run;

proc logistic data=dose_2;
   model Resp(event='1')=LDose;
   ods output ParameterEstimates=Parms_Dose2;
run;

data Parms_Dose2;
   set Parms_Dose2;
   if Variable='LDose';
   _Scale_='MLE';
   _Stage_= 2;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
run;

proc print data=Parms_Dose2;
   title 'Statistics Computed at Stage 2';
run;

proc seqtest Boundary=Test_Dose1
             Parms(Testvar=LDose)=Parms_Dose2
             infoadj=prop
             order=mle
             boundaryscale=mle
             rci
             plots=rci
             ;
   ods output Test=Test_Dose2;
run;

