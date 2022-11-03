/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: FREQEX5                                             */
/*   TITLE: Documentation Example 5 for PROC FREQ               */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis, 2x2 contingency table,   */
/*    KEYS: chi-square tests, Fisher's exact test,              */
/*    KEYS: odds ratio, relative risks                          */
/*   PROCS: FREQ                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC FREQ, Example 5                                */
/*    MISC:                                                     */
/****************************************************************/
/* Analysis of a 2x2 Contingency Table -------------------------*/
proc format;
   value ExpFmt 1='High Cholesterol Diet'
                0='Low Cholesterol Diet';
   value RspFmt 1='Yes'
                0='No';
run;
data FatComp;
   input Exposure Response Count;
   label Response='Heart Disease';
   datalines;
0 0  6
0 1  2
1 0  4
1 1 11
;
proc sort data=FatComp;
   by descending Exposure descending Response;
run;
proc freq data=FatComp order=data;
   format Exposure ExpFmt. Response RspFmt.;
   tables Exposure*Response / chisq relrisk;
   exact pchi or;
   weight Count;
   title 'Case-Control Study of High Fat/Cholesterol Diet';
run;
