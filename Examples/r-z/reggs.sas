/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: reggs                                               */
/*   TITLE: Getting Started Examples for PROC REG               */
/*          1) Height, weight and age of children               */
/*          2) US population by decade                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Ordinary Least Squares Regression                   */
/*   PROCS: REG                                                 */
/*    DATA: USPopulation                                        */
/*                                                              */
/****************************************************************/

ods graphics on;

proc reg data=sashelp.class;
   model Weight = Height;
run;

data USPopulation;
   input Population @@;
   retain Year 1780;
   Year       = Year+10;
   YearSq     = Year*Year;
   Population = Population/1000;
   datalines;
3929 5308 7239 9638 12866 17069 23191 31443 39818 50155
62947 75994 91972 105710 122775 131669 151325 179323 203211
226542 248710 281422
;

proc reg data=USPopulation plots=ResidualByPredicted;
   var YearSq;
   model Population=Year / r clm cli;
run;

   add YearSq;
   print;
run;


proc reg data=USPopulation plots=predictions(X=Year);
   model Population=Year Yearsq;
quit;

ods graphics off;
