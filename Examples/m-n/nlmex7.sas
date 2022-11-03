/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlmex7                                              */
/*   TITLE: Documentation Example 7 for PROC NLMIXED            */
/*          Overdispersion hierarchical nonlinear mixed model   */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: NLMIXED                                             */
/*    DATA: Aklilu et al(2013)                                  */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data comet;
   set sashelp.comet;
   L = 0; M = 0; H = 0; PC = 0;
   if (dose = 1.25) then L  = 1;
   if (dose = 2.50) then M  = 1;
   if (dose = 5.00) then H  = 1;
   if (dose = 200)  then PC = 1;
run;

proc nlmixed data = comet;
   parms b0 = -25  b1 = -10 b2 = -10 b3 = -10 b4 = -10 rho = 10;
   bounds sd1 >=0, sd2 >=0;
   mu = b0+ b1*L+ b2*M+ b3*H+ b4*PC + rateff + sampeff;
   term = (length**rho)*exp(mu);
   llike = log(rho) + (rho-1)*log(length) + mu - term;
   model length ~ general(llike);
   random ratEff ~ normal(0,sd1) subject = rat;
   random sampEff ~ normal(0,sd2) subject = sample(rat);
   predict gamma(1+(1/rho))/(exp(mu)**(1/rho)) out = p1;
run;

ods select ParameterEstimates;
proc nlmixed data = comet;
   parms b0 = -25  b1 = -10 b2 = -10 b3 = -10 b4 = -10 alpha = 1 rho = 10;
   bounds sd1 >=0, sd2 >=0;
   mu = b0+ b1*L+ b2*M+ b3*H+ b4*PC + rateff + sampeff;
   num = rho*((length)**(rho-1))*exp(mu);
   den = (1+(((length)**rho)*exp(mu))/alpha)**(alpha+1);
   llike = log(num/den);
   model length ~ general(llike);
   random rateff ~ normal(0,sd1) subject = rat;
   random sampeff ~ normal(0,sd2) subject = sample(rat);
   predict (gamma(alpha-(1/rho))*gamma(1+(1/rho)))
           /(gamma(alpha)*((exp(mu)/alpha)**(1/rho))) out = p2;
run;

proc means data = p1 mean noprint;
   class sample;
   var pred;
   output out = p11 (keep = sample weibull_mean)mean = weibull_mean;
run;

proc means data = p2 mean noprint;
   class sample;
   var pred;
   output out = p21 (keep = sample weibull_gamma_mean)mean = weibull_gamma_mean;
run;

proc means data = comet mean noprint;
   class sample;
   var length;
   id dose rat;
   output out = p31(keep = dose rat sample observed_mean) mean = observed_mean;
run;

data average;
   merge p11 p21 p31;
   by sample;
   if sample = . then delete;
   label observed_mean = "Observed Average";
   label weibull_gamma_mean = "Weibull Gamma Average";
   label weibull_mean = "Weibull Average";
   label sample = "Sample Index";
   if dose = 0 then dosage = "0 Vehicle Control ";
   if dose = 1.25 then dosage = "1 Low";
   if dose = 2.50 then dosage = "2 Medium";
   if dose = 5.00 then dosage = "3 High";
   if dose = 200  then dosage = "4 Positive Control";
run;

proc sgpanel data = average;
   panelby dosage/onepanel layout = columnlattice novarname uniscale = row;
   rowaxis values=(10 to 80 by 5) label="Average Tail Length";
   series x = sample y = observed_mean;
   series x = sample y = weibull_mean;
   series x = sample y = weibull_gamma_mean;
run;
