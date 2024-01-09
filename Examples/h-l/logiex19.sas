/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX19                                            */
/*   TITLE: Example 19 for PROC LOGISTIC                        */
/*    DESC: Goodness-of-Fit Tests and Calibration               */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binary response data                                */
/*   PROCS: LOGISTIC                                            */
/*    DATA: MROZ data set                                       */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 19: Goodness-of-Fit Tests and Calibration
*****************************************************************/

/*
The following data were originally published by Mroz (1987) and
downloaded from Woolridge (2002).  This data set is based on a
sample of 753 married white women. The dependent variable is a
discrete measure of labor force participation
(InLaborForce). Explanatory variables are the number of children
age 5 or younger (KidsLt6), the number of children ages 6 to 18
(KidsGe6), the woman's age (Age), the woman's years of schooling
(Education), wife's labor experience (Experience), square of
experience (SqExperience), and the family income excluding the
wife's wage (IncomeExcl).
*/

title 'Example 19: Goodness-of-Fit Tests and Calibration';

data Mroz;
   input InLaborForce IncomeExcl Education Experience
         SqExperience Age KidsLt6 KidsGe6 lWage;
   datalines;
1 10.91006    12 14  196   32  1   0   1.210154
1 19.49998    12 5   25    30  0   2   0.3285121
1 12.03991    12 15  225   35  1   3   1.514138
1 6.799996    12 6   36    34  0   3   0.0921233
1 20.10006    14 7   49    31  1   2   1.524272
1 9.859054    12 33  1089  54  0   0   1.55648
1 9.152048    16 11  121   37  0   2   2.12026
1 10.90004    12 35  1225  54  0   0   2.059634
1 17.305      12 24  576   48  0   2   0.7543364
1 12.925      12 21  441   39  0   2   1.544899
1 24.29995    12 15  225   33  0   1   1.401922
1 19.70007    11 14  196   42  0   1   1.524272
1 15.00001    12 0   0     30  1   2   0.7339532
1 14.6        12 14  196   43  0   2   0.8183691
1 24.63091    10 6   36    43  0   1   1.302831
1 17.53103    11 9   81    35  0   3   0.2980284
1 14.09998    12 20  400   43  0   2   1.16761
1 15.839      12 6   36    39  0   5   1.643839
1 14.1        12 23  529   45  0   0   0.6931472
1 10.29996    12 9   81    35  0   4   2.021932
1 22.65498    16 5   25    42  0   2   1.254248
1 8.090048    12 11  121   30  0   0   1.272958
1 17.479      13 18  324   48  0   0   1.178655
1 9.56        12 15  225   45  0   0   1.178655
1 8.274953    12 4   16    31  1   1   0.7675587
1 27.34999    17 21  441   43  0   2   1.331812
1 16          12 31  961   59  0   0   1.386294
1 16.99998    12 9   81    32  0   3   1.55327
1 15.10006    17 7   49    31  1   0   1.981815
1 15.69998    12 7   49    42  0   0   1.76936
1 5.11896     11 32  1024  50  0   0   0.4308079
1 16.75001    16 11  121   59  0   0   0.8997548
1 13.59993    13 16  256   36  0   2   1.76663
1 17.10005    12 14  196   51  0   1   1.272958
1 16.73405    16 27  729   45  0   3   1.336789
1 14.19698    11 0   0     42  0   1   0.9017048
1 10.31999    12 17  289   46  0   0   0.8651237
1 11.3841     10 28  784   46  0   1   1.511847
1 14.59408    14 24  576   51  0   0   1.726029
1 17.50044    17 11  121   30  0   0   2.683142
1 15.51       12 1   1     30  1   2   0.9852943
1 21.99998    12 14  196   57  0   0   1.365939
1 22.5        16 6   36    31  1   2   0.9450337
1 19.994      12 10  100   48  0   2   1.512376
1 14.13       12 6   36    30  0   3   0.6931472
1 5.000013    12 4   16    34  0   2   1.244788
1 21.1549     16 10  100   48  0   2   0.7011649
1 7.141946    12 22  484   45  0   0   1.519863
1 16.65007    12 16  256   51  0   0   0.8209686
1 6.352       12 6   36    30  0   2   0.9698315
1 27.31395    12 12  144   46  0   1   0.8285082
1 14.5        12 32  1024  58  0   0   0.0943096
1 16.25799    12 15  225   37  0   8   0.1625439
1 9.5         8  17  289   52  0   0   0.4700036
1 7.999956    10 34  1156  52  0   0   0.6292484
1 12.50003    16 9   81    31  0   0   1.39716
1 14.00003    14 37  1369  55  0   0   2.265444
1 20.80007    17 10  100   34  0   0   2.084541
1 19.38511    14 35  1225  55  0   0   1.525839
1 12.38699    12 6   36    39  0   2   0.7621601
1 28.5        14 19  361   40  0   3   1.481605
1 15.04991    12 10  100   43  0   4   1.262826
1 10.49998    8  11  121   48  0   0   0.9996756
1 11.81       12 15  225   47  0   0   1.832582
1 6.950073    12 12  144   41  0   4   2.479308
1 12.41997    8  12  144   36  0   0   1.279015
1 17.4        17 14  196   46  0   2   1.937936
1 15.5        12 11  121   34  0   0   1.070453
1 21.21704    12 9   81    41  0   3   1.123923
1 18          12 24  576   51  0   1   1.321756
1 11.89992    12 12  144   33  0   0   1.745
1 26.75196    12 13  169   52  0   0   1.301744
1 12.14996    9  29  841   58  0   0   1.641866
1 10.19999    10 11  121   34  2   4   2.10702
1 8.120015    12 13  169   31  0   1   1.467068
1 10.65996    12 19  361   48  0   1   1.605811
1 18.10001    12 2   4     32  0   2   -1.029739
1 8.599986    17 24  576   49  0   0   1.087686
1 13.665      15 9   81    32  2   2   0
1 32.34996    12 6   36    58  0   0   0.9382087
1 12.08501    6  22  484   50  0   0   -0.1505904
1 12.15       14 30  900   60  0   0   0
1 17.69502    12 10  100   50  0   1   1.073671
1 24.7        14 6   36    56  0   0   1.265848
1 2.133992    9  29  841   51  0   0   0.486369
1 20.95005    17 29  841   54  0   1   2.12026
1 10.50008    13 36  1296  59  0   0   1.129853
1 10.55       9  19  361   46  0   2   0.9932518
1 45.75       15 8   64    46  0   1   1.658628
1 13.63204    12 13  169   39  1   3   0.3474122
1 18.23894    12 16  256   44  0   2   1.568324
1 17.09       12 11  121   33  2   0   0.5108456
1 30.2349     12 15  225   33  1   2   0.1148454
1 28.7        12 6   36    48  0   2   -0.6931472
1 19.63       12 13  169   31  0   4   -0.3364523
1 12.82494    12 22  484   45  0   1   1.028226
1 23.8        12 24  576   45  0   1   1.580689
1 26.30003    13 2   4     32  0   2   0.5558946
1 20.69991    12 6   36    47  0   0   0.9014207
1 26          13 2   4     34  0   2   0.8843046
1 10.87702    12 2   4     37  0   1   0.4282046
1 25.61206    12 14  196   36  0   1   1.058415
1 20.98899    12 9   81    47  1   2   0.8783396
1 70.74993    16 11  121   48  0   1   1.654908
1 17.05       12 9   81    42  0   2   1.321756
1 21          13 6   36    33  0   3   0.3285121
1 8.12        11 19  361   46  0   0   1.386294
1 20.88599    12 26  676   47  0   3   1.172885
1 17.66892    12 19  361   44  0   1   1.224187
1 25.20003    12 3   9     36  0   4   0.2876571
1 14.24501    17 7   49    31  2   0   2.230262
1 14.3        14 28  784   55  0   0   1.504077
1 23.70001    16 13  169   45  0   1   1.531152
1 46          17 9   81    47  0   0   1.375158
1 42.9999     12 15  225   46  0   3   1.760269
1 14.749      11 20  400   49  0   0   -0.6931472
1 16.15005    12 29  841   49  0   0   1.406489
1 17.774      12 9   81    45  0   2   1.791759
1 91          17 1   1     38  1   3   1.299292
1 22.29993    10 8   64    47  0   0   1.351004
1 34.60001    13 19  361   54  0   3   1.016281
1 9.620002    11 23  529   41  0   0   1.075344
1 10.89995    12 3   9     43  0   2   1.478965
1 14.49994    16 13  169   31  1   1   1.689487
1 22.00002    17 8   64    47  0   0   2.288598
1 17.90008    12 17  289   35  0   2   -1.822631
1 23.67506    16 4   16    45  0   3   -0.9607652
1 11.79996    12 15  225   33  1   0   1.290994
1 16.14195    16 11  121   54  0   1   0.8648711
1 18.39997    8  7   49    35  0   4   1.540452
1 15.49995    12 0   0     31  1   2   0.6162121
1 17.324      12 0   0     55  0   0   1.648659
1 19.205      12 10  100   34  0   2   1.193498
1 21.30006    13 8   64    38  0   1   2.143976
1 23.56       11 2   4     45  0   1   0.7244036
1 20.85       12 4   16    47  0   1   0.9416075
1 26.15       12 6   36    39  0   2   0.7827594
1 17          14 18  324   36  1   0   1.832582
1 20.72       12 3   9     33  1   2   1.203963
1 17.00009    12 22  484   50  0   0   1.491645
1 16          12 33  1089  58  0   0   1.892133
1 19.50005    17 28  784   49  0   0   2.130895
1 12          14 23  529   41  0   2   1.480604
1 13.73191    12 27  729   51  0   1   0.8943313
1 27.19999    9  11  121   53  0   0   0.2025325
1 5.315       12 6   36    36  1   2   0.4855078
1 16          12 11  121   46  0   2   1.098612
1 27.87198    12 14  196   36  0   2   1.55327
1 40.00001    14 17  289   53  0   1   0.121598
1 15.90003    16 17  289   40  0   3   2.001804
1 27.49997    17 14  196   42  0   2   1.495037
1 17.02005    15 11  121   33  1   1   0.9052298
1 22.39494    12 7   49    43  0   3   0.6325476
1 11.1        16 8   64    31  1   0   1.386294
1 32.70001    17 6   36    47  0   0   2.102914
1 27.79996    17 8   64    54  0   0   1.959644
1 2.199994    12 4   16    33  1   3   0.5108456
1 19.72095    16 25  625   43  0   0   1.236924
1 9.999988    13 24  576   46  0   1   1.443313
1 13.19997    12 11  121   35  0   3   1.021659
1 12.70897    11 19  361   37  0   3   0.6361535
1 27.30005    16 9   81    37  0   2   1.616453
1 21.2        14 19  361   34  0   3   0.2231435
1 14.4        16 14  196   43  1   0   1.049807
1 20.57596    12 22  484   46  0   0   1.415052
1 12.49999    9  6   36    35  0   3   0.5753766
1 17.50022    17 23  529   46  0   0   2.606682
1 44.00004    14 15  225   46  0   0   1.517915
1 13.11895    12 6   36    43  0   2   0.7550416
1 14.00006    12 11  121   30  0   0   1.094972
1 9.645086    11 2   4     41  0   2   0.9421144
1 17.39705    12 22  484   54  0   1   1.724943
1 7.799889    12 10  100   31  0   1   1.031546
1 13.13398    10 14  196   44  0   0   0.4743691
1 25.6        12 12  144   32  0   1   0.8109302
1 13.90003    5  9   81    47  0   0   0.7092666
1 19.29794    17 13  169   46  0   1   1.710549
1 9.200016    11 18  324   37  0   0   0.4602689
1 37.99999    12 8   64    51  0   2   1.331812
1 44          12 11  121   49  0   1   1.098612
1 21.37202    14 9   81    36  0   4   2.157999
1 23.66802    11 9   81    39  0   1   1.437581
1 9           12 14  196   48  0   2   1.544899
1 25.19995    14 9   81    38  0   2   1.410597
1 21.22       12 2   4     40  0   2   3.218876
1 33.96991    10 12  144   39  1   5   0.9681619
1 17.07       16 15  225   37  0   0   1.791759
1 6.016024    13 11  121   49  0   1   1.68873
1 17.10001    12 7   49    33  0   3   -0.409172
1 8.237       12 9   81    30  0   0   0.2231435
1 13.30008    12 19  361   54  0   0   0.8221558
1 16.00002    11 11  121   39  0   4   1.241702
1 12.53999    12 8   64    43  0   3   1.427124
1 18.00004    9  13  169   31  0   3   1.497097
1 31.2        13 4   16    33  0   3   0.5596158
1 20.74991    12 7   49    40  0   3   1.300028
1 11.09992    12 19  361   36  0   1   1.88443
1 20.68       12 14  196   51  0   0   0.9555114
1 18.00001    13 14  196   44  0   1   1.582087
1 32.43007    16 3   9     42  0   3   1.755614
1 32.90003    12 9   81    40  0   1   1.513103
1 24.10001    16 7   49    34  1   1   2.251892
1 17.80039    17 7   49    30  0   0   2.364432
1 20.50002    12 14  196   54  0   0   0.1053505
1 10.4999     12 29  841   51  0   0   1.399729
1 10.43703    9  19  361   44  0   2   0.9884625
1 18.19499    12 14  196   43  0   1   1.090647
1 12.84508    12 16  256   34  0   1   1.154614
1 13.8        13 10  100   45  0   0   1.266948
1 22.2        12 12  144   39  0   0   2.885192
1 6.699941    12 24  576   50  0   0   1.22888
1 6.250016    12 6   36    52  0   0   1.203963
1 15.60001    12 9   81    41  0   2   1.35738
1 3.30001     10 14  196   59  0   0   0.8377236
1 3.670978    12 26  676   52  0   0   0.5369611
1 7.789997    16 7   49    46  0   0   0.7487238
1 18.27199    12 4   16    41  1   5   2.295873
1 10.95398    11 15  225   33  0   2   1.107803
1 13.49999    12 23  529   45  0   0   0.6208453
1 11.20001    10 1   1     36  1   2   -2.054164
1 20.99991    12 29  841   48  0   1   1.892012
1 25.7        12 9   81    47  0   1   1.729725
1 8.932994    12 6   36    45  0   0   0.4693784
1 19.15998    12 11  121   37  0   2   0.9808417
1 26.58999    16 17  289   46  0   4   2.069492
1 22.40001    17 6   36    43  0   3   1.675188
1 20.633      12 7   49    42  0   2   1.386294
1 28.20001    17 2   4     34  1   2   1.799215
1 28.8        12 24  576   52  0   0   1.832582
1 8.999997    12 4   16    37  0   3   1.090647
1 11.39994    12 11  121   37  0   1   1.443124
1 10.40001    8  25  625   52  0   0   1.25036
1 19.08006    12 11  121   30  1   0   1.602313
1 9.46604     13 2   4     31  0   1   1.018559
1 6.50006     12 19  361   38  0   1   1.297053
1 29.11701    12 7   49    43  0   3   1.685194
1 19.10302    8  2   4     49  0   1   -0.4209849
1 16.34997    12 20  400   55  0   0   1.562095
1 32.02502    17 10  100   38  0   2   2.146528
1 16.70006    17 19  361   52  0   0   2.347463
1 4.811038    12 17  289   48  0   0   0.9698315
1 24.62601    13 12  144   32  0   2   1.924146
1 17.40001    12 11  121   32  0   1   1.626728
1 13.02504    12 6   36    38  0   2   -0.0392607
1 19.00698    12 10  100   46  0   3   1.460149
1 14.03       12 4   16    40  0   3   1.955394
1 14.89991    9  2   4     31  0   4   0.9263599
1 25.00006    10 13  169   43  0   1   2.066192
1 10.70007    12 21  441   51  0   0   1.422843
1 24.25       16 9   81    30  1   0   2.101032
1 39.13997    13 4   16    52  0   0   2.261461
1 7.199973    8  2   4     30  1   5   0.7013138
1 31.811      16 19  361   51  0   0   2.031013
1 10.00005    13 4   16    31  0   2   1.162369
1 20.66       12 9   81    34  0   4   0.4700036
1 13.49998    11 14  196   49  0   0   1.410597
1 25.38       13 6   36    35  1   3   0.3930551
1 18.27498    12 24  576   53  1   0   1.290994
1 39.213      12 1   1     32  0   3   0
1 10.49994    10 13  169   38  0   3   0.9571255
1 34.857      12 3   9     54  0   0   0.5596158
1 28.502      17 10  100   47  0   1   1.568616
1 12.99996    15 16  256   45  0   1   1.710188
1 41.39991    16 9   81    47  0   1   1.410597
1 14.78       10 19  361   59  0   0   0.2231435
1 15.05       11 4   16    32  0   1   0.5108456
1 29.69998    12 10  100   45  0   1   1.332392
1 16.16502    12 5   25    40  0   4   0.8601859
1 25.20516    14 7   49    47  0   2   2.32278
1 14.2        16 3   9     36  1   2   1.919595
1 18.15897    14 38  1444  56  0   0   1.976107
1 28.98106    8  16  256   41  0   1   0.8954347
1 13.392      7  13  169   48  0   3   0.1812376
1 9.17502     12 1   1     36  1   2   0.4953058
1 27.03985    12 7   49    41  0   0   0.5777924
1 13.14995    14 15  225   41  0   0   1.078818
1 16.40007    12 10  100   36  0   3   1.603199
1 21.29999    12 2   4     37  0   3   0.6208453
1 17.20102    12 19  361   38  0   0   2.083894
1 8.560026    14 25  625   43  0   2   1.379169
1 6.49084     16 25  625   54  0   0   1.112384
1 12.49997    12 7   49    38  0   1   1.067122
1 27.00002    12 15  225   30  1   0   1.118807
1 53.50005    12 11  121   49  0   0   1.588541
1 52.49995    13 25  625   45  0   1   1.390311
1 38.39998    13 19  361   51  0   0   1.714806
1 13.89194    10 4   16    34  0   0   0.2010615
1 3.899993    12 14  196   34  0   2   0.987271
1 34.2        12 19  361   41  0   1   0.9835007
1 19.70008    12 18  324   49  0   1   2.233171
1 18.49995    12 14  196   32  0   0   1.143618
1 10.99998    14 11  121   32  0   0   -0.6113829
1 43.30001    17 4   16    32  0   2   2.153052
1 18.76001    10 29  841   47  0   0   1.299837
1 4.800096    9  21  441   39  0   1   0.8409204
1 21.5        12 24  576   49  0   0   1.058484
1 28.03994    12 19  361   37  0   3   1.152658
1 26          16 31  961   59  0   0   1.293576
1 27          12 28  784   50  0   0   1.832582
1 17.79969    17 15  225   32  0   1   2.32718
1 17.40195    12 27  729   46  0   0   1.166146
1 19.30999    17 13  169   43  0   2   2.034993
1 9.99998     11 4   16    37  0   3   0.6792511
1 11.17998    16 10  100   32  0   2   1.547137
1 18.85696    11 8   64    39  0   1   0.7530186
1 12.30002    13 4   16    34  0   2   0.8472836
1 13.67712    11 18  324   39  0   1   0.871126
1 9.559997    8  3   9     45  0   3   0.2282505
1 24.49998    11 11  121   50  0   0   0.0896578
1 23.15       12 8   64    40  0   1   1.321756
1 15.59088    10 10  100   30  0   1   1.196102
1 14.42092    17 33  1089  57  0   0   1.636119
1 17.45491    12 19  361   39  0   1   1.892012
1 9.800019    12 35  1225  53  0   0   1.518309
1 17.57446    17 21  441   48  0   1   2.472159
1 16.555      14 7   49    46  0   1   1.321756
1 13.29497    12 18  324   47  0   0   1.473641
1 11.844      12 4   16    43  0   1   1.369479
1 46.64506    12 12  144   47  0   0   1.203963
1 14.69999    12 16  256   47  0   1   1.198729
1 26.09008    12 14  196   47  0   0   1.27021
1 9.9         12 3   9     46  0   0   0.4700036
1 9.048026    9  1   1     34  0   4   0.7999817
1 30.75006    10 27  729   48  0   0   1.565946
1 8.49994     12 12  144   30  0   1   1.758978
1 22.24999    12 6   36    51  0   1   0.8580258
1 42.91       12 9   81    52  0   5   0.6931472
1 33.3        12 2   4     37  0   2   0.6418539
1 13.8199     12 6   36    32  0   2   1.63374
1 23.60001    17 9   81    36  0   2   1.703748
1 13.00007    12 16  256   35  0   2   1.844004
1 20.74994    17 22  484   45  0   0   1.966119
1 6.3         12 26  676   56  0   0   0.8649974
1 7.788925    10 11  121   40  0   2   0.9333052
1 10.47004    12 11  121   45  1   2   0.7792332
1 12          12 15  225   32  0   2   0.9555114
1 16.97992    12 13  169   45  0   0   1.316247
1 17.9        12 6   36    40  0   2   1.475906
1 15.53994    12 20  400   38  0   1   1.491397
1 9.883986    12 17  289   49  0   4   1.45575
1 28.59995    16 8   64    47  0   1   0.5108456
1 17.66001    13 13  169   52  0   0   1.180438
1 25.99992    13 15  225   34  0   1   1.688489
1 13.60201    12 14  196   44  0   2   0.7907275
1 15.8        16 14  196   36  0   3   1.401799
1 41.09999    17 6   36    50  0   0   -0.433556
1 10.77504    12 24  576   45  0   0   1.683172
1 9.000047    14 10  100   44  0   2   -1.766677
1 24.39899    12 2   4     57  0   2   3.155595
1 37.30009    17 9   81    35  0   0   2.259521
1 27.99995    12 23  529   46  0   0   1.306926
1 13.7        14 12  144   30  2   1   0.7984977
1 17.20994    12 8   64    42  0   3   0.5590442
1 14.00001    12 16  256   34  0   1   0.1479026
1 35.75502    17 10  100   45  0   2   1.944495
1 23.5        16 7   49    35  1   2   1.378338
1 31.99993    16 19  361   40  0   0   3.064745
1 17.15       12 2   4     32  0   1   -0.7419173
1 20.25002    9  9   81    54  0   0   0.7657004
1 5.485985    12 14  196   38  0   3   0.619393
1 25.07504    12 9   81    43  0   3   1.465452
1 18.21995    16 16  256   54  0   0   2.18926
1 26          14 7   49    39  0   3   1.021659
1 34.50007    12 6   36    37  0   1   0.9770095
1 12.4        12 22  484   46  0   2   0.9162908
1 10.78685    11 9   81    56  0   0   2.905096
1 16.32301    12 9   81    41  0   3   -0.1996712
1 30.5        16 14  196   45  0   1   0.6931472
1 51.29963    17 17  289   44  0   1   2.733393
1 33.04997    17 12  144   50  0   1   1.868335
1 34.75001    14 13  169   37  0   5   2.12026
1 16.40004    12 8   64    44  0   1   1.515193
1 19.70007    14 10  100   32  0   2   0.9146093
1 6.600003    12 16  256   34  1   1   1.499556
1 9.020008    10 1   1     32  0   2   0.8030772
1 10.40001    12 6   36    37  0   3   0.7280316
1 14.51999    13 4   16    44  0   1   0.51641
1 17.2        16 8   64    34  0   2   1.226448
1 43          12 4   16    33  1   3   0.9162908
1 13.87196    7  15  225   43  0   3   1.376471
1 -0.0290575  16 7   49    35  0   2   1.828975
1 16.76994    14 14  196   43  0   1   1.368283
1 7.8         12 16  256   34  0   0   1.064711
1 14.50006    10 15  225   36  0   3   1.406489
1 7.9         12 23  529   41  0   2   1.047319
1 79.80001    16 19  361   41  0   0   1.948093
1 7.17597     10 4   16    35  0   3   1.078001
1 17.50698    12 12  144   32  1   3   0.6539385
1 20.6        14 12  144   30  0   0   1.927892
1 18.55992    12 25  625   43  0   0   1.361028
1 9.3         6  14  196   54  0   0   0.6931472
1 5.120008    15 14  196   35  0   2   1.604687
1 14.50004    12 11  121   50  0   0   0.1839036
1 19.8        17 7   49    34  1   1   3.113515
1 18.29995    14 18  324   52  0   0   1.926829
1 33.99994    13 4   16    35  0   3   1.270126
1 11.62794    6  37  1369  55  0   0   0.6826927
1 11.80005    16 13  169   35  0   0   1.68107
1 39.09998    14 14  196   49  0   1   0.556296
1 18.43007    15 17  289   38  2   2   1.62822
1 21          14 5   25    42  0   2   0.9162908
1 59          8  2   4     48  0   1   1.341558
1 25.3        14 0   0     51  0   0   0
1 23.24899    12 3   9     43  0   2   1.122231
1 24.92809    12 21  441   43  0   1   0.5401708
1 14.78199    12 20  400   38  0   1   1.391506
1 18.90003    12 19  361   44  0   1   1.697174
1 21          12 4   16    36  1   3   3.218876
1 10.00001    12 19  361   38  0   0   0.8711678
1 29.30997    8  11  121   47  0   0   1.16733
1 13.14003    12 14  196   34  0   2   1.216988
1 25.08999    17 8   64    40  1   2   0.5753766
1 14.59993    12 13  169   31  0   1   1.151616
1 1.200001    12 24  576   46  0   0   0.9942513
1 32          14 1   1     36  0   3   0.5263249
1 16.11997    13 1   1     39  1   2   -1.543182
1 26.50002    17 3   9     36  0   2   1.912043
1 12.75006    8  4   16    37  0   4   0.5542873
1 12.9        12 21  441   39  0   4   0.9162908
1 10.69998    11 10  100   36  1   3   1.500939
1 14.43403    12 13  169   49  0   2   0.9446838
1 23.709      12 9   81    45  1   1   1.241269
1 15.1        17 14  196   32  2   0   1.564984
1 18.19998    10 2   4     36  0   5   0.8380265
1 22.64106    12 21  441   40  0   1   1.668857
1 21.64008    13 22  484   43  0   2   1.769429
1 23.99998    12 14  196   33  0   1   1.226448
1 16.00002    12 7   49    30  0   1   1.406489
0 21.025      12 2   4     49  0   1   .
0 23.6        16 5   25    30  2   0   .
0 22.8        12 12  144   30  1   0   .
0 35.91       12 1   1     41  0   4   .
0 21.7        12 12  144   45  0   1   .
0 21.823      12 4   16    43  0   5   .
0 31          13 9   81    42  0   1   .
0 15.3        12 9   81    60  0   0   .
0 12.925      12 6   36    57  0   0   .
0 15.83       10 5   25    38  0   2   .
0 30.2        12 5   25    56  0   0   .
0 16.6        12 8   64    32  0   3   .
0 11          7  2   4     49  0   1   .
0 15          12 6   36    55  0   0   .
0 20.528      9  0   0     36  1   1   .
0 13.126      12 3   9     44  0   3   .
0 15.55       10 7   49    44  0   1   .
0 18.01       14 3   9     35  1   2   .
0 18.874      14 10  100   44  2   3   .
0 24.8        12 3   9     45  0   1   .
0 17.5        12 2   4     34  1   0   .
0 16.15       17 12  144   30  2   0   .
0 15.189      8  15  225   39  0   1   .
0 6           12 5   25    36  0   2   .
0 37.25       17 4   16    38  0   2   .
0 27.76       12 10  100   53  0   0   .
0 9.09        12 1   1     36  0   2   .
0 14.5        12 8   64    32  1   1   .
0 19.7        9  20  400   51  0   3   .
0 16.788      11 4   16    38  0   0   .
0 18.52       12 7   49    33  2   0   .
0 20.95       12 10  100   54  0   0   .
0 7.574       9  3   9     38  0   3   .
0 10.027      11 5   25    30  2   2   .
0 5           12 10  100   34  2   3   .
0 7.04        9  0   0     34  0   1   .
0 40.8        12 3   9     50  0   2   .
0 16.05       17 10  100   30  2   0   .
0 33.1        12 2   4     38  0   2   .
0 33.856      14 10  100   54  0   0   .
0 20.5        12 4   16    30  1   2   .
0 28.6        12 0   0     55  0   0   .
0 18.75       10 10  100   51  0   1   .
0 20.3        12 5   25    44  0   1   .
0 13.42       12 0   0     53  0   0   .
0 18.4        10 0   0     42  0   2   .
0 16.682      12 19  361   38  0   2   .
0 32.685      13 2   4     38  1   3   .
0 7.05        12 12  144   41  1   4   .
0 10.867      8  5   25    35  0   3   .
0 18.22       12 5   25    33  1   2   .
0 26.613      13 5   25    48  0   0   .
0 25          12 10  100   47  0   0   .
0 15.7        12 0   0     34  0   5   .
0 40.25       13 4   16    33  2   1   .
0 73.6        13 3   9     31  3   1   .
0 10.592      8  2   4     58  0   0   .
0 8           12 1   1     49  0   0   .
0 13.4        8  0   0     55  0   1   .
0 23.7        14 1   1     44  0   0   .
0 18.9        9  1   1     44  0   0   .
0 48.3        16 6   36    36  0   3   .
0 24.47       12 12  144   38  0   3   .
0 28.63       16 6   36    37  0   3   .
0 25.32       12 9   81    47  0   0   .
0 13.53       12 14  196   47  0   3   .
0 14.8        12 13  169   32  1   1   .
0 17.4        12 8   64    43  1   2   .
0 15.98       11 0   0     42  1   4   .
0 16.576      12 1   1     56  0   0   .
0 21.85       13 3   9     38  0   5   .
0 14.6        12 13  169   52  0   2   .
0 21.6        12 3   9     50  0   0   .
0 24          16 8   64    33  0   0   .
0 20.883      16 8   64    44  0   2   .
0 19.5        12 18  324   41  0   1   .
0 42.8        12 2   4     45  0   1   .
0 41.5        14 3   9     53  0   0   .
0 18.965      14 5   25    53  0   0   .
0 16.1        12 2   4     42  0   1   .
0 14.7        13 10  100   32  2   0   .
0 18.8        12 30  900   56  0   0   .
0 14.75       11 1   1     37  1   3   .
0 21          12 5   25    40  1   2   .
0 35.4        15 8   64    54  0   3   .
0 10.7        7  0   0     53  0   0   .
0 24.5        12 4   16    48  0   1   .
0 17.045      12 2   4     36  1   2   .
0 18.8        12 30  900   57  0   0   .
0 14          12 25  625   51  0   0   .
0 18.214      13 3   9     33  0   4   .
0 20.177      12 20  400   52  0   0   .
0 8.3         10 20  400   56  0   0   .
0 14.2        12 0   0     36  1   2   .
0 21.768      14 15  225   36  1   0   .
0 29.553      12 10  100   46  0   1   .
0 4.35        10 4   16    31  0   3   .
0 24          11 3   9     52  0   0   .
0 18.3        12 10  100   46  0   2   .
0 17.2        12 9   81    35  2   0   .
0 16.476      12 7   49    59  0   0   .
0 13.4        8  12  144   36  0   1   .
0 44.988      7  0   0     51  1   3   .
0 18.2        16 16  256   31  1   0   .
0 28          14 4   16    31  0   2   .
0 11.55       12 7   49    32  1   1   .
0 28.45       16 7   49    35  1   2   .
0 15.096      12 14  196   40  0   3   .
0 8.009       10 2   4     33  1   2   .
0 10.04       7  20  400   54  0   0   .
0 16.7        12 5   25    36  1   1   .
0 8.4         10 10  100   50  0   1   .
0 13          8  20  400   54  0   0   .
0 17.97       11 10  100   48  0   1   .
0 18.45       15 8   64    41  0   4   .
0 31          12 11  121   50  0   4   .
0 24.135      12 3   9     46  0   2   .
0 31.7        13 6   36    42  0   1   .
0 10.19       9  4   16    31  1   2   .
0 21.574      12 4   16    53  0   0   .
0 26.68       12 9   81    51  0   1   .
0 17.7        12 10  100   47  0   1   .
0 29.4        12 3   9     50  0   1   .
0 22.159      6  2   4     37  0   1   .
0 35          12 2   4     30  2   2   .
0 8.63        12 0   0     49  0   0   .
0 17.08       12 8   64    52  0   2   .
0 32.5        12 6   36    47  0   2   .
0 16          12 15  225   49  0   0   .
0 18.85       12 15  225   44  0   4   .
0 17.5        8  9   81    53  0   0   .
0 19.392      12 8   64    30  1   0   .
0 14.45       12 18  324   54  0   2   .
0 21.8        7  3   9     47  1   1   .
0 7.7         15 10  100   56  0   0   .
0 31.8        12 6   36    49  0   1   .
0 17.258      6  20  400   48  0   0   .
0 13.399      12 8   64    49  0   1   .
0 16.073      12 3   9     56  0   1   .
0 23.26       12 4   16    46  0   0   .
0 37.3        12 13  169   45  0   2   .
0 11          12 4   16    32  0   2   .
0 13.075      12 17  289   43  1   1   .
0 13.7        12 4   16    34  1   1   .
0 25.1        12 0   0     30  1   1   .
0 18.6        17 15  225   38  2   0   .
0 29          16 11  121   33  1   1   .
0 19.237      12 23  529   52  0   0   .
0 19.855      11 1   1     43  0   3   .
0 9.45        12 5   25    33  1   1   .
0 30          10 1   1     45  0   0   .
0 15          10 5   25    36  2   1   .
0 24.701      12 3   9     34  1   1   .
0 15.9        14 3   9     37  0   2   .
0 16.24       10 19  361   46  0   1   .
0 21.1        12 20  400   47  0   0   .
0 23          16 5   25    31  2   1   .
0 6.34        5  0   0     57  0   0   .
0 42.25       12 3   9     30  1   1   .
0 14.694      12 3   9     30  0   0   .
0 21.417      12 7   49    44  0   3   .
0 20.2        13 7   49    53  0   0   .
0 12.09       8  1   1     51  0   0   .
0 24.76       12 13  169   39  1   3   .
0 23          8  0   0     52  0   0   .
0 19.365      8  0   0     46  0   4   .
0 5.55        12 12  144   47  0   5   .
0 68.035      8  0   0     52  0   2   .
0 29.3        12 5   25    45  0   2   .
0 18.5        11 45  2025  60  0   0   .
0 22.582      13 10  100   41  0   2   .
0 21.5        8  2   4     39  0   3   .
0 28.07       12 3   9     49  0   1   .
0 50.3        15 1   1     32  1   1   .
0 23.5        12 5   25    33  1   3   .
0 15.5        10 10  100   36  0   4   .
0 13.44       13 4   16    37  3   3   .
0 8.1         12 7   49    30  1   2   .
0 9.8         11 9   81    44  1   1   .
0 20.3        12 5   25    48  0   1   .
0 15          11 4   16    40  0   4   .
0 56.1        13 11  121   47  0   0   .
0 22.846      12 9   81    36  0   2   .
0 22.225      11 4   16    40  0   2   .
0 17.635      12 2   4     46  0   1   .
0 18.5        12 23  529   52  0   0   .
0 13.39       12 3   9     44  0   1   .
0 15.15       10 15  225   45  0   1   .
0 16.2        7  8   64    30  2   1   .
0 33.92       12 3   9     40  1   3   .
0 14          12 25  625   43  0   1   .
0 16.736      12 2   4     49  0   2   .
0 30.65       12 0   0     46  1   4   .
0 12.4        11 19  361   52  0   0   .
0 19.022      12 3   9     31  1   1   .
0 11.203      10 7   49    42  1   1   .
0 19.876      11 1   1     33  0   3   .
0 57          16 9   81    57  0   0   .
0 18.29       10 3   9     49  0   0   .
0 20.22       14 8   64    45  0   1   .
0 22.15       11 0   0     56  0   0   .
0 30.623      12 5   25    41  1   3   .
0 9.38        5  20  400   56  0   0   .
0 22          10 3   9     48  0   1   .
0 23.675      16 12  144   52  0   2   .
0 33.671      12 5   25    51  0   0   .
0 12.367      11 1   1     35  0   3   .
0 21.95       12 0   0     45  0   0   .
0 32          12 7   49    54  0   0   .
0 22.61       12 13  169   54  0   2   .
0 12.092      12 3   9     31  1   0   .
0 3.777       6  0   0     53  0   3   .
0 36          14 2   4     35  2   2   .
0 26.9        12 0   0     36  1   3   .
0 32.242      12 2   4     59  0   0   .
0 35.02       16 1   1     54  0   0   .
0 37.6        12 10  100   37  1   1   .
0 1.5         12 10  100   44  0   0   .
0 96          17 1   1     34  1   2   .
0 18.15       12 3   9     49  0   0   .
0 15.5        12 32  1024  49  0   0   .
0 14          9  0   0     60  0   0   .
0 14.756      12 7   49    51  0   0   .
0 22          12 5   25    30  1   1   .
0 24.466      12 2   4     47  0   2   .
0 24.4        12 5   25    36  0   4   .
0 24          12 3   9     35  1   3   .
0 15.5        12 25  625   58  0   0   .
0 30.8        14 0   0     41  1   3   .
0 10.66       10 3   9     51  0   1   .
0 13.35       12 10  100   47  0   0   .
0 10.09       9  10  100   45  1   2   .
0 55.6        14 7   49    60  0   0   .
0 25.7        16 5   25    30  1   1   .
0 29          11 15  225   55  0   0   .
0 7.286       12 1   1     32  1   2   .
0 37.752      12 5   25    36  0   2   .
0 13.072      12 9   81    55  0   0   .
0 7.044       12 18  324   47  0   0   .
0 18.2        12 1   1     47  0   1   .
0 27          11 0   0     37  0   1   .
0 30.3        12 6   36    50  0   2   .
0 12          12 1   1     30  0   3   .
0 31.5        17 2   4     48  0   1   .
0 27.092      10 15  225   43  0   2   .
0 20.968      11 25  625   48  1   0   .
0 27          14 1   1     41  1   2   .
0 11.225      12 0   0     50  0   0   .
0 37.7        8  0   0     58  0   0   .
0 28.2        13 0   0     38  0   5   .
0 34          12 8   64    37  0   1   .
0 63.2        16 22  484   50  0   0   .
0 7.5         8  5   25    42  0   4   .
0 17.41       9  10  100   37  1   3   .
0 51          16 1   1     41  0   2   .
0 12.916      12 1   1     31  0   2   .
0 21.9        12 6   36    51  0   0   .
0 17.64       12 4   16    36  1   2   .
0 20          15 6   36    54  0   0   .
0 15          12 0   0     49  0   0   .
0 14.06       9  1   1     48  1   1   .
0 15.825      9  3   9     42  0   2   .
0 16.51       12 15  225   41  1   2   .
0 13          16 33  1089  55  0   0   .
0 10          9  2   4     42  0   0   .
0 22          15 1   1     32  0   1   .
0 29.8        12 10  100   43  0   2   .
0 15          12 0   0     33  1   3   .
0 22.3        15 14  196   48  0   1   .
0 14.55       12 15  225   43  0   2   .
0 19.73       17 15  225   47  1   3   .
0 35          12 10  100   54  0   0   .
0 21.014      12 6   36    51  0   1   .
0 10.876      10 18  324   51  0   1   .
0 27.85       13 15  225   43  1   1   .
0 9.56        12 30  900   53  0   0   .
0 30.3        11 15  225   34  1   1   .
0 7.72        8  10  100   31  1   1   .
0 10.55       12 0   0     56  0   0   .
0 24.106      16 0   0     42  0   1   .
0 22.995      12 4   16    32  0   2   .
0 6           12 0   0     35  1   3   .
0 24.35       12 3   9     30  1   1   .
0 7.608       10 20  400   51  0   0   .
0 28.2        12 3   9     47  0   3   .
0 16.15       12 1   1     54  0   1   .
0 51.2        15 5   25    31  3   0   .
0 12.646      10 7   49    47  0   0   .
0 19          14 6   36    47  0   3   .
0 19          12 2   4     40  0   3   .
0 14.4        8  0   0     48  0   0   .
0 7.232       8  10  100   34  0   7   .
0 21.943      12 6   36    38  0   3   .
0 47.5        12 4   16    32  1   3   .
0 28.9        16 8   64    48  0   1   .
0 12.4        12 18  324   41  0   2   .
0 6.531       5  7   49    49  0   2   .
0 22.422      8  15  225   59  0   0   .
0 22.2        13 7   49    58  0   0   .
0 77          12 8   64    41  0   3   .
0 88          12 8   64    45  0   2   .
0 26.04       14 3   9     30  1   1   .
0 63.5        12 10  100   41  0   1   .
0 12.1        12 9   81    30  2   0   .
0 17.505      12 24  576   53  0   1   .
0 18          12 12  144   31  0   0   .
0 28.069      14 2   4     43  0   2   .
0 14          12 6   36    31  1   1   .
0 8.117       12 18  324   51  0   0   .
0 11.895      9  17  289   43  0   0   .
0 45.25       14 7   49    31  1   2   .
0 31.106      11 6   36    48  0   0   .
0 4           12 10  100   31  1   1   .
0 40.5        12 5   25    44  0   1   .
0 21.62       11 7   49    48  0   1   .
0 23.426      12 11  121   53  0   1   .
0 26          10 14  196   42  0   3   .
0 7.84        12 5   25    39  2   6   .
0 6.8         10 2   4     32  1   2   .
0 5.33        12 4   16    36  0   2   .
0 28.2        13 5   25    40  0   2   .
0 10          12 14  196   31  2   3   .
0 9.952       12 4   16    43  0   0   .
0 24.984      12 15  225   60  0   0   .
0 28.363      9  12  144   39  0   3   .
;

data Mroz;
   set Mroz;
   if (ranuni(3939)<.3) then InLaborForce2=.;
   else InLaborForce2=InLaborForce;
run;

ods graphics on;
proc logistic data=Mroz plots=calibration(clm showobs);
   model InLaborForce2 = IncomeExcl Education Experience
                         SqExperience Age KidsLt6 KidsGe6  / gof;
   id InLaborForce;
   output out=Scored xbeta=XBeta;
run;

proc logistic data=Scored(where=(InLaborForce2=.))
              plots=calibration(clm showobs);
   model InLaborForce = XBeta;
   test intercept = 0, XBeta = 1;
run;

