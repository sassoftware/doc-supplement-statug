 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: CHANGEOV                                            */
 /*   TITLE: Grizzle's Two-Period Changeover Design              */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: analysis of variance,                               */
 /*   PROCS: GLM                                                 */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: Grizzle, James E., "The Two-Period Change-over      */
 /*             Design and its use in Clinical Trials",          */
 /*             Biometrics, June 1965, p467.                     */
 /*          Johnson, Dallas E., "Design and Analysis of         */
 /*             Crossover Experiments," notes from course        */
 /*             presented at the Joint Statistical Meetings,     */
 /*             July 2007, Salt Lake City.                       */
 /*                                                              */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/
title1 'Grizzle''s Two-Period Change-over Design';
data Grizzle;
   keep Sequence Subject Period Treatment y;
   do Sequence = "AB","BA";
      do SeqSub = 1 to 8;
         do Period = 1 to 2;
            input y @@;
            Treatment = substr(Sequence,Period,1);
            Subject   = SeqSub + 8*(Sequence = "BA");
            output;
            end;
         end;
      end;
datalines;
 0.2  1.0    0.0 -0.7   -0.8  0.2    0.6  1.1
 0.3  0.4    1.5  1.2     .    .      .    .
 1.3  0.9   -2.3  1.0    0.0  0.6   -0.8 -0.3
-0.4 -1.0   -2.9  1.7   -1.9 -0.3   -2.9  0.9
;

/*
/  GLM can perform an appropriate ANOVA for this data, including
/  estimating and testing differences between treatment and period
/  means.  However, a correct analysis assumes a random subject
/  effect, which GLM cannot model correctly.  This means that the
/  standard errors and t-tests for individual LS-means from GLM are
/  not appropriate.
/---------------------------------------------------------------------*/
title2 "Fixed effect model analysis with GLM";
title3 "Inappropriate LS-Mean Standard Errors";
proc glm data=Grizzle;
   class Subject Treatment Period;
   model y = Subject Treatment Period / ss3;
   lsmeans Treatment Period / Stderr pdiff;
   ods select ModelANOVA LSMeans;
run;

/*
/  MIXED can model the random Subject effect to give correct
/  standard errors and tests for individual LS-means.  Note that the
/  tests for Treatment and Period effects, as well as for the
/  differences between LS-means, are the same as with GLM.
/---------------------------------------------------------------------*/
title2 "Mixed effect model analysis with MIXED";
title3 "Appropriate LS-Mean Standard Errors";
proc mixed data=Grizzle;
   class Subject Treatment Period;
   model y = Treatment Period / ddfm=sat;
   lsmeans Treatment Period / pdiff;
   random Subject;
   ods select Tests3 LSMeans Diffs;
run;

/*
/  TTEST can once again compute the same Treatment and Period tests,
/  and in addition it produces an array of informative graphics to
/  clarify how individual subjects and measurements with subject
/  contribute to this inference.
/---------------------------------------------------------------------*/
title2 "Analysis with TTEST, including graphics";
ods graphics on;
data SideBySide;
   merge Grizzle(where=(Period=1) rename=(y=y1))
         Grizzle(where=(Period=2) rename=(y=y2));
   t1 = substr(Sequence,1,1);
   t2 = substr(Sequence,2,1);
   keep t1 t2 y1 y2;
proc ttest data=SideBySide plots=all;
   var y1 y2 / crossover=(t1 t2);
run;
ods graphics off;
