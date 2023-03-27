/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cagrex2                                             */
/*   TITLE: Documentation Example 2 for PROC CAUSALGRAPH        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphical causal models                             */
/*   PROCS: CAUSALGRAPH                                         */
/*     REF: Timmermann et al (2017), Reprod. Toxic.             */
/****************************************************************/


proc causalgraph method=adjustment maxlist=1 nosort;
   model "Timm17HealthBehavior"
      Age ==> Parity PFAS Education,
      Parity ==> PrevBF Duration PFAS,
      PrevBF ==> PFAS Duration,
      PFAS ==> Duration,
      Education ==> Duration HealthBehavior Employment,
      HealthBehavior ==> PFAS Duration BMI Alcohol Smoking,
      Employment ==> HealthBehavior Duration,
      BMI Alcohol Smoking ==> Duration;
   identify PFAS ==> Duration;
   unmeasured PrevBF HealthBehavior;
run;

