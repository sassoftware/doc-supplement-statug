 /***************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                */
 /*                                                             */
 /*    NAME: FACT2ORD                                           */
 /*   TITLE: Second Order Factor Analysis                       */
 /* PRODUCT: STAT                                               */
 /*  SYSTEM: ALL                                                */
 /*    KEYS: factor analysis, multivariate analysis             */
 /*   PROCS: FACTOR, PRINT, TRANSPOSE                           */
 /*    DATA:                                                    */
 /*                                                             */
  /*     REF:                                                    */
 /*    MISC:                                                    */
 /*                                                             */
 /***************************************************************/

data psych24(/* df=144 */ type=corr);
   title 'Twenty Four Psychological tests';
   title2 'pp. 123-124 of harman: modern factor analysis, 3rd ed';

   input _name_ $1-8 test1-test24;
   if _n_=2 then _type_='priors  ';
   else _type_='corr    ';
   if _n_=1 then _type_='n    ';
   label
         test1='visual perception'         test2='cubes'
         test3='paper form board'          test4='flags'
         test5='general information'       test6='paragraph comprehension'
         test7='sentence completion'       test8='word classification'
         test9='word meaning'              test10='addition'
         test11='code'                     test12='counting dots'
         test13='straight-curved capitals' test14='word recognition'
         test15='number recognition'       test16='figure recognition'
         test17='object - number'          test18='number - figure'
         test19='figure - word'            test20='deduction'
         test21='numerical puzzles'        test22='problem reasoning'
         test23='series completion'        test24='arithmetic problems';
   datalines;
             145     145     145     145     145
             145     145     145     145     145
             145     145     145     145     145
             145     145     145     145     145
             145     145     145     145
           0.756   0.568   0.544   0.922   0.808
           0.651   0.754   0.680   0.870   0.952
           0.712   0.937   0.889   0.648   0.507
           0.600   0.725   0.610   0.569   0.649
           0.784   0.787   0.931   0.836
test1      1.000   0.318   0.403   0.468   0.321
           0.335   0.304   0.332   0.326   0.116
           0.308   0.314   0.489   0.125   0.238
           0.414   0.176   0.368   0.270   0.365
           0.369   0.413   0.474   0.282
test2      0.318   1.000   0.317   0.230   0.285
           0.234   0.157   0.157   0.195   0.057
           0.150   0.145   0.239   0.103   0.131
           0.272   0.005   0.255   0.112   0.292
           0.306   0.232   0.348   0.211
test3      0.403   0.317   1.000   0.305   0.247
           0.268   0.223   0.382   0.184  -0.075
           0.091   0.140   0.321   0.177   0.065
           0.263   0.177   0.211   0.312   0.297
           0.165   0.250   0.383   0.203
test4      0.468   0.230   0.305   1.000   0.227
           0.327   0.335   0.391   0.325   0.099
           0.110   0.160   0.327   0.066   0.127
           0.322   0.187   0.251   0.137   0.339
           0.349   0.380   0.335   0.248
test5      0.321   0.285   0.247   0.227   1.000
           0.622   0.656   0.578   0.723   0.311
           0.344   0.215   0.344   0.280   0.229
           0.187   0.208   0.263   0.190   0.398
           0.318   0.441   0.435   0.420
test6      0.335   0.234   0.268   0.327   0.622
           1.000   0.722   0.527   0.714   0.203
           0.353   0.095   0.309   0.292   0.251
           0.291   0.273   0.167   0.251   0.435
           0.263   0.386   0.431   0.433
test7      0.304   0.157   0.223   0.335   0.656
           0.722   1.000   0.619   0.685   0.246
           0.232   0.181   0.345   0.236   0.172
           0.180   0.228   0.159   0.226   0.451
           0.314   0.396   0.405   0.437
test8      0.332   0.157   0.382   0.391   0.578
           0.527   0.619   1.000   0.532   0.285
           0.300   0.271   0.395   0.252   0.175
           0.296   0.255   0.250   0.274   0.427
           0.362   0.357   0.501   0.388
test9      0.326   0.195   0.184   0.325   0.723
           0.714   0.685   0.532   1.000   0.170
           0.280   0.113   0.280   0.260   0.248
           0.242   0.274   0.208   0.274   0.446
           0.266   0.483   0.504   0.424
test10     0.116   0.057  -0.075   0.099   0.311
           0.203   0.246   0.285   0.170   1.000
           0.484   0.585   0.408   0.172   0.154
           0.124   0.289   0.317   0.190   0.173
           0.405   0.160   0.262   0.531
test11     0.308   0.150   0.091   0.110   0.344
           0.353   0.232   0.300   0.280   0.484
           1.000   0.428   0.535   0.350   0.240
           0.314   0.362   0.350   0.290   0.202
           0.399   0.304   0.251   0.412
test12     0.314   0.145   0.140   0.160   0.215
           0.095   0.181   0.271   0.113   0.585
           0.428   1.000   0.512   0.131   0.173
           0.119   0.278   0.349   0.110   0.246
           0.355   0.193   0.350   0.414
test13     0.489   0.239   0.321   0.327   0.344
           0.309   0.345   0.395   0.280   0.408
           0.535   0.512   1.000   0.195   0.139
           0.281   0.194   0.323   0.263   0.241
           0.425   0.279   0.382   0.358
test14     0.125   0.103   0.177   0.066   0.280
           0.292   0.236   0.252   0.260   0.172
           0.350   0.131   0.195   1.000   0.370
           0.412   0.341   0.201   0.206   0.302
           0.183   0.243   0.242   0.304
test15     0.238   0.131   0.065   0.127   0.229
           0.251   0.172   0.175   0.248   0.154
           0.240   0.173   0.139   0.370   1.000
           0.325   0.345   0.334   0.192   0.272
           0.232   0.246   0.256   0.165
test16     0.414   0.272   0.263   0.322   0.187
           0.291   0.180   0.296   0.242   0.124
           0.314   0.119   0.281   0.412   0.325
           1.000   0.324   0.344   0.258   0.388
           0.348   0.283   0.360   0.262
test17     0.176   0.005   0.177   0.187   0.208
           0.273   0.228   0.255   0.274   0.289
           0.362   0.278   0.194   0.341   0.345
           0.324   1.000   0.448   0.324   0.262
           0.173   0.273   0.287   0.326
test18     0.368   0.255   0.211   0.251   0.263
           0.167   0.159   0.250   0.208   0.317
           0.350   0.349   0.323   0.201   0.334
           0.344   0.448   1.000   0.358   0.301
           0.357   0.317   0.272   0.405
test19     0.270   0.112   0.312   0.137   0.190
           0.251   0.226   0.274   0.274   0.190
           0.290   0.110   0.263   0.206   0.192
           0.258   0.324   0.358   1.0     0.167
           0.331   0.342   0.303   0.374
test20     0.365   0.292   0.297   0.339   0.398
           0.435   0.451   0.427   0.446   0.173
           0.202   0.246   0.241   0.302   0.272
           0.388   0.262   0.301   0.167   1.000
           0.413   0.463   0.509   0.366
test21     0.369   0.306   0.165   0.349   0.318
           0.263   0.314   0.362   0.266   0.405
           0.399   0.355   0.425   0.183   0.232
           0.348   0.173   0.357   0.331   0.413
           1.000   0.374   0.451   0.448
test22     0.413   0.232   0.250   0.380   0.441
           0.386   0.396   0.357   0.483   0.160
           0.304   0.193   0.279   0.243   0.246
           0.283   0.273   0.317   0.342   0.463
           0.374   1.000   0.503   0.375
test23     0.474   0.348   0.383   0.335   0.435
           0.431   0.405   0.501   0.504   0.262
           0.251   0.350   0.382   0.242   0.256
           0.360   0.287   0.272   0.303   0.509
           0.451   0.503   1.0     0.434
test24     0.282   0.211   0.203   0.248   0.420
           0.433   0.437   0.388   0.424   0.531
           0.412   0.414   0.358   0.304   0.165
           0.262   0.326   0.405   0.374   0.366
           0.448   0.375   0.434   1.000
;
run;

*-------------------FIRST ORDER FACTOR ANALYSIS-------------------;
* The method used in both analyses in this example is principal
  factor analysis, but any of the other factor extraction methods
  could also be used. The rotation method in the first analysis
  must be oblique;

proc factor n=5 priors=input rotate=hk outstat=stat;
   title3 'first order analysis';
run;

proc print;
   by _type_ notsorted;
   id _type_ _name_;
   title3 'output data set from first order analysis';
run;


*----------EXTRACT INTERFACTOR CORRELATIONS AND SET _TYPE_--------;
* factor names are also changed from 'factor..' to 'first_..' to
  avoid confusion;

data temp;
   set;
   if _type_='FCORR';
   _type_='CORR';
   substr(_name_,1,6)='first_';
run;

proc print;
   by _type_ notsorted;
   id _type_ _name_;
   title3 'temporary data set containing interfactor correlations';
run;


*-------CHANGE VARIABLE NAMES TO FACTOR NAMES: FIRST_1, ETC.------;
* Tanspose can be used because the interfactor correlation matrix
  is symmetric, so transposing it does not change it. All the
  observations with missing values will be ignored by factor.
  The data set type= option must be set either here or in the
  proc factor statement, otherwise proc factor will not realize
  the data set contains correlations;

proc transpose out=second(type=corr drop=_label_);
   id _name_;
   copy _type_ _name_;
run;

proc print;
   by _type_ notsorted;
   id _type_ _name_;
   title3   'interfactor correlations converted to a type=corr data set';
run;


*------------------SECOND ORDER FACTOR ANALYSIS-------------------;

proc factor corr priors=smc;
   title3 'second order analysis';
run;
