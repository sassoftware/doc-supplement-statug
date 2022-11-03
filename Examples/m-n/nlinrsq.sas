 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: NLINRSQ                                             */
 /*   TITLE: Computation of R-Square for a Non-Linear Model      */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: nonlinear models,                                   */
 /*   PROCS: NLIN MEANS                                          */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /* **************************************************************/


 /* -------------------------------------------------------------*/
 /*    MISC: Analogous to the linear case, R-square is computed  */
 /*          here as RSQ =                                       */
 /*          1 - VARIANCE(FULL MODEL)/VARIANCE(MEAN MODEL) =     */
 /*          1 - SSE/CSS, where                                  */
 /*          SSE = error sum of squares obtained from nlin,      */
 /*          CSS = corrected total sum of squares for the        */
 /*                dependent variable.                           */
 /*          Note that the mean model is not nested within       */
 /*          the general non-linear model, so the quanity RSQ    */
 /*          may be negative.                                    */
 /****************************************************************/

TITLE1 '--------------- NLINRSQ ----------------';
TITLE2 '--- R-Square for a Non-Linear Model ----';

   data uspop;
      input pop :6.3 @@;
      retain year 1780;
      year=year+10;
      yearsq=year*year;
      datalines;
   3929 5308 7239 9638 12866 17069 23191 31443 39818 50155
   62947 75994 91972 105710 122775 131669 151325 179323 203211
   226542 248710
   ;

proc print data=uspop;
proc nlin data=uspop;
   parms c0=3.9 c1=.022;
   model pop=c0*exp(c1*(year-1790));
   output out=b1 sse=sse;
   run;
proc means data=uspop noprint css;
   var pop;
   output out=b2 css=css;
   run;
data _nuLL_;
   set b1(obs=1); set b2(obs=1);
   rsq = 1 - sse/css;
   file print;
   put // +10 'R-square for the non-linear model is defined' /
          +10 'as 1 - SSE/CSS, where sse is the variance of' /
          +10 'of the full model, CSS is the variance of   ' /
          +10 'the mean model. ' //
          +10 'R-square =' +5 rsq 8.6;
   run;
