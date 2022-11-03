/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GLMEX1                                              */
/*   TITLE: Example 1 for PROC GLM                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Randomized complete block design, contrasts         */
/*   PROCS: GLM                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GLM, EXAMPLE 1.                                */
/*    MISC:                                                     */
/****************************************************************/

/* Balanced Data from Randomized Complete Block ----------------*/

/* Snapdragon Experiment ---------------------------------------*/
/* As reported by Stenstrom, 1940, an experiment was undertaken */
/* to investigate how snapdragons grew in various soils. Each   */
/* soil type was used in three blocks. -------------------------*/
title 'Balanced Data from Randomized Complete Block';
data plants;
   input Type $ @;
   do Block = 1 to 3;
      input StemLength @;
      output;
   end;
   datalines;
Clarion  32.7 32.3 31.5
Clinton  32.1 29.7 29.1
Knox     35.7 35.9 33.1
O'Neill  36.0 34.2 31.2
Compost  31.8 28.0 29.2
Wabash   38.2 37.8 31.9
Webster  32.5 31.1 29.7
;
proc glm;
   class Block Type;
   model StemLength = Block Type;
run;
proc glm order=data;
   class Block Type;
   model StemLength = Block Type / solution;

   /*----------------------------------clrn-cltn-knox-onel-cpst-wbsh-wstr */
   contrast 'Compost vs. others'  Type   -1   -1   -1   -1    6   -1   -1;
   contrast 'River soils vs. non' Type   -1   -1   -1   -1    0    5   -1,
                                  Type   -1    4   -1   -1    0    0   -1;
   contrast 'Glacial vs. drift'   Type   -1    0    1    1    0    0   -1;
   contrast 'Clarion vs. Webster' Type   -1    0    0    0    0    0    1;
   contrast "Knox vs. O'Neill"    Type    0    0    1   -1    0    0    0;
run;

   means Type / waller regwq;
run;
