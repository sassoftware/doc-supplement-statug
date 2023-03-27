/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CANCOGS                                             */
/*   TITLE: Getting Started Example for PROC CANCORR            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multivariate analysis                               */
/*   PROCS: CANCORR                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CANCORR, Getting Started Example               */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data Jobs;
   input Career Supervisor Finance Variety Feedback Autonomy;
   label Career    ='Career Satisfaction' Variety ='Task Variety'
         Supervisor='Supervisor Satisfaction' Feedback='Amount of Feedback'
         Finance   ='Financial Satisfaction' Autonomy='Degree of Autonomy';
   datalines;
72  26  9          10  11  70
63  76  7          85  22  93
96  31  7          83  63  73
96  98  6          82  75  97
84  94  6          36  77  97
66  10  5          28  24  75
31  40  9          64  23  75
45  14  2          19  15  50
42  18  6          33  13  70
79  74  4          23  14  90
39  12  2          37  13  70
54  35  3          23  74  53
60  75  5          45  58  83
63  45  5          22  67  53
;

proc cancorr data=Jobs
             vprefix=Satisfaction wprefix=Characteristics
             vname='Satisfaction Areas' wname='Job Characteristics';
   var  Career Supervisor Finance;
   with Variety Feedback Autonomy;
run;

