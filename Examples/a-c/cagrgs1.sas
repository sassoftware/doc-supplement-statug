/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cagrgs1                                             */
/*   TITLE: Getting Started Example 1 for PROC CAUSALGRAPH      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphical causal model, adjustment set              */
/*   PROCS: CAUSALGRAPH                                         */
/*     REF: Timmermann et al (2017), Reprod. Toxic.             */
/****************************************************************/


proc causalgraph;
   model "Timm17TwoLatent"
      Age ==> Parity PFAS Education,
      Parity ==> PrevBF Duration PFAS,
      PrevBF ==> PFAS Duration,
      PFAS ==> Duration,
      Education ==> Duration Employment PFAS BMI Alcohol Smoking,
      Employment ==> Duration PFAS BMI Alcohol Smoking,
      BMI Alcohol Smoking ==> Duration;
   identify PFAS ==> Duration;
   unmeasured Alcohol Smoking;
run;

