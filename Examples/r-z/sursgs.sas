/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SURSGS                                              */
/*   TITLE: Getting Started Examples for PROC SURVEYSELECT      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: survey sampling, probability sampling,              */
/*    KEYS: simple random sampling, stratified sampling,        */
/*    KEYS: systematic sampling, control sorting                */
/*   PROCS: SURVEYSELECT, SORT, PRINT, FREQ                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SURVEYSELECT, Getting Started                  */
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
title1 'Customer Satisfaction Survey';
title2 'First 10 Observations';
proc print data=Customers(obs=10);
run;
/* Simple Random Sampling --------------------------------------*/

title2 'Simple Random Sampling';
proc surveyselect data=Customers method=srs n=100
                  seed=39647 out=SampleSRS;
run;
title2 'Sample of 100 Customers, Selected by SRS';
title3 '(First 20 Observations)';
proc print data=SampleSRS(obs=20);
run;
/* Stratified Sampling -----------------------------------------*/
proc sort data=Customers;
   by State Type;
run;
title2 'Strata of Customers';
proc freq data=Customers;
   tables State*Type;
run;
title2 'Stratified Sampling';
proc surveyselect data=Customers method=srs n=15
                  seed=1953 out=SampleStrata;
   strata State Type;
run;
title2 'Sample Selected by Stratified Design';
title3 '(First 30 Observations)';
proc print data=SampleStrata(obs=30);
run;
/* Stratified Sampling with Control Sorting --------------------*/
title2 'Stratified Sampling with Control Sorting';
proc surveyselect data=Customers method=sys rate=.02
                  seed=1234 out=SampleControl;
   strata State;
   control Type Usage;
run;
