
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: DISCGS                                              */
/*   TITLE: Getting Started Example for PROC DISCRIM            */
/* PRODUCT: SAS/STAT                                            */
/*  SYSTEM: ALL                                                 */
/*    KEYS: discriminant analysis                               */
/*   PROCS: DISCRIM                                             */
/*    DATA: SASHELP.FISH DATA                                   */
/*                                                              */
/*     REF: PROC DISCRIM, GETTING STARTED EXAMPLE               */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

title 'Fish Measurement Data';

proc discrim data=sashelp.fish;
   class Species;
run;
