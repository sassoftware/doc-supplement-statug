 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: PHRCPA1                                             */
 /*   TITLE: Cox's Regression with Delayed Entry                 */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: survival analysis, regression analysis              */
 /*   PROCS: PHREG                                               */
 /*    DATA:                                                     */
  /*    MISC: Also known as left truncation of data               */
 /*                                                              */
 /****************************************************************/

 /*
    In studying the mortality of workers exposed to a carcinogen,
    the survival time was chosen to be the worker's age at death
    by malignant neoplasm. Any worker joining the workplace at
    a later age than a given event failure time was not included
    in the corresponding risk set.  The variables of a worker
    consists of AGE_STRT (age at which the worker started at the
    workplace), AGE_DIED (age at death or censored), STATUS (an
    indicator of whether the observation time is censored, with
    the value 0 identifying a censored time) and EXPOS (amount
    of exposure to the carcinogen).
 */


title 'Delayed Entry into the Risk Set';
data delay;
   input age_died age_strt status expos @@;
datalines;
44 33 0 12.5   51 39 1 11.6   37 30 0  7.2
53 38 0 16.8   55 38 0 16.9   54 38 0 16.7
53 40 0 13.1   53 29 0 25.5   34 30 0  4.3
39 29 0  8.6   25 21 0  2.7   59 41 1 18.6
32 27 1  4.7   48 34 0 13.1   27 21 0  6.0
65 51 0 13.2   38 28 0 11.0   60 47 0 14.2
42 37 1  5.6   35 29 0  7.1   37 29 1  6.9
46 35 1 11.6   56 41 0 15.4   34 31 0  3.1
25 23 0  0.6   46 34 0 11.9   36 27 1  8.0
35 25 0  8.8   36 27 0  9.9   32 29 0  3.0
30 27 0  3.2   65 43 0 22.5   29 24 1  5.1
39 29 1  8.5   28 25 0  2.5   28 23 0  2.8
30 25 0  6.0   43 34 1  8.6   51 34 0 18.2
58 44 0 14.0   31 28 0  0.5   45 32 0 11.5
33 23 1 10.4   37 30 1  7.8   32 27 0  5.5
27 24 0  1.8   33 22 0 10.9   28 26 0  3.2
44 33 1  9.6   56 42 0 13.9   43 31 1 10.0
49 37 0 11.4   33 27 0  5.9   26 20 0  6.6
31 28 0  4.5   47 36 0 10.9   26 22 0  2.4
45 29 0 15.8   36 28 0  6.8   30 25 0  4.4
;



 /*
     Left truncation can be accomodated in PROC PHREG through
     the counting process style of input. However, such a
     specification does not allow survival estimates to be
     computed.
 */

proc phreg data=delay;
   model (age_strt,age_died)*status(0)=expos;
   title2 'Counting Process Style of Input';
run;


 /*
     Alternatively, you can use the ENTRY= option to specify
     the left truncation time. This specification allows
     survival estimates to be output.
 */

proc phreg data=delay;
   model age_died*status(0)=expos/entry=age_strt;
   baseline out=base1 survival=s;
   title2 'Using the ENTRY= Option';
run;

proc print data=base1;
   title 'Survival Estimates for Left Truncated Data';
run;
