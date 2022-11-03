/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SEQDX11                                             */
/*   TITLE: Documentation Example 11 for PROC SEQDESIGN         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SEQDESIGN, EXAMPLE 11                          */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;
proc seqdesign altref=1.0
               pss(cref=0 0.5 1)
               stopprob(cref=0 0.5 1)
               errspend
               plots=(asn power errspend)
               ;

   TwoSidedErrorSpending: design nstages=3
                          method(upperalpha)=errfuncpow(rho=3)
                          method(loweralpha)=errfuncpow(rho=1)
                          info=cum(2 3 4)
                          alt=twosided
                          stop=reject
                          alpha=0.075(upper=0.025)
                          ;
run;
