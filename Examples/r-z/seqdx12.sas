/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqdx12                                             */
/*   TITLE: Documentation Example 12 for PROC SEQDESIGN         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/****************************************************************/

ods graphics on;
proc seqdesign altref=2
               pss(cref=0 0.5 1)
               stopprob(cref=0 1)
               errspend
               plots=(asn power errspend)
               ;
TwoSidedAsymmetric: design nstages=4
                    method=errfuncgamma(gamma=1)
                    method(beta)=errfuncgamma(gamma=-2)
                    method(upperalpha)=errfuncgamma(gamma=-5)
                    alt=twosided
                    stop=both
                    beta=0.1
                    ;
run;

