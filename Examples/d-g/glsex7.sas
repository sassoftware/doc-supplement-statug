/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: glsex7                                              */
/*   TITLE: Example 7 for PROC GLMSELECT                        */
/*    DESC: Simulated example                                   */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection, LASSO                              */
/*          Safe Screening, Sure Independence Screening         */
/*   PROCS: GLMSELECT                                           */
/*                                                              */
/****************************************************************/

%let nObs      = 5000;
%let nContIn   = 5;
%let nContOut  = 1000;
%let nClassIn  = 2;
%let nClassOut = 1000;
%let maxLevs   = 5;
%let noiseScale= 1;

 data ex7Data;
   array xIn{&nContIn};
   array xOut{&nContOut};
   array cIn{&nClassIn};
   array cOut{&nClassOut};

   drop i j sign nLevs xBeta;

   do i=1 to &nObs;
      sign  = -1;
      xBeta = 0;
      do j=1 to dim(xIn);
         xIn{j} = ranuni(1);
         xBeta  = xBeta + sqrt(j)*sign*xIn{j};
         sign   = -sign;
      end;
      do j=1 to dim(xOut);
         xOut{j} = ranuni(1);
      end;

      do j=1 to dim(cIn);
         nLevs  = 2 + mod(j,&maxlevs-1);
         cIn{j} = 1+int(ranuni(1)*nLevs);
         xBeta  = xBeta + j*sign*(cIn{j}-nLevs/2);
         sign   = -sign;
      end;

      do j=1 to dim(cOut);
         nLevs  = 2 + mod(j,&maxlevs-1);
         cOut{j} = 1+int(ranuni(1)*nLevs);
      end;

      y = xBeta + &noiseScale*rannor(1);

      output;
  end;
run;

proc glmselect data=ex7Data;
   class c:;
   model y = x: c:/
         selection=lasso;
run;

proc glmselect data=ex7Data;
   class c:;
   model y = x: c:/
         selection=lasso(screen=sasvi);
run;

proc glmselect data=ex7Data;
   class c:;
   model y = x: c:/
         selection=lasso(screen=sis(keepnum=15));
run;
