/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LATEX1                                              */
/*   TITLE: Documentation Example 1 for PROC LATTICE            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: LATTICE                                             */
/*   PROCS: LATTICE                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: COCHRAN, W.G. & COX, G.M.(1957), "EXPERIMENTAL      */
/*          DESIGNS", 2ND EDITION, NEW YORK: JOHN WILEY & SONS. */
/*    MISC:                                                     */
/****************************************************************/

data Soy(drop=plot);
   do Group = 1 to 2;
      do Block = 1 to 5;
         do Plot = 1 to 5;
            input Treatment Yield @@;
            output;
         end;
      end;
   end;
   datalines;
 1  6  2  7  3  5  4  8  5  6  6 16  7 12  8 12  9 13 10  8
11 17 12  7 13  7 14  9 15 14 16 18 17 16 18 13 19 13 20 14
21 14 22 15 23 11 24 14 25 14  1 24  6 13 11 24 16 11 21  8
 2 21  7 11 12 14 17 11 22 23  3 16  8  4 13 12 18 12 23 12
 4 17  9 10 14 30 19  9 24 23  5 15 10 15 15 22 20 16 25 19
;

proc lattice data=Soy;
run;

