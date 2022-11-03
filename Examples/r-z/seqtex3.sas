/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SEQTEX3                                             */
/*   TITLE: Documentation Example 3 for PROC SEQTEST            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential test                               */
/*   PROCS: SEQDESIGN, SEQTEST, REG                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SEQTEST, EXAMPLE 3                             */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.10;
   OBFErrorFunction: design method=errfuncgamma
                            stop=accept
                            nstages=3
                            info=cum(2 3 4);

   samplesize model=reg( variance=5 xvariance=64 xrsquare=0.10);
   ods output Boundary=Bnd_Fit;
run;

data fitness;
   input Age Weight Oxygen RunTime RestPulse RunPulse MaxPulse @@;
   datalines;
44 89.47 44.609 11.37 62 178 182
40 75.07 45.313 10.07 62 185 185
44 85.84 54.297  8.65 45 156 168
42 68.15 59.571  8.17 40 166 172
38 89.02 49.874  9.22 55 178 180
47 77.45 44.811 11.63 58 176 176
40 75.98 45.681 11.95 70 176 180
43 81.19 49.091 10.85 64 162 170
44 81.42 39.442 13.08 63 174 176
38 81.87 60.055  8.63 48 170 186
44 73.03 50.541 10.13 45 168 168
45 87.66 37.388 14.03 56 186 192
45 66.45 44.754 11.12 51 176 176
47 79.15 47.273 10.60 47 162 164
54 83.12 51.855 10.33 50 166 170
49 81.42 49.156  8.95 44 180 185
51 69.63 40.836 10.95 57 168 172
51 77.91 46.672 10.00 48 162 168
48 91.63 46.774 10.25 48 162 164
49 73.37 50.388 10.08 67 168 168
57 73.37 39.407 12.63 58 174 176
54 79.38 46.080 11.17 62 156 165
52 76.32 45.441  9.63 48 164 166
50 70.87 54.625  8.92 48 146 155
51 67.25 45.118 11.08 48 172 172
54 91.63 39.203 12.88 44 168 172
51 73.71 45.790 10.47 59 186 188
57 59.08 50.545  9.93 49 148 155
49 76.32 48.673  9.40 56 186 188
48 61.24 47.920 11.50 52 170 176
52 82.78 47.467 10.50 53 170 172
;

data fitness;
   set fitness fitness fitness fitness;
run;
data Fit_1;
   Coef=5.0;
   set fitness(obs=47);
   Age= Age + int(5 * rannor(912)/Coef);
   Weight= Weight + 10 * rannor(912)/Coef;
   Oxygen= Oxygen + 0.1* Weight + 5 * rannor(912)/Coef;
   RunTime= RunTime + 1.1 * rannor(912)/Coef;
   RestPulse= RestPulse + 7 * rannor(912)/Coef;
   RunPulse= RunPulse + 10 * rannor(912)/Coef;
   MaxPulse= MaxPulse + 9 * rannor(912)/Coef;
run;
data Fit_2;
   set fitness(firstobs=48 obs=70);
   Coef=5.0;
   Age= Age + int(5 * rannor(912)/Coef);
   Weight= Weight + 8 * rannor(912)/Coef;
   Oxygen= Oxygen + 0.1* Weight + 7 * rannor(912)/Coef;
   RunTime= RunTime + 1.4 * rannor(912)/Coef;
   RestPulse= RestPulse + 7 * rannor(912)/Coef;
   RunPulse= RunPulse + 10 * rannor(912)/Coef;
   MaxPulse= MaxPulse + 9 * rannor(912)/Coef;
run;
data Fit_3;
   set fitness(firstobs=71 obs=95);
   Coef=5.0;
   Age= Age + int(5 * rannor(912)/Coef);
   Weight= Weight + 6 * rannor(912)/Coef;
   Oxygen= Oxygen + 0.1* Weight + 7 * rannor(912)/Coef;
   RunTime= RunTime + 1.4 * rannor(912)/Coef;
   RestPulse= RestPulse + 7 * rannor(912)/Coef;
   RunPulse= RunPulse + 10 * rannor(912)/Coef;
   MaxPulse= MaxPulse + 9 * rannor(912)/Coef;
run;

data fitness;
   set Fit_1 Fit_2 Fit_3;
run;

data Fit_1;
   set fitness(obs=48);
run;

data Fit_2;
   set fitness(obs=72);
run;

data Fit_3;
   set fitness(obs=95);
run;

proc print data=Fit_1(obs=10);
   var Oxygen Age Weight RunTime RunPulse MaxPulse;
   title 'First 10 Obs in the Trial Data';
run;

proc reg data=Fit_1;
   model Oxygen=Age Weight RunTime RunPulse MaxPulse;
   ods output ParameterEstimates=Parms_Fit1;
run;

data Parms_Fit1;
   set Parms_Fit1;
   if Variable='Weight';
   _Scale_='MLE';
   _Stage_= 1;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
run;

proc print data=Parms_Fit1;
   title 'Statistics Computed at Stage 1';
run;

proc seqtest Boundary=Bnd_Fit
             Parms(testvar=Weight)=Parms_Fit1
             infoadj=none
             errspendadj=errfuncgamma
             stopprob
             order=lr
             ;
   ods output Test=Test_Fit1;
run;

proc reg data=Fit_2;
   model Oxygen=Age Weight RunTime RunPulse MaxPulse;
   ods output ParameterEstimates=Parms_Fit2;
run;

data Parms_Fit2;
   set Parms_Fit2;
   if Variable='Weight';
   _Scale_='MLE';
   _Stage_= 2;
   keep _Scale_ _Stage_ Variable Estimate StdErr;
run;


proc print data=Parms_Fit2;
   title 'Statistics Computed at Stage 2';
run;

proc seqtest Boundary=Test_Fit1
             Parms(testvar=Weight)=Parms_Fit2
             errspendadj=errfuncgamma
             order=lr
             pss
             plots=(asn power)
             ;
   ods output Test=Test_Fit2;
run;
