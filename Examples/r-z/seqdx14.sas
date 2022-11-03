/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SEQDX14                                             */
/*   TITLE: Documentation Example 14 for PROC SEQDESIGN         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SEQDESIGN, EXAMPLE 14                          */
/*    MISC:                                                     */
/****************************************************************/

proc seqdesign;
   ErrorSpend: design nstages=4 method=errfuncobf
               ;
   samplesize model=twosamplesurvival
                   ( nullhazard=0.03466 hazard=0.01733
                     accrual=uniform accrate=15);
run;

proc seqdesign;
   ErrorSpend: design nstages=4 method=errfuncobf
               ;
   samplesize model(ceiladjdesign=include)=twosamplesurvival
                   ( nullhazard=0.03466 hazard=0.01733
                     accrual=uniform accrate=15 acctime=18
                     ceiling=time);
run;

proc seqdesign;
   ErrorSpend: design nstages=4 method=errfuncobf
               ;
   samplesize model(ceiladjdesign=include)=twosamplesurvival
                   ( nullhazard=0.03466 hazard=0.01733
                     accrual=uniform accrate=15 acctime=18
                     ceiling=n);
run;
