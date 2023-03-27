/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: hpreggs                                             */
/*   TITLE: Getting Started Example for PROC HPREG              */
/*    DESC: Statistics and Salaries of Major League             */
/*             Baseball (MLB) Players in 1986                   */
/*     REF: Collier Books, 1987, The 1987 Baseball Encyclopedia */
/*          Update, Macmillan Publishing Company, New York.     */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection                                     */
/*   PROCS: HPREG                                               */
/*                                                              */
/****************************************************************/

proc contents varnum data=sashelp.baseball;
   ods select position;
run;

proc hpreg data=sashelp.baseball;
  class league division;
  model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                    yrMajor crAtBat crHits crHome crRuns crRbi
                    crBB league division nOuts nAssts nError;
  selection method=stepwise;
run;

proc hpreg data=sashelp.baseball;
  id name;
  class league division;
  model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                    yrMajor crAtBat crHits crHome crRuns crRbi
                    crBB league division nOuts nAssts nError / vif clb;
  selection method=stepwise;
  output out=baseballOut p=predictedLogSalary r h cookd rstudent;
run;


proc print data=baseballOut(obs=5);
run;

