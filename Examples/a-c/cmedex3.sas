/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cmedex3                                             */
/*   TITLE: Example 3 for PROC CAUSALMED                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Smoking Effect on Infant Mortality                  */
/*   PROCS: CAUSALMED                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CAUSALMED, EXAMPLE 3                           */
/*    MISC:                                                     */
/****************************************************************/

proc print data=sashelp.birthwgt(obs=10);
run;

proc causalmed data=sashelp.birthwgt decomp;
   class LowBirthWgt Smoking Death AgeGroup Married Race
         Drinking SomeCollege /descending;
   mediator LowBirthWgt = Smoking;
   model Death = LowBirthWgt | Smoking;
   covar AgeGroup Married Race Drinking SomeCollege;
   evaluate 'Low Birth-Weight' LowBirthWgt='Yes' / nodecomp;
   evaluate 'Normal Birth-Weight' LowBirthWgt='No' / nodecomp;
run;

