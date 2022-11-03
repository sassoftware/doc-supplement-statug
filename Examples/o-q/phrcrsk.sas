/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PHRCRSK                                             */
/*   TITLE: Regression Analysis for Competing-Risks Data        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Competing Risks, Cause-Specific Hazard, Sub-        */
/*          distribution Hazard                                 */
/*   PROCS: PHREG                                               */
/*    DATA: Pintilie, M. (2006): Competing Risks -- A Practical */
/*          Perspective                                         */
/*    MISC:                                                     */
/****************************************************************/

proc format;
     value $ node
                    'N' = 0
                    'E'=  0
                    'Y' = 1;
data hypoxia;
   input pelvicln $  pelrec$  disrec $ tumsize  hgb  ifp  age  hp5  survtime
         stat  dftime  dfcens  resp $ stnum;
   if      pelrec='Y' then cens=1;
   else if disrec='Y' then cens=2;
   else                    cens=0;
   if      disrec='Y' then cens2=1;
   else if pelrec='Y' then cens2=2;
   else                    cens2=0;
   format pelvicln $node.;
   datalines;
N  N  N   7.0  119   8.0  78  32.1428571  6.152  0  6.152  0  CR    1
N  N  N   2.0  131   8.2  69   2.1739130  8.008  0  8.008  0  CR    2
N  Y  N  10.0  126   8.6  55  52.3255814  0.621  1  0.003  1  NR    3
N  Y  Y   8.0  141   3.3  55   3.2608696  1.120  1  1.073  1  CR    4
Y  Y  N   8.0   95  18.5  50  85.4304636  1.292  1  0.003  1  NR    5
N  N  N   8.0  132  20.0  57  19.3548387  7.929  0  7.929  0  CR    6
E  N  N   4.0  127  21.8  53  44.5783133  8.454  0  8.454  0  CR    7
N  Y  Y   5.0  142  31.6  62  59.6774194  7.116  0  7.107  1  CR    8
N  N  N   5.0  145  16.5  23  29.1666667  8.378  0  8.378  0  CR    9
N  N  N   3.0  142  31.5  57  85.7142857  8.178  0  8.178  0  CR   10
N  N  N   4.0  124  18.5  74   8.0645161  3.395  0  3.395  0  CR   11
Y  Y  Y   5.0  133  12.8  67  77.6315789  1.016  1  0.003  1  NR   12
N  Y  N   4.0  133  18.4  72  33.3333333  3.699  1  1.350  1  CR   13
E  Y  Y   8.0  116  18.5  66  99.2187500  0.630  1  0.003  1  NR   14
Y  N  Y  10.0   82  21.0  47  66.2921348  8.194  0  0.512  1  CR   15
N  N  Y   5.0  118  23.6  61  55.0000000  4.764  1  1.714  1  CR   16
N  Y  N   7.0   95  21.0  78  81.6000000  2.590  1  0.003  1  NR   17
N  N  N   6.0  150  11.1  52  56.7567568  7.707  0  7.707  0  CR   18
N  Y  Y   7.0  119  14.6  33  52.0408163  1.478  1  0.939  1  CR   19
N  N  N   5.0  125  30.9  45  46.7741935  7.316  0  7.316  0  CR   20
E  N  N   9.0  127  19.6  38  43.7500000  7.841  0  7.841  0  CR   21
N  N  Y  10.0  143  24.0  55  91.7293233  1.133  1  0.589  1  CR   22
Y  Y  N   5.0  105  15.8  31  12.7450980  1.268  1  0.003  1  NR   23
N  N  N   6.0  125  15.0  70  32.5000000  7.543  0  7.543  0  CR   24
Y  N  N   3.0  151  13.2  75  82.5000000  6.300  0  6.300  0  CR   25
N  N  N   5.0  142  16.8  71  57.7777778  7.587  0  7.587  0  CR   26
E  Y  Y   5.0  114  16.8  47  70.6293706  3.121  1  1.123  1  CR   27
N  N  N   4.0  145   6.6  67  12.2807018  6.957  0  6.957  0  CR   28
Y  Y  N   8.0  120  24.8  60  47.0198676  0.841  1  0.003  1  NR   29
Y  N  Y   5.0  132  12.0  41  17.1641791  1.766  1  0.460  1  CR   30
N  Y  Y   5.0  133  37.4  27  34.3750000  1.344  1  0.003  1  NR   31
N  N  N   4.0  123  10.3  55  64.8648649  6.114  0  6.114  0  CR   32
E  N  N   5.0  100  19.4  38  35.7142857  6.374  0  6.374  0  CR   33
Y  Y  N   4.0  137  14.2  30  58.8888889  7.277  0  2.519  1  CR   34
N  N  N   5.0  112  16.6  43  12.5984252  5.714  0  5.714  0  CR   35
N  N  Y   4.0  124  13.9  48  30.2325581  2.779  1  1.514  1  CR   36
N  Y  Y   8.0  115  47.9  36  54.8872180  1.098  1  0.003  1  NR   37
N  N  N   6.0  116  14.5  35  63.4782609  6.812  0  6.812  0  CR   38
N  N  N   7.0   99  29.9  66  87.3873874  1.689  0  1.689  0  CR   39
N  N  N   6.0  124  17.5  72  26.0162602  6.097  0  6.097  0  CR   40
N  N  N   3.5  129  23.6  63  24.8000000  5.421  0  5.421  0  CR   41
N  Y  N   6.0  135  18.5  68  63.0136986  2.938  1  1.246  1  CR   42
E  N  N   5.0  136  24.8  66  67.5000000  6.108  0  6.108  0  CR   43
E  Y  Y   8.0  147  34.6  54  27.6315789  2.294  1  1.084  1  CR   44
N  N  N   5.0  124   7.1  59  44.8275862  5.988  0  5.988  0  CR   45
E  Y  N   6.0  123   6.5  72  28.1609195  2.278  1  1.530  1  CR   46
Y  Y  N   3.0  143  19.6  32  51.8750000  1.949  1  1.029  1  CR   47
N  N  Y   6.0  117  32.0  43  78.8079470  3.784  0  1.068  1  CR   48
N  N  N   4.5  130  12.9  74  11.2500000  2.779  0  2.779  0  CR   49
E  N  N   6.0  109  16.3  35  11.8750000  6.442  0  6.442  0  CR   50
E  N  N   4.5  109  13.8  41  50.0000000  2.100  0  2.100  0  CR   51
N  Y  Y   8.0  126  22.3  46  88.7500000  1.287  1  0.003  1  NR   52
N  N  N   5.0  139  12.0  65  27.3437500  6.360  0  6.360  0  CR   53
N  N  N   4.0  129   9.8  46  31.5436242  0.901  0  0.901  0  CR   54
N  N  N   3.0  152  19.4  57  64.9253731  6.272  0  6.272  0  CR   55
E  N  N   5.0  124  18.7  27  29.0502793  3.316  0  3.316  0  CR   56
N  Y  Y   3.0  129  23.1  45  43.6241611  2.839  1  2.606  1  CR   57
N  N  N   5.0  122  12.1  33  30.6250000  5.938  0  5.938  0  CR   58
N  N  Y   6.0  139  23.4  49  80.8917197  1.514  1  1.013  1  CR   59
N  N  N   3.0  139  12.5  61  58.0246914  5.199  0  5.199  0  CR   60
N  N  N   5.0  151  11.7  33  58.7500000  5.306  0  5.306  0  CR   61
N  N  Y   4.0  123  12.9  67  19.5652174  4.331  0  3.814  1  CR   62
N  N  N   4.0  121  11.2  66  19.5652174  3.127  0  3.127  0  CR   63
N  N  Y   4.0  119  23.6  55  77.2972973  2.196  1  0.709  1  CR   64
E  N  Y   5.0  105  26.7  43  60.7142857  2.628  1  1.610  1  CR   65
N  N  N   4.0  140  21.5  77  35.5555556  5.153  0  5.153  0  CR   66
E  N  Y   6.0  132  28.9  53  81.7610063  2.313  1  1.391  1  CR   67
Y  Y  Y   8.0  122  21.1  44  65.6250000  1.210  1  0.003  1  NR   68
Y  N  N   6.0  128  23.2  68  87.7906977  1.076  0  1.076  0  CR   69
Y  Y  N   8.0  114  43.5  51  53.1645570  5.791  0  0.003  1  NR   70
E  N  Y   5.0  123  33.3  49  78.2608696  4.482  0  1.785  1  CR   71
E  N  N   4.0  136  10.0  23  62.7329193  4.446  0  4.446  0  CR   72
E  Y  N   7.5   95  11.0  32  93.0817610  0.980  1  0.003  1  NR   73
E  N  Y   4.0  129  42.1  64  58.7500000  1.106  1  0.690  1  CR   74
N  N  N   3.5  138  14.0  71  41.3043478  3.348  0  3.348  0  CR   75
Y  N  N   8.0  137  18.5  41  66.1870504  5.380  0  5.380  0  CR   76
N  Y  N   5.0  124  18.5  54  83.0357143  5.350  0  0.991  1  CR   77
E  N  N   5.0  144  28.5  46  73.7500000  4.786  0  4.786  0  CR   78
Y  Y  Y  10.0  106  20.2  62  71.8750000  2.593  1  1.541  1  CR   79
N  N  N   8.0  124  20.6  42  59.1397849  5.021  0  5.021  0  CR   80
Y  Y  Y  10.0   84  22.7  49  18.7500000  0.775  1  0.003  1  NR   81
N  N  Y   4.0  123  38.0  61  17.8947368  5.276  0  4.988  1  CR   82
Y  Y  Y   7.0  109  20.9  48  55.6250000  2.094  1  0.003  1  NR   83
Y  N  N   7.0  138   2.8  68   4.3478261  4.405  0  4.405  0  CR   84
Y  N  N   7.0  107  27.6  74  92.5000000  2.875  0  2.875  0  CR   85
N  Y  N   5.0  130  25.6  40   0.6622517  5.005  0  1.741  1  CR   86
E  N  N   5.0  124  38.4  65   0.0000000  4.433  0  4.433  0  CR   87
Y  N  Y   5.0  123   9.5  51  69.3333333  2.108  1  0.868  1  CR   88
N  N  N   5.0  132  18.1  58   9.8360656  4.526  0  4.526  0  CR   89
N  N  N   7.0  117  28.7  43  59.0551181  4.057  0  4.057  0  CR   90
E  N  Y   3.0  134  19.8  53  14.9532710  2.886  1  1.941  1  CR   91
N  N  N   4.0  137  23.2  47   0.0000000  2.916  0  2.916  0  CR   92
N  N  N   5.0  122  19.5  74   7.6271186  3.559  0  3.559  0  CR   93
N  Y  N   8.0  121  46.2  49  44.9367089  0.663  1  0.003  1  NR   94
N  Y  N   7.0  136  39.7  46   2.3121387  2.168  1  1.112  1  CR   95
N  N  Y   5.0  140  18.9  51  12.3287671  2.812  1  1.873  1  CR   96
E  N  N   4.0  141   8.5  47  28.8461538  4.183  0  4.183  0  CR   97
Y  Y  N   8.0  130  22.3  42  20.6896552  1.684  0  0.003  1  NR   98
N  N  N   7.0  124  26.5  44  11.8055556  4.408  0  4.408  0  CR   99
N  N  N   8.0  124  14.3  54  88.6792453  4.016  0  4.016  0  CR  100
E  Y  N   5.0  103  16.9  28  44.6540880  1.927  1  0.706  1  CR  101
Y  N  N   4.0  128   9.6  45  82.7160494  4.112  0  4.112  0  CR  102
N  N  N   4.0  128   9.4  61  28.1481481  3.833  0  3.833  0  CR  103
N  N  N   3.0  132  23.6  66   1.8750000  4.153  0  4.153  0  CR  104
N  N  N   5.0  133  21.2  65  51.3043478  3.775  0  3.775  0  CR  105
N  N  N   6.0  107  14.6  43  49.1891892  3.784  0  3.784  0  CR  106
Y  N  N   5.0  136  12.2  47  89.3939394  3.901  0  3.901  0  CR  107
E  N  N   4.0  127  12.9  46  51.8181818  3.606  0  3.606  0  CR  108
N  N  N   5.0  121  16.7  77  26.8292683  3.288  0  3.288  0  CR  109
;

data x;
  input ifp tumsize pelvicln $ Covariates$ 8-53;
  format pelvicln $node.;
  datalines;
  5 5 N IFP=5, Tumor size=5, Negative/Equivocal nodes
  5 5 Y IFP=5, Tumor size=5, Positive nodes
 20 5 N IFP=20, Tumor size=5, Negative/Equivocal nodes
 20 5 Y IFP=20, Tumor size=5, Positive nodes
  ;

***********************************************************
********* Fine and Gray's (1999) Regression Model *********
***********************************************************;
title "Modeling Subdistribution Hazards (Pintilie, 2006, pp 93-98)";

title2 "Failure of Interest: Local Relapse Only";
proc phreg data=hypoxia;
   model dftime*cens(0)=ifp / eventcode=1;
   run;

ods graphics on;
proc phreg data=hypoxia(keep=dftime cens ifp tumsize pelvicln)
     plot(overlay=stratum)=cif;
   class pelvicln;
   model dftime*cens(0)=ifp tumsize pelvicln / eventcode=1;
   baseline covariates=x out=base1 cif / row=Covariates seed=191;
   run;
title3 "Predicted Cumulative Incidence Functions";
proc print data=base1;
run;
title3;


title2 "Failure of Interest: Distance Relapse without Local Relapse";
proc phreg data=hypoxia;
   model dftime*cens(0)=ifp / eventcode=2;
run;

proc phreg data=hypoxia;
   class pelvicln;
   model dftime*cens(0)=ifp tumsize pelvicln / eventcode=2 covb;
   output out=out1 ressch=r_ifp r_tumsize r_pelnode;
   run;

data schoen;
   set out1;
   if (cens=2);
   keep dftime r_ifp r_tumsize r_pelnode;
run;
proc sort data=schoen; by dftime;run;
data res(drop=r_ifp r_tumsize r_pelnode);
   retain s_ifp s_tumsize s_pelnode;
   set schoen;
   by dftime;
   if first.dftime then do;
      s_ifp= r_ifp;
      s_tumsize= r_tumsize;
      s_pelnode= r_pelnode;
   end;
   else do;
      s_ifp= s_ifp + r_ifp;
      s_tumsize= s_tumsize + r_tumsize;
      s_pelnode= s_pelnode + r_pelnode;
   end;
   if last.dftime then output;
run;
title3 "Schoenfeld Residuals";
proc print data=res;
   id dftime;
run;
title3;

title2 "Failure of Interest: Distance Relapse";
proc phreg data=hypoxia(keep=dftime cens2 ifp tumsize pelvicln) ;
   class pelvicln;
   model dftime*cens2(0)=ifp tumsize pelvicln / eventcode=1;
run;



***********************************************************
****************** Cox's Regression Model *****************
***********************************************************;
title1 "Modeling Cause-Specific Hazards (Pintilie, 2006, pp 102-103)";


title2 "Failure of Interest: Local Lapse";
proc phreg data=hypoxia;
   class pelvicln;
   model dftime*cens(0,2)=ifp/ ties=efron;
run;
proc phreg data=hypoxia;
   class pelvicln;
   model dftime*cens(0,2)=ifp tumsize pelvicln / ties=efron;
run;


title2 "Failure of Interest: Distance  Lapse";
proc phreg data=hypoxia;
   class pelvicln;
   model dftime*cens2(0,2)=ifp/ ties=efron;
run;
proc phreg data=hypoxia;
   class pelvicln;
   model dftime*cens2(0,2)=ifp tumsize pelvicln / ties=efron;
run;
