/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: loessgs                                             */
/*   TITLE: Getting Started Example for PROC LOESS              */
/*          Melanoma Incidences with Trend and Cycle            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Local Regression                                    */
/*   PROCS: LOESS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data Melanoma;
   input  Year Incidences @@;
   format Year d4.0;
   datalines;
1936    0.9   1937   0.8  1938   0.8  1939   1.3
1940    1.4   1941   1.2  1942   1.7  1943   1.8
1944    1.6   1945   1.5  1946   1.5  1947   2.0
1948    2.5   1949   2.7  1950   2.9  1951   2.5
1952    3.1   1953   2.4  1954   2.2  1955   2.9
1956    2.5   1957   2.6  1958   3.2  1959   3.8
1960    4.2   1961   3.9  1962   3.7  1963   3.3
1964    3.7   1965   3.9  1966   4.1  1967   3.8
1968    4.7   1969   4.4  1970   4.8  1971   4.8
1972    4.8
;


proc sgplot data=Melanoma;
   scatter y=Incidences x=Year;
run;

ods graphics on;

proc loess data=Melanoma;
   model Incidences=Year;
run;

proc loess data=Melanoma;
   model Incidences=Year / details(ModelSummary OutputStatistics);
run;

proc loess data=Melanoma;
   model Incidences=Year/smooth=0.1 0.25 0.4 0.6 residual;
   ods output OutputStatistics=Results;
run;



proc print data=Results(obs=5);
   id obs;
run;


proc loess data=Melanoma plots=ResidualsBySmooth(smooth);
   model Incidences=Year/smooth=0.1 0.25 0.4 0.6;
run;

proc loess data=Melanoma;
   model Incidences=Year/clm alpha=0.1;
run;

ods graphics off;

