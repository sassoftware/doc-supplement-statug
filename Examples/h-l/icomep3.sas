/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICOMEP3                                             */
/*   TITLE: Example 3 for EFFECTPLOT Statement                  */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics, Logistic Regression                   */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, Shared Concepts Chapter      */
/*    MISC:                                                     */
/****************************************************************/

/* In a study of the analgesic effects of treatments on elderly
patients with neuralgia, two test treatments and a placebo are
compared. The response variable, Pain, is whether the patient
reported pain or not. Researchers record Age and Sex of the
patients and the Duration of complaint before the treatment
began.*/

title 'Example 3: Logistic Regression';

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

ods graphics on;
proc logistic data=Neuralgia;
   class Treatment Sex / param=ref;
   model Pain= Treatment|Sex Age Duration;
   effectplot slicefit;
run;

proc logistic data=Neuralgia;
   class Treatment Sex / param=ref;
   model Pain= Treatment|Sex Age Duration;
   effectplot interaction(x=Treatment sliceby=Sex) / noobs link;
run;

proc logistic data=Neuralgia;
   class Treatment Sex / param=ref;
   model Pain= Treatment Sex Age Duration;
   effectplot slicefit(sliceby=Treatment plotby(rows)=Sex)
      / at(Duration=min midrange max) obs(fringe jitter(seed=39393));
   store logimodel;
run;

proc plm restore=logimodel;
   effectplot contour(plotby=Treatment) / at(Sex=all);
run;
ods graphics off;
