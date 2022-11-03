 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: LATSQR                                              */
 /*   TITLE: Square Lattice Designs (Balanced and Unbalanced)    */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: LATTICE                                             */
 /*   PROCS: LATTICE                                             */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: COCHRAN, W.G. & COX, G.M.(1957), "EXPERIMENTAL      */
 /*          DESIGNS", 2ND EDITION, NEW YORK: JOHN WILEY & SONS. */
 /*    MISC: This dataset test the yield of 25 varieties of      */
 /* soybeans. The response variable is yield in bushels per acre */
 /* (minus 30 bu).  However, now there is a repition of the      */
 /* basic plan.  This is an example of a 5x5 square unbalanced   */
 /* lattice design with two orthogonal replications.             */
 /****************************************************************/

data soy;
   input Yield Block Group Treatmnt Rep @@;
   datalines;
 6 1 1  1 1    7 1 1  2 1    5 1 1  3 1    8 1 1  4 1    6 1 1  5 1
16 2 1  6 1   12 2 1  7 1   12 2 1  8 1   13 2 1  9 1    8 2 1 10 1
17 3 1 11 1    7 3 1 12 1    7 3 1 13 1    9 3 1 14 1   14 3 1 15 1
18 4 1 16 1   16 4 1 17 1   13 4 1 18 1   13 4 1 19 1   14 4 1 20 1
14 5 1 21 1   15 5 1 22 1   11 5 1 23 1   14 5 1 24 1   14 5 1 25 1
24 1 2  1 1   13 1 2  6 1   24 1 2 11 1   11 1 2 16 1    8 1 2 21 1
21 2 2  2 1   11 2 2  7 1   14 2 2 12 1   11 2 2 17 1   23 2 2 22 1
16 3 2  3 1    4 3 2  8 1   12 3 2 13 1   12 3 2 18 1   12 3 2 23 1
17 4 2  4 1   10 4 2  9 1   30 4 2 14 1    9 4 2 19 1   23 4 2 24 1
15 5 2  5 1   15 5 2 10 1   22 5 2 15 1   16 5 2 20 1   19 5 2 25 1
13 1 1  1 2   26 1 1  2 2    9 1 1  3 2   13 1 1  4 2   11 1 1  5 2
15 2 1  6 2   18 2 1  7 2   22 2 1  8 2   11 2 1  9 2   15 2 1 10 2
19 3 1 11 2   10 3 1 12 2   10 3 1 13 2   10 3 1 14 2   16 3 1 15 2
21 4 1 16 2   16 4 1 17 2   17 4 1 18 2    4 4 1 19 2   17 4 1 20 2
15 5 1 21 2   12 5 1 22 2   13 5 1 23 2   20 5 1 24 2    8 5 1 25 2
16 1 2  1 2    7 1 2  6 2   20 1 2 11 2   13 1 2 16 2   21 1 2 21 2
15 2 2  2 2   10 2 2  7 2   11 2 2 12 2    7 2 2 17 2   14 2 2 22 2
 7 3 2  3 2   11 3 2  8 2   15 3 2 13 2   15 3 2 18 2   16 3 2 23 2
19 4 2  4 2   14 4 2  9 2   20 4 2 14 2    6 4 2 19 2   16 4 2 24 2
17 5 2  5 2   18 5 2 10 2   20 5 2 15 2   15 5 2 20 2   14 5 2 25 2
;

proc lattice data=soy;
   var yield;
run;
