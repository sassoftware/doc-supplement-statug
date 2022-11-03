 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: mdsuni                                              */
 /*   TITLE: Perfect Unidimensional Row Conditional Data         */
 /* PRODUCT: stat                                                */
 /*  SYSTEM: all                                                 */
 /*    KEYS: multidimensional scaling,                           */
 /*   PROCS: mds                                                 */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: alscal9                                             */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Perfect Unidimensional Row Conditional Data with Missing Rows';

data testasym;
   input (Stim1-Stim8) (8*2.);
   datalines;
 0 1 2 3 4 5 6 7
-9 0-9-9-9-9-9-9
 2 1 0 1 2 3 4 5
 3 2 1 0 1 2 3 4
 4 3 2 1 0 1 2 3
 5 4 3 2 1 0 1 2
 6 5 4 3 2 1 0 1
 7 6 5 4 3 2 1 0
 0 1 2 3 4 5 6 7
 1 0 1 2 3 4 5 6
 2 1 0 1 2 3 4 5
 3 2 1 0 1 2 3 4
-9-9-9-9 0-9-9-9
 5 4 3 2 1 0 1 2
 6 5 4 3 2 1 0 1
 7 6 5 4 3 2 1 0
;

ods graphics on;

proc mds fit=2 data=testasym level=ratio condition=row dimens=1 pconfig;
   title2 'Ratio Measurement Level';
run;

proc mds fit=2 data=testasym level=interval condition=row dimens=1 pconfig;
   title2 'Interval Measurement Level';
run;

ods graphics off;
