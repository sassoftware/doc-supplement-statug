/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: FREQGS2                                             */
/*   TITLE: Getting Started Example 2 for PROC FREQ             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis, crosstabulation tables,  */
/*    KEYS: measures of agreement, kappa statistics,            */
/*    KEYS: ODS Graphics, agreement plot                        */
/*   PROCS: FREQ                                                */
/*     REF: PROC FREQ, Getting Started Example 2                */
/****************************************************************/

/* Agreement Study ---------------------------------------------*/

data SkinCondition;
   input Derm1 $ Derm2 $ Count;
   datalines;
terrible terrible 10
terrible     poor 4
terrible marginal 1
terrible    clear 0
poor     terrible 5
poor         poor 10
poor     marginal 12
poor        clear 2
marginal terrible 2
marginal     poor 4
marginal marginal 12
marginal    clear 5
clear    terrible 0
clear        poor 2
clear    marginal 6
clear       clear 13
;

ods graphics on;
proc freq data=SkinCondition order=data;
   tables Derm1*Derm2 /
          agree noprint plots=agreeplot;
   test kappa;
   weight Count;
run;
ods graphics off;

