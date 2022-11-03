 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MR2010F                                             */
 /*   TITLE: Discrete Choice 8                                   */
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

****************** Begin Chair Example Code *****************;

title 'Generic Chair Attributes';

* This design will not be used;
%mktex(3 ** 15, n=36, seed=238)

%mktkey(3 5)

%mktroll(design=randomized, key=key, out=cand)

%mktruns(3 ** 5)

%mktex(3 ** 5, n=243)

proc print data=design(obs=27); run;

%choiceff(data=design,              /* candidate set of alternatives        */
          model=class(x1-x5 / sta), /* model with stdzd orthogonal coding   */
          nsets=6,                  /* number of choice sets                */
          maxiter=100,              /* maximum number of designs to make    */
          seed=121,                 /* random number seed                   */
          flags=3,                  /* 3 alternatives, generic candidates   */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print; by set; id set; run;

%mktdups(generic, data=best, nalts=3, factors=x1-x5)

%mktex(3 ** 5, n=18)

%choiceff(data=design,              /* candidate set of alternatives        */
          model=class(x1-x5 / sta), /* model with stdzd orthogonal coding   */
          nsets=6,                  /* number of choice sets                */
          maxiter=20,               /* maximum number of designs to make    */
          seed=121,                 /* random number seed                   */
          flags=3,                  /* 3 alternatives, generic candidates   */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print; by set; id set; run;

%mktdups(generic, data=best, nalts=3, factors=x1-x5)

%mktex(3 ** 5, n=27, seed=382)

%choiceff(data=design,              /* candidate set of alternatives        */
          model=class(x1-x5 / sta), /* model with stdzd orthogonal coding   */
          nsets=9,                  /* number of choice sets                */
          maxiter=20,               /* maximum number of designs to make    */
          seed=121,                 /* random number seed                   */
          flags=3,                  /* 3 alternatives, generic candidates   */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print; id set; by set; var index prob x:; run;

%mktdups(generic, data=best, nalts=3, factors=x1-x5)

title 'Generic Chair Attributes';

%mktex(3 ** 5, n=243, seed=306)

data final(drop=i);
   set design end=eof;
   retain f1-f3 1 f4 0;
   output;
   if eof then do;
      array x[9] x1-x5 f1-f4;
      do i = 1 to 9; x[i] = i le 5 or i eq 9; end;
      output;
      end;
   run;

proc print data=final(where=(x1 eq x3 and x2 eq x4 and x3 eq x5 or f4)); run;

%choiceff(data=final,               /* candidate set of alternatives        */
          model=class(x1-x5 / sta), /* model with stdzd orthogonal coding   */
          nsets=6,                  /* number of choice sets                */
          maxiter=100,              /* maximum number of designs to make    */
          seed=121,                 /* random number seed                   */
          flags=f1-f4,              /* flag which alt can go where, 4 alts  */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print; by set; id set; run;

%mktdups(generic, data=best, nalts=4, factors=x1-x5)

%mktex(3 ** 15, n=81 * 81, seed=522)

%mktkey(3 5)

data key;
   input (x1-x5) ($);
   datalines;
x1     x2     x3     x4     x5
x6     x7     x8     x9     x10
x11    x12    x13    x14    x15
.      .      .      .      .
;

%mktroll(design=randomized, key=key, out=rolled)

* Code the constant alternative;
data final;
   set rolled;
   if _alt_ = '4' then do; x1 = 1; x2 = 1; x3 = 1; x4 = 1; x5 = 1; end;
   run;

proc print; by set; id set; where set in (1, 100, 1000, 5000, 6561); run;

%choiceff(data=final,               /* candidate set of choice sets         */
          model=class(x1-x5 / sta), /* model with stdzd orthogonal coding   */
          nsets=6,                  /* number of choice sets                */
          nalts=4,                  /* number of alternatives               */
          maxiter=10,               /* maximum number of designs to make    */
          seed=109,                 /* random number seed                   */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktdups(generic, data=best, nalts=4, factors=x1-x5)

%phchoice(off)
