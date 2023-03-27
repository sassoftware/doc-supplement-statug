/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: glsex8                                              */
/*   TITLE: Example 8 for PROC GLMSELECT                        */
/*    DESC: Simulated example                                   */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection, LASSO, Group LASSO                 */
/*   PROCS: GLMSELECT                                           */
/*                                                              */
/****************************************************************/

%macro makeRegressorData(data=,nObs=500,nCont=5,nClass=5,nLev=3);
   data &data;
      drop i j;
      %if &nCont>0  %then %do; array x{&nCont}  x1-x&nCont; %end;
      %if &nClass>0 %then %do; array c{&nClass} c1-c&nClass;%end;
      do i = 1 to &nObs;
         %if &nCont>0 %then %do;
            do j= 1 to &nCont;
               x{j} = rannor(1);
            end;
         %end;
         %if &nClass > 0 %then %do;
            do j=1 to &nClass;
               if      mod(j,3) = 0 then c{j} = ranbin(1,&nLev,.6);
               else if mod(j,3) = 1 then c{j} = ranbin(1,&nLev,.5);
               else if mod(j,3) = 2 then c{j} = ranbin(1,&nLev,.4);
            end;
         %end;
         output;
      end;
   run;
%mend;

%makeRegressorData(data=traindata,nObs=500,nCont=5,nClass=5,nLev=3);

%macro AddDepVar(data=,modelRHS =,errorStd = 1);
   data &data;
      set &data;
      y = &modelRHS + &errorStd * rannor(1);
   run;
%mend;

%AddDepVar(data    = traindata,
           modelRHS= x1 +
                     0.1*x2 - 0.1*x3 - 0.01* x4 -
                     c1,
           errorStd= 1);

ods graphics on;

proc glmselect data=traindata plots=coefficients;
  class c1-c5/split;
  effect s1=spline(x1/split);
  model y = s1 x2-x5 c:/
        selection=lasso(steps=20 choose=sbc);
run;

proc glmselect data=traindata plots=coefficients;
  class c1-c5;
  effect s1=spline(x1);
  effect s2=collection(x2 x3 x4);
  model y = s1 s2 x5 c:/
        selection=grouplasso(steps=20 choose=sbc rho=0.8);
run;

