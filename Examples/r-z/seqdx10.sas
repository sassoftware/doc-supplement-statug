/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqdx10                                             */
/*   TITLE: Documentation Example 10 for PROC SEQDESIGN         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.2 errspend;
   design nstages=3
          method=errfuncpow
          alt=twosided  stop=accept
          betaoverlap=noadjust
          beta=0.09
          ;
run;

proc seqdesign altref=0.2 errspend;
   design nstages=3
          method=errfuncpow
          alt=twosided
          stop=accept
          betaoverlap=adjust
          beta=0.09
          ;
run;

