/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX2                                             */
/*   TITLE: Example 2 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 2. Logistic Modeling With Categorical Predictors
*****************************************************************/

/*
In a study of the analgesic effects of treatments on elderly
patients with neuralgia, two test treatments and a placebo are
compared. The response variable, Pain, is whether the patient
reported pain or not. Researchers record Age and Sex of the
patients and the Duration of complaint before the treatment began.

The first call to the LOGISTIC procedure fits the logit model with
Treatment, Sex, Treatment by Sex interaction, Age, and Duration as
effects.  The categorical variables Treatment and Sex are declared
in the CLASS statement.

The next PROC LOGISTIC call illustrates the use of forward
selection on the data set Neuralgia to identify the effects that
differentiate the two Pain responses.  The option SELECTION=FORWARD
is specified to carry out the forward selection. The term
Treatment|Sex@2 illustrates another way to specify main effects and
two-way interaction.

The final PROC LOGISTIC call refits the previously selected model
using the REFERENCE-coding for the CLASS variables.  ODDSRATIO
statements are specified to compute odds ratios of the main
effects, graphical displays are produced when ODS Graphics is
enabled. Four CONTRAST statements are specified.  The ones labeled
'Pairwise' test the pairwise comparisons between the three levels
of Treatment. The one labeled 'Female vs Male' compares female to
male patients. The option ESTIMATE=EXP is specified in the CONTRAST
statements to exponentiate the estimates of the contrast.  With the
given specification of contrast coefficients, the first of the
'Pairwise' CONTRAST statements corresponds to the odds ratio of A
versus P, the second corresponds to B versus P, and the third
corresponds to A versus B.  The 'Female vs Male' CONTRAST statement
corresponds to the odds ratio that compares female to male
patients.  The EFFECTPLOT statement displays a plot of the
model-predicted probabilities classified by Treatment and Age.
*/

title 'Example 2. Modeling with Categorical Predictors';

data Neuralgia;
   input Treatment $ Sex $ Age Duration Pain $ @@;
   datalines;
P  F  68   1  No   B  M  74  16  No  P  F  67  30  No
P  M  66  26  Yes  B  F  67  28  No  B  F  77  16  No
A  F  71  12  No   B  F  72  50  No  B  F  76   9  Yes
A  M  71  17  Yes  A  F  63  27  No  A  F  69  18  Yes
B  F  66  12  No   A  M  62  42  No  P  F  64   1  Yes
A  F  64  17  No   P  M  74   4  No  A  F  72  25  No
P  M  70   1  Yes  B  M  66  19  No  B  M  59  29  No
A  F  64  30  No   A  M  70  28  No  A  M  69   1  No
B  F  78   1  No   P  M  83   1  Yes B  F  69  42  No
B  M  75  30  Yes  P  M  77  29  Yes P  F  79  20  Yes
A  M  70  12  No   A  F  69  12  No  B  F  65  14  No
B  M  70   1  No   B  M  67  23  No  A  M  76  25  Yes
P  M  78  12  Yes  B  M  77   1  Yes B  F  69  24  No
P  M  66   4  Yes  P  F  65  29  No  P  M  60  26  Yes
A  M  78  15  Yes  B  M  75  21  Yes A  F  67  11  No
P  F  72  27  No   P  F  70  13  Yes A  M  75   6  Yes
B  F  65   7  No   P  F  68  27  Yes P  M  68  11  Yes
P  M  67  17  Yes  B  M  70  22  No  A  M  65  15  No
P  F  67   1  Yes  A  M  67  10  No  P  F  72  11  Yes
A  F  74   1  No   B  M  80  21  Yes A  F  69   3  No
;

proc logistic data=Neuralgia;
   class Treatment Sex;
   model Pain= Treatment Sex Treatment*Sex Age Duration / expb;
run;

proc logistic data=Neuralgia;
   class Treatment Sex;
   model Pain=Treatment|Sex@2 Age Duration
         /selection=forward expb;
run;

ods graphics on;
proc logistic data=Neuralgia plots(only)=(oddsratio(range=clip));
   class Treatment Sex /param=ref;
   model Pain= Treatment Sex Age / noor;
   oddsratio Treatment;
   oddsratio Sex;
   oddsratio Age;
   contrast 'Pairwise A vs P' Treatment 1  0 / estimate=exp;
   contrast 'Pairwise B vs P' Treatment 0  1 / estimate=exp;
   contrast 'Pairwise A vs B' Treatment 1 -1 / estimate=exp;
   contrast 'Female vs Male' Sex 1 / estimate=exp;
   effectplot / at(Sex=all) noobs;
   effectplot slicefit(sliceby=Sex plotby=Treatment) / noobs;
run;

