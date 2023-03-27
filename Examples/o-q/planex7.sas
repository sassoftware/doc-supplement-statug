/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: planex7                                             */
/*   TITLE: Example 7 for PROC PLAN                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: crossover design                                    */
/*   PROCS: PLAN                                                */
/*     REF: PROC PLAN, EXAMPLE 7.                               */
/*                                                              */
/****************************************************************/


/* Crossover designs -------------------------------------------*/

proc plan;
   factors Run=6 ordered Period=6 ordered;
   treatments Treatment=6 cyclic (1 2 6 3 5 4);
run;


/* Generate treatments cyclically ------------------------------*/

proc plan seed=136149876;
   factors Run=6 ordered Period=6 ordered / noprint;
   treatments Treatment=6 cyclic (1 2 6 3 5 4);
   output out=RandomizedDesign
      Run       random
      Treatment random
      ;
run;

/*
/ Relabel Period to obtain the same design as in Cox (1992).
/------------------------------------------------------------------*/
data RandomizedDesign;
   set RandomizedDesign;
   Period = mod(Period+2,6)+1;
run;


/* Prepare to print the design in a standard form --------------*/

proc sort data=RandomizedDesign;
   by Run Period;
run;
proc transpose data=RandomizedDesign out=tDesign(drop=_name_);
   by notsorted Run;
   var Treatment;
run;
data tDesign;
   set tDesign;
   rename COL1-COL6 = Period_1-Period_6;
run;
proc print data=tDesign noobs;
run;


/* Generate carryover variable for preceding period treatment */

proc sort data=RandomizedDesign;
   by Run Period;
run;
data RandomizedDesign;
   set RandomizedDesign;
   by Run period;
   LagTreatment = lag(Treatment);
   if (first.Run) then LagTreatment = .;
run;

proc transpose data=RandomizedDesign out=tDesign(drop=_name_);
   by notsorted Run;
   var LagTreatment;
run;
data tDesign;
   set tDesign;
   rename COL1-COL6 = Period_1-Period_6;
run;
proc print data=tDesign noobs;
run;

data Responses;
   input Response @@;
   datalines;
56.7 53.8 54.4 54.4 58.9 54.5
58.5 60.2 61.3 54.4 59.1 59.8
55.7 60.7 56.7 59.9 56.6 59.6
57.3 57.7 55.2 58.1 60.2 60.2
53.7 57.1 59.2 58.9 58.9 59.6
58.1 55.7 58.9 56.6 59.6 57.5
;
data Mills;
   merge RandomizedDesign Responses;
run;


/* Incorporate the carryover variable in the analysis ----------*/

proc orthoreg data=Mills;
   class Run Period Treatment;
   effect CarryOver = lag(Treatment / period=Period within=Run);
   model Response = Run Period Treatment CarryOver;
   test Run Period Treatment CarryOver / htype=1;
   lsmeans Treatment CarryOver / diff=anom;
   ods select Tests1 LSMeans Diffs;
run;

