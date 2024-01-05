/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PLANEXD                                             */
/*   TITLE: Details Section Examples for PROC PLAN              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: design, factorial experiments                       */
/*   PROCS: PLAN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PLAN, DETAILS EXAMPLES.                        */
/*    MISC:                                                     */
/****************************************************************/


/* Creation of output data sets: example plan ------------------*/

proc plan seed=12345;
   factors a=3 b=2;
run;

/* Creation of output data sets: plan output into a data set ---*/

proc plan seed=12345;
   factors a=3 b=2;
   output out=out;
run;
proc print data=out;
run;

/* Creation of output data sets: specify input data set --------*/

data in;
   input a b;
   datalines;
1 1
2 1
3 1
;

/* Creation of output data sets: use input and output data sets */

proc plan seed=12345;
   factors a=3 b=2;
   output out=out data=in;
run;
proc print data=out;
run;

/* Permute 4 of 30 integers, start with initial block & increment*/

proc plan;
   factors c=6 ordered t=4 of 30 cyclic (2 10 15 18) 2;
run;

/* Create a randomized complete block design -------------------*/

proc plan ordered seed=78390;
   factors blocks=3 cell=5;
   treatments t=5 random;
   output out=rcdb;
run;

