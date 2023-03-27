/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCPPD                                             */
/*   TITLE: Posterior Predictive Distribution                   */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC                                           */
/*    MISC:                                                     */
/****************************************************************/

title 'An Example for the Posterior Predictive Distribution';

data SAT;
   input effect se @@;
   ind=_n_;
   datalines;
28.39 14.9  7.94 10.2 -2.75 16.3
 6.82 11.0 -0.64  9.4  0.63 11.4
18.01 10.4 12.16 17.6
;

ods exclude all;
proc mcmc data=SAT outpost=out nmc=40000 seed=12;
   parms m 0;
   parms v 1 /slice;
   prior m ~ general(0);
   prior v ~ general(1,lower=0);
   random mu ~ normal(m,var=v) subject=ind monitor=(mu);
   model effect ~ normal(mu,sd=se);
   preddist outpred=pout nsim=5000;
run;
ods exclude none;

data pred;
   set pout;
   mean = mean(of effect:);
   sd = std(of effect:);
   max = max(of effect:);
   min = min(of effect:);
run;

proc means data=SAT noprint;
   var effect;
   output out=stat mean=mean max=max min=min stddev=sd;
run;

data _null_;
   set stat;
   call symputx('mean',mean);
   call symputx('sd',sd);
   call symputx('min',min);
   call symputx('max',max);
run;

data _null_;
   set pred end=eof nobs=nobs;
   ctmean + (mean>&mean);
   ctmin + (min>&min);
   ctmax + (max>&max);
   ctsd + (sd>&sd);
   if eof then do;
      pmean = ctmean/nobs; call symputx('pmean',pmean);
      pmin = ctmin/nobs; call symputx('pmin',pmin);
      pmax = ctmax/nobs; call symputx('pmax',pmax);
      psd = ctsd/nobs; call symputx('psd',psd);
   end;
run;

proc template;
   define statgraph twobytwo;
      begingraph;
         layout lattice / rows=2 columns=2;
            layout overlay / yaxisopts=(display=none)
                             xaxisopts=(label="mean");
               layout gridded / columns=2 border=false
                                autoalign=(topleft topright);
                  entry halign=right "p-value =";
                  entry halign=left eval(strip(put(&pmean, 12.2)));
               endlayout;
               histogram mean / binaxis=false;
               lineparm x=&mean y=0 slope=. /
                        lineattrs=(color=red thickness=5);
            endlayout;
            layout overlay / yaxisopts=(display=none)
                             xaxisopts=(label="sd");
               layout gridded / columns=2 border=false
                                autoalign=(topleft topright);
                  entry halign=right "p-value =";
                  entry halign=left eval(strip(put(&psd, 12.2)));
               endlayout;
               histogram sd / binaxis=false;
               lineparm x=&sd y=0 slope=. /
                        lineattrs=(color=red thickness=5);
            endlayout;
            layout overlay / yaxisopts=(display=none)
                             xaxisopts=(label="max");
               layout gridded / columns=2 border=false
                                autoalign=(topleft topright);
                  entry halign=right "p-value =";
                  entry halign=left eval(strip(put(&pmax, 12.2)));
               endlayout;
               histogram max / binaxis=false;
               lineparm x=&max y=0 slope=. /
                        lineattrs=(color=red thickness=5);
            endlayout;
            layout overlay / yaxisopts=(display=none)
                             xaxisopts=(label="min");
               layout gridded / columns=2 border=false
                                autoalign=(topleft topright);
                  entry halign=right "p-value =";
                  entry halign=left eval(strip(put(&pmin, 12.2)));
               endlayout;
               histogram min / binaxis=false;
               lineparm x=&min y=0 slope=. /
                        lineattrs=(color=red thickness=5);
            endlayout;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=pred template=twobytwo;
run;

