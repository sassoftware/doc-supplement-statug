/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SEQDX13                                             */
/*   TITLE: Documentation Example 13 for PROC SEQDESIGN         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SEQDESIGN, EXAMPLE 13                          */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.15 errspend
               ;
   NonbindingDesign: design nstages=4
                     method=obf
                     alt=upper
                     stop=both(betaboundary=nonbinding)
                     alpha=0.025 beta=0.10
                     ;
   samplesize model=twosamplefreq(nullprop=0.6 test=prop);
run;
