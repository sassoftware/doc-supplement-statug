/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SURPHEX1                                            */
/*   TITLE: Documentation Example 1 for PROC SURVEYPHREG        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: clustered data, proportional hazards regression,    */
/*    KEYS: censoring                                           */
/*   PROCS: SURVEYPHREG                                         */
/*    DATA: Lin, D. Y. (1994), "Cox Regression Analysis of      */
/*          Multivariate Failure Time Data: The Marginal        */
/*          Approach," Statistics in Medicine, 13, pp. 2233-2247*/
/*                                                              */
/*     REF: PROC SURVEYPHREG, Example 1                         */
/*    MISC:                                                     */
/****************************************************************/

proc format;
   value type 0='Juvenile' 1='Adult';
   value Rx  1='Laser' 0='Others';
run;

data Blind;
   format Treatment Rx.
          DiabeticType Type.;
   input ID Time Status DiabeticType Treatment @@;
   datalines;
   5 46.23 0 1 1    5 46.23 0 1 0   14 42.50 0 0 1   14 31.30 1 0 0
  16 42.27 0 0 1   16 42.27 0 0 0   25 20.60 0 0 1   25 20.60 0 0 0
  29 38.77 0 0 1   29  0.30 1 0 0   46 65.23 0 0 1   46 54.27 1 0 0
  49 63.50 0 0 1   49 10.80 1 0 0   56 23.17 0 0 1   56 23.17 0 0 0
  61  1.47 0 0 1   61  1.47 0 0 0   71 58.07 0 1 1   71 13.83 1 1 0
 100 46.43 1 1 1  100 48.53 0 1 0  112 44.40 0 1 1  112  7.90 1 1 0
 120 39.57 0 1 1  120 39.57 0 1 0  127 30.83 1 1 1  127 38.57 1 1 0
 133 66.27 0 1 1  133 14.10 1 1 0  150 20.17 1 0 1  150  6.90 1 0 0
 167 58.43 0 1 1  167 41.40 1 1 0  176 58.20 0 0 1  176 58.20 0 0 0
 185 57.43 0 1 1  185 57.43 0 1 0  190 56.03 0 0 1  190 56.03 0 0 0
 202 67.53 0 0 1  202 67.53 0 0 0  214 61.40 0 1 1  214  0.60 1 1 0
 220 10.27 1 0 1  220  1.63 1 0 0  243 66.20 0 0 1  243 66.20 0 0 0
 255  5.67 1 0 1  255 13.83 1 0 0  264 58.83 0 0 1  264 29.97 1 0 0
 266 60.27 0 1 1  266 26.37 1 1 0  284  5.77 1 1 1  284  1.33 1 1 0
 295  5.90 1 0 1  295 35.53 1 0 0  300 25.63 1 1 1  300 21.90 1 1 0
 302 33.90 1 0 1  302 14.80 1 0 0  315  1.73 1 0 1  315  6.20 1 0 0
 324 46.90 0 1 1  324 22.00 1 1 0  328 31.13 0 0 1  328 31.13 0 0 0
 335 30.20 1 0 1  335 22.00 1 0 0  342 70.90 0 0 1  342 70.90 0 0 0
 349 25.80 1 1 1  349 13.87 1 1 0  357  5.73 1 1 1  357 48.30 1 1 0
 368 53.43 0 0 1  368 53.43 0 0 0  385  1.90 1 0 1  385 51.10 0 0 0
 396  9.90 1 1 1  396  9.90 1 1 0  405 34.20 0 0 1  405 34.20 0 0 0
 409 46.73 0 1 1  409  2.67 1 1 0  419 18.73 0 1 1  419 13.83 1 1 0
 429 32.03 0 1 1  429  4.27 1 1 0  433 69.87 0 1 1  433 13.90 1 1 0
 445 66.80 0 0 1  445 66.80 0 0 0  454 64.73 0 0 1  454 64.73 0 0 0
 468  1.70 1 0 1  468  1.70 1 0 0  480  1.77 1 0 1  480 43.03 1 0 0
 485 29.03 0 0 1  485 29.03 0 0 0  491 56.57 0 1 1  491 56.57 0 1 0
 503  8.30 1 1 1  503  8.30 1 1 0  515 21.57 0 1 1  515 18.43 1 1 0
 522 31.57 0 0 1  522 31.57 0 0 0  538 31.63 0 1 1  538 31.63 1 1 0
 547 39.77 0 1 1  547 39.77 0 1 0  550 18.70 1 0 1  550  6.53 1 0 0
 554 18.90 0 0 1  554 18.90 0 0 0  557 56.80 0 0 1  557 22.23 1 0 0
 561 55.60 0 0 1  561 14.00 1 0 0  568 42.17 1 0 1  568 42.17 1 0 0
 572 10.70 0 0 1  572  5.33 1 0 0  576 66.33 0 0 1  576 59.80 1 0 0
 581 52.33 0 1 1  581  5.83 1 1 0  606 58.17 0 0 1  606  2.17 1 0 0
 610 14.30 1 0 1  610 48.43 1 0 0  615 25.83 0 0 1  615 25.83 0 0 0
 618 45.40 0 0 1  618 45.40 0 0 0  624 47.60 0 0 1  624 47.60 0 0 0
 631 13.33 1 0 1  631  9.60 1 0 0  636 42.10 0 0 1  636 42.10 0 0 0
 645 39.93 0 0 1  645 39.93 0 0 0  653 14.27 1 0 1  653  7.60 1 0 0
 662 34.57 1 0 1  662  1.80 1 0 0  664 65.80 0 0 1  664  4.30 1 0 0
 683  4.10 1 1 1  683 12.20 1 1 0  687 60.93 0 0 1  687 60.93 0 0 0
 701 57.20 0 0 1  701 57.20 0 0 0  706 38.07 0 1 1  706 12.73 1 1 0
 717 54.10 0 1 1  717 54.10 1 1 0  722 59.27 0 0 1  722  9.40 1 0 0
 731 21.57 1 0 1  731  9.90 1 0 0  740 54.10 0 0 1  740 54.10 0 0 0
 749 50.47 0 1 1  749 50.47 0 1 0  757 46.17 0 0 1  757 46.17 0 0 0
 760 46.30 0 0 1  760 46.30 0 0 0  766 38.83 0 1 1  766 38.83 0 1 0
 769 44.60 0 0 1  769 44.60 0 0 0  772 43.07 0 0 1  772 43.07 0 0 0
 778 26.23 1 1 1  778 40.03 0 1 0  780 41.60 0 0 1  780 18.03 1 0 0
 793 38.07 0 1 1  793 38.07 0 1 0  800 65.23 0 1 1  800 65.23 0 1 0
 804  7.07 1 1 1  804 66.77 0 1 0  810 13.77 1 0 1  810 13.77 1 0 0
 815  9.63 0 1 1  815  9.63 1 1 0  832 46.23 0 0 1  832 46.23 0 0 0
 834 45.73 0 0 1  834  1.50 1 0 0  838 33.63 1 1 1  838 33.63 1 1 0
 857 40.17 0 0 1  857 40.17 0 0 0  866 63.33 1 1 1  866 27.60 1 1 0
 887 38.47 1 1 1  887  1.63 1 1 0  903 55.23 0 1 1  903 55.23 0 1 0
 910 52.77 0 1 1  910 25.30 1 1 0  920 57.17 0 0 1  920 46.20 1 0 0
 925  9.87 0 1 1  925  1.70 1 1 0  931 57.90 0 0 1  931 57.90 0 0 0
 936  5.90 0 0 1  936  5.90 0 0 0  945 32.20 0 0 1  945 32.20 0 0 0
 949 10.33 1 0 1  949  0.83 1 0 0  952  6.13 1 0 1  952 50.90 0 0 0
 962 43.67 0 0 1  962 25.93 1 0 0  964 38.30 0 0 1  964 38.30 0 0 0
 971 38.77 0 1 1  971 19.40 1 1 0  978 38.07 0 0 1  978 21.97 1 0 0
 983 38.30 0 0 1  983 38.30 0 0 0  987 26.20 1 0 1  987 70.03 0 0 0
1002 62.57 0 0 1 1002 18.03 1 0 0 1017 13.83 1 1 1 1017  1.57 1 1 0
1029 46.50 0 1 1 1029 13.37 1 1 0 1034 11.07 1 0 1 1034  1.97 1 0 0
1037 42.47 0 1 1 1037 22.20 1 1 0 1042 38.73 0 1 1 1042 38.73 0 1 0
1069 51.13 0 1 1 1069 51.13 0 1 0 1074  6.10 1 0 1 1074 46.50 0 0 0
1098  2.10 1 0 1 1098 11.30 1 0 0 1102 17.73 1 0 1 1102 42.30 0 0 0
1112 26.47 0 0 1 1112 26.47 0 0 0 1117 10.77 0 0 1 1117 10.77 0 0 0
1126 55.33 0 1 1 1126 55.33 0 1 0 1135 58.67 0 0 1 1135 58.67 0 0 0
1145 12.93 1 1 1 1145  4.97 1 1 0 1148 54.20 0 1 1 1148 26.47 1 1 0
1167 49.57 0 0 1 1167 49.57 0 0 0 1184 24.43 1 1 1 1184  9.87 1 1 0
1191 50.23 0 1 1 1191 50.23 0 1 0 1205 13.97 1 0 1 1205 30.40 1 0 0
1213 43.33 0 0 1 1213 43.33 1 0 0 1228 42.23 0 1 1 1228 42.23 0 1 0
1247 74.93 0 0 1 1247 74.93 0 0 0 1250 66.93 0 1 1 1250 66.93 0 1 0
1253 73.43 0 0 1 1253 73.43 0 0 0 1267 67.47 0 1 1 1267 38.57 1 1 0
1281  3.67 0 1 1 1281  3.67 1 1 0 1287 48.87 1 0 1 1287 67.03 0 0 0
1293 65.60 0 0 1 1293 65.60 0 0 0 1296 15.83 0 0 1 1296 15.83 1 0 0
1309 20.07 0 1 1 1309  8.83 1 1 0 1312 67.43 0 0 1 1312 67.43 0 0 0
1317  1.47 0 0 1 1317  1.47 0 0 0 1321 62.93 0 0 1 1321 22.13 1 0 0
1333  6.30 1 0 1 1333 56.97 0 0 0 1347 59.70 0 0 1 1347 18.93 1 0 0
1361 13.80 1 0 1 1361 19.00 1 0 0 1366 55.13 0 1 1 1366 55.13 0 1 0
1373 13.57 1 0 1 1373  5.43 1 0 0 1397 42.20 0 1 1 1397 42.20 0 1 0
1410 38.27 0 1 1 1410 38.27 0 1 0 1413  7.10 0 0 1 1413  7.10 1 0 0
1425 63.63 0 1 1 1425 26.17 1 1 0 1447 59.00 0 0 1 1447 24.73 1 0 0
1461 54.37 0 1 1 1461 54.37 0 1 0 1469 54.60 0 1 1 1469 10.97 1 1 0
1480 63.87 0 1 1 1480 21.10 1 1 0 1487 62.37 0 1 1 1487 43.70 1 1 0
1491 62.80 0 1 1 1491 62.80 0 1 0 1499 63.33 0 1 1 1499 14.37 1 1 0
1503 58.53 0 1 1 1503 58.53 0 1 0 1513 58.07 0 1 1 1513 58.07 0 1 0
1524 58.50 0 1 1 1524 58.50 0 1 0 1533  1.50 1 1 1 1533 14.37 0 1 0
1537 54.73 0 0 1 1537 38.40 1 0 0 1552 50.63 0 0 1 1552  2.83 1 0 0
1554 51.10 0 1 1 1554 51.10 0 1 0 1562 49.93 0 1 1 1562  6.57 1 1 0
1572 46.27 0 1 1 1572 46.27 1 1 0 1581 10.60 0 1 1 1581 10.60 0 1 0
1585 42.77 0 1 1 1585 42.77 0 1 0 1596 34.37 1 0 1 1596 42.27 0 0 0
1600 42.07 0 0 1 1600 42.07 0 0 0 1603 38.77 0 0 1 1603 38.77 0 0 0
1619 74.97 0 1 1 1619 61.83 1 1 0 1627  6.57 1 0 1 1627 66.97 0 0 0
1636 38.87 1 0 1 1636 68.30 0 0 0 1640 42.43 1 0 1 1640 46.63 1 0 0
1643 67.07 0 0 1 1643 67.07 0 0 0 1649  2.70 1 0 1 1649  2.70 0 0 0
1666 63.80 0 0 1 1666 63.80 0 0 0 1672 32.63 0 0 1 1672 32.63 0 0 0
1683 62.00 0 1 1 1683 62.00 0 1 0 1688 13.10 1 0 1 1688 54.80 0 0 0
1705  8.00 0 0 1 1705  8.00 0 0 0 1717 51.60 0 1 1 1717 42.33 1 1 0
1727 49.97 0 1 1 1727  2.90 1 1 0 1746 45.90 0 0 1 1746  1.43 1 0 0
1749 41.93 0 1 1 1749 41.93 0 1 0
;

proc surveyphreg data=Blind;
   class Treatment DiabeticType / param=ref;
   model Time*Status(0) = Treatment DiabeticType Treatment*DiabeticType;
   cluster ID;
   hazardratio Treatment;
run;