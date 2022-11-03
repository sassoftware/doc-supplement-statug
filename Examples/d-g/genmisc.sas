 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: GENMISC                                             */
 /*   TITLE: Miscellaneous Examples, GENMOD Procedure            */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: generalized linear models,                          */
 /*   PROCS: GENMOD                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /****************************************************************/


 /*****************************************************************
 | Negative binomial regression.                                  |
 | Code models count data using SAS/STAT GENMOD Procedure.        |
 | 0 responses are accommodated. The example data set is a subset |
 | of a study on predictors for seizures performed by the author. |
 | Number of seizures is the response while the log of the        |
 | population sharing a similar pattern of covariates is used as  |
 | an offset. Indicator predictors are psy=psychological problems;|
 | cvd = cardio-vascular disease; tum = tumor. A model using      |
 | standard Poisson regression proves to be highly overdispersed. |
 | The data may be satisfactorily modeled using a quadratic       |
 | specification (GLM) of the log-linked negative binomial with a |
 | variance adjustment parameter, k, of .14. The user provides a  |
 | value to k which results in the DEV/DF approximating 1.0. Also |
 | check the CHI2/DF - if the value is within 0.8 to 1.2, the     |
 | model is correctly specified. Code for the canonical link and  |
 | inverse link is provided; however, the canonical form does not |
 | converge with this data.                                       |
 *****************************************************************/

data seize;
   input seiz pop psy cvd tum;
   lpop=log(pop);
   datalines;
  0      8   1   0   0
  0     15   0   0   0
  0      5   1   0   0
  3     90   1   0   0
  3     89   0   1   0
651  24795   1   0   0
  2     37   0   0   0
  7    234   0   0   0
  0     14   0   0   0
  0      6   0   1   0
 10    659   0   0   0
  3     64   0   1   0
  4    184   0   0   0
  0      9   0   1   0
  3     62   1   1   0
  0      6   1   0   0
  0     15   0   0   0
  0      7   1   0   0
  0     10   0   1   0
 35    589   1   0   0
  0     84   0   0   0
  1     35   0   0   0
  4    346   0   0   0
  0     11   0   0   0
765 199087   0   0   0
  0      6   0   0   0
  9    141   0   1   0
  2     38   0   0   0
  2    133   0   0   0
  1      7   1   0   0
  0      7   0   0   0
  2     19   1   0   0
  0      7   1   0   0
  0      5   0   0   0
  0      7   1   1   0
  3    261   0   0   0
  5    144   1   0   0
  2    334   0   0   0
  0    12    0   0   0
  9   205    0   1   0
 63  2152    0   0   0
  4   353    0   0   0
  2    10    0   0   1
  0    11    0   0   0
  0    10    0   1   0
  0   206    0   0   0
 31  2957    0   0   0
  2     8    0   0   1
  0     6    0   1   0
  0    15    1   0   0
  1    98    0   0   0
  0     5    1   0   0
  9    78    0   1   0
  1    25    0   1   0
  0     6    0   1   0
  6   256    0   0   0
;

 /* Data is first modeled using Poisson regression */
proc genmod data=seize;
   model seiz = psy cvd tum / dist   = poisson
                              offset = lpop;
run;

 /*  Data is now modeled using a
     log-linked negative binomial, k=.14  */

proc genmod data=seize;
   k = .14;                  /* adjusted by user */
   a = _MEAN_;
   y = _RESP_;

   /* canonical link:  fwdlink link = log(a/(a+k)); */
   /* canonical ilink: invlink ilink = k/(exp(-_XBETA_)-1); */
   variance var = a+k*a*a;
   if (y>0) then d = 2 * (y*log(y/a)-(1+k*y)/k *
                                 log((1+k*y)/(1+k*a)));
   else if (y=0) then d = 2 * log(1+k*a)/k; /* allows 0 response */
   deviance dev = d;
   model seiz= psy cvd tum  / offset = lpop noscale link = log;
run;

/**************************************************************/
   *---------------Poisson Polynomial Regression-------*
   *---------------------------------------------------*;
/**************************************************************/
data poi;
   label c='Response';
   keep c x;
   phi = 5;
   seedg = 94571;
   seedp = 7366;
   do i = 1500 to 2500 by 100;
      x = (i-2000)/1000;
      poly =  - (2.5 * x) - (6 * x * x) + (40 * x * x * x);
      mu1 = exp( poly ) * 100;
      alpha = 1/phi;
      beta = mu1*phi;
      call rangam( seedg, beta, mu );
      mu = alpha * mu;
      call ranpoi( seedp, mu, c );
      output;
   end;
run;

proc genmod data = poi;
   model c = x x*x x*x*x x*x*x*x / dist = poi
                                   link = log
                                   type1;
run;

proc genmod data = poi;
   ods output Obstats = pred;
   model c = x x*x x*x*x / dist = poi
                           link = log
                           obstats
                           pscale
                           type1;
run;

data new;
   set poi( keep = x );
   set pred ( keep = c pred reschi resdev );
run;


proc sgplot data=new;
   series  x=x y=pred;
   scatter x=x y=c;
   xaxis label = 'Explanatory Variable X';
   yaxis label = 'Response';
run;

proc sgplot data=new;
   scatter x=x y=reschi;
   xaxis label = 'Explanatory Variable X';
   yaxis label = 'Pearson Residual';
run;

proc sgplot data=new;
   scatter x=x y=resdev;
   xaxis label = 'Explanatory Variable X';
   yaxis label = 'Deviance Residual';
run;

   /*---------------Component Reliability Example------------*/
   /*--------------------------------------------------------*/

data equip;
   input Year Month $ usehr rem @@;
   if usehr > 0 then lusehr = log(usehr);
   else lusehr=.;
   datalines;
1983  Jan    0 0   1983  Feb   10 0   1983  Mar   26 0
1983  Apr  192 0   1983  May  238 0   1983  Jun  374 1
1983  Jul  356 0   1983  Aug  358 4   1983  Sep  594 0
1983  Oct  786 1   1983  Nov  885 2   1983  Dec  981 2
1984  Jan 1044 0   1984  Feb 1266 1   1984  Mar 1533 1
1984  Apr 1510 2   1984  May 1818 2   1984  Jun 2210 7
1984  Jul 2003 2   1984  Aug 2489 4   1984  Sep 2841 2
1984  Oct 3236 3   1984  Nov 3104 5   1984  Dec 2919 3
1985  Jan 2849 3   1985  Feb 3119 2   1985  Mar 3596 7
1985  Apr 4003 5   1985  May 4067 5   1985  Jun 3690 2
1985  Jul 3509 2   1985  Aug 3653 9   1985  Sep 4186 3
1985  Oct 4562 2   1985  Nov 4277 2   1985  Dec 3838 2
1986  Jan 4253 3   1986  Feb 4242 5   1986  Mar 5119 5
1986  Apr 5281 7   1986  May 5163 4   1986  Jun 4977 2
1986  Jul 4663 4   1986  Aug 5465 4   1986  Sep 5314 5
1986  Oct 5485 4   1986  Nov 5688 6   1986  Dec 5403 0
1987  Jan 5749 2   1987  Feb 5682 4   1987  Mar 6460 3
1987  Apr 6681 3   1987  May 7215 3   1987  Jun 6650 8
1987  Jul 7094 2   1987  Aug 6600 6   1987  Sep 7649 3
1987  Oct 7615 9   1987  Nov 6733 4   1987  Dec 6540 10
1988  Jan 6680 4   1988  Feb 7646 6   1988  Mar 8139 4
1988  Apr 7829 4   1988  May 8220 3   1988  Jun 7671 5
1988  Jul 7120 3   1988  Aug 7293 4   1988  Sep 8045 5
1988  Oct 8567 3   1988  Nov 7682 6   1988  Dec 7048 3
1989  Jan 7369 2   1989  Feb 7270 6   1989  Mar 8124 1
1989  Apr 7636 5   1989  May 7512 5   1989  Jun 7049 4
1989  Jul 7286 2   1989  Aug 7624 2   1989  Sep 7623 2
1989  Oct 7970 5   1989  Nov 7569 1   1989  Dec 7156 10
1990  Jan 7404 3   1990  Feb 7447 8   1990  Mar 7951 12
1990  Apr 8065 7   1990  May 7742 3   1990  Jun 7109 2
1990  Jul 7229 4   1990  Aug 7279 3   1990  Sep 7366 0
1990  Oct 7955 6   1990  Nov 7044 6   1990  Dec 3929 3
;

proc genmod data = equip order=data;
   class month year;
   model rem = month year / dist=poisson
                            link=log
                            offset = lusehr
                            type1
                            type3;
run;

proc genmod data = equip order=data;
   class month year;
   model rem = month year / dist=poisson
                            link=log
                            offset = lusehr
                            type1
                            type3
                            dscale;
run;


proc genmod data = equip order=data;
   class month year;
   ods output  Obstats = outdata;
   model rem =  year / dist=poisson
                       link=log
                       offset = lusehr
                       type1
                       type3
                       obstats;
run;

data rates;
   set outdata;
   if month = 'dec';
   rate = exp(xbeta);
run;

proc print;
   var year rate;
run;

proc genmod data = equip order=data;
   class month year;
   model rem = year / dist=poisson
                      link=log
                      offset = lusehr;
   contrast 'Year86-90' year 0 0 0 1 -1,
                        year 0 0 0 1 0 -1,
                        year 0 0 0 1 0 0 -1,
                        year 0 0 0 1 0 0 0 -1;
run;


   /*---------------Modeling Variance Heterogeneity----------*/
   /* Aitkin, M. (1987), Modelling Variance Heterogeneity in */
   /* Normal Regression Using GLIM, Appl. Statist. 36, No. 3,*/
   /* pp 332-339                                             */
   /*--------------------------------------------------------*/

data semi;
   drop j;
   do p = 'a','b';
      do x = 10 to 15;
         if p = 'a' then do;
            do j = 1 to 2;
               y = x + 2*rannor(1302);
               output;
            end;
         end;
         else if p = 'b' then do;
            do j = 1 to 2;
            y = 3*x + 5*rannor(4567);
            output;
            end;
         end;
      end;
   end;
run;

%macro semimod;

   ods listing close;
   ods output;

   data work;
      * input data set;
      set semi;
      wgt = 1;
      sum = 0;
   run;

   data tmp;
      sum = 0;
   run;

   %let conv = 0;
   %let iter = 0;
   * iterate until convergence;
   %do %while( &conv = 0 );

      data _old;
         set tmp;
         devold = sum;
         keep devold;
      run;

      * mean model;
      * set NOSCALE so that scale is not estimated;
      * select OBSTATS to get residuals;
      * SCWGT selects dispersion parameter weights;
      proc genmod data=work;
         class p;
         scwgt wgt;
         ods output Obstats = A;
         ods output ParameterEstimates = meanests;
         model y = p x p*x / noscale
                             obstats;
      run;

      * this data set contains squared residuals;
      data work;
         drop sum pred xbeta std hesswgt upper lower
              resraw reschi resdev;
         set A;
         set work;
         rsquare = resraw*resraw;
      run;

      * variance model;
      * set scoring=100 to get Fisher scores;
      * set scale = .5 for 1 dof in gamma distribution;
      proc genmod data=work;
         class p;
         ods output  Obstats = C;
         ods output  ParameterEstimates = varests;
         model rsquare = p x p*x / dist=gamma
                                   link=log
                                   obstats
                                   scoring=100
                                   noscale
                                   scale=.5;
      run;

      * get weights for 1st model;
      * compute sum = overall deviance;
      data work;
         drop xbeta std hesswgt upper lower resraw reschi resdev;
         set work;
         set C;
         wgt = 1./pred;
         sum + (rsquare/pred + log(pred) + log(6.283185));
      run;

      data tmp;
         set work nobs = last;
         keep sum;
         if( _n_ = last );
      run;

      %let iter=%eval( &iter+1 );
      %put &iter;

      * check convergence;
      data _NULL_;
         set tmp;
         set _old;
         put sum devold;
         if( abs(sum - devold) <= 1.e-3 ) then conv = 1;
         else conv = 0;
         call symput( 'dev', left(put(sum,12.4)) );
         call symput( 'conv', left(put(conv,3.)) );
      run;

   %end;

   title 'Mean Model';
   ods listing;
   proc print data=meanests;
   run;

   title 'Variance Model';
   proc print data=varests;
   run;

   title;
   %put Number of Iterations: &iter;
   %put Overall Deviance: &dev;
%mend semimod;

%semimod;
