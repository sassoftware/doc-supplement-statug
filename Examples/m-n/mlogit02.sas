 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MR2010F                                             */
 /*   TITLE: Discrete Choice 2                                   */
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

************* Begin Fabric Softener Example Code ************;

title 'Choice of Fabric Softener';

%mktruns(3 3 3 3)

%let n = 18;                     /* n choice sets                    */
%let m = 5;                      /* m alternative including constant */
%let mm1 = %eval(&m - 1);        /* m - 1                            */

proc format;                     /* create a format for the price    */
   value price 1 = '$1.49' 2 = '$1.99' 3 = '$2.49' . = '$1.99';
   run;

%mktex(3 ** 4, n=&n)

%mktex(3 ** 4, n=&n, seed=17)

* Due to machine differences, you might not get the same design if you run
* the step above, so here is the design that is used in the book;
data randomized; input x1-x4 @@; datalines;
2 2 2 3 3 1 1 2 1 3 3 1 3 2 3 2 1 1 1 3 1 3 2 2 3 2 2 1 3 3 1 1 2 1 3 1
1 1 2 1 2 3 1 3 1 2 1 2 2 2 1 1 1 2 3 3 3 1 3 3 2 3 3 2 2 1 2 2 3 3 2 3
;

data design; input x1-x4 @@; datalines;
1 1 1 1 1 1 2 2 1 2 1 3 1 2 3 1 1 3 2 3 1 3 3 2 2 1 1 3 2 1 3 1 2 2 2 2
2 2 3 3 2 3 1 2 2 3 2 1 3 1 2 3 3 1 3 2 3 2 1 2 3 2 2 1 3 3 1 1 3 3 3 3
;

proc print data=design; run;

%mkteval(data=design)

%mkteval(data=design, print=freqs)

data sasuser.SoftenerLinDes;
   set randomized;
   format x1-x&mm1 price.;
   label x1 = 'Sploosh' x2 = 'Plumbbob' x3 = 'Platter' x4 = 'Moosey';
   run;

proc print data=sasuser.SoftenerLinDes label; /* print final design */
   title2 'Efficient Design';
   run;

title2 'Key Data Set';

data key;
   input Brand $ Price $;
   datalines;
Sploosh   x1
Plumbbob  x2
Platter   x3
Moosey    x4
Another   .
;

proc print; run;

%mktroll(design=sasuser.SoftenerLinDes, key=key, alt=brand,
         out=sasuser.SoftenerChDes)

title2 'Linear Arrangement (First 3 Sets)';

proc print data=sasuser.SoftenerLinDes(obs=3); run;

title2 'Choice Design (First 3 Sets)';

proc print data=sasuser.SoftenerChDes(obs=15);
   format price price.;
   id set; by set;
   run;

title2 'Evaluate the Choice Design';

%choiceff(data=sasuser.SoftenerChDes,/* candidate set of choice sets        */
          init=sasuser.SoftenerChDes(keep=set),  /* select these sets       */
          intiter=0,                /* evaluate without internal iterations */
                                    /* main effects with ref cell coding    */
                                    /* ref level for brand is 'Another'     */
                                    /* ref level for price is $1.99         */
          model=class(brand price / zero='Another' '$1.99') /
                lprefix=0           /* lpr=0 labels created from just levels*/
                cprefix=0%str(;)    /* cpr=0 names created from just levels */
                format price price.,/* trick: format passed in with model   */

          nsets=&n,                 /* number of choice sets                */
          nalts=&m,                 /* number of alternatives               */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

title2 'Evaluate the Choice Design';
title3 'Standardized Orthogonal Contrast Coding';

%choiceff(data=sasuser.SoftenerChDes,/* candidate set of choice sets        */
          init=sasuser.SoftenerChDes(keep=set),  /* select these sets       */
          intiter=0,                /* evaluate without internal iterations */
                                    /* model with stdz orthogonal coding    */
                                    /* ref level for brand is 'Another'     */
                                    /* ref level for price is $1.99         */
          model=class(brand price / zero='Another' '$1.99' sta) /
                lprefix=0           /* lpr=0 labels created from just levels*/
                cprefix=0%str(;)    /* cpr=0 names created from just levels */
                format price price.,/* trick: format passed in with model   */

          nsets=&n,                 /* number of choice sets                */
          nalts=&m,                 /* number of alternatives               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=bestcov label;
   title3 'Variance-Covariance Matrix';
   id __label;
   label __label = '00'x;
   var Moosey -- _2_49;
   run;

title2 'Evaluate the Choice Design, Check for Duplicates';

%mktdups(branded, data=sasuser.SoftenerChDes, nalts=&m, factors=brand price)

%mktex(3 ** 4, n=81)

data TestLinDes;
   set design;
   format x1-x&mm1 price.;
   label x1 = 'Sploosh' x2 = 'Plumbbob' x3 = 'Platter' x4 = 'Moosey';
   run;

data key;
   input Brand $ Price $;
   datalines;
Sploosh   x1
Plumbbob  x2
Platter   x3
Moosey    x4
Another   .
;

%mktroll(design=TestLinDes, key=key, alt=brand, out=TestChDes)

%choiceff(data=TestChDes,           /* candidate set of choice sets         */
                                    /* model with stdz orthogonal coding    */
                                    /* ref level for brand is 'Another'     */
                                    /* ref level for price is $1.99         */
          model=class(brand price / zero='Another' '$1.99' sta) /
                lprefix=0           /* lpr=0 labels created from just levels*/
                cprefix=0%str(;)    /* cpr=0 names created from just levels */
                format price price.,/* trick: format passed in with model   */

          seed=205,                 /* random number seed                   */
          maxiter=50,               /* maximum number of designs to make    */
          nsets=&n,                 /* number of choice sets                */
          nalts=&m,                 /* number of alternatives               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%choiceff(data=sasuser.SoftenerChDes,/* candidate set of choice sets        */
          init=sasuser.SoftenerChDes(keep=set),  /* select these sets       */
          intiter=0,                /* evaluate without internal iterations */
          rscale=16.4264,           /* optimal D-efficiency                 */
                                    /* model with stdz orthogonal coding    */
                                    /* ref level for brand is 'Another'     */
                                    /* ref level for price is $1.99         */
          model=class(brand price / zero='Another' '$1.99' sta) /
                lprefix=0           /* lpr=0 labels created from just levels*/
                cprefix=0%str(;)    /* cpr=0 names created from just levels */
                format price price.,/* trick: format passed in with model   */

          nsets=&n,                 /* number of choice sets                */
          nalts=&m,                 /* number of alternatives               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

title;

data _null_;                     /* print questionnaire */
   array brands[&m] $ _temporary_ ('Sploosh' 'Plumbbob' 'Platter'
                                   'Moosey' 'Another');
   array x[&m] x1-x&m;
   file print linesleft=ll;
   set sasuser.SoftenerLinDes;

   x&m = 2;                     /* constant alternative */
   format x&m price.;

   if _n_ = 1 or ll < 12 then do;
      put _page_;
      put @60 'Subject: _________' //;
      end;

   put _n_ 2. ') Circle your choice of '
       'one of the following fabric softeners:' /;

   do brnds = 1 to &m;
      put '    ' brnds 1. ') ' brands[brnds] 'brand at '
          x[brnds] +(-1) '.' /;
      end;
   run;

title 'Choice of Fabric Softener';

data results;                    /* read choice data set */
   input Subj (choose1-choose&n) (1.) @@;
   datalines;
  1 334533434233312433  2 334213442433333325  3 333333333333313333
  4 334431444434412453  5 335431434233512423  6 334433434433312433
  7 334433434433322433  8 334433434433412423  9 334433332353312433
 10 325233435233332433 11 334233434433313333 12 334331334433312353
 13 534333334333312323 14 134421444433412423 15 334333435433312335
 16 334433435333315333 17 534333432453312423 18 334435544433412543
 19 334333335433313433 20 331431434233315533 21 334353534433512323
 22 334333452233312523 23 334333332333312433 24 525221444233322423
 25 354333434433312333 26 334435545233312323 27 334353534233352323
 28 334333332333332333 29 334433534335352423 30 334453434533313433
 31 354333334333312433 32 354331332233332423 33 334424432353312325
 34 334433434433312433 35 334551444453412325 36 334234534433312433
 37 334431434433512423 38 354333334433352523 39 334351334333312533
 40 324433334433412323 41 334433444433412443 42 334433434433312423
 43 334434454433332423 44 334433434233312423 45 334451544433412424
 46 434431435433512423 47 524434534433412433 48 335453334433322453
 49 334533434133312433 50 334433332333312423
;

proc format;
   value price 1 = '$1.49' 2 = '$1.99' 3 = '$2.49' . = '$1.99';
   run;

%mktmerge(design=sasuser.SoftenerChDes, data=results, out=res2,
          nsets=&n, nalts=&m, setvars=choose1-choose&n)

title2 'Choice Design and Data (First 3 Sets)';

proc print data=res2(obs=15);
   id subj set; by subj set;
   run;

data res3;   /* Create a numeric actual price */
   set res2;
   price = input(put(price, price.), dollar5.);
   label price = 'Price';
   run;

proc transreg design=5000 data=res3 nozeroconstant norestoremissing;
   model class(brand / zero=none order=data)
         identity(price) / lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   id subj set c;
   run;

proc print data=coded(obs=15) label;
   title2 'First 15 Observations of Analysis Data Set';
   id subj set c;
   by subj set;
   run;

proc phreg data=coded outest=betas brief;
   title2 'Discrete Choice Model';
   model c*c(2) = &_trgind / ties=breslow;
   strata subj set;
   run;

proc score data=coded(where=(subj=1) drop=c)
           score=betas type=parms out=p;
   var &_trgind;
   run;

data p2;
   set p;
   p = exp(c);
   run;

proc means data=p2 noprint;
   output out=s sum(p) = sp;
   by set;
   run;

data p;
   merge p2 s(keep=set sp);
   by set;
   p = p / sp;
   keep brand set price p;
   run;

proc print data=p(obs=15);
   title2 'Choice Probabilities for the First 3 Choice Sets';
   id set; by set;
   run;

%let forms = 50;
title2 'Create 50 Custom Questionnaires';

*---Make the design---;
%mktex(&forms &n &mm1, n=&forms * &n * &mm1)

*---Assign Factor Names---;
%mktlab(data=design, vars=Form Set Alt)

*---Set up for Random Ordering---;
data sasuser.orders;
   set final;
   by form set;
   retain r1;
   if first.set then r1 = uniform(17);
   r2 = uniform(17);
   run;

*---Random Sort---;
proc sort out=sasuser.orders(drop=r:); by form r1 r2; run;

proc print data=sasuser.orders(obs=16); run;

proc transpose data=sasuser.orders out=sasuser.orders(drop=_name_);
   by form notsorted set;
   run;

proc print data=sasuser.orders(obs=18);
   run;

ods listing close; /* suppress a LOT of output */

title;

data _null_;
   array brands[&mm1] $ _temporary_
                   ('Sploosh' 'Plumbbob' 'Platter' 'Moosey');
   array x[&mm1] x1-x&mm1;
   array c[&mm1] col1-col&mm1;
   format x1-x&mm1 price.;
   file print linesleft=ll;

   do frms = 1 to &forms;
      do choice = 1 to &n;
         if choice = 1 or ll < 12 then do;
            put _page_;
            put @60 'Subject: ' frms //;
            end;
         put choice 2. ') Circle your choice of '
             'one of the following fabric softeners:' /;
         set sasuser.orders;
         set sasuser.SoftenerLinDes point=set;
         do brnds = 1 to &mm1;
            put '    ' brnds 1. ') ' brands[c[brnds]] 'brand at '
                x[c[brnds]] +(-1) '.' /;
            end;
         put '    5) Another brand at $1.99.' /;
         end;
      end;
   stop;
   run;

ods listing;

title 'Choice of Fabric Softener';

data results;                    /* read choice data set */
   input Subj (choose1-choose&n) (1.) @@;
   datalines;
  1 524141141211421241  2 532234223321321311  3 223413221434144231
  4 424413322222544331  5 123324312534444533  6 233114423441143321
  7 123243224422433312  8 312432241121112412  9 315432222144111124
 10 511432445343442414 11 331244123342421432 12 323234114312123245
 13 312313434224435334 14 143433332142334114 15 234423133531441145
 16 425441421454434414 17 234431535341441432 18 235224352241523311
 19 134331342432542243 20 335331253334232433 21 513453254214134224
 22 212241213544214125 23 133444341431414432 24 453424142151142322
 25 324424431252444221 26 244145452131443415 27 553254131423323121
 28 233423242432231424 29 322454324541433543 30 323433433135133542
 31 412422434342513222 32 243144343352123213 33 441113141133454445
 34 131114113312342312 35 325222444355122522 36 342133254432124342
 37 511322324114234222 38 522153113442344541 39 211542232314512412
 40 244432222212213211 41 241411341323123213 42 314334342111232114
 43 422351321313343332 44 124243444234124432 45 141251113314352121
 46 414215225442424413 47 333452434454311222 48 334325341342552344
 49 335124122444243112 50 244412331342433332
;

proc transpose data=results   /* create one obs per choice set */
               out=res2(rename=(col1=choose) drop=_name_);
   by subj;
   run;

data res3(keep=subj set choose);
   array c[&mm1] col1-col&mm1;
   merge sasuser.orders res2;
   if choose < 5 then choose = c[choose];
   run;

proc sort; by subj set; run;

data _null_;
   set res3;
   by subj;
   if first.subj then do;
      if mod(subj, 3) eq 1 then put;
      put subj 4. +1 @@;
      end;
   put choose 1. @@;
   run;

%phchoice(off)
