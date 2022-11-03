/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: rregex5                                             */
/*   TITLE: Documentation Example 5 for PROC ROBUSTREG          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Robust Regression                                   */
/*                                                              */
/*   PROCS: ROBUSTREG                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data house;
   input price sqft age feats ne cor tax @@;
   label price = "Selling price"
         sqft  = "Square feet of living space"
         age   = "Age of home in year"
         feats = "Number out of 11 features (dishwasher, refrigerator,
                  microwave, disposer, washer, intercom, skylight(s),
                  compactor, dryer, handicap fit, cable TV access)"
         ne    = "Located in northeast sector of city (1) or not (0)"
         cor   = "Corner location (1) or not (0)"
         tax   = "Annual taxes";
   sum = sqft+age+feats+ne+cor+tax;
   id  = _N_;
   datalines;
2050 2650 13 7 1 0 1639
2150 2664  6 5 1 0 1193
2150 2921  3 6 1 0 1635
1999 2580  4 4 1 0 1732
1900 2580  4 4 1 0 1534
1800 2774  2 4 1 0 1765
1560 1920  1 5 1 0 1161
1449 1710  1 3 1 0 1010
1375 1837  4 5 1 0 1191
1270 1880  8 6 1 0  930
1250 2150 15 3 1 0  984
1235 1894 14 5 1 0 1112
1170 1928 18 8 1 0  600
1155 1767 16 4 1 0  794
1110 1630 15 3 1 1  867
1139 1680 17 4 1 1  750
 995 1500 15 4 1 0  743
 900 1400 16 2 1 1  731
 960 1573 17 6 1 0  768
1695 2931 28 3 1 1 1142
1553 2200 28 4 1 0 1035
1020 1478 53 3 1 1  626
1020 1713 30 4 1 1  600
 850 1190 41 1 1 0  600
 720 1121 46 4 1 0  398
 749 1733 43 6 1 0  656
2150 2848  4 6 1 0 1487
1350 2253 23 4 1 0  939
1299 2743 25 5 1 1 1232
1250 2180 17 4 1 1 1141
1239 1706 14 4 1 0  810
1125 1710 16 4 1 0  800
1080 2200 26 4 1 0 1076
1050 1680 13 4 1 0  875
1049 1900 34 3 1 0  690
 934 1543 20 3 1 0  820
 875 1173  6 4 1 0  456
 805 1258  7 4 1 1  821
 759  997  4 4 1 0  461
 729 1007 19 6 1 0  513
 710 1083 22 4 1 0  504
 975 1500  7 3 0 1  700
 939 1428 40 2 0 0  701
2100 2116 25 3 0 0 1209
 580 1051 15 2 0 0  426
1844 2250 40 6 0 0  915
 699 1400 45 1 0 1  481
1160 1720  5 4 0 0  867
1109 1740  4 3 0 0  816
1129 1700  6 4 0 0  725
1050 1620  6 4 0 0  800
1045 1630  6 4 0 0  750
1050 1920  8 4 0 0  944
1020 1606  5 4 0 0  811
1000 1535  7 5 0 1  668
1030 1540  6 2 0 1  826
 975 1739 13 3 0 0  880
 940 1305  5 3 0 0  647
 920 1415  7 4 0 0  866
 945 1580  9 3 0 0  810
 874 1236  3 4 0 0  707
 872 1229  6 3 0 0  721
 870 1273  4 4 0 0  638
 869 1165  7 4 0 0  694
 766 1200  7 4 0 1  634
 739  970  4 4 0 1  541
;
ods graphics on;
proc robustreg data=house method=MM plots=all;
   model price = sqft age feats ne cor tax sum /
                 leverage(opc mcdinfo) diagnostics;
run;
proc robustreg data=house method=MM plots=all;
   model price = sqft age feats ne tax/leverage(mcdinfo) diagnostics;
run;
ods graphics off;
