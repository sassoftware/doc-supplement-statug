
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GENMEX12                                            */
/*   TITLE: Example 12 for PROC GENMOD                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: generalized linear models, Tweedie distribution     */
/*   PROCS: GENMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GENMOD, EXAMPLE 12                             */
/*    MISC:                                                     */
/****************************************************************/

%let nObs = 250;
%let nClass = 5;
%let nLevs = 4;
%let seed = 100;

data tmp1;
   array c{&nClass};

   keep c1-c&nClass yTweedie d1 d2;

   /* Tweedie parms */
   phi=0.5;
   p=1.5;

   do i=1 to &nObs;

      do j=1 to &nClass;
         c{j} = int(ranuni(1)*&nLevs);
      end;

      d1 = ranuni(&seed);
      d2 = ranuni(&seed);

      xBeta   =  0.5*((c2<2) - 2*(c1=1) + 0.5*c&nClass + 0.05*d1);
      mu      =  exp(xBeta);

      /* Poisson distributions parms */
      lambda = mu**(2-p)/(phi*(2-p));
      /* Gamma distribution parms */
      alpha = (2-p)/(p-1);
      gamma = phi*(p-1)*(mu**(p-1));

      rpoi = ranpoi(&seed,lambda);
      if rpoi=0 then yTweedie=0;
      else do;
         yTweedie=0;
         do j=1 to rpoi;
         yTweedie = yTweedie + rangam(&seed,alpha);
         end;
         yTweedie = yTweedie * gamma;
      end;
      output;
   end;
run;

proc genmod data=tmp1;
   class C1-C5;
   model yTweedie = C1-C5 D1 D2 / dist=Tweedie type3;
run;

proc genmod data=tmp1;
   class C1 C2;
   model yTweedie = C1 C2 D1 / dist=Tweedie(p=1.5) type3;
run;

