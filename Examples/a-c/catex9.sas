/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CATEX9                                              */
/*   TITLE: Example 9 for PROC CATMOD                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis                           */
/*   PROCS: CATMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC CATMOD chapter          */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*----------------------------------------------------------------
Example 9: Repeated Measures, Two Repeated Measurement Factors

             Diagnostic Procedure Comparison
             -------------------------------
Two diagnostic procedures (standard and test) are done on each
subject, and the results of both are evaluated at each of two
times as being positive or negative.

From: MacMillan et al. (1981).
----------------------------------------------------------------*/

data a;
   input std1 $ test1 $ std2 $ test2 $ wt @@;
   datalines;
neg neg neg neg 509  neg neg neg pos  4  neg neg pos neg  17
neg neg pos pos   3  neg pos neg neg 13  neg pos neg pos   8
neg pos pos pos   8  pos neg neg neg 14  pos neg neg pos   1
pos neg pos neg  17  pos neg pos pos  9  pos pos neg neg   7
pos pos neg pos   4  pos pos pos neg  9  pos pos pos pos 170
;

proc catmod data=a;
   title2 'Marginal Symmetry, Saturated Model';
   weight wt;
   response marginals;
   model std1*test1*std2*test2=_response_ / freq design noparm;
   repeated Time 2, Treatment 2 / _response_=Time Treatment
            Time*Treatment;
run;

   title2 'Marginal Symmetry, Reduced Model';
   model std1*test1*std2*test2=_response_ / corrb design noprofile;
   repeated Time 2, Treatment 2 / _response_=Treatment;
run;

   title2 'Sensitivity and Specificity Analysis, '
          'Main-Effects Model';
   model std1*test1*std2*test2=_response_ / covb design noprofile;
   repeated Time 2, Accuracy 2 / _response_=Time Accuracy;
   response exp 1 -1  0  0  0  0  0  0,
                0  0  1 -1  0  0  0  0,
                0  0  0  0  1 -1  0  0,
                0  0  0  0  0  0  1 -1

            log 0 0 0 0   0 0  0   0 0 0 0   1 1 1 1,
                0 0 0 0   0 0  0   1 1 1 1   1 1 1 1,
                1 1 1 1   0 0  0   0 0 0 0   0 0 0 0,
                1 1 1 1   1 1  1   0 0 0 0   0 0 0 0,
                0 0 0 1   0 0  1   0 0 0 1   0 0 0 1,
                0 0 1 1   0 0  1   0 0 1 1   0 0 1 1,
                1 0 0 0   1 0  0   1 0 0 0   1 0 0 0,
                1 1 0 0   1 1  0   1 1 0 0   1 1 0 0;
quit;
