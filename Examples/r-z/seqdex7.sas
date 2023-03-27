/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqdex7                                             */
/*   TITLE: Documentation Example 7 for PROC SEQDESIGN          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.693147
               bscale=score
               plots=combinedboundary
               ;
   BoundaryKeyNone:  design nstages=4
                            method=whitehead
                            boundarykey=none
                            alt=upper   stop=both
                            alpha=0.05  beta=0.20
                            ;
   BoundaryKeyAlpha: design nstages=4
                            method=whitehead
                            boundarykey=alpha
                            alt=upper   stop=both
                            alpha=0.05  beta=0.20
                            ;

   BoundaryKeyBeta:  design nstages=4
                            method=whitehead
                            boundarykey=beta
                            alt=upper   stop=both
                            alpha=0.05  beta=0.20
                            ;
run;

