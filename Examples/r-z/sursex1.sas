/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SURSEX1                                             */
/*   TITLE: Documentation Example 1 for PROC SURVEYSELECT       */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: survey sampling, probability sampling,              */
/*    KEYS: replicated sampling, sequential random sampling,    */
/*    KEYS: control sorting                                     */
/*   PROCS: SURVEYSELECT, SORT, PRINT                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SURVEYSELECT, Example 1                        */
/*    MISC:                                                     */
/****************************************************************/
/* Generate Sampling Frame -------------------------------------*/
data Customer1;
   input CustomerID State$ Type$ Usage;
   format CustomerID SSN11.;
   datalines;
416874322 AL New 839
288139763 GA Old 224
339008654 GA Old 2451
118980542 GA New 349
421670342 FL New 562
623189201 SC New 68
324550324 FL Old 137
832902397 AL Old 1563
586450178 GA New 615
801245317 SC New 728
;

data Customer2;
   drop n;
   format CustomerID SSN11.;
   state = 'GA';
   Type = 'New';
   do n=1 to 3486;
      CustomerID = floor(1e9 * ranuni(123));
      Usage = exp(5+1.35*rannor(456));
      output;
   end;
   Type = 'Old';
   do n= 1 to 1938;
      CustomerID = floor(1e9 * ranuni(123));
      Usage = exp(5.2+1.4*rannor(456));
      output;
   end;
   state = 'AL';
   Type = 'New';
   do n=1 to 1237;
      CustomerID = floor(1e9 * ranuni(123));
      Usage = exp(5+1.35*rannor(456));
      output;
   end;
   Type = 'Old';
   do n=1 to 705;
      CustomerID = floor(1e9 * ranuni(123));
      Usage = exp(5.2+1.4*rannor(456));
      output;
   end;
   state = 'FL';
   Type = 'New';
   do n=1 to 2169;
      CustomerID = floor(1e9 * ranuni(123));
      Usage = exp(5+1.35*rannor(456));
      output;
   end;
   Type = 'Old';
   do n=1 to 1369;
      CustomerID = floor( 1e9 * ranuni(6) );
      Usage = exp(5.2+1.4*rannor(1));
      output;
   end;
   state = 'SC';
   Type = 'New';
   do n=1 to 1682;
      CustomerID = floor( 1e9 * ranuni(7) );
      Usage = exp(5+1.35*rannor(1));
      output;
   end;
   Type = 'Old';
   do n=1 to 875;
      CustomerID = floor( 1e9 * ranuni(8) );
      Usage = exp(5.2+1.4*rannor(1));
      output;
   end;
run;
proc sort data=Customer2;
   by CustomerID;
run;

data Customers; set Customer1 Customer2;
   format Usage 6.0;
   if Usage < 0 then Usage = 0;
run;
/* Replicated Sampling -----------------------------------------*/
title1 'Customer Satisfaction Survey';
title2 'Replicated Sampling';
proc surveyselect data=Customers method=seq n=(8 12 20 10)
                  reps=4 seed=40070 ranuni out=SampleRep;
   strata State;
   control Type Usage;
run;
title2 'Sample Selected by Replicated Design';
title3 '(First Stratum)';
proc print data=SampleRep;
   where State = 'AL';
run;
