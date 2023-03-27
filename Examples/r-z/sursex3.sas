/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SURSEX3                                             */
/*   TITLE: Documentation Example 3 for PROC SURVEYSELECT       */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: survey sampling, probability sampling,              */
/*    KEYS: probability proportional to size (PPS) sampling,    */
/*    KEYS: stratified sampling, dollar-unit sampling           */
/*   PROCS: SURVEYSELECT, SORT, PRINT                           */
/*     REF: PROC SURVEYSELECT, Example 3                        */
/****************************************************************/

/* Sampling Frame ----------------------------------------------*/

data TravelExpense;
   input ID$ Amount @@;
   if (Amount < 500) then Level='1_Low ';
      else if (Amount > 1500) then Level='3_High';
      else Level='2_Avg ';
   datalines;
110  237.18   002  567.89   234  118.50
743   74.38   411 1287.23   782  258.10
216  325.36   174  218.38   568 1670.80
302  134.71   285 2020.70   314   47.80
139 1183.45   775  330.54   425  780.10
506  895.80   239  620.10   011  420.18
672  979.66   142  810.25   738  670.85
192  314.58   243   87.50   263 1893.40
496  753.30   332  540.65   486 2580.35
614  230.56   654  185.60   308  688.43
784  505.14   017  205.48   162  650.42
289 1348.34   691   30.50   545 2214.80
517  940.35   382  217.85   024  142.90
478  806.90   107  560.72
;

proc sort data=TravelExpense;
   by Level;
run;

title1 'Travel Expense Audit';
proc print data=TravelExpense;
run;

/* PPS (Dollar-Unit) Sampling ----------------------------------*/

title2 'Stratified PPS (Dollar-Unit) Sampling';
proc surveyselect data=TravelExpense method=pps n=(6 10 4)
                  seed=47279 out=AuditSample;
   size Amount;
   strata Level;
run;

title2 'Sample Selected by Stratified PPS Design';
proc print data=AuditSample;
run;

