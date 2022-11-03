 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MR2010F                                             */
 /*   TITLE: Discrete Choice 4                                   */
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

%let mktopts = noseed;

************* Begin PHREG Output Customization **************;
options ls=80 ps=60 nonumber nodate;

%phchoice(on)

*********** Begin Asymmetric Vacation Example Code **********;

title 'Vacation Example with Asymmetry';

%mktruns(3 ** 14 4 2 2)

%mktex(3 ** 13 4 3 2 2, n=36, seed=205)

%mkteval(data=randomized)

title 'Vacation Example with Asymmetry';
%mktruns(3 ** 13 4 3 2 2, interact=x1*x11 x2*x12 x3*x13 x4*x14 x5*x15, max=45)

%mktex(3 ** 13 4 3 2 2, n=72, seed=368,
       interact=x1*x11 x2*x12 x3*x13 x4*x14 x5*x15)

data mat;
   do a = 1 to 17;
      b = .;
      output;
      end;
   do a = 1 to 5;
      b = 10 + a;
      output;
      end;
   run;

proc print; run;

%mktex(3 ** 13 4 3 2 2,             /* all attrs of all alternatives        */
       n=72,                        /* number of choice sets                */
       seed=368,                    /* random number seed                   */
       order=matrix=mat,            /* identifies pairs of cols to work on  */
       interact=x1*x11 x2*x12 x3*x13 x4*x14 x5*x15) /* interactions         */

* Due to machine differences, you might not get the same design if you run
* the step above, so here is the design that is used in the book;
data randomized; input x1-x17 @@; datalines;
2 2 1 1 3 2 1 2 2 3 2 1 1 2 2 2 2 3 2 3 1 2 1 3 3 1 1 1 1 1 3 2 2 2 1 1
3 2 1 1 1 1 3 3 3 3 1 4 1 1 2 2 3 1 1 3 1 3 2 3 1 3 3 3 1 2 2 2 3 3 3 1
1 2 2 3 3 2 3 2 2 1 2 1 2 3 3 2 3 3 1 1 2 1 2 2 1 3 3 2 1 1 3 3 2 1 2 1
1 3 2 1 3 3 2 2 1 1 1 1 1 1 2 1 2 3 1 3 2 2 2 2 2 1 1 1 2 2 1 2 1 1 1 1
2 3 1 2 2 1 2 2 2 1 3 2 2 2 1 3 2 2 1 3 2 3 2 3 1 2 1 1 3 1 2 1 1 2 1 3
1 1 3 1 1 2 2 1 2 3 3 3 1 2 1 1 2 3 1 3 1 1 1 1 3 1 1 1 3 3 2 2 1 2 1 3
2 2 3 2 2 3 1 2 3 1 1 2 2 2 2 1 2 1 2 3 1 1 3 2 2 2 1 3 1 2 3 1 2 1 2 1
1 1 2 1 3 1 3 1 3 1 1 3 3 1 2 3 3 3 2 2 2 3 1 3 2 2 3 2 3 2 2 1 2 4 1 1
2 3 1 3 2 1 2 2 1 1 1 2 1 2 2 3 2 2 2 3 1 1 1 1 2 2 1 2 3 2 1 4 1 1 1 2
2 2 3 2 2 2 1 2 2 3 1 1 3 1 1 2 3 3 3 2 2 3 3 1 3 3 1 2 2 3 1 1 1 2 2 3
2 3 2 3 2 3 3 1 1 3 4 3 2 1 3 2 2 1 1 3 1 2 3 2 3 3 3 3 3 2 1 2 1 2 1 2
2 3 1 1 3 3 2 3 2 2 1 1 2 1 2 3 2 3 1 1 3 2 3 1 2 2 3 2 1 3 1 2 1 3 2 1
3 3 1 1 1 3 4 1 1 2 2 2 3 3 1 3 3 3 2 1 2 3 3 3 1 2 2 1 2 1 2 2 1 2 3 3
1 1 1 2 3 3 2 1 2 1 3 2 1 2 1 3 2 1 3 3 3 3 2 1 1 3 3 1 3 2 2 3 1 2 3 3
1 3 1 3 2 2 3 3 1 2 1 3 1 1 1 2 1 3 1 2 2 2 1 2 2 3 2 3 1 2 1 3 2 1 3 1
3 2 1 2 3 1 3 1 1 3 2 2 2 1 2 2 1 4 2 2 1 1 2 2 1 2 1 3 1 1 2 2 3 2 4 2
2 2 1 3 2 3 3 2 1 3 1 1 2 2 1 1 2 2 1 1 3 2 3 3 3 3 3 2 2 1 3 3 1 3 1 2
2 1 2 3 1 1 2 2 3 3 2 3 2 1 3 2 1 2 1 2 1 2 3 3 1 1 1 1 3 1 3 3 1 2 2 1
1 2 2 2 1 3 2 2 1 3 3 2 2 1 1 1 3 1 3 2 2 2 3 3 1 3 1 1 2 2 2 2 2 3 3 2
2 3 2 1 3 2 2 3 3 1 2 1 2 2 1 1 3 2 3 1 2 3 1 1 2 1 1 1 1 2 2 3 2 3 1 2
2 1 1 1 1 3 3 4 1 2 1 1 2 3 3 3 2 3 2 1 1 1 3 2 2 1 1 2 1 1 1 2 3 3 3 2
2 2 2 1 3 3 1 1 2 3 1 1 3 3 1 3 1 3 1 3 3 1 3 1 2 1 2 3 2 1 3 3 3 3 1 3
1 1 2 1 1 2 1 1 1 2 3 2 3 2 3 2 3 2 3 3 2 1 2 2 3 2 1 1 1 1 2 3 3 2 2 2
3 2 1 2 1 3 2 2 3 3 1 1 3 3 3 2 3 1 4 3 1 1 1 1 3 2 1 2 3 3 2 2 1 1 1 1
3 2 1 1 2 3 3 2 3 1 2 2 2 3 2 2 4 2 2 1 2 2 3 2 3 3 2 3 3 3 3 2 1 2 1 2
2 2 2 1 3 1 1 3 1 1 3 2 1 3 2 2 1 1 3 1 3 3 3 3 2 3 1 3 3 2 3 4 2 1 2 3
2 1 1 2 2 2 1 2 3 1 3 1 1 3 1 1 1 3 3 1 1 1 1 1 3 1 2 1 3 2 3 1 2 3 2 1
2 1 2 3 3 1 2 2 2 1 4 3 1 2 1 3 2 2 3 3 2 1 2 1 1 1 1 4 2 2 1 1 2 1 2 2
2 2 2 1 1 3 3 3 1 1 2 1 2 2 3 1 3 3 1 1 1 1 2 2 1 1 3 1 1 1 1 2 2 3 2 2
1 2 1 3 2 2 3 3 2 2 3 3 2 2 1 2 1 2 1 3 3 3 1 3 1 2 2 1 1 2 1 1 3 3 3 3
2 3 1 1 2 2 2 1 1 1 3 1 3 1 2 3 2 3 2 1 2 3 3 1 1 2 1 3 2 2 1 1 3 1 2 2
2 2 4 3 2 2 1 3 1 1 1 3 1 3 1 3 3 3 2 4 3 1 1 3 2 3 1 3 2 3 1 3 2 3 2 3
4 2 2 1 1 3 3 3 2 2 2 2 3 3 2 3 1 3 3 1 1 3 1 1 2 2 3 2 2 2 1 3 1 2 4 2
1 1 1 2 2 1 1 2 2 2 3 3 1 2 2 3 2 1 2 3 3 1 1 3 2 1 1 2 2 2 2 2 3 1 2 1
;
data design; input x1-x17 @@; datalines;
1 1 1 3 2 1 1 3 1 1 1 2 2 3 3 1 2 1 1 1 3 2 2 2 2 1 2 3 3 1 2 3 1 1 1 1
1 3 3 3 3 3 3 2 3 1 2 4 2 2 1 1 1 2 1 1 1 2 3 2 3 1 1 2 1 2 1 2 1 1 2 1
3 2 1 2 1 2 2 2 2 4 2 2 2 1 1 3 2 3 1 2 3 1 1 3 2 1 2 3 2 1 1 1 3 2 3 2
2 1 2 1 1 3 2 1 1 2 1 1 2 1 1 2 2 2 1 3 3 2 3 2 1 1 1 1 1 2 1 1 3 2 3 3
1 3 1 3 1 2 3 2 2 1 2 1 2 1 1 1 1 3 2 1 3 3 2 1 2 1 1 2 1 2 1 2 3 2 2 3
3 2 3 4 3 1 2 1 2 2 1 1 3 1 1 2 2 3 3 3 3 2 2 1 1 2 2 2 2 1 2 2 3 1 3 1
2 1 1 2 2 1 2 2 3 3 3 2 1 3 3 2 2 1 3 3 2 2 1 2 3 2 1 1 1 2 2 2 2 1 2 3
3 1 1 1 2 3 2 2 3 1 3 3 2 2 3 1 1 3 1 2 1 3 1 1 1 2 3 2 2 1 2 3 1 3 1 1
2 1 3 1 3 3 1 2 3 2 3 2 2 3 1 1 1 1 1 3 2 2 2 3 2 2 3 1 1 3 3 4 2 2 1 1
3 2 2 3 2 1 3 3 1 3 1 1 3 1 1 2 1 3 2 3 2 1 3 1 1 1 2 1 3 2 2 2 1 1 3 2
3 2 3 1 1 3 2 1 2 1 2 1 1 2 1 3 3 1 1 3 3 1 1 3 3 2 2 4 1 1 1 1 3 3 3 1
3 3 2 2 3 1 1 1 1 1 2 2 1 3 3 3 3 1 2 1 2 1 3 3 3 3 2 2 2 2 1 1 1 2 1 1
2 2 2 3 1 1 4 2 2 1 2 1 1 1 3 2 1 1 1 1 1 3 3 1 2 2 2 2 1 2 1 1 3 3 3 2
2 3 2 1 1 1 2 1 2 1 2 2 1 3 3 3 2 1 2 3 2 2 3 1 2 2 1 2 3 2 2 3 1 2 3 2
2 3 4 1 1 1 2 1 3 1 1 2 2 1 2 2 2 1 1 3 3 2 1 2 1 3 1 3 1 2 2 3 3 1 2 3
2 1 1 1 2 1 3 2 1 1 1 1 1 2 2 1 3 4 1 1 2 2 2 1 1 1 3 2 3 3 1 2 1 3 4 2
2 1 2 2 1 2 1 1 2 2 1 1 2 3 2 3 1 2 2 2 2 1 3 2 3 2 1 1 3 3 1 1 4 2 1 2
2 2 2 1 2 1 3 1 2 1 1 3 1 4 3 1 2 2 2 2 3 1 2 2 3 3 2 1 1 3 3 1 1 1 2 2
3 1 2 3 2 3 1 2 1 2 2 3 1 2 2 2 2 3 2 3 3 2 3 3 1 3 3 2 4 2 1 1 2 2 3 3
2 2 1 2 2 1 3 2 3 1 3 2 1 2 3 1 1 1 1 2 1 2 2 3 1 2 2 2 1 2 2 3 1 2 3 3
1 2 2 3 1 1 2 1 3 1 1 2 3 2 1 3 2 3 1 3 1 3 2 2 3 3 1 1 2 3 2 2 1 1 3 3
1 3 3 2 3 1 3 2 2 2 3 2 3 2 2 3 3 1 2 2 3 1 1 2 1 1 2 3 3 1 2 1 3 2 3 2
2 1 2 1 3 2 1 2 3 3 2 1 3 3 2 1 2 1 2 3 3 2 2 1 2 3 3 3 3 1 1 2 3 3 3 3
1 2 1 2 2 3 1 1 1 2 3 3 2 1 1 2 1 3 2 1 1 1 3 1 1 2 2 1 1 3 2 3 1 3 1 4
1 2 1 3 1 1 2 2 2 2 2 2 2 1 2 3 1 2 1 2 3 1 1 2 2 3 2 1 2 3 3 1 3 3 3 2
2 3 1 1 3 1 3 1 1 3 1 2 2 1 1 3 2 2 3 1 2 3 3 1 2 2 3 2 3 3 3 1 3 1 2 3
1 3 1 2 1 3 3 3 3 2 3 3 3 2 2 2 3 1 3 2 1 2 3 2 3 3 1 1 2 2 2 2 2 3 1 3
3 1 2 1 2 1 3 2 3 1 3 2 1 1 3 2 1 2 1 1 3 1 3 1 3 2 1 1 2 1 1 3 2 1 2 3
2 3 1 1 2 2 1 2 4 1 2 2 3 2 2 1 3 1 1 2 1 3 3 1 1 3 2 1 1 3 2 2 1 3 3 1
2 1 1 1 2 3 1 1 1 2 3 2 2 3 1 2 2 3 2 3 2 2 2 2 1 2 1 3 2 2 3 3 3 3 2 2
2 3 3 2 3 1 2 1 3 2 3 2 3 1 3 1 3 2 1 2 1 3 2 1 1 3 2 3 3 3 3 3 3 2 1 1
1 3 2 3 1 2 3 3 1 2 3 3 2 2 2 2 2 2 1 2 2 1 2 3 3 2 1 2 3 1 1 1 3 1 3 2
2 3 2 1 3 3 2 3 1 1 2 2 1 1 1 2 1 4 3 2 1 3 3 3 1 1 2 2 3 1 2 3 1 3 4 3
1 1 3 3 3 1 2 2 1 3 2 1 3 2 1 2 2 2 2 3 3 3 3 3 1 1 3 2 2 2 3 2 4 3 1 2
;

%mkteval(data=design)

%mktex(3 ** 13 4 3 2 2,             /* all attrs of all alternatives        */
       n=72,                        /* number of choice sets                */
       examine=i v,                 /* show information & variance matrices */
       options=check,               /* check initial design efficiency      */
       init=randomized,             /* initial design                       */
       interact=x1*x11 x2*x12 x3*x13 x4*x14 x5*x15) /* interactions         */

%mktblock(data=randomized, nblocks=4, out=sasuser.AsymVacLinDesBlckd, seed=114)

proc format;
   value price 1 = ' 999'      2 = '1249' 3 = '1499' 4 = '1749'  . = ' ';
   value scene 1 = 'Mountains' 2 = 'Lake'            3 = 'Beach' . = ' ';
   value lodge 1 = 'Cabin'     2 = 'Bed & Breakfast' 3 = 'Hotel' . = ' ';
   value side  1 = 'Side Trip' 2 = 'No'                          . = ' ';
   run;

data key;
   input Place $ 1-10 (Lodge Scene Price Side) ($);
   datalines;
Hawaii      x1  x6   x11  x16
Alaska      x2  x7   x12  .
Mexico      x3  x8   x13  x17
California  x4  x9   x14  .
Maine       x5  x10  x15  .
.           .   .    .    .
;

data temp;
   set sasuser.AsymVacLinDesBlckd(rename=(block=Form));
   x11 + 1;
   x12 + 1;
   run;

%mktroll(design=temp, key=key, alt=place, out=sasuser.AsymVacChDes,
         options=nowarn, keep=form)

data sasuser.AsymVacChDes;
   set sasuser.AsymVacChDes;
   format scene scene. lodge lodge. side side. price price.;
   run;

proc print data=sasuser.AsymVacChDes(obs=12);
   by form set; id form set;
   run;

title2 'Evaluate the Choice Design';

%choiceff(data=sasuser.AsymVacChDes,/* candidate set of choice sets         */
          init=sasuser.AsymVacChDes(keep=set), /* select these sets         */
          intiter=0,                /* evaluate without internal iterations */
                                    /* alternative-specific effects model   */
                                    /* zero=none - no ref levels for place  */
                                    /* order=data - do not sort levels      */
          model=class(place / zero=none order=data)
                                    /* zero=none - no ref levels any factor */
                                    /* order=formatted - sort levels        */
                                    /* use blank sep to build interact terms*/
                class(place * price place * scene place * lodge /
                      zero=none order=formatted separators='' ' ')
                                    /* no ref level for place               */
                                    /* ref level for side is 'No'           */
                                    /* use blank sep to build interact terms*/
                class(place * side / zero=' ' 'No' separators='' ' ') /
                lprefix=0           /* lpr=0 labels created from just levels*/
                cprefix=0,          /* cpr=0 names created from just levels */

          nsets=72,                 /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

ods listing close; /* suppress a LOT of output */

%let m   = 6;                    /* m alts including constant  */
%let mm1 = %eval(&m - 1);        /* m - 1                      */
%let n   = 18;                   /* number of choice sets      */
%let blocks = 4;                 /* number of blocks           */

title;
options ls=80 ps=60 nonumber nodate;

data _null_;
   array dests[&mm1] $ 10 _temporary_ ('Hawaii' 'Alaska' 'Mexico'
                                       'California' 'Maine');
   array scenes[3]   $ 13 _temporary_
                     ('the Mountains' 'a Lake' 'the Beach');
   array lodging[3]  $ 15 _temporary_
                     ('Cabin' 'Bed & Breakfast' 'Hotel');
   array x[15];
   array p[&mm1];
   length price $ 6;
   file print linesleft=ll;

   set sasuser.AsymVacLinDesBlckd;
   by block;

   p1 = 1499 + (x[11] - 2) * 250;
   p2 = 1499 + (x[12] - 2) * 250;
   p3 = 1249 + (x[13] - 2) * 250;
   p4 = 1374 + (x[14] - 2.5) * 250;
   p5 = 1249 + (x[15] - 2) * 250;

   if first.block then do;
      choice = 0;
      put _page_;
      put @50 'Form: ' block  ' Subject: ________' //;
      end;
   choice + 1;

   if ll < (19 + (x16 = 1) + (x17 = 1)) then put _page_;
   put choice 2. ') Circle your choice of '
       'vacation destinations:' /;

   do dest = 1 to &mm1;
      price = left(put(p[dest], dollar6.));
      put '    ' dest 1. ') ' dests[dest]
          +(-1) ', staying in a ' lodging[x[dest]]
          'near ' scenes[x[&mm1 + dest]] +(-1) ',' /
          +7 'with a package cost of ' price +(-1) @@;
      if dest = 3 and x16 = 1 then
         put ', and an optional visit' / +7
             'to archaeological sites for an additional $100' @@;
      else if dest = 1 and x17 = 1 then
         put ', and an optional helicopter' / +7
             'flight to an active volcano for an additional $200' @@;
      put '.' /;
      end;
   put "    &m) Stay at home this year." /;
   run;

ods listing;

data _null_;
   array dests[&mm1] _temporary_ (5 -1 4 3 2);
   array scenes[3]   _temporary_ (-1 0 1);
   array lodging[3]  _temporary_ (0 3 2);
   array u[&m];
   array x[15];

   do rep = 1 to 100;
      n = 0;
      do i = 1 to &blocks;
         k + 1;
         if mod(k,3) = 1 then put;
         put k 3. +1 i 1. +2 @@;
         do j = 1 to &n; n + 1;
            set sasuser.AsymVacLinDesBlckd point=n;
            do dest = 1 to &mm1;
               u[dest] = dests[dest] + lodging[x[dest]] +
                         scenes[x[&mm1 + dest]] -
                         x[2 * &mm1 + dest] +
                         2 * normal(17);
               end;

            u[1] = u[1] + (x16 = 1);
            u[3] = u[3] + (x17 = 1);
            u&m  = -3 + 3 * normal(17);
            m = max(of u1-u&m);
            if      abs(u1 - m) < 1e-4 then c = 1;
            else if abs(u2 - m) < 1e-4 then c = 2;
            else if abs(u3 - m) < 1e-4 then c = 3;
            else if abs(u4 - m) < 1e-4 then c = 4;
            else if abs(u5 - m) < 1e-4 then c = 5;
            else                            c = 6;
            put +(-1) c @@;
            end;
         end;
      end;
   stop;
   run;

title 'Vacation Example with Asymmetry';
%let m = 6; %let mm1 = %eval(&m - 1); %let n = 18; %let blocks = 4;
data results;
   input Subj Form (choose1-choose&n) (1.) @@;
   datalines;
  1 1 413414111315351335   2 2 115311141441134121   3 3 331451344433513341
  4 4 113111143133311314   5 1 113413531545431313   6 2 145131111414331511
  7 3 313413113111313331   8 4 415143311133541321   9 1 133314111133431113
 10 2 543311131111333413  11 3 241353113111313311  12 4 113111311133343311
 13 1 113411111131353334  14 2 441111531411131411  15 3 333311144111413311
 16 4 413111141133313311  17 1 133114111535451313  18 2 313311131311131313
 19 3 333115114111414311  20 4 113411313133333511  21 1 133411111133453335
 22 2 113335113443331331  23 3 153411113111413331  24 4 114111111333313311
 25 1 133511432133133335  26 2 541145131311134111  27 3 313311133131413331
 28 4 431111341331313351  29 1 143111151133431311  30 2 145341131311131411
 31 3 331353113111414311  32 4 414111143153343311  33 1 113111531113131313
 34 2 145111111413331313  35 3 311311113111113311  36 4 413111141334343633
 37 1 333414111112413354  38 2 441311133111131111  39 3 313313313111534331
 40 4 413111111333343331  41 1 511514111131455313  42 2 115341134441111441
 43 3 333411113111411331  44 4 133411413314113311  45 1 133311431113343344
 46 2 145141413341331113  47 3 133311111111413331  48 4 113411113331343311
 49 1 133311111133411113  50 2 115135143413333311  51 3 134351313111514331
 52 4 114111543433313351  53 1 114514431113151333  54 2 145133133451331113
 55 3 333311313111433311  56 4 534411115133513351  57 1 133311411111431333
 58 2 141311111141131511  59 3 333111111111413313  60 4 412411111433333313
 61 1 114511111343331133  62 2 545335113111131413  63 3 231311113111514335
 64 4 113131141433115133  65 1 113514111113431113  66 2 143313133441331311
 67 3 351413113135534313  68 4 114111113431533351  69 1 113313113111431331
 70 2 115315533311344311  71 3 353411313511513335  72 4 114411111133311311
 73 1 513514112533331333  74 2 413111133411133113  75 3 331411311111513311
 76 4 114411113333333311  77 1 133414111113531153  78 2 115113133445111323
 79 3 341413114111513331  80 4 413411111333313311  81 1 111311131513331313
 82 2 113313111311133411  83 3 341313113511413331  84 4 413111313133313311
 85 1 111414415143451136  86 2 415136331446131413  87 3 335511113151513311
 88 4 414111341431343151  89 1 131311131115451133  90 2 111311531411133311
 91 3 531113111111313311  92 4 413411113133313111  93 1 131311131133131331
 94 2 441111133441131311  95 3 333313111111313333  96 4 514111311133334331
 97 1 113311411113531311  98 2 143113131541131111  99 3 333413113131414331
100 4 114113313133331311 101 1 113511164113111433 102 2 141311113341333313
103 3 351413133115511311 104 4 115411341133113321 105 1 113414131115151135
106 2 115313131441131111 107 3 333313311111533311 108 4 413111151531313311
109 1 113414131113153333 110 2 415331111441131441 111 3 353411113111414311
112 4 113111143133313311 113 1 113111431115553313 114 2 545313511314333311
115 3 131313113151333331 116 4 114111141134313334 117 1 133311411113311315
118 2 113311111441133313 119 3 341314134411511315 120 4 113111111133333331
121 1 133431111113533335 122 2 443315141254131113 123 3 331311113113413331
124 4 414411113313311151 125 1 313411113113131133 126 2 145111133311331113
127 3 131414113111513311 128 4 414111351433343355 129 1 131311131115352333
130 2 415331131311131113 131 3 111114111111414351 132 4 114111511313343331
133 1 113514111313431333 134 2 143131131341331413 135 3 331313113111414311
136 4 114411141433313311 137 1 313411114113411333 138 2 113333113354331341
139 3 153411114153313335 140 4 114111311531513333 141 1 545511133113411141
142 2 165113113345131311 143 3 253411211111431351 144 4 113111111333313334
145 1 113211111543131154 146 2 445311111343134513 147 3 111314111131114331
148 4 113453415313131331 149 1 243314431335151113 150 2 415343113651111313
151 3 143314113111313111 152 4 115113513333313321 153 1 555311111511351331
154 2 445311111111134323 155 3 144453113111513331 156 4 112111111334531351
157 1 111414431335444115 158 2 415111131141131333 159 3 351511111111513311
160 4 113111311134313333 161 1 115411111131511313 162 2 455313111144131411
163 3 211413111111414315 164 4 113111111153343311 165 1 143211133113411133
166 2 111315331323331113 167 3 133341111131313331 168 4 114411151133341313
169 1 143511132115431313 170 2 145111111341331123 171 3 331311113131411315
172 4 414111151114313334 173 1 313514111513551113 174 2 141141131541344513
175 3 141313313113413315 176 4 434113111433143343 177 1 113414111543334333
178 2 345311111441111321 179 3 131411113111413311 180 4 115111313133533334
181 1 153413111545351335 182 2 145341111351131111 183 3 313133313411413341
184 4 413111111533343331 185 1 131411111111131133 186 2 445313111311351423
187 3 141311143111513331 188 4 414111111133333333 189 1 131311111333153151
190 2 115335111441334411 191 3 333311111151413413 192 4 413111111543131311
193 1 533113111513551331 194 2 345135113444333511 195 3 343314114111413311
196 4 433111151133363331 197 1 133515131113353113 198 2 141314131341131141
199 3 151311111151313331 200 4 115513311131133111 201 1 133413413336133133
202 2 415111131311334411 203 3 131311111111414311 204 4 114141113333313331
205 1 133411411531411311 206 2 115333111464331113 207 3 153413214451314315
208 4 133411331113313533 209 1 113511111313431331 210 2 111113111111333313
211 3 131311113511413311 212 4 433111151433533311 213 1 113511111343332111
214 2 145311113121331111 215 3 331151113411413331 216 4 413111113131133311
217 1 113311111133351313 218 2 113111331441331313 219 3 331311143111633351
220 4 413111413334233311 221 1 113413111513541351 222 2 245143111441331111
223 3 331111334111531331 224 4 115111313331341344 225 1 113413313315443315
226 2 115113131341133313 227 3 115414111111514311 228 4 413141111133333333
229 1 133513114135141331 230 2 543311133411131411 231 3 141413111411311311
232 4 113141133133343311 233 1 133511111135133131 234 2 131113333411331313
235 3 143311113131531331 236 4 415111151113313311 237 1 131511131113153133
238 2 145111131541131313 239 3 331413113115413311 240 4 111411331333143315
241 1 133414133313143313 242 2 113341111411331313 243 3 334314114131113331
244 4 114411151314343111 245 1 133411113133151314 246 2 141431513451331311
247 3 331453133115413331 248 4 113111113133311111 249 1 133311113113411343
250 2 415343113441133313 251 3 331311113111433311 252 4 413111113333131321
253 1 513113111513553134 254 2 313111131441631111 255 3 151313114411315311
256 4 414111111134543311 257 1 113311133133351313 258 2 145331111341331413
259 3 141311113111433361 260 4 114111343133413311 261 1 331411131535311333
262 2 115111131351131311 263 3 133311114115533331 264 4 114111111333313311
265 1 133514162113151334 266 2 515111511343134411 267 3 131553114111413331
268 4 413111111333311351 269 1 133331131113151335 270 2 345114111151334311
271 3 333411114115514331 272 4 514414431431313331 273 1 133413433113151313
274 2 415135513341331113 275 3 333353144111411311 276 4 113111511134341314
277 1 433513131111331311 278 2 345311113111331111 279 3 343113113113314331
280 4 134113141133313311 281 1 313311311313453311 282 2 145341131345333143
283 3 331411113411313335 284 4 514411533313343331 285 1 113414134133531133
286 2 115131531114131113 287 3 141413111111414311 288 4 113411541134533311
289 1 133311431535313331 290 2 115311131311133511 291 3 153454111111511335
292 4 454411113334333311 293 1 133111431143553333 294 2 441311131441131111
295 3 332413113111513331 296 4 111411113133141321 297 1 145333211133554133
298 2 115311511444111311 299 3 161454111131514313 300 4 113111411154333311
301 1 113314111132351133 302 2 143311131241331113 303 3 355311113111411311
304 4 413111141133333331 305 1 313211433513541333 306 2 134313111421333111
307 3 345511113111413311 308 4 414113341133533313 309 1 433411111513331351
310 2 145411316311131311 311 3 351534111151413331 312 4 413111111533331311
313 1 111411111113451313 314 2 413311133413133313 315 3 313451113113514311
316 4 413113611113363313 317 1 133111511111313113 318 2 343413513424331311
319 3 131311143111313311 320 4 411411113353511341 321 1 133554131133431113
322 2 141111111411133133 323 3 135354114113413311 324 4 114111311333331311
325 1 133414114113151133 326 2 145341131341333113 327 3 231111113111111311
328 4 113411113131441331 329 1 115314111135431133 330 2 445411311441133313
331 3 153351114111315335 332 4 415111143333343311 333 1 533311434343151334
334 2 141313131441131313 335 3 331414113115533311 336 4 134411113331341311
337 1 333414431315331113 338 2 431331131311331411 339 3 133411113151513331
340 4 414111353334333111 341 1 113514111115411311 342 2 145311113413131313
343 3 133311111114513331 344 4 114411341131513321 345 1 513213111115451331
346 2 115311131351133411 347 3 333411113435413351 348 4 114111353134311331
349 1 133411111113131333 350 2 445115111311334311 351 3 331413111111433311
352 4 412111153333114311 353 1 113311111531431333 354 2 113315131311331313
355 3 333411144131413331 356 4 414111353134331151 357 1 533411111131343333
358 2 115363131311331311 359 3 333213113131314311 360 4 414141153133113311
361 1 533514111313411113 362 2 443311111351331311 363 3 141411114131431311
364 4 111111151434315351 365 1 443314131115441333 366 2 545141111441133313
367 3 131311113131511311 368 4 111111153333343321 369 1 311311114145333311
370 2 541313111343333413 371 3 141413134131311331 372 4 413411443333513311
373 1 133411113513153133 374 2 543321331411131513 375 3 333413313111514331
376 4 114411153114311311 377 1 113514111113441113 378 2 113313111441334111
379 3 311413144151411311 380 4 114111141134113321 381 1 133114111115411113
382 2 545311511411131411 383 3 253411114311313311 384 4 114411113633333311
385 1 123411411533151115 386 2 145131111411334111 387 3 131113113111413311
388 4 411111111333344311 389 1 113514111313431134 390 2 645111113314331121
391 3 133313133531514311 392 4 113141313134311311 393 1 111511111315131343
394 2 411113111151113321 395 3 133111111511514311 396 4 114111111331313341
397 1 331311431513163313 398 2 115133111313133111 399 3 313311114111413311
400 4 115511141534111131
;

%mktmerge(design=sasuser.AsymVacChDes, data=results, out=res2, blocks=form,
          nsets=&n, nalts=&m, setvars=choose1-choose&n,
          stmts=%str(price = input(put(price, price.), 5.);
                     format scene scene. lodge lodge. side side.;))

proc print data=res2(obs=18);
   id form subj set; by form subj set;
   run;

proc transreg design=5000 data=res2 nozeroconstant norestoremissing;
   model class(place / zero=none order=data)
         class(price scene lodge / zero=none order=formatted)
         class(place * side / zero=' ' 'No' separators='' ' ') /
         lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   id subj set form c;
   run;

proc print data=coded(obs=6) label;
   run;

proc phreg data=coded brief;
   model c*c(2) = &_trgind / ties=breslow;
   strata subj set;
   run;

proc summary data=coded nway;
   class form set c &_trgind;
   output out=agg(drop=_type_);
   run;

proc phreg data=agg;
   model c*c(2) = &_trgind / ties=breslow;
   freq _freq_;
   strata form set;
   run;

%phchoice(off)