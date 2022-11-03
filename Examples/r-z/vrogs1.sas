/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: VROGS1                                              */
/*   TITLE: Getting Started Example for PROC VARIOGRAM          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: spatial analysis, semivariogram                     */
/*   PROCS: VARIOGRAM                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC VARIOGRAM, GETTING STARTED EXAMPLE             */
/*    MISC:                                                     */
/****************************************************************/


title 'Spatial Correlation Analysis with PROC VARIOGRAM';

ods graphics on;


/* Perform preliminary analysis --------------------------------*/

proc variogram data=sashelp.thick plots=pairs(thr=30);
   compute novariogram nhc=20;
   coordinates xc=East yc=North;
   var Thick;
run;


/* Empirical SV (95% CL) ---------------------------------------*/

proc variogram data=sashelp.thick outv=outv;
   compute lagd=7 maxlag=10 cl robust;
   coordinates xc=East yc=North;
   var Thick;
run;

proc variogram data=sashelp.thick outv=outv plots(only)=moran;
   compute lagd=7 maxlag=10 autocorr(assum=random);
   coordinates xc=East yc=North;
   var Thick;
run;


/* Fit Gaussian model ------------------------------------------*/

proc variogram data=sashelp.thick outv=outv;
   store out=SemivStoreGau / label='Thickness Gaussian WLS Fit';
   compute lagd=7 maxlag=10;
   coordinates xc=East yc=North;
   model form=gau cl / covb;
   var Thick;
run;

ods graphics off;
