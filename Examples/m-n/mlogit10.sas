 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MR2010F                                             */
 /*   TITLE: Discrete Choice 10                                  */
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

******* Begin Partial Profiles and Restrictions Code ********;

title 'Partial Profiles';

%mktex(3 ** 20,                     /* 20 three-level factors               */
       n=41,                        /* 41 runs                              */
       partial=5,                   /* partial profile, 5 attrs vary        */
       seed=292,                    /* random number seed                   */
       maxdesigns=1)                /* make only one design                 */

%mktlab(data=randomized, values=. 1 2, nfill=99)

data _null_; set final(firstobs=2); put (x1-x20) (2.); run;

data des(drop=i);
   Set = _n_;
   set final(firstobs=2);
   array x[20];
   output;
   do i = 1 to 20;
      if n(x[i]) then do; if x[i] = 1 then x[i] = 2; else x[i] = 1; end;
      end;
   output;
   run;

%choiceff(data=des,                 /* candidate set of choice sets         */
          init=des(keep=set),       /* select these sets from candidates    */
          intiter=0,                /* evaluate without internal iterations */
          model=class(x1-x20 / zero=none), /* main effects, no ref levels   */
          nsets=40,                 /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktdups(generic, data=best, nalts=2, factors=x1-x20)

%choiceff(data=des,                 /* candidate set of choice sets         */
          init=des(keep=set),       /* select these sets from candidates    */
          intiter=0,                /* evaluate without internal iterations */
          model=class(x1-x20 / zero=none), /* main effects, no ref levels   */
          nsets=40,                 /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
                                    /* extra model terms to drop from model */
          drop=x12 x22 x32 x42 x52 x62 x72 x82 x92 x102
          x112 x122 x132 x142 x152 x162 x172 x182 x192 x202,
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%choiceff(data=des,                 /* candidate set of choice sets         */
          init=des(keep=set),       /* select these sets from candidates    */
          intiter=0,                /* evaluate without internal iterations */
          model=class(x1-x20 / sta),/* model with stdzd orthogonal coding   */
          nsets=40,                 /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
                                    /* extra model terms to drop from model */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

title 'Partial Profiles';

%mktex(4 ** 12,                     /* 12 four-level factor                 */
       n=37,                        /* 37 runs                              */
       partial=4,                   /* partial profile, 4 attrs vary        */
       seed=462,                    /* random number seed                   */
       maxdesigns=1)                /* make only one design                 */

%mktlab(data=randomized, values=. 1 2 3, nfill=99)

proc print; run;

title 'Partial Profiles';

%macro partprof;
   sum = 0;
   do k = 1 to 10;
      sum = sum + (x[k] = x[k+10]   &   x[k] = x[k+20]);
      end;
   bad = abs(sum - 4);
   %mend;

%mktex(3 ** 30,                     /* 30 three-level factors               */
       n=198,                       /* 198 runs                             */
       options=quickr               /* very quick run with random init      */
               nox,                 /* suppress x1, x2, ... creation        */
       order=random,                /* loop over columns in a random order  */
       out=sasuser.cand,            /* output design stored permanently     */
       restrictions=partprof,       /* name of restrictions macro           */
       seed=382)                    /* random number seed                   */

%mktkey(3 10)

%mktroll(design=sasuser.cand, key=key, out=rolled)

%mktdups(generic, data=rolled, out=nodups, factors=x1-x10, nalts=3)

proc print data=nodups(obs=9); id set; by set; run;

%choiceff(data=nodups,              /* candidate set of choice sets         */
          model=class(x1-x10 / sta),/* model with stdzd orthogonal coding   */
          seed=495,                 /* random number seed                   */
          maxiter=10,               /* maximum iterations for each phase    */
          nsets=27,                 /* number of choice sets                */
          nalts=3,                  /* number of alternatives               */
          options=nodups            /* no duplicate choice sets             */
                  relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=best; id set; by notsorted set; var x1-x10; run;

%macro partprof;
   sum = 0;
   do k = 1 to 20;
      sum = sum + (x[k]    = 1 & x[k+20] = 1 & x[k+40]  = 1 &
                   x[k+60] = 1 & x[k+80] = 1 & x[k+100] = 1);
      end;
   bad = abs(sum - 15);
   %mend;

   * Uncomment this code if you want it to run

%mktex(2 ** 120,                    /* 120 two-level factors                */
       n=300,                       /* 300 runs                             */
       order=random,                /* loop over columns in a random order  */
       out=cand,                    /* output design                        */
       restrictions=partprof,       /* name of restrictions macro           */
       seed=424,                    /* random number seed                   */
       maxtime=0,                   /* stop once design conforms            */
       options=largedesign          /* make large design more quickly       */
               nosort               /* do not sort output design            */
               resrep               /* detailed report on restrictions      */
               quickr               /* very quick run with random init      */
               nox)                 /* suppress x1, x2, ... creation        */

   ;

%macro partprof;
   sum = 0;
   do k = 1 to 20;
      sum = sum + (x[k]    = 1 & x[k+20] = 1 & x[k+40]  = 1 &
                   x[k+60] = 1 & x[k+80] = 1 & x[k+100] = 1);
      end;
   bad = abs(sum - 15);
   %mend;

%macro partprof;
   sum = 0;
   do k = 1 to 20;
      sum = sum + (x[k]    = 1 & x[k+20] = 1 & x[k+40]  = 1 &
                   x[k+60] = 1 & x[k+80] = 1 & x[k+100] = 1);
      end;
   bad = abs(sum - 15);
   if sum < 15 & x[j1] = 2 then do;
      k = mod(j1 - 1, 20) + 1;
      c = (x[k]    = 1) + (x[k+20] = 1) + (x[k+40]  = 1) +
          (x[k+60] = 1) + (x[k+80] = 1) + (x[k+100] = 1);
      if c >= 3 then bad = bad + (6 - c) / 6;
      end;
   %mend;

%mktex(2 ** 120,                    /* 120 two-level factors                */
       n=300,                       /* 300 runs                             */
       order=random,                /* loop over columns in a random order  */
       out=cand,                    /* output design                        */
       restrictions=partprof,       /* name of restrictions macro           */
       seed=424,                    /* random number seed                   */
       maxtime=0,                   /* stop once design conforms            */
       options=largedesign          /* make large design more quickly       */
               nosort               /* do not sort output design            */
               resrep               /* detailed report on restrictions      */
               quickr               /* very quick run with random init      */
               nox)                 /* suppress x1, x2, ... creation        */

%mktkey(6 20)

%mktroll(design=cand, key=key, out=rolled)

proc print; by set; id set; var x:; where set le 5; run;

%mktdups(generic, data=rolled, out=nodups, factors=x1-x20, nalts=6)

proc print data=nodups(obs=18); id set; by set; run;

%choiceff(data=nodups,              /* candidate set of choice sets         */
          model=class(x1-x20 / zero=first), /* main effects, first ref level*/
          seed=495,                 /* random number seed                   */
          maxiter=10,               /* maximum iterations for each phase    */
          nsets=18,                 /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          options=nodups,           /* no duplicate choice sets             */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=best; id set; by notsorted set; var x1-x20; run;

   * Uncomment this code if you want it to run

%mktex(2 ** 120,                    /* 120 two-level factors                */
       n=400,                       /* 400 runs                             */
       optiter=0,                   /* no PROC OPTEX iterations             */
       tabiter=0,                   /* no OA initialization iterations      */
       maxtime=60,                  /* at most 60 minutes per phase         */
       order=random,                /* loop over columns in a random order  */
       out=cand,                    /* output design                        */
       restrictions=partprof,       /* name of restrictions macro           */
       seed=424,                    /* random number seed                   */
       maxstages=1,                 /* maximum number of algorithm stages   */
       options=largedesign          /* make large design more quickly       */
               nosort)              /* do not sort output design            */

   ;

%macro partprof;
   sum = 0;
   do k = 1 to 20;
      sum = sum + (x[k]    = 1 & x[k+20] = 1 & x[k+40]  = 1 &
                   x[k+60] = 1 & x[k+80] = 1 & x[k+100] = 1);
      end;
   bad = abs(sum - 15);
   if sum < 15 & x[j1] = 2 then bad = bad + 1000;
   %mend;

%mktex(2 ** 120,                    /* 120 two-level factors                */
       n=300,                       /* 300 runs                             */
       order=random,                /* loop over columns in a random order  */
       out=cand,                    /* output design                        */
       restrictions=partprof,       /* name of restrictions macro           */
       seed=424,                    /* random number seed                   */
       maxtime=0,                   /* stop once design conforms            */
       options=largedesign          /* make large design more quickly       */
               nosort               /* do not sort output design            */
               resrep               /* detailed report on restrictions      */
               quickr               /* very quick run with random init      */
               nox)                 /* suppress x1, x2, ... creation        */

%choiceff(data=nodups,              /* candidate set of choice sets         */
          model=class(x1-x20 / zero=first), /* main effects, first ref level*/
          seed=495,                 /* random number seed                   */
          maxiter=10,               /* maximum iterations for each phase    */
          nsets=18,                 /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          options=nodups,           /* no duplicate choice sets             */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%choiceff(data=nodups,              /* candidate set of choice sets         */
          model=class(x1-x20 / sta),/* model with stdzd orthogonal coding   */
          seed=495,                 /* random number seed                   */
          maxiter=10,               /* maximum iterations for each phase    */
          nsets=18,                 /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          options=nodups            /* no duplicate choice sets             */
                  relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%macro partprof;
   sum = 0;
   do k = 1 to 15;
      sum = sum + (x[k+15] = x[k] & x[k+30] = x[k] &
                   x[k+45] = x[k] & x[k+60] = x[k]);
      end;
   bad = abs(sum - 10);
   if sum < 10 & x[j1] ^= x[mod(j1 - 1, 15) + 1] then bad = bad + 1000;
   %mend;

%mktex(5 ** 75,                     /* 75 five-level factors                */
       n=400,                       /* 400 runs                             */
       order=random,                /* loop over columns in a random order  */
       out=cand,                    /* output design                        */
       restrictions=partprof,       /* name of restrictions macro           */
       seed=472,                    /* random number seed                   */
       maxtime=0,                   /* stop once design conforms            */
       options=largedesign          /* make large design more quickly       */
               nosort               /* do not sort output design            */
               resrep               /* detailed report on restrictions      */
               quickr               /* very quick run with random init      */
               nox)                 /* suppress x1, x2, ... creation        */

%mktkey(5 15)

%mktroll(design=cand, key=key, out=rolled)

%mktdups(generic, data=rolled, out=nodups, factors=x1-x15, nalts=5)

%choiceff(data=nodups,              /* candidate set of choice sets         */
          model=class(x1-x15 / sta),/* model with stdz orthogonal coding    */
          seed=513,                 /* random number seed                   */
          maxiter=10,               /* maximum iterations for each phase    */
          nsets=15,                 /* number of choice sets                */
          nalts=5,                  /* number of alternatives               */
          options=nodups            /* no duplicate choice sets             */
                  relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=best(obs=15); id set; by notsorted set; var x1-x15; run;

%choiceff(data=nodups,              /* candidate set of choice sets         */
          model=class(x1-x15 / sta),/* model with stdz orthogonal coding    */
          seed=513,                 /* random number seed                   */
          maxiter=10,               /* maximum iterations for each phase    */
          nsets=30,                 /* number of choice sets                */
          nalts=5,                  /* number of alternatives               */
          options=nodups            /* no duplicate choice sets             */
                  relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

   /* Uncomment this code if you want it to run

%macro partprof;
   sum = 0;
   do k = 1 to 15;
      sum = sum + (x[k+15] = x[k] & x[k+30] = x[k] &
                   x[k+45] = x[k] & x[k+60] = x[k]);
      end;
   bad = abs(sum - 10);
   if sum < 10 then do;
      if x[j1] ^= x[mod(j1 - 1, 15) + 1] then bad = bad + 1000;
      if x[j2] ^= x[mod(j2 - 1, 15) + 1] then bad = bad + 1000;
      end;
   %mend;

   */
   * Uncomment this code if you want it to run

%mktex(5 ** 75,                     /* 75 five-level factors                */
       n=400,                       /* 400 runs                             */
       optiter=0,                   /* no PROC OPTEX iterations             */
       tabiter=0,                   /* no OA initialization iterations      */
       maxtime=720,                 /* at most 720 minutes per phase        */
       order=random=15,             /* pairwise exchanges within            */
                                    /*    nonconstant attributes            */
       out=sasuser.cand,            /* output design stored permanently     */
       restrictions=partprof,       /* name of restrictions macro           */
       seed=472,                    /* random number seed                   */
       exchange=2,                  /* pairwise exchanges                   */
       maxstages=1,                 /* maximum number of algorithm stages   */
       options=largedesign          /* make large design more quickly       */
               nosort               /* do not sort output design            */
               resrep               /* detailed report on restrictions      */
               nox)                 /* suppress x1, x2, ... creation        */

   ;

   * Uncomment this code if you want it to run

%mktkey(5 15)

%mktroll(design=sasuser.cand, key=key, out=rolled)

%mktdups(generic, data=rolled, out=nodups, factors=x1-x15, nalts=5)

%choiceff(data=nodups,              /* candidate set of choice sets         */
          model=class(x1-x15 / sta),/* model with stdz orthogonal coding    */
          seed=513,                 /* random number seed                   */
          maxiter=10,               /* maximum iterations for each phase    */
          nsets=30,                 /* number of choice sets                */
          nalts=5,                  /* number of alternatives               */
          options=nodups            /* no duplicate choice sets             */
                  relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

   ;
   /* Uncomment this code if you want it to run

proc print data=best(obs=15); id set; by notsorted set; var x1-x15; run;

   */

%mktbsize(b=20, nattrs=16, setsize=4)

%mktbsize(nattrs=15 to 20, setsize=3 to t / 2, b=t to 30)

%mktbibd(b=20, nattrs=16, setsize=4, seed=17)

%mktex(4 2**4, n=8)

proc print noobs; run;

%mktbibd(b=20, nattrs=16, setsize=4, seed=17)

%mktex(4 2 ** 4, n=8, seed=306)

proc sort data=randomized out=randes(drop=x1);
   by x2 x1;
   run;

proc print noobs data=randes; run;

%mktppro(design=randes, ibd=bibd)

%choiceff(data=chdes,               /* candidate set of choice sets         */
          init=chdes,               /* initial design                       */
          initvars=x1-x6,           /* factors in the initial design        */
          model=class(x1-x16 / sta),/* model with stdz orthogonal coding    */
          nsets=80,                 /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
          rscale=                   /* relative D-efficiency scale factor   */
          %sysevalf(80 * 4 / 16),   /* 4 of 16 attrs in 80 sets vary        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=chdes(obs=12); id set; by set; run;

%mktdups(generic, data=best, factors=x1-x16, nalts=2)

%mktbibd(b=12, nattrs=16, setsize=4, seed=17)

%mktex(4 2 ** 4, n=8, seed=306)

proc sort data=randomized out=randes(drop=x1);
   by x2 x1;
   run;

%mktppro(ibd=bibd, design=randes)

%choiceff(data=chdes,               /* candidate set of choice sets         */
          init=chdes,               /* initial design                       */
          initvars=x1-x6,           /* factors in the initial design        */
          model=class(x1-x16 / sta),/* model with stdz orthogonal coding    */
          nsets=48,                 /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
          rscale=                   /* relative D-efficiency scale factor   */
          %sysevalf(48 * 4 / 16),   /* 4 of 16 attrs in 80 sets vary        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktdups(generic, data=best, factors=x1-x16, nalts=2)

%mktbibd(b=8, nattrs=16, setsize=4, seed=17)

%mktex(4 2 ** 4, n=8, seed=306)

proc sort data=randomized out=randes(drop=x1);
   by x2 x1;
   run;

%mktppro(ibd=bibd, design=randes)

%choiceff(data=chdes,               /* candidate set of choice sets         */
          init=chdes,               /* initial design                       */
          initvars=x1-x6,           /* factors in the initial design        */
          model=class(x1-x16 / sta),/* model with stdz orthogonal coding    */
          nsets=32,                 /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
          rscale=                   /* relative D-efficiency scale factor   */
          %sysevalf(32 * 4 / 16),   /* 4 of 16 attrs in 32 sets vary        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktdups(generic, data=best, factors=x1-x16, nalts=2)

%mktbibd(b=7, nattrs=16, setsize=4, seed=17)

%mktex(4 2 ** 4, n=8, seed=306)

proc sort data=randomized out=randes(drop=x1);
   by x2 x1;
   run;

%mktppro(ibd=bibd, design=randes)

%choiceff(data=chdes,               /* candidate set of choice sets         */
          init=chdes,               /* initial design                       */
          initvars=x1-x6,           /* factors in the initial design        */
          model=class(x1-x16 / sta),/* model with stdz orthogonal coding    */
          nsets=28,                 /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
          rscale=                   /* relative D-efficiency scale factor   */
          %sysevalf(28 * 4 / 16),   /* 4 of 16 attrs in 28 sets vary        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktdups(generic, data=best, factors=x1-x16, nalts=2)

%macro pp(                          /*--------------------------------------*/
       lev=,                        /* levels                               */
       nattrs=,                     /* total attributes                     */
       setsize=,                    /* number of attributes that vary       */
       maxv=,                       /* max number of attrs that can vary    */
       b=,                          /* number of blocks                     */
       seed=);                      /* random number seed                   */
                                    /*--------------------------------------*/

%let sets = %sysevalf(&b * &maxv);
%put NOTE: nattrs=&nattrs, setsize=&setsize, sets=&sets, b=&b..;

%mktbibd(b=&b, nattrs=&nattrs, setsize=&setsize, seed=&seed, positer=0)

%mktex(&maxv &lev ** &setsize, n=&lev * &maxv)

proc sort data=randomized out=randes(drop=x1);
   by x2 x1;
   run;

%mktppro(ibd=bibd, design=randes)

%choiceff(data=chdes,               /* candidate set of choice sets         */
          init=chdes,               /* initial design                       */
          initvars=x1-x&nattrs,     /* factors in the initial design        */
          intiter=0,                /* evaluate without internal iterations */
          model=class(x1-x&nattrs / sta),/* model with stdz orthog coding   */
          nsets=&sets,              /* number of choice sets                */
          nalts=&lev,               /* number of alternatives               */
          rscale=                   /* relative D-efficiency scale factor   */
          %sysevalf(&sets * &setsize / &nattrs),
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=chdes; by set; id set; var x:; run;

%mktdups(generic, data=best, factors=x1-x&nattrs, nalts=&lev)
%mend;

   /* Uncomment this code if you want it to run

%pp(lev = 2, nattrs = 16, setsize =  4, maxv =  4, b =  20, seed =  17)
%pp(lev = 4, nattrs = 16, setsize =  4, maxv =  4, b =  20, seed =  93)
%pp(lev = 2, nattrs = 16, setsize =  8, maxv =  8, b =  30, seed = 109)
%pp(lev = 3, nattrs = 13, setsize =  6, maxv =  6, b =  26, seed = 114)
%pp(lev = 2, nattrs = 23, setsize = 12, maxv = 12, b =  23, seed = 121)
%pp(lev = 5, nattrs = 11, setsize =  5, maxv =  5, b =  11, seed = 145)
%pp(lev = 3, nattrs = 19, setsize =  9, maxv =  9, b =  19, seed = 151)
%pp(lev = 2, nattrs = 22, setsize =  7, maxv = 16, b =  22, seed = 205)
%pp(lev = 4, nattrs = 13, setsize =  3, maxv =  8, b =  26, seed = 238)
%pp(lev = 3, nattrs = 21, setsize =  5, maxv = 12, b =  21, seed = 289)
%pp(lev = 2, nattrs = 22, setsize =  8, maxv = 20, b =  11, seed = 292)
%pp(lev = 3, nattrs = 25, setsize =  9, maxv = 15, b =  25, seed = 306)
%pp(lev = 4, nattrs = 21, setsize =  5, maxv = 12, b =  21, seed = 350)
%pp(lev = 7, nattrs = 15, setsize =  7, maxv =  7, b =  15, seed = 368)
%pp(lev = 5, nattrs = 16, setsize = 10, maxv = 10, b =  16, seed = 377)
%pp(lev = 4, nattrs = 16, setsize =  8, maxv = 16, b =  10, seed = 382)
%pp(lev = 8, nattrs = 15, setsize =  8, maxv =  8, b =  15, seed = 396)
%pp(lev = 2, nattrs =  8, setsize =  2, maxv = 28, b =  28, seed = 420)
%pp(lev = 5, nattrs =  7, setsize =  6, maxv = 15, b =   7, seed = 424)
%pp(lev = 4, nattrs = 11, setsize =  6, maxv = 20, b =  11, seed = 448)
%pp(lev = 3, nattrs = 45, setsize = 12, maxv = 27, b =  45, seed = 462)
%pp(lev = 9, nattrs = 16, setsize =  4, maxv =  9, b =  20, seed = 472)
%pp(lev = 3, nattrs = 15, setsize =  5, maxv = 30, b =  21, seed = 495)
%pp(lev = 7, nattrs =  9, setsize =  3, maxv = 14, b =  12, seed = 513)
%pp(lev = 5, nattrs = 13, setsize =  4, maxv = 20, b =  13, seed = 522)

   */

%mktbsize(nattrs=16, setsize=4)

%mktorth(options=parent, maxlev=144)

data x(keep=n design);
   set mktdeslev;
   array x[144];
   c = 0; one = 0; k = 0;
   do i = 1 to 144;
      c + (x[i] > 0); /* how many differing numbers of levels */
      if x[i] > 1 then do; p = i; k = x[i]; end; /* p^k */
      if x[i] = 1 then do; one + 1; s = i;  end; /* s^1 */
      end;
   if c = 1 then do; c = 2; one = 1; s = p; k = p - 1; end;
   if c = 2 and one = 1 and k > 2 and s * p = n;
   design = compbl(left(design));
   run;

proc print noobs; by n; id n; run;

%mktbibd(b=12, nattrs=12, setsize=6, seed=93, positer=)

%mktex(6 ** 7, n=36, seed=238)

proc sort data=randomized out=randes(drop=x1);
   by x2 x1;
   run;

%mktppro(ibd=bibd, design=randes)

%choiceff(data=chdes,               /* candidate set of choice sets         */
          init=chdes,               /* initial design                       */
          initvars=x1-x12,          /* factors in the initial design        */
          intiter=0,                /* evaluate without internal iterations */
          model=class(x1-x12 / sta),/* model with stdz orthogonal coding    */
          nsets=72,                 /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          rscale=                   /* relative D-efficiency scale factor   */
          %sysevalf(72 * 6 / 12),   /* 6 of 12 attrs in 72 sets vary        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print; by set; id set; var x1-x12; run;

%mktdups(generic, data=best, factors=x1-x12, nalts=6)

%phchoice(off)
