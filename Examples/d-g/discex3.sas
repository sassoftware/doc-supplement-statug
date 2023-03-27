/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: DISCEX3                                             */
/*   TITLE: Documentation Example 3 for PROC DISCRIM            */
/* PRODUCT: SAS/STAT                                            */
/*  SYSTEM: ALL                                                 */
/*    KEYS: discriminant analysis                               */
/*   PROCS: DISCRIM                                             */
/*    DATA: FISHER (1936) IRIS DATA - SASHELP.IRIS              */
/*                                                              */
/*     REF: PROC DISCRIM, EXAMPLE 3                             */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

title 'Discriminant Analysis of Fisher (1936) Iris Data';
title2 'Using Quadratic Discriminant Function';

proc discrim data=sashelp.iris outstat=irisstat
   wcov pcov method=normal pool=test
   distance anova manova listerr crosslisterr;
   class Species;
   var SepalLength SepalWidth PetalLength PetalWidth;
run;

proc print data=irisstat;
   title2 'Output Discriminant Statistics';
run;

