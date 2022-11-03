/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: fmmex03                                             */
/*   TITLE: Documentation Example 3 for PROC FMM                */
/*          Mixed Poisson Regression                            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Partially varying mean functions                    */
/*          Likelihood ratio test                               */
/*          Outlier induces overdispersion                      */
/*                                                              */
/*   PROCS: FMM                                                 */
/*    DATA: Ames salmonella assay data, Margolin et al. (1981)  */
/*                                                              */
/*     REF: Wang, P., Puterman, M. L., Cockburn, I., and Le, N.,*/
/*          (1996), Mixed Poisson Regression Models With        */
/*          Covariate Dependent Rates, Biometrics, 52, 381--400.*/
/*    MISC:                                                     */
/****************************************************************/

data assay;
   label dose = 'Dose of quinoline (microg/plate)'
         num  = 'Observed number of colonies';
   input dose @;
   logd = log(dose+10);
   do i=1 to 3; input num@; output; end;
   datalines;
   0  15 21 29
  10  16 18 21
  33  16 26 33
 100  27 41 60
 333  33 38 41
1000  20 27 42
;

proc fmm data=assay;
   model num = dose logd / dist=Poisson;
run;

proc fmm data=assay;
   model num = dose logd / dist=Poisson k=2
                           equate=effects(dose logd);
run;

proc fmm data=assay;
   model num = dose logd / dist=Poisson k=2;
   restrict 'common dose' dose 1, dose -1;
   restrict 'common logd' logd 1, logd -1;
run;

proc fmm data=assay(where=(num ne 60));
   model num = dose logd / dist=Poisson k=2
                           equate=effects(dose logd);
run;

proc fmm data=assay(where=(num ne 60));
   model num = dose logd / dist=Poisson;
run;
