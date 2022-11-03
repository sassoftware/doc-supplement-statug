 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MR2010F                                             */
 /*   TITLE: Discrete Choice 5                                   */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: marketing research                                  */
 /*   PROCS: PHREG, TRANSREG, OPTEX, FACTEX, PLAN, IML           */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: MR-2010F Discrete Choice                            */
 /*    MISC: This file contains SAS code for the "Discrete       */
 /*          Choice" report, the 01Oct2010 edition, for SAS 9.2. */
 /*                                                              */
 /*          You must install the following macros from          */
 /* http://support.sas.com/techsup/tnote/tnote_stat.html#market  */
 /*                                                              */
 /*          ChoicEff Efficient Choice Designs                   */
 /*          MktAllo  Process a Choice Allocation Study Data Set */
 /*          MktBal   Balanced Experimental Design               */
 /*          MktBIBD  Balanced Incomplete Block Design           */
 /*          MktBlock Block an Experimental Design               */
 /*          MktBSize Balanced Incomplete Block Design Sizes     */
 /*          MktDes   Efficient Experimental Designs             */
 /*          MktDups  Eliminate Duplicate Runs or Choice Sets    */
 /*          MktEval  Evaluate an Experimental Design            */
 /*          MktEx    Efficient Experimental Designs             */
 /*          MktKey   Aid Making the MktRoll KEY= Data Set       */
 /*          MktLab   Change Names, Levels in a Design           */
 /*          MktMDiff MaxDiff (Best-Worst) Choice Modeling       */
 /*          MktMerge Merge a Choice Design with Choice Data     */
 /*          MktOrth  List Orthogonal Designs MktEx Can Make     */
 /*          MktPPro  Optimal Partial Profile Designs            */
 /*          MktRoll  Roll Out a Design Into a Choice Design     */
 /*          MktRuns  Experimental Design Sizes                  */
 /*          PhChoice Customize PROC PHREG for Choice Models     */
 /*                                                              */
 /****************************************************************/

************* Begin PHREG Output Customization **************;
options ls=80 ps=60 nonumber nodate;

%phchoice(on)

************** Begin Brand Choice Example Code **************;

%let m = 5;  /* Number of Brands in Each Choice Set */
             /* (including Other)                   */

title 'Brand Choice Example, Multinomial Logit Model';

proc format;
   value brand 1 = 'Brand 1' 2 = 'Brand 2' 3 = 'Brand 3'
               4 = 'Brand 4' 5 = 'Other';
   run;

data price;
   array p[&m] p1-p&m; /* Prices for the Brands */
   array f[&m] f1-f&m; /* Frequency of Choice   */

   input p1-p&m f1-f&m;
   keep subj set brand price c p1-p&m;

   * Store choice set and subject number to stratify;
   Set = _n_; Subj = 0;

   do i = 1 to &m;           /* Loop over the &m frequencies    */
      do ci = 1 to f[i];     /* Loop frequency of choice times  */
         subj + 1;           /* Subject within choice set       */
         do Brand = 1 to &m; /* Alternatives within choice set  */

            Price = p[brand];

            * Output first choice: c=1, unchosen: c=2;
            c = 2 - (i eq brand); output;
            end;
         end;
      end;

format brand brand.;

datalines;
3.99 5.99 3.99 5.99 4.99   4 29 16 42  9
5.99 5.99 5.99 5.99 4.99  12 19 22 33 14
5.99 5.99 3.99 3.99 4.99  34 26  8 27  5
5.99 3.99 5.99 3.99 4.99  13 37 15 27  8
5.99 3.99 3.99 5.99 4.99  49  1  9 37  4
3.99 5.99 5.99 3.99 4.99  31 12  6 18 33
3.99 3.99 5.99 5.99 4.99  37 10  5 35 13
3.99 3.99 3.99 3.99 4.99  16 14  5 51 14
;

proc print data=price(obs=15);
   var subj set c price brand;
   run;

proc print data=price(obs=5); run;

proc transreg design data=price nozeroconstant norestoremissing;
   model class(brand / zero=none) identity(price) / lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   label price = 'Price';
   id subj set c;
   run;

proc phreg data=coded brief;
   title2 'Discrete Choice with Common Price Effect';
   model c*c(2) = &_trgind / ties=breslow;
   strata subj set;
   run;

proc transreg design data=price nozeroconstant norestoremissing;
   model class(brand / zero=none separators='' ' ') |
         identity(price) / lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   label price = 'Price';
   id subj set c;
   run;

proc print data=coded(obs=10) label;
   title2 'Discrete Choice with Brand by Price Effects';
   var subj set c brand price &_trgind;
   run;

proc phreg data=coded brief;
   model c*c(2) = &_trgind / ties=breslow;
   strata subj set;
   run;

title2;

proc print data=price(obs=5) label;
   run;

proc transreg design data=price nozeroconstant norestoremissing;
   model class(brand / zero=none separators='' ' ') | identity(price)
         identity(p1-p&m) *
            class(brand / zero=none lprefix=0 separators='' ' on ') /
         lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   label price = 'Price'
         p1 = 'Brand 1' p2 = 'Brand 2' p3 = 'Brand 3'
         p4 = 'Brand 4' p5 = 'Other';
   id subj set c;
   run;

title2 'Discrete Choice with Cross-Effects, Mother Logit';
proc format; value zer 0 = '  0' 1 = '  1'; run;
proc print data=coded(obs=5) label; var subj set c brand price; run;
proc print data=coded(obs=5) label; var Brand:;
   format brand: zer5.2 brand brand.; run;
proc print data=coded(obs=5) label; var p1B:; format p: zer5.2; id brand; run;
proc print data=coded(obs=5) label; var p2B:; format p: zer5.2; id brand; run;
proc print data=coded(obs=5) label; var p3B:; format p: zer5.2; id brand; run;
proc print data=coded(obs=5) label; var p4B:; format p: zer5.2; id brand; run;
proc print data=coded(obs=5) label; var p5B:; format p: zer5.2; id brand; run;

%put &_trgind;

proc phreg data=coded brief;
   model c*c(2) = &_trgind / ties=breslow;
   strata subj set;
   run;

proc transreg design data=price nozeroconstant norestoremissing;
   model class(brand / zero='Other' separators='' ' ') | identity(price)
         identity(p1-p4) * class(brand / zero='Other' separators='' ' on ') /
         lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   label price = 'Price'
         p1 = 'Brand 1' p2 = 'Brand 2' p3 = 'Brand 3'
         p4 = 'Brand 4';
   id subj set c;
   run;

proc transreg design data=price nozeroconstant norestoremissing;
   model class(brand / zero='Other' separators='' ' ')
         identity(p1-p4) * class(brand / zero='Other' separators='' ' on ') /
         lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   label price = 'Price'
         p1 = 'Brand 1' p2 = 'Brand 2' p3 = 'Brand 3'
         p4 = 'Brand 4';
   id subj set c;
   run;

title 'Brand Choice Example, Multinomial Logit Model';
title2 'Aggregate Data';

%let m = 5;  /* Number of Brands in Each Choice Set */
             /* (including Other)                   */

proc format;
   value brand 1 = 'Brand 1' 2 = 'Brand 2' 3 = 'Brand 3'
               4 = 'Brand 4' 5 = 'Other';
   run;

data price2;
   array p[&m] p1-p&m; /* Prices for the Brands */
   array f[&m] f1-f&m; /* Frequency of Choice   */

   input p1-p&m f1-f&m;
   keep set price brand freq c p1-p&m;

   * Store choice set number to stratify;
   Set = _n_;

   do Brand = 1 to &m;

      Price = p[brand];

      * Output first choice: c=1, unchosen: c=2;
      Freq = f[brand]; c = 1; output;

      * Output number of times brand is not chosen.;
      freq = sum(of f1-f&m) - freq; c = 2; output;

      end;

format brand brand.;

datalines;
3.99 5.99 3.99 5.99 4.99   4 29 16 42  9
5.99 5.99 5.99 5.99 4.99  12 19 22 33 14
5.99 5.99 3.99 3.99 4.99  34 26  8 27  5
5.99 3.99 5.99 3.99 4.99  13 37 15 27  8
5.99 3.99 3.99 5.99 4.99  49  1  9 37  4
3.99 5.99 5.99 3.99 4.99  31 12  6 18 33
3.99 3.99 5.99 5.99 4.99  37 10  5 35 13
3.99 3.99 3.99 3.99 4.99  16 14  5 51 14
;

proc print data=price2(obs=10);
   var set c freq price brand;
   run;

proc transreg design data=price2 nozeroconstant norestoremissing;
   model class(brand / zero=none) identity(price) / lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   label price = 'Price';
   id freq set c;
   run;

proc phreg data=coded;
   title2 'Discrete Choice with Common Price Effect, Aggregate Data';
   model c*c(2) = &_trgind / ties=breslow;
   strata set;
   freq freq;
   run;

proc transreg design data=price2 nozeroconstant norestoremissing;
   model class(brand / zero=none separators='' ' ') |
         identity(price) / lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   label price = 'Price';
   id freq set c;
   run;

proc phreg data=coded;
   title2 'Discrete Choice with Brand by Price Effects, Aggregate Data';
   model c*c(2) = &_trgind / ties=breslow;
   strata set;
   freq freq;
   run;

%phchoice(off)
