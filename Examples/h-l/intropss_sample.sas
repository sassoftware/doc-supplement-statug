proc power;
   twosamplemeans test=diff
      meandiff = 5 6
      stddev = 12 18
      alpha = 0.05 0.1
      ntotal = 100 200
      power = .;
run;

ods graphics on;

proc power plotonly;
   twosamplemeans test=diff
      meandiff = 5 6
      stddev = 12 18
      alpha = 0.05 0.1
      ntotal = 100 200
      power = .;
   plot;
run;

ods graphics off;

   plot
      min=60
      yopts=(ref=0.9 crossref=yes)
      vary(color by stddev, linestyle by meandiff, symbol by alpha);

   ods output output=powdata;

data tpow;
   do meandiff = 5, 6;
      do stddev = 12, 18;
         do alpha = 0.05, 0.1;
            do ntotal = 100, 200;
               ncp = ntotal * 0.5 * 0.5 * meandiff**2 / stddev**2;
               critval = finv(1-alpha, 1, ntotal-2, 0);
               power = sdf('f', critval, 1, ntotal-2, ncp);
               output;
            end;
         end;
      end;
   end;
run;

proc print data=tpow;
run;

%let meandiff =     5;
%let stddev   =    12;
%let alpha    =  0.05;
%let ntotal   =   100;
%let nsim     = 10000;

data simdata;
   call streaminit(123);
   do isim = 1 to &nsim;
      do i = 1 to floor(&ntotal/2);
         group = 1;
         y = rand('normal', 0        , &stddev);
         output;
         group = 2;
         y = rand('normal', &meandiff, &stddev);
         output;
      end;
   end;
run;

ods exclude all;
proc ttest data=simdata;
   ods output ttests=tests;
   by isim;
   class group;
   var y;
run;
ods exclude none;

data tests;
   set tests;
   where method="Pooled";
   issig = probt < &alpha;
run;

proc freq data=tests;
   ods select binomial;
   tables issig / binomial(level='1');
run;

