/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: hpgamex4                                            */
/*   TITLE: Example 4 for PROC GAMPL                            */
/*    DESC: fitting a nonparametric tweedie regression          */
/*     REF:                                                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: GAMPL                                               */
/*                                                              */
/****************************************************************/

title 'Nonparametric Tweedie Model';
%let phi=0.4;
%let power=1.5;

data one;
   do i=1 to 1000;

      /* Sample the predictors */
      x1=ranuni(1);
      x2=ranuni(1);
      x3=ranuni(1);
      x4=ranuni(1);

      /* Apply nonlinear transformations to predictors */
      f1=2*sin(3.14159265*x1);
      f2=exp(2*x2)*0.8;
      f3=0.2*x3**11*(10*(1-x3))**6+10*(10*x3)**3*(1-x3)**10;
      xb=f1+f2+f3;
      xb=xb/20;
      mu=exp(xb);

      /* Compute parameters of compound Poisson distribution */
      lambda=mu**(2-&power)/(&phi*(2-&power));
      alpha=(2-&power)/(&power-1);
      gamma=&phi*(&power-1)*(mu**(&power-1));

      /* Simulate the response */
      rpoi=ranpoi(1,lambda);
      if rpoi=0 then y=0;
      else do;
         y=0;
         do j=1 to rpoi;
            y=y+rangam(1,alpha);
         end;
         y=y*gamma;
      end;
      output;
   end;
run;

proc genmod data=one;
   model y=x1 x2 x3 x4/dist=tweedie;
run;

proc gampl data=one seed=1234;
   model y=param(x1 x2 x3 x4)/dist=tweedie;
run;

proc gampl data=one seed=1234 plots;
   model y=spline(x1) spline(x2) spline(x3) spline(x4)/dist=tweedie;
run;

