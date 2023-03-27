/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ANOVAEX3                                            */
/*   TITLE: Example 3 for PROC ANOVA                            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: analysis of variance, balanced data, design         */
/*   PROCS: ANOVA                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC ANOVA, EXAMPLE 3.                              */
/*    MISC:                                                     */
/****************************************************************/


/* Split Plot Design -------------------------------------------*/


title1 'Split Plot Design';
data Split;
   input Block 1 A 2 B 3 Response;
   datalines;
142 40.0
141 39.5
112 37.9
111 35.4
121 36.7
122 38.2
132 36.4
131 34.8
221 42.7
222 41.6
212 40.3
211 41.6
241 44.5
242 47.6
231 43.6
232 42.8
;


/* Include Independent Effects Block, A, Block*A, B, and A*B.
   Ask for F test of the A Effect with Block*A as Error Term ---*/


proc anova data=Split;
   class Block A B;
   model Response = Block A Block*A B A*B;
   test h=A e=Block*A;
run;

