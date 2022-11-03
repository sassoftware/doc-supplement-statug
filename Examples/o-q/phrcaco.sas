 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: PHRCACO                                             */
 /*   TITLE: Design and Analysis of Case-Cohort Data             */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: survival analysis                                   */
 /*   PROCS: PHREG                                               */
 /*    DATA:                                                     */
 /*                                                              */
  /*    MISC: Barlow (1994)'s Robust Variance Estimation          */
 /*                                                              */
 /****************************************************************/

 /*-----------------------------------------------------------
  Example: Fitting Case-Cohort Design

     In the analysis of a case-cohort study, the risk set at each
     event time consists of the case that fails at that particular
     event time and members of the subcohort who were at risk at
     the event time. A case outside the subcohort can only be in
     the risk set of his event time. By explicitly constructing
     the risk sets for the event times, you can use PROC PHREG to
     estimate the regression coefficents and compute the robust
     variance estimate of Breslow (1994).

  References:

     Barlow, W.E. (1994), "Robust variance estimation of
     case-cohort design," Biometrics, 50, 1064-1072.

     Breslow, N.E. and Day, N.E. (1987), Statistical Methods
     in Cancer Research, Vol. II - The Design and Analysis
     of Cohort Studies, Lyon: International Agency for
     Research on Cancer.

  -----------------------------------------------------------*/

 /*
   As a illustration of Barlow (1994)'s method, consider the
   cohort of the South Wales Nickel Worker study (Breslow and
   Day 1987, pp. 375-390). The full cohort consists of 679
   workers, and the event of interest is the death from nasal
   sinus cancer (ICD=160). A 10% subcohort is randomly chosen.
   The data for the cases and/or subcohort members are saved
   in the data set NICKEL.

   The data set NICKEL contains seven variables:

      Id            (identification number)
      Exposure      (exposure level)
      Yr_Emp        (calendar year employed),
      AgeStart      (age at first employment),
      AgeStop       (age at death or withdrawal),
      Nasal         (1=nasal sinus cancer, 2=otherwise),
      Subcohort     (1=subcohort member, 0=otherwise).

   There are 68 individuals in the subcohort. Fifty-six workers
   died from nasal sinus cancer, 9 of them are in the chosen
   subcohort.
 */

data nickel;
   input Id Exposure Yr_Emp AgeStart AgeStop Nasal Subcohort @@;
   datalines;
  8  9.0 1911 47.907 69.679 2 1  16  0.5 1924 59.915 65.583 1 0
 19 10.0 1915 52.520 58.490 1 0  35  0.5 1909 47.852 82.827 2 1
 42  0.0 1923 34.748 83.049 2 1  47  1.0 1911 45.934 47.114 1 0
 52  0.5 1915 39.499 86.688 2 1  53  1.0 1923 33.536 72.761 1 0
 54 11.0 1914 44.849 77.808 1 0  55  0.0 1923 33.260 81.014 2 1
 56  2.0 1922 29.746 51.585 2 1  63 14.0 1908 56.216 58.065 1 0
 64  6.0 1907 45.746 64.812 2 1  75  0.0 1922 28.838 76.592 2 1
106 11.0 1908 53.935 58.072 1 0 107  0.0 1923 36.592 79.847 2 1
117  1.0 1916 42.594 66.337 2 1 126 18.0 1908 50.746 57.279 2 1
142  7.5 1910 50.331 57.449 1 0 143  3.0 1920 46.746 77.303 2 1
144  1.5 1913 49.741 67.229 1 0 150  9.5 1910 62.315 64.732 1 0
151 10.5 1908 58.882 77.745 1 0 154  2.5 1922 44.096 70.000 2 1
156 12.5 1914 46.746 58.837 2 1 180  3.0 1913 41.746 48.117 2 1
208  1.5 1913 47.219 67.211 2 1 222  3.5 1913 58.162 70.910 1 0
224  0.0 1917 30.746 37.645 2 1 256  2.0 1920 53.746 68.235 2 1
271  9.0 1915 49.727 64.990 1 0 286  5.0 1910 47.746 63.832 2 1
294  5.5 1920 48.948 62.096 1 0 298 12.0 1911 48.425 54.700 1 0
299  0.0 1921 35.746 68.653 1 0 306  0.0 1922 36.746 37.300 2 1
319  0.0 1922 33.509 66.320 1 0 330  0.0 1910 52.668 70.079 1 1
353  0.0 1924 32.746 48.763 2 1 360  0.0 1913 50.340 86.241 2 1
363 10.0 1910 50.825 57.789 1 0 378  3.5 1913 40.746 63.974 1 0
381 13.0 1914 49.651 78.087 1 1 386  5.0 1917 32.573 78.375 2 1
392 15.0 1912 43.227 57.585 1 0 395  3.0 1919 38.083 70.806 1 0
400  0.0 1922 30.877 77.067 2 1 408  1.0 1908 51.746 74.481 2 1
409  2.0 1912 59.746 70.807 2 1 410  0.0 1923 33.746 51.661 2 1
419  0.0 1922 31.707 70.808 2 1 421  1.0 1914 49.746 69.782 1 0
423  0.0 1906 59.746 74.522 2 1 427  3.5 1915 45.910 67.417 2 1
436  0.0 1922 34.868 73.351 2 1 446  0.0 1923 46.175 65.017 1 0
453  0.0 1923 41.744 64.183 1 0 478  0.0 1924 38.909 73.926 2 1
499  9.0 1910 44.746 67.003 2 1 506  6.0 1911 44.786 67.523 1 1
518  5.5 1903 53.599 80.361 1 0 522  6.0 1906 48.746 63.276 2 1
525  0.0 1920 34.934 65.439 2 1 529  1.0 1923 32.611 50.293 1 0
538  4.5 1912 39.000 59.129 2 1 545  0.5 1920 33.995 71.436 2 1
553  0.0 1923 37.637 70.495 2 1 566  2.5 1912 57.645 66.448 1 0
578  0.0 1910 50.252 74.504 1 0 593  7.5 1914 51.808 61.821 1 0
595  8.0 1911 49.309 79.560 1 0 599  0.0 1916 48.315 81.403 1 0
608  3.0 1922 33.744 72.634 2 1 609  3.0 1915 57.907 70.455 1 0
618  9.0 1913 51.746 53.735 2 1 622  4.5 1905 50.746 71.555 2 1
629  0.0 1911 39.235 75.016 2 1 639 16.0 1909 52.334 78.145 1 0
658  1.0 1918 53.987 68.503 1 0 674 12.5 1904 61.569 63.065 1 0
675  3.0 1922 35.746 53.831 2 1 687  4.0 1914 49.077 78.433 1 1
706  6.0 1913 59.805 74.937 1 0 717 11.5 1908 58.400 59.101 1 1
719  8.0 1915 53.509 56.030 1 0 729  2.0 1922 41.746 70.333 1 1
742  3.0 1903 51.746 57.360 2 1 768 13.0 1907 52.583 59.548 1 0
772  0.0 1922 38.746 55.275 2 1 776  0.0 1912 57.746 66.881 1 0
780  0.0 1923 47.441 56.795 1 0 781  6.0 1915 58.457 69.926 1 0
790  3.0 1914 49.621 59.341 1 0 802  0.0 1903 57.746 86.094 2 1
811  6.0 1909 51.835 63.367 1 0 815  0.0 1916 39.746 53.174 2 1
818  4.0 1909 44.657 71.521 1 1 827 12.0 1911 59.268 64.510 1 1
833  1.0 1915 57.637 62.443 1 0 835  0.5 1919 36.926 54.868 2 1
836  6.5 1912 54.746 68.004 2 1 839  6.5 1914 45.246 62.334 1 0
841  3.0 1903 60.746 66.607 2 1 846  2.0 1923 38.320 77.066 2 1
861  0.0 1923 35.937 67.860 2 1 864  0.0 1923 38.715 80.444 2 1
875  5.0 1914 60.279 76.501 1 1 888  2.0 1913 43.746 67.363 2 1
919  0.0 1913 42.091 82.159 2 1 931  0.0 1916 64.746 70.292 2 1
942  0.0 1906 50.039 51.461 1 0 945  4.5 1913 70.746 83.289 2 1
963  3.5 1914 47.746 51.695 2 1 964  3.0 1923 41.746 73.640 2 1
969 14.0 1910 52.746 57.686 1 0
;

 /*
   Barlow (1994) has considered weights that reflect the
   subcohort membership. Controls in the subcohort are weighted
   inversely proportional to the sampling fraction. For a cohort
   of 10%, the weight is 10.  Cases have a weight of 1 at the
   instant the individual fails regardless of subcohort member-
   ship. Cases inside the subcohort are controls until they
   become a case, and at such instant the weight changes. The
   analysis requires a staggered entry into the cohort since
   the workers started their employment at different times.
   Although PROC PHREG allows a staggered entry with the use of
   the counting process style of input, with all the given
   restrictions, it is simplier to construct the risk sets
   explicity rather than tricking PROC PHREG into forming
   appropriate risk sets.

   The following SAS statements expand the data set NICKEL
   to include explicitly risk sets for the event times (save
   in the data set ONE). The new data set contains three
   additional variables:

      Strat   (stratifying variable representing distinct
               case-control sets)
      T       (articifical time variable: 1=case, 2=control)
      Wt      (weight of the observations)
 */

proc sort data=nickel;
   by AgeStop;
run;

data one (drop=EvntTime);
   retain Strat 0;
   set Nickel;
   if Nasal=1 then do;
      Strat + 1;
      EvntTime= AgeStop;
      t=1;
      Wt=1;
      output;
      do i=_n_+1 to n;
         set Nickel point=i nobs=n;
         if Subcohort=1 and (AgeStart lt EvntTime le AgeStop)
         then do;
            T=2;
            Wt=10;  /* 10% subcohort */
            output;
         end;
      end;
   end;
run;

 /*
   In the following SAS statements, PROC PHREG is invoked to fit
   the case-cohort model with Yr_Emp and Exposure as the
   explanatory variables. Strat is used as a stratifying variable,
   T is the failure time variable, and the control observations
   (T=2) are regarded as censored. Wt is used as the  WEIGHT variable.
 */

proc phreg data=one covs(aggregate);
   model T*T(2)=Yr_Emp Exposure;
   weight Wt;
   strata Strat;
   id Id;
run;
