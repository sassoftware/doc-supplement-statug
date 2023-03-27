/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX4                                             */
/*   TITLE: Example 4 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          polytomous response data                            */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 4. Nominal Response Data: Generalized Logits Model
*****************************************************************/

/*
Stokes, Davis, and Koch (2000). Over the course of one school year, third
graders from three different schools are exposed to three different styles of
mathematics instruction: a self-paced computer-learning style, a team
approach, and a traditional class approach.  The students are asked which
style they prefer and their responses are classified by the type of program
they are in (a regular school day versus a regular day supplemented with an
afternoon school program).  The levels (self, team, and class) of the
response variable Style have no essential ordering, so a logistic regression
is performed on the generalized logits.  An interaction model then a main
effects model are fit.
*/

title 'Example 4. Nominal Response Data: Generalized Logits Model';

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

ods graphics on;
proc logistic data=school;
   freq Count;
   class School Program(ref=first);
   model Style(order=data)=School Program School*Program / link=glogit;
   oddsratio program;
run;

proc logistic data=school;
   freq Count;
   class School Program(ref=first);
   model Style(order=data)=School Program / link=glogit;
   effectplot interaction(plotby=Program) / clm noobs;
run;

