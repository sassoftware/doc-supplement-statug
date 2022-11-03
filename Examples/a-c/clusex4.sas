/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CLUSEX4                                             */
/*   TITLE: Documentation Example 4 for PROC CLUSTER            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: HIERARCHICAL CLUSTER ANALYSIS TIES                  */
/*   PROCS: FREQ, SGSCATTER, CLUSTER, TREE, TABULATE            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CLUSTER, Example 4.                            */
/*    MISC:                                                     */
/****************************************************************/

title 'Hierarchical Cluster Analysis of Mammals'' Teeth Data';
title2 'Evaluating the Effects of Ties';
data teeth;
   input Mammal & $16. v1-v8 @@;
   label v1='Top incisors'
         v2='Bottom incisors'
         v3='Top canines'
         v4='Bottom canines'
         v5='Top premolars'
         v6='Bottom premolars'
         v7='Top molars'
         v8='Bottom molars';
   datalines;
Brown Bat         2 3 1 1 3 3 3 3   Mole              3 2 1 0 3 3 3 3
Silver Hair Bat   2 3 1 1 2 3 3 3   Pigmy Bat         2 3 1 1 2 2 3 3
House Bat         2 3 1 1 1 2 3 3   Red Bat           1 3 1 1 2 2 3 3
Pika              2 1 0 0 2 2 3 3   Rabbit            2 1 0 0 3 2 3 3
Beaver            1 1 0 0 2 1 3 3   Groundhog         1 1 0 0 2 1 3 3
Gray Squirrel     1 1 0 0 1 1 3 3   House Mouse       1 1 0 0 0 0 3 3
Porcupine         1 1 0 0 1 1 3 3   Wolf              3 3 1 1 4 4 2 3
Bear              3 3 1 1 4 4 2 3   Raccoon           3 3 1 1 4 4 3 2
Marten            3 3 1 1 4 4 1 2   Weasel            3 3 1 1 3 3 1 2
Wolverine         3 3 1 1 4 4 1 2   Badger            3 3 1 1 3 3 1 2
River Otter       3 3 1 1 4 3 1 2   Sea Otter         3 2 1 1 3 3 1 2
Jaguar            3 3 1 1 3 2 1 1   Cougar            3 3 1 1 3 2 1 1
Fur Seal          3 2 1 1 4 4 1 1   Sea Lion          3 2 1 1 4 4 1 1
Grey Seal         3 2 1 1 3 3 2 2   Elephant Seal     2 1 1 1 4 4 1 1
Reindeer          0 4 1 0 3 3 3 3   Elk               0 4 1 0 3 3 3 3
Deer              0 4 0 0 3 3 3 3   Moose             0 4 0 0 3 3 3 3
;

title3 'Raw Data';
proc cluster data=teeth method=average nonorm noeigen;
   var v1-v8;
   id mammal;
run;

title3 'Standardized Data';
proc cluster data=teeth std method=average nonorm noeigen;
   var v1-v8;
   id mammal;
run;

/* --------------------------------------------------------- */
/*                                                           */
/* The macro CLUSPERM randomly permutes observations and     */
/* does a cluster analysis for each permutation.             */
/* The arguments are as follows:                             */
/*                                                           */
/*    data    data set name                                  */
/*    var     list of variables to cluster                   */
/*    id      id variable for proc cluster                   */
/*    method  clustering method (and possibly other options) */
/*    nperm   number of random permutations.                 */
/*                                                           */
/* --------------------------------------------------------- */
%macro CLUSPERM(data,var,id,method,nperm);

   /* ------CREATE TEMPORARY DATA SET WITH RANDOM NUMBERS------ */
   data _temp_(drop=i);
      set &data;
      array _random_ _ran_1-_ran_&nperm;
      do i = 1 to dim(_random_);
         _random_[i]=ranuni(835297461);
      end;
   run;

   /* ------PERMUTE AND CLUSTER THE DATA----------------------- */
   %do n=1 %to &nperm;
      proc sort data=_temp_(keep=_ran_&n &var &id) out=_perm_;
         by _ran_&n;
      run;

      proc cluster method=&method noprint outtree=_tree_&n;
         var &var;
         id &id;
      run;
   %end;
%mend;

/* --------------------------------------------------------- */
/*                                                           */
/* The macro PLOTPERM plots various cluster statistics       */
/* against the number of clusters for each permutation.      */
/* The arguments are as follows:                             */
/*                                                           */
/*    nclus   maximum number of clusters to be plotted       */
/*    nperm   number of random permutations.                 */
/*                                                           */
/* --------------------------------------------------------- */
%macro PLOTPERM(nclus,nperm);

   /* ---CONCATENATE TREE DATA SETS FOR 20 OR FEWER CLUSTERS--- */
   data _plot_;
      set %do n=1 %to &nperm; _tree_&n(in=_in_&n) %end;;
      if _ncl_<=&nclus;
      %do n=1 %to &nperm;
         if _in_&n then _perm_=&n;
      %end;
      label _perm_='permutation number';
      keep _ncl_ _psf_ _pst2_ _ccc_ _perm_;
   run;

   /* ---PLOT THE REQUESTED STATISTICS BY NUMBER OF CLUSTERS--- */
   proc sgscatter;
      compare y=(_ccc_ _psf_ _pst2_) x=_ncl_ /group=_perm_;
      label _ccc_ = 'CCC' _psf_ = 'Pseudo F' _pst2_ = 'Pseudo T-Squared';
   run;
%mend;

/* --------------------------------------------------------- */
/*                                                           */
/* The macro TABPERM generates cluster-membership variables  */
/* for a specified number of clusters for each permutation.  */
/* PROC TABULATE gives the frequencies and means.            */
/* The arguments are as follows:                             */
/*                                                           */
/*    var     list of variables to cluster                   */
/*            (no "-" or ":" allowed)                        */
/*    id      id variable for proc cluster                   */
/*    meanfmt format for printing means in PROC TABULATE     */
/*    nclus   number of clusters desired                     */
/*    nperm   number of random permutations.                 */
/*                                                           */
/* --------------------------------------------------------- */
%macro TABPERM(var,id,meanfmt,nclus,nperm);

   /* ------CREATE DATA SETS GIVING CLUSTER MEMBERSHIP--------- */
   %do n=1 %to &nperm;
      proc tree data=_tree_&n noprint n=&nclus
                out=_out_&n(drop=clusname
                              rename=(cluster=_clus_&n));
         copy &var;
         id &id;
      run;

      proc sort;
         by &id &var;
      run;
   %end;

   /* ------MERGE THE CLUSTER VARIABLES------------------------ */
   data _merge_;
      merge
         %do n=1 %to &nperm;
            _out_&n
         %end;;
      by &id &var;
      length all_clus $ %eval(3*&nperm);
      %do n=1 %to &nperm;
         substr( all_clus, %eval(1+(&n-1)*3), 3) =
            put( _clus_&n, 3.);
      %end;
   run;

   /* ------ TABULATE CLUSTER COMBINATIONS------------ */
   proc sort;
      by _clus_:;
   run;
   proc tabulate order=data formchar='           ';
      class all_clus;
      var &var;
      table all_clus, n='FREQ'*f=5. mean*f=&meanfmt*(&var) /
         rts=%eval(&nperm*3+1);
   run;
%mend;

/* -TABULATE does not accept hyphens or colons in VAR lists- */
%let vlist=v1 v2 v3 v4 v5 v6 v7 v8;

title3 'Raw Data';

/* ------CLUSTER RAW DATA WITH AVERAGE LINKAGE-------------- */
%clusperm( teeth, &vlist, mammal, average, 10);

/* -----PLOT STATISTICS FOR THE LAST 20 LEVELS-------------- */
%plotperm(20, 10);

/* ------ANALYZE THE 4-CLUSTER LEVEL------------------------ */
%tabperm( &vlist, mammal, 9.1, 4, 10);

title3 'Standardized Data';

/*------CLUSTER STANDARDIZED DATA WITH AVERAGE LINKAGE------*/
%clusperm( teeth, &vlist, mammal, average std, 10);

/* -----PLOT STATISTICS FOR THE LAST 20 LEVELS-------------- */
%plotperm(20, 10);

/* ------ANALYZE THE 4-CLUSTER LEVEL------------------------ */
%tabperm( &vlist, mammal, 9.1, 4, 10);
