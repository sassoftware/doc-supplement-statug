/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: fmmex04                                             */
/*   TITLE: Documentation Example 4 for PROC FMM                */
/*          Multinomial Cluster Model                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Multinomial overdispersion                          */
/*          Information Criteria                                */
/*                                                              */
/*   PROCS: FMM                                                 */
/*    DATA: Housing satisfaction data, Wilson (1989).           */
/*                                                              */
/*     REF: Brier, S.S. (1980), Analysis of contingency tables  */
/*          under cluster sampling, Biometrika, 67, 591-596     */
/*                                                              */
/*     REF: Wilson J.R., (1989), Chi-square tests for           */
/*          overdispersion with multiparameter estimates,       */
/*          Journal of the Royal Statistical Society Series C   */
/*          (Applied Statistics), 38, 3, 441-453                */
/*                                                              */
/*     REF: Morel, J.G. and Nagaraj, N.K. [sic] (1993),         */
/*          A Finite Mixture Distribution for Modeling          */
/*          Multinomial Extra Variation, Biometrika, 80,        */
/*          363-371                                             */
/*                                                              */
/*    MISC:                                                     */
/****************************************************************/

data housing;
   label us    = 'Unsatisfied'
         s     = 'Satisfied'
         vs    = 'Very Satisfied';
   input type $ us s vs @@;
   datalines;
rural 3 2 0  rural 3 2 0  rural 0 5 0  rural 3 2 0  rural 0 5 0
rural 4 1 0  rural 3 2 0  rural 2 3 0  rural 4 0 1  rural 0 4 1
rural 2 3 0  rural 4 1 0  rural 4 1 0  rural 1 2 2  rural 4 1 0
rural 1 3 1  rural 4 1 0  rural 5 0 0
urban 0 4 1  urban 0 5 0  urban 0 3 2  urban 3 2 0  urban 2 3 0
urban 1 3 1  urban 4 1 0  urban 4 0 1  urban 0 3 2  urban 1 2 2
urban 0 5 0  urban 3 2 0  urban 2 3 0  urban 2 2 1  urban 4 0 1
urban 0 4 1  urban 4 1 0
;

proc fmm data=housing;
   class type;
   model us s vs = Type  / dist=multinomial;
   output out=Pred pred;
run;

data Pred; set Pred;
   Pred_1 = Pred_1 / (us + s + vs);
   Pred_2 = Pred_2 / (us + s + vs);
   Pred_3 = Pred_3 / (us + s + vs);
run;

proc sort data=Pred nodupkey;
  by type;
proc print data=pred noobs;
  var type pred:;
run;

proc fmm data=housing;
   class type;
   model us s vs = Type / dist=multinomcluster;
   output out=Pred pred;
   probmodel Type;
run;

data Pred; set Pred;
   Pred_1 = Pred_1 / (us + s + vs);
   Pred_2 = Pred_2 / (us + s + vs);
   Pred_3 = Pred_3 / (us + s + vs);
run;

proc sort data=Pred nodupkey;
  by type;
proc print data=pred noobs;
  var type pred:;
run;

