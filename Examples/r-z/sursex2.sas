/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SURSEX2                                             */
/*   TITLE: Documentation Example 2 for PROC SURVEYSELECT       */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: survey sampling, probability sampling,              */
/*    KEYS: probability proportional to size (PPS) sampling,    */
/*    KEYS: stratified sampling, Brewer's method                */
/*   PROCS: SURVEYSELECT, PRINT                                 */
/*     REF: PROC SURVEYSELECT, Example 2                        */
/****************************************************************/

/* Sampling Frame ----------------------------------------------*/

data HospitalFrame;
   input Hospital$ Type$ SizeMeasure @@;
   if (SizeMeasure < 20) then Size='Small ';
      else if (SizeMeasure < 50) then Size='Medium';
      else Size='Large ';
   datalines;
034 Rural  0.870   107 Rural  1.316
079 Rural  2.127   223 Rural  3.960
236 Rural  5.279   165 Rural  5.893
086 Rural  0.501   141 Rural 11.528
042 Urban  3.104   124 Urban  4.033
006 Urban  4.249   261 Urban  4.376
195 Urban  5.024   190 Urban 10.373
038 Urban 17.125   083 Urban 40.382
259 Urban 44.942   129 Urban 46.702
133 Urban 46.992   218 Urban 48.231
026 Urban 61.460   058 Urban 65.931
119 Urban 66.352
;

title1 'Hospital Utilization Survey';
title2 'Sampling Frame, Region 1';
proc print data=HospitalFrame;
run;

/* PPS Selection of Two Units Per Stratum ----------------------*/

title2 'Stratified PPS Sampling';
proc surveyselect data=HospitalFrame method=pps_brewer
                  seed=48702 out=SampleHospitals;
   size SizeMeasure;
   strata Type Size notsorted;
run;

title2 'Sample Selected by Stratified PPS Design';
proc print data=SampleHospitals;
run;

