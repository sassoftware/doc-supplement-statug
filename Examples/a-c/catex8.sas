/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CATEX8                                              */
/*   TITLE: Example 8 for PROC CATMOD                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis                           */
/*   PROCS: CATMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC CATMOD chapter          */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*----------------------------------------------------------------
Example 8: Repeated Measures, Logistic Analysis of Growth Curve

               Growth Curve Analysis
               ---------------------
Subjects from 2 diagnostic groups (mild or severe) are given
one of 2 treatments (std or new), and their response to
treatment (n=normal or a=abnormal) is recorded at each of 3
times (weeks 1, 2, and 4)

From: Koch et al. (1977)
----------------------------------------------------------------*/

title 'Growth Curve Analysis';
data growth2;
   input Diagnosis $ Treatment $ week1 $ week2 $ week4 $ count @@;
   datalines;
mild std n n n 16    severe std n n n  2
mild std n n a 13    severe std n n a  2
mild std n a n  9    severe std n a n  8
mild std n a a  3    severe std n a a  9
mild std a n n 14    severe std a n n  9
mild std a n a  4    severe std a n a 15
mild std a a n 15    severe std a a n 27
mild std a a a  6    severe std a a a 28
mild new n n n 31    severe new n n n  7
mild new n n a  0    severe new n n a  2
mild new n a n  6    severe new n a n  5
mild new n a a  0    severe new n a a  2
mild new a n n 22    severe new a n n 31
mild new a n a  2    severe new a n a  5
mild new a a n  9    severe new a a n 32
mild new a a a  0    severe new a a a  6
;

proc catmod data=growth2 order=data;
   title2 'Reduced Logistic Model';
   weight count;
   population Diagnosis Treatment;
   response logit;
   model week1*week2*week4=(1 0 0 0,  /* mild, std */
                            1 0 1 0,
                            1 0 2 0,

                            1 0 0 0,  /* mild, new */
                            1 0 0 1,
                            1 0 0 2,

                            0 1 0 0,  /* severe, std */
                            0 1 1 0,
                            0 1 2 0,

                            0 1 0 0,  /* severe, new */
                            0 1 0 1,
                            0 1 0 2)
          (1='Mild diagnosis, week 1',
           2='Severe diagnosis, week 1',
           3='Time effect for std trt',
           4='Time effect for new trt')
           / freq design;
   contrast 'Diagnosis effect, week 1' all_parms 1 -1 0 0;
   contrast 'Equal time effects' all_parms 0 0 1 -1;
quit;
