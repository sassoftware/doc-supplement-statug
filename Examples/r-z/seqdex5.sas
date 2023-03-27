/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqdex5                                             */
/*   TITLE: Documentation Example 5 for PROC SEQDESIGN          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.25
               errspend
               stopprob
               plots=errspend
               ;
   OneSidedPeto: design nstages=3
                 method=peto( z=3)
                 alt=upper   stop=reject
                 alpha=0.05  beta=0.10;
run;

proc seqdesign altref=0.25
               maxinfo=200
               errspend
               stopprob
               plots=errspend
               ;
   OneSidedPeto: design nstages=3
                 method=peto(z=3 2.5 2)
                 alt=upper  stop=reject
                 boundarykey=none
                 ;
run;

