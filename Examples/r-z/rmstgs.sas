/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: RMSTGS                                              */
/*   TITLE: Getting Started Example 1 for PROC RMSTREG          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Restricted Mean Survival Time, Regression Models    */
/*   PROCS: RMSTREG                                             */
/*    DATA: Fleming and Harrington (1991), Counting Processes & */
/*          Survival Analysis, pp 361-375                       */
/*     REF: SAS/STAT User's Guide, PROC RMSTREG Chapter         */
/*    MISC:                                                     */
/****************************************************************/

data Liver;
   input Time Status Age Albumin Bilirubin Edema Protime @@;
   label Time="Follow-Up Time in Years";
   Time= Time / 365.25;
   datalines;
  400 1 58.7652 2.60 14.5 1.0 12.2 4500 0 56.4463 4.14  1.1 0.0 10.6
 1012 1 70.0726 3.48  1.4 0.5 12.0 1925 1 54.7406 2.54  1.8 0.5 10.3
 1504 0 38.1054 3.53  3.4 0.0 10.9 2503 1 66.2587 3.98  0.8 0.0 11.0
 1832 0 55.5346 4.09  1.0 0.0  9.7 2466 1 53.0568 4.00  0.3 0.0 11.0
 2400 1 42.5079 3.08  3.2 0.0 11.0   51 1 70.5599 2.74 12.6 1.0 11.5
 3762 1 53.7139 4.16  1.4 0.0 12.0  304 1 59.1376 3.52  3.6 0.0 13.6
 3577 0 45.6893 3.85  0.7 0.0 10.6 1217 1 56.2218 2.27  0.8 1.0 11.0
 3584 1 64.6461 3.87  0.8 0.0 11.0 3672 0 40.4435 3.66  0.7 0.0 10.8
  769 1 52.1834 3.15  2.7 0.0 10.5  131 1 53.9302 2.80 11.4 1.0 12.4
 4232 0 49.5606 3.56  0.7 0.5 11.0 1356 1 59.9535 3.51  5.1 0.0 13.0
 3445 0 64.1889 3.83  0.6 0.0 11.4  673 1 56.2765 3.63  3.4 0.0 11.6
  264 1 55.9671 2.94 17.4 1.0 11.7 4079 1 44.5202 4.00  2.1 0.0  9.9
 4127 0 45.0732 4.10  0.7 0.0 11.3 1444 1 52.0246 3.68  5.2 0.0  9.9
   77 1 54.4394 3.31 21.6 0.5 12.0  549 1 44.9473 3.23 17.2 1.0 13.0
 4509 0 63.8768 3.78  0.7 0.0 10.6  321 1 41.3854 2.54  3.6 0.0 11.0
 3839 1 41.5524 3.44  4.7 0.0 10.3 4523 0 53.9959 3.34  1.8 0.0 10.6
 3170 1 51.2827 3.19  0.8 0.0 12.0 3933 0 52.0602 3.70  0.8 0.0 10.5
 2847 1 48.6188 3.20  1.2 0.0 10.6 3611 0 56.4107 3.39  0.3 0.0 10.6
  223 1 61.7276 3.01  7.1 1.0 12.0 3244 1 36.6270 3.53  3.3 0.0 11.0
 2297 1 55.3922 3.00  0.7 0.0 10.6 4467 0 46.6694 3.34  1.3 0.0 11.0
 1350 1 33.6345 3.26  6.8 0.0 11.7 4453 0 33.6947 3.54  2.1 0.0 11.0
 4556 0 48.8706 3.64  1.1 0.0 10.6 3428 1 37.5825 3.55  3.3 1.0 11.7
 4025 0 41.7933 3.93  0.6 0.0 10.9 2256 1 45.7988 2.84  5.7 0.0 12.7
 2576 0 47.4278 3.65  0.5 0.0  9.8 4427 0 49.1362 3.70  1.9 0.0 11.0
  708 1 61.1526 3.82  0.8 0.0 11.0 2598 1 53.5086 3.36  1.1 0.0 10.6
 3853 1 52.0876 3.60  0.8 0.0 10.6 2386 1 50.5407 3.70  6.0 0.0 10.6
 1000 1 67.4086 3.10  2.6 0.0 11.0 1434 1 39.1978 3.40  1.3 1.0 11.0
 1360 1 65.7632 3.94  1.8 0.0 11.0 1847 1 33.6181 3.80  1.1 0.0 10.6
 3282 1 53.5715 3.18  2.3 0.5 12.4 4459 0 44.5695 4.08  0.7 0.0 10.6
 2224 1 40.3943 3.50  0.8 0.0 10.6 4365 0 58.3819 3.40  0.9 0.0 10.3
 4256 0 43.8987 3.94  0.6 0.0 13.0 3090 1 60.7064 2.75  1.3 0.0 13.2
  859 1 46.6283 3.12 22.5 1.0 11.6 1487 1 62.9076 3.50  2.1 0.0 11.0
 3992 0 40.2026 3.60  1.2 0.0 10.0 4191 1 46.4531 3.70  1.4 0.0 11.0
 2769 1 51.2882 3.91  1.1 0.0 10.0 4039 0 32.6133 4.09  0.7 0.0 10.6
 1170 1 49.3388 3.46 20.0 0.5 12.4 3458 0 56.3997 4.64  0.6 0.0 10.6
 4196 0 48.8460 3.57  1.2 0.0 11.5 4184 0 32.4928 3.54  0.5 0.0 10.0
 4190 0 38.4942 3.60  0.7 0.0 11.0 1827 1 51.9206 3.99  8.4 0.0 11.0
 1191 1 43.5181 2.53 17.1 0.5 11.5   71 1 51.9425 3.08 12.2 0.5 11.6
  326 1 49.8261 3.41  6.6 0.5 12.1 1690 1 47.9452 3.02  6.3 0.0 10.6
 3707 0 46.5161 4.24  0.8 0.0 10.9  890 1 67.4114 3.72  7.2 0.0 11.2
 2540 1 63.2635 3.65 14.4 0.0 11.7 3574 1 67.3101 4.09  4.5 0.0 11.1
 4050 0 56.0137 3.50  1.3 0.5 12.9 4032 0 55.8303 3.76  0.4 0.0 11.2
 3358 1 47.2170 3.48  2.1 0.0 11.5 1657 1 52.7584 3.21  5.0 0.0 10.9
  198 1 37.2786 4.40  1.1 0.0 10.7 2452 0 41.3936 4.06  0.6 0.5 12.0
 1741 1 52.4435 3.65  2.0 0.0 11.4 2689 1 33.4757 4.22  1.6 0.0 11.0
  460 1 45.6071 3.47  5.0 0.5 11.9  388 1 76.7091 3.13  1.4 1.0 12.2
 3913 0 36.5339 3.67  1.3 0.0 11.1  750 1 53.9165 3.11  3.2 0.0 11.8
  130 1 46.3901 2.64 17.4 1.0 11.7 3850 0 48.8460 3.70  1.0 0.0 10.4
  611 1 71.8932 3.26  2.0 0.5 11.4 3823 0 28.8843 3.77  1.0 0.0 10.2
 3820 0 48.4682 3.35  1.8 0.0 10.2  552 1 51.4689 3.00  2.3 0.0 12.0
 3581 0 44.9500 3.60  0.9 0.0 10.4 3099 0 56.5695 3.97  0.9 0.0 10.1
  110 1 48.9637 3.67  2.5 1.0 11.1 3086 1 43.0171 3.64  1.1 0.0 11.1
 3092 0 34.0397 4.20  1.1 0.0 10.3 3222 1 68.5092 3.90  2.1 0.0 10.6
 3388 0 62.5216 4.03  0.6 0.0 17.1 2583 1 50.3573 3.50  0.4 0.0 10.3
 2504 0 44.0630 3.61  0.5 0.0 10.6 2105 1 38.9103 3.54  1.9 0.0 10.9
 2350 0 41.1526 4.18  5.5 0.0 10.7 3445 1 55.4579 3.67  2.0 0.0 11.8
  980 1 51.2334 3.74  6.7 0.0 11.1 3395 1 52.8268 4.30  3.2 0.0 11.7
 3422 0 42.6393 4.19  0.7 0.0 10.3 3336 0 61.0705 3.63  3.0 0.5  9.9
 1083 1 49.6564 3.11  6.5 0.0 11.0 2288 1 48.8542 3.30  3.5 0.0 10.2
  515 1 54.2560 3.83  0.6 0.0  9.5 2033 0 35.1513 3.98  3.5 0.0 10.6
  191 1 67.9069 3.08  1.3 1.0 13.2 3297 0 55.4360 4.13  0.6 0.0 10.7
  971 1 45.8207 3.23  5.1 1.0 13.0 3069 0 52.8898 3.90  0.6 0.0 10.8
 2468 0 47.1814 3.51  1.3 0.0 10.0  824 1 53.5989 3.12  1.2 0.0 11.1
 3255 0 44.1040 4.08  0.5 0.0 10.0 1037 1 41.9493 2.89 16.2 0.0 12.6
 3239 0 63.6140 3.87  0.9 0.0  9.7 1413 1 44.2272 3.43 17.4 0.0 11.5
  850 1 62.0014 3.80  2.8 0.0 13.2 2944 0 40.5530 3.83  1.9 0.0  9.8
 2796 1 62.6448 3.95  1.5 0.0 10.1 3149 0 42.3354 3.67  0.7 0.0 10.7
 3150 0 42.9678 3.57  0.4 0.0 11.0 3098 0 55.9617 3.35  0.8 0.0  9.8
 2990 0 62.8611 3.60  1.1 0.0 10.1 1297 1 51.2498 3.93  7.3 0.0 10.5
 2106 0 46.7625 3.31  1.1 0.0 11.6 3059 0 54.0753 4.09  1.1 0.0 10.0
 3050 0 47.0363 3.77  0.9 0.0 10.6 2419 1 55.7262 3.48  1.0 0.0  9.9
  786 1 46.1027 3.60  2.9 0.0 11.0  943 1 52.2875 3.26 28.0 0.5 10.0
 2976 0 51.2005 3.84  0.7 0.0 11.4 2615 0 33.8645 3.89  1.2 0.5  9.4
 2995 0 75.0116 3.37  1.2 0.5 10.7 1427 1 30.8638 3.26  7.2 0.0  9.8
  762 1 61.8042 3.79  3.0 0.5  9.9 2891 0 34.9870 3.63  1.0 0.0 10.0
 2870 0 55.0418 3.03  0.9 0.0  9.4 1152 1 69.9411 3.01  2.3 0.0 10.9
 2863 0 49.6044 3.85  0.5 0.0 11.1  140 1 69.3771 2.56  2.4 1.0 14.1
 2666 0 43.5565 3.35  0.6 0.5 11.2  853 1 59.4086 3.52 25.5 0.0 11.5
 2835 0 48.7584 3.42  0.6 0.0 10.0 2475 0 36.4928 3.37  3.4 0.0 11.2
 1536 1 45.7604 3.46  2.5 0.0 10.1 2772 0 57.3717 3.62  0.6 0.0 10.5
 2797 0 42.7433 3.56  2.3 0.0  9.6  186 1 58.8172 3.19  3.2 0.0 12.0
 2055 1 53.4976 4.08  0.3 0.0  9.9  264 1 43.4141 3.34  8.5 0.5 13.3
 1077 1 53.3060 3.45  4.0 0.0 11.3 2721 0 41.3552 3.26  5.7 0.0  9.5
 1682 1 60.9582 3.86  0.9 0.0 10.3 2713 0 47.7536 3.80  0.4 0.0  9.2
 1212 1 35.4908 4.22  1.3 0.0 10.1 2692 0 48.6626 3.61  1.2 0.0  9.0
 2574 0 52.6680 4.52  0.5 0.0 10.1 2301 0 49.8700 3.34  1.3 0.0  9.8
 2657 0 30.2752 3.42  3.0 0.0  9.8 2644 0 55.5674 3.85  0.5 0.0  9.7
 2624 0 52.1533 3.80  0.8 0.0 10.1 1492 1 41.6099 3.56  3.2 0.0 10.1
 2609 0 55.4524 4.01  0.9 0.0 10.4 2580 0 70.0041 4.08  0.6 0.0 10.2
 2573 0 43.9425 3.83  1.8 0.0  9.9 2563 0 42.5681 4.38  4.7 0.0 10.4
 2556 0 44.5695 3.58  1.4 0.0 10.3 2555 0 56.9446 3.69  0.6 0.0  9.9
 2241 0 40.2601 3.73  0.5 0.0 10.1  974 1 37.6071 3.55 11.0 0.0  9.8
 2527 0 48.3614 3.54  0.8 0.0 10.5 1576 1 70.8364 3.53  2.0 0.5 12.7
  733 1 35.7919 3.43 14.0 0.0 11.5 2332 0 62.6229 3.48  0.7 0.0 11.0
 2456 0 50.6475 3.63  1.3 0.0  9.9 2504 0 54.5270 3.93  2.3 0.0 10.2
  216 1 52.6927 3.35 24.5 0.0 15.2 2443 0 52.7201 3.69  0.9 0.0  9.8
  797 1 56.7721 3.19 10.8 0.0 10.4 2449 0 44.3970 4.30  1.5 0.0  9.1
 2330 0 29.5551 3.90  3.7 0.0 11.5 2363 0 57.0404 3.36  1.4 0.0 11.6
 2365 0 44.6270 3.97  0.6 0.0 10.1 2357 0 35.7974 2.90  0.7 0.0  9.6
 1592 0 40.7173 3.43  2.1 0.0 10.2 2318 0 32.2327 3.55  4.7 0.0  9.9
 2294 0 41.0924 3.20  0.6 0.0 10.8 2272 0 61.6400 3.80  0.5 0.0 10.0
 2221 0 37.0568 4.04  0.5 0.0  9.9 2090 1 62.5791 3.74  0.7 0.0 10.2
 2081 1 48.9774 3.55  2.5 0.0 10.3 2255 0 61.9904 4.07  0.6 0.0 11.0
 2171 0 72.7721 3.33  0.6 0.5 10.1  904 1 61.2950 3.20  3.9 0.0 10.0
 2216 0 52.6242 4.01  0.7 0.0  9.5 2224 0 49.7632 3.37  0.9 0.0 10.0
 2195 0 52.9144 3.76  1.3 0.0 10.3 2176 0 47.2635 3.98  1.2 0.0  9.9
 2178 0 50.2040 3.40  0.5 0.0 10.2 1786 1 69.3470 3.43  0.9 0.0  9.9
 1080 1 41.1691 3.85  5.9 0.0 10.7 2168 0 59.1650 3.68  0.5 0.0 10.4
  790 1 36.0794 3.31 11.4 0.0 10.8 2170 0 34.5955 3.89  0.5 0.0 10.1
 2157 0 42.7132 4.17  1.6 0.0  9.6 1235 1 63.6304 3.22  3.8 0.0 10.6
 2050 0 56.6297 3.65  0.9 0.0  9.7  597 1 46.2642 3.38  4.5 0.0 12.4
  334 1 61.2430 2.43 14.1 1.0 11.0 1945 0 38.6201 3.66  1.0 0.0  9.7
 2022 0 38.7707 3.66  0.7 0.0 10.1 1978 0 56.6954 3.70  0.5 0.0  9.6
  999 1 58.9514 3.35  2.3 0.0  9.7 1967 0 36.9227 3.35  0.7 0.0  9.6
  348 1 62.4148 3.05  4.5 0.5 11.4 1979 0 34.6092 3.41  3.3 0.0 11.5
 1165 1 58.3354 1.96  3.4 0.0 10.7 1951 0 50.1821 3.02  0.4 0.0 10.6
 1932 0 42.6858 3.06  0.9 0.0  9.8 1776 0 34.3792 3.35  0.9 0.0 11.2
 1882 0 33.1828 4.16 13.0 0.0 11.9 1908 0 38.3819 3.79  1.5 0.0  9.7
 1882 0 59.7618 2.95  1.6 0.0 10.1 1874 0 66.4120 3.35  0.6 0.5  9.8
  694 1 46.7899 2.94  0.8 0.0 11.2 1831 0 56.0794 3.72  0.4 0.0 10.1
  837 0 41.3744 3.62  4.4 0.0  9.8 1810 0 64.5722 2.97  1.9 0.0  9.9
  930 1 67.4880 2.81  8.0 0.0 10.0 1690 1 44.8296 3.22  3.9 0.0  9.6
 1790 0 45.7714 3.65  0.6 0.0  9.6 1435 0 32.9500 3.77  2.1 0.0 10.1
  732 0 41.2211 2.83  6.1 0.0 10.0 1785 0 55.4168 3.51  0.8 0.0 10.0
 1783 0 47.9808 3.20  1.3 0.0 10.6 1769 0 40.7912 3.36  0.6 0.0 10.9
 1457 0 56.9747 3.61  0.5 0.0  9.9 1770 0 68.4627 3.35  1.1 0.0 10.0
 1765 0 78.4394 3.03  7.1 0.0 11.2  737 0 39.8576 3.75  3.1 0.0 10.0
 1735 0 35.3101 3.85  0.7 0.0 10.3 1701 0 31.4442 3.74  1.1 0.0  9.7
 1614 0 58.2642 4.23  0.5 0.0 10.6 1702 0 51.4880 3.44  1.1 0.0  9.6
 1615 0 59.9699 2.97  3.1 0.0  9.8 1656 0 74.5243 3.59  5.6 0.0 10.9
 1677 0 52.3641 3.14  3.2 0.0  9.5 1666 0 42.7871 3.06  2.8 0.0  9.5
 1301 0 34.8747 3.57  1.1 0.5 11.4 1542 0 44.1396 3.12  3.4 0.0 11.2
 1084 0 46.3819 3.20  3.5 0.0 10.0 1614 0 56.3094 3.32  0.5 0.0 10.2
  179 1 70.9076 2.33  6.6 1.0 12.1 1191 1 55.3949 2.75  6.4 0.5 11.0
 1363 0 45.0842 3.50  3.6 0.0 10.1 1568 0 26.2779 3.74  1.0 0.0 10.2
 1569 0 50.4723 3.50  1.0 0.0  9.7 1525 0 38.3984 2.93  0.5 0.0  9.8
 1558 0 47.4196 3.46  2.2 0.0  9.6 1447 0 47.9808 3.07  1.6 0.0  9.6
 1349 0 38.3162 3.77  2.2 0.0  9.5 1481 0 50.1081 3.85  1.0 0.0 10.7
 1434 0 35.0883 3.56  1.0 0.5  9.8 1420 0 32.5038 3.70  5.6 0.0  9.9
 1433 0 56.1533 3.77  0.5 0.0  9.8 1412 0 46.1547 3.69  1.6 0.0  9.6
   41 1 65.8836 2.10 17.9 1.0 12.9 1455 0 33.9439 3.52  1.3 0.0  9.5
 1030 0 62.8611 3.99  1.1 0.0  9.6 1418 0 48.5640 3.44  1.3 0.0  9.5
 1401 0 46.3491 3.48  0.8 0.0 10.0 1408 0 38.8528 3.36  2.0 0.0  9.8
 1234 0 58.6475 3.46  6.4 0.0 10.1 1067 0 48.9363 3.89  8.7 0.5  9.6
  799 1 67.5729 3.99  4.0 0.5  9.8 1363 0 65.9849 3.57  1.4 0.0  9.8
  901 0 40.9008 3.18  3.2 0.0  9.9 1329 0 50.2450 3.73  8.6 0.0 11.2
 1320 0 57.1964 2.98  8.5 1.0 12.3 1302 0 60.5366 3.07  6.6 0.0 10.9
  877 0 35.3511 3.83  2.4 0.0 10.3 1321 0 31.3812 3.31  0.8 0.0 10.9
  533 0 55.9863 3.43  1.2 0.0 11.3 1300 0 52.7255 3.37  1.1 0.0 10.2
 1293 0 38.0917 3.76  2.4 0.0 10.8  207 1 58.1711 2.23  5.2 0.0 12.3
 1295 0 45.2101 3.57  1.0 0.0 10.5 1271 0 37.7988 3.95  0.7 0.0 10.6
 1250 0 60.6598 3.25  1.0 0.0 10.6 1230 0 35.5346 3.93  0.5 0.0 10.8
 1216 0 43.0664 3.61  2.9 0.0 10.6 1216 0 56.3915 3.45  0.6 0.0 10.7
 1149 0 30.5736 3.56  0.8 0.0 10.5 1153 0 61.1828 3.58  0.4 0.0 10.4
  994 0 58.2998 2.75  0.4 0.0 10.8  939 0 62.3326 3.35  1.7 0.0 10.2
  839 0 37.9986 3.16  2.0 0.0 10.5  788 0 33.1526 3.79  6.4 0.0 10.8
 4062 0 60.0000 3.65  0.7 0.0 11.0 3561 1 65.0000 3.04  1.4 0.5 12.1
 2844 0 54.0000 4.03  0.7 0.0  9.8 2071 1 75.0000 3.96  0.7 0.5 11.3
 3030 0 62.0000 2.48  0.8 0.0 10.0 1680 0 43.0000 3.68  0.7 0.0  9.5
   41 1 46.0000 2.93  5.0 0.0 10.4 2403 0 44.0000 3.81  0.4 0.5 10.5
 1170 0 61.0000 3.41  1.3 0.5 10.9 2011 1 64.0000 3.69  1.1 0.0 10.5
 3523 0 40.0000 4.04  0.6 0.0 11.2 3468 0 63.0000 3.94  0.6 0.0 11.5
 4795 0 34.0000 3.24  1.8 0.0 18.0 1236 0 52.0000 3.42  1.5 0.0 10.3
 4214 0 49.0000 3.99  1.2 0.0 11.2 2111 1 54.0000 3.60  1.0 0.0 12.1
 1462 1 63.0000 3.40  0.7 0.0 10.1 1746 1 54.0000 3.63  3.5 0.0 10.3
   94 1 46.0000 3.56  3.1 0.5 13.6  785 1 53.0000 2.87 12.6 0.0 11.8
 1518 1 56.0000 3.92  2.8 0.0 10.6  466 1 56.0000 3.51  7.1 0.0 11.8
 3527 0 55.0000 4.15  0.6 0.0 10.1 2635 0 65.0000 3.34  2.1 0.0 10.1
 2286 1 56.0000 3.64  1.8 0.0 10.0  791 1 47.0000 3.42 16.0 0.0 13.8
 3492 0 60.0000 4.38  0.6 0.0 10.6 3495 0 53.0000 4.19  5.4 0.0 11.2
  111 1 54.0000 3.29  9.0 0.0 13.1 3231 0 50.0000 4.01  0.9 0.0 10.5
  625 1 48.0000 2.84 11.1 0.0 12.2 3157 0 36.0000 3.76  8.9 0.0 10.6
 3021 0 48.0000 3.76  0.5 0.0 10.1  559 1 70.0000 3.81  0.6 0.5 11.0
 2812 1 51.0000 3.92  3.4 0.0  9.3 2834 0 52.0000 3.14  0.9 0.0 12.3
 2855 0 54.0000 3.82  1.4 0.0 10.3  662 1 48.0000 4.10  2.1 0.0  9.0
  727 1 66.0000 3.40 15.0 0.0 11.1 2716 0 53.0000 4.19  0.6 0.0  9.9
 2698 0 62.0000 3.40  1.3 0.0 10.6  990 1 59.0000 3.12  1.3 0.0  9.6
 2338 0 39.0000 3.75  1.6 0.0 10.4 1616 1 67.0000 3.26  2.2 0.5 11.1
 2563 0 58.0000 3.46  3.0 0.0 10.4 2537 0 64.0000 3.49  0.8 0.0 10.3
 2534 0 46.0000 2.89  0.8 0.0 10.6  778 1 64.0000 3.15  1.8 0.0 10.4
  617 0 41.0000 2.31  5.5 0.0 10.4 2267 0 49.0000 3.04 18.0 0.0  9.7
 2249 0 44.0000 3.50  0.6 0.0  9.9  359 1 59.0000 3.35  2.7 0.0 11.5
 1925 0 63.0000 3.58  0.9 0.0 10.0  249 1 61.0000 3.01  1.3 0.0 10.7
 2202 0 64.0000 3.49  1.1 0.0  9.8   43 1 49.0000 2.77 13.8 0.0 11.1
 1197 1 42.0000 4.52  4.4 0.0 10.8 1095 1 50.0000 3.36 16.0 0.0 10.0
  489 1 51.0000 3.52  7.3 0.5 11.1 2149 0 37.0000 3.55  0.6 0.0 10.3
 2103 0 62.0000 3.29  0.7 0.0  9.8 1980 0 51.0000 3.10  0.7 0.0 10.6
 1347 0 52.0000 3.24  1.7 0.0 10.5 1478 1 44.0000 3.63  9.5 0.0 10.2
 1987 0 33.0000 3.76  2.2 0.0  9.9 1168 1 60.0000 3.62  1.8 0.5  9.9
  597 1 63.0000 2.73  3.3 0.5 11.1 1725 0 33.0000 4.08  2.9 0.0 10.5
 1899 0 41.0000 3.66  1.7 0.0 11.0  221 1 51.0000 2.58 14.0 0.0 11.6
 1022 0 37.0000 3.00  0.8 0.5 10.8 1639 0 59.0000 3.40  1.3 0.0  9.7
 1635 0 55.0000 2.93  0.7 0.0 10.6 1654 0 54.0000 2.38  1.7 0.0  9.8
 1653 0 49.0000 3.00 13.6 0.5  9.9 1560 0 40.0000 3.50  0.9 0.0 10.9
 1581 0 67.0000 3.06  0.7 0.0 10.0 1419 0 68.0000 3.15  3.0 0.0 10.0
 1443 0 41.0000 2.80  1.2 0.0 11.0 1368 0 69.0000 3.03  0.4 0.0 10.9
  193 1 52.0000 2.96  0.7 0.5  9.9 1367 0 57.0000 3.07  2.0 0.5 12.1
 1329 0 36.0000 3.98  1.4 0.0 11.0 1343 0 50.0000 3.48  1.6 0.0 10.2
 1328 0 64.0000 3.65  0.5 0.0 10.2 1375 0 62.0000 3.49  7.3 0.0 10.9
 1260 0 42.0000 2.82  8.1 0.0 10.4 1223 0 44.0000 3.34  0.5 0.0 10.6
  935 1 69.0000 3.19  4.2 0.0 11.1  943 0 52.0000 3.01  0.8 0.0 10.6
 1141 0 66.0000 3.33  2.5 0.0 10.8 1092 0 40.0000 3.60  4.6 0.0 10.4
 1150 0 52.0000 3.64  1.0 0.0 10.6  703 1 46.0000 2.68  4.5 0.0 11.5
 1129 0 54.0000 3.69  1.1 0.0 10.8 1086 0 51.0000 3.17  1.9 0.5 10.7
 1067 0 43.0000 3.73  0.7 0.0 10.8 1072 0 39.0000 3.81  1.5 0.0 10.8
 1119 0 51.0000 3.57  0.6 0.0 10.6 1097 0 67.0000 3.58  1.0 0.0 10.8
  989 0 35.0000 3.23  0.7 0.0 10.8  681 1 67.0000 2.96  1.2 0.0 10.9
 1103 0 39.0000 3.83  0.9 0.0 11.2 1055 0 57.0000 3.42  1.6 0.0  9.9
  691 0 58.0000 3.75  0.8 0.0 10.4  976 0 53.0000 3.29  0.7 0.0 10.6
;

proc rmstreg data=liver tau=10;
   class Edema;
   model Time*Status(0) = Age Bilirubin Edema / link=linear method=pv;
run;

proc rmstreg data=liver tau=5;
   class Edema;
   model Time*Status(0) = Age Bilirubin Edema / link=linear method=pv;
run;
