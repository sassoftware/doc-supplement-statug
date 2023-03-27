/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqdgs                                              */
/*   TITLE: Getting Started Example for PROC SEQDESIGN          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/****************************************************************/

ods graphics on;
proc seqdesign altref=-10
               plots=boundary(hscale=samplesize)
               ;
   TwoSidedOBrienFleming: design nstages=4
                          method=obf
                          ;
   samplesize model=twosamplemean(stddev=20);
ods output Boundary=Bnd_LDL;
run;

