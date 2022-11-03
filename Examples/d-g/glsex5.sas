
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: glsex5                                              */
/*   TITLE: Example 5 for PROC GLMSELECT                        */
/*    DESC: Simulated example featuring model averaging         */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Averaging, Adaptive Lasso                     */
/*   PROCS: GLMSELECT, SIMNORMAL                                */
/*                                                              */
/****************************************************************/

%macro makeRegressorData(nObs=100,nVars=8,rho=0.5,seed=1);
   data varCorr;
     drop i j;
     array x{&nVars};
     length  _NAME_ $8   _TYPE_ $8;
     _NAME_ = '';

     _TYPE_ = 'MEAN';
     do j=1 to &nVars; x{j}=0; end;
     output;

     _TYPE_ = 'STD';
     do j=1 to &nVars; x{j}=1;end;
     output;

     _TYPE_ = 'N';
     do j=1 to &nVars; x{j}=10000;end;
     output;

     _TYPE_ = 'CORR';
     do i=1 to &nVars;
        _NAME_="x" || trim(left(i));
        do j= 1 to &nVars;
           x{j}=&rho**(abs(i-j));
        end;
        output;
     end;
   run;

   proc simnormal data=varCorr(type=corr) out=Regressors
               numReal=&nObs seed=&seed;
      var x1-x&nVars;
   run;
%mend;

%makeRegressorData(nObs=100,nVars=10,rho=0.5);

data simData;
    set regressors;
    yTrue = 3*x1 + 1.5*x2 + 2*x5;
    y     = yTrue + 3*rannor(2);
run;

proc glmselect data=simData;
   model y=x1-x10/selection=LASSO(adaptive stop=none choose=sbc);
run;

ods graphics on;

proc glmselect data=simData seed=3 plots=(EffectSelectPct ParmDistribution);
   model y=x1-x10/selection=LASSO(adaptive stop=none choose=SBC);
   modelAverage tables=(EffectSelectPct(all) ParmEst(all));
run;

proc glmselect data=simData seed=3;
   model y=x1-x10/selection=LASSO(adaptive stop=none choose=SBC);
   modelAverage details;
   output out=simOut sampleFreq=sf samplePred=sp
                     p=p stddev=stddev lower=q25 upper=q75 median;
run;

proc print data=simOut(obs=5);
   var p stddev q25 median q75 sf1-sf3 sp1-sp3;
run;

proc glmselect data=simData seed=3 plots=(ParmDistribution);
   model y=x1-x10/selection=LASSO(adaptive stop=none choose=SBC);
   modelAverage refit(minpct=35 nsamples=1000) alpha=0.1;
run;

ods graphics off;
