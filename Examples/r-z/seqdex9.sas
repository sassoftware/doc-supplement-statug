/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SEQDEX9                                             */
/*   TITLE: Documentation Example 9 for PROC SEQDESIGN          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SEQDESIGN, EXAMPLE 9                           */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;
proc seqdesign plots=( asn
                       power
                       combinedboundary
                       errspend(hscale=info)
                       )
               ;
   TwoStageDesign:  design nstages=2
                    method=errfuncpow
                    alt=upper  stop=reject
                    ;
   FiveStageDesign: design nstages=5
                    method=errfuncpow
                    alt=upper  stop=reject
                    ;
   TenStageDesign:  design nstages=10
                    method=errfuncpow
                    alt=upper  stop=reject
                    ;
run;
