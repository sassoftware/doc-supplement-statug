/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIEX11                                              */
/*   TITLE: Documentation Example 11 for PROC MI                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple imputation                                 */
/*   PROCS: MI                                                  */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MI, EXAMPLE 11                                 */
/*    MISC:                                                     */
/****************************************************************/

*---------------------Data on Physical Fitness-------------------------*
| These measurements were made on men involved in a physical fitness   |
| course at N.C. State University. Certain values have been set to     |
| missing and the resulting data set has an arbitrary missing pattern. |
| Only selected variables of                                           |
| Oxygen (intake rate, ml per kg body weight per minute),              |
| Runtime (time to run 1.5 miles in minutes),                          |
| RunPulse (heart rate while running) are used.                        |
*----------------------------------------------------------------------*;
data Fitness1;
   input Oxygen RunTime RunPulse @@;
   datalines;
44.609  11.37  178     45.313  10.07  185
54.297   8.65  156     59.571    .      .
49.874   9.22    .     44.811  11.63  176
  .     11.95  176          .  10.85    .
39.442  13.08  174     60.055   8.63  170
50.541    .      .     37.388  14.03  186
44.754  11.12  176     47.273    .      .
51.855  10.33  166     49.156   8.95  180
40.836  10.95  168     46.672  10.00    .
46.774  10.25    .     50.388  10.08  168
39.407  12.63  174     46.080  11.17  156
45.441   9.63  164       .      8.92    .
45.118  11.08    .     39.203  12.88  168
45.790  10.47  186     50.545   9.93  148
48.673   9.40  186     47.920  11.50  170
47.467  10.50  170
;

ods graphics on;
proc mi data=Fitness1 seed=501213 nimpute=5 mu0=50 10 180;
   mcmc plots=(trace(mean(Oxygen)) acf(mean(Oxygen)));
   var Oxygen RunTime RunPulse;
run;
