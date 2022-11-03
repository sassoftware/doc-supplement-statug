 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: betafit                                             */
 /*   TITLE: Fitting the Parameters of a Simple Beta Distribution*/
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: All                                                 */
 /*    KEYS: nonlinear models,                                   */
 /*   PROCS: NLIN MEANS (NLMIXED, GLIMMIX)                       */
 /*    DATA:                                                     */
 /*                                                              */
 /*     REF: Charnes, Frome and Yu, J. Amer. Stat. Soc. V71,     */
 /*          p 169 (1976)                                        */
 /****************************************************************/


 /* Fitting the parameters of a beta distribution using */
 /* maximum likelihood                                  */

 /* Generate data from the Beta distribution */

data sim;
   do i=1 to 100;
      x = betaInv(ranuni(1),2,4);
      output;
   end;
run;

 /* Transform to log(x) and log(1-x)    */
data one; set sim;
   x1 = log(x);
   x2 = log(1-x);
run;

proc means data=one noprint;
   var x x1 x2;
   output out=one sum=x x1 x2 n=n var=v;
run;

data one; set one;
  /* Method of moments initial estimates*/
  /* of a and b.                        */
  /* mean(x) = a/(a+b), var(x) = ab/( (a+b)**2 (a+b+1) ) */
  /* hence (a+b) = mu(1-mu)/sigma**2 - 1                 */
  /*       b     = (1-mu)(a+b)                           */

  a_init = (x/n)*(1-x/n)/v-1;
  if (a_init < 0) then a_init=1;
  b_init = (1-x / n) * a_init;
  a_init = A_INIT - B_INIT;
  if (a_init < 1) then a_init = 1;
  if (b_init < 1) then b_inti = 1;

  /* Create two observations, one for log(x) and one for log(1-x) */
  type=0; x=x1; output;
  type=1; x=x2; output;
  keep x n type a_init b_init;
run;

title "Using NLIN to fit the parameters of the beta distribution";
 /* ------------------------------------------------------------
  *
  *   Equations are:
  *
  *       grad = 0 = du/dp sigma(-1) r
  *
  *         where u are the two means of log(x) and log(1-x)
  *         as functions of a and b, p is the parameter in question,
  *         sigma is the variance covariance matrix of
  *         (log(x), log(1-x) ) and r is the vector of residuals,
  *         ( log(x) - predicted mean, log(1-x) - predicted mean .
  *
  *       hessian = H = du/dp sigma(-1) du/dp.
  *
  *   These equations are realized in the NLIN situation by
  *   factor sigma = L*L` and using
  *     L(-1) * r
  *     L(-1) * (du/dp)
  *   as two independent observations. The effect is to
  *   reproduce the gradient and hessian equation exactly.
  *   Note that the data have been concentrated first.
  *     Sum ( log(x) ) and Sum( log(1-x) ) are sufficient
  *     statistics for this problems.
  *   Note that the resulting variance covariance matrix is
  *     the usual maximum likelihood estimate and that for this
  *     model the expected and observed information matrices are
  *     identical. The actual residual sum of squares is zero in
  *     this implementation, as are the residual degrees of freedom.
  * --------------------------------------------------------------- */

proc nlin sigsq=1; /* to generate the ML standard errors */
    parms a=4  b=4;
    retain z ta tb tab wab waa wbb lab laa lbb ua ub;

     /* 2 by 2 Cholesky root of the variance matrix */
    if _ITER_ = 0 and _OBS_=1 then do;
       a = a_init;
       b = b_init;
    end;
    if _OBS_=1 then do;
       /* need the trigamma function, a numerical derivative of */
       /* the digamma function will suffice.                    */

                     /* Variance matrix     */
       waa = n*(trigamma(A)-trigamma(a+b));
       wab = n*(           -trigamma(a+b));
       wbb = n*(trigamma(B)-trigamma(a+b));

       laa = sqrt(waa);                       /* Cholesky root         */
       lab = wab/laa;
       lbb = sqrt(wbb-lab*lab);

       ua = n*(digamma(a)-digamma(a+b));    /* expect of log(x)      */
       ub = n*(digamma(b)-digamma(a+b));    /* expect of log(1-x)    */
    end;

    if type=0 then do;   /* poor mans Cholesky root application */
       da = waa/laa;     /* derivatives of residuals            */
       db = wab/laa;
       s  = (x-ua)/laa;  /* residual: log(x)-expected value of log x */
       z  = s;           /* save for other log(1-x)                  */
       l  = a*x-n*(lgamma(a)+lgamma(b)-lgamma(a+b));
    end;
    else if type=1 then do;         /* FOR LOG(1-X) COMPONENT */
       da = (wab-lab*waa/laa)/lbb;
       db = (wbb-lab*wab/laa)/lbb;
       s  = ((x-ub)-lab*z/laa)/lbb;
       l  = b*x;
    end;

    /* NLIN fit */

    MODEL s = 0;              /* S already set to be residual */
    _LOSS_  = -L;             /* Likelihood function for loss */
    DER.A   = da;             /* DER with resp. to a and b    */
    DER.B   = db;
run;


 /*-------------------------------------------------------*/
 /*---Using PROC NLMIXED to obtain MLE of beta dist.   ---*/
 /*---The log-likelihood function is computed directly ---*/
 /*---with SAS programming statements.                 ---*/
proc nlmixed data=sim;
   parms a=1 b=1;
   bounds a > 0, b > 0;
   ll = lgamma(a+b) - lgamma(a) - lgamma(b) +
        (a-1)*log(x) + (b-1)*log(1-x);
   model x ~ general(ll);
   ods select ParameterEstimates;
run;
 /*-------------------------------------------------------*/


 /*-------------------------------------------------------*/
 /*---Using PROC GLIMMIX to obtain MLE of beta dist.   ---*/
 /*---The parameterization of the beta distribution in ---*/
 /*---the GLIMMIX procedure relates to the parameteri- ---*/
 /*---zation used in the previous code as follows:     ---*/
 /*---                                                 ---*/
 /*---log(mu/(1-mu)) = Intercept = log(a/b)            ---*/
 /*---                 Scale     = a + b               ---*/
title 'Using PROC GLIMMIX to fit parameters of a beta distribution';
proc glimmix data=sim;
   model x = / dist=beta s;
   ods select ModelInfo ParameterEstimates;
run;
 /*-------------------------------------------------------*/
