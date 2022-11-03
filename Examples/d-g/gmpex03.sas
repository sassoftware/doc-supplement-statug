/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gmpex03                                             */
/*   TITLE: Documentation Example 3 for PROC GLMPOWER           */
/*          (Repeated Measures ANOVA)                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: power                                               */
/*          power analysis                                      */
/*          sample size                                         */
/*          graphs                                              */
/*          general linear models                               */
/*          repeated measures                                   */
/*          multivariate analysis of variance                   */
/*   PROCS: GLMPOWER                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/


data Pain;
   input Treatment $ PainMem0 PainMem1Wk PainMem6Mo PainMem12Mo;
   datalines;
      SensoryFocus    2.40  2.38  2.05  1.90
      StandardOfCare  2.40  2.39  2.36  2.30
;

ods graphics on;

proc glmpower data=Pain;
   class Treatment;
   model PainMem0 PainMem1Wk PainMem6Mo PainMem12Mo = Treatment;
   repeated Time contrast;
   power
      mtest = hlt
      alpha = 0.01
      power = .9
      ntotal = .
      stddev = 0.92 1.04
      matrix ("PainCorr") = lear(0.6, 0.8, 4, 0 1 26 52)
      corrmat = "PainCorr";
   plot y=power min=0.05 max=0.99 yopts=(ref=0.9)
      vary (linestyle by stddev, symbol by dependent source);
run;
ods graphics off;
