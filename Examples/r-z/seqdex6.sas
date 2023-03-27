/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqdex6                                             */
/*   TITLE: Documentation Example 6 for PROC SEQDESIGN          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.2
               bscale=score
               errspend
               plots=(combinedboundary errspend(hscale=info))
               ;
   StopToRejectAccept: design nstages=5 method=tri alt=upper stop=both;
   StopToReject:       design nstages=5 method=tri alt=upper stop=reject;
   StopToAccept:       design nstages=5 method=tri alt=upper stop=accept;
run;

