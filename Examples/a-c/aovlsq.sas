 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: AOVLSQ                                              */
 /*   TITLE: ANOVA for Latin Square Treatment Design             */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: analysis of variance,                               */
 /*   PROCS: ANOVA GLM MEANS                                     */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

*------Change in Blood Sugar Levels in Mice: Latin Square-------*
|     Four groups of mice, four days, and four treatments are   |
| arranged in a latin square design. The response is the mean   |
| change in blood sugar for 6 animals. The treatments are levels|
| of insulin coded as follows:                                  |
|            Level  A for 150 micro units                       |
|                   B     300                                   |
|                   C     600                                   |
|                   D    1200                                   |
*---------------------------------------------------------------*;

data sugar;
   input dAy Group $ Insulin $ Response;
   datalines;
 1 I   B -4.5
 1 II  D 92.33
 1 III C 59.83
 1 IV  A -45.
 2 I   C 91.83
 2 II  A -48.33
 2 III D 168.99
 2 IV  B 89.
 3 I   D 86.16
 3 II  B -78.16
 3 III A -24.17
 3 IV  C 101.0
 4 I   A -.17
 4 II  C 68.83
 4 III B 25.17
 4 IV  D 177.17
;

proc print;
run;

proc anova;
   classes day group insulin;
   model response= day group insulin;
   means day group insulin;
run; quit;

data sugar2;
   set sugar;
   if insulin='A' then ins=150;
   else if insulin='B' then ins=300;
   else if insulin='C' then ins=600;
   else if insulin='D' then ins=1200;
run;

proc glm;
   classes day group;
   model response= day group ins ins*ins ins*ins*ins;
run; quit;

proc sort out=c;
   by ins;
run;

proc means;
   by ins;
   var response;
run;
