/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: HPSPLGS1                                            */
/*   TITLE: Getting Started Example for PROC HPSPLIT            */
/*    DESC: Wine Cultivars                                      */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Classification Trees                                */
/*   PROCS: HPSPLIT                                             */
/*                                                              */
/* SUPPORT: Bob Rodriguez                                       */
/****************************************************************/

%let url = http://archive.ics.uci.edu/ml/machine-learning-databases;
data Wine;
   infile "&url/wine/wine.data" url delimiter=',';
   input Cultivar Alcohol Malic Ash Alkan Mg TotPhen
         Flav NFPhen Cyanins Color Hue ODRatio Proline;
   label Cultivar = "Cultivar"
         Alcohol  = "Alcohol"
         Malic    = "Malic Acid"
         Ash      = "Ash"
         Alkan    = "Alkalinity of Ash"
         Mg       = "Magnesium"
         TotPhen  = "Total Phenols"
         Flav     = "Flavonoids"
         NFPhen   = "Nonflavonoid Phenols"
         Cyanins  = "Proanthocyanins"
         Color    = "Color Intensity"
         Hue      = "Hue"
         ODRatio  = "OD280/OD315 of Diluted Wines"
         Proline  = "Proline";
run;

proc print data=Wine(obs=10); run;

ods graphics on;

proc hpsplit data=Wine seed=15533;
   class Cultivar;
   model Cultivar = Alcohol Malic Ash Alkan Mg TotPhen Flav
                    NFPhen Cyanins Color Hue ODRatio Proline;
   grow entropy;
   prune costcomplexity;
run;

proc hpsplit data=Wine seed=15533;
   class Cultivar;
   model Cultivar = Alcohol Malic Ash Alkan Mg TotPhen Flav
                    NFPhen Cyanins Color Hue ODRatio Proline;
   prune costcomplexity(leaves=3);
run;


