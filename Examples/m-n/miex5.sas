/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIEX5                                               */
/*   TITLE: Documentation Example 5 for PROC MI                 */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple imputation                                 */
/*   PROCS: MI                                                  */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MI, EXAMPLE 5                                  */
/*    MISC:                                                     */
/****************************************************************/

*-----------------------------Fish2 Data-----------------------------*
| The data set contains two species of the fish (Parkki and Perch)   |
| and two measurements: Length and Width.                            |
| Some values have been set to missing, and the resulting data set   |
| has a monotone missing pattern in the variables                    |
| Length, Width, and Species.                                        |
*--------------------------------------------------------------------*;
data Fish2;
   title 'Fish Measurement Data';
   input Species $ Length Width @@;
   datalines;
Parkki  16.5  2.3265    Parkki  17.4  2.3142    .      19.8   .
Parkki  21.3  2.9181    Parkki  22.4  3.2928    .      23.2  3.2944
Parkki  23.2  3.4104    Parkki  24.1  3.1571    .      25.8  3.6636
Parkki  28.0  4.1440    Parkki  29.0  4.2340    Perch   8.8  1.4080
.       14.7  1.9992    Perch   16.0  2.4320    Perch  17.2  2.6316
Perch   18.5  2.9415    Perch   19.2  3.3216    .      19.4   .
Perch   20.2  3.0502    Perch   20.8  3.0368    Perch  21.0  2.7720
Perch   22.5  3.5550    Perch   22.5  3.3075    .      22.5   .
Perch   22.8  3.5340    .       23.5   .        Perch  23.5  3.5250
Perch   23.5  3.5250    Perch   23.5  3.5250    Perch  23.5  3.9950
.       24.0   .        Perch   24.0  3.6240    Perch  24.2  3.6300
Perch   24.5  3.6260    Perch   25.0  3.7250    .      25.5  3.7230
Perch   25.5  3.8250    Perch   26.2  4.1658    Perch  26.5  3.6835
.       27.0  4.2390    Perch   28.0  4.1440    Perch  28.7  5.1373
.       28.9  4.3350    .       28.9   .        .      28.9  4.5662
Perch   29.4  4.2042    Perch   30.1  4.6354    Perch  31.6  4.7716
Perch   34.0  6.0180    .       36.5  6.3875    .      37.3  7.7957
.       39.0   .        .       38.3   .        Perch  39.4  6.2646
Perch   39.3  6.3666    Perch   41.4  7.4934    Perch  41.4  6.0030
Perch   41.3  7.3514    .       42.3   .        Perch  42.5  7.2250
Perch   42.4  7.4624    Perch   42.5  6.6300    Perch  44.6  6.8684
Perch   45.2  7.2772    Perch   45.5  7.4165    Perch  46.0  8.1420
Perch   46.6  7.5958
;

proc mi data=Fish2 seed=7545417 out=outex5;
   class Species;
   monotone discrim( Species= Length Width/ details);
   var Length Width Species;
run;

proc print data=outex5(obs=10);
   title 'First 10 Observations of the Imputed Data Set';
run;
