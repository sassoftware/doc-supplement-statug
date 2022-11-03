/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PLANIN2                                             */
/*   TITLE: Getting Started Example 2 for PROC PLAN             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: design, factorial experiments, randomization        */
/*   PROCS: PLAN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PLAN, INTRODUCTORY EXAMPLE 2.                  */
/*    MISC:                                                     */
/****************************************************************/

/* Randomly assigning subjects to treatments -------------------*/
title 'Completely Randomized Design';
/* The unrandomized design */
data Unrandomized;
   do Unit=1 to 12;
      if (Unit <= 6) then Treatment=1;
      else                Treatment=2;
      output;
   end;
run;
/* Randomize the design for two treatments ---------------------*/
proc plan seed=27371;
   factors Unit=12;
   output data=Unrandomized out=Randomized;
run;
/* Sort data by unit and display randomized design again -------*/
proc sort data=Randomized;
   by Unit;
run;
proc print;
run;
/* Same plan with TREATMENTS statement rather than DATA step --*/
proc plan seed=27371;
   factors Unit=12;
   treatments Treatment=12 cyclic (1 1 1 1 1 1 2 2 2 2 2 2);
   output out=Randomized;
run;
