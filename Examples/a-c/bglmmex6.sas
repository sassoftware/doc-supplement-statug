/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: bglmmex6                                            */
/*   TITLE: Example 6 for PROC BGLIMM                           */
/*    DESC: Multinomial Generalized Logit for Nominal Response  */
/*     REF: STATLIB                                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Multinomial, Generalized Logit                      */
/*   PROCS: BGLIMM                                              */
/*    DATA: Learning Preference data                            */
/*                                                              */
/*     REF:                                                     */
/****************************************************************/

data school;
   length Program $ 9;
   input School Program $ Style $ Count @@;
   datalines;
1 regular   self 10  1 regular   team 17  1 regular   class 26
1 afternoon self  5  1 afternoon team 12  1 afternoon class 50
2 regular   self 21  2 regular   team 17  2 regular   class 26
2 afternoon self 16  2 afternoon team 12  2 afternoon class 36
3 regular   self 15  3 regular   team 15  3 regular   class 16
3 afternoon self 12  3 afternoon team 12  3 afternoon class 20
;

proc bglimm data=school seed=123 dic;
   freq Count;
   class School Program;
   model Style(ref="class")=School Program School*Program / dist=multinomial
         link=glogit;
run;

proc bglimm data=school seed=123 dic;
   freq Count;
   class School Program;
   model Style(ref="class")= School Program / dist=multinomial
         link=glogit;
   estimate 'School 1 vs 3' School 1 0 -1  / exp bycat;
   estimate 'School 2 vs 3' School 0 1 -1  / exp bycat;
   estimate 'Afternoon vs Regular' Program 1 -1  / exp bycat;
run;
