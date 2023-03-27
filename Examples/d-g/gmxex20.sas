/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gmxex20                                             */
/*   TITLE: Documentation Example 20 for PROC GLIMMIX           */
/*          Predictive Margins Comparison                       */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Generalized linear mixed models                     */
/*          Binomial data                                       */
/*   PROCS: GLIMMIX                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data multicenter;
   input center trt$ age marker response @@;
   datalines;
 1 A  15  0  0     1 A  28  0  0
 1 A  60  0  1     1 A  68  1  1
 1 A  23  1  0     1 A  33  1  1
 1 A  30  1  0     1 A  73  1  1
 1 A  15  1  0     1 A  34  1  0
 1 A  15  1  0     1 A  68  1  1
 1 B  53  0  1     1 B  62  0  1
 1 B  15  0  0     1 B  28  1  0
 1 B  27  1  0     1 B  45  1  0
 1 B  56  1  1     1 B  24  1  0
 1 B  42  1  0     1 B  61  1  0
 1 B  15  1  0     1 B  67  1  1
 2 A  28  0  1     2 A  43  0  1
 2 A  52  0  1     2 A  49  1  1
 2 A  59  1  1     2 A  32  1  1
 2 A  50  1  1     2 A  41  1  1
 2 A  21  1  0     2 A  62  1  1
 2 A  77  1  1     2 A  70  1  1
 2 B  79  0  1     2 B  49  0  1
 2 B  73  0  1     2 B  73  1  1
 2 B  78  1  1     2 B  61  1  1
 2 B  78  1  1     2 B  54  1  1
 2 B  51  1  1     2 B  50  1  1
 2 B  17  1  0     2 B  15  1  0
 3 A  20  0  0     3 A  18  0  1
 3 A  32  0  1     3 A  55  1  1
 3 A  51  1  1     3 A  58  1  1
 3 A  36  1  1     3 A  15  1  0
 3 A  21  1  0     3 A  24  1  1
 3 A  40  1  1     3 A  28  1  0
 3 B  54  0  1     3 B  64  0  1
 3 B  15  0  0     3 B  15  1  0
 3 B  76  1  1     3 B  39  1  1
 3 B  48  1  0     3 B  34  1  0
 3 B  17  1  0     3 B  37  1  0
 3 B  35  1  0     3 B  30  1  1
 4 A  74  0  1     4 A  78  0  1
 4 A  15  1  0     4 A  41  1  1
 4 A  25  1  0     4 A  31  1  0
 4 A  22  1  0     4 A  15  1  0
 4 B  77  0  1     4 B  33  0  0
 4 B  21  1  0     4 B  15  1  0
 4 B  70  1  1     4 B  54  1  0
 4 B  15  1  0     4 B  15  1  0
 5 A  21  0  1     5 A  72  0  1
 5 A  28  1  1     5 A  58  1  1
 5 A  39  1  1     5 A  41  1  1
 5 A  35  1  0     5 A  59  1  1
 5 B  73  0  1     5 B  15  0  0
 5 B  46  1  1     5 B  59  1  1
 5 B  20  1  0     5 B  66  1  1
 5 B  24  1  0     5 B  15  1  0
 6 A  25  0  0     6 A  15  0  0
 6 A  63  1  1     6 A  15  1  0
 6 A  61  1  1     6 A  73  1  1
 6 A  35  1  0     6 A  76  1  1
 6 B  76  0  1     6 B  15  0  0
 6 B  15  1  0     6 B  15  1  0
 6 B  15  1  0     6 B  47  1  0
 6 B  77  1  1     6 B  17  1  0
 7 A  27  0  0     7 A  18  0  0
 7 A  18  0  1     7 A  62  1  1
 7 A  30  1  0     7 A  25  1  0
 7 A  40  1  0     7 A  18  1  0
 7 A  16  1  0     7 A  17  1  0
 7 A  43  1  1     7 A  24  1  0
 7 B  64  0  1     7 B  29  0  0
 7 B  23  0  0     7 B  20  1  0
 7 B  36  1  0     7 B  46  1  0
 7 B  19  1  0     7 B  41  1  0
 7 B  23  1  0     7 B  40  1  1
 7 B  37  1  1     7 B  22  1  0
 8 A  51  0  1     8 A  85  0  1
 8 A  16  1  1     8 A  37  1  1
 8 A  28  1  0     8 A  24  1  0
 8 A  25  1  0     8 A  17  1  0
 8 B  54  0  1     8 B  21  0  1
 8 B  23  1  0     8 B  20  1  0
 8 B  19  1  0     8 B  18  1  0
 8 B  21  1  0     8 B  22  1  0
 9 A  22  0  0     9 A  23  0  0
 9 A  33  1  0     9 A  68  1  1
 9 A  42  1  1     9 A  51  1  1
 9 A  16  1  0     9 A  52  1  1
 9 B  77  0  1     9 B  16  0  0
 9 B  42  1  0     9 B  59  1  1
 9 B  28  1  0     9 B  33  1  0
 9 B  31  1  0     9 B  20  1  0
10 A  30  0  1    10 A  24  0  1
10 A  18  1  0    10 A  16  1  0
10 A  27  1  1    10 A  29  1  1
10 A  40  1  1    10 A  64  1  1
10 B  32  0  1    10 B  25  0  0
10 B  19  1  0    10 B  22  1  0
10 B  23  1  0    10 B  38  1  0
10 B  18  1  1    10 B  23  1  0
;

proc glimmix data=multicenter;
   class center trt marker;
   model response = trt|marker age/s dist=binary link=logit;
   random  intercept/ subject=center;
   margins trt/ diff;
   margins trt*marker/ sliceby=marker slicediff;
run;

