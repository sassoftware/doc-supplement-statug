/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX12                                             */
/*   TITLE: Documentation Example 24 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: path analysis, career aspiration data               */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 24                              */
/*    MISC:                                                     */
/****************************************************************/

title 'Peer Influences on Aspiration: Haller & Butterworth (1960)';
data aspire(type=corr);
   _type_='corr';
   input _name_ $ riq rpa rses roa rea fiq fpa fses foa fea;
   label riq='Respondent: Intelligence'
         rpa='Respondent: Parental Aspiration'
         rses='Respondent: Family SES'
         roa='Respondent: Occupational Aspiration'
         rea='Respondent: Educational Aspiration'
         fiq='Friend: Intelligence'
         fpa='Friend: Parental Aspiration'
         fses='Friend: Family SES'
         foa='Friend: Occupational Aspiration'
         fea='Friend: Educational Aspiration';
   datalines;
riq   1.      .      .      .      .      .       .      .      .      .
rpa   .1839  1.      .      .      .      .       .      .      .      .
rses  .2220  .0489  1.      .      .      .       .      .      .      .
roa   .4105  .2137  .3240  1.      .      .       .      .      .      .
rea   .4043  .2742  .4047  .6247  1.      .       .      .      .      .
fiq   .3355  .0782  .2302  .2995  .2863  1.       .      .      .      .
fpa   .1021  .1147  .0931  .0760  .0702  .2087   1.      .      .      .
fses  .1861  .0186  .2707  .2930  .2407  .2950  -.0438  1.      .      .
foa   .2598  .0839  .2786  .4216  .3275  .5007   .1988  .3607  1.      .
fea   .2903  .1124  .3054  .3269  .3669  .5191   .2784  .4105  .6404  1.
;

proc calis data=aspire nobs=329;
   path
      /* measurement model for intelligence and environment */
      rpa     <===  f_rpa    = 0.837,
      riq     <===  f_riq    = 0.894,
      rses    <===  f_rses   = 0.949,
      fses    <===  f_fses   = 0.949,
      fiq     <===  f_fiq    = 0.894,
      fpa     <===  f_fpa    = 0.837,

      /* structural model of influences: 5 equality constraints */
      f_rpa   ===>  R_Amb ,
      f_riq   ===>  R_Amb ,
      f_rses  ===>  R_Amb ,
      f_fses  ===>  R_Amb ,
      f_rses  ===>  F_Amb ,
      f_fses  ===>  F_Amb ,
      f_fiq   ===>  F_Amb ,
      f_fpa   ===>  F_Amb ,
      F_Amb   ===>  R_Amb ,
      R_Amb   ===>  F_Amb ,

      /* measurement model for aspiration: 1 equality constraint */
      R_Amb   ===>  rea  ,
      R_Amb   ===>  roa      = 1.,
      F_Amb   ===>  foa      = 1.,
      F_Amb   ===>  fea  ;
   pvar
      f_rpa f_riq f_rses f_fpa f_fiq f_fses = 6 * 1.0;
   pcov
      R_Amb F_Amb            ,
      rea  fea               ,
      roa  foa               ;
run;

proc calis data=aspire nobs=329 outmodel=model2;
   path
      /* measurement model for intelligence and environment */
      rpa     <===  f_rpa    = 0.837,
      riq     <===  f_riq    = 0.894,
      rses    <===  f_rses   = 0.949,
      fses    <===  f_fses   = 0.949,
      fiq     <===  f_fiq    = 0.894,
      fpa     <===  f_fpa    = 0.837,

      /* structural model of influences: 5 equality constraints */
      f_rpa   ===>  R_Amb    = gam1,
      f_riq   ===>  R_Amb    = gam2,
      f_rses  ===>  R_Amb    = gam3,
      f_fses  ===>  R_Amb    = gam4,
      f_rses  ===>  F_Amb    = gam4,
      f_fses  ===>  F_Amb    = gam3,
      f_fiq   ===>  F_Amb    = gam2,
      f_fpa   ===>  F_Amb    = gam1,
      F_Amb   ===>  R_Amb    = beta,
      R_Amb   ===>  F_Amb    = beta,

      /* measurement model for aspiration: 1 equality constraint */
      R_Amb   ===>  rea      = lambda,
      R_Amb   ===>  roa      = 1.,
      F_Amb   ===>  foa      = 1.,
      F_Amb   ===>  fea      = lambda;
   pvar
      f_rpa f_riq f_rses f_fpa f_fiq f_fses = 6 * 1.0,
      R_Amb F_Amb             = 2 * psi,        /* 1 ec */
      rea fea                 = 2 * theta1,     /* 1 ec */
      roa foa                 = 2 * theta2;     /* 1 ec */
   pcov
      R_Amb F_Amb             = psi12,
      rea  fea                = covea,
      roa  foa                = covoa,
      f_rpa f_riq f_rses      = cov1-cov3,       /* 3 ec */
      f_fpa f_fiq f_fses      = cov1-cov3,
      f_rpa f_riq f_rses * f_fpa f_fiq f_fses =  /* 3 ec */
          cov4 cov5 cov6  cov5 cov7 cov8  cov6 cov8 cov9;
run;

data model3(type=calismdl);
   set model2;
   if _name_='gam4' then
      do;
         _name_=' ';
         _estim_=0;
      end;
run;

proc calis data=aspire nobs=329 inmodel=model3;
run;

data model4(type=calismdl);
   set model2;
   if _name_='beta' then
      do;
         _name_=' ';
         _estim_=0;
      end;
run;

proc calis data=aspire nobs=329 inmodel=model4;
run;

data model5(type=calismdl);
   set model2;
   if _name_='psi12' then
      do;
         _name_=' ';
         _estim_=0;
      end;
run;

proc calis data=aspire nobs=329 inmodel=model5;
run;

data model7(type=calismdl);
   set model2;
   if _name_='psi12'|_name_='beta' then
      do;
         _name_=' ';
         _estim_=0;
      end;
run;

proc calis data=aspire nobs=329 inmodel=model7;
run;

data model6(type=calismdl);
   set model2;
   if _name_='covea'|_name_='covoa' then
      do;
         _name_=' ';
         _estim_=0;
      end;
run;

proc calis data=aspire nobs=329 inmodel=model6;
run;

data _null_;
   array achisq[7] _temporary_
      (12.0132 19.0697 23.0365 20.9981 19.0745 33.4475 25.3466);
   array adf[7] _temporary_
      (13 28 29 29 29 30 30);
   retain indent 16;
   file print;
   input ho ha @@;
   chisq = achisq[ho] - achisq[ha];
   df = adf[ho] - adf[ha];
   p = 1 - probchi( chisq, df);
   if _n_ = 1 then put
      / +indent 'model comparison   chi**2   df  p-value'
      / +indent '---------------------------------------';
   put +indent +3 ho ' versus ' ha @18 +indent chisq 8.4 df 5. p 9.4;
   datalines;
2 1    3 2    4 2    5 2    7 2    7 4    7 5    6 2
;

