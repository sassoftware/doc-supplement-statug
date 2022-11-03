/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PLANEXS                                             */
/*   TITLE: Syntax Section Examples for PROC PLAN               */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: design, factorial experiments                       */
/*   PROCS: PLAN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PLAN, SYNTAX EXAMPLES.                         */
/*    MISC:                                                     */
/****************************************************************/
/* FACTORS Statement: Generate design with two random factors --*/
proc plan seed=27371;
   factors One=4 Two=3;
run;
/* FACTORS Statement: Six random permutations of numbers 1, 2, 3*/
proc plan seed=27371;
   factors a=6 ordered b=3;
run;
/* OUTPUT Statement: Produce OUT= data set, use NVALS=, CVALS= -*/

proc plan seed=27371;
   factors a=6 ordered b=3;
   output out=design a nvals=(10 to 60 by 10)
                     b cvals=('HSX' 'SB2' 'DNY');
run;
/* TREATMENTS statement: generation of Graeco-Latin square -----*/
proc plan;
   factors r=3 ordered c=3 ordered;
   treatments a=3 cyclic
              b=3 cyclic 2;
run;
