/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: glsex6                                              */
/*   TITLE: Example 6 for PROC GLMSELECT                        */
/*    DESC: LEU                                                 */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection, LASSO, Elastic Net,                */
/*          External Cross Validation                           */
/*   PROCS: GLMSELECT                                           */
/*                                                              */
/****************************************************************/

ods graphics on;
proc glmselect data=sashelp.Leutrain valdata=sashelp.Leutest
               plots=coefficients;
   model y = x1-x7129/
         selection=LASSO(steps=120  choose=validate);
run;

proc glmselect data=sashelp.Leutrain valdata=sashelp.Leutest
               plots=coefficients;
   model y = x1-x7129/
         selection=elasticnet(steps=120 L2=0.001 choose=validate);
run;

proc glmselect data=sashelp.Leutrain valdata=sashelp.Leutest
               plots=coefficients;
   model y = x1-x7129/
         selection=elasticnet(steps=120 choose=validate);
run;

proc glmselect data=sashelp.Leutrain testdata=sashelp.Leutest
               plots=coefficients;
   model y = x1-x7129/
         selection=elasticnet(steps=120 choose=cv)cvmethod=split(4);
run;

proc glmselect data=sashelp.Leutrain testdata=sashelp.Leutest
               plots=coefficients;
   model y = x1-x7129/
         selection=elasticnet(steps=120 choose=cvex)cvmethod=split(4);
run;
