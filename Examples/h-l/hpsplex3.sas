/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: HPSPLEX3                                            */
/*   TITLE: Documentation Example 3 for PROC HPSPLIT            */
/*                                                              */
/* PRODUCT: HPSTAT                                              */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection                                     */
/*   PROCS: HPSTAT                                              */
/*                                                              */
/* SUPPORT: Joseph Pingenot                                     */
/****************************************************************/

ods graphics on;

proc hpsplit data=sashelp.baseball seed=123;
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor crAtBat crHits crHome crRuns crRbi
                     crBB league division nOuts nAssts nError;
   output out=hpsplout;
run;

proc print data=hpsplout(obs=10); run;

