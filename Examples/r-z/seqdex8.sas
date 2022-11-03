/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SEQDEX8                                             */
/*   TITLE: Documentation Example 8 for PROC SEQDESIGN          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SEQDESIGN, EXAMPLE 8                           */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.2  errspend
               pss(cref=0 0.5 1)
               stopprob(cref=0 0.5 1)
               plots=(asn power errspend)
               ;
   OneSidedErrorSpending: design nstages=5
                          method(alpha)=errfuncobf
                          method(beta)=errfuncpoc
                          alt=upper  stop=both
                          alpha=0.025
                          ;
run;
