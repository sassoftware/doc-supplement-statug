/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqtex4                                             */
/*   TITLE: Documentation Example 4 for PROC SEQTEST            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential test                               */
/*   PROCS: SEQDESIGN, SEQTEST, MEANS                           */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.10
               boundaryscale=mle
               ;
   PowerFamily: design method=pow
                       nstages=4
                       alt=upper
                       beta=0.20
                       ;
   samplesize model(ceiladjdesign=include)=onesamplefreq( nullprop=0.6);
   ods output AdjustedBoundary=Bnd_Prop;
run;

data prop;
   do j=1 to 141;
      Resp= ranbin( 511312, 1, 0.60);
      output;
   end;
run;
data prop_1;
   set prop(obs=36);
run;
data prop_2;
   set prop(obs=71);
run;
proc print data=prop(obs=10);
   var Resp;
   title 'First 10 Obs in the Trial Data';
run;

proc means data=Prop_1;
   var Resp;
   ods output Summary=Data_Prop1;
run;

data Data_Prop1;
   set Data_Prop1;
   _Scale_='MLE';
   _Stage_= 1;
   NObs= Resp_N;
   PDiff= Resp_Mean - 0.6;
   keep _Scale_ _Stage_ NObs PDiff;
run;
proc print data=Data_Prop1;
   title 'Statistics Computed at Stage 1';
run;

proc seqtest Boundary=Bnd_Prop
             Data(Testvar=PDiff Infovar=NObs)=Data_Prop1
             infoadj=prop
             boundarykey=both
             boundaryscale=mle
             ;
   ods output Test=Test_Prop1;
run;

proc means data=Prop_2;
   var Resp;
   ods output Summary=Data_Prop2;
run;

data Data_Prop2;
   set Data_Prop2;
   _Scale_='MLE';
   _Stage_= 2;
   NObs= Resp_N;
   PDiff= Resp_Mean - 0.6;
   keep _Scale_ _Stage_ NObs PDiff;
run;

proc print data=Data_Prop2;
   title 'Statistics Computed at Stage 2';
run;

proc seqtest Boundary=Test_Prop1
             Data(Testvar=PDiff Infovar=NObs)=Data_Prop2
             infoadj=prop
             boundarykey=both
             boundaryscale=mle
             condpower(cref=1)
             predpower
             plots=condpower
             ;
   ods output test=Test_Prop2;
run;

proc seqtest Boundary=Test_Prop1
             Data(Testvar=PDiff Infovar=NObs)=Data_Prop2
             nstages=3
             boundarykey=both
             boundaryscale=mle
             condpower(cref=1)
             ;
run;

