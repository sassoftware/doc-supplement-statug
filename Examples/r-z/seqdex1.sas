/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SEQDEX1                                             */
/*   TITLE: Documentation Example 1 for PROC SEQDESIGN          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SEQDESIGN, EXAMPLE 1                           */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;
proc seqdesign pss
               ;
   OneSidedFixedSample: design nstages=1
                               alt=upper
                               alpha=0.025 beta=0.10
                               ;
   samplesize model=onesamplemean(mean=0.25);
run;

proc seqdesign altref=1.2
               pss
               ;
   TwoSidedFixedSample: design nstages=1
                               alt=twosided
                               alpha=0.05 beta=0.10
                               ;
   samplesize model=twosamplemean(stddev=2 weight=2);
run;
