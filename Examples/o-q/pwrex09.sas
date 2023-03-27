/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: pwrex09                                             */
/*   TITLE: Documentation Example 9 for PROC POWER              */
/*          (Binary Logistic Regression with Independent        */
/*          Predictors)                                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: power                                               */
/*          sample size                                         */
/*          power analysis                                      */
/*   PROCS: POWER                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

proc power;
   logistic
      vardist("Heat") = ordinal((5 10 15 20) : (0.2 0.3 0.3 0.2))
      vardist("Soak") = ordinal((2 4 6) : (0.4 0.4 0.2))
      vardist("Mass1") = normal(4, 1)
      vardist("Mass2") = normal(4, 2)
      testpredictor = "Heat"
      covariates = "Soak" | "Mass1" "Mass2"
      responseprob = 0.15 0.25
      testoddsratio = 1.2
      units= ("Heat" = 5)
      covoddsratios = 1.4 | 1 1.3
      alpha = 0.1
      power = 0.9
      ntotal = .;
run;

