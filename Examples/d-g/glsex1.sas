/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: glsex1                                              */
/*   TITLE: Example 1 for PROC GLMSELECT                        */
/*    DESC: Statistics and Salaries of Major League             */
/*             Baseball (MLB) Players in 1986                   */
/*     REF: Collier Books, 1987, The 1987 Baseball Encyclopedia */
/*          Update, Macmillan Publishing Company, New York.     */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection, ODS GRAPHICS                       */
/*   PROCS: GLMSELECT                                           */
/*                                                              */
/****************************************************************/


ods graphics on;

proc glmselect data=sashelp.baseball plot=CriterionPanel;
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                  yrMajor crAtBat crHits crHome crRuns crRbi
                  crBB league division nOuts nAssts nError
                / selection=stepwise(select=SL) stats=all;
run;

proc glmselect data=sashelp.baseball;
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                  yrMajor crAtBat crHits crHome crRuns crRbi
                  crBB league division nOuts nAssts nError
                / selection=stepwise(select=SL choose=PRESS);
run;

proc glmselect data=sashelp.baseball plot=Coefficients;
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                  yrMajor crAtBat crHits crHome crRuns crRbi
                  crBB league division nOuts nAssts nError
                / selection=stepwise(select=SL stop=PRESS);
run;


proc glmselect data=sashelp.baseball plot=Candidates;
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                  yrMajor crAtBat crHits crHome crRuns crRbi
                  crBB league division nOuts nAssts nError
                / selection=stepwise(select=CV drop=competitive)
                  cvMethod=split(5);
run;


proc glmselect data=sashelp.baseball plots=(CriterionPanel ASE) seed=1;
   partition fraction(validate=0.3 test=0.2);
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                  yrMajor crAtBat crHits crHome crRuns crRbi
                  crBB league division nOuts nAssts nError
                / selection=forward(choose=validate stop=10);
run;


proc glmselect data=sashelp.baseball plot=CriterionPanel ;
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                  yrMajor crAtBat crHits crHome crRuns crRbi
                  crBB league division nOuts nAssts nError
                / selection=LASSO(choose=CP steps=20);
run;

ods graphics off;
