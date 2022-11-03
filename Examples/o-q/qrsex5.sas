 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: qrsex5                                              */
 /*   TITLE: Quantile Process Example for PROC QUANTSELECT       */
 /*                                                              */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: Quantile Process Regression                         */
 /*   PROCS: QUANTSELECT                                         */
 /*                                                              */
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

proc quantselect data=analysisData;
   ods output ProcessEst=quantProcessEst;
   model y = &model / quantile=process(n=all) selection=none;
run;

proc print data=quantProcessEst(obs=10);
run;

proc quantselect data=analysisData;
   ods output ProcessEst=quantApproxProcessEst;
   model y = &model / quantile=process(n=10) selection=none;
run;

proc print data=quantApproxProcessEst;
run;

proc quantselect data=analysisData;
   model y = &model / quantile=process selection=none;
   output out=outQuantLev p ql;
run;

proc print data=outQuantLev(obs=10);
run;

proc iml;
   Obs  = {1 3001 6001};
   nObs = ncol(Obs);
   call symputx("nObs",nObs);

   use analysisData;
   read all var {&model} into x;
   read all var {"y"} into y;
   close analysisData;

   use outQuantLev;
   read all var {"ql_y"} into ql;
   read all var {"p_y"} into  qm;
   close outQuantLev;

   use quantProcessEst;
   read all var {"Intercept"} into beta0;
   read all var {&model} into beta;
   read all var {"QuantileLevel"} into qLev;
   close quantProcessEst;

   nTau = nrow(qLev);
   qPrcs = j((nTau*nObs),3);
   obsInfo = j(nObs,6);
   obsIndex ="_Obs1":"_Obs&nObs";
   levNames="_qLev1":"_qLev&nObs";
   qtNames ="_qt1":"_qt&nObs";
   qmNames ="_qMean1":"_qMean&nObs";

   do j=1 to nObs;
      iObs = Obs[j];
      call symputx(obsIndex[j],iObs);
      call symputx(qtNames[j], (y[iObs]));
      call symputx(levNames[j],(ql[iObs]));
      call symputx(qmNames[j], (qm[iObs]));
      obsInfo[j,1]=iObs;
      obsInfo[j,2]=y[iObs];
      obsInfo[j,3]=x[iObs,1];
      obsInfo[j,4]=x[iObs,2];
      obsInfo[j,5]=ql[iObs];
      obsInfo[j,6]=qm[iObs];
      Quantiles = beta0 + beta*t(x[iObs,]);
      call sort(Quantiles,1);
      qPrcs[((j-1)*nTau+1):(j*nTau),1]=iObs;
      qPrcs[((j-1)*nTau+1):(j*nTau),2]=qLev;
      qPrcs[((j-1)*nTau+1):(j*nTau),3]=Quantiles;
   end;

   obsInfoColName = {"Index" "Response Value" "x1" "x2"
                     "Quantile Level" "Mean Prediction"};
   obsInfoLabel = {"Information for Specified Observations"};
   print obsInfo[colname=obsInfoColName label=obsInfoLabel];

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
   pProb[1,3]          = (qLev[1]+qLev[2])/2;
   pProb[nTau,3]       = 1-(qLev[nTau-1]+qLev[nTau])/2;
   pProb[2:(nTau-1),3] = (qLev[3:nTau]-qLev[1:(nTau-2)])/2;

   do j=1 to nObs;
      jump = (j-1)*nTau;
      pProb[,(3+j)] = Y[(jump+1):(jump+nTau)];
   end;

   create probData from pProb[colname={"obs" "quantLev" "pProb"
                                       "Obs1" "Obs3001" "Obs6001"}];
   append from pProb;
   close probData;
quit;


proc kde data=probData;
   weight pProb;
   univar Obs1 Obs3001 Obs6001/ plots=densityoverlay;
run;
