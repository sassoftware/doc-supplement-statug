/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: loessex3                                            */
/*   TITLE: Documentation Example 3 for PROC LOESS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Local Regression                                    */
/*   PROCS: LOESS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/
data Experiment;
   input Temperature Catalyst MeasuredYield;
   if ranuni(1) < 0.1
      then CorruptedYield = MeasuredYield + 10 * ranuni(1);
      else CorruptedYield = MeasuredYield;
   datalines;
 80    0.000     6.85601
 80    0.002     7.26355
 80    0.004     7.41448
 80    0.006     7.82640
 80    0.008     8.44204
 80    0.010     8.45239
 80    0.012     8.70607
 80    0.014     8.97274
 80    0.016     9.15395
 80    0.018     9.28224
 80    0.020     9.59752
 80    0.022     9.56851
 80    0.024     9.62627
 80    0.026     9.86399
 80    0.028     9.79364
 80    0.030     9.93268
 80    0.032     9.81482
 80    0.034     9.81741
 80    0.036     9.50789
 80    0.038     9.71788
 80    0.040     9.65169
 80    0.042     9.36858
 80    0.044     9.34950
 80    0.046     9.03065
 80    0.048     8.86428
 80    0.050     8.96405
 80    0.052     8.61824
 80    0.054     8.28759
 80    0.056     8.32988
 80    0.058     8.19932
 80    0.060     8.03286
 80    0.062     7.68868
 80    0.064     7.55529
 80    0.066     7.43059
 80    0.068     7.14750
 80    0.070     7.02783
 80    0.072     6.73280
 80    0.074     6.55818
 80    0.076     6.42067
 80    0.078     6.49039
 80    0.080     6.22599
 82    0.000     6.26173
 82    0.002     6.75029
 82    0.004     7.13305
 82    0.006     7.76355
 82    0.008     7.99605
 82    0.010     8.13294
 82    0.012     8.51652
 82    0.014     8.64410
 82    0.016     8.97600
 82    0.018     9.22960
 82    0.020     9.19322
 82    0.022     9.43364
 82    0.024     9.40902
 82    0.026     9.44993
 82    0.028     9.58280
 82    0.030     9.66778
 82    0.032     9.65395
 82    0.034     9.66427
 82    0.036     9.41483
 82    0.038     9.61874
 82    0.040     9.31958
 82    0.042     9.26881
 82    0.044     9.31388
 82    0.046     9.02321
 82    0.048     8.85707
 82    0.050     8.87958
 82    0.052     8.87415
 82    0.054     8.58891
 82    0.056     8.35854
 82    0.058     8.29338
 82    0.060     8.21175
 82    0.062     7.95078
 82    0.064     7.76264
 82    0.066     7.69762
 82    0.068     7.37929
 82    0.070     7.27376
 82    0.072     7.10862
 82    0.074     6.90903
 82    0.076     6.92943
 82    0.078     6.70950
 82    0.080     6.52256
 84    0.000     6.06037
 84    0.002     6.46585
 84    0.004     6.81400
 84    0.006     7.33322
 84    0.008     7.53020
 84    0.010     7.91188
 84    0.012     8.01805
 84    0.014     8.51995
 84    0.016     8.59733
 84    0.018     8.70642
 84    0.020     8.93509
 84    0.022     9.10880
 84    0.024     9.25190
 84    0.026     9.23317
 84    0.028     9.48806
 84    0.030     9.31164
 84    0.032     9.52914
 84    0.034     9.31545
 84    0.036     9.49316
 84    0.038     9.21151
 84    0.040     9.40908
 84    0.042     9.23990
 84    0.044     9.12483
 84    0.046     8.99241
 84    0.048     8.90217
 84    0.050     8.82322
 84    0.052     8.73569
 84    0.054     8.56755
 84    0.056     8.27027
 84    0.058     8.35114
 84    0.060     8.24862
 84    0.062     8.06142
 84    0.064     8.04670
 84    0.066     7.92165
 84    0.068     7.61113
 84    0.070     7.57568
 84    0.072     7.32662
 84    0.074     7.25779
 84    0.076     7.15606
 84    0.078     6.95156
 84    0.080     6.77234
 86    0.000     5.67518
 86    0.002     6.17379
 86    0.004     6.63671
 86    0.006     6.97501
 86    0.008     7.46863
 86    0.010     7.42898
 86    0.012     7.94103
 86    0.014     8.20712
 86    0.016     8.31117
 86    0.018     8.20294
 86    0.020     8.80592
 86    0.022     8.86682
 86    0.024     9.21925
 86    0.026     8.99192
 86    0.028     9.01230
 86    0.030     9.17340
 86    0.032     9.14446
 86    0.034     9.05556
 86    0.036     9.00018
 86    0.038     8.97113
 86    0.040     9.15364
 86    0.042     9.05892
 86    0.044     8.94286
 86    0.046     8.95075
 86    0.048     8.81630
 86    0.050     8.61975
 86    0.052     8.58172
 86    0.054     8.52381
 86    0.056     8.31203
 86    0.058     8.42970
 86    0.060     8.06209
 86    0.062     8.06825
 86    0.064     8.14816
 86    0.066     8.00643
 86    0.068     7.53998
 86    0.070     7.63209
 86    0.072     7.51301
 86    0.074     7.40521
 86    0.076     7.53176
 86    0.078     7.26778
 86    0.080     7.21988
 88    0.000     5.22485
 88    0.002     5.75603
 88    0.004     6.13767
 88    0.006     6.55551
 88    0.008     6.95175
 88    0.010     7.28165
 88    0.012     7.56807
 88    0.014     7.82485
 88    0.016     7.85799
 88    0.018     8.20388
 88    0.020     8.35506
 88    0.022     8.58987
 88    0.024     8.45625
 88    0.026     8.65500
 88    0.028     8.60348
 88    0.030     8.69495
 88    0.032     8.93597
 88    0.034     8.79999
 88    0.036     8.80655
 88    0.038     8.82928
 88    0.040     8.93919
 88    0.042     8.63911
 88    0.044     8.84401
 88    0.046     8.67236
 88    0.048     8.69773
 88    0.050     8.55577
 88    0.052     8.57683
 88    0.054     8.44339
 88    0.056     8.23501
 88    0.058     8.32762
 88    0.060     8.31905
 88    0.062     8.16028
 88    0.064     7.90469
 88    0.066     7.95608
 88    0.068     8.00775
 88    0.070     7.66058
 88    0.072     7.76934
 88    0.074     7.65117
 88    0.076     7.59078
 88    0.078     7.54839
 88    0.080     7.60691
 90    0.000     5.16649
 90    0.002     5.44609
 90    0.004     5.92646
 90    0.006     6.40226
 90    0.008     6.35284
 90    0.010     6.97888
 90    0.012     7.07171
 90    0.014     7.42367
 90    0.016     7.63298
 90    0.018     7.76622
 90    0.020     7.89244
 90    0.022     8.19737
 90    0.024     8.21636
 90    0.026     8.39427
 90    0.028     8.51005
 90    0.030     8.52113
 90    0.032     8.56883
 90    0.034     8.57467
 90    0.036     8.46817
 90    0.038     8.54862
 90    0.040     8.66137
 90    0.042     8.59049
 90    0.044     8.51692
 90    0.046     8.42994
 90    0.048     8.30959
 90    0.050     8.41555
 90    0.052     8.29840
 90    0.054     8.19606
 90    0.056     8.17643
 90    0.058     8.19109
 90    0.060     8.02081
 90    0.062     8.00941
 90    0.064     7.86422
 90    0.066     7.86571
 90    0.068     7.85095
 90    0.070     7.83305
 90    0.072     7.70246
 90    0.074     7.73733
 90    0.076     7.94531
 90    0.078     7.78762
 90    0.080     7.71956
 92    0.000     4.58344
 92    0.002     5.19300
 92    0.004     5.29193
 92    0.006     5.71869
 92    0.008     6.09843
 92    0.010     6.47568
 92    0.012     6.68684
 92    0.014     6.80011
 92    0.016     7.25625
 92    0.018     7.28646
 92    0.020     7.53660
 92    0.022     7.97016
 92    0.024     8.01791
 92    0.026     8.06612
 92    0.028     8.16866
 92    0.030     8.24858
 92    0.032     8.12566
 92    0.034     8.21216
 92    0.036     8.29255
 92    0.038     8.26711
 92    0.040     8.39577
 92    0.042     8.15597
 92    0.044     8.38774
 92    0.046     8.17745
 92    0.048     8.26579
 92    0.050     8.04954
 92    0.052     8.34880
 92    0.054     8.28418
 92    0.056     7.91483
 92    0.058     8.11423
 92    0.060     7.97692
 92    0.062     7.94265
 92    0.064     7.84848
 92    0.066     7.83694
 92    0.068     7.92697
 92    0.070     8.10472
 92    0.072     7.80900
 92    0.074     7.88779
 92    0.076     7.85381
 92    0.078     7.76268
 92    0.080     7.96582
 94    0.000     4.31132
 94    0.002     4.68574
 94    0.004     4.88171
 94    0.006     5.35033
 94    0.008     5.75230
 94    0.010     6.06558
 94    0.012     6.45267
 94    0.014     6.76527
 94    0.016     6.93468
 94    0.018     6.90618
 94    0.020     7.20513
 94    0.022     7.40729
 94    0.024     7.38935
 94    0.026     7.55972
 94    0.028     7.80518
 94    0.030     7.86723
 94    0.032     7.89629
 94    0.034     7.90357
 94    0.036     7.93746
 94    0.038     8.11154
 94    0.040     7.81842
 94    0.042     7.95733
 94    0.044     7.86988
 94    0.046     8.21853
 94    0.048     7.93951
 94    0.050     7.96901
 94    0.052     7.88895
 94    0.054     7.85519
 94    0.056     7.76002
 94    0.058     7.79098
 94    0.060     7.84761
 94    0.062     7.86976
 94    0.064     7.83063
 94    0.066     7.64316
 94    0.068     7.78456
 94    0.070     7.99245
 94    0.072     7.79487
 94    0.074     8.02519
 94    0.076     7.85782
 94    0.078     8.14508
 94    0.080     7.91149
 96    0.000     4.04005
 96    0.002     4.26857
 96    0.004     4.84066
 96    0.006     5.17152
 96    0.008     5.49237
 96    0.010     5.67088
 96    0.012     6.00757
 96    0.014     6.44121
 96    0.016     6.41182
 96    0.018     6.36245
 96    0.020     6.92685
 96    0.022     7.05784
 96    0.024     7.18165
 96    0.026     7.25771
 96    0.028     7.29124
 96    0.030     7.38777
 96    0.032     7.35862
 96    0.034     7.58385
 96    0.036     7.53608
 96    0.038     7.59304
 96    0.040     7.70861
 96    0.042     7.84806
 96    0.044     7.67094
 96    0.046     7.53859
 96    0.048     7.67699
 96    0.050     7.92315
 96    0.052     7.47659
 96    0.054     7.65813
 96    0.056     7.56644
 96    0.058     7.60564
 96    0.060     7.64725
 96    0.062     7.65108
 96    0.064     7.74088
 96    0.066     7.66116
 96    0.068     7.57666
 96    0.070     7.59458
 96    0.072     7.68836
 96    0.074     7.83415
 96    0.076     7.85876
 96    0.078     8.04787
 96    0.080     8.05279
 98    0.000     3.47307
 98    0.002     3.87881
 98    0.004     4.35608
 98    0.006     4.95762
 98    0.008     5.04726
 98    0.010     5.44877
 98    0.012     5.67041
 98    0.014     5.91511
 98    0.016     6.19191
 98    0.018     6.30724
 98    0.020     6.35058
 98    0.022     6.64744
 98    0.024     6.85174
 98    0.026     7.02856
 98    0.028     6.78734
 98    0.030     7.08577
 98    0.032     6.97927
 98    0.034     7.14637
 98    0.036     7.42542
 98    0.038     7.28473
 98    0.040     7.30339
 98    0.042     7.56836
 98    0.044     7.50435
 98    0.046     7.28137
 98    0.048     7.30367
 98    0.050     7.43137
 98    0.052     7.37380
 98    0.054     7.44250
 98    0.056     7.56021
 98    0.058     7.41011
 98    0.060     7.53008
 98    0.062     7.37549
 98    0.064     7.42365
 98    0.066     7.39662
 98    0.068     7.65810
 98    0.070     7.38330
 98    0.072     7.48278
 98    0.074     8.06999
 98    0.076     7.80674
 98    0.078     7.81472
 98    0.080     7.94737
100    0.000     3.09340
100    0.002     3.83681
100    0.004     4.05328
100    0.006     4.34970
100    0.008     4.68055
100    0.010     5.18645
100    0.012     5.25487
100    0.014     5.43028
100    0.016     5.84549
100    0.018     6.01892
100    0.020     6.02828
100    0.022     6.42303
100    0.024     6.28267
100    0.026     6.40180
100    0.028     6.59935
100    0.030     6.73453
100    0.032     6.64549
100    0.034     6.92574
100    0.036     6.89917
100    0.038     6.96008
100    0.040     7.04358
100    0.042     7.02914
100    0.044     6.80327
100    0.046     7.11186
100    0.048     7.06313
100    0.050     7.18268
100    0.052     7.07498
100    0.054     7.11069
100    0.056     7.15516
100    0.058     7.36666
100    0.060     7.34215
100    0.062     7.25614
100    0.064     7.33462
100    0.066     7.46886
100    0.068     7.45280
100    0.070     7.48278
100    0.072     7.80561
100    0.074     7.56555
100    0.076     7.68892
100    0.078     7.83733
100    0.080     7.88187
102    0.000     3.09184
102    0.002     3.56746
102    0.004     3.84322
102    0.006     4.25145
102    0.008     4.37129
102    0.010     4.59606
102    0.012     4.85958
102    0.014     5.03040
102    0.016     5.52288
102    0.018     5.67933
102    0.020     5.75309
102    0.022     6.02841
102    0.024     6.08804
102    0.026     6.17611
102    0.028     6.34337
102    0.030     6.19780
102    0.032     6.58308
102    0.034     6.47799
102    0.036     6.32603
102    0.038     6.39201
102    0.040     6.55985
102    0.042     6.62790
102    0.044     6.68382
102    0.046     6.67906
102    0.048     6.65316
102    0.050     6.65175
102    0.052     6.84266
102    0.054     6.76613
102    0.056     6.79556
102    0.058     6.83238
102    0.060     6.93710
102    0.062     7.03842
102    0.064     6.97622
102    0.066     7.20649
102    0.068     7.10752
102    0.070     7.34827
102    0.072     7.40654
102    0.074     7.40404
102    0.076     7.78185
102    0.078     7.67311
102    0.080     8.13309
104    0.000     2.83152
104    0.002     3.09729
104    0.004     3.39049
104    0.006     3.94635
104    0.008     4.16613
104    0.010     4.41713
104    0.012     4.56618
104    0.014     4.77288
104    0.016     5.06665
104    0.018     5.27645
104    0.020     5.46952
104    0.022     5.30061
104    0.024     5.82224
104    0.026     5.96161
104    0.028     5.90104
104    0.030     6.05607
104    0.032     6.26679
104    0.034     6.10207
104    0.036     6.06984
104    0.038     6.22393
104    0.040     6.22872
104    0.042     6.28398
104    0.044     6.33023
104    0.046     6.61885
104    0.048     6.29209
104    0.050     6.44770
104    0.052     6.46433
104    0.054     6.54478
104    0.056     6.36180
104    0.058     6.64509
104    0.060     6.50503
104    0.062     6.77499
104    0.064     6.64196
104    0.066     6.91794
104    0.068     7.01745
104    0.070     6.96981
104    0.072     7.13860
104    0.074     7.28093
104    0.076     7.58209
104    0.078     7.57858
104    0.080     7.83940
106    0.000     2.63578
106    0.002     2.74736
106    0.004     3.19257
106    0.006     3.40675
106    0.008     3.72811
106    0.010     4.09671
106    0.012     4.28899
106    0.014     4.53626
106    0.016     4.69764
106    0.018     4.85267
106    0.020     5.34584
106    0.022     5.14443
106    0.024     5.30887
106    0.026     5.30845
106    0.028     5.49121
106    0.030     5.52830
106    0.032     5.54778
106    0.034     5.66966
106    0.036     5.77701
106    0.038     5.94480
106    0.040     6.01208
106    0.042     6.16732
106    0.044     6.09950
106    0.046     6.10412
106    0.048     6.16791
106    0.050     6.04164
106    0.052     6.27600
106    0.054     6.29302
106    0.056     6.28125
106    0.058     6.44515
106    0.060     6.30427
106    0.062     6.50206
106    0.064     6.50871
106    0.066     6.90713
106    0.068     6.91546
106    0.070     6.93772
106    0.072     6.95722
106    0.074     7.25799
106    0.076     7.29572
106    0.078     7.65523
106    0.080     7.75282
108    0.000     2.31876
108    0.002     2.68563
108    0.004     3.27565
108    0.006     3.18665
108    0.008     3.45100
108    0.010     3.85733
108    0.012     4.14296
108    0.014     4.22424
108    0.016     4.36978
108    0.018     4.70134
108    0.020     4.58768
108    0.022     5.01872
108    0.024     5.04925
108    0.026     5.13379
108    0.028     5.27627
108    0.030     5.13126
108    0.032     5.33588
108    0.034     5.35022
108    0.036     5.53573
108    0.038     5.54248
108    0.040     5.52051
108    0.042     5.49345
108    0.044     5.74257
108    0.046     5.85190
108    0.048     5.68849
108    0.050     5.72769
108    0.052     5.91064
108    0.054     5.73370
108    0.056     6.01266
108    0.058     5.94820
108    0.060     5.86991
108    0.062     6.36642
108    0.064     6.22903
108    0.066     6.40429
108    0.068     6.62561
108    0.070     6.69681
108    0.072     6.76122
108    0.074     6.84319
108    0.076     7.07492
108    0.078     7.35109
108    0.080     7.70773
110    0.000     2.19417
110    0.002     2.53542
110    0.004     2.80198
110    0.006     3.04774
110    0.008     3.41791
110    0.010     3.62727
110    0.012     3.73038
110    0.014     4.15893
110    0.016     4.26414
110    0.018     4.17771
110    0.020     4.47306
110    0.022     4.64144
110    0.024     4.70073
110    0.026     4.84099
110    0.028     4.99762
110    0.030     4.82203
110    0.032     4.91603
110    0.034     4.99417
110    0.036     5.07261
110    0.038     5.12285
110    0.040     5.18462
110    0.042     5.25747
110    0.044     5.24892
110    0.046     5.22547
110    0.048     5.54985
110    0.050     5.50833
110    0.052     5.54430
110    0.054     5.84169
110    0.056     5.65565
110    0.058     5.79913
110    0.060     5.94975
110    0.062     5.86083
110    0.064     6.11943
110    0.066     6.02028
110    0.068     6.10547
110    0.070     6.55416
110    0.072     6.50723
110    0.074     6.61860
110    0.076     7.03160
110    0.078     7.21548
110    0.080     7.45471
112    0.000     2.07106
112    0.002     2.09053
112    0.004     2.65677
112    0.006     2.82178
112    0.008     3.19828
112    0.010     3.38315
112    0.012     3.59600
112    0.014     3.70893
112    0.016     4.09288
112    0.018     3.94627
112    0.020     4.19767
112    0.022     4.13826
112    0.024     4.35442
112    0.026     4.58183
112    0.028     4.41641
112    0.030     4.75652
112    0.032     4.72774
112    0.034     4.77083
112    0.036     4.58422
112    0.038     4.84227
112    0.040     4.76684
112    0.042     4.83284
112    0.044     4.99784
112    0.046     5.06606
112    0.048     5.12728
112    0.050     5.14668
112    0.052     5.13565
112    0.054     5.12062
112    0.056     5.35972
112    0.058     5.40483
112    0.060     5.54522
112    0.062     5.56222
112    0.064     5.71535
112    0.066     5.80512
112    0.068     5.91921
112    0.070     6.31690
112    0.072     6.26603
112    0.074     6.53092
112    0.076     6.66569
112    0.078     7.04307
112    0.080     7.31964
114    0.000     1.98088
114    0.002     2.37222
114    0.004     2.53404
114    0.006     2.70891
114    0.008     2.96738
114    0.010     3.26636
114    0.012     3.24977
114    0.014     3.49342
114    0.016     3.61987
114    0.018     3.88230
114    0.020     3.83748
114    0.022     4.13924
114    0.024     3.99506
114    0.026     4.19521
114    0.028     4.18305
114    0.030     4.27229
114    0.032     4.38089
114    0.034     4.38263
114    0.036     4.33212
114    0.038     4.63466
114    0.040     4.41693
114    0.042     4.51065
114    0.044     4.67473
114    0.046     4.57559
114    0.048     4.79137
114    0.050     4.80678
114    0.052     4.80949
114    0.054     4.81716
114    0.056     4.94533
114    0.058     5.11675
114    0.060     5.19397
114    0.062     5.25374
114    0.064     5.31569
114    0.066     5.47216
114    0.068     5.63567
114    0.070     5.89665
114    0.072     6.12742
114    0.074     6.27939
114    0.076     6.40182
114    0.078     6.72684
114    0.080     6.87438
116    0.000     1.83552
116    0.002     2.06320
116    0.004     2.47184
116    0.006     2.51050
116    0.008     2.89175
116    0.010     3.05734
116    0.012     3.11892
116    0.014     3.44923
116    0.016     3.43459
116    0.018     3.65196
116    0.020     3.69693
116    0.022     3.86521
116    0.024     3.79453
116    0.026     3.92068
116    0.028     3.91968
116    0.030     4.15554
116    0.032     4.13339
116    0.034     4.10595
116    0.036     4.29855
116    0.038     4.15178
116    0.040     4.13705
116    0.042     4.21174
116    0.044     4.37677
116    0.046     4.23167
116    0.048     4.41484
116    0.050     4.64491
116    0.052     4.60106
116    0.054     4.63751
116    0.056     4.74776
116    0.058     4.91217
116    0.060     4.77247
116    0.062     4.97367
116    0.064     5.22385
116    0.066     5.32976
116    0.068     5.56210
116    0.070     5.55263
116    0.072     5.85322
116    0.074     6.16075
116    0.076     6.20310
116    0.078     6.55867
116    0.080     6.76257
118    0.000     2.06360
118    0.002     2.48371
118    0.004     2.55840
118    0.006     2.65197
118    0.008     2.76144
118    0.010     3.19761
118    0.012     3.12835
118    0.014     3.17442
118    0.016     3.21374
118    0.018     3.52199
118    0.020     3.50123
118    0.022     3.59206
118    0.024     3.64895
118    0.026     3.76147
118    0.028     3.77859
118    0.030     3.86207
118    0.032     3.92271
118    0.034     4.02733
118    0.036     3.89008
118    0.038     3.96504
118    0.040     4.05219
118    0.042     4.03948
118    0.044     3.98402
118    0.046     4.16398
118    0.048     4.05266
118    0.050     4.26529
118    0.052     4.27522
118    0.054     4.32822
118    0.056     4.41456
118    0.058     4.53502
118    0.060     4.73704
118    0.062     4.75464
118    0.064     5.05375
118    0.066     5.07797
118    0.068     5.25258
118    0.070     5.44181
118    0.072     5.54105
118    0.074     5.81642
118    0.076     6.33166
118    0.078     6.35928
118    0.080     6.69007
120    0.000     2.14562
120    0.002     2.48730
120    0.004     2.41789
120    0.006     2.69940
120    0.008     2.95126
120    0.010     3.01307
120    0.012     3.10770
120    0.014     3.15610
120    0.016     3.33072
120    0.018     3.47181
120    0.020     3.56520
120    0.022     3.62934
120    0.024     3.57681
120    0.026     3.55575
120    0.028     3.77498
120    0.030     3.73768
120    0.032     3.61442
120    0.034     3.82951
120    0.036     3.63681
120    0.038     3.90688
120    0.040     3.79730
120    0.042     3.65795
120    0.044     3.73032
120    0.046     3.71036
120    0.048     3.88967
120    0.050     4.09146
120    0.052     4.03221
120    0.054     4.07742
120    0.056     4.21597
120    0.058     4.30033
120    0.060     4.24183
120    0.062     4.58010
120    0.064     4.83775
120    0.066     4.83897
120    0.068     5.00181
120    0.070     5.14465
120    0.072     5.57028
120    0.074     5.51710
120    0.076     5.81860
120    0.078     6.20656
120    0.080     6.50970
122    0.000     2.33630
122    0.002     2.41286
122    0.004     2.69073
122    0.006     2.69664
122    0.008     2.93068
122    0.010     3.10277
122    0.012     3.04622
122    0.014     3.10733
122    0.016     3.47175
122    0.018     3.38723
122    0.020     3.30204
122    0.022     3.30985
122    0.024     3.40904
122    0.026     3.42394
122    0.028     3.61322
122    0.030     3.46729
122    0.032     3.55570
122    0.034     3.53570
122    0.036     3.56297
122    0.038     3.47628
122    0.040     3.56714
122    0.042     3.70419
122    0.044     3.44454
122    0.046     3.56463
122    0.048     3.61384
122    0.050     3.74056
122    0.052     3.95316
122    0.054     3.88191
122    0.056     4.08545
122    0.058     4.02861
122    0.060     4.13842
122    0.062     4.22795
122    0.064     4.44828
122    0.066     4.79271
122    0.068     4.66198
122    0.070     4.92159
122    0.072     4.92629
122    0.074     5.39414
122    0.076     5.51080
122    0.078     5.88281
122    0.080     6.25285
124    0.000     2.28682
124    0.002     2.52503
124    0.004     2.87142
124    0.006     2.89228
124    0.008     3.14420
124    0.010     3.15778
124    0.012     3.10659
124    0.014     3.23390
124    0.016     3.19647
124    0.018     3.09727
124    0.020     3.42398
124    0.022     3.31409
124    0.024     3.36824
124    0.026     3.46387
124    0.028     3.67037
124    0.030     3.37404
124    0.032     3.39772
124    0.034     3.42737
124    0.036     3.41232
124    0.038     3.37822
124    0.040     3.50211
124    0.042     3.44712
124    0.044     3.41058
124    0.046     3.56592
124    0.048     3.61882
124    0.050     3.50428
124    0.052     3.34618
124    0.054     3.73913
124    0.056     3.67285
124    0.058     3.72791
124    0.060     3.93278
124    0.062     3.99161
124    0.064     4.08992
124    0.066     4.60262
124    0.068     4.55214
124    0.070     4.57691
124    0.072     4.89174
124    0.074     5.00825
124    0.076     5.29870
124    0.078     5.77014
124    0.080     6.10532
126    0.000     2.89456
126    0.002     2.98866
126    0.004     3.09513
126    0.006     3.33357
126    0.008     3.20603
126    0.010     3.13534
126    0.012     3.36427
126    0.014     3.42105
126    0.016     3.32625
126    0.018     3.40931
126    0.020     3.35340
126    0.022     3.45955
126    0.024     3.53583
126    0.026     3.26995
126    0.028     3.43726
126    0.030     3.26551
126    0.032     3.25026
126    0.034     3.32204
126    0.036     3.39750
126    0.038     3.30903
126    0.040     3.40392
126    0.042     3.18851
126    0.044     3.39515
126    0.046     3.41224
126    0.048     3.32913
126    0.050     3.40288
126    0.052     3.56218
126    0.054     3.39691
126    0.056     3.73705
126    0.058     3.79659
126    0.060     3.80293
126    0.062     4.01736
126    0.064     3.87132
126    0.066     4.29650
126    0.068     4.22698
126    0.070     4.71862
126    0.072     4.80596
126    0.074     4.97022
126    0.076     5.36578
126    0.078     5.61033
126    0.080     5.93654
128    0.000     2.99671
128    0.002     3.26851
128    0.004     3.39800
128    0.006     3.53383
128    0.008     3.30959
128    0.010     3.29392
128    0.012     3.44816
128    0.014     3.56781
128    0.016     3.62644
128    0.018     3.54778
128    0.020     3.55404
128    0.022     3.31655
128    0.024     3.30287
128    0.026     3.35277
128    0.028     3.25099
128    0.030     3.20356
128    0.032     3.28146
128    0.034     3.16472
128    0.036     3.47972
128    0.038     3.31627
128    0.040     3.20128
128    0.042     3.40199
128    0.044     3.15181
128    0.046     3.31889
128    0.048     3.32762
128    0.050     3.25615
128    0.052     3.27071
128    0.054     3.29145
128    0.056     3.60400
128    0.058     3.52245
128    0.060     3.68130
128    0.062     3.82842
128    0.064     3.86429
128    0.066     3.93799
128    0.068     4.05115
128    0.070     4.43472
128    0.072     4.45505
128    0.074     4.76387
128    0.076     5.11800
128    0.078     5.41771
128    0.080     5.81451
130    0.000     3.57228
130    0.002     3.58479
130    0.004     3.89138
130    0.006     3.65825
130    0.008     3.75167
130    0.010     3.68365
130    0.012     3.70812
130    0.014     3.73532
130    0.016     3.71472
130    0.018     3.68120
130    0.020     3.90079
130    0.022     3.55675
130    0.024     3.55584
130    0.026     3.59833
130    0.028     3.54804
130    0.030     3.57384
130    0.032     3.36557
130    0.034     3.35224
130    0.036     3.04510
130    0.038     3.26229
130    0.040     3.23983
130    0.042     3.15186
130    0.044     3.04358
130    0.046     3.19505
130    0.048     3.40920
130    0.050     3.23661
130    0.052     3.19833
130    0.054     3.38416
130    0.056     3.33300
130    0.058     3.36327
130    0.060     3.53491
130    0.062     3.68080
130    0.064     3.87457
130    0.066     3.90609
130    0.068     4.05232
130    0.070     4.34636
130    0.072     4.29836
130    0.074     4.74151
130    0.076     5.19386
130    0.078     5.44710
130    0.080     5.57332
132    0.000     4.26296
132    0.002     4.16737
132    0.004     4.07145
132    0.006     4.06626
132    0.008     4.15836
132    0.010     4.38469
132    0.012     4.13851
132    0.014     4.08464
132    0.016     3.98942
132    0.018     4.08371
132    0.020     4.03826
132    0.022     3.93078
132    0.024     3.96939
132    0.026     3.70792
132    0.028     3.64765
132    0.030     3.76184
132    0.032     3.56592
132    0.034     3.56044
132    0.036     3.40338
132    0.038     3.36308
132    0.040     3.12685
132    0.042     3.08222
132    0.044     3.33225
132    0.046     3.07021
132    0.048     3.09872
132    0.050     3.12012
132    0.052     3.12186
132    0.054     3.08735
132    0.056     3.09100
132    0.058     3.19371
132    0.060     3.35880
132    0.062     3.51652
132    0.064     3.89706
132    0.066     3.83417
132    0.068     3.92913
132    0.070     4.18723
132    0.072     4.48715
132    0.074     4.56023
132    0.076     4.96128
132    0.078     5.38586
132    0.080     5.65558
134    0.000     4.80792
134    0.002     4.63467
134    0.004     4.81936
134    0.006     4.43273
134    0.008     4.63889
134    0.010     4.73087
134    0.012     4.73929
134    0.014     4.31941
134    0.016     4.47671
134    0.018     4.31562
134    0.020     4.21523
134    0.022     4.10967
134    0.024     4.12639
134    0.026     3.90848
134    0.028     3.65859
134    0.030     3.77078
134    0.032     3.79278
134    0.034     3.60261
134    0.036     3.47302
134    0.038     3.31885
134    0.040     3.38429
134    0.042     3.36083
134    0.044     3.24590
134    0.046     3.20940
134    0.048     3.27837
134    0.050     3.16509
134    0.052     3.13229
134    0.054     3.26676
134    0.056     3.27961
134    0.058     3.31373
134    0.060     3.51740
134    0.062     3.52347
134    0.064     3.56869
134    0.066     3.85231
134    0.068     3.85259
134    0.070     4.29530
134    0.072     4.19933
134    0.074     4.45113
134    0.076     4.94715
134    0.078     5.17693
134    0.080     5.61553
136    0.000     5.46308
136    0.002     5.35366
136    0.004     5.44010
136    0.006     5.16794
136    0.008     5.13712
136    0.010     5.02684
136    0.012     5.03063
136    0.014     4.83947
136    0.016     4.87426
136    0.018     4.67162
136    0.020     4.51286
136    0.022     4.38564
136    0.024     4.33049
136    0.026     4.20722
136    0.028     4.13192
136    0.030     3.97736
136    0.032     4.06823
136    0.034     3.82937
136    0.036     3.87764
136    0.038     3.50500
136    0.040     3.51189
136    0.042     3.41803
136    0.044     3.61255
136    0.046     3.37218
136    0.048     3.24871
136    0.050     3.30348
136    0.052     3.18213
136    0.054     3.31965
136    0.056     3.31057
136    0.058     3.32683
136    0.060     3.49358
136    0.062     3.40340
136    0.064     3.66343
136    0.066     3.73950
136    0.068     3.95342
136    0.070     4.20109
136    0.072     4.47991
136    0.074     4.60285
136    0.076     5.03538
136    0.078     5.33408
136    0.080     5.66113
138    0.000     6.25862
138    0.002     6.05873
138    0.004     5.83009
138    0.006     5.98366
138    0.008     5.97851
138    0.010     5.76973
138    0.012     5.70691
138    0.014     5.52982
138    0.016     5.37084
138    0.018     5.01412
138    0.020     5.14995
138    0.022     5.00214
138    0.024     4.91069
138    0.026     4.76133
138    0.028     4.33338
138    0.030     4.34272
138    0.032     4.37454
138    0.034     4.19325
138    0.036     4.02455
138    0.038     3.84336
138    0.040     3.79621
138    0.042     3.53222
138    0.044     3.65755
138    0.046     3.37047
138    0.048     3.42798
138    0.050     3.34885
138    0.052     3.35314
138    0.054     3.49194
138    0.056     3.40325
138    0.058     3.60413
138    0.060     3.54998
138    0.062     3.63346
138    0.064     3.79162
138    0.066     3.80265
138    0.068     3.87538
138    0.070     4.27178
138    0.072     4.56626
138    0.074     4.85036
138    0.076     4.85880
138    0.078     5.23074
138    0.080     5.70308
140    0.000     7.05582
140    0.002     6.88270
140    0.004     6.85361
140    0.006     6.88807
140    0.008     6.55955
140    0.010     6.50261
140    0.012     6.29416
140    0.014     6.02609
140    0.016     5.89584
140    0.018     5.71621
140    0.020     5.54598
140    0.022     5.42531
140    0.024     5.11392
140    0.026     5.11109
140    0.028     4.91757
140    0.030     4.75956
140    0.032     4.68358
140    0.034     4.37932
140    0.036     4.47805
140    0.038     4.17780
140    0.040     3.99510
140    0.042     3.88260
140    0.044     3.85560
140    0.046     3.75629
140    0.048     3.85360
140    0.050     3.60654
140    0.052     3.71414
140    0.054     3.50687
140    0.056     3.44223
140    0.058     3.68534
140    0.060     3.77076
140    0.062     3.66212
140    0.064     3.89189
140    0.066     3.82011
140    0.068     4.09957
140    0.070     4.32566
140    0.072     4.38783
140    0.074     5.00703
140    0.076     5.02377
140    0.078     5.20562
140    0.080     5.49371
;
proc template;
   define statgraph gradientScatter;
      beginGraph;
         layout overlay;
            scatterPlot x=Catalyst y=Temperature /
                markercolorgradient = CorruptedYield
                markerattrs         = (symbol=circleFilled)
                colormodel          =  ThreeColorRamp
                name                =  "Yield";

            scatterPlot x=Catalyst y=Temperature /
                markerattrs         = (symbol=circle);

            continuousLegend "Yield" / title= "CorruptedYield";
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=Experiment template=gradientScatter;
run;
ods graphics on;

proc loess data=Experiment;
   model MeasuredYield = Temperature Catalyst / scale=sd(0.1);
run;
proc loess data=Experiment;
   model CorruptedYield = Temperature Catalyst /
                 scale=sd(0.1) smooth=0.018;
run;
proc loess data=Experiment;
   model CorruptedYield = Temperature Catalyst /
                             scale  = sd(0.1)
                             smooth = 0.018
                             iterations=4;
run;
proc loess data=Experiment plots=contourFit(obs=none);
   model CorruptedYield = Temperature Catalyst /
                            scale  = sd(0.1)
                            smooth = 0.018
                            iterations=4;
run;

ods graphics off;
