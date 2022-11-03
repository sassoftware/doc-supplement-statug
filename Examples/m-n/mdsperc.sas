 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: mdsperc                                             */
 /*   TITLE: Intercity Distance Perception                       */
 /* PRODUCT: stat                                                */
 /*  SYSTEM: all                                                 */
 /*    KEYS: multidimensional scaling,                           */
 /*   PROCS: mds                                                 */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: young, psy 362, 1980                                */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Intercity Distance Perception';

data cityperc;
   input (City1-City10) (3. +1) City $ 44-58 Subject $ 60-66;
   datalines;
  0   3   6   4   7   2   5   8   9   1    Atlanta         Young
  3   0   6   4   8   5   1   9   7   2    Chicago         Young
  6   5   0   4   3   9   8   1   2   7    Denver          Young
  1   4   2   0   7   3   6   8   9   5    Houston         Young
  6   5   3   4   0   8   9   1   2   7    Los Angeles     Young
  1   5   6   2   7   0   4   8   9   3    Miami           Young
  3   2   6   5   9   4   0   8   7   1    New York        Young
  6   5   3   4   1   7   9   0   2   8    San Francisco   Young
  8   4   3   5   2   9   6       0   7    Seattle         Young
  2   3   6   4   8   5   1   7   9   0    Washington DC   Young
  0   5   6   4   7   1   3   8   9   2    Atlanta         Solomon
  5   0   1   2   9   6   3   7   8   4    Chicago         Solomon
  8   1   0   4   5   9   6   3   2   7    Denver          Solomon
  2   4   1   0   5   3   8   7   9   6    Houston         Solomon
  6   5   3   4   0   7   9   1   2   8    Los Angeles     Solomon
  1   5   6   2   7   0   4   8   9   3    Miami           Solomon
  2   4   5   6   9   3   0   7   8   1    New York        Solomon
  8   5   3   4   2   9   6   0   1   7    San Francisco   Solomon
  8   4   3   5   2   9   6   1   0   7    Seattle         Solomon
  2   4   6   5   8   3   1   7   9   0    Washington DC   Solomon
  0   6   5   1   7   2   4   8   9   3    Atlanta         Musante
  7   0   4   8   5   9   1   6   3   2    Chicago         Musante
  8   3   0   5   1   9   7   2   4   6    Denver          Musante
  3   2   1   0   4   8   6   7   9   5    Houston         Musante
  6   4   3   5   0   9   8   1   2   7    Los Angeles     Musante
  1   5   6   2   7   0   4   8   9   3    Miami           Musante
  3   2   6   4   9   5   0   7   8   1    New York        Musante
  8   3   4   6   1   9   5   0   2   7    San Francisco   Musante
  8   3   4   7   2   9   5   1   0   6    Seattle         Musante
  2   3   7   5   8   4   1   6   9   0    Washington DC   Musante
  0   4   6   5   7   1   3   8   9   2    Atlanta         Gilbert
  3   0   5   4   9   6   2   8   7   1    Chicago         Gilbert
  6   4   0   3   2   9   8   1   5   7    Denver          Gilbert
  3   2   1   0   7   4   6   8   9   5    Houston         Gilbert
  6   5   2   4   0   8   9   1   3   7    Los Angeles     Gilbert
  1   5   6   2   7   0   4   8   9   3    Miami           Gilbert
  2   3   6   5   9   4   0   8   7   1    New York        Gilbert
  6   5   3   4   1   9   8   0   2   7    San Francisco   Gilbert
  6   4   3   5   2   9   7   1   0   8    Seattle         Gilbert
  2   4   6   5   8   3   1   7   9   0    Washington DC   Gilbert
  0   5   6   3   7   1   4   8   9   2    Atlanta         Carolyn
  4   0   5   3   9   7   1   8   6   2    Chicago         Carolyn
  6   5   0   2   3   9   8   1   4   7    Denver          Carolyn
  2   3   1   0   6   9   5   7   8   4    Houston         Carolyn
  6   5   3   4   0   7   9   1   2   8    Los Angeles     Carolyn
  1   5   6   2   7   0   4   8   9   3    Miami           Carolyn
  3   2   6   4   9   5   0   8   7   1    New York        Carolyn
  6   5   2   4   1   8   9   0   3   7    San Francisco   Carolyn
  7   4   2   5   3   9   8   1   0   6    Seattle         Carolyn
  3   2   6   4   8   5   1   7   9   0    Washington DC   Carolyn
  0   5   6   2   7   3   4   8   9   1    Atlanta         Roger
  3   0   6   5   9   4   1   8   7   2    Chicago         Roger
  5   6   0   4   2   9   8   1   3   7    Denver          Roger
  2   7   1   0   3   6   8   4   9   5    Houston         Roger
  5   8   2   4   0   6   9   1   3   7    Los Angeles     Roger
  1   4   6   3   7   0   5   8   9   2    Miami           Roger
  3   1   4   5   9   6   0   8   7   2    New York        Roger
  5   6   2   4   1   9   8   0   3   7    San Francisco   Roger
  5   6   2   4   3   9   7   1   0   8    Seattle         Roger
  1   4   6   5   9   3   2   7   8   0    Washington DC   Roger
;

ods graphics on;

title2 'Individual Differences Analysis';
title3 'Ordinal Data';
title4 'ALSCAL S-Stress=.08279';
proc mds fit=2 data=cityperc condition=row level=ordinal model=indscal;
   id city;
   subject subject;
run;

title3 'Interval Data';
title4 'ALSCAL S-Stress=.19208';
proc mds fit=2 data=cityperc condition=row level=interval model=indscal;
   id city;
   subject subject;
run;

ods graphics off;
