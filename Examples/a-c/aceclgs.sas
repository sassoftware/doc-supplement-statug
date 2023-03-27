/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ACECLGS                                             */
/*   TITLE: Getting Started Example for PROC ACECLUS            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multivariate analysis, cluster analysis             */
/*   PROCS: ACECLUS                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC ACECLUS, Getting Started Example               */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data poverty;
   input Birth Death InfantDeath Country &$20. @@;
   datalines;
24.7  5.7  30.8 Albania             12.5 11.9  14.4 Bulgaria
13.4 11.7  11.3 Czechoslovakia        12 12.4   7.6 Former E. Germany
11.6 13.4  14.8 Hungary             14.3 10.2    16 Poland
13.6 10.7  26.9 Romania               14    9  20.2 Yugoslavia
17.7   10    23 USSR                15.2  9.5  13.1 Byelorussia
13.4 11.6    13 Ukrainian SSR       20.7  8.4  25.7 Argentina
46.6   18   111 Bolivia             28.6  7.9    63 Brazil
23.4  5.8  17.1 Chile               27.4  6.1    40 Columbia
32.9  7.4    63 Ecuador             28.3  7.3    56 Guyana
34.8  6.6    42 Paraguay            32.9  8.3 109.9 Peru
18    9.6  21.9 Uruguay             27.5  4.4  23.3 Venezuela
29   23.2    43 Mexico                12 10.6   7.9 Belgium
13.2 10.1   5.8 Finland             12.4 11.9   7.5 Denmark
13.6  9.4   7.4 France              11.4 11.2   7.4 Germany
10.1  9.2    11 Greece              15.1  9.1   7.5 Ireland
9.7   9.1   8.8 Italy               13.2  8.6   7.1 Netherlands
14.3 10.7   7.8 Norway              11.9  9.5  13.1 Portugal
10.7  8.2   8.1 Spain               14.5 11.1   5.6 Sweden
12.5  9.5   7.1 Switzerland         13.6 11.5   8.4 U.K.
14.9  7.4     8 Austria              9.9  6.7   4.5 Japan
14.5  7.3   7.2 Canada              16.7  8.1   9.1 U.S.A.
40.4 18.7 181.6 Afghanistan         28.4  3.8    16 Bahrain
42.5 11.5 108.1 Iran                42.6  7.8    69 Iraq
22.3  6.3   9.7 Israel              38.9  6.4    44 Jordan
26.8  2.2  15.6 Kuwait              31.7  8.7    48 Lebanon
45.6  7.8    40 Oman                42.1  7.6    71 Saudi Arabia
29.2  8.4    76 Turkey              22.8  3.8    26 United Arab Emirates
42.2 15.5   119 Bangladesh          41.4 16.6   130 Cambodia
21.2  6.7    32 China               11.7  4.9   6.1 Hong Kong
30.5 10.2    91 India               28.6  9.4    75 Indonesia
23.5 18.1    25 Korea               31.6  5.6    24 Malaysia
36.1  8.8    68 Mongolia            39.6 14.8   128 Nepal
30.3  8.1 107.7 Pakistan            33.2  7.7    45 Philippines
17.8  5.2   7.5 Singapore           21.3  6.2  19.4 Sri Lanka
22.3  7.7    28 Thailand            31.8  9.5    64 Vietnam
35.5  8.3    74 Algeria             47.2 20.2   137 Angola
48.5 11.6    67 Botswana            46.1 14.6    73 Congo
38.8  9.5  49.4 Egypt               48.6 20.7   137 Ethiopia
39.4 16.8   103 Gabon               47.4 21.4   143 Gambia
44.4 13.1    90 Ghana                 47 11.3    72 Kenya
44    9.4    82 Libya               48.3   25   130 Malawi
35.5  9.8    82 Morocco               45 18.5   141 Mozambique
44   12.1   135 Namibia             48.5 15.6   105 Nigeria
48.2 23.4   154 Sierra Leone        50.1 20.2   132 Somalia
32.1  9.9    72 South Africa        44.6 15.8   108 Sudan
46.8 12.5   118 Swaziland           31.1  7.3    52 Tunisia
52.2 15.6   103 Uganda              50.5   14   106 Tanzania
45.6 14.2    83 Zaire               51.1 13.7    80 Zambia
41.7 10.3    66 Zimbabwe
;

proc sgplot data=poverty;
   scatter y=Death x=Birth;
run;

proc aceclus data=poverty out=ace proportion=.03;
   var Birth Death InfantDeath;
run;

proc cluster data=ace outtree=tree noprint method=ward;
   var can1 can2 can3 ;
   copy Birth--Country;
run;

proc tree data=tree out=new nclusters=3 noprint;
   copy Birth Death InfantDeath can1 can2 ;
   id Country;
run;

proc sgplot data=new;
   scatter y=Death x=Birth / group=cluster;
   keylegend / title="Cluster Membership";
run;

proc sgplot data=new;
   scatter y=can2 x=can1 / group=cluster;
   keylegend / title="Cluster Membership";
run;

