/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: KDEGS                                               */
/*   TITLE: Getting Started Example for PROC KDE                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: kernel density estimation, ODS Graphics             */
/*   PROCS: KDE                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC KDE Getting Started Example                    */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data bivnormal;
   seed = 1283470;
   do i = 1 to 1000;
      z1 = rannor(seed);
      z2 = rannor(seed);
      z3 = rannor(seed);
      x = 3*z1+z2;
      y = 3*z1+z3;
      output;
   end;
   drop seed;
run;


ods graphics on;
proc kde data=bivnormal;
   bivar x y / plots=(contour surface);
run;
ods graphics off;
