/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICALEX4                                             */
/*   TITLE: Documentation Example 5 for Introduction to SEM     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: measurement and structural models, aspire data      */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Introduction to SEM, Example 5                      */
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
      /* structural model of influences */
      R_Amb <=== rpa     ,
      R_Amb <=== riq     ,
      R_Amb <=== rses    ,
      R_Amb <=== fses    ,
      F_Amb <=== rses    ,
      F_Amb <=== fses    ,
      F_Amb <=== fiq     ,
      F_Amb <=== fpa     ,
      R_Amb <=== F_Amb   ,
      F_Amb <=== R_Amb   ,

      /* measurement model for aspiration */
      rea <===  R_Amb      ,
      roa <===  R_Amb  = 1.,
      foa <===  F_Amb  = 1.,
      fea <===  F_Amb    ;
   pcov
      R_Amb  F_Amb;
run;

proc calis data=aspire nobs=329;
   path
      /* structural model of influences */
      rpa    ===>  R_Amb   =  gam1,
      riq    ===>  R_Amb   =  gam2,
      rses   ===>  R_Amb   =  gam3,
      fses   ===>  R_Amb   =  gam4,
      rses   ===>  F_Amb   =  gam5,
      fses   ===>  F_Amb   =  gam6,
      fiq    ===>  F_Amb   =  gam7,
      fpa    ===>  F_Amb   =  gam8,
      F_Amb  ===>  R_Amb   = beta1,
      R_Amb  ===>  F_Amb   = beta2,

      /* measurement model for aspiration */
      R_Amb  ===>  rea     = lambda2,
      R_Amb  ===>  roa     = 1.,
      F_Amb  ===>  foa     = 1.,
      F_Amb  ===>  fea     = lambda3;
   pvar
      R_Amb = psi11,
      F_Amb = psi22,
      rpa riq rses fpa fiq fses = v1-v6,
      rea roa fea foa = theta1-theta4;
   pcov
      R_Amb F_Amb = psi12,
      rpa riq rses fpa fiq fses = cov01-cov15;
run;

proc calis data=aspire nobs=329;
   path
      /* structural model of influences */
      rpa    ===> R_Amb         ,
      riq    ===> R_Amb         ,
      rses   ===> R_Amb         ,
      fses   ===> R_Amb         ,
      rses   ===> F_Amb         ,
      fses   ===> F_Amb         ,
      fiq    ===> F_Amb         ,
      fpa    ===> F_Amb         ,
      F_Amb  ===> R_Amb   = beta,
      R_Amb  ===> F_Amb   = beta,

      /* measurement model for aspiration */
      R_Amb  ===> rea         ,
      R_Amb  ===> roa     = 1.,
      F_Amb  ===> foa     = 1.,
      F_Amb  ===> fea     ;
run;

proc calis data=aspire nobs=329;
   path
      /* measurement model for intelligence and environment */
      rpa     <===  f_rpa    = 0.837,
      riq     <===  f_riq    = 0.894,
      rses    <===  f_rses   = 0.949,
      fses    <===  f_fses   = 0.949,
      fiq     <===  f_fiq    = 0.894,
      fpa     <===  f_fpa    = 0.837,

      /* structural model of influences */
      f_rpa   ===>  R_Amb,
      f_riq   ===>  R_Amb,
      f_rses  ===>  R_Amb,
      f_fses  ===>  R_Amb,
      f_rses  ===>  F_Amb,
      f_fses  ===>  F_Amb,
      f_fiq   ===>  F_Amb,
      f_fpa   ===>  F_Amb,
      F_Amb   ===>  R_Amb,
      R_Amb   ===>  F_Amb,

      /* measurement model for aspiration */
      R_Amb   ===>  rea        ,
      R_Amb   ===>  roa    = 1.,
      F_Amb   ===>  foa    = 1.,
      F_Amb   ===>  fea    ;
   pvar
      f_rpa f_riq f_rses f_fses f_fiq f_fpa = 6 * 1.0;
   pcov
      R_Amb F_Amb  ,
      rea  fea     ,
      roa  foa     ;
run;

proc calis data=aspire nobs=329;
   lismod
      xi   = f_rpa f_riq f_rses f_fses f_fiq f_fpa,
      eta  = R_Amb F_Amb,
      xvar = rpa riq rses fses fiq fpa,
      yvar = rea roa foa fea;

   /* measurement model for aspiration */
   matrix _lambday_ [1,1], [2,1] = 1.0, [3,2] = 1.0, [4,2];
   matrix _thetay_  [4,1], [3,2];

   /* measurement model for intelligence and environment */
   matrix _lambdax_ [1,1] = 0.837 0.894 0.949 0.949 0.894 0.837;

   /* structural model of influences */
   matrix _beta_ [2,1],[1,2];
   matrix _gamma_ [1,1 to 4], [2,3 to 6];

   /* Covariances among Eta-variables */
   matrix _psi_ [2,1];

   /* Fixed variances for Xi-variables */
   matrix _phi_ [1,1] = 6 * 1.0;
run;

