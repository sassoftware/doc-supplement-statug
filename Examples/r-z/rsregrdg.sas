 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: RSREGRDG                                            */
 /*   TITLE: Analysis of a Blocked Response Surface Design       */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: response surface methods,                           */
 /*   PROCS: RSREG                                               */
 /*    DATA: Example in Myers (1976), pp. 189-193.               */
 /*                                                              */
  /*     REF: Myers, Raymond H. (1976), "Response Surface Metho-  */
 /*              dology", Blacksburg, Virginia: Virginia Poly-   */
 /*              technic Institute and State University.         */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

 /*
 /  The data is a central composite design in two factor variables
 /  X1 and X2 and response variable Y.  The design has been situa-
 /  ted into two blocks orthogonal to the linear and quadratic
 /  terms of the model.
 /---------------------------------------------------------------*/
data A;
   input Block X1 X2 Y;
   datalines;
   -1   -1.0    0.000   61.8
   -1    0.5    0.866   86.0
   -1    0.5   -0.866   86.3
   -1    0.0    0.000   97.1
   -1    0.0    0.000   95.9
    1   -0.5    0.866   72.9
    1   -0.5   -0.866   61.3
    1    1.0    0.000   92.3
    1    0.0    0.000   91.5
    1    0.0    0.000   89.7
;

 /*
 /  Sort by the independent variables so that we can examine
 /  lack-of-fit.
 /---------------------------------------------------------------*/
proc sort;
   by block x1 x2;
run;

 /*
 /  Analyze by declaring BLOCK to be a covariate rather than a
 /  factor variable: the ridge of maximum response will be
 /  computed for an "average" block (see the documentation for
 /  RSREG on the treatment of covariates in the ridge analysis.)
 /---------------------------------------------------------------*/
proc rsreg;
   model y = block x1 x2 / covar = 1 lackfit;
   ridge max;
run;
