 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: mdsrank                                             */
 /*   TITLE: Ranked Flying Mileages                              */
 /* PRODUCT: stat                                                */
 /*  SYSTEM: all                                                 */
 /*    KEYS: multidimensional scaling,                           */
 /*   PROCS: mds                                                 */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: alscal2                                             */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Ranked Flying Mileages';

data rank;
   input (Atlanta Chicago Denver Houston LosAngeles
          Miami NewYork SanFrancisco Seattle WashingtonDC) (3.)
      @56 City $15.;
   datalines;
                                                       Atlanta
  4                                                    Chicago
 22 13                                                 Denver
  8 15 12                                              Houston
 34 31 11 24                                           Los Angeles
  6 21 29 18 39                                        Miami
 10  9 27 25 42 20                                     New York
 35 32 16 28  2 44 43                                  San Francisco
 36 30 19 33 17 45 40  7                               Seattle
  3  5 26 23 37 14  1 41 38                            Washington DC
;

ods graphics on;

proc mds data=rank fit=2 level=absolute;
   id city;
   title2 'Absolute Level, Good Start';
run;

proc mds data=rank fit=2 level=ratio;
   id city;
   title2 'Ratio Level, Good Start';
   title3 'ALSCAL S-Stress = .05831';
run;

proc mds data=rank fit=2 level=loginterval;
   id city;
   title2 'Log-Interval Level, Good Start';
run;

proc mds data=rank fit=2 level=interval;
   id city;
   title2 'Interval Level, Good Start';
   title3 'ALSCAL S-Stress = .05786';
run;

proc mds data=rank fit=2 level=ordinal;
   id city;
   title2 'Ordinal Level, Good Start';
   title3 'ALSCAL S-Stress = .00585';
run;

data badstart;
   input dim1 dim2;
   datalines;
 1 0
 2 0
 3 0
 4 0
 5 0
 6 0
 7 0
 8 0
 9 0
10 1
;

proc mds data=rank in=badstart fit=2 level=absolute;
   id city;
   title2 'Absolute Level, Bad Start';
run;

proc mds data=rank in=badstart fit=2 level=ratio;
   id city;
   title2 'Ratio Level, Bad Start';
run;

proc mds data=rank in=badstart fit=2 level=loginterval ridge=1e5;
   id city;
   title2 'Log-Interval Level, Bad Start';
run;

proc mds data=rank in=badstart fit=2 level=interval;
   id city;
   title2 'Interval Level, Bad Start';
   title3 'May Find Local Optimum with Negative Slope';
run;

proc mds data=rank in=badstart fit=2 level=ordinal;
   id city;
   title2 'Ordinal Level, Bad Start';
run;

ods graphics off;
