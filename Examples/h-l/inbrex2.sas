/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: INBREX2                                             */
/*   TITLE: Documentation Example 2 for PROC INBREED            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: inbreed, pedigree                                   */
/*   PROCS: INBREED                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC INBREED, DOCUMENTATION EXAMPLE 2               */
/*    MISC:                                                     */
/****************************************************************/

data Swine;
   input Swine_Number $ Sire $ Dam $ Sex $;
   datalines;
3504 2200 2501  M
3514 2521 3112  F
3519 2521 2501  F
2501 2200 3112  M
2789 3504 3514  F
3501 2521 3514  M
3712 3504 3514  F
3121 2200 3501  F
;

title 'Least Related Matings';
proc inbreed data=Swine ind average;
   var Swine_Number Sire Dam;
   matings 2501 / 3501 3504 ,
           3712 / 3121;
   gender Sex;
run;

