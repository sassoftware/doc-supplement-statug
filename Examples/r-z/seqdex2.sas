/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqdex2                                             */
/*   TITLE: Documentation Example 2 for PROC SEQDESIGN          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.15
               ;
   OneSidedOBrienFleming: design nstages=4
                          method=obf
                          alt=upper   stop=both
                          alpha=0.025 beta=0.20
                          ;
   samplesize model(ceiladjdesign=include)
              =twosamplefreq(nullprop=0.6 test=prop);
ods output AdjustedBoundary=Bnd_Prop;
run;

