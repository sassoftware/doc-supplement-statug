/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cagrex6                                             */
/*   TITLE: Documentation Example 6 for PROC CAUSALGRAPH        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphical causal models                             */
/*   PROCS: CAUSALGRAPH                                         */
/*     REF: Thornley et al (2013), Rheumatology                 */
/****************************************************************/


proc causalgraph common(only) outmodel=Thor12;
   model "Thor12Base"
      AntiHypertensiveUse ==> CurrentBP,
      Creatinine ==> AntiHypertensiveUse CurrentBP,
      Nutrition ==> Urate Obesity,
      Obesity ==> PreviousBP Creatinine,
      CurrentBP ==> CVD,
      PreviousBP ==> AntiHypertensiveUse,
      Urate ==> CVD / noanalysis;
   model "Thor12SimpleBP"
      Urate ==> PreviousBP Creatinine / refmodel="Thor12Base";
   model "Thor12AltBP"
      AntiHypertensiveUse ==> Urate / refmodel="Thor12Base";
   identify Urate ==> CVD;
   unmeasured Nutrition PreviousBP;
run;

proc causalgraph inmodel=Thor12 nolist imap=global;
   identify Urate ==> CVD;
   unmeasured Nutrition PreviousBP;
   ods output Imap = Thor12Indep;
run;

proc print data=Thor12Indep(obs=10);
   var Set1 Set2 CondSet;
   where Model="Thor12SimpleBP" and Observable = 1;
run;

proc print data=Thor12Indep(obs=10);
   var Set1 Set2 CondSet;
   where Model="Thor12AltBP" and Observable = 1;
run;

