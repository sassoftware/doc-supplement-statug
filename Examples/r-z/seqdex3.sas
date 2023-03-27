/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqdex3                                             */
/*   TITLE: Documentation Example 3 for PROC SEQDESIGN          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/****************************************************************/

proc seqdesign altref=0.4
               pss
               stopprob
               errspend
               ;
   TwoSidedPocock:        design nstages=4 method=poc;
   TwoSidedOBrienFleming: design nstages=4 method=obf;
   samplesize model=twosamplemean(stddev=0.8 weight=2);
run;

