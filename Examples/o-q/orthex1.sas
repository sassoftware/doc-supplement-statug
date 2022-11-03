/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ORTHOREX1                                           */
/*   TITLE: Example 1 for PROC ORTHOREG                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: regression analysis                                 */
/*   PROCS: ORTHOREG GLM                                        */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC ORTHOREG, EXAMPLE 1.                           */
/*    MISC:                                                     */
/****************************************************************/

/* Example 1: Precise Analysis of Variance ---------------------*/

title 'Atomic Weight of Silver by Two Different Instruments';
data AgWeight;
   input Instrument AgWeight @@;
   datalines;
1 107.8681568   1 107.8681465   1 107.8681572   1 107.8681785
1 107.8681446   1 107.8681903   1 107.8681526   1 107.8681494
1 107.8681616   1 107.8681587   1 107.8681519   1 107.8681486
1 107.8681419   1 107.8681569   1 107.8681508   1 107.8681672
1 107.8681385   1 107.8681518   1 107.8681662   1 107.8681424
1 107.8681360   1 107.8681333   1 107.8681610   1 107.8681477
2 107.8681079   2 107.8681344   2 107.8681513   2 107.8681197
2 107.8681604   2 107.8681385   2 107.8681642   2 107.8681365
2 107.8681151   2 107.8681082   2 107.8681517   2 107.8681448
2 107.8681198   2 107.8681482   2 107.8681334   2 107.8681609
2 107.8681101   2 107.8681512   2 107.8681469   2 107.8681360
2 107.8681254   2 107.8681261   2 107.8681450   2 107.8681368
;

proc orthoreg data=AgWeight;
   class Instrument;
   model AgWeight = Instrument;
run;

ods exclude all;

proc orthoreg data=AgWeight;
   class Instrument;
   model AgWeight = Instrument;
   ods output ANOVA         = OrthoregANOVA
              FitStatistics = OrthoregFitStat;
run;

ods exclude none;

ods exclude all;

proc glm data=AgWeight;
   class Instrument;
   model AgWeight = Instrument;
   ods output OverallANOVA  = GLMANOVA
              FitStatistics = GLMFitStat;
run;

ods exclude none;

data _null_;
   set OrthoregANOVA  (in=inANOVA)
       OrthoregFitStat(in=inFitStat);
   if (inANOVA) then do;
      if (Source = 'Model') then put "Model SS: " ss e20.;
      if (Source = 'Error') then put "Error SS: " ss e20.;
   end;
   if (inFitStat) then do;
      if (Statistic = 'Root MSE') then
                            put "Root MSE: " nValue1 e20.;
      if (Statistic = 'R-Square') then
                         put "R-Square: " nValue1 best20.;
   end;
run;

data _null_;
   set GLMANOVA  (in=inANOVA)
       GLMFitStat(in=inFitStat);
   if (inANOVA) then do;
      if (Source = 'Model') then put "Model SS: " ss e20.;
      if (Source = 'Error') then put "Error SS: " ss e20.;
   end;
   if (inFitStat) then      put "Root MSE: " RootMSE e20.;
   if (inFitStat) then   put "R-Square: " RSquare best20.;
run;
