/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: qrsex2                                              */
/*   TITLE: Example 2 for PROC QUANTSELECT                      */
/*    DESC: Econometric Growth                                  */
/*     REF: Barro and Lee (1994)                                */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Quantile Regression Model Selection                 */
/*   PROCS: QUANTSELECT                                         */
/*                                                              */
/****************************************************************/

data growth;
   length Country$ 22;
   input Country GDPR lgdp2 mse2 fse2 fhe2 mhe2 lexp2 lintr2 gedy2
         Iy2 gcony2 lblakp2 pol2 ttrad2 @@;
   if(index(country,'75')) then period='65-75';
   if(index(country,'85')) then period='75-85';
   datalines;
Algeria75              .0415 7.330 .1320 .0670 .0050 .0220 3.880 .1138 .0382
                       .1898 .0601 .3823 .0833 .1001
Algeria85              .0244 7.745 .2760 .0740 .0070 .0370 3.978 -.107 .0437
                       .3057 .0850 .9386 .0000 .0657
Argentina75            .0187 8.220 .7850 .6200 .0740 .1660 4.181 .4060 .0221
                       .1505 .0596 .1924 .3575 -.011
Argentina85            -.014 8.407 .9360 .9020 .1320 .2030 4.211 .1914 .0243
                       .1467 .0314 .3085 .7010 -.052
Australia75            .0259 9.101 2.541 2.353 .0880 .2070 4.263 6.937 .0348
                       .3272 .0257 .0000 .0080 -.016
Australia85            .0162 9.360 3.061 2.720 .2990 1.011 4.274 8.794 .0490
                       .2962 .0328 .0000 .0000 -.032
Austria75              .0378 8.725 1.087 .5100 .0290 .1620 4.237 .9234 .0355
                       .2967 .0791 .0000 .0000 .0015
Austria85              .0218 9.103 3.521 1.776 .0490 .1910 4.257 5.215 .0484
                       .2786 .0670 .0000 .0000 -.011
Bangladesh85           .0133 6.884 .4880 .0510 .0030 .0550 3.811 1.368 .0106
                       .0374 .2763 .6405 .6507 .0169
Barbados85             .0145 8.592 2.833 3.697 .0390 .1000 4.240 4.350 .0533
                       .1443 .0558 .0811 .0000 -.118
Belgium75              .0356 8.833 1.724 1.398 .0950 .2380 4.257 3.376 .0445
                       .2852 .0372 .0000 .0000 -.001
Belgium85              .0146 9.189 2.161 1.794 .1720 .3590 4.265 3.962 .0579
                       .2416 .0289 .0000 .0000 -.010
Benin85                .0010 6.962 .1190 .0420 .0030 .0100 3.798 1.550 .0456
                       .0623 .1516 .0105 .0500 -.021
Bolivia75              .0310 7.174 1.683 .9690 .1010 .1490 3.770 -.340 .0317
                       .2409 .1163 .2209 .6973 .0158
Bolivia85              -.005 7.484 1.473 .8620 .1120 .2280 3.842 -.080 .0313
                       .1857 .1369 .4334 .1500 .0160
Botswana85             .0512 7.208 .1930 .0980 .0110 .0290 3.924 .8876 .0525
                       .2750 .1636 .2826 .0000 -.018
Brazil75               .0637 7.513 .6740 .5150 .0270 .0950 4.022 .0016 .0171
                       .2217 .0646 .0879 .0011 -.017
Brazil85               .0132 8.150 .6450 .5480 .1050 .1840 4.091 -.254 .0200
                       .2212 .0585 .2670 .0000 -.043
Cameroon75             .0242 6.592 .4390 .0890 .0040 .0130 3.789 .8171 .0268
                       .0663 .1255 .0436 .0000 .0140
Cameroon85             .0433 6.834 .3930 .0850 .0030 .0170 3.920 1.446 .0227
                       .1075 .1237 .0105 .0000 .0048
Canada75               .0346 9.076 2.478 2.667 .3750 .4730 4.268 8.168 .0612
                       .2542 .0350 .0000 .0047 .0146
Canada85               .0240 9.421 3.363 3.386 .6930 .8810 4.290 11.28 .0680
                       .2599 .0315 .0000 .0000 -.013
Central_African_Rep.75 .0071 6.433 .1760 .0170 .0050 .0150 3.684 1.406 .0386
                       .1018 .2772 .0436 .1000 -.002
Central_African_Rep.85 -.011 6.504 .1590 .0220 .0030 .0110 3.766 2.546 .0383
                       .0513 .1831 .0105 .1000 .0269
Chile75                -.012 8.091 1.126 1.138 .0600 .1270 4.064 .7998 .0370
                       .1538 .1269 1.035 .1755 -.032
Chile85                .0111 7.972 1.222 1.445 .1300 .2250 4.153 .3037 .0360
                       .1282 .1159 .1334 .5642 -.050
Colombia75             .0314 7.485 .6950 .4500 .0140 .0690 3.996 -.005 .0150
                       .1741 .0621 .1934 .0000 .0021
Colombia85             .0171 7.799 1.143 1.013 .0610 .1640 4.091 .0406 .0220
                       .1758 .0638 .0407 .5062 .0130
Congo75                .0464 6.938 .7480 .3240 .0520 .1400 3.875 .0853 .0489
                       .1310 .2429 .0436 .3385 .0161
Congo85                .0437 7.402 .6940 .2850 .0370 .1270 3.955 .2875 .0630
                       .1219 .2426 .0105 .1185 .0533
Costa_Rica75           .0293 7.772 .4530 .4240 .0950 .1140 4.143 -.030 .0502
                       .1688 .1240 .2507 .0000 -.027
Costa_Rica85           .0023 8.066 .7580 .6900 .1830 .2070 4.220 -.023 .0534
                       .1864 .1369 .2093 .0000 -.009
Cyprus75               .0147 7.914 1.281 .7430 .0530 .1260 4.237 .5506 .0293
                       .3289 .0686 .0492 .3270 .0021
Cyprus85               .0709 8.061 2.345 1.870 .2020 .3150 4.268 1.086 .0350
                       .2870 .0817 .0696 .6000 -.051
Denmark75              .0186 9.043 1.280 1.286 .4550 .4680 4.282 3.976 .0533
                       .3259 .0774 .0000 .0000 -.005
Denmark85              .0234 9.229 1.732 1.348 .4310 .5160 4.296 3.406 .0595
                       .2562 .1106 .0000 .0000 -.011
Dominican_Rep.75       .0473 7.104 .2870 .1950 .0240 .0540 3.982 .2477 .0259
                       .1467 .0731 .2030 .1613 .0652
Dominican_Rep.85       .0061 7.578 .5340 .4630 .0730 .1150 4.091 .0897 .0181
                       .1940 .0520 .3464 .6000 -.113
Ecuador75              .0523 7.349 .5120 .3690 .0260 .0990 4.000 .0234 .0295
                       .2436 .0886 .1268 .2000 .0302
Ecuador85              .0096 7.872 .7450 .6300 .0580 .1580 4.074 -.085 .0362
                       .2647 .1086 .2412 .1000 .0477
Egypt85                .0427 7.101 .7070 .2140 .0470 .2100 3.955 .5749 .0406
                       .0704 .0980 .4150 .5500 .0002
El_Salvador75          .0154 7.427 .2870 .2290 .0120 .0330 3.959 -.002 .0264
                       .0905 .1103 .1483 .0500 -.011
El_Salvador85          -.013 7.580 .4300 .3810 .0360 .0560 4.064 .1197 .0323
                       .0977 .1370 .4624 .7385 -.028
Finland75              .0391 8.799 .3820 .3970 .1260 .1620 4.228 -.027 .0513
                       .4042 .0485 .0000 .0000 .0025
Finland85              .0213 9.190 .9460 .9490 .1950 .2670 4.257 .7458 .0522
                       .3600 .0665 .0000 .0000 -.014
France75               .0331 8.925 .7490 .6550 .0410 .1240 4.260 .7713 .0292
                       .3187 .0514 .0000 .0020 .0004
France85               .0152 9.256 1.210 1.128 .0900 .2170 4.282 1.271 .0422
                       .2852 .0485 .0000 .0009 -.003
Gambia85               -.011 6.531 .3140 .1190 .0030 .0110 3.611 2.377 .0305
                       .0947 .1451 .0607 .0000 -.014
Germany_West75         .0231 8.991 .6700 .4510 .0480 .1070 4.246 .3239 .0293
                       .3274 .0633 .0000 .0033 .0021
Germany_West85         .0214 9.222 .7760 .5750 .0880 .2720 4.260 -.227 .0408
                       .2776 .0635 .0000 .0000 -.016
Ghana75                .0013 6.766 .5510 .1350 .0080 .0340 3.833 .4963 .0410
                       .0846 .0823 .5031 .1500 .0295
Ghana85                -.015 6.779 1.189 .3440 .0040 .0310 3.908 .5819 .0243
                       .0567 .1652 2.117 .0500 -.031
Greece75               .0528 8.027 .7790 .4370 .0560 .1870 4.243 .2333 .0170
                       .3217 .0397 .0368 .1500 -.021
Greece85               .0174 8.555 1.220 .8210 .1250 .3110 4.285 .5604 .0229
                       .2667 .0308 .0656 .5555 -.009
Guatemala75            .0230 7.474 .1740 .1460 .0100 .0370 3.850 -.055 .0168
                       .1049 .0480 .0000 .2358 -.021
Guatemala85            -.008 7.704 .2610 .2100 .0170 .0630 3.982 -.032 .0164
                       .1128 .0506 .0751 .6700 -.024
Guyana85               -.056 7.676 .6760 .5230 .0190 .0690 4.184 .0053 .0640
                       .2060 .2416 .7574 .1328 -.087
Honduras75             .0127 6.988 .2210 .1640 .0090 .0400 3.871 .4403 .0278
                       .1501 .0919 .0000 .0500 -.029
Honduras85             .0057 7.116 .3190 .2520 .0140 .0540 3.989 .8475 .0299
                       .1469 .1005 .0504 .6000 .0109
Hong_Kong85            .0649 8.624 2.369 1.301 .0590 .1780 4.254 1.921 .0236
                       .2344 .0294 .0000 .0000 -.021
India75                .0104 6.469 .2230 .0550 .0070 .0300 3.780 1.166 .0244
                       .1720 .0890 .3914 .1506 -.020
India85                .0228 6.574 .7130 .1630 .0220 .1130 3.880 1.364 .0287
                       .1829 .0950 .1445 .5002 -.037
Indonesia75            .0463 6.378 .2320 .0650 .0020 .0170 3.752 1.304 .0191
                       .1165 .0500 .2118 .2004 .0736
Indonesia85            .0552 6.842 .4960 .2010 .0100 .0340 3.884 1.259 .0132
                       .2317 .0767 .0393 .5500 .0334
Iran75                 .0538 7.988 .3180 .1020 .0060 .0540 3.829 -.567 .0252
                       .1612 .0100 .0306 .0072 .1327
Iran85                 -.023 8.526 .8110 .2230 .0180 .0810 4.024 -.810 .0450
                       .2617 .0305 .8065 .6624 .0579
Iraq75                 .0216 8.358 .1800 .0440 .0130 .0470 3.829 -1.12 .0460
                       .0605 .0400 .1362 .3604 .1407
Iraq85                 -.029 8.575 .7230 .1720 .0360 .1200 3.970 -.977 .0341
                       .1903 .0750 .4550 .6541 .0610
Ireland75              .0400 8.257 1.301 1.533 .1030 .1800 4.251 1.710 .0400
                       .3026 .0705 .0000 .0160 .0025
Ireland85              .0227 8.657 1.567 1.585 .1270 .2340 4.265 1.615 .0538
                       .3006 .0640 .0000 .0153 -.005
Israel75               .0459 8.405 1.476 1.154 .2440 .4270 4.277 2.218 .0552
                       .3150 .0360 .1626 .0159 -.016
Israel85               .0111 8.863 1.837 1.531 .4310 .6100 4.271 3.021 .0686
                       .2547 .0100 .1582 .5000 .0065
Italy75                .0372 8.658 1.184 .7560 .0370 .1220 4.246 1.271 .0331
                       .3254 .0515 .0000 .0000 -.023
Italy85                .0266 9.030 1.579 1.062 .0810 .1920 4.277 1.443 .0277
                       .2729 .0582 .0000 .0741 -.008
Jamaica75              .0319 7.658 .3380 .3890 .0170 .0370 4.156 -.088 .0360
                       .3123 .0351 .1565 .0000 .0241
Jamaica85              -.031 7.977 .6460 .8170 .0460 .0660 4.214 -.097 .0571
                       .1774 .0724 .4447 .5725 -.078
Japan75                .0636 8.419 1.910 1.560 .0550 .3660 4.234 2.796 .0312
                       .3908 .0479 .0000 .0005 -.019
Japan85                .0337 9.056 2.121 1.828 .0670 .4230 4.290 3.581 .0403
                       .3637 .0347 .0000 .0004 -.018
Jordan75               -.005 7.361 .6750 .2380 .0200 .0860 3.880 .0263 .0343
                       .1470 .0462 .0391 .3358 .0248
Jordan85               .0593 7.316 1.205 .4130 .0190 .0600 4.036 .1420 .0489
                       .2440 .0812 .0208 .5000 -.066
Kenya75                .0314 6.390 .1360 .0610 .0080 .0110 3.824 1.318 .0429
                       .2047 .1351 .2338 .0075 -.020
Kenya85                -.006 6.704 .1550 .0790 .0100 .0180 3.928 1.890 .0548
                       .1571 .1470 .1498 .0037 .0061
Korea75                .0811 6.942 1.526 .4700 .0310 .2280 4.011 -.459 .0253
                       .2203 .0489 .1098 .1514 -.007
Korea85                .0605 7.754 2.369 1.060 .0900 .3970 4.117 .1331 .0281
                       .3024 .0131 .0751 .1513 -.022
Liberia75              .0171 6.687 .2780 .0870 .0190 .0550 3.742 .8358 .0182
                       .1193 .1565 .0459 .0000 -.035
Liberia85              -.017 6.859 .6680 .1980 .0280 .0760 3.854 1.069 .0413
                       .0981 .1411 .1733 .5000 -.022
Malawi75               .0224 5.989 .0240 .0030 .0000 .0000 3.648 2.354 .0229
                       .1276 .1407 .2006 .0000 .0043
Malawi85               .0000 6.213 .1640 .0370 .0040 .0120 3.714 3.220 .0238
                       .1398 .1522 .5688 .0000 -.024
Malaysia75             .0472 7.398 .8430 .2860 .0320 .0750 4.018 .0016 .0366
                       .2150 .0627 .0100 .0000 -.023
Malaysia85             .0442 7.870 1.255 .5170 .0370 .0720 4.140 -.018 .0500
                       .2944 .0397 .0030 .0541 .0149
Malta85                .0536 8.023 1.019 .6100 .0550 .1700 4.257 -.003 .0373
                       .2353 .1208 .0441 .0000 -.013
Mauritius85            .0141 8.187 .7640 .4420 .0240 .0950 4.143 -.327 .0425
                       .1140 .1101 .0492 .0000 -.084
Mexico75               .0335 8.107 .4840 .2070 .0220 .0970 4.067 -.299 .0199
                       .1825 .0367 .0000 .0009 .0000
Mexico85               .0130 8.443 .7950 .2930 .0370 .1920 4.140 -.502 .0241
                       .1966 .0484 .1167 .0007 .0228
Netherlands75          .0328 8.911 .8840 .5700 .0330 .1400 4.290 .8955 .0551
                       .3120 .0257 .0000 .0000 -.009
Netherlands85          .0118 9.238 2.494 1.971 .1670 .4070 4.304 5.011 .0669
                       .2384 .0142 .0000 .0000 .0009
New_Zealand75          .0147 9.112 2.250 2.132 .0790 .1940 4.162 5.908 .0370
                       .2866 .0635 .0000 .0000 -.042
New_Zealand85          .0076 9.258 3.235 2.875 .4490 .6700 4.277 8.480 .0471
                       .2501 .0659 .0000 .0000 .0034
Nicaragua75            .0127 7.641 .2190 .1520 .0030 .0380 3.884 -.220 .0211
                       .1393 .0289 .1731 .0000 -.017
Nicaragua85            -.038 7.768 .3240 .2470 .0340 .1000 3.996 -.118 .0352
                       .1193 .0885 .8471 .6953 -.032
Niger75                -.001 6.407 .0920 .0410 .0000 .0120 3.584 1.614 .0089
                       .0784 .1531 .0436 .0000 -.012
Niger85                -.012 6.400 .0840 .0290 .0000 .0070 3.664 2.998 .0210
                       .0891 .1535 .0105 .0500 -.045
Norway75               .0345 8.860 1.026 .8100 .0210 .1180 4.296 1.372 .0487
                       .3618 .0462 .0000 .0000 .0072
Norway85               .0358 9.205 4.151 3.861 .1640 .3320 4.309 10.19 .0592
                       .3433 .0542 .0000 .0000 .0301
Pakistan75             .0035 6.760 .5120 .1850 .0260 .0670 3.789 .4889 .0137
                       .1145 .0874 .6103 .1540 -.002
Pakistan85             .0312 6.796 1.039 .2710 .0480 .1870 3.842 .6504 .0156
                       .1085 .0666 .2621 .5507 -.037
Panama75               .0373 7.562 .8920 .9060 .1000 .1160 4.124 .1133 .0447
                       .2761 .1573 .0000 .2173 -.028
Panama85               .0188 7.935 1.187 1.272 .1800 .1990 4.199 .2302 .0471
                       .2340 .1864 .0000 .0000 -.010
Papua_New_Guinea85     -.013 7.455 .1360 .0480 .0040 .0150 3.867 .4700 .0720
                       .1717 .2261 .1760 .0000 -.001
Paraguay75             .0263 7.176 .5480 .2990 .0290 .0850 4.165 .0469 .0172
                       .1050 .0986 .1781 .0000 -.029
Paraguay85             .0283 7.439 .7680 .5750 .0650 .1270 4.184 .0981 .0129
                       .1857 .0836 .3078 .0000 -.019
Peru75                 .0210 7.785 .6990 .4270 .0660 .1550 3.896 -.026 .0353
                       .2007 .0629 .2807 .0500 .0022
Peru85                 -.018 7.995 1.129 .7720 .1610 .2890 4.015 .0767 .0270
                       .2143 .0658 .1392 .6000 -.048
Philippines75          .0278 7.113 .7590 .5470 .2390 .2730 3.996 -.155 .0220
                       .1430 .1032 .0820 .0589 -.027
Philippines85          -.006 7.391 1.049 .8370 .3840 .4010 4.060 -.179 .0149
                       .2039 .1149 .0870 .8023 -.061
Portugal85             .0140 8.383 .6940 .3620 .0350 .0960 4.220 -.497 .0367
                       .2524 .0922 .1001 .1000 -.024
Rwanda75               .0590 5.820 .1450 .0720 .0050 .0240 3.867 1.928 .0281
                       .0311 .1283 .3570 .0500 -.030
Rwanda85               .0184 6.410 .1370 .0600 .0040 .0190 3.837 2.626 .0258
                       .0480 .1651 .3681 .0000 .0206
Senegal75              -.001 7.002 .1320 .1140 .0190 .0240 3.694 .5625 .0268
                       .0655 .1542 .0436 .0743 .0350
Senegal85              .0022 6.989 .2420 .1130 .0170 .0400 3.770 1.345 .0406
                       .0547 .1420 .0105 .0000 -.042
Sierra_Leone85         -.024 6.984 .5500 .2580 .0100 .0260 3.555 1.204 .0329
                       .0167 .2804 .2033 .0000 -.008
Singapore85            .0486 8.520 1.427 .8170 .0520 .1360 4.228 .4527 .0248
                       .3884 .0056 .0015 .0000 .0074
Spain75                .0457 8.452 .5980 .2990 .0260 .0930 4.243 -.058 .0127
                       .3108 .0480 .0000 .0014 -.026
Spain85                .0020 8.909 1.147 .6110 .0730 .2060 4.288 .2524 .0233
                       .2675 .0435 .0000 .0353 -.014
Sri_Lanka75            .0108 7.098 1.537 .9100 .0110 .0280 4.146 -.431 .0337
                       .1234 .1560 .7213 .0500 -.030
Sri_Lanka85            .0469 7.206 2.022 1.438 .0240 .0470 4.149 -.747 .0247
                       .2170 .0998 .2431 .5000 -.001
Sudan85                .0007 6.928 .1630 .0340 .0030 .0280 3.757 1.615 .0403
                       .0351 .1750 .5409 .7000 -.022
Sweden75               .0240 9.140 2.629 2.228 .2100 .2700 4.299 7.414 .0617
                       .2835 .0769 .0000 .0000 .0034
Sweden85               .0116 9.381 2.664 2.788 .2600 .3620 4.315 7.246 .0721
                       .2367 .1019 .0000 .0000 -.009
Switzerland75          .0146 9.344 1.818 1.297 .1840 .3960 4.271 5.089 .0339
                       .3277 .0138 .0000 .0000 .0061
Switzerland85          .0139 9.490 1.453 1.232 .0380 .2090 4.299 2.008 .0460
                       .2902 .0144 .0000 .0000 .0039
Syria75                .0601 7.573 .3030 .0850 .0090 .0550 3.936 -.138 .0321
                       .1417 .0063 .1120 .2500 .0295
Syria85                .0138 8.174 .7610 .2000 .0330 .1500 4.043 -.457 .0282
                       .1910 .0100 .2084 .5735 .0467
Taiwan75               .0614 7.479 1.360 .4230 .0350 .2140 4.181 .0492 .0245
                       .2426 .1465 .0601 .0534 -.021
Taiwan85               .0570 8.093 1.629 .7380 .0750 .2550 4.243 .3358 .0286
                       .2935 .1197 .0391 .0000 -.033
Tanzania75             .0332 5.916 .3440 .1140 .0540 .1550 3.728 1.387 .0298
                       .1708 .1925 .3843 .0035 .0000
Tanzania85             -.013 6.248 .2570 .0880 .0340 .0980 3.829 2.604 .0413
                       .1652 .2144 .9890 .5000 -.013
Thailand75             .0397 7.021 .3820 .1370 .0200 .0490 3.985 .2992 .0211
                       .2004 .0679 .0005 .1000 -.012
Thailand85             .0374 7.418 .4510 .2190 .0530 .0920 4.084 .3243 .0261
                       .1955 .0789 .0020 .6511 -.037
Togo75                 .0212 6.198 .0650 .0130 .0000 .0070 3.704 1.871 .0245
                       .1716 .1381 .0436 .1270 .0693
Togo85                 .0002 6.410 .3110 .0860 .0060 .0300 3.811 2.388 .0550
                       .2492 .1608 .0105 .0000 -.092
Trinidad_Tobago85      .0196 8.977 1.220 .9980 .0370 .0870 4.196 .5419 .0365
                       .1671 .0290 .2872 .0000 .0171
Tunisia75              .0499 7.102 .2740 .0670 .0080 .0450 3.908 .3261 .0465
                       .1922 .1047 .2402 .0000 .0431
Tunisia85              .0301 7.602 .5400 .1770 .0200 .0710 4.011 .1069 .0470
                       .1717 .0866 .0611 .0000 .0192
Turkey85               .0075 7.951 .6090 .2280 .0180 .0940 4.050 -.299 .0312
                       .2604 .0215 .1613 .5582 -.035
Uganda75               -.005 6.594 .1530 .0230 .0000 .0030 3.784 1.122 .0265
                       .1242 .1551 .5025 .1739 -.004
Uganda85               -.041 6.548 .0870 .0270 .0010 .0120 3.850 2.433 .0185
                       .0646 .1758 1.859 .5630 .0317
United_Kingdom75       .0201 8.903 1.036 1.151 .0410 .1230 4.263 1.921 .0403
                       .2260 .0818 .0000 .0518 -.014
United_Kingdom85       .0213 9.105 1.920 1.860 .2350 .4680 4.277 3.752 .0531
                       .1905 .0722 .0000 .1518 .0140
United_States75        .0155 9.353 3.154 3.253 .5170 .7230 4.248 12.69 .0516
                       .2509 .0051 .0000 .0015 -.019
United_States85        .0207 9.508 4.227 4.198 .7120 .9600 4.271 15.04 .0578
                       .2291 .0085 .0000 .5007 -.007
Uruguay75              .0143 8.168 .7650 .6800 .0510 .0570 4.211 .3336 .0303
                       .1476 .0622 .1941 .0891 -.034
Uruguay85              -.009 8.311 1.134 1.214 .2310 .1920 4.234 .5556 .0201
                       .2290 .0897 .0479 .0000 -.018
Venezuela75            -.000 8.900 .4620 .2810 .0310 .1060 4.111 -.478 .0347
                       .1724 .0296 .0015 .0500 .1119
Venezuela85            -.019 8.899 .8500 .7520 .1090 .2060 4.193 -.011 .0466
                       .2319 .0443 .1926 .0038 .0532
Yemen85                .0305 6.839 .0620 .0000 .0000 .0080 3.669 2.010 .0365
                       .1475 .0419 .1147 .0730 .0016
Zaire85                -.035 6.399 .1280 .0220 .0010 .0140 3.829 2.732 .0312
                       .0654 .1224 .9393 .7022 -.007
Zambia75               .0120 6.989 .3760 .1190 .0130 .0420 3.757 .4388 .0339
                       .3688 .2513 .3945 .0000 -.032
Zambia85               -.046 7.109 .4200 .2740 .0110 .0270 3.854 .8812 .0477
                       .1632 .2637 .6467 .0000 -.033
Zimbabwe75             .0320 6.860 .1450 .0170 .0080 .0450 3.833 .7156 .0337
                       .2276 .0246 .1997 .0000 -.040
Zimbabwe85             -.011 7.180 .2200 .0650 .0060 .0400 3.944 .9296 .0520
                       .1559 .0518 .7862 .7161 -.024
;

proc quantselect data=growth;
   class period;
   model GDPR = period lgdp2 mse2 fse2 fhe2 mhe2 lexp2
               lintr2 gedy2 Iy2 gcony2 lblakp2 pol2 ttrad2
               / quantile=0.1 0.5 0.9 selection=backward(choose=sbc sh=5);
run;


proc quantreg data=growth;
   class period;
   model GDPR =  &_qrsindt2 / quantile=0.5;
   Time_Period: test  period;
   Political_Instability: test  pol2;
run;

proc quantreg data=growth;
   class period;
   model GDPR =  &_qrsindt2 / quantile=0.9;
   Time_Period:           test period;
   Political_Instability: test pol2;
   Period_and_Political:  test period pol2;
run;

proc quantselect data=growth;
   class period;
   model GDPR = period lgdp2 mse2 fse2 fhe2 mhe2 lexp2
               lintr2 gedy2 Iy2 gcony2 lblakp2 pol2 ttrad2
               / quantile=0.9 selection=backward(choose=sbc sh=5);
   output out=growth90Out p=Pred;
run;

data growth90;
   set growth90Out;
   drop lgdp2  mse2  fse2  fhe2  mhe2 lexp2   lintr2 gedy2   Iy2
        gcony2 lblakp2  ttrad2;
   where  GDPR-Pred >= -1E-4;
   GdpDiff = GDPR-Pred;
run;

proc sort data=growth90;
   by GdpDiff;
run;
proc print data=growth90;
run;

