/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICALEX2                                             */
/*   TITLE: Documentation Example 3 for Introduction to SEM     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: measurement error model, spleen data                */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Introduction to SEM, Example 3                      */
/*    MISC:                                                     */
/****************************************************************/

data spleen;
   input rosette nucleate;
   sqrtrose=sqrt(rosette);
   sqrtnucl=sqrt(nucleate);
   datalines;
4 62
5 87
5 117
6 142
8 212
9 120
12 254
13 179
15 125
19 182
28 301
51 357
;

proc calis data=spleen;
   lineqs factrose = beta * factnucl + disturb,
          sqrtrose =        factrose + err_rose,
          sqrtnucl =        factnucl + err_nucl;
   variance
          factnucl = v_factnucl,
          disturb  = v_disturb,
          err_rose = v_rose,
          err_nucl = v_nucl;
run;

proc calis data=spleen residual;
   lineqs factrose = beta * factnucl + disturb,
          sqrtrose =        factrose + err_rose,
          sqrtnucl =        factnucl + err_nucl;
   variance
          factnucl = v_factnucl,
          disturb  = v_disturb,
          err_rose = 0.25,
          err_nucl = 0.25;
run;

proc calis data=spleen residual;
   lineqs factrose = beta * factnucl + disturb,
          sqrtrose =        factrose + err_rose,
          sqrtnucl =        factnucl + err_nucl;
   variance
          factnucl = v_factnucl,
          disturb  = 0.,
          err_rose = 0.25,
          err_nucl = 0.25;
run;

proc calis data=spleen;
   path
      sqrtrose <=== factrose   = 1.0,
      sqrtnucl <=== factnucl   = 1.0,
      factrose <=== factnucl   ;
   pvar
      sqrtrose = 0.25,      /* error variance for sqrtrose */
      sqrtnucl = 0.25,      /* error variance for sqrtnucl */
      factrose,             /* disturbance/error variance for factrose */
      factnucl;             /* variance of factnucl */
run;

proc calis data=spleen;
   path
      sqrtrose <=== factrose   = 1.0,
      sqrtnucl <=== factnucl   = 1.0,
      factrose <=== factnucl   = beta;
   pvar
      sqrtrose = 0.25,       /* error variance for sqrtrose */
      sqrtnucl = 0.25,       /* error variance for sqrtnucl */
      factrose = v_disturb,  /* disturbance/error variance for factrose */
      factnucl = v_factnucl; /* variance of factnucl */
run;

ods graphics on;

proc calis data=spleen plots=pathdiagram;
   path
      sqrtrose <=== factrose   = 1.0,
      sqrtnucl <=== factnucl   = 1.0,
      factrose <=== factnucl   ;
   pvar
      sqrtrose = 0.25,      /* error variance for sqrtrose */
      sqrtnucl = 0.25,      /* error variance for sqrtnucl */
      factrose,             /* disturbance/error variance for factrose */
      factnucl;             /* variance of factnucl */
run;

proc calis data=spleen;
   path
      sqrtrose <=== factrose   = 1.0,
      sqrtnucl <=== factnucl   = 1.0,
      factrose <=== factnucl   ;
   pvar
      sqrtrose = 0.25,      /* error variance for sqrtrose */
      sqrtnucl = 0.25,      /* error variance for sqrtnucl */
      factrose,             /* disturbance/error variance for factrose */
      factnucl;             /* variance of factnucl */
   pathdiagram nofittable title='No Fit Summary';
run;

proc calis data=spleen;
   path
      sqrtrose <=== factrose   = 1.0,
      sqrtnucl <=== factnucl   = 1.0,
      factrose <=== factnucl   = beta;
   pvar
      sqrtrose = 0.25,       /* error variance for sqrtrose */
      sqrtnucl = 0.25,       /* error variance for sqrtnucl */
      factrose = v_disturb,  /* disturbance/error variance for factrose */
      factnucl = v_factnucl; /* variance of factnucl */
   pathdiagram diagram=initial useerr;
run;
ods graphics off;

