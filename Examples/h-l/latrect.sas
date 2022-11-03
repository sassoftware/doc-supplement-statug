 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: LATRECT                                             */
 /*   TITLE: Rectangular Lattice Designs (Simple and Triple)     */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: LATTICE                                             */
 /*   PROCS: LATTICE                                             */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: COCHRAN, W.G. & COX, G.M.(1957), "EXPERIMENTAL      */
 /*          DESIGNS", 2ND EDITION, NEW YORK: JOHN WILEY & SONS. */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

 /* Data for Rectangular Lattice */

 /****************************************************************/
 /* These data show a rectangular lattice design with PROC       */
 /* LATTICE. The data specify a 3x4 triple rectangular lattice   */
 /* design (three orthogonal replications).                      */
 /* The response variable is Weight.                             */
 /****************************************************************/

data cow;
  input Group Block Treatmnt Weight @@;
datalines;
1 1 1 16   1 1 2  9   1 1  3  4   1 2  4  0   1 2  5  3   1 2  6 11
1 3 7 16   1 3 8 23   1 3  9 15   1 4 10  7   1 4 11 11   1 4 12 12
2 1 4  5   2 1 7 14   2 1 10  6   2 2  1 17   2 2  8 19   2 2 11  8
2 3 2 10   2 3 5  6   2 3 12  9   2 4  3 11   2 4  6 20   2 4  9 17
3 1 6 15   3 1 8 20   3 1 12 10   3 2  2 15   3 2  9 16   3 2 10  9
3 3 3  3   3 3 4  1   3 3 11  6   3 4  1 22   3 4  5 11   3 4  7 17
;

proc lattice data=cow;
   var weight;
run;

 /****************************************************************/
 /* These data show by-processing with PROC LATTICE. The first   */
 /* by-group is a 3x4 triple rectangular lattice design (three   */
 /* orthogonal replications). The 2nd by-group is a 4x5 simple   */
 /* rectangular lattice design (two orthogonal replications.     */
 /* The by-var here is the variable Design.                      */
 /* The response variable is Yield.                              */
 /****************************************************************/

data rect;
  input Group Block Treatmnt Yield Design @@;
datalines;
1 1 1  .89 1   1 1 2  .55 1   1 1 3  .65 1   1 2 4  .96 1   1 2 5  .75 1
1 2 6  .96 1   1 3 7  .35 1   1 3 8  .12 1   1 3 9  .15 1   1 4 10 .93 1
1 4 11 .14 1   1 4 12 .15 1   2 1 4  .23 1   2 1 7  .65 1   2 1 10 .98 1
2 2 1  .63 1   2 2 8  .98 1   2 2 11 .12 1   2 3 2  .65 1   2 3 5  .65 1
2 3 12 .35 1   2 4 3  .49 1   2 4 6  .98 1   2 4 9  .78 1   3 1 6  .95 1
3 1 8  .29 1   3 1 12 .85 1   3 2 2  .25 1   3 2 9  .14 1   3 2 10 .76 1
3 3 3  .35 1   3 3 4  .97 1   3 3 11 .15 1   3 4 1  .35 1   3 4 5  .15 1
3 4 7  .48 1
1 1 1  16  2   1 1 2   9  2   1 1 3   4  2   1 1 4   0  2   1 2 5   3  2
1 2 6  11  2   1 2 7  16  2   1 2 8  23  2   1 3 9  15  2   1 3 10  7  2
1 3 11 11  2   1 3 12 12  2   1 4 13  8  2   1 4 14 13  2   1 4 15  0  2
1 4 16  5  2   1 5 17 14  2   1 5 18  9  2   1 5 19  8  2   1 5 20  7  2
2 1 5   5  2   2 1 9  14  2   2 1 13  6  2   2 1 17 17  2   2 2 1  19  2
2 2 10  8  2   2 2 14 10  2   2 2 18  6  2   2 3 2   9  2   2 3 6  11  2
2 3 15 20  2   2 3 19 17  2   2 4 3  15  2   2 4 7  20  2   2 4 11 10  2
2 4 20 15  2   2 5 4  16  2   2 5 8   9  2   2 5 12  3  2   2 5 16  7  2
;

proc lattice data=rect;
   by design;
   var yield;
run;
