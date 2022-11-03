
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: STEPDGS                                             */
/*   TITLE: Getting Started Example for PROC STEPDISC           */
/* PRODUCT: SAS/STAT                                            */
/*  SYSTEM: ALL                                                 */
/*    KEYS: discriminant analysis, multivariate analysis        */
/*   PROCS: STEPDISC                                            */
/*    DATA: SASHELP.FISH DATA                                   */
/*                                                              */
/*     REF: PROC STEPDISC, GETTING STARTED EXAMPLE              */
/*    MISC:                                                     */
/****************************************************************/

title 'Fish Measurement Data';

proc stepdisc data=sashelp.fish;
   class Species;
run;
