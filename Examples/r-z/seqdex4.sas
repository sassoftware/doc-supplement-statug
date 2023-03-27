/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqdex4                                             */
/*   TITLE: Documentation Example 4 for PROC SEQDESIGN          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.4
               plots=all
               ;
   TwoSidedPocock:        design nstages=4 method=poc;
   TwoSidedOBrienFleming: design nstages=4 method=obf;
run;

