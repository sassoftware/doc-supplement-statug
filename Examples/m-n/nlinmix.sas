 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: NLINMIX                                             */
 /*   TITLE: Macro for Fitting Nonlinear Mixed Models            */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: MIXED NONLINEAR MODELS,                             */
 /*   PROCS: MIXED, MACRO, NLIN                                  */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/
 /*-----------------------------------------------------------
 TITLE
 -----
 NLINMIX: a SAS macro for fitting nonlinear mixed models
 using PROC NLIN and PROC MIXED. Requires SAS/STAT Version 8.

 SUPPORT
 -------
 Russ Wolfinger (russ.wolfinger@sas.com)
 Please send email with any suggestions or corrections.

 HISTORY
 -------
 initial coding                                  01Jun92 rdw
 revision                                        21Oct92 rdw
 removed PROC NLIN from iterations and revised   08Mar94 rdw
 changed syntax to include random effects
    explicitly, added numerical derivatives and
    optional Gauss-Newton steps                  19Dec94 rdw
 added rtype=                                    09Feb95 rdw
 changed tech= to expand=                        13Feb95 rdw
 suggestions from Ken Goldberg, Wyeth-Ayerst     29May96 rdw
 added random2                                   07Jan98 rdw
 more suggestions from Ken Goldberg: covparms
    only used in iter 0 unless noprev, added
    covpopt=,nlinopt=,nlinstmt=,outdata=,
    nestrsub                                     16Nov98 rdw
 fixed problem from Ken Goldberg with random2,
    eblup, and unequal subject2 block sizes      16Apr99 rdw

 DESCRIPTION
 -----------
 Available estimation methods are as follows, all of which
 are implemented via iterative calls to PROC MIXED using
 appropriately constructed pseudo data:

    1. Expanding the nonlinear function about random effects
    parameters set equal to zero, which is similar to Sheiner
    and Beal's first-order method (NONMEM User's Guide,
    University of California, San Francisco).  This method is
    the default for random effects specifications, and uses
    the RANDOM statement in PROC MIXED.

    2. Expanding the nonlinear function about random effects
    parameters set equal to their current empirical best
    linear unbiased predictor (EBLUP), which is Lindstrom and
    Bates' approximate second-order method (Lindstrom and
    Bates, 1990, Biometrics 46, 673-687).
       The method is implemented using an initial call to
    PROC NLIN and then iterative calls to PROC MIXED.  This
    differs from Lindstrom and Bates' implementation, in
    which pseudo data is constructed and iterative calls are
    made alternately to PROC MIXED and PROC NLIN.  This
    macro's implementation requires much less time and space
    for larger problems, and it works because solving the
    mixed-model equations in PROC MIXED is equivalent to
    taking the first Gauss-Newton step in PROC NLIN
    (Wolfinger, 1993, Biometrika 80, 791-795).  Use
    EXPAND=EBLUP to implement this method, which uses
    the RANDOM statement in PROC MIXED.

    3. Iteratively fitting a covariance structure outside of
    the nonlinear function.  This is a second-order
    generalized estimating equation approach (Prentice and
    Zhao, 1991, Biometrics 47, 825-839).  Use RTYPE= or
    ROPT= to implement this method, which uses the REPEATED
    statement in PROC MIXED.


 SYNTAX
 ------
 %nlinmix(
    data=,
    response=,
    subject=,
    model=,
    modinit=,
    derivs=,
    tol=,
    parms=,
    covparms=,
    covpopt=,
    random=,
    ranopt=,
    type=,
    random2=,
    ranopt2=,
    subject2=,
    type2=,
    rtype=,
    reffect=,
    rsub=,
    ropt=,
    weight=,
    add=,
    method=,
    expand=,
    converge=,
    subconv=,
    maxit=,
    maxsubit=,
    switch=,
    gauss=,
    fraction=,
    procopt=,
    modopt=,
    nlinopt=,
    nlinstmt=,
    class=,
    outdata=,
    options=
 )

 where

  data     specifies the analysis data set; default=last
           created; it must be sorted by subject (and
           subject2 if it is specified)

  response specifies the response variable, default=y

  subject  specifies the subject variable to be used in
           association with the random effects, default=subject
           this can only be a single variable - no nested or
           crossed effects allowed here; the data must be
           sorted by subject (and subject2 if it is specified)

  model    specifies the nonlinear mixed model in terms of
           parameters of your choice; the fixed-effects
           parameters are listed in the PARMS= argument
           and the random-effects in the RANDOM= argument;
           the final value of the model should be assigned to
           a variable named PRED, which is the predicted
           value for that observation; you may use multiple
           statements and auxiliary variables; the names of
           fixed and random effects parameters should be
           unique and should not exceed 6 characters in
           length; you should enclose the entire
           specification with the %str() macro (see example
           syntax below)

  modinit  specifies modeling statements to be called only
           once at the beginning of the modeling step; this
           option is usually used in conjunction with
           initializing recursively defined models which
           are to be differentiated numerically; this code
           should have no references to the fixed- or random-
           effects parameters

  derivs   specifies the derivatives of the predicted value
           in the preceding model specification with respect
           to the fixed- and random-effects parameters; the
           derivatives are specified using the same parameter
           names but with d_ appended beforehand; you
           may use multiple statements, auxiliary variables,
           and variables defined in the model specification,
           and you should enclose the entire specification
           with the %str() macro (see example syntax below);
           if you do not specify this argument, derivatives
           are computed numerically using central differences
           with width tol*(1+abs(parm)), where tol is from
           the TOL= argument

  tol      specifies the tolerance for numerical derivatives;
           default=1e-5, and the width is computed as
           tol*(1+abs(parm)), where parm is the parameter
           being differentiated

  parms    specifies the starting values of the fixed-effects
           parameters in the form %str(b1=value b2=value ...
           bN=value); when not using the SKIPNLIN option,
           the form can be %str(b1=values b2=values ...
           bN=values), where the form of the values is
           defined in the documentation of PROC NLIN's
           PARAMETER statement; the fixed-effect parameters
           are prefixed with "D_" in the PROC MIXED
           generated output; you should scale the parameters
           so that they are all are around the same order
           of magnitude to avoid instabilities in the
           algorithm

  covparms specifies the starting values of the covariance
           parameters for each PROC MIXED call; the argument
           must be in the form of a PROC MIXED PARMS
           statement, omitting the PARMS keyword and the
           final semicolon

  covpopt  specifies options for the PARMS statement in PROC MIXED;
           covparms is not required;  allows things like
           HOLD=, LOWERB=, etc.

  random   specifies variables in the model specification
           to be considered random effects; they are assumed
           to have zero mean and variance-covariance matrix
           to be estimated by the macro; the random effects
           are prefixed with "D_" in the PROC MIXED
           generated output;  the subject= argument defines
           when new realizations of the random effects are
           assumed to occur

  ranopt   specifies options to be included in PROC MIXED's
           RANDOM statement

  type     specifies the covariance structure for the
           variance matrix of the random effects, default=vc
           (variance components), and the most common
           alternative is type=un (unstructured), see the
           PROC MIXED documentation for other possible types

  random2  specifies a second set of random effects; they must have
           names different from the random= effects and their subject
           effect is specified with the subject2= argument; this option
           sets up a second RANDOM statement in the internal PROC MIXED
           specification

  ranopt2  specifies options to be included in PROC MIXED's
           second RANDOM statement

  type2    specifies the covariance structure for the second
           RANDOM statement

  subject2 specifies the subject effect for the random2= effects;
           By default, this effect is internally nested within the
           subject= variable; specify the CROSS2 option to make it
           crossed.  This can only be a single variable - no nested
           or crossed effects allowed here; neither this variable nor
           the main subject= effect should contain missing values in
           the input data set; also, the input data set must be
           sorted by subject and then subject2 within subject

  rtype    specifies the covariance structure for the
           variance matrix of the residual errors, the
           default is sigma^2 times the identity matrix;
           this is used to set up a REPEATED statement in
           the PROC MIXED calls; refer to the PROC MIXED
           documentation for possible types

  reffect  specifies the effect for the REPEATED statement,
           the default is no effect

  rsub     specifies the subject effect for the REPEATED
           statement, the default is the SUBJECT= variable

  ropt     specifies options for the REPEATED statement,
           refer to the PROC MIXED documentation for details

  weight   specifies the weight expression, which may use
           auxiliary variables defined in the model and
           derivs specifications

  add      specifies additional PROC MIXED statements to be
           included with each call; they are typically
           CONTRAST, ESTIMATE, LSMEANS, or MAKE statements,
           and you should end them with semicolons and
           enclose the entire argument with %str()

  method   specifies the PROC MIXED optimization method,
           default=REML

  expand   specifies the Taylor series expansion point,
           default=ZERO (Method 1 above), EBLUP specifies
           the current EBLUPs (Method 2 above)

  converge specifies the convergence criterion for the macro,
           default=1e-8

  subconv  specifies the convergence criterion for the Gauss-
           Newton iterations, default=1e-12

  maxit    specifies the maximum number of iterations for the
           macro to converge, default=20

  maxsubit specifies the maximum number of Gauss-Newton steps
           in a subiteration, default=10

  gauss    specifies the number of iterations for which to
           perform Gauss-Newton subiterations, default=0

  fraction specifies the multiplier by which to step-shorten
           when Gauss-Newton fails to improve the objective
           function, default=0.9

  procopt  specifies options for the PROC MIXED statement

  modopt   specifies options for the MODEL statement in each
           PROC MIXED call

  nlinopt  specifies options for the PROC NLIN statement

  nlinstmt specifies statements to be included in the PROC NLIN call

  class    specifies variables to be included in the CLASS
           statement in each PROC MIXED call

  outdata  specifies the name of the output working data set
           produced by NLINMIX; the default name is _NLINMIX

  options  specifies nlinmix macro options:

     cross2           leaves subject2 as distinct and hence is
                      crossed with subject.  By default,
                      subject2 is nested within subject.

     nestrsub         nests the effect specified by rsub
                      within subject and subject2

     noprev           does not use previous values as
                      starting values for the next
                      iteration

     noprint          suppresses all printing

     notes            requests printing of SAS notes, date, and page
                      numbers during macro execution.  By default,
                      the notes, date, and numbers are turned off
                      during macro execution and turned back on
                      after completion.

     printall         prints all PROC NLIN and MIXED
                      steps; the final PROC MIXED step
                      is printed by default

     printfirst       prints the first PROC NLIN and
                      MIXED runs

     skipnlin         skips the initial PROC NLIN call


 EXAMPLE SYNTAX
 --------------

 %nlinmix(data=tree,
    response=y,
    subject=tree,
    model=%str(
       num = b1+u1;
       e = exp(b3*x);
       den = 1 + b2*e;
       pred = num/den;
    ),
    derivs=%str(
       d_b1 = 1/den;
       d_b2 = -num/den/den*e;
       d_b3 = -num/den/den*b2*x*e;
       d_u1 = d_b1;
    ),
    parms=%str(b1=150 b2=10 b3=-.001)
    random=u1
 )


 DISCLAIMER
 -----------

 THIS INFORMATION IS PROVIDED BY SAS INSTITUTE INC. AS A
 SERVICE TO ITS USERS.  IT IS PROVIDED "AS IS".  THERE ARE NO
 WARRANTIES, EXPRESSED OR IMPLIED, AS TO MERCHANTABILITY OR
 FITNESS FOR A PARTICULAR PURPOSE REGARDING THE ACCURACY OF
 THE MATERIALS OR CODE CONTAINED HEREIN.

 -------------------------------------------------------------*/


 /*--------------------------------------------------------------*/
 /*                                                              */
 /*    %init                                                     */
 /*    Sets the initial values for the iterations.               */
 /*                                                              */
 /*--------------------------------------------------------------*/
%macro init;

 /*---determine number of parameters---*/
%let another = 1;
%let nb = 0;
%let pos = 1;
%let prevpos = 1;
%let _error = 0;
%let fixed = ;
%let d_fixed = ;
%let d_fixedn = ;
%do %while(&another = 1);
   %let effect = %scan(&parms,&pos,' ' =);
   %if %length(&effect) %then %do;
      %let fixed = &fixed &effect;
      %let d_fixed = &d_fixed D_&effect;
      %let d_fixedn = &d_fixedn der.&effect;
      %let nb = %eval(&nb + 1);
      %let pos = %eval(&pos + 2);
   %end;
   %else %let another = 0;
%end;

%let another = 1;
%let nu = 0;
%let d_random = ;
%do %while(&another = 1);
   %let effect = %scan(&random,%eval(&nu+1),' ');
   %if %length(&effect) %then %do;
      %let d_random = &d_random D_&effect;
      %let nu = %eval(&nu + 1);
   %end;
   %else %let another = 0;
%end;

%let nu2 = 0;
%if %length(&random2) %then %do;
   %let nu1 = &nu;
   %let random1 = &random;
   %let d_ran1 = &d_random;
   %let another = 1;
   %let d_ran2 = ;
   %do %while(&another = 1);
      %let effect = %scan(&random2,%eval(&nu2+1),' ');
      %if %length(&effect) %then %do;
         %let d_ran2 = &d_ran2 D_&effect;
         %let nu2 = %eval(&nu2 + 1);
      %end;
      %else %let another = 0;
   %end;
   %let nu = %eval(&nu1 + &nu2);
   %let random = &random1 &random2;
   %let d_random = &d_ran1 &d_ran2;
   %if (&gauss > 0) %then %do;
      %put WARNING: Gauss steps are not available with RANDOM2.;
      %let gauss = 0;
   %end;
%end;

%if %length(&rtype) | %length(&reffect) | %length(&ropt) %then %do;
   %let nr = 1;
   %if %index(&options,NESTRSUB) %then %do;
      %if &nu2 %then %let rsub1=_subject(&rsub2 _sub2);
      %else %let rsub1=_subject(&rsub2);
   %end;
   %else %let rsub1=&rsub;
%end;
%else %let nr = 0;

%if %index(&options,DEBUG) %then %do;
   %put model = &mod;
   %put derivatives = &der;
   %put fixed = &fixed;
   %put d_fixed = &d_fixed;
   %if (&nu2) %then %do;
      %put random1 = &random1;
      %put d_ran1 = &d_ran1;
      %put random2 = &random2;
      %put d_ran2 = &d_ran2;
   %end;
   %put random = &random;
   %put d_random = &d_random;
   %if (&nr = 1) %then
      %put repeated = &reffect / TYPE=&rtype SUB=&rsub1 &ropt;
%end;

%if not %index (&expand,EBLUP) | (&switch > 0) %then
   %let expand = ZERO;
%if (&expand = ZERO) %then %do;
   %let savegau = &gauss;
   %let gauss = 0;
%end;

 /*---number of subjects and maximum observations per subject---*/
%let ns = 0;
data &outdata;
   retain _cursub . _cursub1 0 _curobs 1 _maxobs 1
      %if (&nu2) %then %do; _csub2 . _csub21 0 %end; ;
   set %unquote(&data);
   if _cursub ne %unquote(&subject) then do;
      _cursub = %unquote(&subject);
      _cursub1 = _cursub1 + 1;
      call symput('ns',left(_cursub1));
      _maxobs = max(_maxobs,_curobs);
      call symput('nos',left(_maxobs));
      _curobs = 1;
      %if (&nu2) %then %do;
         _csub2 = %unquote(&subject2);
         _csub21 = 1;
      %end;
   end;
   else do;
      _curobs = _curobs + 1;
      %if (&nu2) %then %do;
         if _csub2 ne %unquote(&subject2) then do;
            _csub2 = %unquote(&subject2);
            _csub21 = _csub21 + 1;
         end;
      %end;
   end;
   _subject = _cursub1;
   drop _cursub _cursub1 _curobs _maxobs;
   %if (&nu2) %then %do;
      _sub2 = _csub21;
      drop _csub2 _csub21;
   %end;
   _one = 1;
run;

 /*---number of observations---*/
data _null_;
   set &outdata nobs=count;
   call symput('no',left(put(count,8.)));
   nus = &nu*&ns;
   call symput('nus',left(nus));
run;

%if (&nu2) & %index(&options,CROSS2) %then %do;
   %let ns = 1;
   %let nos = &no;
%end;

 /*---starting values for b and u---*/
data &outdata;
   set &outdata;
   %let idx = 1;
   %if %index(&options,SKIPNLIN) %then %do;
      %do i = 1 %to &nb;
         %scan(&parms,&idx,' ' =) =
            %scan(&parms,%eval(&idx+1),' ' =);
         %let idx = %eval(&idx + 2);
      %end;
   %end;
   %do i = 1 %to &nu;
      %scan(&random,&i,' ') = 0;
   %end;
run;

%mend init;

 /*------------------------------------------------------*/
 /*                                                      */
 /*   %numder                                            */
 /*   numerical derivatives                              */
 /*                                                      */
 /*------------------------------------------------------*/
%macro numder;

   do _i = 1 to &nb;
      _b0 = _b{_i};
      _tol = &tol*(1+abs(_b0));
      _b{_i} = _b0 - _tol;
      &mod
      _predl = pred;
      _b{_i} = _b0 + _tol;
      &mod
      _predu = pred;
      _db{_i} = (_predu - _predl)/2/_tol;
      _b{_i} = _b0;
   end;
   %if (&nu) %then %do;
      do i = 1 to &nu;
         _u0 = _u{i};
         _tol = &tol*(1+abs(_u0));
         _u{i} = _u0 - _tol;
         &mod
         _predl = pred;
         _u{i} = _u0 + _tol;
         &mod
         _predu = pred;
         _du{i} = (_predu - _predl)/2/_tol;
         _u{i} = _u0;
      end;
   %end;

%mend numder;


 /*------------------------------------------------------*/
 /*                                                      */
 /*   %nlin                                              */
 /*   PROC NLIN call                                     */
 /*                                                      */
 /*------------------------------------------------------*/
%macro nlin;

%if (not %index(&options,NOPRINT)) & ((&nu) | (&nr)) %then %do;
   %put Calling PROC NLIN to initialize.;
%end;

proc nlin data=&outdata &_printn_ %unquote(&nlinopt);
   array _b{&nb} &fixed;
   array _db{&nb} &d_fixed;
   array _derb{&nb} &d_fixedn;

   /*---set starting values---*/
   parms %unquote(&parms);

   /*---compute the nonlinear function and its derivatives---*/
   &modinit
   &mod
   model %unquote(&response) = pred;
   %if %length(&weight) ne 0 %then %do;
      _weight_ = %unquote(&weight);
   %end;
   %if %length(&der) %then %do;
      &der
   %end;
   %else %do;
      %if (&nu) %then %do;
         array _u{&nu} &random;
         array _du{&nu} &d_random;
      %end;
      %numder
   %end;
   do i = 1 to &nb;
      _derb{i} = _db{i};
   end;

   output out=&outdata parms=&fixed;
   %unquote(&nlinstmt);
run;

%mend nlin;


 /*----------------------------------------------------------*/
 /*                                                          */
 /*   %resder                                                */
 /*   construct residuals and derivatives                    */
 /*                                                          */
 /*----------------------------------------------------------*/
%macro resder;

data &outdata;
   set &outdata end=_last;
   %if (&nb) %then %do;
      array _b{&nb} &fixed;
      array _db{&nb} &d_fixed;
   %end;
   %if (&nu) %then %do;
      array _u{&nu} &random;
      array _du{&nu} &d_random;
   %end;
   retain _rss 0;
   &modinit
   &mod
   _resid = %unquote(&response) - pred;
   %if %index(&options,DEBUG) %then %do;
      _residy = _resid;
   %end;
   %if %length(&weight) %then %do;
      _w = %unquote(&weight);
      if (_resid ne .) then _rss = _rss + _resid*_resid*_w;
   %end;
   %else %do;
      if (_resid ne .) then _rss = _rss + _resid*_resid;
   %end;
   %if %length(&der) %then %do;
      &der
   %end;
   %else %do;
      %numder
   %end;
   if (_resid ne .) then do;
      %if (&nb) %then %do;
         do _i = 1 to &nb;
            _resid = _resid + _db{_i}*_b{_i};
         end;
      %end;
      %if (&nu) & (&expand=EBLUP) %then %do;
         do _i = 1 to &nu;
            _resid = _resid + _du{_i}*_u{_i};
         end;
      %end;
   end;
   if _last then call symput('rss',left(_rss));
   drop _rss;
   if (_error_ = 1) then do;
      call symput('_error',left(_error_));
      stop;
   end;
run;

%if %index(&options,DEBUG) %then %do;
   proc print data=&outdata(obs=30);
   run;
   proc means data=&outdata uss;
      var _residy;
   run;
%end;

%mend resder;

 /*----------------------------------------------------------*/
 /*                                                          */
 /*   %mixed                                                 */
 /*   PROC MIXED step                                        */
 /*                                                          */
 /*----------------------------------------------------------*/
%macro mixed;

%let ncall = %eval(&ncall + 1);
%if not %index(&options,NOPRINT) %then
   %put %str(   )PROC MIXED call &ncall;

proc mixed data=&outdata method=%unquote(&method)
   %unquote(&procopt) %if (&hold>0) %then %do; noprofile %end; ;
   %if not %index(&options,NOCLASS) %then %do;
      class _subject &class %if (&nu2) %then %do; _sub2 %end;
         %if (&nr) %then %do; &reffect &rsub2 %end; ;
   %end;
   %if (&nb) %then %do;
      model _resid = &d_fixed / notest s cl noint %unquote(&modopt);
   %end;
   %else %do;
      model _resid = / noint %unquote(&modopt);
   %end;
   %if (&nu2) %then %do;
      random &d_ran1 / type=%unquote(&type) sub=_subject
         %if (&expand=EBLUP) %then %do; s %end;
         %if (&gauss>0) %then %do; gci %end; &ranopt ;
      random &d_ran2 / type=%unquote(&type2)
         %if %index(&options,CROSS2) %then %do; sub=_sub2 %end;
         %else %do; sub=_sub2(_subject) %end;
         %if (&expand=EBLUP) %then %do; s %end;
         %if (&gauss>0) %then %do; gci %end; &ranopt2 ;
   %end;
   %else %if (&nu) %then %do;
      random &d_random / type=%unquote(&type) sub=_subject
         %if (&expand=EBLUP) %then %do; s %end;
         %if (&gauss>0) %then %do; gci %end; &ranopt ;
   %end;
   %if &nu or %length(&covpopt&covparms) %then %do;
      %if (&hold>0) %then
         %str(parms / pdata=_covsave noiter %unquote(&covpopt);) ;
      %else %if %length(&covparms) & (&ncall=0 or
         %index(&options,NOPREV))%then
         %str(parms %unquote(&covparms / &covpopt);) ;
      %else %if (&ncall>0) & not %index(&options,NOPREV) %then
         %str(parms / pdata=_covsave %unquote(&covpopt);) ;
      %else %if %length(&covpopt) %then
         %str(parms / %unquote(&covpopt);) ;
   %end;
   %if %length(&weight) %then %str(weight _w;);
   %if (&nr) %then %do;
      %if %length(&rtype) %then
         %str(repeated &reffect / type=&rtype sub=&rsub1 &ropt;);
      %else %str(repeated &reffect / sub=&rsub1 &ropt;);
   %end;
   %if %length(&add) %then %do;
      %unquote(&add)
   %end;
   %if (&nb) %then %do;
      ods output solutionf=_soln;
   %end;
   %if (&nu) | (&nr) %then %do;
      ods output covparms=_cov;
      %if (&nu) & (&expand=EBLUP) %then %do;
         ods output solutionr=_solnr;
      %end;
      %if (&nu) & (&gauss>0) %then %do;
         ods output invcholg=_gci;
      %end;
   %end;
   ods output fitstatistics=_fit;
run;

%if (&nu2) & (&expand=EBLUP) %then %do;
   data _solnr;
      set _solnr;
      if _subject = . then delete;
   run;
%end;

 /*---check for convergence---*/
%let there = 0;
data _null_;
   set _fit;
   call symput('there',1);
run;
%if (&there = 0) %then %do;
   %if not %index(&options,NOPRINT) %then
      %put PROC MIXED did not converge.;
   %let _error = 1;
%end;

%mend mixed;


 /*-----------------------------------------------------------*/
 /*                                                           */
 /*   %merge                                                  */
 /*   merge in new estimates of b and u                       */
 /*                                                           */
 /*-----------------------------------------------------------*/
%macro merge;

 /*---drop variables for subsequent merge---*/
data &outdata;
   set &outdata;
   drop pred;
   %if (&nb) %then %do;
      drop &fixed;
   %end;
   %if (&nu) & (&expand=EBLUP) %then %do;
      drop &random;
   %end;
run;

 /*---merge in b---*/
%if (&nb) %then %do;
   proc transpose data=_saveb out=_beta;
      var estimate;
   run;

   data _beta;
      set _beta;
      array _b{&nb} &fixed;
      %do i = 1 %to &nb;
         _b{&i} = col&i;
      %end;
      _one = 1;
      keep _one &fixed;
   run;

   data &outdata;
      merge &outdata _beta;
      by _one;
   run;
%end;

 /*---merge in u---*/
%if (&nu) & (&expand=EBLUP) %then %do i=1 %to &nu;

   %let effect = %scan(&random,&i,' ');
   %let d_effect = %scan(&d_random,&i,' ');

   data _eblup;
      set _saveu;
      pp = "&d_effect";
      if (effect = pp);
      /*---convert to numeric---*/
      _sub = 0;
      _sub = _sub + _subject;
      &effect = estimate;
      keep _sub &effect;
      %if (&nu2) & (&i > &nu1) %then %do;
         /*---convert to numeric---*/
         _s2 = 0;
         _s2 = _s2 + _sub2;
         keep _s2;
      %end;
   run;

   data _eblup;
      set _eblup;
      _subject = _sub;
      keep _subject &effect;
      %if (&nu2) & (&i > &nu1) %then %do;
         _sub2 = _s2;
         keep _sub2;
      %end;
   run;

   %if %index(&options,CROSS2) & (&nu2) & (&i > &nu1) %then %do;
      %if (&i = %eval(&nu1+1)) %then %do;
         proc sort data=&outdata;
            by _sub2;
         run;
      %end;
      data _eblup;
         set _eblup;
         keep _sub2 &effect;
      run;
      data &outdata;
         merge &outdata _eblup;
         by _sub2;
      run;
      %if (&i = &nu) %then %do;
         proc sort data=&outdata;
            by _subject _sub2;
         run;
      %end;
   %end;
   %else %do;
      data &outdata;
         merge &outdata _eblup;
         %if (&nu2) & (&i > &nu1) %then %do;
            by _subject _sub2;
         %end;
         %else %do;
            by _subject;
         %end;
      run;
   %end;

%end;

%mend merge;

 /*----------------------------------------------------------*/
 /*                                                          */
 /*   %uquad                                                 */
 /*   compute u'inv(G)u                                      */
 /*                                                          */
 /*----------------------------------------------------------*/
%macro uquad;

%if not (&nu) | not (&expand=EBLUP) %then %let uq = 0;
%else %do;

   data _eblup;
      set _saveu;
      %if %index(&options,NOCLASS) %then %do;
         _subject = subject;
      %end;
      %else %do;
         _subject = substr(subject,9);
      %end;
      _sub = 0;
      _sub = _sub + _subject;
      keep estimate _sub;
   run;

   proc transpose data=_eblup out=_eb;
      var estimate;
      by _sub;
   run;

   data _eb;
      set _eb end=_last;
      array col{&nu} col1-col&nu;
      array us{&nu} us1-us&nu;
      retain uq 0;

      /*---compute InvChol(G)*u---*/
      %do i = 1 %to &nu;
         us{&i} = 0;
         %do j = 1 %to &i;
            us{&i} = us{&i} + (&&gci&i&j)*col{&j};
         %end;
      %end;

      /*---accumulate sum of squares---*/
      do i = 1 to &nu;
         uq = uq + us{i}*us{i};
      end;
      output;
      if _last then call symput("uq",left(uq));
   run;
%end;

%mend uquad;


 /*-------------------------------------------------------*/
 /*                                                       */
 /*    %iterate                                           */
 /*    Iteration process                                  */
 /*                                                       */
 /*-------------------------------------------------------*/
%macro iterate;

 /*---initial data set for iterinfo---*/
data _beta;
   set &outdata(obs=1);
   %if (&nb) %then %do;
      keep &fixed;
   %end;
run;

 /*---initial data sets for Gauss-Newton---*/
%if (&gauss > 0) %then %do;
   %if (&nb) %then %do;
      data _oldb;
         set _beta;
         array _b{&nb} &fixed;
         %do i = 1 %to &nb;
            oldest = _b{&i};
            output;
         %end;
         keep oldest;
      run;
   %end;
   %if (&nu) & (&expand=EBLUP) %then %do;
      data _oldu;
         oldest = 0;
         %do i = 1 %to &nus;
            output;
         %end;
      run;
   %end;
%end;

 /*---initial macro variables---*/
%let crit = .;
%let conv = 0;
%let hold = 0;
%let ni = 0;
%let ncall = -1;

 /*---iterate until convergence---*/
%do %while(&ni <= &maxit);

   %if (&ni = 0) and not %index(&options,NOPRINT) %then
      %put Iteratively calling PROC MIXED.;

   %if (&switch > 0) and (&ni = &switch) %then %do;
      %let expand = EBLUP;
      %let gauss = &savegau;
      %let ni = 0;
      %let switch = 0;
      %put Switching from EXPAND=ZERO to EXPAND=EBLUP;
   %end;

   /*---save estimates---*/
   %if (&ni ne 0) and ((&nu) | (&nr)) %then %do;
      data _covold;
         set _covsave;
         estold = estimate;
         keep estold;
      run;
   %end;
   %if (&ni ne 0) and (&nb) %then %do;
      data _solnold;
         set _saveb;
         estold = estimate;
         keep estold;
      run;
   %end;

   /*---set up pseudo data and compute first step---*/
   %resder
   %if (&_error = 1) %then %goto finish;
   %mixed
   %if (&_error = 1) %then %goto finish;

   %if (&nu) | (&nr) %then %do;
      data _covsave;
         set _cov;
         /*---code to handle lowerb---*/
         %if %length(&lowerb) %then %do;
            %let i=1;
            %do %while(%length(%scan(&lowerb,&i,%str(,))));
               %let j=%scan(&lowerb,&i,%str(,));
               %if &j^=. %then %do;
                  if _n_=&i and est<&j then est=&j;
               %end;
               %let i=%eval(&i+1);
            %end;
         %end;
      run;
   %end;

   /*---check for convergence---*/
   %if (&ni ne 0) %then %do;
      %let crit = 0;
      %if (&nu) | (&nr) %then %do;
         data _null_;
            merge _cov _covold end=last;
            retain cr &crit;
            crit = abs(estimate-estold)/
               max(abs(estold),max(abs(estimate),1));
            %if %index(&options,WORST) %then %do;
               if (crit > cr) then do;
                  call symput('worst',left(estold));
               end;
            %end;
            cr = max(cr,crit);
            if last then do;
               call symput('crit',left(cr));
            end;
         run;
      %end;
      %if (&nb) %then %do;
         data _null_;
            merge _soln _solnold end=last;
            retain cr &crit;
            crit = abs(estimate-estold)/
               max(abs(estold),max(abs(estimate),1));
            %if %index(&options,WORST) %then %do;
               if (crit > cr) then do;
                  call symput('worst',left(estold));
               end;
            %end;
            cr = max(cr,crit);
            if last then do;
               call symput('crit',left(cr));
            end;
         run;
      %end;
      data _null_;
         cr = &crit;
         if (cr < &converge) then call symput('conv',left(1));
      run;
   %end;
   %else %if %index(&options,PRINTFIRST) %then %do;
      ods exclude all;
   %end;
   %if not %index(&options,NOPRINT) %then %do;
      %put %str(   );
      %put iteration = &ni;
      %put convergence criterion = &crit;
      %getbc;
      %put &bstr &cstr;
      %if %index(&options,WORST) %then %do;
         %put worst = &worst;
      %end;
   %end;
   %if (&conv = 1) %then %do;
      %let maxit = -1;
      %let gauss = -1;
   %end;
   %else %let ni = %eval(&ni + 1);

   /*---if no Gauss-Newton, just merge in new estimates and
        loop back (this is equivalent to taking 1 G-N step)---*/
   %if (&ni > &gauss) %then %do;
      /*---save step---*/
      %if (&nb) %then %do;
         data _saveb;
            set _soln;
         run;
      %end;
      %if (&nu) & (&expand=EBLUP) %then %do;
         data _saveu;
            set _solnr;
         run;
      %end;
      %merge;
   %end;
   /*---Gauss-Newton steps---*/
   %else %do;
      /*---get residual variance estimate---*/
      data _null_;
         set _cov;
         if (covparm = 'Residual') then
            call symput('resid',left(estimate));
      run;
      /*---load elements of InvChol(G) into macro variables---*/
      %if (&nu) %then %do;
         data _null_;
            set _gci;
            array col{&nu} col1-col&nu;
            %do i = 1 %to &nu;
               %do j = 1 %to &i;
                  %local gci&i&j;
                  if (row = &i) then
                     call symput("gci&i&j",left(col{&j}));
               %end;
            %end;
         run;
      %end;

      /*---compute quadratic form of random effects---*/
      %if (&ni > 1) %then %uquad;
      %else %let uq = 0;
      /*---compute initial objective function---*/
      data _null_;
         obj = &rss/&resid + &uq;
         call symput('oldobj',left(obj));
      run;
      %if not %index(&options,NOPRINT) %then %do;
         %put %str(   );
         %put %str(   )subiteration = 0;
         %put %str(   )Gauss-Newton starting objective = &oldobj;
         %put %str(   )rss=&rss  resid=&resid  uq=&uq;
         %getbc;
         %put %str(   )&bstr &cstr;
      %end;
      /*---save step---*/
      %if (&nb) %then %do;
         data _bestb;
            set _soln;
         run;
      %end;
      %if (&nu) & (&expand=EBLUP) %then %do;
         data _bestu;
            set _solnr;
         run;
      %end;

      /*---Gauss-Newton loop---*/
      %let hold = 1;
      %let nsi = 1;
      %do %while(&nsi <= &maxsubit);
         /*---save step---*/
         %if (&nb) %then %do;
            data _saveb;
               set _soln;
            run;
         %end;
         %if (&nu) & (&expand=EBLUP) %then %do;
            data _saveu;
               set _solnr;
            run;
         %end;
         /*---merge in new estimates of b and u---*/
         %merge;
         /*---update pseudo data---*/
         %resder;
         /*---compute u`*inv(G)*u---*/
         %uquad;
         /*---check to see if objective has improved---*/
         %let better = 0;
         %let sconv = 0;
         data _null_;
            obj = &rss/&resid + &uq;
            reldiff = (&oldobj - obj)/
               max(&oldobj,max(obj,1));
            if (reldiff > 0) then call symput('better',left(1));
            if (abs(reldiff) < &subconv) then
               call symput('sconv',left(1));
            call symput('obj',left(obj));
            call symput('reldiff',left(reldiff));
         run;
         %if not %index(&options,NOPRINT) %then %do;
            %put %str(   );
            %put %str(   )subiteration  = &nsi;
            %put %str(   )old objective = &oldobj;
            %put %str(   )new objective = &obj;
            %put %str(   )relative diff = &reldiff;
            %put %str(   )subconverged  = &sconv;
            %put %str(   )better = &better;
            %put %str(   )rss=&rss  resid=&resid  uq=&uq;
            %getbc;
            %put %str(   )&bstr &cstr;
         %end;

         /*---stop looping if objectives are within tolerance---*/
         %if (&sconv = 1) %then %let nsi = &maxsubit;

         /*---if better, update saves and take another step---*/
         %if (&better = 1) %then %do;
            %if (&nb) %then %do;
               data _bestb;
                  set _saveb;
               run;
               data _oldb;
                  set _saveb;
                  oldest = estimate;
                  keep oldest;
               run;
            %end;
            %if (&nu) & (&expand=EBLUP) %then %do;
               data _bestu;
                  set _saveu;
               run;
               data _oldu;
                  set _saveu;
                  oldest = estimate;
                  keep oldest;
               run;
            %end;
            %let oldobj = &obj;
            /*---compute new iterate, holding variance
                 parameters fixed---*/
            %if (&nsi < &maxsubit) %then %mixed;
         %end;
         /*---if not better, step shorten---*/
         %else %if (&nsi < &maxsubit) %then %do;
            %if not %index(&options,NOPRINT) %then %put
               %str(   )step-shortening with fraction &fraction;
            %if (&nb) %then %do;
               data _soln;
                  merge _saveb _oldb;
                  estimate = &fraction*estimate +
                     (1-&fraction)*oldest;
                  drop oldest;
               run;
            %end;
            %if (&nu) & (&expand=EBLUP) %then %do;
               data _solnr;
                  merge _saveu _oldu;
                  estimate = &fraction*estimate +
                     (1-&fraction)*oldest;
                  drop oldest;
               run;
            %end;
         %end;
         /*---increment counter---*/
         %let nsi = %eval(&nsi + 1);
      %end;

      /*---merge in best parameters---*/
      %if (&nb) %then %do;
         data _saveb;
            set _bestb;
         run;
      %end;
      %if (&nu) & (&expand=EBLUP) %then %do;
         data _saveu;
            set _bestu;
         run;
      %end;
      %merge
      %let hold = 0;
   %end;
   /*---get rid of fitting data set---*/
   %if (&there = 1) %then %do;
      proc datasets lib=work nolist;
         delete _fit;
      run;
   %end;
%end;

 /*---turn on printing and options---*/
%finish:
ods select all;
%let _printn_ = ;
%let niter = &ni;
%if not %index(&options,NOTES) %then %do;
   options notes date number;
%end;

%if not %index(&options,NOPRINT) %then %do;
   %if (&conv = 1) %then %do;
      %put NLINMIX convergence criteria met.;
      /*---compute final results---*/
      %resder
      %if (&expand = ZERO) %then %let expand = EBLUP;
      %mixed
      %if %index(&options,PLOT) %then %do;
         symbol i=join r=500 c=black;
         proc gplot data=&outdata;
            plot &response*pred=_subject / nolegend;
            plot _resid*(&d_fixed)=_subject / nolegend;
      %end;
   %end;
   %else %put NLINMIX did not converge.;
%end;

%mend iterate;



 /*------------------------------------------------------------*/
 /*                                                            */
 /*    %baseinfo                                               */
 /*    Print basic information about the macro                 */
 /*                                                            */
 /*------------------------------------------------------------*/
%macro baseinfo;

%if %index(&data,.)=0 %then %let data=WORK.&data;
%put;
%put %str(                          The NLINMIX Macro);
%put;
%put %str(           Data Set                     : &data);
%put %str(           Response                     : &response);
%put %str(           Subject                      : &subject);
%if (&nb) %then
%put %str(           Fixed Effects Parameters     : &fixed);
%if (&nu2) %then %do;
%put %str(           Random Effects               : &random1);
%put %str(           Covariance Type              : &type);
%put %str(           Second Random Effects        : &random2);
%put %str(           Second Covariance Type       : &type2);
%put %str(           Second Subject               : &subject2);
%end;
%else %if (&nu) %then %do;
%put %str(           Random Effects Parameters    : &random);
%put %str(           Covariance Type              : &type);
%end;
%if (&nu) %then
%put %str(           Expansion Point              : &expand);
%if %length(&reffect) %then
%put %str(           REPEATED Effect              : &reffect);
%if %length(&rtype) %then
%put %str(           REPEATED Covariance Type     : &rtype);
%if %length(&weight) %then
%put %str(           Weight                       : &weight);
%put %str(           Optimization Method          : &method);
%put;
%put;
%put %str(                            Dimensions);
%put;
%put %str(                 Observations                : &no);
%put %str(                 Subjects                    : &ns);
%put %str(                 Maximum Obs per Subject     : &nos);
%put %str(                 Fixed Effects Parameters    : &nb);
%if (&nu) & (not (&nu2)) %then
%put %str(                 Random Effects per Subject  : &nu);
%put;

%mend baseinfo;

 /*----------------------------------------------------------*/
 /*                                                          */
 /*    %getbc                                                */
 /*    load current estimate of b into macro variables       */
 /*                                                          */
 /*----------------------------------------------------------*/
%macro getbc;

%let bstr = ;
%let cstr = ;

%if (&nb) %then %do;
   data _beta;
      set _beta;
      %do i = 1 %to &nb;
         call symput("bb&i",left(%scan(&fixed,&i,' ')));
      %end;
   run;

   %do i = 1 %to &nb;
      %let bstr = &bstr %scan(&fixed,&i,' ')=&&bb&i;
   %end;
%end;

%if (&nu) or (&nr) %then %do;
   data _null_;
      set _cov nobs=count;
      call symput('ncov',left(put(count,8.)));
   run;

   data _null_;
      set _cov;
      %do i = 1 %to &ncov;
         if (_n_ = &i) then do;
            call symput("cc&i",left(estimate));
         end;
      %end;
   run;

   %do i = 1 %to &ncov;
      %let cstr = &cstr COVP&i=&&cc&i;
   %end;
%end;


%mend getbc;

 /*------------------------------------------------------------*/
 /*                                                            */
 /*    %nlinmix()                                              */
 /*    the main macro                                          */
 /*                                                            */
 /*------------------------------------------------------------*/
%macro nlinmix(data=,response=y,subject=subject,modinit=,model=,
    derivs=,tol=1e-5,parms=,covparms=,covpopt=,random=,ranopt=,
    type=vc,random2=,ranopt2=,subject2=,type2=vc,
    rtype=,reffect=,rsub=_subject,ropt=,weight=,add=,method=reml,
    expand=ZERO,converge=1e-8,subconv=1e-12,maxit=20,maxsubit=10,
    switch=0,gauss=0,fraction=0.5,procopt=,modopt=,nlinopt=,
    nlinstmt=,class=,outdata=_nlinmix,options=);

 /*---check for mandatories---*/
%if %bquote(&model)= %then %let missing = MODEL=;
%else %let missing =;
%if %length(&missing) %then %do;
   %put ERROR: The NLINMIX &missing argument is not present.;
%end;
%else %do;
   /*---default data set---*/
   %if %bquote(&data)= %then %let data=&syslast;

   /*---change variables to quoted uppercase---*/
   %let data     = %qupcase(&data);
   %let response = %qupcase(&response);
   %let subject  = %qupcase(&subject);
   %let modinit  = %qupcase(&modinit);
   %let mod      = %qupcase(&model);
   %let der      = %qupcase(&derivs);
   %let parms    = %qupcase(&parms);
   %let covparms = %qupcase(&covparms);
   %let random   = %qupcase(&random);
   %let ranopt   = %qupcase(&ranopt);
   %let type     = %qupcase(&type);
   %let random2  = %qupcase(&random2);
   %let ranopt2  = %qupcase(&ranopt2);
   %let subject2 = %qupcase(&subject2);
   %let type2    = %qupcase(&type2);
   %let rtype    = %qupcase(&rtype);
   %let reffect  = %qupcase(&reffect);
   %let rsub     = %qupcase(&rsub);
   %let ropt     = %qupcase(&ropt);
   %let weight   = %qupcase(&weight);
   %let add      = %qupcase(&add);
   %let method   = %qupcase(&method);
   %let expand   = %qupcase(&expand);
   %let procopt  = %qupcase(&procopt);
   %let covpopt  = %qupcase(&covpopt);
   %let modopt   = %qupcase(&modopt);
   %let class    = %qupcase(&class);
   %let options  = %qupcase(&options);

   /*---global variables---*/
   %global _printn_ _error;

   /*---local variables---*/
   %local nb nu ns nos no nus ni ncall nr fixed d_fixed d_fixedn
      d_random crit hold rss resid uq bstr cstr there savegau
      random1 random2 nu1 nu2 d_ran1 d_ran2 rsub1 lowerb;

   /*---initialize---*/
   %if not %index(&options,NOTES) %then %do;
      options nonotes nodate nonumber;
   %end;

   %let rsub2=;
   %let i=1;
   %do %while(%length( %scan(&rsub,&i,%str( *())) ));
      %let rsub2=&rsub2 %scan(&rsub,&i,%str( *()));
      %let i=%eval(&i+1);
   %end;

   %let i=%index(&covpopt,LOWERB);
   %if &i %then %do;
      %let lowerb=%qscan(%qsubstr(%str(&covpopt),&i+5),2,%str(=LNOPRU));
      %let i=%index(&lowerb,EQC);
      %if &i %then %let lowerb=%qsubstr(&lowerb,1,&i-1);
   %end;
   %else %let lowerb=;

   %init

   %if %index(&options,PRINTALL) or %index(&options,PRINTFIRST)
      %then %do;
      ods select all;
      %let _printn_ = ;
   %end;
   %else %do;
      ods exclude all;
      %let _printn_ = noprint;
   %end;

   /*---print basic macro information---*/
   %if not %index(&options,NOPRINT) %then %baseinfo;

   /*---run PROC NLIN to get initial estimates---*/
   %if (&nb) & not %index(&options,SKIPNLIN) %then %do;
      %if not (&nu) & not (&nr) %then %let _printn_ = ;
      %nlin;
   %end;

   /*---iterate PROC MIXED calls until convergence---*/
   %iterate;


%end;

%mend nlinmix;

 /*---Examples for NLINMIX macro---*/

 /*---Data on orange trees, Draper and Smith, 1981, p. 524, and
     Lindstrom and Bates, Biometrics, 1990, 673-687---*/

data tree;
   input tree time x y;
   datalines;
1 1  118   30
1 2  484   58
1 3  664   87
1 4 1004  115
1 5 1231  120
1 6 1372  142
1 7 1582  145
2 1  118   33
2 2  484   69
2 3  664  111
2 4 1004  156
2 5 1231  172
2 6 1372  203
2 7 1582  203
3 1  118   30
3 2  484   51
3 3  664   75
3 4 1004  108
3 5 1231  115
3 6 1372  139
3 7 1582  140
4 1  118   32
4 2  484   62
4 3  664  112
4 4 1004  167
4 5 1231  179
4 6 1372  209
4 7 1582  214
5 1  118   30
5 2  484   49
5 3  664   81
5 4 1004  125
5 5 1231  142
5 6 1372  174
5 7 1582  177
;

run;

 /*---logistic model---*/
%nlinmix(data=tree,
   response=y,
   subject=tree,
   model=%str(
      num = b1+u1;
      e = exp(b3*x);
      den = 1 + b2*e;
      pred = num/den;
   ),
   derivs=%str(
      d_b1 = 1/den;
      d_b2 = -num/den/den*e;
      d_b3 = -num/den/den*b2*x*e;
      d_u1 = d_b1;
   ),
   parms=%str(b1=150 b2=10 b3=-.001),
   random=u1,
   expand=eblup
)
run;

 /*---Data on pigs, Johansen, 1984, and Lindstrom and Bates,
     Biometrics, 1990, 673-687---*/

data pigs;
   input pig index x ey;
   y = -ey/100;
   intercep = 1;
   datalines;
1  1 .5 332
1  2  1 263
1  3  2 226
1  4  4 189
1  5  7 177
1  6 10 139
1  7 15 139
1  8 20 151
1  9 35  98
1 10 50  47
2  1 .5 312
2  2  1 268
2  3  2 223
2  4  4 187
2  5  7 171
2  6 10 149
2  7 15 125
2  8 20 101
2  9 35 100
2 10 50  87
3  1 .5 309
3  2  1 264
3  3  2 216
3  4  4 200
3  5  7 161
3  6 10 150
3  7 15 132
3  8 20 128
3  9 35  97
3 10 50  84
4  1 .5 347
4  2  1 289
4  3  2 229
4  4  4 201
4  5  7 177
4  6 10 168
4  7 15 146
4  8 20 139
4  9 35 120
4 10 50  92
5  1 .5 324
5  2  1 263
5  3  2 236
5  4  4 198
5  5  7 156
5  6 10 135
5  7 15 132
5  8 20 114
5  9 35  86
5 10 50  82
6  1 .5 334
6  2  1 278
6  3  2 246
6  4  4 193
6  5  7 158
6  6 10 166
6  7 15 144
6  8 20 164
6  9 35 124
6 10 50 118
7  1 .5 339
7  2  1 284
7  3  2 233
7  4  4 206
7  5  7 183
7  6 10 162
7  7 15 154
7  8 20 139
7  9 35 113
7 10 50 106
8  1 .5 335
8  2  1 281
8  3  2 254
8  4  4 215
8  5  7 178
8  6 10 166
8  7 15 143
8  8 20 145
8  9 35 122
8 10 50 103
;

run;

 /* NOTE: The variance parameters on the original scale
    differ by 5 orders of magnitude, so we rescale x to make
    the problem more stable.  The final estimates on the
    original scale are close to those given by Lindstrom and Bates,
    but are not exactly equal. */

 /* The derivatives are commented out so that NLINMIX will
    compute them numerically. */

 /*---log-transformed Michaelis-Menten model---*/
%nlinmix(data=pigs,
   response=y,
   subject=pig,
   model=%str(
      a = k + kz + x;
      ef = v*x/a + (d+dz)*x/100;
      pred = log(ef);
   ),
 /*
   derivs=%str(
      d_v = x/a/ef;
      d_k = -v*x/a/a/ef;
      d_d = x/100/ef;
      d_kz = d_k;
      d_dz = d_d;
   ),
 */
   parms=%str(v=.3 k=5 d=1),
   random=kz dz,
   type=un,
   expand=eblup
)
run;
