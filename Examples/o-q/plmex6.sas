/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: plmex6                                              */
/*   TITLE: Example 6 for PROC PLM                              */
/*    DESC: SIMULATED Data                                      */
/*     REF:                                                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: ORTHOREG,PLM                                        */
/*                                                              */
/****************************************************************/

data spline;
   input group y @@;
   x = _n_;
   datalines;
 1    -.020 1    0.199 2    -1.36 1    -.026
 2    -.397 1    0.065 2    -.861 1    0.251
 1    0.253 2    -.460 2    0.195 2    -.108
 1    0.379 1    0.971 1    0.712 2    0.811
 2    0.574 2    0.755 1    0.316 2    0.961
 2    1.088 2    0.607 2    0.959 1    0.653
 1    0.629 2    1.237 2    0.734 2    0.299
 2    1.002 2    1.201 1    1.520 1    1.105
 1    1.329 1    1.580 2    1.098 1    1.613
 2    1.052 2    1.108 2    1.257 2    2.005
 2    1.726 2    1.179 2    1.338 1    1.707
 2    2.105 2    1.828 2    1.368 1    2.252
 1    1.984 2    1.867 1    2.771 1    2.052
 2    1.522 2    2.200 1    2.562 1    2.517
 1    2.769 1    2.534 2    1.969 1    2.460
 1    2.873 1    2.678 1    3.135 2    1.705
 1    2.893 1    3.023 1    3.050 2    2.273
 2    2.549 1    2.836 2    2.375 2    1.841
 1    3.727 1    3.806 1    3.269 1    3.533
 1    2.948 2    1.954 2    2.326 2    2.017
 1    3.744 2    2.431 2    2.040 1    3.995
 2    1.996 2    2.028 2    2.321 2    2.479
 2    2.337 1    4.516 2    2.326 2    2.144
 2    2.474 2    2.221 1    4.867 2    2.453
 1    5.253 2    3.024 2    2.403 1    5.498
;

proc orthoreg data=spline;
   class group;
   effect spl = spline(x);
   model y = group spl*group / noint;
   store ortho_spline;
   title 'B-splines Comparisons';
run;

proc plm restore=ortho_spline;
   score data=spline out=ortho_pred predicted=p;
run;

proc sgplot data=ortho_pred;
   series  y=p x=x / group=group name="fit";
   scatter y=y x=x / group=group;
   keylegend "fit" / title="Group";
run;

%macro GroupDiff;
   %do x=0 %to 75 %by 5;
      "Diff at x=&x" group 1 -1 group*spl [1,1  &x] [-1,2  &x],
   %end;
   'Diff at x=80' group 1 -1 group*spl [1,1 80] [-1,2 80]
%mend;

proc plm restore=ortho_spline;
   show effects;
   estimate %GroupDiff / adjust=simulate seed=1 stepdown;
run;

proc plm restore=ortho_spline;
   estimate %GroupDiff / adjust=simulate seed=1 stepdown;
   filter adjp > 0.05;
run;
