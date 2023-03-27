/*********************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                      */
/*                                                                   */
/*    NAME: SVIMPEX4                                                 */
/*   TITLE: Documentation Example 4 for PROC SURVEYIMPUTE            */
/* PRODUCT: STAT                                                     */
/*  SYSTEM: ALL                                                      */
/*    KEYS: fractional hot-deck imputation (FHDI), NHANES            */
/*    KEYS: balanced repeated replication (BRR)                      */
/*    KEYS: imputation-adjusted replicate weights                    */
/*    KEYS: domain analysis, regression analysis                     */
/*   PROCS: SURVEYIMPUTE, SURVEYMEANS, SURVEYREG                     */
/*    DATA: NHANES III                                               */
/*    URL:  http://www.cdc.gov/nchs/nhanes/about_nhanes.htm          */
/*  UPDATE: March 30, 2018                                           */
/*     REF: PROC SURVEYIMPUTE, Example 4                             */
/*    MISC: You must download the core and imp1 data sets from       */
/*          NHANES III before running the sample program. See the    */
/*          description in the example about how to create the       */
/*          HealthMiss data set that is used in this example.        */
/*********************************************************************/

/*
data Health;
   merge nh3mi.core (keep=seqn hff1if han6srif hat28if bmphtif bmpwtif
                          pep6g3if hsageir dmarethn hssex hshsizer
                          hfa8 hfa12 wtp: sdpstra6 sdppsu6)
         nh3mi.imp1 (keep=seqn hff1mi han6srmi hat28mi bmphtmi bmpwtmi
                          pep6g3mi);
   by seqn;
run;
data Health; set Health;
   where hsageir >= 17 and hsageir <= 60;
run;

*Use age and household size to create imputation clusters;
proc fastclus data=Health out=HealthClust maxc=5 maxiter=100;
   var hsageir hshsizer;
run;

data HealthClust; set HealthClust;
   if hfa12 <=3 then Married=1;
   else Married=0;
run;
*Add missing values;
data HealthMiss; set HealthClust;
   if hff1if   = 2 then hff1mi  =.;
   if han6srif = 2 then han6srmi=.;
   if hat28if  = 2 then hat28mi =.;
   if bmphtif  = 2 then bmphtmi =.;
   if bmpwtif  = 2 then bmpwtmi =.;
   if pep6g3if = 2 then pep6g3mi=.;
run;

proc format;
   value MarriedFmt 1="Married" 0="Not Married";
run;

data HealthMiss; set HealthMiss;
   format Married MarriedFmt.;
run;

*---Create bins for continuous variables---;
data HealthMiss; set HealthMiss;
   if bmphtmi       = .     then bmphtlev=.;
   else if bmphtmi <= 162.6 then bmphtlev=1;
   else if bmphtmi <= 171.5 then bmphtlev=2;
   else                          bmphtlev=3;
   if bmpwtmi       = .    then bmpwtlev=.;
   else if bmpwtmi <= 65.7 then bmpwtlev=1;
   else if bmpwtmi <= 80.2 then bmpwtlev=2;
   else                         bmpwtlev=3;
   if pep6g3mi       = .    then pep6g3lev=.;
   else if pep6g3mi <= 65.3 then pep6g3lev=1;
   else if pep6g3mi <= 75.8 then pep6g3lev=2;
   else                          pep6g3lev=4;
   label bmphtlev  = "Bin values for BMPHTMI"
         bmpwtlev  = "Bin values for BMPWTMI"
         pep6g3lev = "Bin values for PEP6G3MI";
run;

proc surveyimpute data=HealthMiss method=fhdi varmethod=brr
                       ndonors=5 seed=9388401;
   id seqn;
   class hff1mi hat28mi;
   weight wtpfqx6;
   repweights wtpqrp:;
   cells cluster married;
   var hff1mi hat28mi bmphtmi (clevvar=bmphtlev)
                      bmpwtmi (clevvar=bmpwtlev)
                      pep6g3mi(clevvar=pep6g3lev);
   output out=HealthFHDI;
run;

ods graphics on;
proc surveymeans data=HealthFHDI varmethod=brr(Fay=0.3) plots=domain;
   weight ImpWt;
   repweights ImpRepWt_:;
   var pep6g3mi;
   domain hff1mi;
run;

proc surveyreg data=HealthFHDI varmethod=brr(Fay=0.3);
   weight ImpWt;
   repweights ImpRepWt_:;
   class hff1mi hssex;
   model pep6g3mi = hff1mi hssex bmphtmi bmpwtmi hsageir / solution;
   output out=Resid residual=Residuals predicted=Fitted;
run;

*---Modify the ODS template to customize plot title---;
data Resid; set Resid;
   label Fitted ='Fitted Values'
         Residuals = 'Residuals';
run;
proc template;
   source Stat.SurveyReg.FitHeatHex / file='sr.tpl';
quit;
data _null_;
   infile 'sr.tpl' end=eof;
   input;
   if findw(_infile_, 'entrytitle YVARLABEL " Fit Plot"') then do;
      _infile_ = tranwrd(_infile_, 'entrytitle YVARLABEL " Fit Plot"',
                                   'entrytitle "Residuals Plot"');
   end;
   if findw(_infile_, 'discretelegend "Fit" "Confidence"') then do;
      _infile_ = tranwrd(_infile_, 'discretelegend "Fit" "Confidence"',
                                   '');
   end;
   if _n_ = 1 then call execute('proc template;');
   call execute(_infile_);
   if eof then call execute('quit;');
run;

proc surveyreg data=resid plots(nbins=60)=fit(shape=hexagonal);
   model Residuals=Fitted;
   weight impwt;
run;

*/

