/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: pwrex03                                             */
/*   TITLE: Documentation Example 3 for PROC POWER              */
/*          (Simple AB/BA Crossover Designs)                    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: power                                               */
/*          sample size                                         */
/*          power analysis                                      */
/*          graphs                                              */
/*   PROCS: POWER                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;

proc power;
   pairedmeans test=diff
      pairedmeans   = (330 310)
      pairedstddevs = (40 55)
      corr          = 0.3
      sides         = 1 2
      alpha         = 0.01
      npairs        = 100
      power         = .;
   plot x=n min=50 max=200;
run;

ods graphics off;

proc power;
   pairedmeans test=equiv_add
      lower         = -35
      upper         = 35
      pairedmeans   = (330 310)
      pairedstddevs = (40 55)
      corr          = 0.3
      alpha         = 0.01
      npairs        = 100
      power         = .;
run;

