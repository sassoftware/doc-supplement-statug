/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlmex1                                              */
/*   TITLE: Documentation Example 1 for PROC NLMIXED            */
/*          One-Compartment Model with Pharmacokinetic Data     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Continuous, normal response                         */
/*          Correlated random effects                           */
/*   PROCS: NLMIXED                                             */
/*    DATA: Theophylline data, Pinheiro and Bates (1995)        */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data theoph;
   input subject time conc dose wt;
   datalines;
 1  0.00  0.74 4.02 79.6
 1  0.25  2.84 4.02 79.6
 1  0.57  6.57 4.02 79.6
 1  1.12 10.50 4.02 79.6
 1  2.02  9.66 4.02 79.6
 1  3.82  8.58 4.02 79.6
 1  5.10  8.36 4.02 79.6
 1  7.03  7.47 4.02 79.6
 1  9.05  6.89 4.02 79.6
 1 12.12  5.94 4.02 79.6
 1 24.37  3.28 4.02 79.6
 2  0.00  0.00 4.40 72.4
 2  0.27  1.72 4.40 72.4
 2  0.52  7.91 4.40 72.4
 2  1.00  8.31 4.40 72.4
 2  1.92  8.33 4.40 72.4
 2  3.50  6.85 4.40 72.4
 2  5.02  6.08 4.40 72.4
 2  7.03  5.40 4.40 72.4
 2  9.00  4.55 4.40 72.4
 2 12.00  3.01 4.40 72.4
 2 24.30  0.90 4.40 72.4
 3  0.00  0.00 4.53 70.5
 3  0.27  4.40 4.53 70.5
 3  0.58  6.90 4.53 70.5
 3  1.02  8.20 4.53 70.5
 3  2.02  7.80 4.53 70.5
 3  3.62  7.50 4.53 70.5
 3  5.08  6.20 4.53 70.5
 3  7.07  5.30 4.53 70.5
 3  9.00  4.90 4.53 70.5
 3 12.15  3.70 4.53 70.5
 3 24.17  1.05 4.53 70.5
 4  0.00  0.00 4.40 72.7
 4  0.35  1.89 4.40 72.7
 4  0.60  4.60 4.40 72.7
 4  1.07  8.60 4.40 72.7
 4  2.13  8.38 4.40 72.7
 4  3.50  7.54 4.40 72.7
 4  5.02  6.88 4.40 72.7
 4  7.02  5.78 4.40 72.7
 4  9.02  5.33 4.40 72.7
 4 11.98  4.19 4.40 72.7
 4 24.65  1.15 4.40 72.7
 5  0.00  0.00 5.86 54.6
 5  0.30  2.02 5.86 54.6
 5  0.52  5.63 5.86 54.6
 5  1.00 11.40 5.86 54.6
 5  2.02  9.33 5.86 54.6
 5  3.50  8.74 5.86 54.6
 5  5.02  7.56 5.86 54.6
 5  7.02  7.09 5.86 54.6
 5  9.10  5.90 5.86 54.6
 5 12.00  4.37 5.86 54.6
 5 24.35  1.57 5.86 54.6
 6  0.00  0.00 4.00 80.0
 6  0.27  1.29 4.00 80.0
 6  0.58  3.08 4.00 80.0
 6  1.15  6.44 4.00 80.0
 6  2.03  6.32 4.00 80.0
 6  3.57  5.53 4.00 80.0
 6  5.00  4.94 4.00 80.0
 6  7.00  4.02 4.00 80.0
 6  9.22  3.46 4.00 80.0
 6 12.10  2.78 4.00 80.0
 6 23.85  0.92 4.00 80.0
 7  0.00  0.15 4.95 64.6
 7  0.25  0.85 4.95 64.6
 7  0.50  2.35 4.95 64.6
 7  1.02  5.02 4.95 64.6
 7  2.02  6.58 4.95 64.6
 7  3.48  7.09 4.95 64.6
 7  5.00  6.66 4.95 64.6
 7  6.98  5.25 4.95 64.6
 7  9.00  4.39 4.95 64.6
 7 12.05  3.53 4.95 64.6
 7 24.22  1.15 4.95 64.6
 8  0.00  0.00 4.53 70.5
 8  0.25  3.05 4.53 70.5
 8  0.52  3.05 4.53 70.5
 8  0.98  7.31 4.53 70.5
 8  2.02  7.56 4.53 70.5
 8  3.53  6.59 4.53 70.5
 8  5.05  5.88 4.53 70.5
 8  7.15  4.73 4.53 70.5
 8  9.07  4.57 4.53 70.5
 8 12.10  3.00 4.53 70.5
 8 24.12  1.25 4.53 70.5
 9  0.00  0.00 3.10 86.4
 9  0.30  7.37 3.10 86.4
 9  0.63  9.03 3.10 86.4
 9  1.05  7.14 3.10 86.4
 9  2.02  6.33 3.10 86.4
 9  3.53  5.66 3.10 86.4
 9  5.02  5.67 3.10 86.4
 9  7.17  4.24 3.10 86.4
 9  8.80  4.11 3.10 86.4
 9 11.60  3.16 3.10 86.4
 9 24.43  1.12 3.10 86.4
10  0.00  0.24 5.50 58.2
10  0.37  2.89 5.50 58.2
10  0.77  5.22 5.50 58.2
10  1.02  6.41 5.50 58.2
10  2.05  7.83 5.50 58.2
10  3.55 10.21 5.50 58.2
10  5.05  9.18 5.50 58.2
10  7.08  8.02 5.50 58.2
10  9.38  7.14 5.50 58.2
10 12.10  5.68 5.50 58.2
10 23.70  2.42 5.50 58.2
11  0.00  0.00 4.92 65.0
11  0.25  4.86 4.92 65.0
11  0.50  7.24 4.92 65.0
11  0.98  8.00 4.92 65.0
11  1.98  6.81 4.92 65.0
11  3.60  5.87 4.92 65.0
11  5.02  5.22 4.92 65.0
11  7.03  4.45 4.92 65.0
11  9.03  3.62 4.92 65.0
11 12.12  2.69 4.92 65.0
11 24.08  0.86 4.92 65.0
12  0.00  0.00 5.30 60.5
12  0.25  1.25 5.30 60.5
12  0.50  3.96 5.30 60.5
12  1.00  7.82 5.30 60.5
12  2.00  9.72 5.30 60.5
12  3.52  9.75 5.30 60.5
12  5.07  8.57 5.30 60.5
12  7.07  6.59 5.30 60.5
12  9.03  6.11 5.30 60.5
12 12.05  4.57 5.30 60.5
12 24.15  1.17 5.30 60.5
;

proc nlmixed data=theoph;
   parms beta1=-3.22 beta2=0.47 beta3=-2.45
         s2b1 =0.03  cb12 =0    s2b2 =0.4 s2=0.5;
   cl   = exp(beta1 + b1);
   ka   = exp(beta2 + b2);
   ke   = exp(beta3);
   pred = dose*ke*ka*(exp(-ke*time)-exp(-ka*time))/cl/(ka-ke);
   model conc ~ normal(pred,s2);
   random b1 b2 ~ normal([0,0],[s2b1,cb12,s2b2]) subject=subject;
run;

/* Cholesky-root parameterization as in Pinheiro and Bates (1995) */

proc nlmixed data=theoph;
   parms ll1=-1.5 l2=0 ll3=-0.1 beta1=-3 beta2=0.5 beta3=-2.5 ls2=-0.7;
   s2   = exp(ls2);
   l1   = exp(ll1);
   l3   = exp(ll3);
   s2b1 = l1*l1*s2;
   cb12 = l2*l1*s2;
   s2b2 = (l2*l2 + l3*l3)*s2;
   cl   = exp(beta1 + b1);
   ka   = exp(beta2 + b2);
   ke   = exp(beta3);
   pred = dose*ke*ka*(exp(-ke*time)-exp(-ka*time))/cl/(ka-ke);
   model conc   ~ normal(pred,s2);
   random b1 b2 ~ normal([0,0],[s2b1,cb12,s2b2]) subject=subject;
run;

