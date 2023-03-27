/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: regdt                                               */
/*   TITLE: Details Section Examples for PROC REG               */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Ordinary Least Squares Regression                   */
/*   PROCS: REG                                                 */
/*    DATA: Fitness, USPopulation                               */
/*                                                              */
/****************************************************************/

data fitness;
   input Age Weight Oxygen RunTime RestPulse RunPulse MaxPulse @@;
   datalines;
44 89.47 44.609 11.37 62 178 182   40 75.07 45.313 10.07 62 185 185
44 85.84 54.297  8.65 45 156 168   42 68.15 59.571  8.17 40 166 172
38 89.02 49.874  9.22 55 178 180   47 77.45 44.811 11.63 58 176 176
40 75.98 45.681 11.95 70 176 180   43 81.19 49.091 10.85 64 162 170
44 81.42 39.442 13.08 63 174 176   38 81.87 60.055  8.63 48 170 186
44 73.03 50.541 10.13 45 168 168   45 87.66 37.388 14.03 56 186 192
45 66.45 44.754 11.12 51 176 176   47 79.15 47.273 10.60 47 162 164
54 83.12 51.855 10.33 50 166 170   49 81.42 49.156  8.95 44 180 185
51 69.63 40.836 10.95 57 168 172   51 77.91 46.672 10.00 48 162 168
48 91.63 46.774 10.25 48 162 164   49 73.37 50.388 10.08 67 168 168
57 73.37 39.407 12.63 58 174 176   54 79.38 46.080 11.17 62 156 165
52 76.32 45.441  9.63 48 164 166   50 70.87 54.625  8.92 48 146 155
51 67.25 45.118 11.08 48 172 172   54 91.63 39.203 12.88 44 168 172
51 73.71 45.790 10.47 59 186 188   57 59.08 50.545  9.93 49 148 155
49 76.32 48.673  9.40 56 186 188   48 61.24 47.920 11.50 52 170 176
52 82.78 47.467 10.50 53 170 172
;

data USPopulation;
   input Population @@;
   retain Year 1780;
   Year=Year+10;
   YearSq=Year*Year;
   Population=Population/1000;
   datalines;
3929 5308 7239 9638 12866 17069 23191 31443 39818 50155
62947 75994 91972 105710 122775 131669 151325 179323 203211
226542 248710 281422
;

proc corr data=fitness outp=r noprint;
   var Oxygen RunTime Age Weight RunPulse MaxPulse RestPulse;
run;
proc print data=r;
run;
proc reg data=r;
   model Oxygen=RunTime Age Weight;
run;

proc reg data=fitness outsscp=sscp noprint;
   model Oxygen=RunTime Age Weight RunPulse MaxPulse RestPulse;
run;
proc print data=sscp;
run;
proc reg data=sscp;
   model Oxygen=RunTime Age Weight;
run;

proc reg data=USPopulation outest=est;
   m1: model Population=Year;
   m2: model Population=Year YearSq;
run;
proc print data=est;
run;

proc reg data=USPopulation outest=est tableout alpha=0.1;
   m1: model Population=Year/noprint;
   m2: model Population=Year YearSq/noprint;
run;
proc print data=est;
run;

proc reg data=fitness outest=est;
   model Oxygen=Age Weight RunTime RunPulse RestPulse MaxPulse
         / selection=rsquare mse jp gmsep cp aic bic sbc b best=1;
run;
proc print data=est;
run;

proc reg data=fitness outsscp=sscp;
   var Oxygen RunTime Age Weight RestPulse RunPulse MaxPulse;
run;
proc print data=sscp;
run;

ods graphics on;

proc reg data=sashelp.Class plots(modelLabel only)=ResidualByPredicted;
   model Weight=Age Height;
run;

   delete age;
   print;
run;

   add age;
   print;
run;

   reweight r.>20;
   print;
run;

proc reg data=fitness;
   model Oxygen=RunTime Age Weight RunPulse MaxPulse RestPulse
         / ss1 ss2 stb clb covb corrb;
run;


data USPop2;
   input Year @@;
   YearSq=Year*Year;
   datalines;
2010 2020 2030
;

data USPop2;
   set USPopulation USPop2;
run;

proc reg data=USPop2;
   id Year;
   model Population=Year YearSq / r cli clm;
run;

data fit2;
   set fitness;
   Dif=RunPulse-RestPulse;
run;
proc reg data=fit2;
   model Oxygen=RunTime Age Weight RunPulse MaxPulse RestPulse Dif;
run;

proc reg data=fitness;
   model Oxygen=RunTime Age Weight RunPulse MaxPulse RestPulse
         / tol vif collin;
run;

proc reg data=USPopulation;
   where Year <= 1970;
   model Population=Year YearSq / influence;
run;

ods graphics on;

proc reg data=USPopulation
      plots(label)=(CooksD RStudentByLeverage DFFITS DFBETAS);
   where Year <= 1970;
   id Year;
   model Population=Year YearSq;
run;

proc reg data=USPopulation plots(only)=residualchart;
   where Year <= 1970;
   id Year;
   model Population=Year YearSq;
run;

ods graphics on;

proc reg data=fitness;
   model Oxygen=RunTime Weight Age / partial;
run;

ods graphics off;

proc reg data=sashelp.Class;
   model Weight=Age Height / p;
   id Name;
run;
   reweight obs.=17;
   reweight r. le -17 or r. ge 17 / weight=0.5;
   print p;
run;
   reweight allobs / weight=1.0;
   reweight obs.=17;
   refit;
   reweight r. le -17 or r. ge 17 / weight=.5;
   print;
run;
   reweight allobs / reset;
   print;
run;
   reweight r. le -12 or r. ge 12 / weight=.75;
   reweight r. le -17 or r. ge 17 / weight=.5;
   reweight undo;
   print;
run;
   reweight r. le -12 or r. ge 12 / weight=.75;
   reweight r. le -17 or r. ge 17 / weight=.5;
   reweight / reset;
   print;
run;


* Manova Data from Morrison (1976, 190);
data a;
   input sex $ drug $ @;
   do rep=1 to 4;
      input y1 y2 @;
      sexcode=(sex='m')-(sex='f');
      drug1=(drug='a')-(drug='c');
      drug2=(drug='b')-(drug='c');
      sexdrug1=sexcode*drug1;
      sexdrug2=sexcode*drug2;
      output;
   end;
   datalines;
m a  5  6  5  4  9  9  7  6
m b  7  6  7  7  9 12  6  8
m c 21 15 14 11 17 12 12 10
f a  7 10  6  6  9  7  8 10
f b 10 13  8  7  7  6  6  9
f c 16 12 14  9 14  8 10  5
;

proc reg;
   model y1 y2=sexcode drug1 drug2 sexdrug1 sexdrug2;
   y1y2drug: mtest y1=y2, drug1,drug2;
   drugshow: mtest drug1, drug2 / print canprint;
run;

proc reg data=USPopulation;
   model Population=Year YearSq / dwProb;
run;


/* PROC REG Heat Map Example -----------------------------------*/

data x;
   do i = 1 to 25000;
      x = 2 * normal(104);
      y = x + sin(x * 2) + 3 * normal(104);
      output;
   end;
run;

ods graphics on;

proc reg data=x plots(maxpoints=30000);
   model y = x;
quit;

proc reg data=x;
   model y = x;
quit;

