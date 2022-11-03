 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: mdscity                                             */
 /*   TITLE: Intercity Flying Mileages Example for PROC MDS      */
 /* PRODUCT: stat                                                */
 /*  SYSTEM: all                                                 */
 /*    KEYS: multidimensional scaling, distance and similarity   */
 /*   PROCS: mds                                                 */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: alscal1                                             */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Intercity Flying Mileages';

data city;
   input (Atlanta Chicago Denver Houston LosAngeles
          Miami NewYork SanFrancisco Seattle WashingtonDC) (5.)
          @56 City $15.;
   datalines;
    0                                                  Atlanta
  587    0                                             Chicago
 1212  920    0                                        Denver
  701  940  879    0                                   Houston
 1936 1745  831 1374    0                              Los Angeles
  604 1188 1726  968 2339    0                         Miami
  748  713 1631 1420 2451 1092    0                    New York
 2139 1858  949 1645  347 2594 2571    0               San Francisco
 2182 1737 1021 1891  959 2734 2408  678    0          Seattle
  543  597 1494 1220 2300  923  205 2442 2329    0     Washington DC
;

ods graphics on;

proc mds data=city fit=2 level=absolute;
   id city;
   title2 'Absolute Level, Good Start';
run;

proc mds data=city fit=2 level=ratio;
   id city;
   title2 'Ratio Level, Good Start';
   title3 'ALSCAL S-Stress = .00308';
run;

proc mds data=city fit=2 level=loginterval;
   id city;
   title2 'Log-Interval Level, Good Start';
run;

proc mds data=city fit=2 level=interval out=out outres=res;
   id city;
   title2 'Interval Level, Good Start';
   title3 'ALSCAL S-Stress = .00291';
run;

proc mds data=city fit=2 level=ordinal;
   id city;
   title2 'Ordinal Level, Good Start';
   title3 'ALSCAL S-Stress = .00047';
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

proc mds data=city in=badstart fit=2 level=absolute;
   id city;
   title2 'Absolute Level, Bad Start';
run;

proc mds data=city in=badstart fit=2 level=ratio;
   id city;
   title2 'Ratio Level, Bad Start';
run;

proc mds data=city in=badstart fit=2 level=loginterval ridge=1e5;
   id city;
   title2 'Log-Interval Level, Bad Start';
run;

proc mds data=city in=badstart fit=2 level=interval;
   id city;
   title2 'Interval Level, Bad Start';
run;

proc mds data=city in=badstart fit=2 level=ordinal;
   id city;
   title2 'Ordinal Level, Bad Start';
run;

ods graphics off;
