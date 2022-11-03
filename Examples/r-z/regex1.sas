/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: regex1                                              */
/*   TITLE: Example 1 for PROC REG                              */
/*    DESC: Statistics and Salaries of Major League             */
/*             Baseball (MLB) Players in 1986                   */
/*     REF: Collier Books, 1987, The 1987 Baseball Encyclopedia */
/*          Update, Macmillan Publishing Company, New York.     */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics, Influence Diagnostics                 */
/*   PROCS: REG                                                 */
/*                                                              */
/****************************************************************/

proc contents varnum data=sashelp.baseball;
   ods select position;
run;

ods graphics on;

proc reg data=sashelp.baseball;
   id name team league;
   model logSalary = nhits nruns nrbi nbb yrmajor crhits;
run;

proc reg data=sashelp.baseball
         plots(only label)=(RStudentByLeverage CooksD);
   id name team league;
   model logSalary = nhits nruns nrbi nbb yrmajor crhits;
run;

proc reg data=sashelp.baseball
         plots=(RStudentByLeverage(label) residuals(smooth));
   where name^="Rose, Pete";
   id name team league;
   model logSalary = nhits nruns nrbi nbb yrmajor crhits;
run;

data baseball;
   set sashelp.baseball(where=(name^="Rose, Pete"));
   YrMajor2 = yrmajor*yrmajor;
   CrHits2  = crhits*crhits;
run;

proc reg data=baseball
      plots=(diagnostics(stats=none) RStudentByLeverage(label)
             CooksD(label) Residuals(smooth)
             DFFITS(label) DFBETAS ObservedByPredicted(label));
   id name team league;
   model logSalary = nhits nruns nrbi nbb yrmajor crhits
                     yrmajor2 crhits2;
run;

%let ind = nhits nruns nrbi nbb yrmajor crhits yrmajor2 crhits2;
proc reg data=baseball plots=none;
   model logSalary = &ind;
   output out=pred p=p;
run;

%marginal(dependent=logSalary, predicted=p, independents=&ind)
