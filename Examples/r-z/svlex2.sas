/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SVLEX2                                              */
/*   TITLE: Documentation Example 2 for PROC SURVEYLOGISTIC     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression, survey sampling                */
/*    KEYS: link functions, stratification, clustering          */
/*    KEYS: unequal weighting, categorical data analysis        */
/*    KEYS: MEPS                                                */
/*   PROCS: SURVEYLOGISTIC                                      */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SURVEYLOGISTIC, Example 2                      */
/*                                                              */
/*    MISC: The Household Component of the Medical              */
/*          Expenditure Panel Survey (MEPS)                     */
/*                                                              */
/*          The data for this example can be downloaded as a    */
/*          SAS transport data set from                         */
/*                                                              */
/*          https://meps.ahrq.gov/mepsweb/data_stats            */
/*                /download_data_files.jsp                      */
/*                                                              */
/*          After downloading, run the following SAS commands,  */
/*          inserting your site-specific information, to create */
/*          the imported data set and to run the analysis:      */
/*                                                              */
/*          filename in1 "<<Where you stored the                */
/*                        unzipped transport-format file>>";    */
/*          libname  puflib "<<Where you want to store          */
/*                           the data set>>";                   */
/*          proc xcopy in=in1 out=puflib import;                */
/*          run;                                                */
/*                                                              */
/****************************************************************/

proc format;
   value racex
      -9 = 'NOT ASCERTAINED'
      -8 = 'DK'
      -7 = 'REFUSED'
      -1 = 'INAPPLICABLE'
      1 = 'AMERICAN INDIAN'
      2 = 'ALEUT, ESKIMO'
      3 = 'ASIAN OR PACIFIC ISLANDER'
      4 = 'BLACK'
      5 = 'WHITE'
      91 = 'OTHER'
      ;
   value sex
      -9 = 'NOT ASCERTAINED'
      -8 = 'DK'
      -7 = 'REFUSED'
      -1 = 'INAPPLICABLE'
      1 = 'MALE'
      2 = 'FEMALE'
      ;
   value povcat9h
      1 = 'NEGATIVE OR POOR'
      2 = 'NEAR POOR'
      3 = 'LOW INCOME'
      4 = 'MIDDLE INCOME'
      5 = 'HIGH INCOME'
      ;
   value inscov9f
      1 = 'ANY PRIVATE'
      2 = 'PUBLIC ONLY'
      3 = 'UNINSURED'
      ;
run;

libname mylib '';

data meps;
   set mylib.H38;
   label racex= sex= inscov99= povcat99=
      varstr99= varpsu99= perwt99f= totexp99=;
   format racex racex. sex sex.
      povcat99 povcat9h. inscov99 inscov9f.;
   keep inscov99 sex racex povcat99 varstr99
      varpsu99 perwt99f totexp99;
run;

proc print data=meps (obs=30);
run;

proc surveylogistic data=meps;
   stratum VARSTR99;
   cluster VARPSU99;
   weight PERWT99F;
   class SEX RACEX POVCAT99;
   model INSCOV99 = TOTEXP99 SEX RACEX POVCAT99 / link=glogit;
run;
