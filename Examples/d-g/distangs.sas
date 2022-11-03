/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: distangs                                            */
/*   TITLE: Getting Started Example for PROC DISTANCE           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Distance Matrix, Cluster Analysis                   */
/*   PROCS: DISTANCE, CLUSTER, PRINT                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC DISTANCE, Getting Started Example              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data Protein;
   length Country $ 14;
   input Country &$ RedMeat WhiteMeat Eggs Milk
                      Fish Cereal Starch Nuts FruitVeg;
   datalines;
Albania            10.1  1.4  0.5   8.9  0.2  42.3  0.6  5.5  1.7
Austria             8.9 14.0  4.3  19.9  2.1  28.0  3.6  1.3  4.3
Belgium            13.5  9.3  4.1  17.5  4.5  26.6  5.7  2.1  4.0
Bulgaria            7.8  6.0  1.6   8.3  1.2  56.7  1.1  3.7  4.2
Czechoslovakia      9.7 11.4  2.8  12.5  2.0  34.3  5.0  1.1  4.0
Denmark            10.6 10.8  3.7  25.0  9.9  21.9  4.8  0.7  2.4
E Germany           8.4 11.6  3.7  11.1  5.4  24.6  6.5  0.8  3.6
Finland             9.5  4.9  2.7  33.7  5.8  26.3  5.1  1.0  1.4
France             18.0  9.9  3.3  19.5  5.7  28.1  4.8  2.4  6.5
Greece             10.2  3.0  2.8  17.6  5.9  41.7  2.2  7.8  6.5
Hungary             5.3 12.4  2.9   9.7  0.3  40.1  4.0  5.4  4.2
Ireland            13.9 10.0  4.7  25.8  2.2  24.0  6.2  1.6  2.9
Italy               9.0  5.1  2.9  13.7  3.4  36.8  2.1  4.3  6.7
Netherlands         9.5 13.6  3.6  23.4  2.5  22.4  4.2  1.8  3.7
Norway              9.4  4.7  2.7  23.3  9.7  23.0  4.6  1.6  2.7
Poland              6.9 10.2  2.7  19.3  3.0  36.1  5.9  2.0  6.6
Portugal            6.2  3.7  1.1   4.9 14.2  27.0  5.9  4.7  7.9
Romania             6.2  6.3  1.5  11.1  1.0  49.6  3.1  5.3  2.8
Spain               7.1  3.4  3.1   8.6  7.0  29.2  5.7  5.9  7.2
Sweden              9.9  7.8  3.5   4.7  7.5  19.5  3.7  1.4  2.0
Switzerland        13.1 10.1  3.1  23.8  2.3  25.6  2.8  2.4  4.9
UK                 17.4  5.7  4.7  20.6  4.3  24.3  4.7  3.4  3.3
USSR                9.3  4.6  2.1  16.6  3.0  43.6  6.4  3.4  2.9
W Germany          11.4 12.5  4.1  18.8  3.4  18.6  5.2  1.5  3.8
Yugoslavia          4.4  5.0  1.2   9.5  0.6  55.9  3.0  5.7  3.2
;

title 'Protein Consumption in Europe';
proc distance data=Protein out=Dist method=Euclid;
   var interval(RedMeat--FruitVeg / std=Std);
   id Country;
run;

proc print data=Dist(obs=10);
   title2 'First 10 Observations in Output Data Set from PROC DISTANCE';
run;
title2;

ods graphics on;

proc cluster data=Dist method=Ward plots=dendrogram(height=rsq);
   id Country;
run;