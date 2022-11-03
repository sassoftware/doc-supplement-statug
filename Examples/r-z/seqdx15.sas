/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SEQDX15                                             */
/*   TITLE: Documentation Example 15 for PROC SEQDESIGN         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential design                             */
/*   PROCS: SEQDESIGN                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SEQDESIGN, EXAMPLE 15                          */
/*    MISC:                                                     */
/****************************************************************/

proc seqdesign;
   OBrienFleming: design nstages=4 method=obf
                  ;
   samplesize model=twosamplesurvival
                    ( nullhazard=0.03466
                      hazard=0.01733
                      accrual=exp(parm=-0.1)
                      loss=exp(hazard=0.05)
                      acctime=20);
run;

proc seqdesign;
   OBrienFleming: design nstages=4
                  method=obf
                  ;
   samplesize model=twosamplesurvival
                    ( nullhazard=0.03466
                      hazard=0.01733
                      accrual=exp(parm=-0.1)
                      loss=exp(hazard=0.05)
                      acctime=20 accnobs=360 );
run;

proc seqdesign;
   OBrienFleming: design nstages=4
                  method=obf
                  ;
   samplesize model=twosamplesurvival
                    ( nullhazard=0.03466
                      hazard=0.01733
                      accrual=exp(parm=-0.1)
                      loss=exp(hazard=0.05)
                      acctime=20 accnobs=360
                      ceiling=n);
run;
