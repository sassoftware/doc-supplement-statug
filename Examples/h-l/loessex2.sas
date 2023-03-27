/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: loessex2                                            */
/*   TITLE: Documentation Example 2 for PROC LOESS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Local Regression                                    */
/*   PROCS: LOESS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data SO4;
   input Latitude Longitude SO4 @@;
   format Latitude f4.0;
   format Longitude f4.0;
   format SO4 f4.1;
   datalines;
32.45833  87.24222 1.403 34.28778  85.96889 2.103
33.07139 109.86472 0.299 36.07167 112.15500 0.304
31.95056 112.80000 0.263 33.60500  92.09722 1.950
34.17944  93.09861 2.168 36.08389  92.58694 1.578
36.10056  94.17333 1.708 39.00472 123.08472 0.096
36.56694 118.77722 0.259 41.76583 122.47833 0.065
34.80611 119.01139 0.053 38.53528 121.77500 0.135
37.44139 105.86528 0.247 38.11778 103.31611 0.326
39.99389 105.48000 0.687 39.40306 107.34111 0.225
39.42722 107.37972 0.339 37.19806 108.49028 0.559
40.50750 107.70194 0.250 40.36417 105.58194 0.307
40.53472 106.78000 0.564 37.75139 107.68528 0.557
39.10111 105.09194 0.371 40.80639 104.75472 0.286
29.97472  82.19806 1.279 28.54278  80.64444 1.564
25.39000  80.68000 0.912 30.54806  84.60083 1.243
27.38000  82.28389 0.991 32.14111  81.97139 1.225
33.17778  84.40611 1.580 31.47306  83.53306 0.851
43.46139 113.55472 0.180 43.20528 116.74917 0.103
44.29778 116.06361 0.161 40.05333  88.37194 2.940
41.84139  88.85111 2.090 41.70111  87.99528 3.171
37.71000  89.26889 2.523 38.71000  88.74917 2.317
37.43556  88.67194 3.077 40.93333  90.72306 2.006
40.84000  85.46389 2.725 38.74083  87.48556 3.158
41.63250  87.08778 3.443 40.47528  86.99222 2.775
42.90972  91.47000 1.154 40.96306  93.39250 1.423
37.65111  94.80361 1.863 39.10222  96.60917 0.898
38.67167 100.91639 0.536 37.70472  85.04889 2.693
37.07778  82.99361 2.195 38.11833  83.54694 2.762
36.79056  88.06722 2.377 29.92972  91.71528 1.276
30.81139  90.18083 1.393 44.37389  68.26056 2.268
46.86889  68.01472 1.551 44.10750  70.72889 1.631
45.48917  69.66528 1.369 39.40889  76.99528 2.535
38.91306  76.15250 2.477 41.97583  70.02472 1.619
42.39250  72.34444 2.156 42.38389  71.21472 2.417
45.56083  84.67833 1.701 46.37417  84.74139 1.539
47.10472  88.55139 1.048 42.41028  85.39278 3.107
44.22389  85.81806 2.258 47.53111  93.46861 0.550
47.94639  91.49611 0.563 46.24944  94.49722 0.591
44.23722  95.30056 0.604 32.30667  90.31833 1.614
32.33472  89.16583 1.135 34.00250  89.80000 1.503
38.75361  92.19889 1.814 36.91083  90.31861 2.435
45.56861 107.43750 0.217 48.51028 113.99583 0.387
48.49917 109.79750 0.100 46.48500 112.06472 0.209
41.15306  96.49278 0.743 41.05917 100.74639 0.391
36.13583 115.42556 0.139 41.28528 115.85222 0.075
38.79917 119.25667 0.053 39.00500 114.21583 0.273
43.94306  71.70333 2.391 40.31500  74.85472 2.593
33.22028 108.23472 0.377 35.78167 106.26750 0.315
32.90944 105.47056 0.355 36.04083 106.97139 0.376
36.77889 103.98139 0.326 42.73389  76.65972 3.249
42.29944  79.39639 3.344 43.97306  74.22306 2.322
44.39333  73.85944 2.111 41.35083  74.04861 3.306
43.52611  75.94722 3.948 42.10639  77.53583 2.231
41.99361  74.50361 3.022 36.13250  77.17139 1.857
35.06056  83.43056 2.393 35.69694  80.62250 2.082
35.02583  78.27833 1.729 34.97083  79.52833 1.959
35.72833  78.68028 1.780 47.60139 103.26417 0.354
48.78250  97.75417 0.306 47.12556  99.23694 0.273
39.53139  84.72417 3.828 40.35528  83.06611 3.401
39.79278  81.53111 3.961 40.78222  81.92000 3.349
36.80528  98.20056 0.603 34.98000  97.52139 0.994
36.59083 101.61750 0.444 44.38694 123.62306 0.629
44.63472 123.19000 0.329 45.44917 122.15333 0.716
43.12167 121.05778 0.050 44.21333 122.25333 0.423
43.89944 117.42694 0.071 45.22444 118.51139 0.109
40.78833  77.94583 3.275 41.59778  78.76750 4.336
40.65750  77.93972 3.352 41.32750  74.82028 3.081
33.53944  80.43500 1.456 44.35500  98.29083 0.372
43.94917 101.85833 0.224 35.96139  84.28722 3.579
35.18250  87.19639 2.148 35.66444  83.59028 2.474
35.46778  89.15861 1.811 33.95778 102.77611 0.376
28.46667  97.70694 0.886 29.66139  96.25944 0.934
30.26139 100.55500 0.938 32.37861  94.71167 2.229
31.56056  94.86083 1.472 33.27333  99.21528 0.890
33.39167  97.63972 1.585 37.61861 112.17278 0.237
41.65833 111.89694 0.271 38.99833 110.16528 0.143
41.35750 111.04861 0.172 42.87611  73.16333 2.412
44.52833  72.86889 2.549 38.04056  78.54306 2.478
37.33139  80.55750 1.650 38.52250  78.43583 2.360
47.86000 123.93194 1.144 48.54056 121.44528 0.837
46.83528 122.28667 0.635 46.76056 117.18472 0.255
37.98000  80.95000 2.396 39.08972  79.66222 3.291
45.79639  88.39944 1.054 45.05333  88.37278 1.457
44.66444  89.65222 1.044 43.70194  90.56861 1.309
46.05278  89.65306 1.132 42.57917  88.50056 1.809
45.82278  91.87444 0.984 41.34028 106.19083 0.335
42.73389 108.85000 0.236 42.49472 108.82917 0.313
42.92889 109.78667 0.182 43.22278 109.99111 0.161
43.87333 104.19222 0.306 44.91722 110.42028 0.210
45.07611  72.67556 2.646
;

proc format;
   picture latitude  -90 - 0  = '000S'
                      0  - 90 = '000N';
   picture longitude -180  - 0    = '000W'
                      0    - 180  = '000E';
run;
data SO4;
   set SO4;
   format longitude longitude. latitude  latitude.;
   longitude = -longitude;
run;

proc template;
   define statgraph gradientScatter;
      beginGraph;
         layout overlay;
            scatterPlot x=longitude y=latitude /
               markercolorgradient = SO4
               markerattrs         = (symbol=circleFilled)
               colormodel          =  ThreeColorRamp
               name                =  "Scatter";
            scatterPlot x=longitude y=latitude /
               markerattrs         = (symbol=circle);
            continuousLegend "Scatter"/title= "SO4";
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=SO4 template=gradientScatter;
run;


ods graphics on;

proc loess data=SO4;
   model SO4=Longitude Latitude / degree=2 interp=cubic;
run;

ods graphics off;


data PredPoints;
   format longitude longitude.
          latitude  latitude.;
   do Latitude = 26 to 46 by 1;
      do Longitude = -79 to -123 by -1;
         output;
      end;
   end;
run;

proc loess data=SO4;
   model SO4=Longitude Latitude;
   score data=PredPoints / print;
   ods Output ScoreResults=ScoreOut;
run;

proc template;
   define statgraph surface;
      begingraph;
         layout overlay3d / rotate=340 tilt=30 cube=false;
            surfaceplotparm x=Longitude y=Latitude z=p_SO4;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=ScoreOut template=surface;
run;

