/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCREO                                             */
/*   TITLE: An Example That Illustrates the REOBSINFO Option    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC                                           */
/*    MISC:                                                     */
/****************************************************************/
data input;
   array names{*} $ n1-n10 ("John" "Mary" "Chris" "Rob" "Greg"
                     "Jen" "Henry" "Alice" "James" "Toby");
   call streaminit(17);
   do i = 1 to 20;
      j = ceil(rand("uniform") * 10 );
      index = names[j];
      output;
   end;
   drop n: j;
run;

proc print data=input;
run;
ods select reobsinfo;
proc mcmc data=input reobsinfo stats=none diag=none;
   random u ~ normal(0, sd=1) subject=index;
   model general(0);
run;
