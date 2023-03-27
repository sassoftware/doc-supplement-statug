/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlmex2                                              */
/*   TITLE: Documentation Example 2 for PROC NLMIXED            */
/*          Probit-Normal Model with Binomial Data              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Binomial data                                       */
/*          Group-specific variance components                  */
/*   PROCS: NLMIXED                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data rats;
   input trt $ m x @@;
   if (trt='c') then do;
      x1 = 1;
      x2 = 0;
   end;
   else do;
      x1 = 0;
      x2 = 1;
   end;
   litter = _n_;
   datalines;
c 13 13   c 12 12   c  9  9   c  9  9   c  8  8   c  8  8   c 13 12   c 12 11
c 10  9   c 10  9   c  9  8   c 13 11   c  5  4   c  7  5   c 10  7   c 10  7
t 12 12   t 11 11   t 10 10   t  9  9   t 11 10   t 10  9   t 10  9   t  9  8
t  9  8   t  5  4   t  9  7   t  7  4   t 10  5   t  6  3   t 10  3   t  7  0
;

proc nlmixed data=rats;
   parms t1=1 t2=1 s1=.05 s2=1;
   eta = x1*t1 + x2*t2 + alpha;
   p   = probnorm(eta);
   model x ~ binomial(m,p);
   random alpha ~ normal(0,x1*s1*s1+x2*s2*s2) subject=litter;
   estimate 'gamma2' t2/sqrt(1+s2*s2);
   predict p out=p;
run;

