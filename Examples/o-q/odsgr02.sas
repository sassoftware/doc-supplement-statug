/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGR02                                             */
/*   TITLE: Getting Started 2, ODS Graphics                     */
/* PRODUCT: SAS                                                 */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics                                        */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
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


ods html;  /* On z/OS, replace this with ods html path=".";  */
ods graphics on;
ods trace on;

title 'Getting started example';
proc kde data = bivnormal;
   bivar x y / plots = contour surface;
run;

ods trace off;


title 'Selecting contour and surface plots';
ods select Contour SurfacePlot;

proc kde data = bivnormal;
   bivar x y / plots = contour surface;
run;

ods graphics off;
ods html close;
title;
