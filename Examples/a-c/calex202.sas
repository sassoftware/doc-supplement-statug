/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX202                                            */
/*   TITLE: Documentation Example 8 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: PATH, measurement error models                      */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 8                               */
/*    MISC:                                                     */
/****************************************************************/

data measures;
   input x y @@;
   datalines;
 7.91736    13.8673    6.10807    11.7966    6.94139    12.2174
 7.61290    12.9761    6.77190    11.6356    6.33328    11.7732
 7.60608    12.8040    6.65642    12.8866    6.26643    11.9382
 7.32266    13.2590    5.76977    10.7654    5.62881    11.5041
 7.57418    13.2502    7.17305    13.3416    8.23123    13.9876
 7.17199    13.1750    8.04604    14.5968    5.77692    11.5077
 5.72741    11.3299    6.66033    12.5159    7.14944    12.4988
 7.51832    12.3588    5.48877    11.2211    7.50323    13.3735
 7.15814    13.1556    7.35485    13.8457    8.91648    14.4929
 5.37445     9.6366    6.00419    11.7654    6.89546    13.1493
;

proc calis data=measures;
   path
      x ===> y;
run;

proc reg data=measures;
   model y = x;
run;

proc calis data=measures meanstr;
   path
      x ===> y;
   pvar
      x y;
run;

proc calis data=measures;
   path
      x  <=== Fx   = 1.,
      Fx ===> y;
   pvar
      x  = 0.019,
      Fx, y;
run;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy   ,
      Fy ===> y   = 1.;
   pvar
      x  = 0.019,
      y  = 0.022,
      Fx Fy;
run;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy   ,
      Fy ===> y   = 1.;
   pvar
      x  = 0.,
      y  = 0.,
      Fx Fy;
run;
