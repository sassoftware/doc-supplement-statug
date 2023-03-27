/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: svlgs                                               */
/*   TITLE: Getting Started Examples for PROC SURVEYLOGISTIC    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression, survey sampling,               */
/*          link functions, stratification, clustering,         */
/*          unequal weighting, categorical data analysis        */
/*   PROCS: SURVEYLOGISTIC                                      */
/*     REF: PROC SURVEYLOGISTIC, Getting Started                */
/*                                                              */
/****************************************************************/

/* Example in the Getting Started section */

proc format;
   value Coding
      1='Extremely Unsatisfied'
      2='Unsatisfied'
      3='Neutral'
      4='Satisfied'
      5='Extremely Satisfied';
run;

data Customer1;
   input CustomerID State$ Type$ Usage Rating;
   format Rating coding.;
   datalines;
416874322 AL New 839   1
288139763 GA Old 224   2
339008654 GA Old 2451  3
118980542 GA New 349   4
421670342 FL New 562   5
623189201 SC New 68    2
324550324 FL Old 137   3
832902397 AL Old 1563  4
586450178 GA New 615   1
801245317 SC New 728   5
;

data Customer2;
   drop n; retain seed 321;
   format Rating coding.;
   state = 'GA';
   Type = 'New';
   do n=1 to 3486;
      CustomerID = floor(1e9 * ranuni(123));
      Usage = exp(5+1.35*rannor(456));
      call rantbl(seed, .11 ,.16 ,.31 ,.30, Rating);
      output;
   end;
   Type = 'Old';
   do n= 1 to 1938;
      CustomerID = floor(1e9 * ranuni(123));
      Usage = exp(5.2+1.4*rannor(456));
      call rantbl(seed, .15 ,.20 ,.25 ,.18, Rating);
      output;
   end;
   state = 'AL';
   Type = 'New';
   do n=1 to 1237;
      CustomerID = floor(1e9 * ranuni(123));
      Usage = exp(5+1.35*rannor(456));
      call rantbl(seed, .09 ,.16 ,.25 ,.3, Rating);
      output;
   end;
   Type = 'Old';
   do n=1 to 705;
      CustomerID = floor(1e9 * ranuni(123));
      Usage = exp(5.2+1.4*rannor(456));
      call rantbl(seed, .11 ,.16 ,.34 ,.37, Rating);
      output;
   end;
   state = 'FL';
   Type = 'New';
   do n=1 to 2169;
      CustomerID = floor(1e9 * ranuni(123));
      Usage = exp(5+1.35*rannor(456));
      call rantbl(seed, .17 ,.23 ,.25 ,.2, Rating);
      output;
   end;
   Type = 'Old';
   do n=1 to 1369;
      CustomerID = floor( 1e9 * ranuni(6) );
      Usage = exp(5.2+1.4*rannor(1));
      call rantbl(seed, .1 ,.2 ,.3 ,.3, Rating);
      output;
   end;
   state = 'SC';
   Type = 'New';
   do n=1 to 1682;
      CustomerID = floor( 1e9 * ranuni(7) );
      Usage = exp(5+1.35*rannor(1));
      call rantbl(seed, .2 ,.25 ,.1 ,.2, Rating);
      output;
   end;
   Type = 'Old';
   do n=1 to 875;
      CustomerID = floor( 1e9 * ranuni(8) );
      Usage = exp(5.2+1.4*rannor(1));
      call rantbl(seed, .08 ,.12 ,.34 ,.24, Rating);
      output;
   end;
run;

proc sort data=Customer2;
   by CustomerID;
run;

data Customers;
   set Customer1 Customer2;
   format Usage 6.2;
   drop seed;
   if Usage < 0 then Usage = 0;
   if Usage < 50 and Rating <4
      then Rating = Rating +2;
   if Usage > 400 and Rating > 1
      then Rating = Rating -1;
   Usage=Usage/60;
run;

proc sort data=Customers;
   by State Type;
run;

proc surveyselect data=Customers
      method=pps_wr n=25
      seed=1953 out=SampleStrata;
   strata State Type;
   size Usage;
run;

data SampleStrata;
   set SampleStrata;
   SamplingWeight=SamplingWeight*Numberhits;
   keep State Type CustomerID Rating
        Usage SamplingWeight;
run;

title1 'Customer Satisfaction Survey';
title2 'Stratified PPS Sampling';
title3 '(First 10 Observations)';
proc print data=SampleStrata(obs=10);
run;

title 'Customer Satisfaction Survey';
proc surveylogistic data=SampleStrata;
   strata state type/list;
   model Rating (order=internal) = Usage;
   weight SamplingWeight;
run;

