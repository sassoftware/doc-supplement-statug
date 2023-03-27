/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TREGEX4                                             */
/*   TITLE: Documentation Example 4 for PROC TRANSREG           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: marketing research                                  */
/*   PROCS: TRANSREG                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC TRANSREG, EXAMPLE 4                            */
/*    MISC:                                                     */
/****************************************************************/

title 'Nonmetric Conjoint Analysis of Ranks';

proc format;
   value BrandF
              1 = 'Goodstone'
              2 = 'Pirogi   '
              3 = 'Machismo ';
   value PriceF
              1 = '$69.99'
              2 = '$74.99'
              3 = '$79.99';
   value LifeF
              1 = '50,000'
              2 = '60,000'
              3 = '70,000';
   value HazardF
              1 = 'Yes'
              2 = 'No ';
run;

data Tires;
   input Brand Price Life Hazard Rank;
   format Brand BrandF9. Price PriceF9. Life LifeF6. Hazard HazardF3.;
   datalines;
1 1 2 1  3
1 1 3 2  2
1 2 1 2 14
1 2 2 2 10
1 3 1 1 17
1 3 3 1 12
2 1 1 2  7
2 1 3 2  1
2 2 1 1  8
2 2 3 1  5
2 3 2 1 13
2 3 2 2 16
3 1 1 1  6
3 1 2 1  4
3 2 2 2 15
3 2 3 1  9
3 3 1 2 18
3 3 3 2 11
;

proc transreg maxiter=50 utilities short;
   ods select TestsNote ConvergenceStatus FitStatistics Utilities;
   model monotone(Rank / reflect) =
         class(Brand Price Life Hazard / zero=sum);
   output ireplace predicted;
run;

proc print label;
   var Rank TRank PRank Brand Price Life Hazard;
   label PRank = 'Predicted Ranks';
run;

