/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCMRE                                             */
/*   TITLE: Monitor Functions of Random-Effects Parameters      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC                                           */
/*    MISC:                                                     */
/****************************************************************/

/****************************************************************/
/*   Indexing Subject Variable                                  */
/****************************************************************/

data a;
   input students @@;
   datalines;
1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10
;

proc mcmc data=a monitor=(p) diag=none stats=none outpost=a1
   plots=none seed=1;
   array p[10];
   random u ~ n(0, sd=1) subject=students;
   p[students] = logistic(u);
   model general(0);
run;

proc print data=a1(obs=3);
run;

/****************************************************************/
/*   Unsorted Numeric Subject Variable (repeated values)        */
/****************************************************************/

data a;
   input students @@;
   datalines;
   1 1 1 3 5 3 4 5 3 1 5 5 4 4 2 2 2 2 4 3
;
proc mcmc data=a monitor=(p) diag=none stats=none outpost=a1
   plots=none seed=1;
   array p[5];
   random u ~ n(0, sd=1) subject=students;
   p[students] = logistic(u);
   model general(0);
run;

proc print data=a1(obs=3);
run;


/****************************************************************/
/*   Non-Indexing Subject Variable                              */
/****************************************************************/

data a;
   input students$ @@;
   datalines;
   smith john john mary kay smith lizzy ben ben dylan
   ben toby abby mary kay kay lizzy ben dylan mary
;

proc sql noprint;
   select count(distinct(students)) into :nuniq from a;
quit;
%put &nuniq;

proc freq data=a order=data noprint;
   tables students / out=_f(keep=students);
run;

proc print data=_f;
run;

data a(drop=n);
   set a;
   do i = 1 to nobs until(students=n);
      set _f(keep=students rename=(students=n)) point=i nobs=nobs;
      Index = i;
   end;
run;

proc print data=a;
run;

data _f;
   set _f;
   subj = compress('p_'||students);
run;
proc sql noprint;
   select subj into :pnames separated by ' ' from _f;
quit;
%put &pnames;

proc mcmc data=a monitor=(p) diag=none stats=none outpost=a1
   plots=none seed=1;
   array p[&nuniq] &pnames;
   random u ~ n(0, sd=1) subject=students;
   p[index] = logistic(u);
   model general(0);
run;

proc print data=a1(obs=3);
run;

/****************************************************************/
/*   Unsorted Numerals                                          */
/****************************************************************/

data a;
   call streaminit(1);
   do i = 1 to 20;
      students = rand("poisson", 20);
      output;
   end;
   drop i;
run;

proc sql noprint;
   select count(distinct(students)) into :nuniq from a;
quit;
%put &nuniq;

proc freq data=a order=data noprint;
   tables students / out=_f(keep=students);
run;

data a(drop=n);
   set a;
   do i = 1 to nobs until(students=n);
      set _f(keep=students rename=(students=n)) point=i nobs=nobs;
      Index = i;
   end;
run;

data _f;
   set _f;
   subj = compress('p_'||students);
proc sql noprint;
   select subj into :pnames separated by ' ' from _f;
   quit;
%put &pnames;

proc mcmc data=a monitor=(p) diag=none stats=none outpost=a1
   plots=none seed=1;
   array p[&nuniq] &pnames;
   random u ~ n(0, sd=1) subject=students;
   p[index] = logistic(u);
   model general(0);
run;

proc print data=a1(obs=3);
run;
