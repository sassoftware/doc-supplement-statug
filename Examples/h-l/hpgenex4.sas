/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: hpgenex4                                            */
/*   TITLE: Example 4 for PROC HPGENSELECT                      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection by the LASSO Method                 */
/*   PROCS: HPGENSELECT                                         */
/*    DATA: Simulated                                           */
/*                                                              */
/*     REF: SAS/HPA User's Guide, PROC HPGENSELECT chapter      */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 4: LASSO Model Selection
*****************************************************************/

%let nObs      = 1000000;
%let nContIn   = 20;
%let nContOut  = 80;
%let Seed      = 12345;

data ex4Data;
array xIn{&nContIn};
array xOut{&nContOut};

drop i j sign xBeta expXbeta;

seed = &Seed;
do i=1 to &nObs;
   sign  = -1;
       xBeta = 0;
       do j=1 to dim(xIn);
           call ranuni(seed,xIn[j]);
           xBeta  = xBeta + j*sign*xIn{j};
           sign   = -sign;
       end;

       do j=1 to dim(xOut);
          call ranuni(seed,xOut[j]);
       end;

       call ranuni(seed,xSubtle);
       call ranuni(seed,xTiny);

       xBeta = xBeta + 0.1*xSubtle + 0.05*xTiny;
       expXbeta = exp(xBeta/20);
       call ranpoi(seed,expXbeta,yPoisson);
       output;
end;
run;

proc hpgenselect data=ex4Data(Obs=10000);
   model yPoisson = x: / dist=Poisson;
   selection method=Lasso(choose=SBC) details=all;
   performance details;
run;

