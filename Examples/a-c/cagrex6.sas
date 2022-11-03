/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CAGREX6                                             */
/*   TITLE: Documentation Example 6 for PROC CAUSALGRAPH        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphical causal models                             */
/*   PROCS: CAUSALGRAPH                                         */
/*    DATA:                                                     */
/*                                                              */
/*  UPDATE: July 06, 2018                                       */
/*     REF: PROC CAUSALGRAPH, Example 6                         */
/*    MISC: Special thanks to Noah Greifer                      */
/****************************************************************/

proc causalgraph common(only);
   model "Thor12SimpleBP"
      AntiHypertensiveUse ==> CurrentBP,
      Creatinine ==> AntiHypertensiveUse CurrentBP,
      Nutrition ==> Urate Obesity,
      Obesity ==> PreviousBP Creatinine,
      CurrentBP ==> CVD,
      PreviousBP ==> AntiHypertensiveUse,
      Urate ==> PreviousBP Creatinine CVD;
   model "Thor12AltBP"
      AntiHypertensiveUse ==> CurrentBP Urate,
      Creatinine ==> AntiHypertensiveUse CurrentBP,
      Nutrition ==> Urate Obesity,
      Obesity ==> PreviousBP Creatinine,
      CurrentBP ==> CVD,
      PreviousBP ==> AntiHypertensiveUse,
      Urate ==> CVD;
   identify Urate ==> CVD;
   unmeasured Nutrition PreviousBP;
run;

proc causalgraph imap=global;
   model "Thor12SimpleBP"
      AntiHypertensiveUse ==> CurrentBP,
      Creatinine ==> AntiHypertensiveUse CurrentBP,
      Nutrition ==> Urate Obesity,
      Obesity ==> PreviousBP Creatinine,
      CurrentBP ==> CVD,
      PreviousBP ==> AntiHypertensiveUse,
      Urate ==> PreviousBP Creatinine CVD;
   identify Urate ==> CVD;
   unmeasured Nutrition PreviousBP;
   ods output Imap = SimpleBPIndep;
run;

proc causalgraph imap=global;
   model "Thor12AltBP"
      AntiHypertensiveUse ==> CurrentBP Urate,
      Creatinine ==> AntiHypertensiveUse CurrentBP,
      Nutrition ==> Urate Obesity,
      Obesity ==> PreviousBP Creatinine,
      CurrentBP ==> CVD,
      PreviousBP ==> AntiHypertensiveUse,
      Urate ==> CVD;
   identify Urate ==> CVD;
   unmeasured Nutrition PreviousBP;
   ods output Imap = AltBPIndep;
run;

proc print data=SimpleBPIndep(obs=10);
   var Set1 Set2 CondSet;
   where Observable = 1;
run;

proc print data=AltBPIndep(obs=10);
   var Set1 Set2 CondSet;
   where Observable = 1;
run;
