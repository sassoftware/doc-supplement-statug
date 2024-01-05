/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: HPMEX5                                              */
/*   TITLE: Documentation Example 5 for PROC HPMIXED            */
/*          Repeated Measures                                   */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mixed Linear Models                                 */
/*   PROCS: HPMIXED                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC HPMIXED, EXAMPLE 5                             */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

*---------------Repeated Measures Example-----------*
| Data represent a repeated measures example where  |
| an unstructured variance matrix is fit.  Data are |
| from Pothoff and Roy (1964) and are analyzed by   |
| Jennrich and Schluchter (1986).                   |
*---------------------------------------------------*;

data pr;
   input Person Gender $ y1 y2 y3 y4;
   y=y1; Time=1; Age=8;  output;
   y=y2; Time=2; Age=10; output;
   y=y3; Time=3; Age=12; output;
   y=y4; Time=4; Age=14; output;
   drop y1-y4;
   datalines;
 1   F   21.0    20.0    21.5    23.0
 2   F   21.0    21.5    24.0    25.5
 3   F   20.5    24.0    24.5    26.0
 4   F   23.5    24.5    25.0    26.5
 5   F   21.5    23.0    22.5    23.5
 6   F   20.0    21.0    21.0    22.5
 7   F   21.5    22.5    23.0    25.0
 8   F   23.0    23.0    23.5    24.0
 9   F   20.0    21.0    22.0    21.5
10   F   16.5    19.0    19.0    19.5
11   F   24.5    25.0    28.0    28.0
12   M   26.0    25.0    29.0    31.0
13   M   21.5    22.5    23.0    26.5
14   M   23.0    22.5    24.0    27.5
15   M   25.5    27.5    26.5    27.0
16   M   20.0    23.5    22.5    26.0
17   M   24.5    25.5    27.0    28.5
18   M   22.0    22.0    24.5    26.5
19   M   24.0    21.5    24.5    25.5
20   M   23.0    20.5    31.0    26.0
21   M   27.5    28.0    31.0    31.5
22   M   23.0    23.0    23.5    25.0
23   M   21.5    23.5    24.0    28.0
24   M   17.0    24.5    26.0    29.5
25   M   22.5    25.5    25.5    26.0
26   M   23.0    24.5    26.0    30.0
27   M   22.0    21.5    23.5    25.0
;

proc hpmixed data=pr;
   class Person Gender Time;
   model y = Gender Age Gender*Age;
   test Gender Age Gender*Age;
   repeated Time / type=un subject=Person r;
run;

proc hpmixed data=pr;
   class Person Gender Time;
   model y = Gender Age Gender*Age;
   repeated Time / type=ar(1) sub=Person r;
run;

