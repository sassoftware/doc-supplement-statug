/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cagrex4                                             */
/*   TITLE: Documentation Example 4 for PROC CAUSALGRAPH        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphical causal models                             */
/*   PROCS: CAUSALGRAPH                                         */
/*     REF: Thornley et al (2013), Rheumatology                 */
/****************************************************************/


proc causalgraph common;
   model "Thor12SimpleHDL"
      Ethnicity ==> Nutrition Smoking,
      Gender ==> Nutrition Urate,
      Gout ==> CVD,
      Nutrition ==> PreviousHDL Urate,
      CurrentHDL ==> CVD,
      PreviousHDL ==> StatinUse,
      Smoking ==> CVD,
      StatinUse ==> CurrentHDL,
      Urate ==> CVD Gout;
   model "Thor12AltHDL"
      StatinUse ==> CVD / refmodel="Thor12SimpleHDL";
   identify Urate ==> CVD;
   unmeasured Nutrition PreviousHDL;
run;

