/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cagrex7                                             */
/*   TITLE: Documentation Example 7 for PROC CAUSALGRAPH        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphical causal models                             */
/*   PROCS: CAUSALGRAPH                                         */
/*     REF: Thornley et al (2013), Rheumatology                 */
/****************************************************************/


data CVDdata;
   drop ii Nutrition PreviousHDL;
   call streaminit(1000);
   array EthProb[6] _temporary_ (0.60, 0.18, 0.13, 0.05, 0.01, 0.03);
   array SmokeRates[6] _temporary_ (0.17, 0.10, 0.17, 0.07, 0.22, 0.15);
   array EthNut[6] _temporary_ (0.20, 0.18, 0.08, 0.03, 0.11, 0.04);
   do ii = 1 to 79000;
      Gender = rand("Bernoulli" , .5);
      Ethnicity = rand("Table" , of EthProb[*]);
      Smoking = rand("Bernoulli", SmokeRates[Ethnicity]);
      Nutrition = 0.5 - Gender + 10.0*rand("Normal", 0, EthNut[Ethnicity]);
      PreviousHDL = 55 + 4.0*Nutrition;
      if      PreviousHDL<40 then StatinUse = rand("Bernoulli", 0.90);
      else if PreviousHDL<60 then StatinUse = rand("Bernoulli", 0.65);
      else                        StatinUse = rand("Bernoulli", 0.05);
      CurrentHDL = 55 + rand("Normal",0.0,7) + StatinUse*rand("Normal",4.0,0.5);
      Urate = 6.0 + 0.4*Nutrition + 1.5*Gender;
      Gout = rand("Bernoulli", logistic(-8.0 + 0.90*Urate));
      CVD = rand("Bernoulli", logistic(-1.2 - 0.04*CurrentHDL + 0.2*Gout +
         0.65*Smoking + 0.1*Urate));
      output;
   end;
run;

proc format;
   value Ethnicity 1='WhiteNonHisp' 2='Hispanic' 3='AfricanAmer' 4='Asian'
      5='NativeAmer' 6='Other';
   value Gender 0='Female' 1='Male';
   value Smoking 0='No' 1='Yes';
run;
proc print data=CVDdata(obs=10);
   format Ethnicity Ethnicity.;
   format Gender Gender.;
   format Smoking Smoking.;
run;

proc means data=CVDdata;
   var Urate;
   ods output Summary=SampleMeansOutput;
run;

%let UnitTrue = 0.007619562;
%let StdTrue  = 0.006789300;

proc causalgraph maxsize=2;
   model "Thor12SimpleHDL"
      Ethnicity ==> Nutrition Smoking,
      Gender ==> Nutrition Urate,
      Gout ==> CVD,
      Nutrition ==> PreviousHDL Urate,
      CurrentHDL ==> CVD,
      PreviousHDL ==> StatinUse,
      Smoking ==> CVD,
      StatinUse ==> CurrentHDL,
      Urate ==> CVD Gout;
   identify Urate ==> CVD;
   unmeasured Nutrition PreviousHDL;
run;

data _null_;
   set SampleMeansOutput;
   call symputx("UrateMean",Urate_Mean);
   call symputx("UrateStd", Urate_StdDev);
   call symputx("UrateUnit1", Urate_Mean + 0.5);
   call symputx("UrateUnit0", Urate_Mean - 0.5);
   call symputx("UrateStd1", Urate_Mean + 0.5*Urate_StdDev);
   call symputx("UrateStd0", Urate_Mean - 0.5*Urate_StdDev);
run;

data ScoreData;
   set SampleMeansOutput;
   keep Urate Test;

   Test  = "UnitTreat  ";
   Urate = &UrateUnit1;
   output;

   Test  = "UnitControl";
   Urate = &UrateUnit0;
   output;

   Test  = "StdTreat   ";
   Urate = &UrateStd1;
   output;

   Test  = "StdControl ";
   Urate = &UrateStd0;
   output;
run;

proc sort data=CVDdata;
   by Smoking StatinUse;
run;
proc logistic data=CVDdata noprint;
   by Smoking StatinUse;
   model CVD(event='1') = Urate;
   score data=ScoreData out=ProbStrat;
run;

proc print data=ProbStrat;
   var Smoking StatinUse Test Urate P_1;
run;

proc freq data=CVDData;
   table Smoking*StatinUse;
   ods output CrossTabFreqs=NObsInfo;
run;
data NObsInfo;
   set NObsInfo;
   keep Frequency Smoking StatinUse;
   if Smoking = . then delete;
   if StatinUse = . then delete;
run;
data ProbStrat;
   merge ProbStrat NObsInfo;
   by Smoking Statinuse;
run;
proc sort data=ProbStrat;
   by Test;
run;
proc means data=ProbStrat;
   by Test;
   var P_1;
   freq Frequency;
   ods output Summary = StratSummary;
run;

data _null_;
   set StratSummary;
   if Test="UnitControl" then call symputx("UnitControlStrat", P_1_Mean);
   if Test="UnitTreat  " then call symputx("UnitTreatStrat", P_1_Mean);
   if Test="StdControl " then call symputx("StdControlStrat", P_1_Mean);
   if Test="StdTreat   " then call symputx("StdTreatStrat", P_1_Mean);
run;

proc logistic data=CVDdata noprint;
   model CVD(event='1') = Urate;
   score data=ScoreData out=ProbNaive;
run;

proc print data=ProbNaive;
   var Test Urate P_1;
run;

data _null_;
   set ProbNaive;
   if Test="UnitControl" then call symputx("UnitControlNaive", P_1);
   if Test="UnitTreat  " then call symputx("UnitTreatNaive",P_1);
   if Test="StdControl " then call symputx("StdControlNaive", P_1);
   if Test="StdTreat   " then call symputx("StdTreatNaive", P_1);
run;

data Output;
   keep Type TrueEff StratEff UnadjEff;
   label Type='Effect'
         TrueEff='True Effect'
         StratEff='Stratified Estimation'
         UnadjEff='Unadjusted Estimation';
   Type="UnitEff";
   TrueEff  = &UnitTrue;
   StratEff = &UnitTreatStrat - &UnitControlStrat;
   UnadjEff = &UnitTreatNaive - &UnitControlNaive;
   output;
   Type="StdEff";
   TrueEff  = &StdTrue;
   StratEff = &StdTreatStrat - &StdControlStrat;
   UnadjEff = &StdTreatNaive - &StdControlNaive;
   output;
run;

proc print label;
   format TrueEff  10.6
          StratEff 10.6
          UnadjEff 10.6;
run;

