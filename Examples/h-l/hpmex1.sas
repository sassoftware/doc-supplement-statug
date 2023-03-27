/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: HPMEX1                                              */
/*   TITLE: Example 1 for PROC HPMIXED                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Random-Effect Coefficient                           */
/*          Rank the predicted values                           */
/*   PROCS: HPMIXED                                             */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Tianlin Wang                                        */
/*     REF: PROC HPMIXED, EXAMPLE 1.                            */
/*    MISC:                                                     */
/****************************************************************/

%let NFarm = 15;
%let NAnimal = %eval(&NFarm*100);
data Sim;
   keep Species Farm Animal Yield;
   array BV{&NAnimal};
   array AnimalSpecies{&NAnimal};
   array AnimalFarm{&NAnimal};
   do i = 1 to &NAnimal;
      BV           {i} = sqrt(4.0)*rannor(12345);
      AnimalSpecies{i} = 1 + int(   5  *ranuni(12345));
      AnimalFarm   {i} = 1 + int(&NFarm*ranuni(12345));
   end;
   do i = 1 to 40*&NAnimal;
      Animal  = 1 + int(&NAnimal*ranuni(12345));
      Species = AnimalSpecies{Animal};
      Farm    = AnimalFarm   {Animal};
      Yield   = 1 + Species
                  + Farm
                  + BV{Animal}
                  + sqrt(8.0)*rannor(12345);
      output;
   end;
run;

ods exclude all;
proc hpmixed data=Sim;
   class Species Farm Animal;
   model Yield = Species Farm*Species;
   random Animal/cl;
   ods output SolutionR=EBV;
run;
ods exclude none;

proc sort data=EBV;
   by descending estimate;
run;
proc print data=EBV(obs=10) noobs;
   var Animal Estimate StdErrPred Lower Upper;
run;

/* lmr6850 (NSpecies,NAnimalPerFarm)=(10,500), TopTime=600 */
data Times;
   input PROC $ NFarm Time @@;
   label Time    = "Run-time";
   NAnimals       = 500*NFarm;
   label NAnimals = "Number of animals";
   datalines;
GLIMMIX  2    2.45  GLIMMIX  3    3.72  GLIMMIX  4    5.47
GLIMMIX  5    7.17  GLIMMIX  6    9.44  GLIMMIX  7   11.70
GLIMMIX  8   15.08  GLIMMIX  9   17.45  GLIMMIX 10   21.31
GLIMMIX 11   25.28  GLIMMIX 12   35.06  GLIMMIX 13   40.42
GLIMMIX 14   48.14  GLIMMIX 15   57.23  GLIMMIX 16   66.37
GLIMMIX 17   79.52  GLIMMIX 18   92.56  GLIMMIX 19  108.23
GLIMMIX 20  125.92  GLIMMIX 21  146.11  GLIMMIX 22  169.56
GLIMMIX 23  196.17  GLIMMIX 24  236.00  GLIMMIX 25  263.81
GLIMMIX 26  294.84  GLIMMIX 27  348.93  GLIMMIX 28  385.80
GLIMMIX 29  472.26  GLIMMIX 30  538.34  GLIMMIX 31  614.26
GLIMMIX 32  692.90  GLIMMIX 33  778.63
HPMIXED  2    1.06  HPMIXED  3    1.34  HPMIXED  4    1.94
HPMIXED  5    2.61  HPMIXED  6    3.53  HPMIXED  7    4.25
HPMIXED  8    5.30  HPMIXED  9    6.33  HPMIXED 10    7.03
HPMIXED 11    8.41  HPMIXED 12   10.59  HPMIXED 13   11.86
HPMIXED 14   12.66  HPMIXED 15   14.39  HPMIXED 16   18.11
HPMIXED 17   18.20  HPMIXED 18   20.97  HPMIXED 19   22.95
HPMIXED 20   24.94  HPMIXED 21   31.28  HPMIXED 22   30.70
HPMIXED 23   37.89  HPMIXED 24   42.80  HPMIXED 25   33.64
HPMIXED 26   39.92  HPMIXED 27   43.02  HPMIXED 28   49.72
HPMIXED 29   46.89  HPMIXED 30   79.95  HPMIXED 31   67.44
HPMIXED 32   76.41  HPMIXED 33   80.50  HPMIXED 34   84.94
HPMIXED 35   78.95  HPMIXED 36  101.33  HPMIXED 37   91.75
HPMIXED 38   87.03  HPMIXED 39  103.06  HPMIXED 40  140.19
HPMIXED 41  114.15  HPMIXED 42  170.87  HPMIXED 43  218.05
HPMIXED 44  118.48  HPMIXED 45  139.44  HPMIXED 46  137.48
HPMIXED 47  150.33  HPMIXED 48  187.83  HPMIXED 49  181.37
HPMIXED 50  182.37  HPMIXED 51  190.39  HPMIXED 52  236.62
HPMIXED 53  289.95  HPMIXED 54  211.98  HPMIXED 55  458.26
HPMIXED 56  234.11  HPMIXED 57  249.34  HPMIXED 58  248.59
HPMIXED 59  322.19  HPMIXED 60  337.28  HPMIXED 61  303.97
HPMIXED 62  356.14  HPMIXED 63  329.00  HPMIXED 64  842.98
HPMIXED 65  486.47  HPMIXED 66  429.75  HPMIXED 67  315.54
HPMIXED 68  539.78  HPMIXED 69  381.81  HPMIXED 70  723.11
HPMIXED 71  815.46
MIXED    2    2.30  MIXED    3    4.28  MIXED    4    7.05
MIXED    5   11.11  MIXED    6   17.23  MIXED    7   24.36
MIXED    8   31.48  MIXED    9   42.87  MIXED   10   59.64
MIXED   11   69.44  MIXED   12   90.20  MIXED   13  326.73
MIXED   14  671.67  MIXED   15  854.51  MIXED   16 1167.81
;

proc sgplot data=Times;
   yaxis max=600 display=(novalues noticks);
   xaxis max=20000;
   loess y=Time x=NAnimals / group=PROC nomarkers
                             interpolation=cubic smooth=0.5;
run;

/* lmr6850 (NFarm,NAnimalPerFarm)=(15,100), TopTime=60 */
data Times;
   input PROC $ NX Time @@;
   label NX   = "Number of covariates";
   label Time = "Run-time";
   datalines;
GLIMMIX   5  2.9540  GLIMMIX  10  3.2810  GLIMMIX  15  3.6560
GLIMMIX  20  3.9840  GLIMMIX  25  4.3590  GLIMMIX  30  4.8120
GLIMMIX  35  5.1400  GLIMMIX  40  5.7190  GLIMMIX  45  6.1410
GLIMMIX  50  6.4060  GLIMMIX  55  6.7340  GLIMMIX  60  7.2810
GLIMMIX  65  7.7340  GLIMMIX  70  8.1870  GLIMMIX  75  8.6090
GLIMMIX  80  9.1250  GLIMMIX  85  9.8120  GLIMMIX  90 10.1400
GLIMMIX  95 10.6400  GLIMMIX 100 11.3130  GLIMMIX 105 11.8750
GLIMMIX 110 12.3910  GLIMMIX 115 13.0930  GLIMMIX 120 14.0460
GLIMMIX 125 14.2810  GLIMMIX 130 15.9680  GLIMMIX 135 15.7190
GLIMMIX 140 16.4530  GLIMMIX 145 17.0470  GLIMMIX 150 17.7340
GLIMMIX 155 18.2180  GLIMMIX 160 19.1720  GLIMMIX 165 20.0630
GLIMMIX 170 20.6400  GLIMMIX 175 21.6250  GLIMMIX 180 22.8910
GLIMMIX 185 23.6400  GLIMMIX 190 24.2180  GLIMMIX 195 25.7190
GLIMMIX 200 26.5310  GLIMMIX 205 27.6880  GLIMMIX 210 28.5310
GLIMMIX 215 34.7030  GLIMMIX 220 31.1250  GLIMMIX 225 32.3270
HPMIXED   5  1.6400  HPMIXED  10  2.8120  HPMIXED  15  4.5940
HPMIXED  20  6.7650  HPMIXED  25  9.5780  HPMIXED  30 17.3440
HPMIXED  35 37.8740  HPMIXED  40 55.5460  HPMIXED  45 73.7810
MIXED     5  1.6720  MIXED    10  1.9530  MIXED    15  2.3900
MIXED    20  2.8430  MIXED    25  3.2810  MIXED    30  3.7500
MIXED    35  4.2500  MIXED    40  4.9220  MIXED    45  5.4690
MIXED    50  6.1250  MIXED    55  6.8600  MIXED    60  7.5310
MIXED    65  8.3600  MIXED    70  9.3750  MIXED    75 10.3600
MIXED    80 11.4060  MIXED    85 12.8900  MIXED    90 13.3440
MIXED    95 14.5620  MIXED   100 15.7650  MIXED   105 17.0620
MIXED   110 18.3590  MIXED   115 19.8440  MIXED   120 22.2490
MIXED   125 22.7030  MIXED   130 24.1560  MIXED   135 26.6410
MIXED   140 27.7180  MIXED   145 29.7350  MIXED   150 30.9370
MIXED   155 32.9370
;

proc sgplot data=Times;
   yaxis max=30 display=(novalues noticks);
   loess y=Time x=NX / group=PROC nomarkers
                       interpolation=cubic smooth=0.5;
run;

