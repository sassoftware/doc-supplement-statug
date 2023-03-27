/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: svlex1                                              */
/*   TITLE: Documentation Example 1 for PROC SURVEYLOGISTIC     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression, survey sampling,               */
/*          link functions, stratification, clustering,         */
/*          unequal weighting, categorical data analysis        */
/*   PROCS: SURVEYLOGISTIC                                      */
/*     REF: PROC SURVEYLOGISTIC, Example 1                      */
/*    MISC: Logistic Regression with Different Link             */
/*          Functions for Stratified Cluster Sampling           */
/*                                                              */
/****************************************************************/

proc format;
   value Class
      1='Freshman' 2='Sophomore'
      3='Junior'   4='Senior';
run;

data Enrollment;
   format Class Class.;
   input Class _TOTAL_;
   datalines;
1 3734
2 3565
3 3903
4 4196
;

proc format;
   value Design 1='A' 2='B' 3='C';
   value Rating
      1='dislike very much'
      2='dislike'
      3='neutral'
      4='like'
      5='like very much';
run;

data WebSurvey;
   format Class Class. Design Design. Rating Rating.;
   do Class=1 to 4;
      do Design=1 to 3;
         do Rating=1 to 5;
            input Count @@;
            output;
         end;
      end;
   end;
   datalines;
10 34 35 16 15   8 21 23 26 22   5 10 24 30 21
 1 14 25 23 37  11 14 20 34 21  16 19 30 23 12
19 12 26 18 25  11 14 24 33 18  10 18 32 23 17
 8 15 35 30 12  15 22 34  9 20   2 34 30 18 16
;

data WebSurvey;
   set WebSurvey;
   if Class=1 then Weight=3734/300;
   if Class=2 then Weight=3565/300;
   if Class=3 then Weight=3903/300;
   if Class=4 then Weight=4196/300;
run;

proc print data=WebSurvey(obs=20);
run;

proc surveylogistic data=WebSurvey total=Enrollment;
   stratum Class;
   freq Count;
   class Design;
   model Rating (order=internal) = design;
   weight Weight;
run;

proc surveylogistic data=WebSurvey total=Enrollment;
   stratum Class;
   freq Count;
   class Design;
   model Rating (ref='neutral') = Design /link=glogit;
   weight Weight;
run;

