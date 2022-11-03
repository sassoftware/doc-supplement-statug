/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: qregex6                                             */
/*   TITLE: Documentation Example 6 for PROC QUANTREG           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Quantile Regression                                 */
/*                                                              */
/*   PROCS: QUANTREG                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

%let seed=123;
%let n=6001;
%let model=x1 x2;
data analysisData;
   do i=1 to &n;
      x1=(i-1)/(&n-1);
      x2=(1-x1)*(1-x1);
      y =x1*ranexp(&seed)+x2*(rannor(&seed)-3);
      output;
   end;
run;

proc quantreg data=analysisData;
   ods output ProcessEst=fqprEst
              AvgParameterEst=fqprAvgEst;
   model y = &model / quantile=fqpr(n=500);
run;


proc print data=fqprEst(obs=10);
run;


proc iml;

   /* Specify observations to be plotted */
   Obs  = {1 3001 6001};
   nObs = ncol(Obs);
   call symputx("nObs",nObs);

   /* Load training data */
   use analysisData;
   read all var {&model} into x;
   read all var {"y"} into y;
   close analysisData;

   /* Load parameter estimates for the quantile prcess  */
   use fqprEst;
   read all var {"Intercept"} into beta0;
   read all var {&model} into beta;
   read all var {"QuantileLevel"} into qLev;
   close fqprEst;

   /* Load average parameter estimates for the quantile prcess  */
   use fqprAvgEst;
   read all var {"Estimate"} into avgBeta;
   close fqprAvgEst;

   nTau = nrow(qLev);
   qPrcs = j((nTau*nObs),3);
   obsInfo = j(nObs,6);

   /* Make macro variable names */
   obsIndex ="_Obs1":"_Obs&nObs";
   levNames="_qLev1":"_qLev&nObs";
   qtNames ="_qt1":"_qt&nObs";
   qmNames ="_qMean1":"_qMean&nObs";
   gLNames ="_gridL1":"_gridL&nObs";
   gUNames ="_gridU1":"_gridU&nObs";

   /* Define a function for computing observation quantile level */
   start QntLev(y,sample);
      call sort(sample,1);
      nL = ncol(loc(sample<y));
      nH = ncol(loc(sample>y));
      nr = nrow(sample);
      if      nL=0       then qtlev = 0.25/nr;
      else if nH=0       then qtlev = 1-(0.25/nr);
      else if nr>(nL+nH) then qtlev = 0.5*(nL+nr-nH)/nr;
      else qtlev = (nL-0.5+(y-sample[nL])/(sample[nL+1]-sample[nL]))/nr;
      return qtlev;
   finish;

   do j=1 to nObs;
      iObs = Obs[j];

      /* Compute quantile process prediction for each specified observation */
      Quantiles = beta0 + beta*t(x[iObs,]);

      /* Compute average of the quantile process prediction */
      Average  = avgBeta[1]+x[iObs,]*avgBeta[2:3];

      /* Compute observation quantile level */
      QuantLev = QntLev(y[iObs],Quantiles);

      /* Save quantile process prediction */
      qPrcs[((j-1)*nTau+1):(j*nTau),1]=iObs;
      qPrcs[((j-1)*nTau+1):(j*nTau),2]=qLev;
      qPrcs[((j-1)*nTau+1):(j*nTau),3]=Quantiles;

      /* Make macro variables */
      call symputx(obsIndex[j],iObs);
      call symputx(qtNames[j], y[iObs]);
      call symputx(levNames[j],QuantLev);
      call symputx(qmNames[j], Average);
      call symputx(gLNames[j], Quantiles[1]);
      call symputx(gUNames[j], Quantiles[nTau]);

      /* Save observation quantile level and average of
         the quantile process prediction */
      obsInfo[j,1]=iObs;
      obsInfo[j,2]=y[iObs];
      obsInfo[j,3]=x[iObs,1];
      obsInfo[j,4]=x[iObs,2];
      obsInfo[j,5]=QuantLev;
      obsInfo[j,6]=Average;
   end;

   /* Print observation information */
   obsInfoColName = {"Index" "Response Value" "x1" "x2"
                     "Quantile Level" "Mean Prediction"};
   obsInfoLabel = {"Information for Specified Observations"};
   print obsInfo[colname=obsInfoColName label=obsInfoLabel];

   /* Store all quantile process predictions into a SAS data set  */
   create distData from qPrcs[colname={"iObs" "qLev" "Quantiles"}];
   append from qPrcs;
   close distData;
quit;

data distData;
   set distData;
   label iObs  = "Observation Index"
         qLev  = "Cumulative Probability"
         Quantiles = "Quantile";
run;

/* Make CDF plot for specified observations */
%macro plotCDF;
   proc sgplot data=distData;
      series y=qLev x=Quantiles/group=iObs;
      %do j=1 %to &nObs;
      refline &&_qLev&j/label=("Obs &&_Obs&j")
                        axis=y labelloc=inside;
      refline &&_qt&j/ label=("Obs &&_Obs&j")
                        axis=x;
      %end;
   run;
%mend;

%plotCDF;

proc iml;
   /* Load quantile process preditions */
   use distData;
   read all var {"iObs"} into iObs;
   read all var {"qLev"} into qLev;
   read all var {"Quantiles"} into Y;
   close distData;

   nObs = &nObs;
   nTau = nrow(qLev)/nObs;
   pProb = j(nTau,3+nObs);

   pProb[,1]           = t(1:nTau);
   pProb[,2]           = qLev[1:nTau];

   /* Compute weights for quantile predictions */
   pProb[1,3]          = (qLev[1]+qLev[2])/2;
   pProb[nTau,3]       = 1-(qLev[nTau-1]+qLev[nTau])/2;
   pProb[2:(nTau-1),3] = (qLev[3:nTau]-qLev[1:(nTau-2)])/2;

   do j=1 to nObs;
      jump = (j-1)*nTau;
      pProb[,(3+j)] = Y[(jump+1):(jump+nTau)];
   end;

   /* Store all quantile process predictions and their weights
      into a SAS data set */
   create probData from pProb[colname={"obs" "quantLev" "pProb"
                                       "Obs1" "Obs3001" "Obs6001"}];
   append from pProb;
   close probData;
quit;

/* Make PDF plot for specified observations */
%macro plotPDF;
   proc kde data=probData;
      weight pProb;
      univar
         %do j=1 %to &nObs;
            Obs&&_Obs&j (gridL=&&_gridL&j gridU=&&_gridU&j)
         %end;
       / plots=densityoverlay;
   run;
%mend;

%plotPDF;
