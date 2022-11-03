/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PLANIN1                                             */
/*   TITLE: Getting Started Example 1 for PROC PLAN             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: design, factorial experiments                       */
/*   PROCS: PLAN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PLAN, INTRODUCTORY EXAMPLE 1.                  */
/*    MISC:                                                     */
/****************************************************************/

/* Design with three replicates of four factor levels ----------*/

proc plan seed=27371;
   factors Replicate=3 ordered Drug=4;
run;
/* Apply one of four different treatments to each cell of plan ----*/

   factors Replicate=3 ordered Drug=4;
   treatments Treatment=4;
run;
