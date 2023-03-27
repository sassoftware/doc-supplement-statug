/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: probitex5                                           */
/*   TITLE: Documentation Example 5 for PROC PROBIT             */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*                                                              */
/*   PROCS: PROBIT                                              */
/*    DATA: Documentation Example 4 (probitex4)                 */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

proc probit data=epidemic;
   class treat sex;
   model r/n = dose treat sex treat*sex;
   slice treat*sex / diff;
   effectplot;
run;

