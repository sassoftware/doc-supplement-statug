/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: qregex5                                             */
/*   TITLE: Documentation Example 5 for PROC QUANTREG           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Quantile Regression                                 */
/*                                                              */
/*   PROCS: QUANTREG                                            */
/*    DATA: salary                                              */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data salary;
   input Salaries Years @@;
   label Salaries='Salaries (1000s of dollars)';
   datalines;
54.94   2  58.24   2  58.11   2  52.23   2  52.98    2  57.62    2
44.48   2  57.22   2  54.24   2  54.79   2  56.42    2  61.90    2
63.90   2  64.10   2  47.77   2  54.86   2  49.31    2  53.37    2
51.69   2  53.66   2  58.77   2  56.77   2  53.06    2  54.86    2
50.96   2  56.46   2  51.67   2  49.37   2  56.86    2  49.85    2
50.95   2  56.46   2  48.76   2  55.87   2  60.22    2  50.27    2
56.83   2  56.16   2  54.49   2  57.79   2  52.97    2  54.78    2
56.10   2  55.06   2  56.02   2  56.54   2  54.31    2  63.06    2
52.06   2  51.44   2  52.53   2  58.71   2  58.83    2  57.42    2
56.04   2  51.06   2  49.98   2  56.20   2  51.31    2  48.24    2
54.51   2  54.77   2  51.60   2  54.21   2  52.20    2  55.38    2
51.02   2  51.30   2  50.76   2  54.67   2  53.38    2  54.15    2
52.48   2  56.68   2  57.83   2  56.19   2  49.11    2  60.12    2
50.02   2  67.11   5  68.71   5  62.13   5  64.63    5  61.42    5
68.29   5  62.08   5  67.68   5  66.52   5  73.68    5  60.18    5
49.50   5  60.12   5  69.50   5  48.50   5  61.00    5  54.15    5
51.16   5  48.90   5  68.91   5  62.15   5  52.43    5  59.42    5
60.64   5  51.58   5  70.45   5  62.48   5  68.92    5  59.05    5
59.43   5  61.91   5  66.88   5  60.26   5  54.17    5  69.50    5
70.29   5  60.02   5  61.49   5  50.60   5  65.43    5  65.07    5
67.43   5  68.42   5  63.65   5  56.54   5  73.90    5  62.07    5
63.10   5  59.04   5  59.56   5  72.90   5  73.10    5  62.56    5
62.64   5  66.70   5  73.80   5  64.45   5  63.92    5  71.98    5
55.52   5  58.90   5  58.05   5  65.78   5  70.24    5  55.78    5
54.72   5  57.45   5  64.95   5  57.81   5  55.40    8  53.80    8
74.20   8  67.74   8  54.20   8  65.98   8  64.23    8  65.92    8
61.31   8  62.38   8  63.04   8  65.84   8  60.04    8  65.52    8
64.67   8  64.85   8  64.62   8  66.98   8  69.54    8  67.48    8
62.46   8  64.81   8  68.40   8  63.11   8  58.99    8  68.10    8
68.77   8  65.97   8  67.96   8  64.47   8  65.90    8  59.14    8
65.23   8  73.45   8  64.47   8  58.48   8  60.94    8  58.86    8
69.38   8  66.67   8  62.43   8  63.97   8  69.39    8  65.36    8
74.90   8  64.57   8  75.53   8  70.54   8  73.80   11  53.20   11
66.69  11  54.13  11  59.61  11  75.20  11  53.98   11  78.20   11
59.51  11  68.72  11  51.01  11  76.20  11  61.32   11  58.76   11
60.45  11  67.04  11  61.21  11  66.26  11  53.94   11  61.75   11
59.08  11  64.94  11  75.02  11  65.26  11  56.49   11  72.71   11
55.39  11  62.64  11  62.66  11  66.78  11  63.01   11  61.99   11
65.48  11  58.56  11  60.46  11  58.66  11  62.30   11  61.22   11
61.71  11  71.19  11  59.98  11  68.30  11  56.04   11  64.69   11
52.01  11  58.42  11  58.42  11  56.64  11  65.35   11  56.37   11
63.17  11  63.15  11  59.03  11  61.99  11  51.84   11  56.40   11
60.59  11  71.78  11  60.98  11  65.43  11  69.64   11  57.71   11
57.07  11  60.75  11  69.79  11  65.44  14  76.90   14  77.80   14
71.75  14  65.13  14  69.12  14  64.35  14  61.38   14  64.61   14
61.08  14  66.16  14  76.20  14  69.19  14  75.90   14  52.10   14
64.85  14  53.40  14  66.42  14  58.09  14  54.46   14  69.47   14
60.12  14  65.57  14  60.50  14  63.14  14  59.12   14  59.30   14
65.30  14  55.10  14  54.81  14  66.28  14  65.49   14  68.15   14
55.40  14  58.70  14  75.37  14  58.01  14  57.23   14  63.27   14
64.61  14  61.11  14  62.56  14  67.80  14  56.28   14  56.44   14
59.68  14  59.08  14  62.55  14  64.13  14  61.91   14  63.71   14
60.71  14  65.68  14  59.47  14  65.53  14  75.80   14  75.10   14
59.00  14  63.64  14  64.17  14  70.18  14  67.75   14  63.58   14
72.84  17  73.79  17  73.25  17  68.77  17  77.07   17  74.15   17
68.65  17  58.19  17  57.38  17  60.77  17  60.65   17  60.50   17
74.09  17  61.50  17  77.26  17  60.46  17  55.61   17  69.35   17
59.40  17  71.66  17  74.88  17  59.50  17  58.50   17  69.09   17
59.67  17  63.70  17  76.63  17  75.65  17  78.55   17  68.53   17
75.30  17  69.17  17  77.71  17  62.70  17  58.99   17  59.36   17
74.33  17  71.55  17  56.42  17  68.96  17  68.69   17  76.89   17
74.71  17  69.04  17  72.20  17  70.51  17  69.65   17  54.73   17
70.27  17  69.74  17  72.88  17  79.20  17  62.55   20  59.10   20
72.15  20  58.20  20  57.10  20  75.67  20  60.10   20  66.45   20
68.27  20  57.70  20  68.09  20  77.70  20  72.74   20  64.55   20
66.61  20  64.89  20  67.34  20  69.59  20  70.85   20  70.97   20
74.35  20  77.80  20  78.10  20  66.33  20  77.50   20  76.91   20
68.37  20  72.77  20  70.85  20  70.89  20  74.77   23  83.62   23
69.33  23  82.80  23  57.80  23  59.80  23  67.09   23  60.03   23
67.77  23  68.23  23  66.23  23  71.72  23  81.80   23  60.80   23
63.94  23  81.74  23  73.60  23  77.81  23  60.98   23  65.52   23
60.64  23  69.89  23  72.85  23  77.70  23  61.21   23  74.73   23
58.87  23  58.02  25  68.94  25  85.50  25  53.48   25  61.13   25
63.37  25  83.50  25  85.48  25  56.99  25  75.12   25  57.33   25
85.72  25  64.87  25  51.76  25  51.11  25  51.31   25  78.28   25
57.91  25  86.78  25  58.27  25  56.56  25  76.33   25  61.83   25
69.13  25  63.15  25  66.13  25
;

ods graphics on;

proc quantreg data=salary ci=sparsity;
   model salaries = years years*years years*years*years
                     /quantile=0.25 0.5 0.75
                     plot=fitplot(showlimits);

   test  years/QINTERACT;

run;
