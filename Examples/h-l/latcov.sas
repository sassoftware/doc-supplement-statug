 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: LATCOV                                              */
 /*   TITLE: Getting Started Example for PROC LATTICE            */
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

 /****************************************************************/
 /* This example shows the covariance option with PROC LATTICE.  */
 /* the data set specifies a 3x4 triple rectangular lattice      */
 /* design (three orthogonal replications).  This dataset has    */
 /* two response variables (Yield and Weight).  Specifying the   */
 /* covariance option gives an ANOVA table for each variable     */
 /* plus an analysis of covariance table for Yield and Weight.   */
 /****************************************************************/

 /* This dataset is from Cochran & Cox p. 418.     */
 /* The variable Weight is added for this example. */

data TestCov;
  input Group Block Treatmnt Yield Weight;
datalines;
1 1  1 16 2.20
1 1  2  9 1.84
1 1  3  4 2.18
1 2  4  0 2.05
1 2  5  3 0.85
1 2  6 11 1.86
1 3  7 16 0.73
1 3  8 23 1.60
1 3  9 15 1.76
1 4 10  7 1.19
1 4 11 11 1.20
1 4 12 12 1.15
2 1  4  5 2.26
2 1  7 14 1.07
2 1 10  6 1.45
2 2  1 17 2.12
2 2  8 19 2.03
2 2 11  8 1.63
2 3  2 10 1.81
2 3  5  6 1.16
2 3 12  9 1.11
2 4  3 11 1.76
2 4  6 20 2.16
2 4  9 17 1.80
3 1  6 15 1.71
3 1  8 20 1.57
3 1 12 10 1.13
3 2  2 15 1.77
3 2  9 16 1.57
3 2 10  9 1.43
3 3  3  3 1.50
3 3  4  1 1.60
3 3 11  6 1.42
3 4  1 22 2.04
3 4  5 11 0.93
3 4  7 17 1.78
;

 /* The COVARIANCE option is specified which produces an */
 /* Analysis of Covariance table.                        */

proc lattice data=testcov cov;
   var yield weight;
run;

 /* The COVARIANCE option is not specified, so the      */
 /* Analysis of Covariance table is not produced.       */

proc lattice data=testcov;
   var yield weight;
run;

 /****************************************************************/
 /* These next steps provide another example of the covariance   */
 /* option w/ PROC LATTICE. This data set specifies a 5x5 square */
 /* lattice design.  There are two response variables (Yield and */
 /* Height).  Specifying the covariance option gives an ANOVA    */
 /* table for each variable plus an analysis of covariance table */
 /* for Yield and Height.                                        */
 /****************************************************************/

data TestCov2;
 input Treatmnt Yield Block Group Height;
datalines;
 1  6 1 1 2.20
 2  7 1 1 1.84
 3  5 1 1 2.18
 4  8 1 1 2.05
 5  6 1 1 0.85
 6 16 2 1 1.86
 7 12 2 1 0.73
 8 12 2 1 1.60
 9 13 2 1 1.76
10  8 2 1 1.19
11 17 3 1 1.20
12  7 3 1 1.15
13  7 3 1 2.26
14  9 3 1 1.07
15 14 3 1 1.45
16 18 4 1 2.12
17 16 4 1 2.03
18 13 4 1 1.63
19 13 4 1 1.81
20 14 4 1 1.16
21 14 5 1 1.11
22 15 5 1 1.76
23 11 5 1 2.16
24 14 5 1 1.80
25 14 5 1 1.71
 1 24 1 2 1.57
 6 13 1 2 1.13
11 24 1 2 1.77
16 11 1 2 1.57
21  8 1 2 1.43
 2 21 2 2 1.50
 7 11 2 2 1.60
12 14 2 2 1.42
17 11 2 2 2.04
22 23 2 2 0.93
 3 16 3 2 1.78
 8  4 3 2 2.25
13 12 3 2 2.84
18 12 3 2 2.58
23 12 3 2 2.05
 4 17 4 2 0.85
 9 10 4 2 1.96
14 30 4 2 0.73
19  9 4 2 1.60
24 23 4 2 1.36
 5 15 5 2 1.19
10 15 5 2 1.20
15 22 5 2 1.75
20 16 5 2 2.26
25 19 5 2 1.37
;

 /* PROC LATTICE without the COV option */
proc lattice data=testcov2;
   var yield height;
run;

 /* PROC LATTICE with the COV option   */
proc lattice data = testcov2 cov;
   variables yield height;
run;
