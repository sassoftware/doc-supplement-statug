/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: qregex3                                             */
/*   TITLE: Documentation Example 3 for PROC QUANTREG           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Quantile Regression                                 */
/*                                                              */
/*   PROCS: QUANTREG                                            */
/*    DATA: bweight                                             */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

proc contents varnum data=sashelp.bweight;
   ods select position;
run;

proc format;
   value vfmt 0 = 'No Visit'       1 = 'Second Trimester'
              2 = 'Last Trimester' 3 = 'First Trimester';
   value efmt 0 = 'High School'    1 = 'Some College'
              2 = 'College'        3 = 'Less Than High School';
run;

ods graphics on;

proc quantreg ci=sparsity/iid algorithm=interior(tolerance=5.e-4)
   data=sashelp.bweight order=internal;
   class Visit MomEdLevel;
   model Weight = Black Married Boy Visit MomEdLevel MomSmoke
   CigsPerDay MomAge MomAge*MomAge
   MomWtGain MomWtGain*MomWtGain /
   quantile= 0.05 to 0.95 by 0.05
   plot=quantplot;
   format Visit vfmt. MomEdLevel efmt.;
run;
