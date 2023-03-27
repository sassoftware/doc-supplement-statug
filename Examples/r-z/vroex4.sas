/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: VROEX4                                              */
/*   TITLE: Documentation Example 4 for PROC VARIOGRAM          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: spatial analysis, semivariogram, covariogram        */
/*   PROCS: VARIOGRAM                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC VARIOGRAM, EXAMPLE 4                           */
/*    MISC:                                                     */
/****************************************************************/

title 'Covariogram and Semivariogram';

data dataCoord;
   retain seed 837591;
   do i=1 to 100;
      East = round(100*ranuni(seed),0.1);
      North = round(100*ranuni(seed),0.1);
      output;
   end;
run;

/* Perform 500 simulations of SRF with features as specified ---*/

proc sim2d outsim=dataSims;
   simulate numreal=500 seed=79750
            nugget=2 scale=6 range=10 form=exp;
   mean 30;
   grid gdata=dataCoord xc=East yc=North;
run;


/* Compute empirical semivariogram for each simulation ---------*/

proc variogram data=dataSims outv=outv noprint;
   compute lagd=3 maxlag=18;
   coord xc=gxc yc=gyc;
   by _ITER_;
   var svalue;
run;


/* Sort OUTV= data set to use as input in PROC MEANS -----------*/

proc sort data=outv;
   by lag;
run;


/* Average semivariance and covariance for each lag over n sims */

proc means data=outv n mean noprint;
   var Distance variog covar;
   by lag;
   output out=dataAvgs mean(variog)=Semivariance
                       mean(covar)=Covariance
                       mean(Distance)=Distance;
run;


/* Plot average semivariogram and covariogram ------------------*/

proc sgplot data=dataAvgs;
   title "Empirical Semivariogram and Covariogram";
   xaxis label = "Distance" grid;
   yaxis  label = "Semivariance" min=-0.5 max=9 grid;
   y2axis label = "Covariance"   min=-0.5 max=9;
   scatter y=Semivariance x=Distance /
           markerattrs = GraphData1
           name='Semivar'
           legendlabel='Semivariance';
   scatter y=Covariance x=Distance /
           y2axis
           markerattrs = GraphData2
           name='Covar'
           legendlabel='Covariance';
   discretelegend 'Semivar' 'Covar';
run;


/* Obtain the sample variance from the data set ----------------*/

proc print data=dataAvgs (obs=1);
run;

