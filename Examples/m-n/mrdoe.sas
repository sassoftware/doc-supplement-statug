 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MR2010C                                             */
 /*   TITLE: Experimental Design, Efficiency, Coding, and Choice */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: marketing research                                  */
 /*   PROCS: IML                                                 */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: MR-2010C Experimental Design: ...                   */
 /*    MISC: This file contains all of the sample code for       */
 /*          the "Experimental Design: Efficiency, Coding,       */
 /*          and Choice Designs" report,                         */
 /*          the 01Oct2010 edition, for SAS 9.2.                 */
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

proc iml;
   x = designf((1:5)`);          /* X = effects coding,  A = X * inv(T)     */
   call gsorth(a,t,b,x);         /* A = Gram-Schmidt orthogonalization of X */
   print "Orthogonal Contrast Coding" /
         (a * inv(diag(a[1:ncol(a),])) * diag(1:ncol(a)));
   print "Standardized Orthogonal Contrast Coding" /
         (a * sqrt(nrow(a)));
   quit;

*********** Begin Orthogonal Coding Example Code ************;

options ls=80 ps=60 nonumber nodate;
title;

proc iml; /* orthogonal coding, levels must be 1, 2, ..., m */
   reset fuzz;

   start orthogcode(x);
      levels = max(x);
      xstar  = shape(x, levels - 1, nrow(x))`;
      j = shape(1 : (levels - 1), nrow(x), levels - 1);
      r = sqrt(levels # (x / (x + 1))) # (j = xstar) -
          sqrt(levels / (j # (j + 1))) # (j > xstar | xstar = levels);
      return(r);
      finish;

   Design = (1:2)` @ j(6, 1, 1) || {1, 1} @ (1:6)`;
   X = j(12, 1, 1) || orthogcode(design[,1]) || orthogcode(design[,2]);
   print design[format=1.]  '  '
         x[format=5.2 colname={'Int' 'Two' 'Six'} label=' '];

   XpX = x` * x;     print xpx[format=best5.];
   Inv = inv(xpx);   print inv[format=best5.];
   d_eff = 100 / (nrow(x) #   det(inv) ## (1 / ncol(inv)));
   a_eff = 100 / (nrow(x) # trace(inv)       / ncol(inv));
   print    'D-efficiency =' d_eff[format=6.2 label=' ']
         '   A-efficiency =' a_eff[format=6.2 label=' '];

   design = design[1:10,];
   x = j(10, 1, 1) || orthogcode(design[,1]) || orthogcode(design[,2]);
   inv = inv(x` * x);
   d_eff = 100 / (nrow(x) #   det(inv) ## (1 / ncol(inv)));
   a_eff = 100 / (nrow(x) # trace(inv)       / ncol(inv));
   print    'D-efficiency =' d_eff[format=6.2 label=' ']
         '   A-efficiency =' a_eff[format=6.2 label=' '];
   quit;

%mktex(3 ** 4,                      /* set number and factor levels         */
       n=9)                         /* num of sets times num of alts (3x3)  */

%mktlab(data=design,                /* design from MktEx                    */
        vars=Set x1-x3)             /* new variable names                   */

%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          model=class(x1-x3 / sta), /* model with stdzd orthogonal coding   */
          nsets=3,                  /* 3 choice sets                        */
          nalts=3,                  /* 3 alternatives per set               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=bestcov label;      /* covariance matrix from ChoicEff      */
   title 'Variance-Covariance Matrix';
   id __label;
   label __label = '00'x;           /* hex null suppress label header       */
   var x:;
   run;

title;

data final;                          /* random design                       */
   do Set = 1 to 3;                  /* 3 choice sets                       */
      do Alt = 1 to 3;               /* 3 alternatives                      */
         x1 = ceil(3 * uniform(151));/* random levels for each attr         */
         x2 = ceil(3 * uniform(151));
         x3 = ceil(3 * uniform(151));
         output;
         end;
      end;
   run;

%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          model=class(x1-x3 / sta), /* model with stdzd orthogonal coding   */
          nsets=3,                  /* 3 choice sets                        */
          nalts=3,                  /* 3 alternatives per set               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=bestcov label;      /* covariance matrix from ChoicEff      */
   title 'Variance-Covariance Matrix';
   id __label;
   label __label = '00'x;           /* hex null suppress label header       */
   var x:;
   run;

title;

%mktex(3 ** 3,                      /* just the factor levels               */
       n=27)                        /* number of candidate alts             */

%mktlab(data=design,                /* design from MktEx                    */
        int=f1-f3)                  /* flag which alt can go where, 3 alts  */

data final;                         /* all candidates go to alt 1 and 2     */
   set final;                       /* x1=2 x2=2 x3=2 also goes to alt 3    */
   f3 = (x1 eq 2 and x2 eq 2 and x3 eq 2);
   run;

%choiceff(data=final,               /* candidate set of alternatives        */
          model=class(x1-x3 / sta), /* model with stdzd orthogonal coding   */
          seed=205,                 /* random number seed                   */
          nsets=3,                  /* 3 choice sets                        */
          flags=f1-f3,              /* flag which of the 3 alts go where    */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=bestcov label;      /* covariance matrix from ChoicEff      */
   title 'Variance-Covariance Matrix';
   id __label;
   label __label = '00'x;           /* hex null suppress label header       */
   var x:;
   run;

title;

%choiceff(data=final,               /* candidate set of alternatives        */
          model=class(x1-x3 / sta), /* model with stdzd orthogonal coding   */
          seed=205,                 /* random number seed                   */
          nsets=3,                  /* 3 choice sets                        */
          flags=f1-f3,              /* flag which of the 3 alts go where    */
          rscale=1.5874,            /* scale using previous D-efficiency    */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=bestcov label;      /* covariance matrix from ChoicEff      */
   title 'Variance-Covariance Matrix';
   id __label;
   label __label = '00'x;           /* hex null suppress label header       */
   var x:;
   run;

title;

data x;
   input Brand $ x1-x2;
   datalines;
A 1 1
A 1 2
A 2 1
A 2 2
B 1 1
B 1 2
B 2 1
B 2 2
C 1 1
C 1 2
C 2 1
C 2 2
;

proc transreg design data=x;
   model class(brand / lprefix=0)
         class(brand * x1 brand * x2 / sta zero=' ' lprefix=0 2 2);
   output out=coded(drop=_: in:) separators='' ' ';
   run;

proc print label noobs; run;

proc transreg design data=x;
   model class(brand | x1 brand | x2 / sta zero=' ' lprefix=0 2 2);
   output out=coded separators='' ' ';
   run;

proc print label noobs;
   var BrandA BrandB BrandC x11 x21 BrandAx11 BrandBx11 BrandCx11
       BrandAx21 BrandBx21 BrandCx21;
   run;

proc format;
   value price  1 = $2.89 2 = $2.99 3 = $3.09 4 = $3.19 5 = $3.29
                6 = $2.89           7 = $3.09           8 = $3.29;
   run;

%mktex(3 ** 6 6,                    /* factors, difference scheme in 3 ** 6 */
       n=18,                        /* number of runs in full design        */
       options=nosort,              /* do not sort the design               */
       levels=0)                    /* make levels 0, 1, 2 (not 1, 2, 3)    */

proc print data=design(obs=6) noobs; var x1-x6; run;

data choice(keep=set x1-x6);
   Set = _n_;
   set design(obs=6);
   array x[6];
   do i = 1 to 6; x[i] + 1; end;
   output;
   do i = 1 to 6; x[i] = mod(x[i], 3) + 1; end;
   output;
   do i = 1 to 6; x[i] = mod(x[i], 3) + 1; end;
   output;
   run;

proc print; id set; by set; run;

%mktex(4 2 ** 4,                    /* choice set number and attr levels    */
       seed=368,                    /* random number seed                   */
       n=8)                         /* 8 runs - 4 sets, two alts each       */

%mktlab(data=randomized,            /* randomized design                    */
        vars=Set x1-x4)             /* var names for set var and for attrs  */

proc sort; by set; run;

proc print; by set; id set; run;

%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          model=class(x1-x4 / sta), /* model with stdzd orthogonal coding   */
          nsets=4,                  /* 4 choice sets                        */
          nalts=2,                  /* 2 alternatives per set               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(9 3 ** 9,                    /* choice set number and attr levels    */
       seed=420,                    /* random number seed                   */
       n=27)                        /* 27 runs - 9 sets, 3 alts each        */

%mktlab(data=randomized,            /* randomized design                    */
        vars=Set x1-x9)             /* var names for set var and for attrs  */

proc sort; by set; run;

proc print; by set; id set; run;

%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          model=class(x1-x9 / sta), /* model with stdzd orthogonal coding   */
          nsets=9,                  /* 9 choice sets                        */
          nalts=3,                  /* 3 alternatives per set               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(8 4 ** 8,                    /* choice set number and attr levels    */
       seed=396,                    /* random number seed                   */
       n=32)                        /* 32 runs - 8 sets, four alts each     */

%mktlab(data=randomized,            /* randomized design                    */
        vars=Set x1-x8)             /* var names for set var and for attrs  */

proc sort; by set; run;

proc print; by set; id set; run;

%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          model=class(x1-x8 / sta), /* model with stdzd orthogonal coding   */
          nsets=8,                  /* 8 choice sets                        */
          nalts=4,                  /* 4 alternatives per set               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktorth(maxn=100,                  /* output up to 100 runs                */
         options=parent)            /* just list the parent designs         */

data x;
   set mktdeslev;
   array x[50];
   gotone = 0;
   do p = 50 to 1 by -1 until(gotone);
      if x[p] eq 1 then gotone = 1;
      end;
   if not gotone then do;
      p = sqrt(n);
      if abs(p * p - n) < 1e-8 then if x[p] then gotone = 1;
      end;
   if gotone then do;
      m = n / p;
      if m eq p then x[m] + -1;
      q = x[m];
      design = compbl(put(m, 5.) || ' ** ' || put(q, 5.));
      From   = compbl(put(p, 5.) || ' ** 1 ' ||
                      trim(design) || ', n=' || put(n, 5. -L));
      if (n le 10 and q > 1) or (n gt 10 and q > 2) then output;
      end;
   run;

proc sort;
   by n p descending q;
   run;

data list(keep=sets alts design from);
   length Sets Alts 8;
   set x;
   by n p;
   if first.p;
   sets = p;
   alts = n / p;
   run;

proc sort;
   by sets descending alts;
   run;

proc print; by sets; id sets; run;

%let p = 6;                         /* p - number of choice sets            */
%let m = 3;                         /* m-level factors                      */
%let q = &p;                        /* q - number of factors                */

%mktex(&p &m ** &q,                 /* choice set number and attr levels    */
       n=&p * &m)                   /* p * m runs - p sets, m alts each     */

%mktlab(data=design,                /* orthogonal array                     */
        vars=Set x1-x&q)            /* var names for set var and for attrs  */

proc print; id set; by set; run;

%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          model=class(x1-x&q / sta),/* model with stdzd orthogonal coding   */
          nsets=&p,                 /* &p choice sets                       */
          nalts=&m,                 /* &m alternatives per set              */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc format;
   value zer -1e-12 - 1e-12 = ' 0   ';
   run;

proc print data=bestcov label;
   id __label;
   label __label = '00'x;
   var x:;
   format _numeric_ zer5.2;
   run;

%mktex(12 2 ** 27 3 ** 11 6,        /* Set and factor levels                */
       n=72)                        /* num of sets times num of alts (12x6) */

%mktlab(data=design,                /* design from MktEx                    */
        vars=Set x1-x39)            /* new variable names                   */

%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          model=class(x1-x39 / sta),/* model with stdzd orthogonal coding   */
          nsets=12,                 /* 12 choice sets                       */
          nalts=6,                  /* 6 alternatives per set               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print; by set; id set; var x:; run;

proc iml;
   use bestcov(keep=x:); read all into x;
   x = round(shape(x,1)`, 1e-12);
   create veccov from x; append from x;
   quit;

proc freq; run;

%mktex(6 4,                         /* factor levels                        */
       n=12,                        /* 12 runs                              */
       seed=513,                    /* random number seed                   */
       options=nohistory)           /* do not print iteration history       */

proc print; run;

proc transpose data=design out=bd(drop=x1 _:) prefix=b; by x1; run;

proc print; run;

%mktbibd(b=6,                       /* 6 blocks                             */
         t=4,                       /* 4 treatments                         */
         k=2,                       /* 2 treatments in each block           */
         seed=350)                  /* random number seed                   */

%mktbibd(b=5,                       /* 5 blocks                             */
         t=5,                       /* 5 treatments                         */
         k=2,                       /* 2 treatments in each block           */
         seed=420)                  /* random number seed                   */

%mktbibd(b=4,                       /* 4 blocks                             */
         t=5,                       /* 5 treatments                         */
         k=2,                       /* 2 treatments in each block           */
         seed=420)                  /* random number seed                   */

%mktbsize(t=5,                      /* 5 treatments                         */
         k=2 to 3,                  /* 2 or 3 treatments per block          */
         b=2 to 20)                 /* between 2 and 20 blocks              */

%mktbsize(t=5,                      /* 5 treatments                         */
         k=2 to 3,                  /* 2 or 3 treatments per block          */
         b=2 to 20,                 /* between 2 and 20 blocks              */
         options=ubd)               /* also show unbalanced block designs   */

%mktbsize(t=5,                      /* 5 treatments                         */
         k=2 to 3,                  /* 2 or 3 treatments per block          */
         b=2 to 20,                 /* between 2 and 20 blocks              */
         options=ubd,               /* also show unbalanced block designs   */
         maxreps=2)                 /* allow 1 or 2 replications            */

%mktbsize(nattrs=5,                 /* 5 attributes                         */
         setsize=2 to 3,            /* 2 or 3 attributes per set            */
         nsets=2 to 20)             /* between 2 and 20 sets                */

title 'Cereal Bars';

%mktruns(4 2  4 2  4 2)     /* factor level list for all attrs and alts     */

%mktex(4 2  4 2  4 2,       /* factor level list for all attrs and alts     */
       n=16,                /* number of choice sets                        */
       seed=17)             /* random number seed                           */

* Due to machine differences, you might not get the same designs
so here is the design that is used in the book;
data randomized; input x1-x6 @@; datalines;
1 1 2 1 2 1 4 1 2 2 4 2 3 2 2 1 3 2 3 1 4 1 4 1 2 2 2 2 1 1 4 1 1 1 1 1
3 2 1 2 2 1 1 2 3 2 4 1 2 1 4 2 2 2 1 2 4 1 1 2 4 2 4 2 3 1 2 1 3 1 3 1
2 2 1 1 4 2 1 1 1 2 3 2 3 1 3 2 1 2 4 2 3 1 2 2
;

title2 'Examine Correlations and Frequencies';

%mkteval(data=randomized)   /* evaluate randomized design                   */

title2 'Examine Design';
proc print data=randomized; run;

%mktkey(3 2)                /* x1-x6 (since 3*2=6) in 3 rows and 2 columns  */

title2 'Create the Choice Design Key';

data key;
   input
Brand $ 1-12    Price $    Count $; datalines;
Branolicious    x1         x2
Brantopia       x3         x4
Brantasia       x5         x6
None            .          .
;

title2 'Create Choice Design from Linear Arrangement';

%mktroll(design=randomized,  /* input randomized linear arrangement         */
         key=key,            /* rules for making choice design              */
         alt=brand,          /* brand or alternative label var              */
         out=cerealdes)      /* output choice design                        */

proc print; id set; by set; run;

title2 'Final Choice Design';

proc format;
   value price 1 = $2.89 2 = $2.99 3 = $3.09 4 = $3.19 . = ' ';
   value count 1 = 'Six Bars' 2 = 'Eight Bars'  . = ' ';
   run;

data sasuser.cerealdes;
   set cerealdes;
   format price price. count count.;
   run;

proc print data=sasuser.cerealdes(obs=16);
   by set;   id set;
   run;

title2 'Evaluate Design';

%choiceff(data=sasuser.cerealdes,          /* candidate choice sets         */
          init=sasuser.cerealdes(keep=set),/* select these sets from cands  */
          intiter=0,                       /* eval without internal iters   */
          model=class(brand price count),  /* model, ref cell coding        */
          nalts=4,                         /* number of alternatives        */
          nsets=16,                        /* number of choice sets         */
          beta=zero)                       /* assumed beta vector, Ho: b=0  */

proc format;
   value zer -1e-12 - 1e-12 = ' 0   ';
   run;

proc print data=bestcov label;
   id __label;
   label __label = '00'x;
   var BrandBranolicious -- CountSix_Bars;
   format _numeric_ zer5.2;
   run;

%choiceff(data=sasuser.cerealdes,          /* candidate choice sets         */
          init=sasuser.cerealdes(keep=set),/* select these sets from cands  */
          intiter=0,                       /* eval without internal iters   */
                                           /* model with stdz orthog coding */
          model=class(brand price count / sta),
          nalts=4,                         /* number of alternatives        */
          nsets=16,                        /* number of choice sets         */
          options=relative,                /* display relative D-efficiency */
          beta=zero)                       /* assumed beta vector, Ho: b=0  */

proc print data=bestcov label;
   id __label;
   label __label = '00'x;                  /* hex null suppress label header*/
   var BrandBranolicious -- CountSix_Bars;
   format _numeric_ zer5.2;
   run;

title2 'Evaluate Design for Alternative-Specific Model';

%choiceff(data=sasuser.cerealdes,          /* candidate choice sets         */
          init=sasuser.cerealdes(keep=set),/* select these sets from cands  */
          intiter=0,                       /* eval without internal iters   */
                                           /* alternative-specific model    */
                                           /* stdzd orthogonal coding       */
          model=class(brand brand*price brand*count / sta) /
                cprefix=0                  /* lpr=0 labels from just levels */
                lprefix=0,                 /* cpr=0 names from just levels  */
          nalts=4,                         /* number of alternatives        */
          nsets=16,                        /* number of choice sets         */
          options=relative,                /* display relative D-efficiency */
          beta=zero)                       /* assumed beta vector, Ho: b=0  */

%macro printcov(vars);
   proc print data=bestcov label;
      id __label;
      label __label = '00'x;
      var &vars;
      format _numeric_ zer5.2;
      run;
   %mend;

%printcov(Branolicious Brantasia Brantopia)
%printcov(Branolicious_2_89 Branolicious_2_99 Branolicious_3_09)
%printcov(Brantasia_2_89 Brantasia_2_99 Brantasia_3_09)
%printcov(Brantopia_2_89 Brantopia_2_99 Brantopia_3_09)
%printcov(BranoliciousSix_Bars BrantasiaSix_Bars BrantopiaSix_Bars)

%mktdups(branded,                         /* a design with brands           */
         data=sasuser.cerealdes,          /* the input design to evaluate   */
         factors=brand price count,       /* factors in the design          */
         nalts=4)                         /* number of alternatives         */

title2 'Read Data';

data results;
   input Subject (r1-r16) (1.);
   datalines;
  1 1331132331312213
  2 3231322131312233
  3 1233332111132233
  4 1211232111313233
  5 1233122111312233
  6 3231323131212313
  7 3231232131332333
  8 3233332131322233
  9 1223332111333233
 10 1332132111233233
 11 1233222211312333
 12 1221332111213233
 13 1231332131133233
 14 3211333211313233
 15 3313332111122233
 16 3321123231331223
 17 3223332231312233
 18 3211223311112233
 19 1232332111132233
 20 1213233111312413
 21 1333232131212233
 22 3321322111122231
 23 3231122131312133
 24 1232132111311333
 25 3113332431213233
 26 3213132141331233
 27 3221132111312233
 28 3222333131313231
 29 1221332131312231
 30 3233332111212233
 31 1221332111342233
 32 2233232111111211
 33 2332332131211231
 34 2221132211312411
 35 1232233111332233
 36 1231333131322333
 37 1231332111331333
 38 1223132211233331
 39 1321232131211231
 40 1223132331321233
;

title2 'Merge Data and Design';

%mktmerge(design=sasuser.cerealdes, /* input design                         */
          data=results,             /* input data set                       */
          out=res2,                 /* output data set with design and data */
          nsets=16,                 /* number of choice sets                */
          nalts=4,                  /* number of alternatives               */
          setvars=r1-r16)           /* variables with the chosen alt nums   */

title2 'Design and Data Both';

proc print data=res2(obs=16);
   by set subject;   id set subject;
   run;

title2 'Code the Independent Variables';

proc transreg design norestoremissing data=res2;
   model class(brand price count);
   id subject set c;
   output out=coded(drop=_type_ _name_ intercept) lprefix=0;
   run;

proc print data=coded(obs=16) label;
   title3 'ID Information and the Dependent Variable';
   format price price. count count.;
   var Brand Price Count Subject Set c;
   by set subject;   id set subject;
   run;

proc print data=coded(obs=16) label;
   title3 'ID Information and the Coding of Brand';
   format price price. count count.;
   var brandbranolicious brandbrantasia brandbrantopia brand;
   by set subject;   id set subject;
   run;

proc print data=coded(obs=16) label;
   title3 'ID Information and the Coding of Price and Count';
   format price price. count count.;
   var Price_2_89 Price_2_99 Price_3_09 CountSix_Bars Price Count;
   by set subject;   id set subject;
   run;

%phchoice(on)                       /* customize PHREG for a choice model   */

title2 'Multinomial Logit Discrete Choice Model';

proc phreg data=coded brief;
   model c*c(2) = &_trgind / ties=breslow;
   strata subject set;
   run;

%phchoice(off)                      /* restore PHREG to a survival PROC     */

proc sort data=coded nodupkeys out=combos(drop=subject -- c);
   by brand price count;
   run;

data utils(drop=i);
   set combos;
   array b[7] _temporary_ (2.7 2.3 2.9 2.9 1.7 0.7 -1.2);
   array x[7] brandbranolicious -- countsix_bars;
   u = 0;
   do i = 1 to 7;
      x[i] = b[i] * x[i];
      u + x[i];
      end;
   run;

proc print label noobs split='-';
   title2 'Part-Worth Utility Report';
   label BrandBranolicious = 'Bran-olic-ious-'
         BrandBrantasia    = 'Bran-tas -ia  -'
         BrandBrantopia    = 'Bran-top -ia  -';
   id u;
   run;

%macro res;
   if x1 = x3 & x1 = x5 then bad = 1;
   if x2 = x4 & x2 = x6 then bad = bad + 1;
   %mend;

%mktex(4 2  4 2  4 2,       /* factor level list for all attrs and alts     */
       n=16,                /* number of choice sets                        */
       restrictions=res,    /* name of the restrictions macro               */
       options=resrep,      /* detailed report on restrictions              */
       seed=17)             /* random number seed                           */

title2 'Create the Choice Design Key';

data key;
   input
Brand $ 1-12    Price $    Count $; datalines;
Branolicious    x1         x2
Brantopia       x3         x4
Brantasia       x5         x6
None            .          .
;

title2 'Create Choice Design from Linear Arrangement';

proc format;
   value price 1 = $2.89 2 = $2.99 3 = $3.09 4 = $3.19 . = ' ';
   value count 1 = 'Six Bars' 2 = 'Eight Bars'  . = ' ';
   run;

%mktroll(design=randomized,  /* input randomized linear arrangement         */
         key=key,            /* rules for making choice design              */
         alt=brand,          /* brand or alternative label var              */
         out=cerealdes)      /* output choice design                        */

title2;
proc print; format price price. count count.; id set; by set; run;

%macro bad; * The easy way with vectors;
   c1 = sum(x[, 1:32] = 1);
   c2 = sum(x[,33:64] = 1);
   bad = abs(6 - c1) + abs(6 - c2);
   %mend;

%macro bad; * The hard way with scalars;
   c1 = (x1  = 1) + (x2  = 1) + (x3  = 1) + (x4  = 1) + (x5  = 1) + (x6  = 1)
      + (x7  = 1) + (x8  = 1) + (x9  = 1) + (x10 = 1) + (x11 = 1) + (x12 = 1)
      + (x13 = 1) + (x14 = 1) + (x15 = 1) + (x16 = 1) + (x17 = 1) + (x18 = 1)
      + (x19 = 1) + (x20 = 1) + (x21 = 1) + (x22 = 1) + (x23 = 1) + (x24 = 1)
      + (x25 = 1) + (x26 = 1) + (x27 = 1) + (x28 = 1) + (x29 = 1) + (x30 = 1)
      + (x31 = 1) + (x32 = 1);
   c2 = (x33 = 1) + (x34 = 1) + (x35 = 1) + (x36 = 1) + (x37 = 1) + (x38 = 1)
      + (x39 = 1) + (x40 = 1) + (x41 = 1) + (x42 = 1) + (x43 = 1) + (x44 = 1)
      + (x45 = 1) + (x46 = 1) + (x47 = 1) + (x48 = 1) + (x49 = 1) + (x50 = 1)
      + (x51 = 1) + (x52 = 1) + (x53 = 1) + (x54 = 1) + (x55 = 1) + (x56 = 1)
      + (x57 = 1) + (x58 = 1) + (x59 = 1) + (x60 = 1) + (x61 = 1) + (x62 = 1)
      + (x63 = 1) + (x64 = 1);
   bad = abs(6 - c1) + abs(6 - c2);
   %mend;

title 'Cereal Bars';

%mktex(4 2,                         /* all attribute levels                 */
       n=8)                         /* number of candidate alternatives     */

%mktlab(data=design,                /* original design from MktEx           */
        vars=Price Count)           /* new variable names                   */

proc print; run;

data cand;
   length Brand $ 12;
   retain Price Count . f1-f4 0;

   if _n_ = 1 then do;
      brand = 'None        '; f4 = 1; output; f4 = 0;    /* brand 4 (None)  */
      end;

   set final;

   brand = 'Branolicious';    f1 = 1; output; f1 = 0;    /* brand 1         */
   brand = 'Brantasia   ';    f2 = 1; output; f2 = 0;    /* brand 2         */
   brand = 'Brantopia   ';    f3 = 1; output; f3 = 0;    /* brand 3         */
   run;

proc print; run;

proc format;
   value price 1 = $2.89 2 = $2.99 3 = $3.09 4 = $3.19 . = ' ';
   value count 1 = 'Six Bars' 2 = 'Eight Bars'  . = ' ';
   run;

proc sort;
   by brand price count;
   format price price. count count.;
   run;

proc print label; run;

%choiceff(data=cand,                /* candidate set of alternatives        */
          bestout=sasuser.cerealdes,/* choice design permanently stored     */
                                    /* model with stdz orthogonal coding    */
          model=class(brand price count / sta),
          maxiter=10,               /* maximum number of designs to make    */
          flags=f1-f4,              /* flag which alt can go where, 4 alts  */
          nsets=16,                 /* number of choice sets                */
          seed=306,                 /* random number seed                   */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

* Due to machine differences, you might not get the same designs
so here is the design that is used in the book;
data sasuser.cerealdes;
   length Set 8 Brand $ 12;
   input Set Brand $ Price Count @@;
   format price price. count count.;
   datalines;
 1 Branolicious 4 1  1 Brantasia 1 1  1 Brantopia 2 2  1 None . .
 2 Branolicious 1 2  2 Brantasia 4 1  2 Brantopia 2 2  2 None . .
 3 Branolicious 4 1  3 Brantasia 3 2  3 Brantopia 2 1  3 None . .
 4 Branolicious 2 2  4 Brantasia 4 1  4 Brantopia 1 1  4 None . .
 5 Branolicious 3 1  5 Brantasia 2 2  5 Brantopia 1 2  5 None . .
 6 Branolicious 3 2  6 Brantasia 4 2  6 Brantopia 1 1  6 None . .
 7 Branolicious 2 2  7 Brantasia 1 1  7 Brantopia 3 1  7 None . .
 8 Branolicious 1 2  8 Brantasia 3 1  8 Brantopia 2 1  8 None . .
 9 Branolicious 3 1  9 Brantasia 1 2  9 Brantopia 4 2  9 None . .
10 Branolicious 1 2 10 Brantasia 2 1 10 Brantopia 4 2 10 None . .
11 Branolicious 4 2 11 Brantasia 3 2 11 Brantopia 1 1 11 None . .
12 Branolicious 3 2 12 Brantasia 2 1 12 Brantopia 4 2 12 None . .
13 Branolicious 1 1 13 Brantasia 4 1 13 Brantopia 3 2 13 None . .
14 Branolicious 2 1 14 Brantasia 1 2 14 Brantopia 3 1 14 None . .
15 Branolicious 4 1 15 Brantasia 2 2 15 Brantopia 3 1 15 None . .
16 Branolicious 2 1 16 Brantasia 3 2 16 Brantopia 4 2 16 None . .
;

proc print data=sasuser.cerealdes;
   by set;
   id set;
   var brand -- count;
   run;

proc format;
   value zer -1e-12 - 1e-12 = ' 0   ';
   run;

proc print data=bestcov label;
   id __label;
   label __label = '00'x;
   var BrandBranolicious -- CountSix_Bars;
   format _numeric_ zer5.2;
   run;

%mktdups(branded,                         /* a design with brands           */
         data=sasuser.cerealdes,          /* the input design to evaluate   */
         factors=brand price count,       /* factors in the design          */
         nalts=4)                         /* number of alternatives         */

title2 'Read Data';

data results;
   input Subject (r1-r16) (1.);
   datalines;
  1 3131312123331232
  2 3131332121331222
  3 3133331121321222
  4 3111232121321223
  5 3131312122311222
  6 3131333121213232
  7 3131311132331332
  8 3131331121321223
  9 3121332122331222
 10 3131132123321222
 11 3131312121321223
 12 3121332122311232
 13 3131331122321222
 14 3131311121331223
 15 3131311121121223
 16 3121333221321223
 17 3121332131311222
 18 3131233121331222
 19 3131332121131232
 20 3131231121311432
 21 2133232121331223
 22 3121332121121221
 23 3131332121331223
 24 3133312131311323
 25 3131332431311232
 26 3131312143331222
 27 3121112133311223
 28 3123331121321221
 29 3121312122311231
 30 3131332121311233
 31 3121332121341222
 32 2131231122331231
 33 2131312122231221
 34 2121332321311421
 35 3133311121331233
 36 3131333121321323
 37 3131312131331223
 38 3121312331331221
 39 3121312121221231
 40 3123232121321232
;

title2 'Merge Data and Design';

%mktmerge(design=sasuser.cerealdes, /* input design                         */
          data=results,             /* input data set                       */
          out=res2,                 /* output data set with design and data */
          nsets=16,                 /* number of choice sets                */
          nalts=4,                  /* number of alternatives               */
          setvars=r1-r16)           /* variables with the chosen alt nums   */

title2 'Code the Independent Variables';

proc transreg design norestoremissing data=res2;
   model class(brand price count);
   id subject set c;
   output out=coded(drop=_type_ _name_ intercept) lprefix=0;
   run;

%phchoice(on)                       /* customize PHREG for a choice model   */

title2 'Multinomial Logit Discrete Choice Model';

proc phreg data=coded brief;
   model c*c(2) = &_trgind / ties=breslow;
   strata subject set;
   run;

%phchoice(off)                      /* restore PHREG to a survival PROC     */

title 'Cereal Bars';

%mktex(4 2,                         /* all attribute levels                 */
       n=8)                         /* number of candidate alternatives     */

%mktlab(data=design,                /* original design from MktEx           */
        vars=Price Count)           /* new variable names                   */

data cand;
   length Brand $ 12;
   retain Price Count . f1-f4 0;

   if _n_ = 1 then do;
      brand = 'None        '; f4 = 1; output; f4 = 0;    /* brand 4 (None)  */
      end;

   set final;

   brand = 'Branolicious';    f1 = 1; output; f1 = 0;    /* brand 1         */
   brand = 'Brantasia   ';    f2 = 1; output; f2 = 0;    /* brand 2         */
   brand = 'Brantopia   ';    f3 = 1; output; f3 = 0;    /* brand 3         */
   run;

proc format;
   value price 1 = $2.89 2 = $2.99 3 = $3.09 4 = $3.19 . = ' ';
   value count 1 = 'Six Bars' 2 = 'Eight Bars'  . = ' ';
   run;

proc sort;
   by brand price count;
   format price price. count count.;
   run;

proc print; run;

%macro res;
   if x[1,1] = x[2,1] & x[1,1] = x[3,1] then bad = 1;
   if x[1,2] = x[2,2] & x[1,2] = x[3,2] then bad = bad + 1;
   %mend;

%choiceff(data=cand,                /* candidate set of alternatives        */
          bestout=sasuser.cerealdes,/* choice design permanently stored     */
                                    /* model with stdz orthogonal coding    */
          model=class(brand price count / sta),
          maxiter=10,               /* maximum number of designs to make    */
          flags=f1-f4,              /* flag which alt can go where, 4 alts  */
          nsets=16,                 /* number of choice sets                */
          seed=306,                 /* random number seed                   */
          options=relative          /* display relative D-efficiency        */
                  resrep,           /* detailed report on restrictions      */
          restrictions=res,         /* name of the restrictions macro       */
          resvars=price count,      /* vars used in defining restrictions   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

* Due to machine differences, you might not get the same designs
so here is the design that is used in the book;
data sasuser.cerealdes;
   length Set 8 Brand $ 12;
   input set brand Price Count @@;
   format price price. count count.;
   datalines;
 1 Branolicious 1 1  1 Brantasia 2 2  1 Brantopia 3 1  1 None .  .
 2 Branolicious 1 1  2 Brantasia 4 1  2 Brantopia 2 2  2 None .  .
 3 Branolicious 4 2  3 Brantasia 2 2  3 Brantopia 1 1  3 None .  .
 4 Branolicious 4 1  4 Brantasia 3 1  4 Brantopia 2 2  4 None .  .
 5 Branolicious 3 2  5 Brantasia 1 2  5 Brantopia 2 1  5 None .  .
 6 Branolicious 3 1  6 Brantasia 1 2  6 Brantopia 4 2  6 None .  .
 7 Branolicious 3 2  7 Brantasia 4 1  7 Brantopia 2 1  7 None .  .
 8 Branolicious 2 2  8 Brantasia 3 1  8 Brantopia 1 2  8 None .  .
 9 Branolicious 4 2  9 Brantasia 3 1  9 Brantopia 1 1  9 None .  .
10 Branolicious 1 1 10 Brantasia 4 2 10 Brantopia 3 2 10 None .  .
11 Branolicious 2 1 11 Brantasia 3 2 11 Brantopia 4 2 11 None .  .
12 Branolicious 4 1 12 Brantasia 1 2 12 Brantopia 3 1 12 None .  .
13 Branolicious 2 1 13 Brantasia 1 2 13 Brantopia 4 2 13 None .  .
14 Branolicious 3 2 14 Brantasia 2 1 14 Brantopia 1 1 14 None .  .
15 Branolicious 1 2 15 Brantasia 2 1 15 Brantopia 4 1 15 None .  .
16 Branolicious 2 2 16 Brantasia 4 1 16 Brantopia 3 2 16 None .  .
;

proc format;
   value zer -1e-12 - 1e-12 = ' 0   ';
   run;

proc print data=bestcov label;
   id __label;
   label __label = '00'x;
   var BrandBranolicious -- CountSix_Bars;
   format _numeric_ zer5.2;
   run;

proc print data=sasuser.cerealdes; id set; by set; var brand price count; run;

%mktdups(branded,                         /* a design with brands           */
         data=sasuser.cerealdes,          /* the input design to evaluate   */
         factors=brand price count,       /* factors in the design          */
         nalts=4)                         /* number of alternatives         */

title2 'Read Data';

data results;
   input Subject (r1-r16) (1.);
   datalines;
  1 2133321333322311
  2 3133221131222211
  3 2133321131122311
  4 1113221131322311
  5 2133321133322311
  6 2133221131222311
  7 2133221132322311
  8 2133221131322311
  9 1123221112222311
 10 1133123133222211
 11 3133221331322111
 12 1123221113223311
 13 2231221132123321
 14 2133221331222321
 15 2133321131122111
 16 2123221331222321
 17 2123223331332311
 18 2133223311132121
 19 1133221131122311
 20 2133221131222411
 21 2133221131222321
 22 2123221111122321
 23 2133223131222111
 24 1133321111332111
 25 3133321431222131
 26 2133221143223113
 27 2123131113322311
 28 3322221131322311
 29 2123221133322311
 30 2133221131222311
 31 1121221111242311
 32 2133221133122311
 33 2133321133222311
 34 2123221331322411
 35 1132221111322311
 36 1133323131322121
 37 1333221131322311
 38 1123321311222311
 39 1123223131222111
 40 2123221331222313
;

title2 'Merge Data and Design';

%mktmerge(design=sasuser.cerealdes, /* input design                         */
          data=results,             /* input data set                       */
          out=res2,                 /* output data set with design and data */
          nsets=16,                 /* number of choice sets                */
          nalts=4,                  /* number of alternatives               */
          setvars=r1-r16)           /* variables with the chosen alt nums   */

title2 'Code the Independent Variables';

proc transreg design norestoremissing data=res2;
   model class(brand price count);
   id subject set c;
   output out=coded(drop=_type_ _name_ intercept) lprefix=0;
   run;

%phchoice(on)                       /* customize PHREG for a choice model   */

title2 'Multinomial Logit Discrete Choice Model';

proc phreg data=coded brief;
   model c*c(2) = &_trgind / ties=breslow;
   strata subject set;
   run;

%phchoice(off)                      /* restore PHREG to a survival PROC     */

title 'Cereal Bars';

%mktruns(4 2  4 2  4 2)     /* factor level list for all attrs and alts     */

%mktex(4 2  4 2  4 2,       /* factor level list for all attrs and alts     */
       n=512,               /* number of candidate choice sets              */
       out=full,            /* output data set with full factorial          */
       seed=17)             /* random number seed                           */

data design;
   set full;
   if x1 eq x3 and x3 eq x5 then delete;  /* delete constant price          */
   if x2 eq x4 and x4 eq x6 then delete;  /* delete constant count          */
   run;

%mktkey(3 2)         /* x1-x6 (since 3*2=6) in 3 rows and 2 columns         */

data key;
   input Brand $ 1-12 Price $ Count $;
   datalines;
Branolicious    x1         x2
Brantopia       x3         x4
Brantasia       x5         x6
None            .          .
;

proc print; run;

%mktroll(design=design,      /* input linear candidate design               */
         key=key,            /* rules for making choice design              */
         alt=brand,          /* brand or alternative label var              */
         out=cand)           /* output candidate choice design              */

proc format;
   value price 1 = $2.89 2 = $2.99 3 = $3.09 4 = $3.19 . = ' ';
   value count 1 = 'Six Bars' 2 = 'Eight Bars'  . = ' ';
   run;

data cand;
   set cand;
   format price price. count count.;
   run;

proc print data=cand(obs=16); id set; by set; run;

%choiceff(data=cand,                      /* candidate set of choice sets   */
                                          /* model with stdz orthog coding  */
          model=class(brand price count / sta) /
                cprefix=0                 /* lpr=0 labels from just levels  */
                lprefix=0,                /* cpr=0 names from just levels   */
          nsets=16,                       /* number of choice sets          */
          seed=145,                       /* random number seed             */
          nalts=4,                        /* number of alternatives         */
          options=relative,               /* display relative D-efficiency  */
          beta=zero)                      /* assumed beta vector            */

* Due to machine differences, you might not get the same designs
so here is the design that is used in the book;
data sasuser.cerealdes;
   length Set 8 Brand $ 12;
   input Set Brand $ Price Count @@;
   format price price. count count.;
   datalines;
140 Branolicious 2 2 140 Brantopia 1 1 140 Brantasia 3 1 140 None . .
115 Branolicious 2 1 115 Brantopia 3 1 115 Brantasia 4 2 115 None . .
19 Branolicious 1 1 19 Brantopia 2 2 19 Brantasia 3 2 19 None . .  164
Branolicious 2 2 164 Brantopia 3 1 164 Brantasia 4 2 164 None . .  116
Branolicious 2 1 116 Brantopia 3 2 116 Brantasia 1 1 116 None . .  287
Branolicious 4 1 287 Brantopia 2 2 287 Brantasia 1 1 287 None . .  321
Branolicious 4 2 321 Brantopia 1 1 321 Brantasia 3 2 321 None . .  65
Branolicious 1 2 65 Brantopia 2 2 65 Brantasia 3 1 65 None . .  260
Branolicious 3 2 260 Brantopia 4 1 260 Brantasia 1 2 260 None . .  191
Branolicious 3 1 191 Brantopia 1 2 191 Brantasia 4 1 191 None . .  82
Branolicious 1 2 82 Brantopia 4 1 82 Brantasia 2 2 82 None . .  13
Branolicious 1 1 13 Brantopia 2 1 13 Brantasia 4 2 13 None . .  349
Branolicious 4 2 349 Brantopia 3 2 349 Brantasia 2 1 349 None . .  268
Branolicious 3 2 268 Brantopia 4 2 268 Brantasia 2 1 268 None . .  277
Branolicious 4 1 277 Brantopia 1 2 277 Brantasia 2 1 277 None . .  214
Branolicious 3 1 214 Brantopia 4 1 214 Brantasia 1 2 214 None . .
;

proc print data=best(obs=16);
   by notsorted set;
   id set;
   var brand -- count;
   run;

data sasuser.choice;
   set best(keep=brand price count);
   retain Set 1;
   output;
   if brand = 'None' then set + 1;
   run;

proc print data=sasuser.choice(obs=16);
   by set;
   id set;
   var brand -- count;
   run;

proc format;
   value zer -1e-12 - 1e-12 = ' 0   ';
   run;

proc print data=bestcov label;
   id __label;
   label __label = '00'x;
   var Branolicious -- Six_Bars;
   format _numeric_ zer5.2;
   run;

%mktdups(branded,                         /* a design with brands           */
         data=sasuser.choice,             /* the input design to evaluate   */
         factors=brand price count,       /* factors in the design          */
         nalts=4)                         /* number of alternatives         */

%mktruns(4 2 3 2)                  /* factor level list for one alternative */

%mktex(4 2 3 2,             /* factor level list for one alternative        */
       n=48)                /* number of candidate alternatives             */

proc format;
   value price 1 = $2.89 2 = $2.99 3 = $3.09 4 = $3.19;
   value count 1 = 'Six Bars' 2 = 'Eight Bars';
   value cal   1 = '90 Calories' 2 = '110 Calories' 3 = '130 Calories';
   value chol  1 = 'Cholesterol Free' 2 = 'No Claim';
   run;

%mktlab(data=design,           /* input data set                            */
        vars=Price Count Calories Cholesterol, /* new attribute names       */
        int=f1-f3,             /* create 3 columns of 1's in f1-f3          */
        out=final,             /* output design                             */
                               /* add a format statement for the attributes */
        stmts=format price price. count count. calories cal. cholesterol chol.)

proc print; run;

%choiceff(data=final,                 /* candidate set of alternatives      */
          bestout=sasuser.cerealdes,  /* choice design permanently stored   */
                                      /* model with stdz orthog coding      */
          model=class(price count calories cholesterol / sta) /
                cprefix=0             /* lpr=0 labels from just levels      */
                lprefix=0,            /* cpr=0 names from just levels       */
          nsets=9,                    /* number of choice sets to make      */
          seed=145,                   /* random number seed                 */
          flags=f1-f3,                /* flag which alt can go where, 3 alts*/
          options=relative,           /* display relative D-efficiency      */
          beta=zero)                  /* assumed beta vector                */

* Due to machine differences, you might not get the same designs
so here is the design that is used in the book;
data sasuser.cerealdes;
Set = int((_n_ - 1) / 3) + 1;
input Price    Count    Calories    Cholesterol @@;
format price price. count count. calories cal. cholesterol chol.;
cards;
4 2 1 2 1 1 2 2 3 1 3 1 4 2 3 2 2 1 1 1 1 1 2 1 4 1 2 1 1 2 3 2 3 2 1 1
4 2 2 1 2 1 3 2 3 1 1 1 2 2 3 1 1 1 1 1 3 2 2 2 1 2 3 1 2 2 2 1 4 1 1 2
3 2 3 1 1 2 1 2 2 1 2 2 4 1 3 1 2 2 1 2 3 2 2 2 2 2 1 1 3 1 3 2 1 2 2 1
;

proc print data=sasuser.cerealdes;
   var price -- cholesterol;
   id set; by set;
   run;

proc format;
   value zer -1e-12 - 1e-12 = ' 0   ';
   run;

proc print data=bestcov label;
   id __label;
   label __label = '00'x;
   var _2_89 -- Cholesterol_Free;
   format _numeric_ zer5.2;
   run;

%mktdups(generic,                   /* generic design (no brands)           */
         data=sasuser.cerealdes,    /* the input design to evaluate         */
                                    /* factors in the design                */
         factors=price count calories cholesterol,
         nalts=3)                   /* number of alternatives               */

title 'Cereal Bars';

%mktbsize(nattrs=13,                /* 13 attributes                        */
          setsize=3 to 8,           /* try set sizes in range 3 to 8        */
          options=ubd)              /* consider unbalanced designs too      */

%mktbibd(nattrs=13,                 /* 13 attributes                        */
         setsize=6,                 /* vary 6 at a time                     */
         b=13,                      /* create 13 blocks of choice sets      */
         seed=289)                  /* random number seed                   */

%mktbibd(nattrs=13,                 /* 13 attributes                        */
         setsize=6,                 /* vary 6 at a time                     */
         b=13,                      /* create 13 blocks of choice sets      */
         seed=289,                  /* random number seed                   */
         positer=0,                 /* do not optimize position frequencies */
         optiter=100)               /* only 100 PROC OPTEX iterations       */

%mktex(8 2 ** 6,                    /* 1 eight-level and 6 two-level factors*/
       n=16,                        /* 16 runs                              */
       seed=382)                    /* random number seed                   */

* Due to machine differences, you might not get the same designs
so here are the designs that are used in the book;
data bibd; input x1-x6 @@; datalines;
3 5 6 8 10 11 3 4 7 8 9 10 2 4 6 10 12 13 1 2 4 6 7 8 1 2 3 9 10 12 1 3
5 6 7 12 1 4 5 9 10 11 2 6 8 9 11 12 3 4 7 11 12 13 1 6 7 9 11 13 4 5 8
9 12 13 2 5 7 10 11 13 1 2 3 5 8 13
;

data randomized; input x1-x7 @@; datalines;
6 2 2 1 2 2 1 8 2 1 2 2 2 2 5 2 1 2 2 1 1 8 1 2 1 1 1 1 5 1 2 1 1 2 2 3 1
1 1 2 2 1 2 2 2 2 1 2 1 3 2 2 2 1 1 2 7 2 1 1 1 2 2 6 1 1 2 1 1 2 2 1 1 1
2 1 2 1 2 1 1 1 1 1 1 1 2 2 2 2 2 4 1 1 2 1 2 1 7 1 2 2 2 1 1 4 2 2 1 2 1 2
;

proc sort data=randomized           /* sort randomized data set             */
          out=randes(drop=x1);      /* do not need 8-level factor any more  */
   by x2 x1;                        /* must sort by x2 then x1.  Really!    */
   run;

%mktppro(ibd=bibd,                  /* input block design                   */
         design=randes)             /* input orthogonal array               */

%choiceff(data=chdes,               /* candidate set of choice sets         */
          init=chdes,               /* initial design                       */
          initvars=x1-x13,          /* factors in the initial design        */
          model=class(x1-x13 / sta),/* model with stdz orthogonal coding    */
          nsets=104,                /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
          rscale=                   /* relative D-efficiency scale factor   */
          %sysevalf(104 * 6 / 13),  /* 6 of 13 attrs in 104 sets vary       */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=chdes; id set; by set; where set le 16; run;

proc print noobs data=randes; run;

%mktblock(data=chdes,               /* input choice design to block         */
          out=sasuser.chdes,        /* output blocked choice design         */
                                    /* stored in permanent SAS data set     */
          nalts=2,                  /* two alternatives                     */
          nblocks=8,                /* eight blocks                         */
          factors=x1-x13,           /* 13 attributes, x1-x13                */
          print=design,             /* print the blocked design (only)      */
          seed=472)                 /* random number seed                   */

data _null_;
   array alts[13] $ 12 _temporary_ ('Almonds' 'Apple' 'Banana Chips'
                  'Brown Sugar' 'Cashews' 'Chocolate' 'Coconut' 'Cranberries'
                  'Hazel Nuts' 'Peanuts' 'Pecans' 'Raisins' 'Walnuts');
   array x[13];                           /* 13 design factors              */
   set sasuser.chdes;                     /* read each alternative          */
   if alt eq 1 then put / block 1. set 3. +1 @; /* write block and set num  */
   else put '<vs> ' @;                    /* print '<vs>' to separate alts  */
   c = 0;                                 /* do not print a comma yet       */
   do j = 1 to 13;                        /* loop over all 13 attrs         */
      if x[j] eq 2 then do;               /* if this one is shown           */
         if c then put +(-1) ', ' @;      /* print comma if not on 1st attr */
         put alts[j] @;                   /* print attr value               */
         c = 1;                           /* not on first term so do commas */
         end;
      end;
   run;

data chdata;
   input Block Sub (c1-c13) (1.) @@;
   datalines;
 1  1 1212221112122 1  2 2222221112122 1  3 2221222112122 1  4 2211221112121
 1  5 2212222112212 1  6 2212222122122 1  7 2222221112122 1  8 2122222112122
 1  9 2122221112122 1 10 2212221112122 1 11 1222222112122 1 12 2221222112122
 1 13 1212221112212 1 14 2112222122122 1 15 2212221112222 1 16 2212221112122
 1 17 2212221112122 1 18 2212221112122 1 19 2222221112222 1 20 2212221112122
 2  1 1212112212122 2  2 1112222212122 2  3 1212222112122 2  4 1112222212122
 2  5 1221112122122 2  6 1112212122122 2  7 1212112212122 2  8 1212212212122
 2  9 1112222222122 2 10 1211122212122 2 11 1112222222122 2 12 1212112222112
 2 13 1112222212122 2 14 1212122222122 2 15 1222222222122 2 16 1212122222112
 2 17 1212212212122 2 18 1112122212122 2 19 1112222222122 2 20 1112122212122
 3  1 1221211112222 3  2 1222221111222 3  3 2121211112222 3  4 1221211112222
 3  5 1222212122222 3  6 1122211121222 3  7 1222211112222 3  8 1121211112222
 3  9 1222211112222 3 10 1221211111222 3 11 2121211111222 3 12 1121221112222
 3 13 1122211112222 3 14 1122211122222 3 15 1121212111222 3 16 1121211122222
 3 17 1122211112222 3 18 1122211112222 3 19 1122211122222 3 20 1112211121222
 4  1 2211212112212 4  2 2111212122212 4  3 2111212222212 4  4 2111211122212
 4  5 2111222122212 4  6 2122212112212 4  7 2221212122221 4  8 2111212121222
 4  9 2121212111212 4 10 2122212121211 4 11 2121212111211 4 12 2111212122212
 4 13 2111212111211 4 14 2221212122212 4 15 2211211122212 4 16 2111212111212
 4 17 2211212121221 4 18 2121212112212 4 19 2112212111212 4 20 2111212121221
 5  1 2112122112112 5  2 1212122122211 5  3 2222122111111 5  4 2212222121211
 5  5 2222122112111 5  6 2122122212112 5  7 1212122111112 5  8 2222222122111
 5  9 1222222112111 5 10 2212122111111 5 11 2211221122111 5 12 2211121111111
 5 13 2212222221212 5 14 2222222112111 5 15 2222222121111 5 16 2222222111111
 5 17 2222122122211 5 18 1212122112111 5 19 2212222122111 5 20 2212222212111
 6  1 1222221212112 6  2 1222221212122 6  3 1222121212212 6  4 1222221212212
 6  5 1222221211112 6  6 1222221212112 6  7 1222221112122 6  8 1222221212112
 6  9 1221221211112 6 10 1222121222112 6 11 1222221211122 6 12 1221221212212
 6 13 1222121222212 6 14 1222221211112 6 15 1221121212112 6 16 1222221211212
 6 17 1222121212212 6 18 1221221212112 6 19 1212121212212 6 20 1222221212112
 7  1 2112222221211 7  2 1122222222111 7  3 1112222222111 7  4 2112222222111
 7  5 2112222222112 7  6 2112222222111 7  7 2112222222111 7  8 1112222221211
 7  9 2112222122111 7 10 1122222222211 7 11 2112222222211 7 12 2112222222121
 7 13 2112222222211 7 14 2112222222211 7 15 1112222222111 7 16 1112122222111
 7 17 2112222222111 7 18 2112222222211 7 19 2112222212211 7 20 1112222222211
 8  1 2211112221122 8  2 2212212222121 8  3 2212212221121 8  4 2212212121122
 8  5 2211122221121 8  6 2212222121121 8  7 2221122221111 8  8 2211212221122
 8  9 2211212221121 8 10 2211112221111 8 11 2211212221121 8 12 2212222221121
 8 13 2211112221122 8 14 2111222221122 8 15 2212222221121 8 16 2212222221121
 8 17 2222222221121 8 18 2111112121122 8 19 2111212221122 8 20 2112212222121
;

%mktmerge(design=sasuser.chdes,     /* input final blocked choice design    */
          data=chdata,              /* input choice data                    */
          out=desdata,              /* output design and data               */
          blocks=block,             /* the blocking variable is block       */
          nsets=13,                 /* 13 choice sets per subject           */
          nalts=2,                  /* 2 alternatives in each set           */
          setvars=c1-c13)           /* the choices for each subject vars    */

%phchoice(on)                       /* customize PHREG for a choice model   */

proc phreg brief data=desdata;      /* provide brief summary of strata      */
   ods output parameterestimates=pe;/* output parameter estimates           */
   class x1-x13 / ref=first;        /* name all as class vars, '1' ref level*/
   model c*c(2) = x1-x13;           /* 1 - chosen, 2 - not chosen           */
                                    /* x1-x13 are independent vars          */
   label x1  = 'Almonds'            /* set of descriptive labels            */
         x2  = 'Apple'
         x3  = 'Banana Chips'
         x4  = 'Brown Sugar'
         x5  = 'Cashews'
         x6  = 'Chocolate'
         x7  = 'Coconut'
         x8  = 'Cranberries'
         x9  = 'Hazel Nuts'
         x10 = 'Peanuts'
         x11 = 'Pecans'
         x12 = 'Raisins'
         x13 = 'Walnuts';
   strata block sub set;            /* set within subject within block      */
   run;                             /* identify each choice set             */

proc sort data=pe;                  /* process the parameter estimates      */
   by descending estimate;          /* table by sorting by estimate         */
   run;

data pe;                            /* also get rid of the '2' level        */
   set pe;                          /* in the label                         */
   substr(label, length(label)) = ' ';
   run;

proc print label;                   /* print estimates with largest first   */
   id label;
   label label = '00'x;
   var df -- probchisq;
   run;

%phchoice(off)                      /* restore PHREG to a survival PROC     */

title 'Cereal Bars';

%mktbsize(nattrs=13,                /* 13 total attributes                  */
          setsize=2 to 6,           /* show between 2 and 6 at once         */
          nsets=2 to 40,            /* make between 2 and 40 choice sets    */
          options=ubd,              /* consider unbalanced designs          */
          maxreps=5)                /* permit multiple replications, which  */
                                    /* will show us some BIBDs that might   */
                                    /* not be otherwise listed with         */
                                    /* options=ubd                          */

%mktbibd(out=sasuser.bibd,          /* output BIBD                          */
         nattrs=13,                 /* 13 total attributes                  */
         setsize=4,                 /* show 4 in each set                   */
         nsets=13,                  /* 13 choice sets                       */
         seed=93)                   /* random number seed                   */

* Due to machine differences, you might not get the same designs
so here is the design that is used in the book;
data sasuser.bibd; input x1-x4 @@; datalines;
3 11 1 10 11 4 7 6 4 9 13 3 8 10 6 9 7 13 10 12 5 1 9 7 10 2 5 4
13 5 8 11 1 6 2 13 12 8 4 1 2 7 3 8 9 12 11 2 6 3 12 5
;

data _null_;
   array alts[13] $ 12 _temporary_ ('Almonds' 'Apple' 'Banana Chips'
                  'Brown Sugar' 'Cashews' 'Chocolate' 'Coconut' 'Cranberries'
                  'Hazel Nuts' 'Peanuts' 'Pecans' 'Raisins' 'Walnuts');
   set sasuser.bibd;                /* read design                          */
   put alts[x1] +(-1) ', '          /* print each attr, comma separated     */
       alts[x2] +(-1) ', ' alts[x3] +(-1) ', ' alts[x4];
   run;

data bwdata;
   input (x1-x26) (1.);
   datalines;
34133132412334244323323143
34143214411431314314422141
23143414421432344221422142
31123213421332231241432143
34133214421434242124233142
34314232211334211423432141
24434114312334344243122141
31134124322334214243213442
41123114131432241321422432
41423113341334431242424132
32423412122334244343423141
31433214431334231313122443
41133214411334244314422141
34213123431334241223212443
13134214311334211343422141
32242421341331232323122142
41124214311342244313132142
31143214411334231213411442
41423124211234244323412141
31233413211431121243424141
;

%let attrlist=Almonds,Apple,Banana Chips,Brown Sugar,Cashews,Chocolate
,Coconut,Cranberries,Hazel Nuts,Peanuts,Pecans,Raisins,Walnuts;

%phchoice(on)                       /* customize PHREG for a choice model   */

%mktmdiff(bwaltpos,                 /* data are best then worst and         */
                                    /* alternating and are the positions    */
                                    /* of the chosen attributes             */
          nattrs=13,                /* 13 attributes                        */
          nsets=13,                 /* 13 choice sets                       */
          setsize=4,                /* 4 attributes shown in each set       */
          attrs=attrlist,           /* list of attribute names              */
          data=bwdata,              /* input data set with data             */
          design=sasuser.bibd)      /* input data set with BIBD             */

%mktmdiff(bwaltpos,                 /* data are best then worst and         */
                                    /* alternating and are the positions    */
                                    /* of the chosen attributes             */
          nattrs=13,                /* 13 attributes                        */
          nsets=13,                 /* 13 choice sets                       */
          setsize=4,                /* 4 attributes shown in each set       */
          attrs=attrlist,           /* list of attribute names              */
          classopts=zero='Hazel Nuts',/* set the reference level            */
          data=bwdata,              /* input data set with data             */
          design=sasuser.bibd)      /* input data set with BIBD             */

%phchoice(off)                      /* restore PHREG to a survival PROC     */

************************* Exercises *************************;

options ls=80 ps=60 nonumber nodate;
title;

* Answer 1.a;

%mktruns(6 6, n=36)

*
6^3 in 36 runs is the design with the most six-level factors.  Using
one factor as the choice set number, you can have at most 2 six-level
attributes in a choice design with perfect 100% relative
D-efficiency.  Since 6 is a composite number, you do not have the
full range of factors in orthogonal arrays that you get when the levels
are all prime such as 2, 3, 5, and 7 or powers of a prime such as 4, 8,
and 9.

You can use the MktRuns macro to find the answer as shown.  An
alternative approach is shown below:
;

%mktorth(range=n=36)

proc print data=mktdeslev; where x6 gt 2; var n design; run;

* Answer 1.b;

%mktex(6 ** 3, n=36)

%mktlab(data=design, vars=Set x1-x2)

proc print; by set; id set; run;

proc freq; tables x1 * x2 / list; run;

*
This design is constructed by combinatorial means from an orthogonal array.
;

* Answer 1.c;

%choiceff(data=final,
          init=final(keep=set),
          model=class(x1 - x2 / sta),
          beta=zero,
          nsets=6,
          nalts=6,
          intiter=0,
          options=relative)

*
Note that the standardized orthogonal contrast coding was used.
;

* Answer 1.d;

*
The variances, D-error, and 1 over the number of choice sets are
all 1/6.  D-efficiency and the number of choice sets are both 6.
These are the properties of an optimal generic design.  D-error
and D-efficiency are always the inverse of each other.
;

* Answer 1.e;

*
The output from the ChoicEff macro states that there are 10 parameters.
Furthermore, it lists 10 parameters each with 1 df.  There are 2
six-level factors and 2(6 - 1) = 10.

The output from the ChoicEff macro states that there is a maximum of 30
parameters.  There are six choice sets and six alternatives.  The number
of choice sets, times the number of alternatives minus one, provides a
ceiling on the number of parameters in the model.
;

* Answer 1.f;

%mktex(6 ** 7, n=36, seed=104)

%mktlab(data=design, vars=Set x1-x6)

%choiceff(data=final,
          init=final(keep=set),
          model=class(x1 - x6 / sta),
          beta=zero,
          nsets=6,
          nalts=6,
          intiter=0,
          options=relative)

proc print data=final; id set; by set; run;

proc print data=bestcov label;      /* covariance matrix from ChoicEff      */
   id __label;
   label __label = '00'x;           /* hex null suppress label header       */
   var x:;
   run;

* Answer 1.g;

*
There are 30 parameters in the model.  There are six attributes, each
with six levels.  Six attributes, times six minus one levels, equals 30
parameters.  This design is saturated.  You cannot add any more
attributes.
;

* Answer 1.h;

*
If the orthogonal array 6^7 in 36 runs existed, then it could be used
to make an optimal generic design with 6 six-level factors.  Each choice
set would contribute 1 to the unscaled efficiency criterion (assuming
the standardized orthogonal contrast coding used here) and the result
would be 6.  Instead we get a value on the order of 5.13 and roughly
85.5% relative D-efficiency.  This design is probably nearly optimal.
The 85.5% value is computed relative to a hypothetical optimal design
constructed from a nonexistent orthogonal array.  Hence it provides a
pessimistic view of efficiency relative to the actual optimal design.
;

* Answer 1.i;

*
The fact that the absolute maximum number of parameters is specified is
perhaps worrisome.  Of course when data are collected, there are
multiple subjects, so there will be error df.  You might consider
creating a design with more choice sets, such as 72, and blocking it.
All that said, the variances are not wildly different from D-error
and one over the number of choice sets, so maybe this design is fine.
Ultimately, you have to make the call based on what you, your client,
and your brand manager need to do.
;

* Answer 2.a;

%mktruns(6 ** 6)

%mktex(6 ** 6, n=36, seed=104)

%choiceff(data=randomized,
          model=class(x1 - x6 / sta),
          beta=zero,
          nsets=6,
          flags=6,
          maxiter=100,
          seed=104,
          options=relative)

* Answer 2.b;

*
The smallest number of candidate sets you could pick is 31.  This is the
size of the saturated design reported by the MktRuns macro.  You would
certainly not want to try a size smaller than 36.  Seventy two is an
obvious choice since an orthogonal array exists.  You might try other
multiples of 36.  The full-factorial design, at 46,656 runs is probably
too large to try.  Typically, smaller sizes with zero violations, like
36 or 72, will work better than other sizes.  The only way to know for
sure is to try a number of sizes.  Usually you will get diminishing
returns on your time if you try a lot of sizes.
;

* Answer 2.d;

*
The answer will depend on the sizes that you tried and the way you
approached the problem.
;

* Answer 3.a;

%mktruns(6 ** 36)

%mktex(6 ** 36, n=216, options=quickr largedesign, maxtime=1, seed=104)

%mktroll(key=6 6, design=randomized, out=cand)

%choiceff(data=cand,
          model=class(x1 - x6 / sta),
          beta=zero,
          nsets=6,
          nalts=6,
          maxiter=100,
          seed=104,
          options=relative)

*
The options create one design, quickly, using a random initial design.
Total run time for the MktEx macro is expected to be just over one
minute.  Typically, you do not want to spend lots of time searching for
a candidate set.  The return on that extra time is usually minimal.
First, get your code working as quickly as possible.  Then you may want
to remove the option and let it run over lunch or overnight to see if
you might do a bit better.

This approach is usually going to be inferior to the approach in the
preceding example, unless the design is very small, then you would
expect both approaches to do equally well.  This approach is typically
going to search for the design in a very limited and inferior region of
the design space when compared to the previous approach.
;

* Answer 3.b;

*
The answer will depend on the sizes that you tried and the way you
approached the problem.
;

* Answer 4.a;

%mktruns(4 ** 16)

*
The MktRuns macro tells you that you need at least 49 choice sets.
Since an orthogonal array is available in 64 runs, that is a good place
to start.  Other sizes include 96 or 128, but 64 is probably going to be
best.  You could block the design into eight blocks of size 8, four
blocks of size 16, or two blocks of size 32.  If you feel that 32 choice
sets is too many for one person, then you would probably choose four
blocks of size 16.
;

* Answer 4.b;

%mktex(4 ** 16, n=64, seed=104)

%mktkey(4 4)

data b;
   input Brand $ @@;
   cards;
   A B C D
;

data key; merge b key; run;

%mktroll(key=key, design=randomized, out=chdes, alt=brand)

proc print; by set; id set brand; run;

* Answer 4.c;

%choiceff(data=chdes,
          init=chdes(keep=set),
          model=class(brand x1 - x4 / sta),
          beta=zero,
          nsets=64,
          nalts=4,
          intiter=0,
          options=relative)

proc format;
   value zer -1e-12 - 1e-12 = ' 0   ';
   run;

proc print data=bestcov label;      /* covariance matrix from ChoicEff      */
   id __label;
   label __label = '00'x;           /* hex null suppress label header       */
   var b: x:;
   format _numeric_ zer5.3;
   run;

*
The macro reports that there are 15 parameters.  Four brands, plus four
attributes with 4 levels creates: $(4 - 1) + 4(4 - 1) = 15$ parameters.
;

* Answer 4.d;

%choiceff(data=chdes,
          init=chdes(keep=set),
          model=class(brand / sta)
                class(brand * x1 brand * x2 brand * x3 brand * x4 /
                zero=' ' sta),
          beta=zero,
          nsets=64,
          nalts=4,
          intiter=0,
          options=relative)

proc print data=bestcov label;      /* covariance matrix from ChoicEff      */
   id __label;
   label __label = '00'x;           /* hex null suppress label header       */
   var b:;
   format _numeric_ zer5.3;
   run;

*
There are 51 parameters.  First, there are 3 for the brand effect (4
brands minus 1).  For each of the four brands, there are four attributes
times four levels minus 1: 4 x 4(4 - 1) = 48$.  Finally, 3 + 48 = 51.

With this coding, the variance matrix is diagonal.
;

* Answer 4.e;

*
The variances are constant within similarly constructed effects (that
is within the brand effects and within the alternative-specific
effects).  D-efficiency is 13.24, and relative D-efficiency is 20.69.
Do not interpret that to mean that this is an inferior design.  The
relative D-efficiency only has the nice 0 to 100 scaling for restricted
classes of designs such as some generic designs.  This is a good design
with a nice covariance structure.  Attributes are uncorrelated with each
other both within and across alternatives.  If you did not need the
alternative-specific effects, this design would be much larger than it
would need to be.  However, for this model, this is a great design.

If there is any weakness, it is the fact that the construction method
does not produce results this clean when there are asymmetries.  This
all works so cleanly because an orthogonal array exists with four-level
factors, and we have the right numbers of choice sets, four-level
attributes, and alternatives to use it.
;

* Answer 4.f;

%mktruns(4 ** 4)

%mktex(4 ** 4, n=16, seed=104)

data cand;
   retain f1-f4 0;
   set randomized;
   brand = 'A'; f1 = 1; output; f1 = 0;
   brand = 'B'; f2 = 1; output; f2 = 0;
   brand = 'C'; f3 = 1; output; f3 = 0;
   brand = 'D'; f4 = 1; output; f4 = 0;
   run;

%choiceff(data=cand,
          model=class(brand / sta)
                class(brand * x1 brand * x2 brand * x3 brand * x4 /
                zero=' ' sta),
          beta=zero,
          nsets=64,
          flags=f1-f4,
          maxiter=100,
          seed=104,
          options=relative)

proc print data=bestcov label;      /* covariance matrix from ChoicEff      */
   id __label;
   label __label = '00'x;           /* hex null suppress label header       */
   var b:;
   format _numeric_ zer5.3;
   run;

*
This is a pretty good design, but not quite as good as the design
constructed using the linear arrangement and the 64-run orthogonal
array.
;

* Answer 4.g;

%mktruns(4 ** 4)

%mktex(4 ** 4, n=256, seed=104)

data cand;
   retain f1-f4 0;
   set randomized;
   brand = 'A'; f1 = 1; output; f1 = 0;
   brand = 'B'; f2 = 1; output; f2 = 0;
   brand = 'C'; f3 = 1; output; f3 = 0;
   brand = 'D'; f4 = 1; output; f4 = 0;
   run;

%choiceff(data=cand,
          model=class(brand / sta)
                class(brand * x1 brand * x2 brand * x3 brand * x4 /
                zero=' ' sta),
          beta=zero,
          nsets=64,
          flags=f1-f4,
          maxiter=10,
          seed=104,
          options=relative)

proc print data=bestcov label;      /* covariance matrix from ChoicEff      */
   id __label;
   label __label = '00'x;           /* hex null suppress label header       */
   var b:;
   format _numeric_ zer5.3;
   run;

*
With a full-factorial candidate set to search, you know the optimal
design is in there, but it is hard to find.  You can try other sizes as
well.
;

* Answer 4.h;

*
The linear arrangement produces a design with a very nice
covariance matrix structure.  The largest relative D-efficiency is
probably 13.2418 from the direct orthogonal array construction.
;

* Answer 4.i;

%mktblock(data=chdes, nalts=4, nblocks=4, factors=brand x1-x4, seed=104)

* Answer 4.j;

%mktex(4 ** 4, n=16, seed=104)

data cand;
   retain f1-f3 1;
   set randomized;
   brand = 'A'; output;
   brand = 'B'; output;
   brand = 'C'; output;
   brand = 'D'; output;
   run;

%choiceff(data=cand,
          model=class(brand x1-x4 / sta),
          beta=zero,
          nsets=64,
          flags=f1-f3,
          seed=104,
          options=relative)

* Answer 4.k;

proc freq; tables set * brand / list; run;

*
It will be inefficient to include the same brand multiple times in the
same choice set, so the D-efficiency criterion will try to steer away
from it.
;

* Answer 4.l;

%mktruns(4 ** 4)

%mktex(4 ** 4, n=16, seed=104)

data cand;
   retain f1-f4 0;
   set randomized;
   brand = 'A'; f1 = 1; price =  .99 + 0.5 * x1; output; f1 = 0;
   brand = 'B'; f2 = 1; price = 1.49 + 0.5 * x1; output; f2 = 0;
   brand = 'C'; f3 = 1; price = 1.29 + 0.5 * x1; output; f3 = 0;
   brand = 'D'; f4 = 1; price = 1.19 + 0.5 * x1; output; f4 = 0;
   run;

proc freq; tables brand * price / list; run;

%choiceff(data=cand,
          model=class(brand / sta)
                class(brand * price brand * x2 brand * x3 brand * x4 /
                      zero=' ' sta),
          beta=zero,
          nsets=64,
          flags=f1-f4,
          seed=104,
          options=relative,
          out=ridged)

%choiceff(data=cand,
          model=class(brand / sta)
                class(brand * price brand * x2 brand * x3 brand * x4 /
                      zero=' ' sta),
          drop=brandAprice1D69 brandAprice1D79 brandAprice2D19
               brandAprice2D29 brandAprice2D69 brandAprice2D79
               brandAprice2D99 brandAprice3D19 brandAprice3D29
               brandBprice1D49 brandBprice1D69 brandBprice1D79
               brandBprice2D19 brandBprice2D29 brandBprice2D69
               brandBprice2D79 brandBprice3D19 brandBprice3D29
               brandCprice1D49 brandCprice1D69 brandCprice1D99
               brandCprice2D19 brandCprice2D49 brandCprice2D69
               brandCprice2D99 brandCprice3D19 brandCprice3D29
               brandDprice1D49 brandDprice1D79 brandDprice1D99
               brandDprice2D29 brandDprice2D49 brandDprice2D79
               brandDprice2D99 brandDprice3D19 brandDprice3D29,
          beta=zero,
          nsets=64,
          flags=f1-f4,
          seed=104,
          options=relative,
          out=regular)

proc compare data=ridged compare=regular
   criterion=1e-8 method=rel(1) note nosummary;
   title3 "should be no differences";
   run;

*
Note that the same design is chosen.  Only the efficiency is different.
;

* Answer 5.a;

%mktruns(4 3 3 2    4 3 3 2    4 3 3 2    4 3 3 2 )

*
The saturated design has 33 choice sets, so that is the minimum.  The
smallest size that makes sense to try is 36.  It is good to try a small
one first.  You might consider two blocks of size 18.  Alternatively,
you might make a larger design, like one with 144 choice sets and block
it into blocks of size 12 or 24.
;

* Answer 5.b;

%mktex(4 3 3 2    4 3 3 2    4 3 3 2    4 3 3 2, n=36, seed=104)

%mktkey(4 4)

data b;
   input Brand $ @@;
   cards;
   A B C D
;

data key; merge b key; run;

%mktroll(key=key, design=randomized, out=chdes, alt=brand)

proc print; by set; id set brand; run;

* Answer 5.c;

%choiceff(data=chdes,
          init=chdes(keep=set),
          model=class(brand x1 - x4 / sta),
          beta=zero,
          nsets=36,
          nalts=4,
          intiter=0,
          options=relative)

*
The main effects model has 11 parameters: three brands minus one, plus
4 - 1, 3 - 1, 3 - 1, and 2 - 1.
;

* Answer 5.d;

%choiceff(data=chdes,
          init=chdes(keep=set),
          model=class(brand / sta)
                class(brand * x1 brand * x2 brand * x3 brand * x4 /
                zero=' ' sta),
          beta=zero,
          nsets=36,
          nalts=4,
          intiter=0,
          options=relative)

*
The model has 35 parameters, and the design can handle a maximum of 108
parameters.  There are 3 brand parameters, and 4 brands times ((4 - 1) +
(3 - 1) + (3 - 1) + (2 - 1)).
;

* Answer 5.e;

proc print data=bestcov label;      /* covariance matrix from ChoicEff      */
   id __label;
   label __label = '00'x;           /* hex null suppress label header       */
   var b:;
   format _numeric_ zer5.3;
   run;

*
The perfect variance structure seen with orthogonal array design
construction will rarely exist when there are asymmetries like we have
here.  Still, this looks like a good design.  You can tell better by
comparing it to other possibilities.
;

* Answer 5.f;

%mktruns(4 3 3 2)

%mktex(4 3 3 2, n=72)

data cand;
   retain f1-f4 0;
   set design;
   brand = 'A'; f1 = 1; output; f1 = 0;
   brand = 'B'; f2 = 1; output; f2 = 0;
   brand = 'C'; f3 = 1; output; f3 = 0;
   brand = 'D'; f4 = 1; output; f4 = 0;
   run;

%choiceff(data=cand,
          model=class(brand / sta)
                class(brand * x1 brand * x2 brand * x3 brand * x4 /
                zero=' ' sta),
          beta=zero,
          nsets=36,
          flags=f1-f4,
          maxiter=20,
          seed=104,
          options=relative)

*
The efficiency of this design is similar to the efficiency from the
previous approach.
;

* Answer 5.g;

*
The answer will depend on the sizes that you tried and the way you
approached the problem.
;

* Answer 6;

%mktruns( 4 3 3 2   4 3 3 2   4 3 3 2 )

%macro res;
  bad = (x1 = x5) + (x1 = x9) + (x5 = x9);
  %mend;

%mktex( 4 3 3 2   4 3 3 2   4 3 3 2, n=36, restrictions=res, seed=104 )

%mktkey(3 4)

data b;
   input Brand $ @@;
   cards;
A B C
;

data key; merge b key; run;

%mktroll(key=key, design=randomized, out=cand, alt=brand)

proc print; by set; id set brand; run;

%choiceff(data=cand,
          model=class(brand x1 - x4 / sta),
          beta=zero,
          nsets=12,
          nalts=3,
          seed=104,
          options=relative)

proc print; by notsorted set; id set brand; var x1-x4; run;

proc print data=bestcov label;      /* covariance matrix from ChoicEff      */
   id __label;
   label __label = '00'x;           /* hex null suppress label header       */
   var b: x:;
   format _numeric_ zer5.3;
   run;

* Answer 6.a;

*
The smallest suggested size is 36 candidate choice sets, so that seems
like a good place to start.  Seventy-two and 144 also look like good
choices.  You could try larger sizes like 288, but sizes greater than
144 will probably not help a lot.
;

* Answer 6.b;

*
The answer will depend on the sizes that you tried and the way you
approached the problem.

These restrictions are simple.  If you use the restrictions macro that
was provided, you will get the right results.  You should always check
though, because often times it is hard to write the restrictions macro.
;

* Answer 6.c;

*
There are 10 parameters.  The maximum is 24.  There are 12 choice sets,
times 3 alternatives minus 1, equals a maximum of 24 parameters.
;

* Answer 6.d;

%mktruns(4 3 3 2)
%mktex(4 3 3 2, n=72)

data cand;
   length Brand $ 1;
   set design;
   brand = 'A'; f1 = 1; f2 = 0; f3 = 0; output;
   brand = 'B'; f1 = 0; f2 = 1; f3 = 0; output;
   brand = 'C'; f1 = 0; f2 = 0; f3 = 1; output;
   run;

%macro res;
   bad = (x[1,1] = x[2,1]) + (x[1,1] = x[3,1]) + (x[2,1] = x[3,1]) +
         (x[1,2] = x[2,2]) + (x[1,2] = x[3,2]) + (x[2,2] = x[3,2]) +
         (x[1,3] = x[2,3]) + (x[1,3] = x[3,3]) + (x[2,3] = x[3,3]);
   %mend;

%choiceff(data=cand,
          model=class(brand x1-x4 / sta),
          seed=238,
          nsets=12,
          flags=f1-f3,
          resvars=x1-x3,
          restrictions=res,
          options=relative,
          beta=zero)

proc print; id set; by set; var brand -- x4; run;

* Answer 6.e;
%macro res;
   do j = 1 to 3;                   /* loop over attributes   */
      do i = 1 to 3;                /* loop over all rows     */
         do k = i + 1 to 3;         /* loop over rows (k > i) */
            bad = bad + (x[i,j] = x[k,j]);
            end;
         end;
      end;
   %mend;

%choiceff(data=cand,
          model=class(brand x1-x4 / sta),
          seed=238,
          nsets=12,
          flags=f1-f3,
          resvars=x1-x3,
          restrictions=res,
          options=relative,
          beta=zero)

proc print; id set; by set; var brand -- x4; run;

* The results of 6.d and 6.3 match.
