/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqtex5                                             */
/*   TITLE: Documentation Example 5 for PROC SEQTEST            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential test                               */
/*   PROCS: SEQDESIGN, SEQTEST, LOGISTIC                        */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.441833
               boundaryscale=mle
               ;
   OneSidedErrorSpending: design method=errfuncpow
                                 nstages=5
                                 alt=upper
                                 stop=accept
                                 alpha=0.025;
   samplesize model=twosamplefreq( nullprop=0.6 test=logor);
   ods output Boundary=Bnd_CSup;
run;

data count;
   do j=1 to 503;
      TrtGrp='Control';
      Resp= ranbin( 91312, 1, 0.60);
      output;
      TrtGrp='C_Sup';
      Resp= ranbin( 91312, 1, 0.66);
      output;
   end;
run;
data CSup_1;
   set count;
   if (j <= 101);
run;
data CSup_2;
   set count;
   if (j <= 202);
run;
data CSup_3;
   set count;
   if (j <= 302);
run;
data CSup_4;
   set count;
   if (j <= 403);
run;
data CSup_5;
   set count;
run;
proc print data=CSup_1(obs=10);
   var TrtGrp Resp;
   title 'First 10 Obs in the Trial Data';
run;

proc logistic data=CSup_1 descending;
   class TrtGrp / param=ref;
   model Resp= TrtGrp;
   ods output ParameterEstimates=Parms_CSup1;
run;

data Parms_CSup1;
   set Parms_CSup1;
   if Variable='TrtGrp' and ClassVal0='C_Sup';
   _Scale_='MLE';
   _Stage_= 1;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
run;

proc print data=Parms_CSup1;
   title 'Statistics Computed at Stage 1';
run;

proc seqtest Boundary=Bnd_CSup
             Parms(Testvar=TrtGrp)=Parms_CSup1
             infoadj=prop
             errspendadj=errfuncpow
             boundarykey=both
             boundaryscale=mle
             ;
   ods output test=Test_CSup1;
run;

proc logistic data=CSup_2 descending;
   class TrtGrp / param=ref;
   model Resp= TrtGrp;
   ods output ParameterEstimates=Parms_CSup2;
run;

data Parms_CSup2;
   set Parms_CSup2;
   if Variable='TrtGrp' and ClassVal0='C_Sup';
   _Scale_='MLE';
   _Stage_= 2;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
run;
proc print data=Parms_CSup2;
   title 'Statistics Computed at Stage 2';
run;

proc seqtest Boundary=Test_CSup1
             Parms( testvar=TrtGrp)=Parms_CSup2
             infoadj=prop
             errspendadj=errfuncpow
             boundarykey=both
             boundaryscale=mle
             ;
   ods output Test=Test_CSup2;
run;

proc logistic data=CSup_3 descending;
   class TrtGrp / param=ref;
   model Resp= TrtGrp;
   ods output ParameterEstimates=Parms_CSup3;
run;
data Parms_CSup3;
   set Parms_CSup3;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
   _Scale_='MLE';
   _Stage_= 3;
   if Variable='TrtGrp' and ClassVal0='C_Sup';
run;
proc seqtest Boundary=Test_CSup2
             Parms( testvar=TrtGrp)=Parms_CSup3
             infoadj=prop
             errspendadj=errfuncpow
             boundarykey=both
             boundaryscale=mle
             ;
   ods output test=Test_CSup3;
run;

proc logistic data=CSup_4 descending;
   class TrtGrp / param=ref;
   model Resp= TrtGrp;
   ods output ParameterEstimates=Parms_CSup4;
run;

data Parms_CSup4;
   set Parms_CSup4;
   if Variable='TrtGrp' and ClassVal0='C_Sup';
   _Scale_='MLE';
   _Stage_= 4;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
run;

proc seqtest Boundary=Test_CSup3
             Parms( testvar=TrtGrp)=Parms_CSup4
             infoadj=prop
             errspendadj=errfuncpow
             boundarykey=both
             boundaryscale=mle
             ;
   ods output test=Test_CSup4;
run;

proc logistic data=CSup_5 descending;
   class TrtGrp / param=ref;
   model Resp= TrtGrp;
   ods output ParameterEstimates=Parms_CSup5;
run;

data Parms_CSup5;
   set Parms_CSup5;
   if Variable='TrtGrp' and ClassVal0='C_Sup';
   _Scale_='MLE';
   _Stage_= 5;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
run;

proc print data=Parms_CSup5;
   title 'Statistics Computed at Stage 5';
run;

proc seqtest Boundary=Test_CSup4
             Parms( testvar=TrtGrp)=Parms_CSup5
             errspendadj=errfuncpow
             boundaryscale=mle
             cialpha=.025
             rci
             plots=rci
             ;
run;

