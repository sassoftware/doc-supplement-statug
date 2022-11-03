/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: INTCLUS                                             */
/*   TITLE: Documentation Examples for Clustering Introduction  */
/* PRODUCT: SAS                                                 */
/*  SYSTEM: ALL                                                 */
/*    KEYS: CLUSTER                                             */
/*   PROCS: ACECLUS CLUSTER FASTCLUS PLOT TREE SGPLOT           */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data compact;
   keep x y;
   n=50; scale=1;
   mx=0; my=0; link generate;
   mx=8; my=0; link generate;
   mx=4; my=8; link generate;
   stop;
generate:
   do i=1 to n;
      x=rannor(1)*scale+mx;
      y=rannor(1)*scale+my;
      output;
   end;
   return;
run;

proc cluster data=compact outtree=tree method=single noprint;
run;

proc tree noprint out=out n=3;
   copy x y;
run;

ods graphics on / attrpriority=none;

proc sgplot noautolegend;
   title 'Single Linkage Cluster Analysis: '
         'Well-Separated, Compact Clusters';
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

data closer;
   keep x y c;
   n=50; scale=1;
   mx=0; my=0; c=3; link generate;
   mx=3; my=0; c=1; link generate;
   mx=1; my=2; c=2; link generate;
   stop;
generate:
   do i=1 to n;
      x=rannor(9)*scale+mx;
      y=rannor(9)*scale+my;
      output;
   end;
   return;
run;

title 'True Clusters for Data Containing Poorly Separated, Compact Clusters';
proc sgplot noautolegend;
   scatter y=y x=x / group=c;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc fastclus data=closer out=out maxc=3 noprint;
   var x y;
   title 'FASTCLUS Analysis: '
         'Poorly Separated, Compact Clusters';
run;

proc sgplot noautolegend;
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc cluster data=closer outtree=tree method=ward noprint;
   var x y;
run;

proc tree noprint out=out n=3;
   copy x y;
   title 'Ward''s Minimum Variance Cluster Analysis: '
         'Poorly Separated, Compact Clusters';
run;

proc sgplot noautolegend;
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc cluster data=closer outtree=tree method=average noprint;
   var x y;
run;

proc tree noprint out=out n=3 dock=5;
   copy x y;
   title 'Average Linkage Cluster Analysis: '
         'Poorly Separated, Compact Clusters';
run;

proc sgplot noautolegend;
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc cluster data=closer outtree=tree method=centroid noprint;
   var x y;
run;

proc tree noprint out=out n=3 dock=5;
   copy x y;
   title 'Centroid Cluster Analysis: '
         'Poorly Separated, Compact Clusters';
run;

proc sgplot noautolegend;
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc cluster data=closer outtree=tree method=twostage k=10 noprint;
   var x y;
run;

proc tree noprint out=out n=3;
   copy x y _dens_;
   title 'Two-Stage Density Linkage Cluster Analysis: '
         'Poorly Separated, Compact Clusters';
run;

proc sgplot noautolegend;
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc sgplot noautolegend;
   title 'Estimated Densities for Data Containing Poorly Separated, '
         'Compact Clusters';
   bubble y=y x=x size=_dens_ / nofill lineattrs=graphdatadefault;
run;

proc cluster data=closer outtree=tree method=single noprint;
   var x y;
run;

proc tree data=tree noprint out=out n=3 dock=5;
   copy x y;
   title 'Single Linkage Cluster Analysis: '
         'Poorly Separated, Compact Clusters';
run;

proc format;
   value out . = 'Outlier';
run;

proc sgplot noautolegend;
   styleattrs datasymbols=(circle plus x circlefilled);
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
   format cluster out.;
run;

data unequal;
   keep x y c;
   mx=1; my=0; n=20; scale=.5; c=1; link generate;
   mx=6; my=0; n=80; scale=2.; c=3; link generate;
   mx=3; my=4; n=40; scale=1.; c=2; link generate;
   stop;
generate:
   do i=1 to n;
      x=rannor(1)*scale+mx;
      y=rannor(1)*scale+my;
      output;
   end;
   return;
run;

title 'True Clusters for Data Containing Multinormal Clusters of Unequal Size';
proc sgplot noautolegend;
   scatter y=y x=x / group=c;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc fastclus data=unequal out=out maxc=3 noprint;
   var x y;
   title 'FASTCLUS Analysis: Compact Clusters of Unequal Size';
run;

proc sgplot noautolegend;
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc cluster data=unequal outtree=tree method=ward noprint;
   var x y;
run;

proc tree noprint out=out n=3;
   copy x y;
   title 'Ward''s Minimum Variance Cluster Analysis: '
         'Compact Clusters of Unequal Size';
run;

proc sgplot noautolegend;
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc cluster data=unequal outtree=tree method=average noprint;
   var x y;
run;

proc tree noprint out=out n=3 dock=5;
   copy x y;
   title 'Average Linkage Cluster Analysis: '
         'Compact Clusters of Unequal Size';
run;

proc sgplot noautolegend;
   styleattrs datasymbols=(circle plus x circlefilled);
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
   format cluster out.;
run;

proc cluster data=unequal outtree=tree method=centroid noprint;
   var x y;
run;

proc tree noprint out=out n=3 dock=5;
   copy x y;
   title 'Centroid Cluster Analysis: '
         'Compact Clusters of Unequal Size';
run;

proc sgplot noautolegend;
   styleattrs datasymbols=(circle plus x circlefilled);
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
   format cluster out.;
run;

proc cluster data=unequal outtree=tree method=twostage k=10 noprint;
   var x y;
run;

proc tree noprint out=out n=3;
   copy x y _dens_;
   title 'Two-Stage Density Linkage Cluster Analysis: '
         'Compact Clusters of Unequal Size';
run;

proc sgplot noautolegend;
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc sgplot noautolegend;
   title 'Estimated Densities for Data Containing '
         'Compact Clusters of Unequal Size';
   bubble y=y x=x size=_dens_ / nofill lineattrs=graphdatadefault;
run;

proc cluster data=unequal outtree=tree method=single noprint;
   var x y;
run;

proc tree data=tree noprint out=out n=3 dock=5;
   copy x y;
   title 'Single Linkage Cluster Analysis: '
         'Compact Clusters of Unequal Size';
run;

proc sgplot noautolegend;
   styleattrs datasymbols=(circle plus x circlefilled);
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
   format cluster out.;
run;

data elongate;
   keep x y;
   ma=8; mb=0; link generate;
   ma=6; mb=8; link generate;
   stop;
generate:
   do i=1 to 50;
      a=rannor(7)*6+ma;
      b=rannor(7)+mb;
      x=a-b;
      y=a+b;
      output;
   end;
   return;
run;

proc fastclus data=elongate out=out maxc=2 noprint;
run;

proc sgplot noautolegend;
   title 'FASTCLUS Analysis: Parallel Elongated Clusters';
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc cluster data=elongate outtree=tree method=average noprint;
run;

proc tree noprint out=out n=2 dock=5;
   copy x y;
run;

proc sgplot noautolegend;
   title 'Average Linkage Cluster Analysis: '
         'Parallel Elongated Clusters';
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc cluster data=elongate outtree=tree method=twostage k=10 noprint;
run;

proc tree noprint out=out n=2;
   copy x y;
run;

proc sgplot noautolegend;
   title 'Two-Stage Density Linkage Cluster Analysis: '
         'Parallel Elongated Clusters';
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc aceclus data=elongate out=ace p=.1;
   var x y;
   title 'ACECLUS Analysis: Parallel Elongated Clusters';
run;

proc sgplot noautolegend;
   title 'Data Containing Parallel Elongated Clusters';
   title2 'After Transformation by PROC ACECLUS';
   scatter y=can2 x=can1;
   xaxis label='Canonical Variable 1';
   yaxis label='Canonical Variable 2';
run;

proc cluster data=ace outtree=tree method=ward noprint;
   var can1 can2;
   copy x y;
run;

proc tree noprint out=out n=2;
   copy x y;
run;

proc sgplot noautolegend;
   title 'Ward''s Minimum Variance Cluster Analysis: '
         'Parallel Elongated Clusters';
   title2 'After Transformation by PROC ACECLUS';
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

data noncon;
   keep x y;
   do i=1 to 100;
      a=i*.0628319;
      x=cos(a)+(i>50)+rannor(7)*.1;
      y=sin(a)+(i>50)*.3+rannor(7)*.1;
      output;
   end;
run;

proc fastclus data=noncon out=out maxc=2 noprint;
run;

proc sgplot noautolegend;
   title 'FASTCLUS Analysis: Nonconvex Clusters';
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc cluster data=noncon outtree=tree method=centroid noprint;
run;

proc tree noprint out=out n=2 dock=5;
   copy x y;
run;

proc sgplot noautolegend;
   title 'Centroid Cluster Analysis: Nonconvex Clusters';
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;

proc cluster data=noncon outtree=tree method=twostage k=10 noprint;
run;

proc tree noprint out=out n=2;
   copy x y;
run;

proc sgplot noautolegend;
   title 'Two-Stage Density Linkage Cluster Analysis: Nonconvex Clusters';
   scatter y=y x=x / group=cluster;
   keylegend / location=inside position=topright sortorder=ascending
               across=1 noopaque title='';
run;
