/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: FREQGS1                                             */
/*   TITLE: Getting Started Example 1 for PROC FREQ             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis,                          */
/*    KEYS: frequency/crosstabulation tables, ODS Graphics,     */
/*    KEYS: chi-square statistics, Fisher's exact test,         */
/*    KEYS: Cochran-Mantel-Haenszel statistics                  */
/*   PROCS: FREQ                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC FREQ, Getting Started                          */
/*    MISC:                                                     */
/****************************************************************/
/* Frequency Tables and Statistics -----------------------------*/
data SummerSchool;
   input Gender $ Internship $ Enrollment $ Count @@;
   datalines;
boys  yes yes 35   boys  yes no 29
boys   no yes 14   boys   no no 27
girls yes yes 32   girls yes no 10
girls  no yes 53   girls  no no 23
;
proc freq data=SummerSchool order=data;
   tables Internship*Enrollment / chisq;
   weight Count;
run;
ods graphics on;
proc freq data=SummerSchool;
   tables Gender*Internship*Enrollment /
          chisq cmh plots(only)=freqplot(twoway=cluster);
   weight Count;
run;
ods graphics off;
