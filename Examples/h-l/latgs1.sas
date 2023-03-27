/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LATGS1                                              */
/*   TITLE: Getting Started Example for PROC LATTICE            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: lattice                                             */
/*   PROCS: LATTICE                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: COCHRAN, W.G. & COX, G.M.(1957), "EXPERIMENTAL      */
/*          DESIGNS", 2ND EDITION, NEW YORK: JOHN WILEY & SONS. */
/*    MISC:                                                     */
/****************************************************************/

title 'Examining the Growth Rate of Pigs';

data Pigs;
   input Group Block Treatment Weight @@;
   datalines;
1 1 1 2.20  1 1 2 1.84  1 1 3 2.18  1 2 4 2.05  1 2 5 0.85
1 2 6 1.86  1 3 7 0.73  1 3 8 1.60  1 3 9 1.76
2 1 1 1.19  2 1 4 1.20  2 1 7 1.15  2 2 2 2.26  2 2 5 1.07
2 2 8 1.45  2 3 3 2.12  2 3 6 2.03  2 3 9 1.63
3 1 1 1.81  3 1 5 1.16  3 1 9 1.11  3 2 2 1.76  3 2 6 2.16
3 2 7 1.80  3 3 3 1.71  3 3 4 1.57  3 3 8 1.13
4 1 1 1.77  4 1 6 1.57  4 1 8 1.43  4 2 2 1.50  4 2 4 1.60
4 2 9 1.42  4 3 3 2.04  4 3 5 0.93  4 3 7 1.78
;

proc lattice data=Pigs;
   var Weight;
run;

