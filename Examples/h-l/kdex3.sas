/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: KDEX3                                               */
/*   TITLE: Documentation Example 6 for PROC KDE                */
/* PRODUCT: SAS                                                 */
/*  SYSTEM: ALL                                                 */
/*    KEYS: kernel density estimation, ODS Graphics             */
/*   PROCS: KDE                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC KDE, Example 6                                 */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/
data octane;
   input Rater Customer;
   label Rater    = 'Rater'
         Customer = 'Customer';
   datalines;
94.5 92.0
94.0 88.0
94.0 90.0
93.0 93.0
88.0 88.0
91.0 89.0
93.0 89.0
90.5 84.0
96.0 88.0
92.0 86.0
94.0 88.0
92.0 82.0
92.0 82.0
92.0 84.0
95.0 89.0
96.0 90.0
92.0 88.0
86.0 80.0
96.0 90.0
93.0 85.0
91.0 87.0
92.0 87.0
91.0 86.0
95.0 90.0
84.0 80.0
93.0 87.0
88.0 82.0
87.0 87.0
94.0 85.0
92.0 86.0
94.0 89.0
94.8 89.1
95.7 90.8
92.8 88.2
96.6 88.2
96.6 91.6
89.1 85.4
89.1 80.8
91.6 85.4
94.8 90.0
95.7 90.0
95.7 86.4
96.6 88.2
93.9 91.6
94.8 85.4
96.6 83.6
93.9 89.1
94.8 83.6
89.1 76.6
94.8 91.6
93.9 87.3
94.0 87.0
96.0 88.0
90.0 77.0
93.0 89.0
94.0 90.0
96.0 84.0
96.0 88.0
96.0 84.0
92.0 86.0
97.0 91.0
88.0 87.0
91.0 90.0
87.0 77.0
93.0 86.0
92.0 88.0
92.0 86.0
99.0 88.0
89.0 80.0
88.0 77.0
91.0 83.0
87.0 83.0
99.5 93.0
92.0 86.0
90.0 86.0
96.0 88.0
85.0 77.0
94.0 81.0
95.0 88.0
91.0 79.0
96.0 89.0
96.0 94.0
90.0 86.0
91.0 84.0
82.0 82.0
95.0 93.0
89.0 83.0
96.0 93.0
94.0 89.0
96.0 79.0
88.0 84.0
91.0 79.0
96.0 86.0
92.0 80.0
90.0 85.0
88.5 88.0
90.0 82.0
93.0 83.0
93.0 84.0
98.0 94.0
95.5 92.0
94.0 90.0
95.0 87.0
90.0 81.0
98.5 94.0
90.0 88.0
90.0   .L
86.0   .L
86.0   .L
91.0 85.0
96.0 88.0
95.0 94.0
94.0 87.0
92.0 88.0
90.0   .L
89.0 84.0
97.0 90.0
94.0 80.0
88.0 89.0
90.0 86.0
90.0 86.0
88.0 86.0
96.0 91.0
87.0 79.0
91.0 83.0
89.0 86.0
94.0 88.0
87.0   .L
94.0 89.0
92.0   .L
86.0 80.0
88.0 82.0
91.0 86.0
89.0   .L
88.0 87.0
86.0   .L
91.5 87.0
90.0   .L
85.0 87.0
91.5   .L
86.5   .L
95.0 86.0
83.0   .L
86.7 84.9
91.5 84.9
94.0 91.5
86.7 76.6
96.0 91.5
88.3 84.9
95.0 84.9
91.5 90.0
84.9 86.7
88.3 86.7
97.5 98.2
84.9   .L
90.0 84.9
91.5 88.3
91.5 80.8
80.8   .L
91.5 80.8
92.8 88.3
92.8 83.0
95.0 84.9
88.3 84.9
95.0 91.5
94.0 84.9
91.5 84.9
91.5 84.9
84.9 83.0
88.3 80.8
86.7 86.7
91.5 88.3
94.0 84.9
96.0 90.0
88.3 84.9
86.7   .L
96.5 92.8
98.7 91.5
94.0 78.7
86.7 86.7
90.0 84.9
  .H 84.9
91.0 89.0
95.0 92.0
95.0 91.0
94.0 86.0
94.0 82.0
94.0 91.0
92.0 85.0
88.0 80.0
89.0 87.0
92.5 83.0
93.5 82.0
96.0 90.0
88.0 86.0
93.0 84.0
92.0 86.0
90.0 85.0
91.0 86.0
93.0 87.0
90.0 82.0
96.0 88.0
92.0 85.0
91.0 85.0
93.0 90.0
93.0 90.0
94.0 86.0
89.5 85.0
90.0 88.0
91.0 88.0
95.0 82.0
96.0   .L
90.0 87.0
94.0 89.0
96.0 89.0
90.0 83.0
97.0 91.0
98.0 86.0
94.0 89.0
99.0 91.0
94.0   .L
89.0 87.0
94.5 90.0
91.0 83.0
92.0 85.0
89.0 83.0
93.0 93.0
95.0 87.0
88.0 89.0
89.0 87.0
89.0 86.0
89.0 87.0
92.0 84.0
89.0 90.0
96.0 92.0
95.0 86.0
95.0 87.0
96.0 90.0
93.0 79.0
94.0 90.0
86.0 85.0
96.0 95.0
88.0 83.0
83.0 82.0
89.0 78.0
93.0 87.0
88.0 84.0
  .H 90.0
;
ods graphics on;
proc kde data=octane;
   bivar Rater Customer / plots=all;
run;
ods graphics off;