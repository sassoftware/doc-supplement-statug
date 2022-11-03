/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gmxex14                                             */
/*   TITLE: Documentation Example 14 for PROC GLIMMIX           */
/*          Generalized Poisson Mixed Model for Overdispersed   */
/*          Count Data                                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Generalized linear mixed models                     */
/*          User-defined log likelihood                         */
/*          Adaptive Gauss-Hermite quadrature                   */
/*   PROCS: GLIMMIX                                             */
/*    DATA: Simulated counts                                    */
/*                                                              */
/*     REF: Joe, H. and Zhu, R. (2005)                          */
/*          Generalized Poisson Distribution: the Property of   */
/*          Mixture of Poisson and Comparison with Negative     */
/*          Binomial Distribution                               */
/*          Biometrical Journal, 47, 219--229                   */
/*    MISC:                                                     */
/****************************************************************/

data counts;
   input ni @@;
   sub = _n_;
   do i=1 to ni;
      input x y @@;
      output;
   end;
   datalines;
  1 29 0
  6  2 0 82 5 33 0 15 2 35 0 79 0
 19 81 0 18 0 85 0 99 0 20 0 26 2 29 0 91 2 37 0 39 0  9 1 33 0
     3 0 60 0 87 2 80 0 75 0  3 0 63 1
  9 18 0 64 0 80 0  0 0 58 0  7 0 81 0 22 3 50 0
 15 91 0  2 1 14 0  5 2 27 1  8 1 95 0 76 0 62 0 26 2  9 0 72 1
    98 0 94 0 23 1
  2 34 0 95 0
 18 48 1  5 0 47 0 44 0 27 0 88 0 27 0 68 0 84 0 86 0 44 0 90 0
    63 0 27 0 47 0 25 0 72 0 62 1
 13 28 1 31 0 63 0 14 0 74 0 44 0 75 0 65 0 74 1 84 0 57 0 29 0
    41 0
  9 42 0  8 0 91 0 20 0 23 0 22 0 96 0 83 0 56 0
  3 64 0 64 1 15 0
  4  5 0 73 2 50 1 13 0
  2  0 0 41 0
 20 21 0 58 0  5 0 61 1 28 0 71 0 75 1 94 16 51 4 51 2 74 0  1 1
    34 0  7 0 11 0 60 3 31 0 75 0 62 0 54 1
  2 66 1 13 0
  5 83 7 98 1 11 1 28 0 18 0
 17 29 5 79 0 39 2 47 2 80 1 19 0 37 0 78 1 26 0 72 1  6 0 50 3
    50 4 97 0 37 2 51 0 45 0
 17 47 0 57 0 33 0 47 0  2 0 83 0 74 0 93 0 36 0 53 0 26 0 86 0
     6 0 17 0 30 0 70 1 99 0
  7 91 0 25 1 51 4 20 0 61 1 34 0 33 2
 14 60 0 87 0 94 0 29 0 41 0 78 0 50 0 37 0 15 0 39 0 22 0 82 0
    93 0  3 0
 16 68 0 26 1 19 0 60 1 93 3 65 0 16 0 79 0 14 0  3 1 90 0 28 3
    82 0 34 0 30 0 81 0
 19 48 3 48 1 43 2 54 0 45 9 53 0 14 0 92 5 21 1 20 0 73 0 99 0
    66 0 86 2 63 0 10 0 92 14 44 1 74 0
  8 34 1 44 0 62 0 21 0  7 0 17 0  0 2 49 0
 13 11 0 27 2 16 1 12 3 52 1 55 0  2 6 89 5 31 5 28 3 51 5 54 13
    64 0
  9  3 0 36 0 57 0 77 0 41 0 39 0 55 0 57 0 88 1
  7  2 0 80 0 41 1 20 0  2 0 27 0 40 0
 18 73 1 66 0 10 0 42 0 22 0 59 9 68 0 34 1 96 0 30 0 13 0 35 0
    51 2 47 0 60 1 55 4 83 3 38 0
 17 96 0 40 0 34 0 59 0 12 1 47 0 93 0 50 0 39 0 97 0 19 0 54 0
    11 0 29 0 70 2 87 0 47 0
 13 59 0 96 0 47 1 64 0 18 0 30 0 37 0 36 1 69 0 78 1 47 1 86 0
    88 0
 15 66 0 45 1 96 1 17 0 91 0  4 0 22 0  5 2 47 0 38 0 80 0  7 1
    38 1 33 0 52 0
 12 84 6 60 1 33 1 92 0 38 0  6 0 43 3 13 2 18 0 51 0 50 4 68 0
;

proc glimmix data=counts method=quad;
   class sub;
   model y = x / link=log s dist=poisson;
   random int / subject=sub;
run;

proc glimmix data=counts method=quad;
   class sub;
   model y = x / link=log s;
   random int / subject=sub;
   xi = (1 - 1/exp(_phi_));
   _variance_ = _mu_ / (1-xi)/(1-xi);
   if (_mu_=.) or (_linp_ = .) then _logl_ = .;
   else do;
      mustar = _mu_ - xi*(_mu_ - y);
      if (mustar < 1E-12) or (_mu_*(1-xi) < 1e-12) then
         _logl_ = -1E20;
      else do;
         _logl_ = log(_mu_*(1-xi)) + (y-1)*log(mustar) -
                   mustar - lgamma(y+1);
      end;
   end;
run;
proc glimmix data=counts method=quad;
   class sub;
   model y = x / link=log s;
   random int / subject=sub;
   xi = (1 - 1/exp(_phi_));
   _variance_ = _mu_ / (1-xi)/(1-xi);
   if (_mu_=.) or (_linp_ = .) then _logl_ = .;
   else do;
      mustar = _mu_ - xi*(_mu_ - y);
      if (mustar < 1E-12) or (_mu_*(1-xi) < 1e-12) then
         _logl_ = -1E20;
      else do;
         _logl_ = log(_mu_*(1-xi)) + (y-1)*log(mustar) -
                   mustar - lgamma(y+1);
      end;
   end;
   covtest 'H:phi = 0' . 0 / est;
run;
