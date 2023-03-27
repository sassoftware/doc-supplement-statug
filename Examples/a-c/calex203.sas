/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX203                                            */
/*   TITLE: Documentation Example 9 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: PATH, testing measurement models                    */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 9                               */
/*    MISC:                                                     */
/****************************************************************/

data measures;
   input x y;
   datalines;
 7.91736    13.8673
 7.61290    12.9761
 7.60608    12.8040
 7.32266    13.2590
 7.57418    13.2502
 7.17199    13.1750
 5.72741    11.3299
 7.51832    12.3588
 7.15814    13.1556
 5.37445     9.6366
 6.10807    11.7966
 6.77190    11.6356
 6.65642    12.8866
 5.76977    10.7654
 7.17305    13.3416
 8.04604    14.5968
 6.66033    12.5159
 5.48877    11.2211
 7.35485    13.8457
 6.00419    11.7654
 6.94139    12.2174
 6.33328    11.7732
 6.26643    11.9382
 5.62881    11.5041
 8.23123    13.9876
 5.77692    11.5077
 7.14944    12.4988
 7.50323    13.3735
 8.91648    14.4929
 6.89546    13.1493
;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy   ,
      Fy ===> y   = 1.;
   pvar
      x  = evar,
      y  = evar,
      Fy = 0.,
      Fx;
run;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy  = 1.,  /* Testing a fixed constant effect */
      Fy ===> y   = 1.;
   pvar
      x  = evar,
      y  = evar,
      Fy = 0.,
      Fx;
run;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy  ,       /* regression effect is freely estimated */
      Fy ===> y   = 1.;
   pvar
      x  = evar,
      y  = evar,
      Fy = 0.,
      Fx;
   mean
      x y = 0. 0., /* Intercepts are zero in the measurement error model */
      Fy  = 0.,    /* Fixed to zero under the hypothesis */
      Fx;          /* Mean of Fx is freely estimated */
run;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy  ,
      Fy ===> y   = 1.;
   pvar
      x  = evar,
      y  = evar,
      Fy = 0.,
      Fx;
   mean
      x y = 0. 0.,
      Fy Fx;
run;

