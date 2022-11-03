/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: glsdt                                               */
/*   TITLE: Details Section Examples for PROC GLMSELECT         */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection, ODS GRAPHICS                       */
/*   PROCS: GLMSELECT                                           */
/*                                                              */
/****************************************************************/

/****************************************************************/
/*  Details Section: Class Variable Coding Example              */
/****************************************************************/

data codingExample;
   drop i;
   do i=1 to 1000;
      c1 = 1 + mod(i,6);
      if      i < 50  then c2 = 'very low ';
      else if i < 250 then c2 = 'low';
      else if i < 500 then c2 = 'medium';
      else if i < 800 then c2 = 'high';
      else                 c2 = 'very high';
      x1 = ranuni(1);
      x2 = ranuni(1);
      y = x1 + 10*(c1=3) +5*(c1=5) +rannor(1);
      output;
   end;
run;

proc glmselect data=codingExample;
   class c1(param=ref split) c2(param=ordinal order=data) /
          delimiter = ',' showcoding;
   model y = c1 c2 x1 x2/orderselect;
run;

/****************************************************************/
/*  Details Section: Using Macro Variables                      */
/****************************************************************/

data one(drop=i j);
   array x{5} x1-x5;
   do i=1 to 1000;
      classVar = mod(i,4)+1;
      do j=1 to 5;
         x{j} = ranuni(1);
      end;
      if i<400 then do;
         byVar = 'group 1';
         y     = 3*classVar+7*x2+5*x2*x5+rannor(1);
      end;
      else do;
         byVar = 'group 2';
         y     = 2*classVar+x5+rannor(1);
      end;
      output;
   end;
run;

proc glmselect data=one;
   by     byVar;
   class  classVar;
   model  y = classVar x1|x2|x3|x4|x5 @2 /
                  selection=stepwise(stop=aicc);
   output out=glmselectOutput;
run;

%macro LSMeansAnalysis;
   %do i=1 %to &_GLSNUMBYS;
      title1  "Analysis Using the Selected Model for BY group number &i";
      title2 "Selected Effects: &&_GLSIND&i";

      ods select LSMeans;
      proc glm data=glmselectOutput(where = (_BY_ = &i));
         class classVar;
         model y = &&_GLSIND&i;
         lsmeans classVar;
      run;quit;
   %end;
%mend;

%LSMeansAnalysis;

/****************************************************************/
/*  Details Section: Using a STORE statement                    */
/****************************************************************/

proc glmselect data=one;
   by     byVar;
   class  classVar;
   model  y = classVar x1|x2|x3|x4|x5 @2 /
                  selection=stepwise(stop=aicc);
   store out=glmselectStore;
run;

proc plm source=glmselectStore;
   lsmeans classVar;
run;

ods graphics on;

proc glmselect data=sashelp.baseball plots=coefficients;
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor|yrMajor crAtBat|crAtBat crHits|crHits
                     crHome|crHome crRuns|crRuns crRbi|crRbi
                     crBB|crBB league division nOuts nAssts nError /
                     selection=forward(stop=AICC CHOOSE=SBC);
run;

proc glmselect data=sashelp.baseball
     plots(unpack maxparmlabel=0 stepaxis=number)=coefficients;

   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor|yrMajor crAtBat|crAtBat crHits|crHits
                     crHome|crHome crRuns|crRuns crRbi|crRbi
                     crBB|crBB league division nOuts nAssts nError /
                     selection=forward(stop=none);
run;

proc glmselect data=sashelp.baseball plots=criteria;
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor|yrMajor crAtBat|crAtBat crHits|crHits
                     crHome|crHome crRuns|crRuns crRbi|crRbi
                     crBB|crBB league division nOuts nAssts nError /
                     selection=forward(steps=15 choose=AICC)
                     stats=PRESS;
run;

proc glmselect data=sashelp.baseball plots=criteria(startstep=10 endstep=16);
   class league division;
   model logSalary = nAtBat nHits nHome nRuns nRBI nBB
                     yrMajor|yrMajor crAtBat|crAtBat crHits|crHits
                     crHome|crHome crRuns|crRuns crRbi|crRbi
                     crBB|crBB league division nOuts nAssts nError /
                     selection=forward(stop=none choose=AICC);
run;

ods graphics off;
