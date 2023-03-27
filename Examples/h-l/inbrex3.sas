/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: INBREX3                                             */
/*   TITLE: Documentation Example 3 for PROC INBREED            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: inbreed, by-group                                   */
/*   PROCS: INBREED                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC INBREED, DOCUMENTATION EXAMPLE 3               */
/*    MISC:                                                     */
/****************************************************************/

data Swine;
   input Group Swine_Number $ Sire $ Dam $ Sex $;
   datalines;
1  2789 3504 3514  F
2  2501 2200 3112  .
2  3504 2501 3782  M
;

proc inbreed data=Swine covar noprint outcov=Covariance
             init=0.4;
   var Swine_Number Sire Dam;
   gender Sex;
   by Group;
run;

title 'Printout of OUTCOV= data set';
proc print data=Covariance;
   format Col1-Col3 4.2;
run;

