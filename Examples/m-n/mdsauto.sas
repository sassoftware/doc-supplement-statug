 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: mdsauto                                             */
 /*   TITLE: Similarities of Automobiles with Confidence Ratings */
 /* PRODUCT: stat                                                */
 /*  SYSTEM: all                                                 */
 /*    KEYS: multidimensional scaling                            */
 /*   PROCS: mds                                                 */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: Null & Sarle, 1982 (SUGI Proceedings)               */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title "Similarities of Automobiles with Confidence Ratings";

data autosim;
   Subject = floor((_n_-1)/20)+1;
   input (VolvoWagon AstonMartin DeLorean Chevette RabbitDiesel
          Jaguar Mustang Triumph Continental Omega Datsun LeBaron
          Hornet HondaCivic Squire LeMans Riviera SaabTurbo
          Champ Mercedes) (2.);
   label
      volvowagon   = 'Volvo Wagon'
      astonmartin  = 'Aston-Martin'
      delorean     = 'De Lorean'
      chevette     = 'Chevette'
      rabbitdiesel = 'Rabbit Diesel'
      jaguar       = 'Jaguar XKE'
      mustang      = 'Mustang GT'
      triumph      = 'Triumph TR7'
      continental  = 'Continental'
      omega        = 'Omega'
      datsun       = 'Datsun 210'
      lebaron      = 'Le Baron'
      hornet       = 'Hornet'
      hondacivic   = 'Civic'
      squire       = 'Country Squire'
      lemans       = 'Le Mans'
      riviera      = 'Riviera'
      saabturbo    = 'Saab Turbo'
      champ        = 'Champ'
      mercedes     = 'Mercedes 300d';
   datalines;
-1
 7
 8 3
 6 7 5
 7 5 5 0
 9 3 510 8
-1 5 5 9 8 8
10 3 5 8 7 1 2
 7 5 71010 8 8 9
 6 7 5 6 8 7 5 7 3
 8 5 5 3 1 8 7 8 9 7
 7 5 5 9 9 6 6 9 2 2 8
 5 7 3 5 6 7 8 810 6 4 6
 4 5 3 1 010 7 610 7 9 8 4
 3 6 5 5 6 6 7 5 9 5 5 6 4 7
 6 4 5 7 7 6 5 6 3 2 8 1 5 8 6
 6 5 5 6 7 8 6 7 3 6 7 2 6 5 410
 8 5 4 6 6 2 3 3 8 6 8 8 6 5 8 7 6
 5 8 5 1 0 8 8 7 9 8 2 8 7 0 6 9 7 7
 8 5 3 8 5 4 4 2 7 8 8 6 8 6 6 5 6 3 7
-1
 8
 8 6
 710 9
 5 8 8 4
 7 3 4 9 9
 7 9 5 7 4 9
 8 4 5 8 5 8 3
 8 8 6 8 8 7 6 9
 8 4 9 6 4 9 5 7 5
 7 3 4 8 2 8 3 8 6 7
 8 9 9 7 7 7 8 710 5 4
 7 8 9 6 6 6 5 4 3 5 8 6
 9 7 9 9 3 7 5 3 8 3 6 7 4
 3 9 8 7 7 8 6 7 8 910 7 7 7
 5 9 9 8 4 8 5 8 3 3 5 4 5 7 6
 6 9 8 7 4 6 510 4 2 6 8 7 3 5 1
 8 3 4 6 6 2 6 3 4 7 9 410 9 8 7 8
 4 6 4 3 7 9 9 310 7 4 4 7 4 9 7 4 8
 7 2 8 9 8 8 8 810 9 7 9 9 9 9 8 9 2 9
-1
 5
 8 5
 5 5 9
 3 9 8 1
 7 8 5 8 9
 5 5 5 8 2 2
 5 7 5 9 9 4 2
10 3 51010 8 2 8
 5 3 710 8 5 7 6 3
 3 7 5 2 1 5 2 5 9 8
 8 3 4 9 9 6 8 7 7 2 8
 5 5 5 1 5 5 5 5 3 6 5 9
 4 8 5 1 2 9 3 710 8 5 7 2
 6 7 5 7 6 9 6 8 8 7 7 1 5 3
 7 5 5 8 6 7 3 8 7 6 5 2 5 6 1
 6 5 5 7 9 9 8 7 3 4 8 1 6 6 1 1
 5 7 5 8 7 4 2 2 7 5 6 9 5 7 8 9 6
 3 5 7 2 1 8 5 9 9 8 3 7 2 2 4 3 2 8
 5 2 21010 5 5 6 4 2 9 8 5 9 9 8 5 6 9
-1
 6
 9 0
 9 810
 81010 0
 4 4 31010
 910 7 4 010
 010 8 2 4 2 8
10-1 3101010 410
 9 4 6 81010 01010
 910 210 0 810 0 8 8
 6 7 210 8 7 010 0 3 9
10 3 9 7 0 0 0 7 9 010 8
 9 610 0 010 71010 9 8 8 5
 8 810 01010 8 8 8 410 0 8 4
 9 31010 9 8 410 3 010 0 6 9 3
 7 3 81010 8 710 0-1 9 2 31010 1
10 0 0 910 0 6-1 8 8 1 710 5 910 7
 8 010 0 0 0 1 6 8 510 9 7 110 3 8 7
10 0 01010 9 8 610 7 4 7 910 210 8 210
-1
 3
 4 4
 2 3 6
 2 1 7 1
 5 4 2 4 3
 8 5 7 3 9 3
 3 6 4 1 2 3 4
 7 2 410 9 9 810
 2 5 9 8 8 7 910 2
 2 5 8 3 3 3 3 310 8
 8 7 8 8 9 8 710 1 8 9
 4 6 3 9 9 7 310 4 810 2
 2 3 7 2 2 2 7 210 8 1 810
-1 5 4 8 7101010 3 7 9 2 8 8
 8 9 4 8 7 8 7 8 1 3 7 2 8 9 1
 9 9 2 8 8 9 8 8 1 9 7 1 5 9 2 6
 4 5 2 2 3 3 3 2 4 6 5 3 4 2 9 8 4
 7 5 3 9 7 8 510 1 3 7 2 4 8 3 3 8 4
 4 2 4 6 3 2 5 2 9 9 3 3 8 2 8 8 5 4 7
-1
 7
 9 3
 81010
 7 910 4
 8 3 3 9 9
 9 4 7 5 6 6
 9 4 2 8 8 3 3
 8 5 5 9 8 3 810
 7 8 8 8 7 7 6 8 6
 8 910 2 4 9 5 6 8 6
 7 9 8 8 7 8 7 9 4 3 9
 5 910 4 3 9 610 9 6 3 8
 7 9 9 4 4 9 7 8 9 7 3 7 3
 4 910 9 8 9 7 8 8 7 8 7 8 8
 8 8 8 7 8 7 6 8 7 2 7 3 7 8 7
 7 7 8 8 6 7 7 9 5 2 9 3 8 8 5 2
 5 4 4 8 7 5 6 4 5 7 8 6 8 8 9 7 5
 9 910 3 6 8 6 810 7 3 7 3 3 8 6 8 8
 7 4 510 4 2 8 8 4 810 810 9 9 8 5 410
-1
 4
 5 4
 81010
 6 3 9 2
 3 4 210 9
 7 6 9 3 5 9
 7 2 5 4 5 3 4
 6 9 910 9 6 8 9
 7 9 9 3 6 8 4 8 6
 9 7 9 3 310 3 510 6
 8 910 5 6 9 5 6 4 1 6
 7 910 2 510 510 9 8 5 5
 9 710 3 4 9 3 410 7 2 7 5
 41010 7 6 8 8 9 4 3 8 4 7 9
 9 8 9 6 8 7 5 7 8 1 5 1 7 5 8
 7 6 5 8 7 6 7 7 4 4 8 2 810 3 2
 2 6 3 8 4 1 9 5 4 7 8 7 9 710 8 5
 8 910 2 5 9 3 4 8 5 3 6 5 310 4 8 7
 4 3 210 5 2 8 4 4 9 8 71010 7 8 7 2 9
-1
 3
 5 5
 5 4 4
 4 6 6 6
 8 4 5 710
 8 4 3 2 4 4
 8 8 4 8 9 1 4
 8 4 3 710 2 8 2
 5 4 5 2 5 8 6 7 7
 4 3 5 3 2 8 3 6 7 5
 6 2 3 4 6 6 6 6 4 3 4
 4 2 5 5 7 7 2 3 5 2 2 5
 2 4 5 4 1 8 7 7 9 6 1 4 1
 1 5 5 4 2 9 5 7 6 4 4 4 5 4
 4 5 3 2 7 4 3 4 4 4 7 4 5 8 5
 5 5 4 2 6 6 5 4 4 3 7 2 6 7 4 2
 4 5 7 6 4 2 1 2 2 6 6 6 4 6 8 4 4
 6 4 4 3 6 7 8 7 5 4 6 4 6 7 4 3 3 7
 7 6 8 8 4 2 7 8 1 7 6 4 4 8 9 4 4 8 6
-1
 8
 7 4
 2 5 9
 3 7 9 1
 8 2 3 910
 8 2 4 6 7 2
 8 2 3 6 6 2 3
 8 4 11010 4 8 4
 5 5 4 8 3 4 6 7 4
 2 8 7 2 3 9 6 9 9 5
 7 3 2 7 8 3 7 4 1 5 9
 3 8 9 1 3 9 6 8 9 5 3 8
 3 6 9 2 1 9 5 5 9 7 2 7 2
 4 6 6 5 4 7 7 8 3 6 5 4 6 6
 6 4 3 8 7 4 4 5 3 5 7 2 8 7 4
 7 5 3 7 7 7 5 8 2 1 7 1 7 8 4 2
 2 4 5 7 5 3 5 2 4 6 4 4 3 4 5 4 7
 2 5 9 2 1 8 4 6 6 3 2 8 1 3 5 5 6 9
 6 2 1 6 5 4 5 4 3 5 8 3 8 5 6 4 3 2 9
-1
 5
 8 5
 5 5 9
 5 8 8 1
 8 9 9 6 4
 5 8 8 3 7 5
 7 8 8 4 4 4 4
 5 3 3 910 9 7 8
 7 5 5 3 6 5 5 5 8
 5 9 8 1 3 5 3 4 9 5
 7 2 3 9 9 9 9 9 3 8 9
 7 8 9 4 3 3 4 3 9 5 3 9
 2 8 8 1 1 7 5 410 6 3 9 4
 5 5 5 9 9 9 8 9 8 5 81010 9
 8 5 51010 9 8 9 8 3 9 2 8 910
 8 5 3 9 9 8 7 8 3 5 8 3 8 9 7 2
 6 8 9 5 5 4 8 3 8 5 3 8 5 4 5 7 6
 5 5 5 7 9 5 5 7 6 5 7 8 7 8 5 5 5 5
 4 6 6 6 4 6 4 5 8 5 5 7 3 4 9 8 5 4 7
;

data autocon;
   Subject=floor((_n_-1)/20)+1;
   input (w1-w20) (2.);
   datalines;
 0
 1
 1 0
 9 2 1
 9 1 110
 9 1 110 8
 0 2 110 9 9
10 2 2 9 91010
 9 1 11010 9 910
 7 6 1 9 8 9 8 9 8
 7 3 11010 6 9 910 9
 9 1 0 9 9 8 9 91010 8
 8 7 1 6 6 7 8 810 8 7 6
 8 2 1101010 9 810 810 8 7
 8 2 1 9 9 6 8 7 9 7 9 6 7 8
 7 2 1 7 8 9 8 8 9 91010 5 8 6
 5 1 1 9 9 9 7 9 9 9 9 9 6 8 010
 9 3 2 9 810 9 9 9 5 9 8 7 8 9 9 8
 7 1 31010 8 9 810 710 8 610 610 8 9
10 1 210 8 8 910 9 6 7 9 8 8 6 7 8 9 7
 0
 3
 3 8
 8 3 5
 6 8 3 7
 6 9 3 0 8
 9 7 3 8 5 9
 9 6 7 7 8 6 8
 8 7 2 8 9 3 7 9
 1 5 1 7 6 9 8 7 3
 8 4 7 7 8 7 7 6 7 7
 9 2 3 9 8 5 6 810 8 8
 7 8 3 6 5 7 8 9 6 9 8 5
 8 1 4 5 9 7 8 5 8 6 6 8 3
 8 2 3 8 9 9 8 5 3 9 8 2 8 9
 8 2 3 8 7 8 9 7 8 9 8 9 8 8 9
 8 8 3 9 9 9 7 9 8 8 7 8 8 8 9 9
 3 7 3 9 4 9 3 7 9 8 7 5 6 9 7 9 7
 8 1 510 8 7 8 6 9 2 9 8 8 7 8 7 4 9
 8 5 5 9 7 9 7 9 7 7 7 910 8 9 8 8 8 9
 0
 0
 4 0
 1 0 7
 7 8 610
 9 6 0 910
 0 0 110 7 8
 7 8 010 9 510
10 6 0101010 910
 0 5 31010 0 9 3 9
 6 9 0 7 9 4 8 5 9 7
 9 7 4 910 8 9 9 8 8 9
 0 0 0 9 0 0 0 8 6 0 0 9
 6 7 0101010 7 910 9 8 9 9
 8 8 0 2 8 9 810 9 9 9 8 1 9
 9 0 0 9 7 9 6 9 810 8 8 0 8 9
 8 0 1 810 9 9 8 8 7 910 910 9 8
 5 2 01010 9 910 9 0 910 0 7 810 8
 8 0 2 91010 11010 9 9 9 810 9 7 8 9
 2 2 41010 0 7 8 8 810 7 3101010 8 9 9
 0
10
 910
 9 8 9
 910 810
 8 5 91010
 610 5 810 9
1010 9 2 9 910
 7 01010 710 610
 9 5 91010101010 8
 910 810 9 7 810 7 9
 8 5 810 8 8101010 9 9
 4 2 9 7 5 01010 91010 9
10 51010 010 8101010 9 9 8
 7 01010 71010 8 8 8101010 6
10 8 710 8 9 3 7 910 810 710 4
 8 9 7 910 7 81010 010 8 3 8 3 9
 91010101010 9 0 9 9 9 910 010 8 8
 8 0 41010 510 8 8 610 9 710 9 8 7 8
 6101010 9 7 9 910 6 710 910 8 710 910
 0
 1
 4 1
10 1 8
10 1 310
 9 2 21010
10 1 310 910
10 1 1 9 9 810
10 1 010 9101010
 9 1 21010 9 8 710
10 1 1 910 9 81010 8
 8 2 2 9 9 7101010 8 8
10 0 61010 9101010101010
 9 1 310 910101010 7101010
 0 1 4101010101010 910 91010
 9 2 4 9 7 8101010 8 8 9101010
 8 0 31010 9 9 810 6 9 9101010 0
 4 0 1 2 2 0 2 2 3 2 0 3 4 4 2 4 3
10 1 11010 8 4 9 9 710 9 9 9 9 8 8 1
 9 2 0 810 7 91010 7 9 8 910101010 3 5
 0
 9
 9 9
 9 910
 9 9 9 9
 9 9 9 9 9
 9 9 9 9 9 9
 9 9 9 9 9 9 9
 9 9 9 9 9 9 910
 9 9 9 9 9 9 9 9 9
 9 9 9 9 9 9 9 9 9 9
 9 9 9 9 9 9 9 9 9 9 9
 9 9 9 9 9 9 9 9 9 9 9 9
 9 9 9 9 9 9 9 9 9 9 9 9 9
 9 9 9 9 9 9 9 9 9 9 9 9 9 9
 9 9 9 9 9 9 9 9 9 8 9 9 9 9 9
 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9
 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9
 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9
 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9
 0
 9
 5 9
 91010
 9 910 9
10 7101010
 9 7 9 8 6 9
 9 9 7 8 7 8 8
 8101010 8 8 8 9
 810 9 9 8 8 8 9 8
 8 810 8 910 9 710 8
 8 910 9 7 9 5 8 710 8
 91010 9 810 510 910 7 8
 9 810 9 8 9 7 810 910 9 9
 81010 9 9 9 810 910 9 9 910
 91010 7 8 9 510 910 910 8 610
 8 8 6 810 8 8 9 9 9 9 8 9101010
10 6 9 9 81010 610 7 8 910 810 9 6
 9 81010 9 910 9 9 7 8 8 8 910 7 8 9
 8 71010 910 710 910 8 71010 9 81010 9
 0
 0
 3 0
 6 0 0
 6 0 0 3
 7 0 0 6 9
 7 0 0 6 5 6
 7 1 0 21010 8
 7 0 0 510 9 8 7
 4 0 0 4 2 1 2 8 3
 6 0 0 1 8 8 6 6 9 4
 1 0 0 4 5 6 3 2 4 3 4
 0 0 1 0 1 4 5 3 0 0 0 1
 9 1 0 4 9 8 710 9 210 1 2
 9 0 0 4 1 9 4 7 9 1 6 3 0 6
 6 0 3 6 6 7 9 6 9 4 7 4 3 8 6
 3 0 1 5 3 6 4 5 4 4 4 4 2 6 5 7
 4 0 0 1 1 4 3 4 2 3 4 1 3 3 1 1 4
 2 0 0 5 3 4 3 5 2 3 6 3 3 3 2 4 5 1
 8 0 0 4 9 7 5 910 3 8 2 4 8 7 8 3 5 2
 0
 3
 5 3
 7 4 7
 9 3 7 8
 7 4 5 8 8
 6 6 6 6 6 8
 7 5 8 8 8 9 7
 7 4 71010 8 8 8
 3 3 7 6 5 9 4 5 8
 7 5 5 7 8 8 6 7 9 6
 6 6 8 6 7 7 5 6 6 6 7
 7 8 7 9 8 8 6 7 7 3 7 5
 8 6 8 7 7 9 6 9 8 6 6 8 9
 6 5 5 6 4 8 6 5 7 6 8 6 6 5
 7 7 7 7 7 6 6 5 5 3 7 8 8 6 5
 8 6 2 8 6 6 6 6 7 4 5 7 6 6 5 7
 5 5 5 8 6 7 5 5 6 5 7 5 7 7 6 8 7
 7 2 7 7 9 8 5 7 7 6 8 8 9 8 8 5 5 7
 7 5 7 7 6 6 5 7 8 7 7 7 5 7 5 7 6 8 6
 0
 2
 8 3
 5 3 5
 4 7 3 9
 7 6 8 5 6
 5 5 2 3 6 2
 7 4 5 5 8 5 4
 3 8 7 9 9 8 4 6
 5 2 3 6 3 3 3 3 6
 3 2 8 9 8 4 8 5 8 5
 8 5 3 9 9 7 8 7 8 5 8
 5 7 7 8 8 5 5 8 8 3 4 9
 7 4 5 8 8 5 4 8 9 5 8 8 6
 2 2 2 8 8 8 8 2 8 2 8 6 9 9
 5 3 3 8 9 7 6 8 2 7 7 6 8 910
 7 2 4 8 8 7 6 8 8 3 7 5 8 7 6 6
 5 6 2 2 3 6 5 7 7 2 5 7 5 7 2 6 2
 5 3 2 3 6 1 3 5 3 3 6 3 8 4 3 5 3 3
 2 4 6 9 4 7 5 2 8 2 3 6 3 7 8 7 6 6 3
;

data auto;
   merge autosim autocon;
run;

ods graphics on;

title2 "Fitting Squared Distances";
title3 "ALSCAL S-Stress=.44724";
proc mds fit=2 data=autosim coef=diag level=ordinal;
   var volvowagon -- mercedes;
   subject subject;
run;

title2 "Fitting Distances";
proc mds data=autosim coef=diag level=ordinal;
   var volvowagon -- mercedes;
   subject subject;
run;

title3 "With Confidence Ratings Used as Data Weights";
proc mds data=auto coef=diag level=ordinal;
   var volvowagon -- mercedes;
   weight w1-w20;
   subject subject;
run;

ods graphics off;
