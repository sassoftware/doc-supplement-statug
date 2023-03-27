
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LIFERGS1                                            */
/*   TITLE: Getting Started Example 1 for PROC LIFEREG          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: survival data analysis                              */
/*   PROCS: LIFEREG                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC LIFEREG, INTRODUCTORY EXAMPLE 1.               */
/*    MISC:                                                     */
/****************************************************************/


data Headache;
   input Minutes Group Censor @@;
   datalines;
11  1  0   12  1  0   19  1  0   19  1  0
19  1  0   19  1  0   21  1  0   20  1  0
21  1  0   21  1  0   20  1  0   21  1  0
20  1  0   21  1  0   25  1  0   27  1  0
30  1  0   21  1  1   24  1  1   14  2  0
16  2  0   16  2  0   21  2  0   21  2  0
23  2  0   23  2  0   23  2  0   23  2  0
25  2  1   23  2  0   24  2  0   24  2  0
26  2  1   32  2  1   30  2  1   30  2  0
32  2  1   20  2  1
;

proc print data=headache (obs=5);
run;

proc lifereg data=Headache;
   class Group;
   model Minutes*Censor(1)=Group;
   output out=New cdf=Prob;
run;

proc sgplot data=New;
   scatter x=Minutes y=Prob / group=Group;
   discretelegend;
run;

