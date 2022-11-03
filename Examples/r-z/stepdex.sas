
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: STEPDEX                                             */
/*   TITLE: Documentation Example for PROC STEPDISC             */
/* PRODUCT: SAS/STAT                                            */
/*  SYSTEM: ALL                                                 */
/*    KEYS: discriminant analysis, multivariate analysis        */
/*   PROCS: STEPDISC                                            */
/*    DATA: FISHER (1936) IRIS DATA - SASHELP.IRIS              */
/*                                                              */
/*     REF: PROC STEPDISC, EXAMPLE 1                            */
/*    MISC:                                                     */
/****************************************************************/

title 'Fisher (1936) Iris Data';

%let _stdvar = ;
proc stepdisc data=sashelp.iris bsscp tsscp;
   class Species;
   var SepalLength SepalWidth PetalLength PetalWidth;
run;

* print the macro variable list;
%put &_stdvar;

proc discrim data=sashelp.iris;
   class Species;
   var &_stdvar;
run;
