 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MR2010I                                             */
 /*   TITLE: The Macros                                          */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: marketing research                                  */
 /*   PROCS: PHREG, TRANSREG, OPTEX, FACTEX, PLAN, IML           */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: MR-2010I The Macros                                 */
 /*    MISC: This file contains all of the sample code for       */
 /*          "The Macros" report,                                */
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

%mktex(2 3 ** 7, n=18)

****************** Begin ChoicEff Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktex(3 ** 3, n=3**3, seed=238)

proc print; run;

%choiceff(data=design,              /* candidate set of alternatives        */
          model=class(x1-x3 / sta), /* model with stdz orthogonal coding    */
          nsets=9,                  /* number of choice sets                */
          flags=3,                  /* 3 alternatives, generic candidates   */
          seed=289,                 /* random number seed                   */
          maxiter=60,               /* maximum number of designs to make    */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print; var x1-x3; id set; by set; run;

proc print data=bestcov label;
   title 'Variance-Covariance Matrix';
   id __label;
   label __label = '00'x;
   var x:;
   run;
title;

%mktdups(generic, data=best, factors=x1-x3, nalts=3)

proc format;
   value sf 1 = '12 oz' 2 = '16 oz' 3 = '24 oz';
   value cf 1 = 'Red  ' 2 = 'Green' 3 = 'Blue ';
   run;

data ChoiceDesign;
   set best;
   format x1 sf. x2 cf. x3 dollar6.2;
   label x1 = 'Size' x2 = 'Color' x3 = 'Price';
   x3 + 0.49;
   run;

proc print label; var x1-x3; id set; by set; run;

%mktlab(data=design, int=f1-f3)

proc print data=final; run;

%choiceff(data=final,               /* candidate set of alternatives        */
          model=class(x1-x3 / sta), /* model with stdz orthogonal coding    */
          nsets=9,                  /* number of choice sets                */
          flags=f1-f3,              /* flag which alt can go where, 3 alts  */
          seed=289,                 /* random number seed                   */
          maxiter=60,               /* maximum number of designs to make    */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(3 ** 4, n=9)

%mktlab(data=design, vars=Set Size Color Price)

proc print data=final; id set; by set; var size -- price; run;

%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          intiter=0,                /* evaluate without internal iterations */
          model=class(size color    /* main-effects model with stdz         */
                      price / sta), /* orthogonal coding                    */
          nsets=3,                  /* number of choice sets                */
          nalts=3,                  /* number of alternatives               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktdups(generic, data=best, factors=size color price, nalts=3)

%mktex(3 ** 4, n=9, options=nosort)

proc sort; by x4 x1; run;

%mktlab(data=design, vars=Size Color Price Set)

proc print; id set; by set; run;

%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          model=class(size color    /* main-effects model with stdz         */
                      price / sta), /* orthogonal coding                    */
          nsets=3,                  /* number of choice sets                */
          nalts=3,                  /* number of alternatives               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktdups(generic, data=best, factors=size color price, nalts=3)

%mktex(3 ** 9, n=2187, seed=368)

%mktroll(design=design, key=3 3, out=rolled)

%choiceff(data=rolled,              /* candidate set of choice sets         */
          model=class(x1-x3 / sta), /* model with stdz orthogonal coding    */
          nsets=9,                  /* number of choice sets                */
          nalts=3,                  /* number of alternatives               */
          maxiter=20,               /* maximum number of designs to make    */
          seed=205,                 /* random number seed                   */
          options=relative nodups,  /* display relative D-eff, avoid dups   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktdups(generic, data=best, factors=x1-x3, nalts=3)

%mktex(4 ** 6, n=32, seed=104)

%macro res;
   do i = 1 to nalts;
      do k = i + 1 to nalts;
         if all(x[i,] >= x[k,])     /* alt i dominates alt k                */
            then bad = bad + 1;
         if all(x[k,] >= x[i,])     /* alt k dominates alt i                */
            then bad = bad + 1;
         end;
      end;
   %mend;

%choiceff(data=randomized,          /* candidate set of choice sets         */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          nsets=8,                  /* number of choice sets                */
          flags=4,                  /* 4 alternatives, generic candidates   */
          seed=104,                 /* random number seed                   */
          options=relative          /* display relative D-efficiency        */
                  resrep,           /* detailed report on restrictions      */
          restrictions=res,         /* name of the restrictions macro       */
          resvars=x1-x6,            /* vars used in defining restrictions   */
          maxiter=1,                /* maximum number of designs to make    */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc format;
   value x1f 1='Bad'   2='Good'    3='Better'   4='Best';
   value x2f 1='Small' 2='Average' 3='Bigger'   4='Large';
   value x3f 1='Ugly'  2='OK'      3='Average'  4='Nice ';
   value x4f 1='Slow'  2='Fast'    3='Faster'   4='Fastest';
   value x5f 1='Rough' 2='Normal'  3='Smoother' 4='Smoothest';
   value x6f 1='$9.99' 2='$8.99'   3='$7.99'    4='$6.99';
   run;

proc print label;
   label x1 = 'Quality'   x2 = 'Size'       x3 = 'Appearance'
         x4 = 'Speed'     x5 = 'Smoothness' x6 = 'Price';
   format x1 x1f. x2 x2f. x3 x3f. x4 x4f. x5 x5f. x6 x6f.;
   by set; id set; var x:;
   run;

title;
proc iml;
   use best(keep=x1-x6); read all into x;
   sets = 8;
   alts = 4;
   if sets # alts ^= nrow(x) then print 'ERROR: Invalid sets and/or alts.';
   do a = 1 to sets;
      print a[label='Set'] '   '
            (x[((a - 1) * alts + 1) : a * alts,])[format=1.] '          ';
      ii = 0;
      do i = (a - 1) * alts + 1 to a * alts;
         ii = ii + 1;
         kk = ii;
         do k = i + 1 to a * alts;
            kk = kk + 1;
            print ii[label='Alt'] '   ' (x[i,])[format=1.]
                  (sum(x[i,] >= x[k,]))[label='Sum'],
                  kk[label=none]  '   ' (x[k,])[format=1.]
                  (sum(x[k,] >= x[i,]))[label=none];
            if all(x[i,] >= x[k,]) | all(x[k,] >= x[i,]) then
               print "ERROR: Sum=0.";
            end;
         end;
      end;
   quit;

%mktex(4 ** 6, n=32, seed=104)

%macro res;
   do i = 1 to nalts;
      do k = i + 1 to nalts;
         if any(x[i,] >= x[k,]) then bad = bad + 1; /* should be all not any */
         if any(x[k,] >= x[i,]) then bad = bad + 1; /* should be all not any */
         end;
      end;
   %mend;

%choiceff(data=randomized,          /* candidate set of choice sets         */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          nsets=8,                  /* number of choice sets                */
          flags=4,                  /* 4 alternatives, generic candidates   */
          seed=104,                 /* random number seed                   */
          options=relative          /* display relative D-efficiency        */
                  resrep,           /* detailed report on restrictions      */
          restrictions=res,         /* name of the restrictions macro       */
          resvars=x1-x6,            /* vars used in defining restrictions   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(4 ** 6, n=32, seed=104)

%macro res;
   c = 0;                           /* n of constant attrs in x             */
   do i = 1 to ncol(x);
      c = c +                       /* n of constant attrs in x             */
         all(x[,i] = round(x[:,i]));/* all values equal average value       */
      end;
   bad = bad + abs(c - 2);          /* want two attrs constant              */
   %mend;

%choiceff(data=randomized,          /* candidate set of alternatives        */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          nsets=8,                  /* number of choice sets                */
          flags=4,                  /* 4 alternatives, generic candidates   */
          seed=104,                 /* random number seed                   */
          options=relative          /* display relative D-efficiency        */
                  resrep,           /* detailed report on restrictions      */
          restrictions=res,         /* name of the restrictions macro       */
          resvars=x1-x6,            /* variable names used in restrictions  */
          maxiter=1,                /* maximum number of designs to make    */
          bestout=desres2,          /* final choice design                  */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=desres2; id set; by set; var x:; run;

%mktex(4 ** 6, n=128, seed=104, maxdesigns=1, options=nodups)

%macro res;
   c = 0;                           /* n of constant attrs in x             */
   do i = 1 to ncol(x);
      c = c +                       /* n of constant attrs in x             */
         all(x[,i] = round(x[:,i]));/* all values equal average value       */
      end;
   bad = bad + abs(c - 2);          /* want two attrs constant              */
   if c < 2 then do;                /* refine bad if we need more constants */
      do i = 1 to ncol(x);
         bad = bad +                /* count values not at the average      */
               sum(x[,i] ^= round(x[:,i]));
         end;
      end;
   %mend;

%choiceff(data=randomized,          /* candidate set of alternatives        */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          nsets=8,                  /* number of choice sets                */
          flags=4,                  /* 4 alternatives, generic candidates   */
          seed=104,                 /* random number seed                   */
          options=relative          /* display relative D-efficiency        */
                  resrep,           /* detailed report on restrictions      */
          restrictions=res,         /* name of the restrictions macro       */
          resvars=x1-x6,            /* variable names used in restrictions  */
          maxiter=1,                /* maximum number of designs to make    */
          bestout=desres3,          /* final choice design                  */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=desres3; id set; by set; var x:; run;

%mktex(4 ** 6, n=128, seed=104, maxdesigns=1, options=nodups)

%macro res;
   do i = 1 to nalts;
      do k = i + 1 to nalts;
         if all(x[i,] >= x[k,])     /* alt i dominates alt k                */
            then bad = bad + 1;
         if all(x[k,] >= x[i,])     /* alt k dominates alt i                */
            then bad = bad + 1;
         end;
      end;
   c = 0;                           /* n of constant attrs in x             */
   do i = 1 to ncol(x);
      c = c +                       /* n of constant attrs in x             */
         all(x[,i] = round(x[:,i]));/* all values equal average value       */
      end;
   bad = bad + abs(c - 2);          /* want two attrs constant              */
   if c < 2 then do;                /* refine bad if we need more constants */
      do i = 1 to ncol(x);
         bad = bad +                /* count values not at the average      */
               sum(x[,i] ^= round(x[:,i]));
         end;
      end;
   %mend;

%choiceff(data=randomized,          /* candidate set of alternatives        */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          nsets=8,                  /* number of choice sets                */
          flags=4,                  /* 4 alternatives, generic candidates   */
          seed=104,                 /* random number seed                   */
          options=relative          /* display relative D-efficiency        */
                  resrep,           /* detailed report on restrictions      */
          restrictions=res,         /* name of the restrictions macro       */
          resvars=x1-x6,            /* variable names used in restrictions  */
          maxiter=1,                /* maximum number of designs to make    */
          bestout=desres4,          /* final choice design                  */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=desres4; id set; by set; var x:; run;

proc iml;
   use desres4(keep=x1-x6); read all into x;
   sets = 8;
   alts = 4;
   if sets # alts ^= nrow(x) then print 'ERROR: Invalid sets and/or alts.';
   do a = 1 to sets;
      print a[label='Set'] '   '
            (x[((a - 1) * alts + 1):a * alts,])[format=1.] '          ';
      ii = 0;
      do i = (a - 1) * alts + 1 to a * alts;
         ii = ii + 1;
         kk = ii;
         do k = i + 1 to a * alts;
            kk = kk + 1;
            print ii[label='Alt'] '   ' (x[i,])[format=1.]
                  (sum(x[i,] >= x[k,]))[label='Sum'],
                  kk[label=none]  '   ' (x[k,])[format=1.]
                  (sum(x[k,] >= x[i,]))[label=none];
            if all(x[i,] >= x[k,]) | all(x[k,] >= x[i,]) then
               print "ERROR: Sum=0.";
            end;
         end;
      end;
   quit;

%mktex(4 ** 6, n=4096, seed=104)

%macro res;
   do i = 1 to nalts;
      do k = i + 1 to nalts;
         if all(x[i,] >= x[k,])     /* alt i dominates alt k                */
            then bad = bad + 1;
         if all(x[k,] >= x[i,])     /* alt k dominates alt i                */
            then bad = bad + 1;
         end;
      end;
   c = 0;                           /* n of constant attrs in x             */
   do i = 1 to ncol(x);
      c = c +                       /* n of constant attrs in x             */
         all(x[,i] = round(x[:,i]));/* all values equal average value       */
      end;
   bad = bad + abs(c - 2);          /* want two attrs constant              */
   if c < 2 then do;                /* refine bad if we need more constants */
      do i = 1 to ncol(x);
         bad = bad +                /* count values not at the average      */
               sum(x[,i] ^= round(x[:,i]));
         end;
      end;
   %mend;

%choiceff(data=randomized,          /* candidate set of alternatives        */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          nsets=8,                  /* number of choice sets                */
          flags=4,                  /* 4 alternatives, generic candidates   */
          seed=104,                 /* random number seed                   */
          rscale=8 * 6 / 8,         /* relative D-efficiency scale factor   */
                                    /* 6 of 8 attrs in 8 sets vary          */
          options=resrep,           /* detailed report on restrictions      */
          restrictions=res,         /* name of the restrictions macro       */
          resvars=x1-x6,            /* variable names used in restrictions  */
          maxiter=10,               /* maximum number of designs to make    */
          bestout=desres5,          /* final choice design                  */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=desres5; id set; by set; var x:; run;

%mktex(4 ** 6, n=256, seed=104, maxdesigns=1, options=nodups)

%macro res;
   do i = 1 to nalts;
      do k = i + 1 to nalts;
         if all(x[i,] >= x[k,])     /* alt i dominates alt k                */
            then bad = bad + 1;
         if all(x[k,] >= x[i,])     /* alt k dominates alt i                */
            then bad = bad + 1;
         end;
      end;

   nattrs = ncol(x);                /* number of columns in design          */
   v = j(1, nattrs, 0);             /* n of constant attrs across sets      */
   c = 0;                           /* n of constant attrs within set       */

   do i = 1 to nattrs;              /* loop over all attrs                  */
      a    = all(x[,i] = x[1,i]);   /* 1 - attr i constant, 0 - varying     */
      c    = c + a;                 /* n of constant attrs within set       */
      v[i] = v[i] + a;              /* n of constant attrs across sets      */
      end;

   if c > 2 | c = 0 then            /* want 1 or 2 constant attrs in a set  */
      bad = bad + 10 # abs(c - 2);  /* weight of 10 prevents trade offs     */

   do s = 1 to nsets;               /* loop over rest of design             */
      if s ^= setnum then do;       /* skip xmat part that corresponds to x */
         z = xmat[((s-1)*nalts+1) : /* pull out choice set s                */
                  (s * nalts),];
         do i = 1 to nattrs;        /* loop over attrs                      */
            v[i] = v[i] +           /* n of constant attrs across sets      */
                   all(z[,i] = z[1,i]);
            end;
         end;
      end;

   d   = abs(v - {2 1 2 1 2 1})[+]; /* see if constant attrs match target   */
   bad = bad + d;                   /* increase badness                     */
   if d then do;                    /* if not at target, fine tune badness  */
      do i = 1 to nattrs;           /* loop over attrs                      */
         bad = bad +                /* add to badness as attrs are farther  */
               (x[,i] ^= x[1,i])[+];/* from constant                        */
         end;
      end;
   %mend;

%choiceff(data=randomized,          /* candidate set of alternatives        */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          nsets=8,                  /* number of choice sets                */
          flags=4,                  /* 4 alternatives, generic candidates   */
          seed=104,                 /* random number seed                   */
          options=relative          /* display relative D-efficiency        */
                  resrep,           /* detailed report on restrictions      */
          restrictions=res,         /* name of the restrictions macro       */
          resvars=x1-x6,            /* variable names used in restrictions  */
          maxiter=1,                /* maximum number of designs to make    */
          bestout=desres6,          /* final choice design                  */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=desres6; id set; by set; var x:; run;

%mktex(4 ** 6, n=4096)

%macro res2;

   nattrs = 6;                      /* 6 attributes                         */
   nalts  = 4;                      /* 4 alternatives                       */
   z = shape(x, nalts, nattrs);     /* rearrange x to look like a choice set*/

   do ii = 1 to nalts;
      do k = ii + 1 to nalts;
         if all(z[ii,] >= z[k,])    /* alt ii dominates alt k               */
            then bad = bad + 1;
         if all(z[k,] >= z[ii,])    /* alt k dominates alt ii               */
            then bad = bad + 1;
         end;
      end;

   c = 0;                           /* n of constant attrs within set       */
   do ii = 1 to nattrs;             /* loop over all attrs                  */
      c = c +                       /* n of constant attrs within set       */
          all(z[,ii] = z[1,ii]);    /* 1 - attr i constant, 0 - varying     */
      end;
   if c > 2 | c = 0 then            /* want 1 or 2 constant attrs in a set  */
      bad = bad + 10 # abs(c - 2);  /* weight of 10 prevents trade offs     */
   %mend;

%mktex(4 ** 24, n=200, restrictions=res2, seed=104,
       target=90, options=quickr resrep, order=random)

%mktkey(4 6)

%mktroll(design=randomized, key=key, out=rolled)

%macro res;
   nattrs = ncol(x);                /* number of columns in design          */
   v = j(1, nattrs, 0);             /* n of constant attrs across sets      */
   do s = 1 to nsets;               /* loop over each choice set            */
      if s ^= setnum then           /* pull choice set out of xmat          */
         z = xmat[((s - 1) * nalts + 1) : (s * nalts),];
      else z = x;                   /* if current set, get from x           */
      do i = 1 to nattrs;           /* loop over attrs                      */
         v[i] = v[i] +              /* n of constant attrs across sets      */
                all(z[,i] = z[1,i]);
         end;
      end;
   bad = abs(v - {2 1 2 1 2 1})[+]; /* see if constant attrs match target   */
   %mend;

%choiceff(data=rolled,              /* candidate set of choice sets         */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          nsets=8,                  /* number of choice sets                */
          nalts=4,                  /* number of alternatives               */
          seed=104,                 /* random number seed                   */
          options=relative          /* display relative D-efficiency        */
                  resrep,           /* detailed report on restrictions      */
          restrictions=res,         /* name of the restrictions macro       */
          resvars=x1-x6,            /* variable names used in restrictions  */
          maxiter=2,                /* maximum number of designs to make    */
          bestout=desres7,          /* final choice design                  */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=desres7; id set; by notsorted set; var x:; run;

proc iml;
   use desres7(keep=x1-x6); read all into x;
   sets = 8;
   alts = 4;
   if sets # alts ^= nrow(x) then print 'ERROR: Invalid sets and/or alts.';
   do a = 1 to sets;
      print a[label='Set'] '   '
            (x[((a - 1) * alts + 1):a * alts,])[format=1.] '          ';
      ii = 0;
      do i = (a - 1) * alts + 1 to a * alts;
         ii = ii + 1;
         kk = ii;
         do k = i + 1 to a * alts;
            kk = kk + 1;
            print ii[label='Alt'] '   ' (x[i,])[format=1.]
                  (sum(x[i,] >= x[k,]))[label='Sum'],
                  kk[label=none]  '   ' (x[k,])[format=1.]
                  (sum(x[k,] >= x[i,]))[label=none];
            if all(x[i,] >= x[k,]) | all(x[k,] >= x[i,]) then
               print "ERROR: Sum=0.";
            end;
         end;
      end;
   quit;

%mktex(3 ** 3, n=3**3)

data full;
   Set + 1;
   Brand = 0;
   set design;
   retain f1-f3 0;
   array f[3];
   do brand = 1 to 3;
      f[brand] = 1; output; f[brand] = 0;
      end;
   run;

proc print; id set; by set; run;

%macro res;
   c = j(9, 3, 0);                  /* counts - nine positions x 3 levels   */
   do s = 1 to nsets;               /* loop over sets                       */
      if s = setnum then z = x;     /* get choice set from x or xmat        */
      else z = xmat[((s - 1) # nalts + 1) : s # nalts,];
      k = 0;                        /* index into count matrix c            */
      do j = 1 to ncol(z);          /* loop over attributes                 */
         do i = 1 to nalts;         /* loop over alternatives               */
            k = k + 1;              /* index into the next row of c         */
            a = z[i,j];             /* index into c for the z[i,j] level    */
            c[k,a] = c[k,a] + 1;    /* add one to count                     */
            end;
         end;
      end;
   bad = sum((c < 3) # abs(c - 3)) +/* penalty for counts being less than 3 */
         sum((c > 5) # abs(c - 5)); /* penalty for counts greater than 5    */
   %mend;

%choiceff(data=full,                /* candidate set of alternatives        */
          model=class(brand)        /* brand effects                        */
                class(brand*x1      /* alternative-specific effects         */
                      brand*x2
                      brand*x3 /
                      zero=' '),    /* use all brands in these effects      */
          nsets=12,                 /* number of choice sets                */
          seed=104,                 /* random number seed                   */
          options=resrep,           /* detailed report on restrictions      */
          restrictions=res,         /* name of the restrictions macro       */
          resvars=x1-x3,            /* variable names used in restrictions  */
          flags=f1-f3,              /* flag which alt can go where, 3 alts  */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print; var brand x:; id set; by set; run;

proc iml;
   nsets = 12;  nalts = 3;
   use best(keep=x:); read all into xmat;
   c = j(9, 3, 0);                  /* counts - nine positions x 3 levels   */
   do s = 1 to nsets;               /* loop over sets                       */
      z = xmat[((s - 1) # nalts + 1) : s # nalts,];
      k = 0;                        /* index into count matrix c            */
      do j = 1 to ncol(z);          /* loop over attributes                 */
         do i = 1 to nalts;         /* loop over alternatives               */
            k = k + 1;              /* index into next row of c             */
            a = z[i,j];             /* index into c for the z[i,j] level    */
            c[k,a] = c[k,a] + 1;    /* add one to count                     */
            end;
         end;
      end;
   print c[format=2.];
   quit;

%macro res;
   c = j(9, 3, 0);                  /* counts - nine positions x 3 levels   */
   do s = 1 to nsets;               /* loop over sets                       */
      if s = setnum then z = x;     /* get choice set from x or xmat        */
      else z = xmat[((s - 1) # nalts + 1) : s # nalts,];
      k = 0;                        /* index into count matrix c            */
      do j = 1 to ncol(z);          /* loop over attributes                 */
         do i = 1 to nalts;         /* loop over alternatives               */
            k = k + 1;              /* index into the next row of c         */
            a = z[i,j];             /* index into c for the z[i,j] level    */
            c[k,a] = c[k,a] + 1;    /* add one to count                     */
            end;
         end;
      end;
   bad = sum(abs(c - 4));           /* penalty for counts not at 4          */
   %mend;

%choiceff(data=full,                /* candidate set of alternatives        */
          model=class(brand)        /* brand effects                        */
                class(brand*x1      /* alternative-specific effects         */
                      brand*x2
                      brand*x3 /
                      zero=' '),    /* use all brands in these effects      */
          nsets=12,                 /* number of choice sets                */
          seed=104,                 /* random number seed                   */
          options=resrep,           /* detailed report on restrictions      */
          restrictions=res,         /* name of the restrictions macro       */
          resvars=x1-x3,            /* variable names used in restrictions  */
          flags=f1-f3,              /* flag which alt can go where, 3 alts  */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc iml;
   nsets = 12;  nalts = 3;
   use best(keep=x:); read all into xmat;
   c = j(9, 3, 0);                  /* counts - nine positions x 3 levels   */
   do s = 1 to nsets;               /* loop over sets                       */
      z = xmat[((s - 1) # nalts + 1) : s # nalts,];
      k = 0;                        /* index into count matrix c            */
      do j = 1 to ncol(z);          /* loop over attributes                 */
         do i = 1 to nalts;         /* loop over alternatives               */
            k = k + 1;              /* index into next row of c             */
            a = z[i,j];             /* index into c for the z[i,j] level    */
            c[k,a] = c[k,a] + 1;    /* add one to count                     */
            end;
         end;
      end;
   print c[format=2.];
   quit;

%choiceff(data=full,                /* candidate set of alternatives        */
          model=class(brand)        /* brand effects                        */
                class(brand*x1      /* alternative-specific effects         */
                      brand*x2
                      brand*x3 /
                      zero=' '),    /* use all brands in these effects      */
          nsets=12,                 /* number of choice sets                */
          seed=104,                 /* random number seed                   */
          flags=f1-f3,              /* flag which alt can go where, 3 alts  */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(3 ** 4, n=3**4)

%mktlab(data=design, vars=x1-x3 Brand)

data full(drop=i);
   set final;
   array f[3];
   do i = 1 to 3; f[i] = (brand eq i); end;
   run;

proc print data=full(obs=9); run;

%choiceff(data=full,                /* candidate set of alternatives        */
                                    /* alternative-specific effects model   */
                                    /* zero=' ' no reference level for brand*/
                                    /* brand*x1 ... interactions            */
          model=class(brand brand*x1 brand*x2 brand*x3 / zero=' ' sta),
          nsets=15,                 /* number of choice sets                */
          flags=f1-f3,              /* flag which alt can go where, 3 alts  */
          seed=151,                 /* random number seed                   */
          converge=1e-12,           /* convergence criterion                */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%choiceff(data=full,                /* candidate set of alternatives        */
          init=best(keep=index),    /* select these alts from candidates    */
                                    /* alternative-specific effects model   */
                                    /* zero=' ' no reference level for brand*/
                                    /* brand*x1 ... interactions            */
          model=class(brand brand*x1 brand*x2 brand*x3 / zero=' ' sta),
          drop=brand3,              /* extra model terms to drop from model */
          seed=522,                 /* random number seed                   */
          nsets=15,                 /* number of choice sets                */
          flags=f1-f3,              /* flag which alt can go where, 3 alts  */
          converge=1e-12,           /* convergence criterion                */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%choiceff(data=full,                /* candidate set of alternatives        */
          init=best(keep=index),    /* select these alts from candidates    */
                                    /* alternative-specific effects model   */
                                    /* zero=' ' no reference level for brand*/
                                    /* brand*x1 ... interactions            */
          model=class(brand x1 x2 x3 brand*x1 brand*x2 brand*x3 / sta),
          seed=522,                 /* random number seed                   */
          nsets=15,                 /* number of choice sets                */
          flags=f1-f3,              /* flag which alt can go where, 3 alts  */
          converge=1e-12,           /* convergence criterion                */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktruns(15 3 3 3 3, interact=2*3 2*4 2*5)

%mktex(15 3 ** 4, n=45)

%mktlab(data=design, vars=Set Brand x1-x3)

%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          model=class(brand x1 x2 x3 / sta), /* model w stdzd orthog coding */
          nsets=15,                 /* 6 choice sets                        */
          nalts=3,                  /* 3 alternatives per set               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc format;
   value price 1 = ' 999'      2 = '1249'            3 = '1499';
   value scene 1 = 'Mountains' 2 = 'Lake'            3 = 'Beach';
   value lodge 1 = 'Cabin'     2 = 'Bed & Breakfast' 3 = 'Hotel';
   run;

%mktex(3 ** 3, n=27)

data cand;
   retain f1-f6 0;
   length Place $ 10 Price Scene Lodge 8;
   if _n_ = 1 then do; f6 = 1; Place = 'Home'; output; f6 = 0; end;
   set design(rename=(x1=Price x2=Scene x3=Lodge));
   price = input(put(price, price.), 5.);
   f1 = 1; Place = 'Hawaii';     output; f1 = 0;
   f2 = 1; Place = 'Alaska';     output; f2 = 0;
   f3 = 1; Place = 'Mexico';     output; f3 = 0;
   f4 = 1; Place = 'California'; output; f4 = 0;
   f5 = 1; Place = 'Maine';      output; f5 = 0;
   format scene scene. lodge lodge.;
   run;

%choiceff(data=cand,                /* candidate set of alternatives        */
          model=class(place /       /* alternative effects                  */
                      zero=none     /* zero=none - use all levels           */
                      order=data)   /* use ordering of levels from data set */
                class(place * price /* alternative-specific effect of price */
                      place * scene /* alternative-specific effect of scene */
                      place * lodge /* alternative-specific effect of lodge */
                    / zero=none     /* zero=none - use all levels of place  */
                      order=formatted)/* order=formatted - sort levels      */
              / lprefix=0           /* lpr=0 labels created from just levels*/
                cprefix=0           /* cpr=0 names created from just levels */
                separators=' ' ', ',/* use comma sep to build interact terms*/
          nsets=36,                 /* number of choice sets                */
          flags=f1-f6,              /* six alternatives, alt-specific       */
          seed=104,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%choiceff(data=cand,                /* candidate set of alternatives        */
          model=class(place /       /* alternative effects                  */
                      zero='Home'   /* use 'Home' as reference level        */
                      order=data)   /* use ordering of levels from data set */
                                    /* place * price ... - interactions or  */
                class(place * price /* alternative-specific effect of price */
                      place * scene /* alternative-specific effect of scene */
                      place * lodge /* alternative-specific effect of lodge */
                    / zero='Home'   /* use 'Home' as reference level        */
                      order=formatted)/* order=formatted - sort levels      */
              / lprefix=0           /* lpr=0 labels created from just levels*/
                cprefix=0           /* cpr=0 names created from just levels */
                separators=' ' ', ',/* use comma sep to build interact terms*/
          nsets=36,                 /* number of choice sets                */
          flags=f1-f6,              /* six alternatives, alt-specific       */
          maxiter=100,              /* maximum number of designs to make    */
          seed=104,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

options ps=200 missing=' ';
proc print;
   id set;
   by set;
   var place -- lodge;
   run;
options ps=60 missing='.';

proc transreg data=best design norestoremissing;
   model class(place / zero='Home' order=data)
         class(place * price place * scene place * lodge /
               zero='Home' order=formatted) /
         lprefix=0 cprefix=0 separators=' ' ', ';
   output out=coded;
   run;

proc print data=coded(obs=6) noobs label;
   var place -- lodge Hawaii -- Maine;
   run;

proc print data=coded(obs=6) noobs label;
   var place Alaska_999 Alaska_1249 California_999 California_1249;
   run;

proc print data=coded(obs=6) noobs label;
   var place Hawaii_999 Hawaii_1249 Maine_999 Maine_1249 Mexico_999 Mexico_1249;
   run;

proc print data=coded(obs=6) noobs label;
   var place AlaskaBeach AlaskaLake CaliforniaBeach CaliforniaLake;
   run;

proc print data=coded(obs=6) noobs label;
   var place HawaiiBeach HawaiiLake MaineBeach MaineLake MexicoBeach MexicoLake;
   run;

proc print data=coded(obs=6) noobs label;
   var place AlaskaBed___Breakfast AlaskaCabin
       CaliforniaBed___Breakfast CaliforniaCabin;
   run;

proc print data=coded(obs=6) noobs label;
   var place HawaiiBed___Breakfast HawaiiCabin MaineBed___Breakfast MaineCabin
        MexicoBed___Breakfast MexicoCabin;
   run;

%mktex(3 ** 9, n=2187, seed=121)

data key;
   input (Brand x1-x3) ($);
   datalines;
1 x1 x2 x3
2 x4 x5 x6
3 x7 x8 x9
;

%mktroll(design=design, key=key, alt=brand, out=rolled)

%choiceff(data=rolled,              /* candidate set of choice sets         */
                                    /* alternative-specific model           */
                                    /* effects coding of interactions       */
                                    /* zero=' ' no reference level for brand*/
                                    /* brand*x1 ... interactions            */
          model=class(brand)
                class(brand*x1 brand*x2 brand*x3 / effects zero=' '),
          nsets=15,                 /* number of choice sets                */
          nalts=3)                  /* number of alternatives               */

%choiceff(data=rolled,              /* candidate set of choice sets         */
                                    /* alternative-specific model           */
                                    /* effects coding of interactions       */
                                    /* zero=' ' no reference level for brand*/
                                    /* brand*x1 ... interactions            */
          model=class(brand)
                class(brand*x1 brand*x2 brand*x3 / effects zero=' '),

          nsets=15,                 /* number of choice sets                */
          nalts=3,                  /* number of alternatives               */
          n=100,                    /* n obs to use in variance formula     */
          seed=462,                 /* random number seed                   */
          beta=1 2 -0.5 0.5 -0.75 0.75 -1 1
               -0.5 0.5 -0.75 0.75 -1 1 -0.5 0.5 -0.75 0.75 -1 1)

%mktex(3 ** 5, n=3**5)

data key;
   input (Brand Price) ($);
   datalines;
1 x1
2 x2
3 x3
4 x4
5 x5
. .
;

%mktroll(design=design, key=key, alt=brand, out=rolled, keep=x1-x5)

proc print; by set; id set; where set in (1, 48, 101, 243); run;

%choiceff(data=rolled,              /* candidate set of choice sets         */
                                    /* model with cross-effects             */
                                    /* zero=none - use all levels           */
                                    /* ide(...) * class(...) - cross-effects*/
          model=class(brand brand*price / zero=none)
                identity(x1-x5) * class(brand / zero=none),
          nsets=20,                 /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          seed=17,                  /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%choiceff(data=rolled,              /* candidate set of choice sets         */
                                    /* zero=' ' no reference level for brand*/
                                    /* model with cross-effects             */
                                    /* zero=none - use all levels           */
                                    /* ide(...) * class(...) - cross-effects*/
          model=class(brand brand*price / zero=' ')
                identity(x1-x5) * class(brand / zero=none),

                                    /* extra model terms to drop from model */
          drop=x1Brand1 x2Brand2 x3Brand3 x4Brand4 x5Brand5,
          nsets=20,                 /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          seed=17,                  /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc format;
   value bf 11 = 'None';
   run;

data cand(keep=brand price f:);
   retain Brand Price f1-f11 0;
   array p[8];
   array f[11];
   infile cards missover;
   input Brand p1-p8;
   do i = 1 to 8;
      Price = p[i];
      if n(price) or (i = 1 and brand = 11) then do;
         f[brand] = 1; output; f[brand] = 0;
         end;
      end;
   format brand bf.;

   datalines;
 1 0.89 0.94 0.99 1.04 1.09 1.14 1.19 1.24
 2 0.94 0.99 1.04 1.09 1.14 1.19 1.24 1.29
 3 0.99 1.04 1.09 1.14 1.19 1.24
 4 0.89 0.94 0.99 1.04 1.09 1.14
 5 1.04 1.09 1.14 1.19 1.24 1.29
 6 0.89 0.99 1.09 1.19
 7 0.99 1.09 1.19 1.29
 8 0.94 0.99 1.14 1.19
 9 1.09 1.14 1.19 1.24
10 1.14 1.19 1.24 1.29
11
;

proc print; run;

%choiceff(data=cand,                /* candidate set of alternatives        */
          model=class(brand         /* model with brand and                 */
                      brand*price / /* brand by price effects               */
                      zero=none) /  /* zero=none - use all levels           */
                      lprefix=0     /* use just levels in variable labels   */
                      cprefix=1,    /* use one var name char in new names   */
          nsets=24,                 /* number of choice sets                */
          flags=f1-f11,             /* flag which alt can go where, 11 alts */
          seed=462,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%let vars=
BNone B1P1D24 B1P1D29 B2P0D89 B2P1D29 B3P0D89 B3P0D94 B3P1D24 B3P1D29 B4P1D14
B4P1D19 B4P1D24 B4P1D29 B5P0D89 B5P0D94 B5P0D99 B5P1D29 B6P0D94 B6P1D04 B6P1D14
B6P1D19 B6P1D24 B6P1D29 B7P0D89 B7P0D94 B7P1D04 B7P1D14 B7P1D24 B7P1D29 B8P0D89
B8P1D04 B8P1D09 B8P1D19 B8P1D24 B8P1D29 B9P0D89 B9P0D94 B9P0D99 B9P1D04 B9P1D24
B9P1D29 B10P0D89 B10P0D94 B10P0D99 B10P1D04 B10P1D09 B10P1D29 BNoneP0D89
BNoneP0D94 BNoneP0D99 BNoneP1D04 BNoneP1D09 BNoneP1D14 BNoneP1D19 BNoneP1D24
BNoneP1D29;

%choiceff(data=cand,                /* candidate set of alternatives        */
          model=class(brand         /* model with brand and                 */
                      brand*price / /* brand by price effects               */
                      zero=none) /  /* zero=none - use all levels           */
                      lprefix=0     /* use just levels in variable labels   */
                      cprefix=1,    /* use one var name char in new names   */
          drop=&vars,               /* extra terms to drop                  */
          nsets=24,                 /* number of choice sets                */
          flags=f1-f11,             /* flag which alt can go where, 11 alts */
          seed=462,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */


proc print data=best(obs=22); id set; by set; var brand price; run;

%mktruns(3 2 ** 6  3 2 ** 6  3 2 ** 6)

%mktex(3 2 ** 6  3 2 ** 6  3 2 ** 6, n=72, seed=289)

data cand;                          /* new candidates with recoded price    */
   set randomized;                  /* use randomized design from MktEx     */
   x1  = 0.5 + 0.25 * x1;           /* map 1, 2, 3 to 0.75, 1.0, 1.25       */
   d1  = 0;                         /* discount for first alt is no discount*/
   d2  = 2 + x8;                    /* map 1, 2, 3 to 3%, 4%, 5% discount   */
   d3  = 5 + x15;                   /* map 1, 2, 3 to 6%, 7%, 8% discount   */
   x8  = round(x1 * (1 - d2 / 100), 0.01);/* apply discount to second alt   */
   x15 = round(x1 * (1 - d3 / 100), 0.01);/* apply discount to third alt    */
   run;

proc print data=cand(obs=10); run;

%mktkey(3 7)

data key;
   input (Price x2-x7 Discount) ($);
   datalines;
x1     x2     x3     x4     x5     x6     x7   d1
x8     x9     x10    x11    x12    x13    x14  d2
x15    x16    x17    x18    x19    x20    x21  d3
;

proc print; run;

%mktroll(design=cand, key=key, out=cand2)

proc print data=cand2(obs=30); id set; by set; run;

%choiceff(data=cand2,               /* candidate set of choice sets         */
          model=ide(Price)          /* model with quantitative price effect */
                class(x2-x7 / effects), /* binary attributes, effects coded */
          nsets=20,                 /* 20 choice sets                       */
          nalts=3,                  /* 3 alternatives per set               */
          morevars=discount,        /* add this var to the output data set  */
          drop=discount,            /* do not add this var to the model     */
          seed=292,                 /* random number seed                   */
          options=nodups,           /* no duplicate choice sets             */
          maxiter=10,               /* maximum number of designs to create  */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=bestcov label;
   title 'Variance-Covariance Matrix';
   id __label;
   label __label = '00'x;
   var price x:;
   run;
title;

proc freq data=best; tables price; run;

%choiceff(data=cand2,               /* candidate set of choice sets         */
          model=class(Price / zero=none)/* model with qualitative price     */
                class(x2-x7 / effects), /* binary attributes, effects coded */
          nsets=20,                 /* 20 choice sets                       */
          nalts=3,                  /* 3 alternatives per set               */
          morevars=discount,        /* add this var to the output data set  */
          drop=discount,            /* do not add this var to the model     */
          seed=292,                 /* random number seed                   */
          options=nodups,           /* no duplicate choice sets             */
          maxiter=10,               /* maximum number of designs to create  */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc freq data=best; tables price; run;

%mktex(3 2 ** 6  3 2 ** 6  3 2 ** 6, n=2 * 72, seed=289)

%mkteval;

* Eliminate or replace options=quick when you know what you are doing.
*
* Increase n=.  Small values are good for testing.
* Larger values should give better designs.
;

%mktruns(2 3 4 3 2 4, interact=1*2)

%mktex(2 3 4 3 2 4,                 /* attrs for proposed brands            */
       interact=1*2,                /* x1*x2 interaction                    */
       n=24,                        /* number of candidate alternatives     */
       seed=292,                    /* random number seed                   */
       out=d1,                      /* output experimental design           */
       options=quick)               /* provides a quick run initially       */

%mktruns(5 4 4 3 2 4, interact=1*2)

%mktex(5 4 4 3 2 4,                 /* attrs for current brands             */
       interact=1*2,                /* x1*x2 interaction                    */
       n=40,                        /* number of candidate alternatives     */
       seed=292,                    /* random number seed                   */
       out=d2,                      /* output experimental design           */
       options=quick)               /* provides a quick run initially       */

* Create full candidate design.;
data all;
   retain f1-f8 Brand 1;
   set d1(in=d1) d2(in=d2);

   * Make alternative-specific changes to the price
   * and other attribute levels in here as necessary.
   ;

   * For Brand 1 and Brand 2, write out the other attrs;
   if d1 then do;
      do brand = 1 to 2; output; end;
      end;

   * For Brand 3 through Brand 10, write out the other attrs;
   if d2 then do;
      do brand = 3 to 10; output; end;
      end;
   run;

* For the next three calls to the choiceff macro:
* Recode model with alternative-specific effects?
* Drop maxiter=1 or increase the value later.
* Consider increasing nsets= later.
;

                                    /* get a design with 6 alternatives     */
%choiceff(data=all,                 /* candidate set of alternatives        */
          bestout=b1,               /* name of output design data set       */
                                    /* model with main effects, interaction */
          model=class(brand x1-x6 x1 * x2),
          flags=f1-f6,              /* flag which alt can go where, 6 alts  */
          nsets=20,                 /* number of choice sets                */
          maxiter=1,                /* maximum number of designs to make    */
          seed=109,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

                                    /* get a design with 7 alternatives     */
%choiceff(data=all,                 /* candidate set of alternatives        */
          bestout=b2,               /* name of output design data set       */
                                    /* model with main effects, interaction */
          model=class(brand x1-x6 x1 * x2),
          flags=f1-f7,              /* flag which alt can go where, 7 alts  */
          nsets=20,                 /* number of choice sets                */
          maxiter=1,                /* maximum number of designs to make    */
          seed=114,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

                                    /* get a design with 8 alternatives     */
%choiceff(data=all,                 /* candidate set of alternatives        */
          bestout=b3,               /* name of output design data set       */
                                    /* model with main effects, interaction */
          model=class(brand x1-x6 x1 * x2),
          flags=f1-f8,              /* flag which alt can go where, 8 alts  */
          nsets=20,                 /* number of choice sets                */
          maxiter=1,                /* maximum number of designs to make    */
          seed=121,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

* Concatenate the three designs, create a new Set variable,
* and flag the three different sizes of choice sets with SetType=1, 2, 3.
* We will use this (with a bit more modification) as a candidate set for
* making the final design.
;
data best(keep=Set Brand SetType AltType x1-x6);
   set b1(in=b1) b2(in=b2) b3(in=b3);
   if set ne lag(set) then newset + 1;
   SetType = b1 + 2 * b2 + 3 * b3;
   AltType = 1 + (brand gt 2);
   set = newset;
   run;

* Extract just the choice sets where no brand appears more than once.
* In other words, if the maximum frequency by set is 1, keep it.
* Start by seeing how often each brand occurs within each set;
;
proc freq data=best noprint; tables set * brand / out=list; run;

* Find the maximum frequency.;
proc means noprint; var count; by set;
   output out=maxes(where=(_stat_ eq 'MAX'));
   run;

* Output the set number if the maximum frequency is one.;
data sets; set; if count = 1; keep set; run;

* Select the sets where the maximum frequency is one.;
data best; merge best sets(in=one); by set; if one; run;

* Report on the set and SetType variables as an error check.;
proc freq; tables set * SetType / list; run;

* Sort the design by brand within set.;
proc sort data=best; by set brand; run;

* Add alternative numbers within set.  Get consecutive set numbers again.;
data best(drop=oldset);
   set best(rename=(set=oldset)); by oldset;
   if first.oldset then do; Alt = 0; Set + 1; end;
   alt + 1;
   call symputx('maxset', set);
   run;

* Display the candidate design.;
proc print; var settype alttype brand x1-x6; by set; id set alt; run;

* Make the choice set alternative numbers you would have if all
* sets had the maximum 8 alternatives.  We will need this kind of layout
* because ChoicEff assumes all sets have the same alternatives, and uses
* weights when they don't.
;
data frame;
   do Set = 1 to &maxset;
      do Alt = 1 to 8;
         output;
         end;
      end;
   run;

* Add missing observations to the sets with 6 and 7 alternatives.
* Flag alternatives actually there with w = 1 and the rest with w = 0.
;
data all; merge frame best(in=b); by set alt; w = b; run;

proc print; var settype brand alttype x1-x6; by set; id set alt w; run;

* Create a final design with 3 types of choice sets,
* 12 with 6 alternatives, 12 with 7, and 12 with 8, using weights
* to ignore the dummy alternatives.
* The candidate set has all three types of choice sets.
;

%choiceff(data=all,                 /* candidate set of choice sets         */
                                    /* model with main effects, interaction */
          model=class(brand x1-x6 x1 * x2),
          nalts=8,                  /* number of alternatives               */
          weight=w,                 /* weight to ignore dummy alternatives  */
          types=12 12 12,           /* number of each type of set           */
          typevar=settype,          /* choice set types variable            */
          nsets=36,                 /* number of choice sets                */
          maxiter=1,                /* maximum number of designs to make    */
          seed=396,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

* Display final design.;
proc print;
   var brand settype alttype x1-x6;
   by notsorted set;
   id set alt;
   where w;
   run;

* Check for duplicate choice sets.;
proc freq data=best; tables set; run;

%mktruns(3 ** 9)

%mktex(3 ** 9, n=27, seed=292)

%mktroll(design=randomized, key=3 3, out=cand)

%choiceff(data=cand,                /* candidate set of choice sets         */
          model=class(x1-x3 / sta), /* model with stdz orthogonal coding    */
          seed=513,                 /* random number seed                   */
          maxiter=5,                /* maximum number of designs to make    */
          options=relative nodups,  /* display relative D-efficiency        */
          nsets=18,                 /* number of choice sets                */
          nalts=3,                  /* number of alternatives               */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(3 ** 9, n=36, seed=292)
%mktroll(design=randomized, key=3 3, out=cand)
%choiceff(data=cand, model=class(x1-x3 / sta), seed=513, maxiter=5,
          options=relative nodups, nsets=18, nalts=3, beta=zero)

%mktex(3 ** 9, n=45, seed=292)
%mktroll(design=randomized, key=3 3, out=cand)
%choiceff(data=cand, model=class(x1-x3 / sta), seed=513, maxiter=5,
          options=relative nodups, nsets=18, nalts=3, beta=zero)

%mktex(3 ** 9, n=54, seed=292)
%mktroll(design=randomized, key=3 3, out=cand)
%choiceff(data=cand, model=class(x1-x3 / sta), seed=513, maxiter=5,
          options=relative nodups, nsets=18, nalts=3, beta=zero)

%mktex(3 ** 9, n=3 ** 4, seed=292)
%mktroll(design=randomized, key=3 3, out=cand)
%choiceff(data=cand, model=class(x1-x3 / sta), seed=513, maxiter=5,
          options=relative nodups, nsets=18, nalts=3, beta=zero)

%mktex(3 ** 9, n=3 ** 5, seed=292)
%mktroll(design=randomized, key=3 3, out=cand)
%choiceff(data=cand, model=class(x1-x3 / sta), seed=513, maxiter=5,
          options=relative nodups, nsets=18, nalts=3, beta=zero)

%mktex(3 ** 9, n=3 ** 6, seed=292)
%mktroll(design=randomized, key=3 3, out=cand)
%choiceff(data=cand, model=class(x1-x3 / sta), seed=513, maxiter=5,
          options=relative nodups, nsets=18, nalts=3, beta=zero)

%mktex(3 ** 9, n=3 ** 7, seed=292)
%mktroll(design=randomized, key=3 3, out=cand)
%choiceff(data=cand, model=class(x1-x3 / sta), seed=513, maxiter=5,
          options=relative nodups, nsets=18, nalts=3, beta=zero)

%mktex(3 ** 9, n=3 ** 8, seed=292)
%mktroll(design=randomized, key=3 3, out=cand)
%choiceff(data=cand, model=class(x1-x3 / sta), seed=513, maxiter=5,
          options=relative nodups, nsets=18, nalts=3, beta=zero)

%mktex(3 ** 9, n=3 ** 9, seed=292)
%mktroll(design=randomized, key=3 3, out=cand)
%choiceff(data=cand, model=class(x1-x3 / sta), seed=513, maxiter=5,
          options=relative nodups, nsets=18, nalts=3, beta=zero)

%mktruns(3 ** 6)

%mktex(3 ** 6, n=18, seed=306)

%choiceff(data=design,              /* candidate set of alternatives        */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          maxiter=400,              /* maximum number of designs to make    */
          seed=121,                 /* random number seed                   */
          flags=3,                  /* 3 alternatives, generic candidates   */
          nsets=6,                  /* number of choice sets                */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

   /* Uncomment this code if you want it to run

%mktex(3 ** 6, n=27, seed=306)
%choiceff(data=design, model=class(x1-x6 / sta), maxiter=400, seed=121,
          flags=3, nsets=6, options=relative, beta=zero)

%mktex(3 ** 6, n=36, seed=306)
%choiceff(data=design, model=class(x1-x6 / sta), maxiter=400, seed=121,
          flags=3, nsets=6, options=relative, beta=zero)

%mktex(3 ** 6, n=54, seed=306)
%choiceff(data=design, model=class(x1-x6 / sta), maxiter=400, seed=121,
          flags=3, nsets=6, options=relative, beta=zero)

%mktex(3 ** 6, n=72, seed=306)
%choiceff(data=design, model=class(x1-x6 / sta), maxiter=400, seed=121,
          flags=3, nsets=6, options=relative, beta=zero)

%mktex(3 ** 6, n=81, seed=306)
%choiceff(data=design, model=class(x1-x6 / sta), maxiter=400, seed=121,
          flags=3, nsets=6, options=relative, beta=zero)

%mktex(3 ** 6, n=108, seed=306)
%choiceff(data=design, model=class(x1-x6 / sta), maxiter=400, seed=121,
          flags=3, nsets=6, options=relative, beta=zero)

   */

%mktex(6 3 ** 6, n=18, seed=306)

%mktlab(data=design, vars=Set x1-x6, out=final)

proc print data=final;
   by set;
   id set;
   var x1-x6;
   run;

%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          nalts=3,                  /* number of alternatives               */
          nsets=6,                  /* number of choice sets                */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktorth(range=n=36, options=lineage)

proc print data=mktdeslev; var lineage; where x3 ge 6; run;

%mktex(3 ** 6,                      /* 6 three-level factors                */
       n=36,                        /* 36 runs                              */
       seed=306,                    /* random number seed                   */
       options=lineage)             /* display OA construction instructions */

%mktorth(range=n=36, options=lineage dups)

data lev;
   set mktdeslev;
   where lineage ? '2 ** 2 18' and lineage ? '3 ** 6 6' and
         not (lineage ? ': 6');
   run;

%mktex(3 ** 6,                      /* 6 three-level factors                */
       n=36,                        /* 36 runs                              */
       seed=306,                    /* random number seed                   */
       options=lineage,             /* display OA construction instructions */
       cat=lev)                     /* OA catalog comes from lev data set   */

%choiceff(data=design,              /* candidate set of alternatives        */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          maxiter=400,              /* maximum number of designs to make    */
          seed=121,                 /* random number seed                   */
          flags=3,                  /* 3 alternatives, generic candidates   */
          nsets=6,                  /* number of choice sets                */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(5 ** 6, n=25)

%mktlab(data=design, vars=Set x1-x5)

                                    /* evaluate design                      */
%choiceff(data=final,               /* candidate set of choice sets         */
          init=final(keep=set),     /* select these sets from candidates    */
          intiter=0,                /* evaluate without internal iterations */
          model=class(x1-x5 / sta), /* model with stdzd orthogonal coding   */
          nsets=5,                  /* 5 choice sets                        */
          nalts=5,                  /* 5 alternatives per set               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(3 ** 6 6, n=18, options=nosort)

data design(keep=x1-x6);            /* There are easier ways to make this   */
   set design(obs=6);               /* design.  This example is just for    */
   array x[6];                      /* illustration.                        */
   output;
   do i = 1 to 6; x[i] = mod(x[i], 3) + 1; end;
   output;
   do i = 1 to 6; x[i] = mod(x[i], 3) + 1; end;
   output;
   run;

%choiceff(data=design,              /* candidate set of choice sets         */
          init=design,              /* initial design                       */
          initvars=x1-x6,           /* factors in the initial design        */
          intiter=0,                /* evaluate without internal iterations */
          model=class(x1-x6 / sta), /* model with stdzd orthogonal coding   */
          nsets=6,                  /* 6 choice sets                        */
          nalts=3,                  /* 3 alternatives per set               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(3 ** 3, n=27, seed=238)

                                    /* search for a design                  */
%choiceff(data=randomized,          /* candidate set of alternatives        */
          model=class(x1-x3),       /* main effects with ref cell coding    */
          nsets=3,                  /* number of choice sets                */
          flags=3,                  /* 3 alternatives, generic candidates   */
          seed=382,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

                                    /* evaluate design                      */
%choiceff(data=randomized,          /* candidate set of alternatives        */
          init=best(keep=index),    /* select these alts from candidates    */
          intiter=0,                /* evaluate without internal iterations */
          model=class(x1-x3 / sta), /* model with stdz orthogonal coding    */
          nsets=3,                  /* number of choice sets                */
          flags=3,                  /* 3 alternatives, generic candidates   */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(2 ** 6, n=64)

%mktroll(design=design, key=2 3, out=cand)

                                    /* search for a design                  */
%choiceff(data=cand,                /* candidate set of choice sets         */
          model=class(x1-x3),       /* main effects with ref cell coding    */
          nsets=8,                  /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
          seed=151,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

                                    /* evaluate design                      */
%choiceff(data=cand,                /* candidate set of choice sets         */
          init=best(keep=set),      /* select these sets from candidates    */
          intiter=0,                /* evaluate without internal iterations */
          model=class(x1-x3 / sta), /* model with stdzd orthogonal coding   */
          nsets=8,                  /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(3 ** 4 6, n=18)

proc sort data=design out=design(drop=x5); by x1 x5; run;

%mktbibd(b=20, t=16, k=4, seed=104, out=b)

%mktppro(ibd=b, print=f p)

%choiceff(data=chdes,               /* candidate set of choice sets         */
          init=chdes(keep=set),     /* select these sets from candidates    */
          intiter=0,                /* no iterations, just evaluate         */
          model=class(x1-x6 / sta), /* model with stdz orthogonal coding    */
          nsets=120,                /* number of choice sets                */
          nalts=3,                  /* number of alternatives               */
          rscale=partial=4 of 16,   /* partial profiles, 4 of 16 vary       */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktex(6 3 ** 6, n=18, seed=104);

%mktlab(data=randomized, vars=Set x1-x6)

proc sort data=final; by set; run;

data chdes;
   set final;
   by set;
   output;
   if last.set then do;
      x1 = .; x2 = .; x3 = .;
      x4 = .; x5 = .; x6 = .;
      output;
      end;
   run;

proc print; by set; id set; run;

%choiceff(data=chdes,               /* candidate set of choice sets         */
          init=chdes(keep=set),     /* select these sets from candidates    */
          intiter=0,                /* no iterations, just evaluate         */
          model=class(x1-x6 / sta), /* model with stdzd orthogonal coding   */
          nsets=6,                  /* 6 choice sets                        */
          nalts=4,                  /* number of alternatives               */
          rscale=partial=3 of 4,    /* relative D-eff, 3 of 4 attrs vary    */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc format;
   value zer -1e-12 - 1e-12 = ' 0   ';
   run;

proc print data=bestcov label;
   title 'Variance-Covariance Matrix';
   id __label;
   label __label = '00'x;
   var x:;
   format _numeric_ zer5.2;
   run;
title;

%mktex(3 ** 6, n=729, seed=104);

data cand;
   retain f1-f4 0;
   if _n_ = 1 then do;
      f4 = 1; output; f1 = 1; f2 = 1; f3 = 1; f4 = 0;
      end;
   set randomized;
   output;
   run;

proc print data=cand; run;

%choiceff(data=cand,                /* candidate set of alternatives        */
          model=class(x1-x6 / sta), /* model with stdzd orthogonal coding   */
          flags=f1-f4,              /* flag which alts go where             */
          nsets=6,                  /* 6 choice sets                        */
          maxiter=30,               /* maximum designs to make              */
          rscale=partial=3 of 4,    /* relative D-eff, 3 of 4 attrs vary    */
          seed=104,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=bestcov label;
   title 'Variance-Covariance Matrix';
   id __label;
   label __label = '00'x;
   var x:;
   format _numeric_ zer5.2;
   run;
title;

%mktex(3 ** 12, n=27, seed=104)

%mktkey(3 4)

data key; Brand = scan('A B C', _n_); set key; run;

%mktroll(design=randomized, key=key, out=rolled, alt=brand)

%choiceff(data=rolled,              /* candidate set of choice sets         */
          init=rolled(keep=set),    /* select these sets from candidates    */
          intiter=0,                /* no iterations, just evaluate         */
          model=class(brand / sta)  /* brand effects                        */
                class(brand * x1    /* alternative-specific effects x1      */
                      brand * x2    /* alternative-specific effects x2      */
                      brand * x3    /* alternative-specific effects x3      */
                      brand * x4 /  /* alternative-specific effects x4      */
                      sta zero=' '),/* std ortho coding, use all brands     */
          nalts=3,                  /* number of alternatives               */
          nsets=27,                 /* number of choice sets                */
          rscale=alt,               /* alt-specific design efficiency scale */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=bestcov label;
   title 'Variance-Covariance Matrix';
   id __label;
   label __label = '00'x;
   var B:;
   format _numeric_ zer5.2;
   run;
title;

data _null_;
   sets  = 27;
   alts  = 3;
   m     = alts - 1;
   parms = m + alts * 4 * (3 - 1);
   det1  = sets ** m;
   det2  = (sets * (m / (alts ** 2))) ** (parms - m);
   scale = (det1 * det2) ** (1 / parms);
   put scale=;
   run;

%mktex(6 3 2 2 4 4  6 3 2 2 4 4
       6 3 2 2 4 4  6 3 2 2 4 4  6 3 2 2 4 4, n=288)

%mktkey(5 6)

data key; Brand = scan('A B C D E F', _n_); set key; run;

%mktroll(design=randomized, key=key, out=rolled, alt=brand)

%choiceff(data=rolled,              /* candidate set of choice sets         */
          init=rolled(keep=set),    /* select these sets from candidates    */
          intiter=0,                /* no iterations, just evaluate         */
          model=class(brand / sta)  /* brand effects                        */
                class(brand * x1    /* alternative-specific effects x1      */
                      brand * x2    /* alternative-specific effects x2      */
                      brand * x3    /* alternative-specific effects x3      */
                      brand * x4    /* alternative-specific effects x4      */
                      brand * x5    /* alternative-specific effects x5      */
                      brand * x6 /  /* alternative-specific effects x6      */
                      sta zero=' '),/* std ortho coding, use all brands     */
          nalts=5,                  /* number of alternatives               */
          nsets=288,                /* number of choice sets                */
          rscale=alt,               /* alt-specific design efficiency scale */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc print data=bestcov label;
   title 'Variance-Covariance Matrix';
   id __label;
   label __label = '00'x;
   var B:;
   format _numeric_ zer5.2;
   run;
title;

proc iml;
   use bestcov(drop=__:); read all into x;
   x = shape(x, 1)`;
   create _cov from x[colname='Covariance']; append from x;
   quit;

proc freq; tables Covariance; format covariance zer5.; run;

data _null_;
   sets  = 288;
   alts  = 5;
   m     = alts - 1;
   parms = m + alts * (6 + 3 + 2 + 2 + 4 + 4 - 6);
   det1  = sets ** m;
   det2  = (sets * (m / (alts ** 2))) ** (parms - m);
   scale = (det1 * det2) ** (1 / parms);
   put scale=;
   run;

%mktex(6 3 2 2 4 4, n=6*3*2*2*4*4)

data des(drop=i);
   retain f1-f5 0;
   array f[5];
   set design;
   do i = 1 to 5;
      Brand = scan('A B C D E', i);
      f[i] = 1; output; f[i] = 0;
      end;
   run;

%choiceff(data=des,                 /* candidate set of alternatives        */
          model=class(brand / sta)  /* brand effects                        */
                class(brand * x1    /* alternative-specific effects x1      */
                      brand * x2    /* alternative-specific effects x2      */
                      brand * x3    /* alternative-specific effects x3      */
                      brand * x4    /* alternative-specific effects x4      */
                      brand * x5    /* alternative-specific effects x5      */
                      brand * x6 /  /* alternative-specific effects x6      */
                      sta zero=' '),/* std ortho coding, use all brands     */
          flags=f1-f5,              /* 5 alternatives, generic candidates   */
          nsets=32,                 /* number of choice sets                */
          maxiter=2,                /* maximum number of designs to make    */
          rscale=alt,               /* alt-specific design efficiency scale */
          seed=104,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%let sets = %eval(3 ** 5);

%mktex(3 ** 5, n=&sets)

%mktlab(values=1.49 1.99 2.49)

data key;
  input (b p) ($);
  datalines;
1 x1
2 x2
3 x3
4 x4
5 x5
. .
;

%mktroll(design=final, key=key, out=crosscan, alt=b, keep=x1-x5)

data crosscan;
   set crosscan;
   label b  = 'Brand' p = 'Price' x1 = 'Brand 1 Price'
         x2 = 'Brand 2 Price' x3 = 'Brand 3 Price'
         x4 = 'Brand 4 Price' x5 = 'Brand 5 Price';
   run;

%choiceff(data=crosscan,            /* candidate set of choice sets         */
          init=crosscan(keep=set),  /* select these sets from candidates    */
          intiter=0,                /* no iterations, just evaluate         */
          model=class(b             /* brand effects                        */
                b*p / zero=' ')     /* alternative-specific effects         */
                class(b / zero=none)/* cross effects                        */
                * identity(x1-x5),
          drop=B1X1 B2X2 B3X3       /* drop cross effects of brand on self  */
               B4X4 B5X5,
          nsets=&sets,              /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%choiceff(data=crosscan,            /* candidate set of choice sets         */
          model=class(b             /* brand effects                        */
                b*p / zero=' ')     /* alternative-specific effects         */
                class(b / zero=none)/* cross effects                        */
                * identity(x1-x5),
          maxiter=10,               /* maximum number of designs to make    */
          drop=B1X1 B2X2 B3X3       /* drop cross effects of brand on self  */
               B4X4 B5X5,
          nsets=&sets,              /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          seed=104,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%let sets = 32;

%choiceff(data=crosscan,            /* candidate set of choice sets         */
          model=class(b             /* brand effects                        */
                b*p / zero=' ')     /* alternative-specific effects         */
                class(b / zero=none)/* cross effects                        */
                * identity(x1-x5),
          maxiter=10,               /* maximum number of designs to make    */
          drop=B1X1 B2X2 B3X3       /* drop cross effects of brand on self  */
               B4X4 B5X5,
          rscale=&sets * 7.1536/243,/* scaling factor for relative eff      */
          nsets=&sets,              /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          seed=104,                 /* random number seed                   */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%choiceff(help)
%choiceff(?)

******************* Begin MktAllo Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

data allocs2;
   input Brand $ 1-8 Price $ Count Set;
   datalines;
.              .         0 1
Brand  1     $50       103 1
Brand  2     $75        58 1
Brand  3     $50       318 1
Brand  4    $100        99 1
Brand  5    $100        54 1
Brand  6    $100        83 1
Brand  7     $75        71 1
Brand  8     $75        58 1
Brand  9     $75       100 1
Brand 10     $50        56 1
.              .        10 2
Brand  1    $100        73 2
Brand  2    $100        76 2
Brand  3    $100       342 2
Brand  4     $50        55 2
Brand  5     $75        50 2
Brand  6    $100        77 2
Brand  7     $75        95 2
Brand  8    $100        71 2
Brand  9     $50        72 2
Brand 10    $100        79 2
;
proc print; run;

%mktallo(data=allocs2, out=allocs3, nalts=11,
         vars=set brand price, freq=Count)

proc print; run;

%mktallo(help)
%mktallo(?)

******************* Begin MktBal Macro Example Code *******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktbal(2 2 3 3 3, n=18, seed=151)

%mkteval(data=design)

%mktbal(2 3 4 5 6 7 8 9 10, n=120, options=progress, seed=17)

%mktbal(2 3 4 5 6 7 8 9 10, n=120, options=progress, seed=17,
        maxstarts=1, maxiter=1, maxtries=1)

%mktbal(help)
%mktbal(?)

****************** Begin MktBIBD Macro Example Code *******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktbibd(b=10, t=5, k=3, seed=104)

proc print data=bibd noobs; run;

proc print data=incidence noobs; run;

proc print data=factorial(obs=9) noobs; run;

%mktbibd(b=14, t=7, k=4, options=neighbor, seed=104)

%mktbibd(b=14, t=7, k=4, options=serial, seed=361699)

%mktbibd(b=14, t=7, k=4, options=serial, seed=104)

%mktbibd(b=7, t=7, k=4, options=serial, seed=104)

%mktbsize(t=1 to 20, k=2 to 0.5 * t, b=t to 100)

%mktbibd(help)
%mktbibd(?)

%macro mktbeval(design=_last_,      /* block design to evaluate         */
                attrortr=Attribute);/* string to print in the output    */
                                    /* specify Treatment or use default */

proc iml;
   use &design; read all into x;
   t = max(x);    k = ncol(x);    blocks = nrow(x);
   call symput('k', char(k));
   call symput('b', char(blocks));
   f = j(t, t, .);    p = j(t, k, 0);
   do i = 1 to blocks;
      do j = 1 to k;
         p[x[i,j],j] = p[x[i,j],j] + 1;
         do q = j to k;
            a = min(x[i,j],x[i,q]);
            b = max(x[i,j],x[i,q]);
            f[a,b] = sum(f[a,b], 1);
            end;
         end;
      end;
   options missing=' ';
   w = ceil(log10(t + 1)); t = right(char(1, w, 0) : char(t, w, 0));
   w = ceil(log10(k + 1)); q = right(char(1, w, 0) : char(k, w, 0));
   if max(f) < 100 then print "&attrortr by &attrortr Frequencies",,
      f[format=2. label='' rowname=t colname=t];
   else print "&attrortr by &attrortr Frequencies",,
      f[label='' rowname=t colname=t];
   if max(p) < 100 then print "&attrortr by Position Frequencies",,
      p[format=2. label='' rowname=t colname=q];
   else print "&attrortr by Position Frequencies",,
      p[label='' rowname=t colname=q];
   options missing='.';
   x = (1:blocks)` @ j(k, 1, 1) || shape(x, blocks * k);
   create __tmpbefac from x; append from x;
   quit;

proc optex;
   class col2;
   model col2;
   generate initdesign=__tmpbefac method=sequential;
   blocks structure=(&b)&k init=chain iter=0;
   ods select BlockDesignEfficiencies;
   run;

proc datasets nolist; delete __tmpbefac; run; quit;
%mend;

%mktbibd(b=10, t=6, k=3, seed=104)

%mktbeval;

****************** Begin MktBlock Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktex(3 ** 7, n=27, seed=350)

%mktlab(data=randomized, vars=x1-x6 Block)

%mktex(3 ** 6, n=27, seed=350)

%mktblock(data=randomized, nblocks=3, seed=377, maxiter=50)

%mktex(3 ** 6, n=3**6)

%mktroll(design=design, key=2 3, out=out)

%choiceff(data=out,                 /* candidate set of choice sets         */
          model=class(x1-x3 / sta), /* model with stdz orthogonal coding    */
          nsets=18,                 /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
          seed=151,                 /* random number seed                   */
          options=nodups            /* do not create duplicate choice sets  */
                  relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

* Block the choice design.  Ask for 2 blocks;
%mktblock(data=best, nalts=2, nblocks=2, factors=x1-x3, seed=472)

%mktblock(help)
%mktblock(?)

****************** Begin MktBSize Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktbsize(t=12, k=4 to 8, b=12 to 30)

%mktbibd(t=12, k=6, b=22, seed=104)

%mktbsize(t=5 to 20, k=3 to t - 1, b=t to 30)

%mktbsize(t=2 to 10, k=2 to 0.5 * t, b=t to 10)

%mktbsize(t=2 to 10, k=2 to t - 1, b=t to 2 * t)

%mktbsize(b=2 to 10, t=2 to 0.5 * b, k=2 to t - 1, order=btk)

%mktbsize(t=20, k=6, options=ubd)

%mktbibd(t=20, k=6, b=10, seed=104)

%mktbsize(help)
%mktbsize(?)

******************* Begin MktDes Macro Example Code *******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktdes(factors=x1-x2=2 x3-x5=3, n=18)

*---2 two-level factors and 3 three-level factors in 18 runs---;
%mktdes(factors=x1-x2=2 x3-x5=3, n=18, maxiter=500)

%mktdes(help)
%mktdes(?)

%mktdes(factors=x1-x10=2)

%mktdes(factors=x1-x5=2 x6-x10=3 x11-x15=5)

%mktdes(factors=x1-x5=2 x6-x10=3(3))

%mktdes(step=1, factors=x1-x3=2, n=30, run=factex)

%mktdes(step=2, factors=x4-x6=3, n=30, run=factex)

%mktdes(step=3, factors=x7-x9=5, n=30, run=factex optex,
        otherint=x1*x4)

%mktdes(factors=x1-x3=2 x4-x6=3 x7-x9=5, n=30)

%mktdes(step=1, factors=x1-x3=2, n=30, run=factex)
%mktdes(step=2, factors=x4-x6=3, n=30, run=factex)
%mktdes(step=3, factors=x7-x9=5, n=30, run=factex optex)

%mktex(2 2 2 3 3 3 5 5 5, n=30)

proc optex data=Cand3;
   class
      x1-x3
      x4-x6
      x7-x9
      / param=orthref;
   model
      x1-x3
      x4-x6
      x7-x9
      ;
   generate n=30 iter=10 keep=5 method=m_fedorov;
   output out=Design;
   run; quit;

******************* Begin MktDups Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktex(3 ** 9, n=27, seed=424)

data key;
   input (Brand x1-x3) ($);
   datalines;
Acme   x1 x2 x3
Ajax   x4 x5 x6
Widgit x7 x8 x9
;

%mktroll(design=randomized, key=key, alt=brand, out=cand)

%choiceff(data=cand,                /* candidate set of choice sets         */
          model=class(brand x1-x3 / sta),/* model with stdz orthog coding   */
          seed=420,                 /* random number seed                   */
          nsets=18,                 /* number of choice sets                */
          nalts=3,                  /* number of alternatives               */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc freq; tables set; run;

%mktdups(branded, data=best, factors=brand x1-x3, nalts=3, out=out)

proc freq; tables set; run;

%mktex(2 ** 5, n=2**5, seed=109)

%choiceff(data=randomized,          /* candidate set of alternatives        */
          model=class(x1-x5 / sta), /* model with stdz orthogonal coding    */
          seed=93,                  /* random number seed                   */
          nsets=42,                 /* number of choice sets                */
          flags=4,                  /* 4 alternatives, generic candidates   */
          options=relative,         /* display relative D-efficiency        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktdups(generic, data=best, factors=x1-x5, nalts=4, out=out)

proc print data=best;
   var x1-x5;
   id set; by set;
   where set in (2, 25, 39);
   run;

%mktex(2 ** 6, n=2**6)

%mktroll(design=design, key=3 2, out=cand)

%mktdups(generic, data=cand, factors=x1-x2, nalts=3, out=out)

proc print; by set; id set; run;

%mktex(3 ** 3 2 ** 2, n=19, seed=513)

%mktdups(linear, data=design, factors=x1-x5)

%mktdups(help)
%mktdups(?)

******************* Begin MktEval Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktex(2 2 3 ** 6,                  /* 2 two-level and 6 three-level factors*/
       n=18,                        /* 18 runs                              */
       balance=0,                   /* require perfect balance in the end   */
       mintry=5*18,                 /* but imbalance OK for first 5 passes  */
       seed=289)                    /* random number seed                   */

%mkteval(data=randomized)

%mkteval(help)
%mkteval(?)

******************** Begin MktEx Macro Example Code *******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktex(2 ** 5  3 ** 4  5 5 5  6 6, n=60)

%mktorth(maxlev=2)

proc print; run;

data x;
   length Method $ 30;
   do n = 4 to 1000 by 4;
      HadSize = n; method = ' ';
      do while(mod(hadsize, 8) eq 0); hadsize = hadsize / 2; end;
      link paley;
      if method eq ' ' and hadsize le 256 and not (hadsize in (188, 236))
         then method = 'Williamson';
      else if hadsize in (188, 236, 260, 268, 292, 356, 404, 436, 596)
         then method = 'Turyn, Hedayat, Wallis';
      else if hadsize = 324                    then method = 'Ehlich';
      else if hadsize in (372, 612, 732, 756)  then method = 'Turyn';
      else if hadsize in (340, 580, 724, 1060) then method = 'Paley 2';
      else if hadsize in (412, 604)            then method = 'Yamada';
      else if hadsize = 428 then method = 'Kharaghania and Tayfeh-Rezaiea';
      if method = ' ' then do;
         do while(hadsize lt n and method eq ' ');
            hadsize = hadsize * 2;
            link paley;
            end;
         end;
      if method ne ' ' then do; Change = n - lag(n); output; end;
      end;
   return;
   paley:;
      ispm1 = 1; ispm2 = mod(hadsize / 2, 4) eq 2;
      h = hadsize - 1;
      do i = 3 to sqrt(hadsize) by 2 while(ispm1);
         ispm1 = mod(h, i);
         end;
      h = hadsize / 2 - 1;
      do i = 3 to sqrt(hadsize / 2) by 2 while(ispm2);
         ispm2 = mod(h, i);
         end;
      if      ispm1 then method = 'Paley 1';
      else if ispm2 then method = 'Paley 2';
      return;
   run;

options ps=2100;
proc print label noobs;
   label hadsize = 'Reduced Hadamard Matrix Size';
   var n hadsize method change;
   run;

%mktex(n=36)

%mktex(3 ** 4, n=3 * 3)

proc print; run;

%macro latin(x,y);
   proc iml;
      use design;
      read all into x;
      file print;
      s1 = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+=-*';
      s2 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz123456789+=-*';
      k = 0;
      m = x[nrow(x),1];
      do i = 1 to m;
         put;
         do j = 1 to m;
            k = k + 1;
            put (substr(s1, x[k,&x], 1)) $1. @;
            %if &y ne %then %do; put +1 (substr(s2, x[k,&y], 1)) $1. +1 @; %end;
            put +1 @;
            end;
         end;

      put;
      quit;
   %mend;

%mktex(3 ** 4, n=3 * 3)
%latin(3)
%latin(4)

%mktex(4 ** 5, n=4 ** 2)
%latin(3)

%mktex(5 ** 3, n=25)
%latin(3)

%mktex(6 ** 3, n=36)
%latin(3)

%mktex(6 ** 3,                      /* 3 six-level factor                   */
       n=36,                        /* 36 runs                              */
       options=nohistory            /* do not display iteration history     */
               nofinal,             /* do not display final levels, D-eff   */
       seed=109)                    /* random number seed                   */

proc sort data=randomized out=design; by x1 x2; run;

%latin(3)

%mktex(3 ** 4, n=3 * 3)
%latin(3,4)

%mktex(12 ** 4, n=12 ** 2)
%latin(3,4)

%mktex(2 ** 23, n=24, options=nosort)

data splitplot;
   Plot = floor((_n_ - 1) / 6) + 1; /* 6 1s, 6 2s, 6 3s, 6 4s */
   set design;
   run;

proc print; id Plot; by Plot; var x22 x23 x21 x1-x20; run;

%mktex(2 ** 23, n=24, options=nosort lineage)

proc sort data=design out=splitplot;
   by x1-x23;
   run;

data splitplot;
   Plot = floor((_n_ - 1) / 6) + 1;
   set splitplot;
   run;

proc print; id Plot; by Plot; run;

%mktorth(range=n=24, options=dups lineage)

data cat;
   set mktdescat;
   design  = left(transtrn(compbl(design), ' ** ', '^'));
   lineage = left(transtrn(substr(lineage, 21), ' ** ', '^'));
   run;

proc print noobs; run;

%mktorth(range=n=24, options=lineage)

data cat;
   set mktdescat;
   design  = left(transtrn(compbl(design), ' ** ', '^'));
   lineage = left(transtrn(substr(lineage, 21), ' ** ', '^'));
   run;

proc print noobs; run;

data lev;
   set mktdeslev;
   if x2 eq 23 and index(lineage, '2 ** 11');
   run;

%mktex(2 ** 23, n=24, options=nosort, cat=lev)

data splitplot;
   Plot = floor((_n_ - 1) / 6) + 1;
   set design;
   run;

proc print; id Plot; by Plot; run;

%mktorth(range=n=24, options=dups lineage)

data lev;
   set mktdeslev;
   where x2 = 14 and index(lineage, '2 ** 11 4 ** 1 6 ** 1');
   run;

%mktex(2 ** 14 6, n=24, out=whole(keep=x12-x14), options=nosort)

data in(keep=x1-x7);
   retain x1-x7 .;
   set whole;
   x1 = x13;
   x2 = x14;
   x3 = x12;
   run;

proc print; run;

data in(keep=x1-x7);
   retain x1-x7 .;
   input x1-x3;
   do i = 1 to 6; output; end;
   datalines;
1 1 1
1 2 2
2 2 1
2 1 2
;

%mktex(2 ** 3, n=4, options=nosort)

data in(keep=x1-x7);
   retain x1-x7 .;
   set design(rename=(x2=x1 x3=x2 x1=x3));
   do i = 1 to 6; output; end;
   run;

%mktex(2 2 2   6 6 2 3, n=24, init=in, seed=104, options=nosort, maxiter=100)

%mkteval;

data splitplot;
   Plot = floor((_n_ - 1) / 6) + 1;
   set design;
   run;

proc print; id plot; by Plot;  run;

data in(keep=x1-x8);
   retain x1-x8 .;
   set whole; /* same design with whole-plot factors as before */
   x1 = x13;
   x2 = x14;
   x3 = x12;
   x4 = floor((_n_ - 1) / 6) + 1;  /* Plot number: 1, 2, 3, 4 */
   run;

%mktex(2 2 2   4   6 6 2 3, n=24, init=in, seed=104, options=nosort,
       maxiter=100, ridge=1e-4)

%mkteval;

proc print label; by x4; id x4; label x4 = 'Plot'; run;

%mktex(3 ** 4, n=9, examine=aliasing=2)

%mktex(3 ** 4, n=9, examine=aliasing=2 full)

%mktex(3 ** 4, n=9, examine=aliasing=4 full)

%let m = 12;
%mktorth(range=n=2 * &m, options=lineage dups, maxlev=&m)

%mktex(2 ** &m, n=2 * &m, examine=aliasing=2,
       cat=mktdeslev(where=(index(compbl(design), "2 ** &m &m ** 1"))))

%mktex(help)
%mktex(?)

%mktruns(4 2 ** 5 3 ** 5)

%mktex(2 ** 5, interact=@2, n=16)
%mktex(2 ** 5, interact=1|2|3|4|5@2, n=16)
%mktex(2 ** 5, interact=x1|x2|x3|x4|x5@2, n=16)

%mktex(4 ** 12,                     /* 12 four-level factors                */
       n=48,                        /* 48 profiles                          */
       partial=4,                   /* four attrs vary                      */
       seed=205,                    /* random number seed                   */
       maxdesigns=1)                /* just make one design                 */

%mktlab(data=randomized, values=. 1 2 3, nfill=99)

options missing=' ';
proc print data=final(obs=10); run;
options missing='.';

%macro restrict;
   bad = (x1 = x2) +
         (x2 = x3) +
         (x3 = x4) +
         (x4 = x5);
   %mend;

%mktex(2 2 2 3 3 3, n=18, outall=sasuser.a)

proc means data=sasuser.a noprint;
   output out=m max(efficiency)=m;
   run;

data best;
   retain id .;
   set sasuser.a;
   if _n_ eq 1 then set m;
   if nmiss(id) and abs(m - efficiency) < 1e-12 then do;
      id = design;
      put 'NOTE: Keeping design ' design +(-1) '.';
      end;
   if id eq design;
   keep design efficiency x:;
   run;

proc print; run;

%mktex(3 3 3 3 5, n=18)

%mkteval;

%let m = 5;
data ex;
   do i = 1 to &m;
      do j = i + 1 to &m;
         output;
         end;
      end;
   run;

proc print noobs; run;

%macro sumres;
   allone = 0; oneone = 0; alltwo = 0;
   do k = 1 to 22;
      if      (x[k] = 1 & x[k+22] = 1) then allone = allone + 1;
      else if (x[k] = 1 | x[k+22] = 1) then oneone = oneone + 1;
      else if (x[k] = 2 & x[k+22] = 2) then alltwo = alltwo + 1;
      end;
   bad = 100 # (^(5 <= allone & allone <= 9)) # abs(allone - 7) +
          10 # (^(5 <= oneone & oneone <= 9)) # abs(oneone - 7) +
               (^(5 <= alltwo & alltwo <= 9)) # abs(alltwo - 7);
   %mend;

%mktex(3 ** 50,                     /* 50 three-level factors               */
       n=135,                       /* 135 runs                             */
       restrictions=sumres,         /* name of restrictions macro           */
       seed=289,                    /* random number seed                   */
       options=resrep               /* restrictions report                  */
               quickr               /* very quick run with random init      */
               nox)                 /* suppresses x1, x2, x3 ... creation   */

%mktkey(x1-x50)

data key;
   input (x1-x25) ($);
   datalines;
x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13
x14 x15 x16 x17 x18 x19 x20 x21 x22                  x45 x46 x47
x23 x24 x25 x26 x27 x28 x29 x30 x31 x32 x33 x34
x35 x36 x37 x38 x39 x40 x41 x42 x43 x44              x48 x49 x50
;

%mktroll(design=design, key=key, out=chdes)

proc print; by set; id set; where set le 2 or set ge 134; run;

******************* Begin MktKey Macro Example Code *******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktkey(5 10)

%mktkey(5 10 t)

%mktkey(x1-x15)

data key;
   input (x1-x5) ($);
   datalines;
 x1  x2  x3  x4  x5
 x6  x7  x8  x9 x10
x11 x12 x13 x14 x15
  .   .   .   .   .
;

%mktkey(help)
%mktkey(?)

******************* Begin MktLab Macro Example Code *******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktex(n=12, options=nosort)

proc print noobs; run;

%mktex(n=12,                        /* 12 runs                              */
       options=nosort,              /* do not sort design                   */
       levels=i                     /* -1 and 1 instead of 1 and 2          */
              int)                  /* add an intercept to the design       */

%mktex(n=12, options=nosort)

%mktlab(data=design, values=1 -1, int=Had0, prefix=Had)

proc print noobs; run;

data key;
  array Had[11];
  input Had1 @@;
  do i = 2 to 11; Had[i] = Had1; end;
  drop i;
  datalines;
1 -1
;

proc print data=key; run;

%mktlab(data=design, key=key, int=Had0)

data randomized;
  input x1-x8 @@;
  datalines;
4 2 1 1 1 2 2 2 2 1 1 2 1 3 1 3 3 4 2 2 1 3 2 3 4 3 2 1 3 2 2 3 4 1 2 1
1 1 1 1 2 4 1 2 1 2 1 1 1 2 1 2 3 3 2 1 2 2 2 2 2 2 2 3 1 4 2 1 1 2 2 2
3 2 2 1 3 1 2 1 1 4 1 2 2 3 1 2 1 3 2 2 1 3 1 1 3 2 1 2 2 1 2 3 3 4 1 1
3 1 1 3 4 1 2 2 2 1 2 1 2 3 2 1 2 3 2 2 2 1 2 1 3 3 1 3 4 2 2 2 1 3 1 2
2 4 2 2 3 1 1 2 3 1 2 2 3 2 1 2 3 3 1 1 2 3 1 1 4 4 2 1 2 2 1 3 1 1 1 1
3 2 1 2 4 3 1 2 3 3 2 2 1 2 2 1 2 1 1 3 1 3 1 1 1 1 2 3
;

data key;
  missing N;
  input Client ClientLineExtension ClientMicro $ ShelfTalker $
        Regional Private PrivateMicro $ NationalLabel;
  format _numeric_ dollar5.2;
  datalines;
1.29 1.39 micro Yes 1.99 1.49 micro 1.99
1.69 1.89 stove No  2.49 2.29 stove 2.39
2.09 2.39 .     .   N     N   .     N
N    N    .     .   .     .   .     .
;

%mktlab(data=randomized, key=key)

proc sort; by shelftalker; run;

proc print; by shelftalker; run;

%mktex(n=36, seed=420)

data key;
  array x[23] two1-two11 thr1-thr12;
  input two1 thr1;
  do i =  2 to 11; x[i] = two1; end;
  do i = 13 to 23; x[i] = thr1; end;
  drop i;
  datalines;
-1 -1
 1  0
 .  1
;

%mktlab(data=randomized, key=key)

proc print data=key noobs; var two:; run;
proc print data=key noobs; var thr:; run;

proc print data=final(obs=5) noobs; var two:; run;
proc print data=final(obs=5) noobs; var thr:; run;

%mktex(n=18, seed=396)

%mktblock(data=design, nblocks=2, factors=x1-x4, seed=292)

data key;
   input Brand $ Price Size;
   format price dollar5.2;
   datalines;
Acme 1.49   6
Apex 1.79   8
.    1.99  12
;

%mktlab(data=blocked, key=key)

proc print; run;

%mktex(3 ** 15,                     /* 15 three-level factors               */
       n=36,                        /* 36 runs                              */
       seed=17,                     /* random number seed                   */
       maxtime=0)                   /* no more than 1 iter in each phase    */

%mktblock(data=randomized, nblocks=2, factors=x1-x15, seed=448)

%macro lab;
   label X1  = 'Hawaii, Accommodations'
         X2  = 'Alaska, Accommodations'
         X3  = 'Mexico, Accommodations'
         X4  = 'California, Accommodations'
         X5  = 'Maine, Accommodations'
         X6  = 'Hawaii, Scenery'
         X7  = 'Alaska, Scenery'
         X8  = 'Mexico, Scenery'
         X9  = 'California, Scenery'
         X10 = 'Maine, Scenery'
         X11 = 'Hawaii, Price'
         X12 = 'Alaska, Price'
         X13 = 'Mexico, Price'
         X14 = 'California, Price'
         X15 = 'Maine, Price';
   format x11-x15 dollar5.;
%mend;

data key;
   length x1-x5 $ 16 x6-x10 $ 8 x11-x15 8;
   input x1 & $ x6 $ x11;
   x2  = x1;    x3 = x1;    x4 = x1;    x5 = x1;
   x7  = x6;    x8 = x6;    x9 = x6;   x10 = x6;
   x12 = x11;  x13 = x11;  x14 = x11;  x15 = x11;
   datalines;
Cabin            Mountains   999
Bed & Breakfast  Lake       1249
Hotel            Beach      1499
;

%mktlab(data=blocked, key=key, labels=lab)

proc contents p; ods select position; run;

%mktlab(help)
%mktlab(?)

%mktex(3 ** 4, n=18, seed=205)

%macro labs;
   label x1 = 'Sploosh' x2 = 'Plumbob'
         x3 = 'Platter' x4 = 'Moosey';
   format x1-x4 dollar5.2;
   %mend;

%mktlab(data=randomized, values=1.49 1.99 2.49, labels=labs)

proc print label; run;

%mktex(3 ** 4, n=18, seed=205)

%mktlab(data=randomized, values=1.49 1.99 2.49,
        vars=Sploosh Plumbob Platter Moosey,
        statements=format Sploosh Plumbob Platter Moosey dollar5.2)

proc print; run;

****************** Begin MktMDiff Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktbsize(nattrs=9, setsize=2 to 9, nsets=1 to 20)

%mktbibd(nattrs=9, setsize=5, nsets=18, seed=377, out=sasuser.bibd)

* Due to machine differences, you might not get the same design if you run
* the step above, so here is the design that is used in the book;
data sasuser.bibd; input x1-x5 @@; datalines;
1 2 4 7 9 6 2 9 8 4 5 8 2 1 7 7 9 1 6 3 9 7 6 5 2 3 1 5 6 8 4 6 3 8 2
6 7 4 1 8 7 5 2 3 4 1 3 8 2 7 3 4 1 5 9 2 9 6 3 1 8 3 9 2 5 9 8 7 4 3
5 4 8 9 1 2 1 5 4 6 8 5 7 9 6 4 6 3 7 5
;

title 'Best Worst Example with Cell Phone Attributes';

data bestworst;
   input Sub $ @4 (b1-b18 w1-w18) (1.);
   datalines;
 1 188661884399349653941955342212935494
 2 765358873891388493922673644336595554
 3 782126282892848564995993447213935655
 4 481363264246399187162125415351281453
 5 787168863811878175225995382352235293
 6 787658867891878667495965442313345453
 7 788171867736888187465395344393344453
 8 788771867711888687445353445353335254
 9 188778887896878687425323443242344454
10 788778887816888687445353444343344454
11 787778877816878667442353343343235453
12 787778387711898667425321443253544594
13 767668285791988687441951364232234194
14 187168877741878687445323445216334453
15 788176487116988675492393314339579457
16 267665615733884677442193342349545564
17 481191867813938266147956244139584594
18 725778814832585185141193643296944467
19 188678863811279263445123344253934596
20 728698612719281483265755285851944597
;

%let attrlist=Camera,Flip,Hands Free,Games,Internet
,Free Replacement,Battery Life,Large Letters,Applications;

%phchoice( on )

%mktmdiff(bw, nattrs=9, nsets=18, setsize=5, attrs=attrlist,
          data=bestworst, design=sasuser.bibd)

%mktmdiff(bw, nattrs=9, nsets=18, setsize=5,
          attrs=attrlist, classopts=zero='Internet',
          data=bestworst, design=sasuser.bibd)

%mktbsize(nattrs=1 to 20, setsize=2 to 0.5 * t, nsets=t to 100)

%mktbibd(nattrs=12, setsize=6, nsets=22, seed=104)

%mktbibd(nattrs=20, setsize=5, nsets=16, seed=292, out=sasuser.maxdiffdes)

%mktbibd(nattrs=20, setsize=5, nsets=20, seed=292, out=sasuser.maxdiffdes)

%mktbibd(nattrs=20, setsize=5, nsets=24, seed=292, out=sasuser.maxdiffdes)

%mktbsize(nattrs=20, setsize=5, nsets=t to 500)

%mktbsize(nattrs=18 to 22, setsize=4 to 6, nsets=t to 500)

%mktbibd(nattrs=21, setsize=5, nsets=21, seed=292, out=sasuser.maxdiffdes)

%mktmdiff(help)
%mktmdiff(?)

****************** Begin MktMerge Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktmerge(design=rolled, data=results, out=res2,
          nsets=18, nalts=5, setvars=choose1-choose18)

%mktmerge(design=rolled, data=results, out=res2, blocks=form,
          nsets=18, nalts=5, setvars=choose1-choose18)

%mktmerge(help)
%mktmerge(?)

******************* Begin MktOrth Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktorth(maxn=100, maxlev=6)

   /* Uncomment this code if you want it to run

%mktorth(maxlev=144, options=512)

   */

%mktorth(maxlev=144)

proc print data=mktdeslev(where=(n le 12 or n ge 972));
   var design reference;
   id n; by n;
   run;

proc print data=mktdeslev(where=(n le 12));
   var design reference x1-x6;
   id n; by n;
   run;

%mktorth(maxn=100)

proc print data=mktdeslev noobs;
   where x2 ge 5 and x3 ge 5 and x4 ge 1;
   var n design reference;
   run;

%mktorth(range=12 le n le 20)

proc print; id n; by n; run;

%mktorth(range=n=36, options=lineage)

proc print noobs;
   where index(design, '2 ** 11') and index(design, '3 ** 12');
   run;

%mktorth(help)
%mktorth(?)

%mktorth(range=n=18, options=lineage)

data _null_;
   set;
   design = compbl(design);
   put 'Design:  ' design / 'Lineage: ' lineage /;
   run;

%mktex(6 3 ** 6, n=18)

%mktorth(range=n=18, options=lineage dups)

data _null_;
   set;
   design = compbl(design);
   put 'Design:  ' design / 'Lineage: ' lineage /;
   run;

%mktorth(range=n=18, options=lineage dups)

data lev;
   set mktdeslev;
   where lineage ? '3 ** 4';
   run;

%mktex(2 3 ** 4,                    /* 1 two-level and 4 three-level factors*/
       n=18,                        /* 18 runs                              */
       cat=lev,                     /* OA catalog comes from lev data set   */
       out=alternative)             /* name of output design                */

%mktex(2 3 ** 4, n=18, out=default)

data d;
   set default;
   y = 1;
   run;

data i;
   set alternative;
   y = 1;
   run;

proc glm data=d;
   ods select galiasing;
   model y = x1-x5 / e aliasing;
   run; quit;

proc glm data=i;
   ods select galiasing;
   model y = x1-x5 / e aliasing;
   run; quit;

proc glm data=d;
   ods select galiasing;
   model y = x1-x5 x1|x2|x3|x4|x5@2 / e aliasing;
   run; quit;

proc glm data=i;
   model y = x1-x5 x1|x2|x3|x4|x5@2 / e aliasing;
   run; quit;

proc glm data=d;
   ods select galiasing;
   model y = x1-x5 x1|x2|x3|x4|x5@5 / e aliasing;
   run; quit;

proc glm data=i;
   model y = x1-x5 x1|x2|x3|x4|x5@5 / e aliasing;
   run; quit;

%mktorth(range=n=12*13, options=lineage)

proc print; run;

%mktex(12 13, n=12*13)

%mktorth;

proc print; where reference ? 'Full'; run;

%mktorth(range=n=29 * 29, options=lineage)

%mktex(29 ** 30, n=29*29)

%mktorth(range=n=256, options=lineage, maxlev=64)

proc print data=mktdeslev; where x64 and x4 ge 10; run;

%mktex(4 ** 10 64, n=256)

%mktorth(range=n=128, options=lineage)

data _null_;
   set mktdeslev;
   if x2 eq 7 and x4 eq 5 and x8 eq 15;
   design = compbl(design);
   put design / lineage /;
   run;

%mktorth(range=n=32, options=lineage)

data _null_;
   set mktdeslev;
   if x2 eq 31;
   design = compbl(design);
   put design / lineage /;
   run;

******************* Begin MktPPro Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktex(4 2 ** 4, n=8, seed=306)

proc sort data=randomized out=randes(drop=x1);
   by x2 x1;
   run;

proc print noobs data=randes; run;

%mktbibd(b=20, nattrs=16, setsize=4, seed=104)

%mktppro(design=randes, ibd=bibd, print=f p)

%choiceff(data=chdes,               /* candidate set of choice sets         */
          init=chdes,               /* initial design                       */
          initvars=x1-x16,          /* factors in the initial design        */
          model=class(x1-x16 / sta),/* model with stdz orthogonal coding    */
          nsets=80,                 /* number of choice sets                */
          nalts=2,                  /* number of alternatives               */
          rscale=                   /* relative D-efficiency scale factor   */
          %sysevalf(80 * 4 / 16),   /* 4 of 16 attrs in 80 sets vary        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

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

proc print; run;

%mktex(6 3 ** 6, n=18, seed=424)

proc sort data=randomized out=randes(drop=x1);
   by x2 x1;
   run;

proc print data=randes noobs; run;

%mktbsize(nattrs=20, setsize=6, options=ubd)

%mktbibd(b=10, nattrs=20, setsize=6, seed=104)

%mktppro(design=randes, ibd=bibd, print=f p)

%choiceff(data=chdes,               /* candidate set of choice sets         */
          init=chdes,               /* initial design                       */
          initvars=x1-x20,          /* factors in the initial design        */
          model=class(x1-x20 / sta),/* model with stdz orthogonal coding    */
          nsets=60,                 /* number of choice sets                */
          nalts=3,                  /* number of alternatives               */
          rscale=                   /* relative D-efficiency scale factor   */
          %sysevalf(60 * 6 / 20),   /* 6 of 20 attrs in 60 sets vary        */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktppro(help)
%mktppro(?)

******************* Begin MktRoll Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktkey(5 1)

data key;
   input (Brand Price) ($);
   datalines;
A x1
B x2
C x3
D x4
E x5
;

%mktex(3 ** 5, n=12)

%mktroll(design=randomized, key=key, out=sasuser.design, alt=brand)

%mktex(2 ** 12, n=16, seed=109)

data key;
   input (Brand Price Size Color Shape) ($); datalines;
          A     x1     x2   x3    x4
          B     x5     x6   x7    x8
          C     x9    x10  x11   x12
          None   .      .    .     .
;

%mktroll(design=randomized, key=key, out=sasuser.design, alt=brand)

%mktex(2 ** 14, n=16, seed=114)

data key;
   input (Brand Price Size Color Shape Pattern) ($);
   datalines;
A     x1     x2   x3    x4   x13
B     x5     x6   x7    x8     .
C     x9    x10  x11   x12   x14
None   .      .    .     .     .
;

%mktroll(design=randomized, key=key, out=sasuser.design, alt=brand)

%mktroll(design=randomized, key=key, out=sasuser.design, alt=brand,
         keep=x1 x5 x9)

%mktroll(help)
%mktroll(?)

******************* Begin MktRuns Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%mktruns(2 2 2 3 3 3 3)

%mktruns(2 ** 3 3 ** 4)

proc print label data=nums split='-';
   label s = '00'x;
   id n;
   run;

%mktruns(2 2 3 3 4 4 5 5)

%mktruns(2 2 3 3 4 4 5 5, max=5000)

%mktruns(2 2 2 3 3 3 3, interact=1*2, options=source)

%mktruns(help)
%mktruns(?)

%mktruns(2 ** 5, interact=@2)
%mktruns(2 ** 5, interact=1|2|3|4|5@2)
%mktruns(2 ** 5, interact=x1|x2|x3|x4|x5@2)

****************** Begin Paint Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%paint(help)
%paint(?)

****************** Begin PHChoice Macro Example Code ******************;

options ls=80 ps=60 nonumber nodate;
title;

%phchoice(on)

%phchoice(off)

proc template;
   source stat.phreg;
   run;

proc template;
   edit stat.phreg.ParameterEstimates;
      column Label DF Estimate StdErr ChiSq ProbChiSq;
      header h1;

      define h1;
         text "Multinomial Logit Parameter Estimates";
         space = 1;
         spill_margin;
         end;

      define Label;
         header = " " style = RowHeader;
         end;
      end;

      edit Stat.Phreg.CensoredSummary;
         column Stratum Pattern Freq GenericStrVar Total
                Event Censored;
         header h1;
         define h1;
            text "Summary of Subjects, Sets, "
                 "and Chosen and Unchosen Alternatives";
            space = 1;
            spill_margin;
            first_panel;
         end;

         define Freq;
           header=";Number of;Choices" format=6.0;
         end;

      define Total;
         header = ";Number of;Alternatives";
         format_ndec = ndec;
         format_width = 8;
      end;

      define Event;
         header = ";Chosen;Alternatives";
         format_ndec = ndec;
         format_width = 8;
      end;

      define Censored;
         header = "Not Chosen";
         format_ndec = ndec;
         format_width = 8;
      end;
      end;

   run;

* Delete edited templates, restore original templates;
proc template;
   delete Stat.Phreg.ParameterEstimates;
   delete Stat.Phreg.CensoredSummary;
   run;

%phchoice(on, Variable DF Estimate StdErr ChiSq ProbChiSq Label)

%phchoice(on)

%phchoice(help)
%phchoice(?)

%plotit(help)
%plotit(?)

%phchoice(off)
