/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: adptgs1                                             */
/*   TITLE: Getting Started Example 1 for PROC ADAPTIVEREG      */
/*    DESC: Automobile MPG Study                                */
/*     REF: UCI Machine Learning                                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: ADAPTIVEREG                                         */
/*                                                              */
/****************************************************************/

title 'Automobile MPG Study';
data Autompg;
   input MPG Cylinders Displacement Horsepower Weight
         Acceleration Year Origin Name $35.;
   datalines;
18.0 8 307.0   130.0   3504   12.0   70  1  Chevrolet Chevelle Malibu
15.0 8 350.0   165.0   3693   11.5   70  1  Buick Skylark 320
18.0 8 318.0   150.0   3436   11.0   70  1  Plymouth Satellite
16.0 8 304.0   150.0   3433   12.0   70  1  AMC Rebel SST
17.0 8 302.0   140.0   3449   10.5   70  1  Ford Torino
15.0 8 429.0   198.0   4341   10.0   70  1  Ford Galaxie 500
14.0 8 454.0   220.0   4354    9.0   70  1  Chevrolet Impala
14.0 8 440.0   215.0   4312    8.5   70  1  Plymouth Fury III
14.0 8 455.0   225.0   4425   10.0   70  1  Pontiac Catalina
15.0 8 390.0   190.0   3850    8.5   70  1  AMC Ambassador DPL
15.0 8 383.0   170.0   3563   10.0   70  1  Dodge Challenger SE
14.0 8 340.0   160.0   3609    8.0   70  1  Plymouth Cuda 340
15.0 8 400.0   150.0   3761    9.5   70  1  Chevrolet Monte Carlo
14.0 8 455.0   225.0   3086   10.0   70  1  Buick Estate Wagon (SW)
24.0 4 113.0   95.00   2372   15.0   70  3  Toyota Corona Mark II
22.0 6 198.0   95.00   2833   15.5   70  1  Plymouth Duster
18.0 6 199.0   97.00   2774   15.5   70  1  AMC Hornet
21.0 6 200.0   85.00   2587   16.0   70  1  Ford Maverick
27.0 4 97.00   88.00   2130   14.5   70  3  Datsun Pl510
26.0 4 97.00   46.00   1835   20.5   70  2  Volkswagen 1131 Deluxe Sedan
25.0 4 110.0   87.00   2672   17.5   70  2  Peugeot 504
24.0 4 107.0   90.00   2430   14.5   70  2  Audi 100 LS
25.0 4 104.0   95.00   2375   17.5   70  2  Saab 99E
26.0 4 121.0   113.0   2234   12.5   70  2  BMW 2002
21.0 6 199.0   90.00   2648   15.0   70  1  AMC Gremlin
10.0 8 360.0   215.0   4615   14.0   70  1  Ford F250
10.0 8 307.0   200.0   4376   15.0   70  1  Chevy C20
11.0 8 318.0   210.0   4382   13.5   70  1  Dodge D200
9.0  8 304.0   193.0   4732   18.5   70  1  Hi 1200D
27.0 4 97.00   88.00   2130   14.5   71  3  Datsun Pl510
28.0 4 140.0   90.00   2264   15.5   71  1  Chevrolet Vega 2300
25.0 4 113.0   95.00   2228   14.0   71  3  Toyota Corona
25.0 4 98.00   .       2046   19.0   71  1  Ford Pinto
19.0 6 232.0   100.0   2634   13.0   71  1  AMC Gremlin
16.0 6 225.0   105.0   3439   15.5   71  1  Plymouth Satellite Custom
17.0 6 250.0   100.0   3329   15.5   71  1  Chevrolet Chevelle Malibu
19.0 6 250.0   88.00   3302   15.5   71  1  Ford Torino 500
18.0 6 232.0   100.0   3288   15.5   71  1  AMC Matador
14.0 8 350.0   165.0   4209   12.0   71  1  Chevrolet Impala
14.0 8 400.0   175.0   4464   11.5   71  1  Pontiac Catalina Brougham
14.0 8 351.0   153.0   4154   13.5   71  1  Ford Galaxie 500
14.0 8 318.0   150.0   4096   13.0   71  1  Plymouth Fury III
12.0 8 383.0   180.0   4955   11.5   71  1  Dodge Monaco (SW)
13.0 8 400.0   170.0   4746   12.0   71  1  Ford Country Squire (SW)
13.0 8 400.0   175.0   5140   12.0   71  1  Pontiac Safari (SW)
18.0 6 258.0   110.0   2962   13.5   71  1  AMC Hornet Sportabout (SW)
22.0 4 140.0   72.00   2408   19.0   71  1  Chevrolet Vega (SW)
19.0 6 250.0   100.0   3282   15.0   71  1  Pontiac Firebird
18.0 6 250.0   88.00   3139   14.5   71  1  Ford Mustang
23.0 4 122.0   86.00   2220   14.0   71  1  Mercury Capri 2000
28.0 4 116.0   90.00   2123   14.0   71  2  Opel 1900
30.0 4 79.00   70.00   2074   19.5   71  2  Peugeot 304
30.0 4 88.00   76.00   2065   14.5   71  2  Fiat 124b
31.0 4 71.00   65.00   1773   19.0   71  3  Toyota Corolla 1200
35.0 4 72.00   69.00   1613   18.0   71  3  Datsun 1200
27.0 4 97.00   60.00   1834   19.0   71  2  Volkswagen Model 111
26.0 4 91.00   70.00   1955   20.5   71  1  Plymouth Cricket
24.0 4 113.0   95.00   2278   15.5   72  3  Toyota Corona Hardtop
25.0 4 97.50   80.00   2126   17.0   72  1  Dodge Colt Hardtop
23.0 4 97.00   54.00   2254   23.5   72  2  Volkswagen Type 3
20.0 4 140.0   90.00   2408   19.5   72  1  Chevrolet Vega
21.0 4 122.0   86.00   2226   16.5   72  1  Ford Pinto Runabout
13.0 8 350.0   165.0   4274   12.0   72  1  Chevrolet Impala
14.0 8 400.0   175.0   4385   12.0   72  1  Pontiac Catalina
15.0 8 318.0   150.0   4135   13.5   72  1  Plymouth Fury III
14.0 8 351.0   153.0   4129   13.0   72  1  Ford Galaxie 500
17.0 8 304.0   150.0   3672   11.5   72  1  AMC Ambassador SST
11.0 8 429.0   208.0   4633   11.0   72  1  Mercury Marquis
13.0 8 350.0   155.0   4502   13.5   72  1  Buick Lesabre Custom
12.0 8 350.0   160.0   4456   13.5   72  1  Oldsmobile Delta 88 Royale
13.0 8 400.0   190.0   4422   12.5   72  1  Chrysler Newport Royal
19.0 3 70.00   97.00   2330   13.5   72  3  Mazda Rx2 Coupe
15.0 8 304.0   150.0   3892   12.5   72  1  AMC Matador (SW)
13.0 8 307.0   130.0   4098   14.0   72  1  Chevrolet Chevelle Concours (SW)
13.0 8 302.0   140.0   4294   16.0   72  1  Ford Gran Torino (SW)
14.0 8 318.0   150.0   4077   14.0   72  1  Plymouth Satellite Custom (SW)
18.0 4 121.0   112.0   2933   14.5   72  2  Volvo 145e (SW)
22.0 4 121.0   76.00   2511   18.0   72  2  Volkswagen 411 (SW)
21.0 4 120.0   87.00   2979   19.5   72  2  Peugeot 504 (SW)
26.0 4 96.00   69.00   2189   18.0   72  2  Renault 12 (SW)
22.0 4 122.0   86.00   2395   16.0   72  1  Ford Pinto (SW)
28.0 4 97.00   92.00   2288   17.0   72  3  Datsun 510 (SW)
23.0 4 120.0   97.00   2506   14.5   72  3  Toyota Corona Mark II (SW)
28.0 4 98.00   80.00   2164   15.0   72  1  Dodge Colt (SW)
27.0 4 97.00   88.00   2100   16.5   72  3  Toyota Corolla 1600 (SW)
13.0 8 350.0   175.0   4100   13.0   73  1  Buick Century 350
14.0 8 304.0   150.0   3672   11.5   73  1  AMC Matador
13.0 8 350.0   145.0   3988   13.0   73  1  Chevrolet Malibu
14.0 8 302.0   137.0   4042   14.5   73  1  Ford Gran Torino
15.0 8 318.0   150.0   3777   12.5   73  1  Dodge Coronet Custom
12.0 8 429.0   198.0   4952   11.5   73  1  Mercury Marquis Brougham
13.0 8 400.0   150.0   4464   12.0   73  1  Chevrolet Caprice Classic
13.0 8 351.0   158.0   4363   13.0   73  1  Ford Ltd
14.0 8 318.0   150.0   4237   14.5   73  1  Plymouth Fury Gran Sedan
13.0 8 440.0   215.0   4735   11.0   73  1  Chrysler New Yorker Brougham
12.0 8 455.0   225.0   4951   11.0   73  1  Buick Electra 225 Custom
13.0 8 360.0   175.0   3821   11.0   73  1  AMC Ambassador Brougham
18.0 6 225.0   105.0   3121   16.5   73  1  Plymouth Valiant
16.0 6 250.0   100.0   3278   18.0   73  1  Chevrolet Nova Custom
18.0 6 232.0   100.0   2945   16.0   73  1  AMC Hornet
18.0 6 250.0   88.00   3021   16.5   73  1  Ford Maverick
23.0 6 198.0   95.00   2904   16.0   73  1  Plymouth Duster
26.0 4 97.00   46.00   1950   21.0   73  2  Volkswagen Super Beetle
11.0 8 400.0   150.0   4997   14.0   73  1  Chevrolet Impala
12.0 8 400.0   167.0   4906   12.5   73  1  Ford Country
13.0 8 360.0   170.0   4654   13.0   73  1  Plymouth Custom Suburb
12.0 8 350.0   180.0   4499   12.5   73  1  Oldsmobile Vista Cruiser
18.0 6 232.0   100.0   2789   15.0   73  1  AMC Gremlin
20.0 4 97.00   88.00   2279   19.0   73  3  Toyota Carina
21.0 4 140.0   72.00   2401   19.5   73  1  Chevrolet Vega
22.0 4 108.0   94.00   2379   16.5   73  3  Datsun 610
18.0 3 70.00   90.00   2124   13.5   73  3  Mazda RX3
19.0 4 122.0   85.00   2310   18.5   73  1  Ford Pinto
21.0 6 155.0   107.0   2472   14.0   73  1  Mercury Capri V6
26.0 4 98.00   90.00   2265   15.5   73  2  Fiat 124 Sport Coupe
15.0 8 350.0   145.0   4082   13.0   73  1  Chevrolet Monte Carlo S
16.0 8 400.0   230.0   4278   9.50   73  1  Pontiac Grand Prix
29.0 4 68.00   49.00   1867   19.5   73  2  Fiat 128
24.0 4 116.0   75.00   2158   15.5   73  2  Opel Manta
20.0 4 114.0   91.00   2582   14.0   73  2  Audi 100LS
19.0 4 121.0   112.0   2868   15.5   73  2  Volvo 144EA
15.0 8 318.0   150.0   3399   11.0   73  1  Dodge Dart Custom
24.0 4 121.0   110.0   2660   14.0   73  2  Saab 99LE
20.0 6 156.0   122.0   2807   13.5   73  3  Toyota Mark II
11.0 8 350.0   180.0   3664   11.0   73  1  Oldsmobile Omega
20.0 6 198.0   95.00   3102   16.5   74  1  Plymouth Duster
21.0 6 200.0   .       2875   17.0   74  1  Ford Maverick
19.0 6 232.0   100.0   2901   16.0   74  1  AMC Hornet
15.0 6 250.0   100.0   3336   17.0   74  1  Chevrolet Nova
31.0 4 79.00   67.00   1950   19.0   74  3  Datsun B210
26.0 4 122.0   80.00   2451   16.5   74  1  Ford Pinto
32.0 4 71.00   65.00   1836   21.0   74  3  Toyota Corolla 1200
25.0 4 140.0   75.00   2542   17.0   74  1  Chevrolet Vega
16.0 6 250.0   100.0   3781   17.0   74  1  Chevrolet Chevelle Malibu Classic
16.0 6 258.0   110.0   3632   18.0   74  1  AMC Matador
18.0 6 225.0   105.0   3613   16.5   74  1  Plymouth Satellite Sebring
16.0 8 302.0   140.0   4141   14.0   74  1  Ford Gran Torino
13.0 8 350.0   150.0   4699   14.5   74  1  Buick Century Luxus (SW)
14.0 8 318.0   150.0   4457   13.5   74  1  Dodge Coronet Custom (SW)
14.0 8 302.0   140.0   4638   16.0   74  1  Ford Gran Torino (SW)
14.0 8 304.0   150.0   4257   15.5   74  1  AMC Matador (SW)
29.0 4 98.00   83.00   2219   16.5   74  2  Audi Fox
26.0 4 79.00   67.00   1963   15.5   74  2  Volkswagen Dasher
26.0 4 97.00   78.00   2300   14.5   74  2  Opel Manta
31.0 4 76.00   52.00   1649   16.5   74  3  Toyota Corona
32.0 4 83.00   61.00   2003   19.0   74  3  Datsun 710
28.0 4 90.00   75.00   2125   14.5   74  1  Dodge Colt
24.0 4 90.00   75.00   2108   15.5   74  2  Fiat 128
26.0 4 116.0   75.00   2246   14.0   74  2  Fiat 124 TC
24.0 4 120.0   97.00   2489   15.0   74  3  Honda Civic
26.0 4 108.0   93.00   2391   15.5   74  3  Subaru
31.0 4 79.00   67.00   2000   16.0   74  2  Fiat X1.9
19.0 6 225.0   95.00   3264   16.0   75  1  Plymouth Valiant Custom
18.0 6 250.0   105.0   3459   16.0   75  1  Chevrolet Nova
15.0 6 250.0   72.00   3432   21.0   75  1  Mercury Monarch
15.0 6 250.0   72.00   3158   19.5   75  1  Ford Maverick
16.0 8 400.0   170.0   4668   11.5   75  1  Pontiac Catalina
15.0 8 350.0   145.0   4440   14.0   75  1  Chevrolet Bel Air
16.0 8 318.0   150.0   4498   14.5   75  1  Plymouth Grand Fury
14.0 8 351.0   148.0   4657   13.5   75  1  Ford LTD
17.0 6 231.0   110.0   3907   21.0   75  1  Buick Century
16.0 6 250.0   105.0   3897   18.5   75  1  Chevrolet Chevelle Malibu
15.0 6 258.0   110.0   3730   19.0   75  1  AMC Matador
18.0 6 225.0   95.00   3785   19.0   75  1  Plymouth Fury
21.0 6 231.0   110.0   3039   15.0   75  1  Buick Skyhawk
20.0 8 262.0   110.0   3221   13.5   75  1  Chevrolet Monza 2+2
13.0 8 302.0   129.0   3169   12.0   75  1  Ford Mustang II
29.0 4 97.00   75.00   2171   16.0   75  3  Toyota Corolla
23.0 4 140.0   83.00   2639   17.0   75  1  Ford Pinto
20.0 6 232.0   100.0   2914   16.0   75  1  AMC Gremlin
23.0 4 140.0   78.00   2592   18.5   75  1  Pontiac Astro
24.0 4 134.0   96.00   2702   13.5   75  3  Toyota Corona
25.0 4 90.00   71.00   2223   16.5   75  2  Volkswagen Dasher
24.0 4 119.0   97.00   2545   17.0   75  3  Datsun 710
18.0 6 171.0   97.00   2984   14.5   75  1  Ford Pinto
29.0 4 90.00   70.00   1937   14.0   75  2  Volkswagen Rabbit
19.0 6 232.0   90.00   3211   17.0   75  1  AMC Pacer
23.0 4 115.0   95.00   2694   15.0   75  2  Audi 100LS
23.0 4 120.0   88.00   2957   17.0   75  2  Peugeot 504
22.0 4 121.0   98.00   2945   14.5   75  2  Volvo 244DL
25.0 4 121.0   115.0   2671   13.5   75  2  Saab 99LE
33.0 4 91.00   53.00   1795   17.5   75  3  Honda Civic Cvcc
28.0 4 107.0   86.00   2464   15.5   76  2  Fiat 131
25.0 4 116.0   81.00   2220   16.9   76  2  Opel 1900
25.0 4 140.0   92.00   2572   14.9   76  1  Capri II
26.0 4 98.00   79.00   2255   17.7   76  1  Dodge Colt
27.0 4 101.0   83.00   2202   15.3   76  2  Renault 12TL
17.5 8 305.0   140.0   4215   13.0   76  1  Chevrolet Chevelle Malibu Classic
16.0 8 318.0   150.0   4190   13.0   76  1  Dodge Coronet Brougham
15.5 8 304.0   120.0   3962   13.9   76  1  AMC Matador
14.5 8 351.0   152.0   4215   12.8   76  1  Ford Gran Torino
22.0 6 225.0   100.0   3233   15.4   76  1  Plymouth Valiant
22.0 6 250.0   105.0   3353   14.5   76  1  Chevrolet Nova
24.0 6 200.0   81.00   3012   17.6   76  1  Ford Maverick
22.5 6 232.0   90.00   3085   17.6   76  1  AMC Hornet
29.0 4 85.00   52.00   2035   22.2   76  1  Chevrolet Chevette
24.5 4 98.00   60.00   2164   22.1   76  1  Chevrolet Woody
29.0 4 90.00   70.00   1937   14.2   76  2  VW Rabbit
33.0 4 91.00   53.00   1795   17.4   76  3  Honda Civic
20.0 6 225.0   100.0   3651   17.7   76  1  Dodge Aspen SE
18.0 6 250.0   78.00   3574   21.0   76  1  Ford Granada Ghia
18.5 6 250.0   110.0   3645   16.2   76  1  Pontiac Ventura SJ
17.5 6 258.0   95.00   3193   17.8   76  1  AMC Pacer D/L
29.5 4 97.00   71.00   1825   12.2   76  2  Volkswagen Rabbit
32.0 4 85.00   70.00   1990   17.0   76  3  Datsun B-210
28.0 4 97.00   75.00   2155   16.4   76  3  Toyota Corolla
26.5 4 140.0   72.00   2565   13.6   76  1  Ford Pinto
20.0 4 130.0   102.0   3150   15.7   76  2  Volvo 245
13.0 8 318.0   150.0   3940   13.2   76  1  Plymouth Volare Premier V8
19.0 4 120.0   88.00   3270   21.9   76  2  Peugeot 504
19.0 6 156.0   108.0   2930   15.5   76  3  Toyota Mark II
16.5 6 168.0   120.0   3820   16.7   76  2  Mercedes-Benz 280s
16.5 8 350.0   180.0   4380   12.1   76  1  Cadillac Seville
13.0 8 350.0   145.0   4055   12.0   76  1  Chevy C10
13.0 8 302.0   130.0   3870   15.0   76  1  Ford F108
13.0 8 318.0   150.0   3755   14.0   76  1  Dodge D100
31.5 4 98.00   68.00   2045   18.5   77  3  Honda Accord CVCC
30.0 4 111.0   80.00   2155   14.8   77  1  Buick Opel Isuzu Deluxe
36.0 4 79.00   58.00   1825   18.6   77  2  Renault 5 GTL
25.5 4 122.0   96.00   2300   15.5   77  1  Plymouth Arrow GS
33.5 4 85.00   70.00   1945   16.8   77  3  Datsun F-10 Hatchback
17.5 8 305.0   145.0   3880   12.5   77  1  Chevrolet Caprice Classic
17.0 8 260.0   110.0   4060   19.0   77  1  Oldsmobile Cutlass Supreme
15.5 8 318.0   145.0   4140   13.7   77  1  Dodge Monaco Brougham
15.0 8 302.0   130.0   4295   14.9   77  1  Mercury Cougar Brougham
17.5 6 250.0   110.0   3520   16.4   77  1  Chevrolet Concours
20.5 6 231.0   105.0   3425   16.9   77  1  Buick Skylark
19.0 6 225.0   100.0   3630   17.7   77  1  Plymouth Volare Custom
18.5 6 250.0   98.00   3525   19.0   77  1  Ford Granada
16.0 8 400.0   180.0   4220   11.1   77  1  Pontiac Grand Prix LJ
15.5 8 350.0   170.0   4165   11.4   77  1  Chevrolet Monte Carlo Landau
15.5 8 400.0   190.0   4325   12.2   77  1  Chrysler Cordoba
16.0 8 351.0   149.0   4335   14.5   77  1  Ford Thunderbird
29.0 4 97.00   78.00   1940   14.5   77  2  Volkswagen Rabbit Custom
24.5 4 151.0   88.00   2740   16.0   77  1  Pontiac Sunbird Coupe
26.0 4 97.00   75.00   2265   18.2   77  3  Toyota Corolla Liftback
25.5 4 140.0   89.00   2755   15.8   77  1  Ford Mustang II 2+2
30.5 4 98.00   63.00   2051   17.0   77  1  Chevrolet Chevette
33.5 4 98.00   83.00   2075   15.9   77  1  Dodge Colt M/M
30.0 4 97.00   67.00   1985   16.4   77  3  Subaru DL
30.5 4 97.00   78.00   2190   14.1   77  2  Volkswagen Dasher
22.0 6 146.0   97.00   2815   14.5   77  3  Datsun 810
21.5 4 121.0   110.0   2600   12.8   77  2  BMW 320i
21.5 3 80.00   110.0   2720   13.5   77  3  Mazda RX-4
43.1 4 90.00   48.00   1985   21.5   78  2  Volkswagen Rabbit Custom Diesel
36.1 4 98.00   66.00   1800   14.4   78  1  Ford Fiesta
32.8 4 78.00   52.00   1985   19.4   78  3  Mazda GLC Deluxe
39.4 4 85.00   70.00   2070   18.6   78  3  Datsun B210 GX
36.1 4 91.00   60.00   1800   16.4   78  3  Honda Civic CVCC
19.9 8 260.0   110.0   3365   15.5   78  1  Oldsmobile Cutlass Salon Brougham
19.4 8 318.0   140.0   3735   13.2   78  1  Dodge Diplomat
20.2 8 302.0   139.0   3570   12.8   78  1  Mercury Monarch Ghia
19.2 6 231.0   105.0   3535   19.2   78  1  Pontiac Phoenix LJ
20.5 6 200.0   95.00   3155   18.2   78  1  Chevrolet Malibu
20.2 6 200.0   85.00   2965   15.8   78  1  Ford Fairmont (Auto)
25.1 4 140.0   88.00   2720   15.4   78  1  Ford Fairmont (Man)
20.5 6 225.0   100.0   3430   17.2   78  1  Plymouth Volare
19.4 6 232.0   90.00   3210   17.2   78  1  AMC Concord
20.6 6 231.0   105.0   3380   15.8   78  1  Buick Century Special
20.8 6 200.0   85.00   3070   16.7   78  1  Mercury Zephyr
18.6 6 225.0   110.0   3620   18.7   78  1  Dodge Aspen
18.1 6 258.0   120.0   3410   15.1   78  1  AMC Concord D/L
19.2 8 305.0   145.0   3425   13.2   78  1  Chevrolet Monte Carlo Landau
17.7 6 231.0   165.0   3445   13.4   78  1  Buick Regal Sport Coupe (Turbo)
18.1 8 302.0   139.0   3205   11.2   78  1  Ford Futura
17.5 8 318.0   140.0   4080   13.7   78  1  Dodge Magnum XE
30.0 4 98.00   68.00   2155   16.5   78  1  Chevrolet Chevette
27.5 4 134.0   95.00   2560   14.2   78  3  Toyota Corona
27.2 4 119.0   97.00   2300   14.7   78  3  Datsun 510
30.9 4 105.0   75.00   2230   14.5   78  1  Dodge Omni
21.1 4 134.0   95.00   2515   14.8   78  3  Toyota Celica Gt Liftback
23.2 4 156.0   105.0   2745   16.7   78  1  Plymouth Sapporo
23.8 4 151.0   85.00   2855   17.6   78  1  Oldsmobile Starfire SX
23.9 4 119.0   97.00   2405   14.9   78  3  Datsun 200-SX
20.3 5 131.0   103.0   2830   15.9   78  2  Audi 5000
17.0 6 163.0   125.0   3140   13.6   78  2  Volvo 264GL
21.6 4 121.0   115.0   2795   15.7   78  2  Saab 99GLE
16.2 6 163.0   133.0   3410   15.8   78  2  Peugeot 604SL
31.5 4 89.00   71.00   1990   14.9   78  2  Volkswagen Scirocco
29.5 4 98.00   68.00   2135   16.6   78  3  Honda Accord LX
21.5 6 231.0   115.0   3245   15.4   79  1  Pontiac Lemans V6
19.8 6 200.0   85.00   2990   18.2   79  1  Mercury Zephyr 6
22.3 4 140.0   88.00   2890   17.3   79  1  Ford Fairmont 4
20.2 6 232.0   90.00   3265   18.2   79  1  AMC Concord DL 6
20.6 6 225.0   110.0   3360   16.6   79  1  Dodge Aspen 6
17.0 8 305.0   130.0   3840   15.4   79  1  Chevrolet Caprice Classic
17.6 8 302.0   129.0   3725   13.4   79  1  Ford Ltd Landau
16.5 8 351.0   138.0   3955   13.2   79  1  Mercury Grand Marquis
18.2 8 318.0   135.0   3830   15.2   79  1  Dodge St. Regis
16.9 8 350.0   155.0   4360   14.9   79  1  Buick Estate Wagon (SW)
15.5 8 351.0   142.0   4054   14.3   79  1  Ford Country Squire (SW)
19.2 8 267.0   125.0   3605   15.0   79  1  Chevrolet Malibu Classic (SW)
18.5 8 360.0   150.0   3940   13.0   79  1  Chrysler Lebaron Town & Country (SW)
31.9 4 89.00   71.00   1925   14.0   79  2  VW Rabbit Custom
34.1 4 86.00   65.00   1975   15.2   79  3  Maxda GLC Deluxe
35.7 4 98.00   80.00   1915   14.4   79  1  Dodge Colt Hatchback Custom
27.4 4 121.0   80.00   2670   15.0   79  1  AMC Spirit DL
25.4 5 183.0   77.00   3530   20.1   79  2  Mercedes Benz 300D
23.0 8 350.0   125.0   3900   17.4   79  1  Cadillac Eldorado
27.2 4 141.0   71.00   3190   24.8   79  2  Peugeot 504
23.9 8 260.0   90.00   3420   22.2   79  1  Oldsmobile Cutlass Salon Brougham
34.2 4 105.0   70.00   2200   13.2   79  1  Plymouth Horizon
34.5 4 105.0   70.00   2150   14.9   79  1  Plymouth Horizon TC3
31.8 4 85.00   65.00   2020   19.2   79  3  Datsun 210
37.3 4 91.00   69.00   2130   14.7   79  2  Fiat Strada Custom
28.4 4 151.0   90.00   2670   16.0   79  1  Buick Skylark Limited
28.8 6 173.0   115.0   2595   11.3   79  1  Chevrolet Citation
26.8 6 173.0   115.0   2700   12.9   79  1  Oldsmobile Omega Brougham
33.5 4 151.0   90.00   2556   13.2   79  1  Pontiac Phoenix
41.5 4 98.00   76.00   2144   14.7   80  2  VW Rabbit
38.1 4 89.00   60.00   1968   18.8   80  3  Toyota Corolla Tercel
32.1 4 98.00   70.00   2120   15.5   80  1  Chevrolet Chevette
37.2 4 86.00   65.00   2019   16.4   80  3  Datsun 310
28.0 4 151.0   90.00   2678   16.5   80  1  Chevrolet Citation
26.4 4 140.0   88.00   2870   18.1   80  1  Ford Fairmont
24.3 4 151.0   90.00   3003   20.1   80  1  AMC Concord
19.1 6 225.0   90.00   3381   18.7   80  1  Dodge Aspen
34.3 4 97.00   78.00   2188   15.8   80  2  Audi 4000
29.8 4 134.0   90.00   2711   15.5   80  3  Toyota Corona Liftback
31.3 4 120.0   75.00   2542   17.5   80  3  Mazda 626
37.0 4 119.0   92.00   2434   15.0   80  3  Datsun 510 Hatchback
32.2 4 108.0   75.00   2265   15.2   80  3  Toyota Corolla
46.6 4 86.00   65.00   2110   17.9   80  3  Mazda GLC
27.9 4 156.0   105.0   2800   14.4   80  1  Dodge Colt
40.8 4 85.00   65.00   2110   19.2   80  3  Datsun 210
44.3 4 90.00   48.00   2085   21.7   80  2  VW Rabbit C (Diesel)
43.4 4 90.00   48.00   2335   23.7   80  2  VW Dasher (Diesel)
36.4 5 121.0   67.00   2950   19.9   80  2  Audi 5000s (Diesel)
30.0 4 146.0   67.00   3250   21.8   80  2  Mercedes-Benz 240D
44.6 4 91.00   67.00   1850   13.8   80  3  Honda Civic 1500 GL
40.9 4 85.00   .       1835   17.3   80  2  Renault Le Car Deluxe
33.8 4 97.00   67.00   2145   18.0   80  3  Subaru DL
29.8 4 89.00   62.00   1845   15.3   80  2  Vokswagen Rabbit
32.7 6 168.0   132.0   2910   11.4   80  3  Datsun 280-ZX
23.7 3 70.00   100.0   2420   12.5   80  3  Mazda Rx-7 GS
35.0 4 122.0   88.00   2500   15.1   80  2  Triumph Tr7 Coupe
23.6 4 140.0   .       2905   14.3   80  1  Ford Mustang Cobra
32.4 4 107.0   72.00   2290   17.0   80  3  Honda Accord
27.2 4 135.0   84.00   2490   15.7   81  1  Plymouth Reliant
26.6 4 151.0   84.00   2635   16.4   81  1  Buick Skylark
25.8 4 156.0   92.00   2620   14.4   81  1  Dodge Aries Wagon (SW)
23.5 6 173.0   110.0   2725   12.6   81  1  Chevrolet Citation
30.0 4 135.0   84.00   2385   12.9   81  1  Plymouth Reliant
39.1 4 79.00   58.00   1755   16.9   81  3  Toyota Starlet
39.0 4 86.00   64.00   1875   16.4   81  1  Plymouth Champ
35.1 4 81.00   60.00   1760   16.1   81  3  Honda Civic 1300
32.3 4 97.00   67.00   2065   17.8   81  3  Subaru
37.0 4 85.00   65.00   1975   19.4   81  3  Datsun 210 MPG
37.7 4 89.00   62.00   2050   17.3   81  3  Toyota Tercel
34.1 4 91.00   68.00   1985   16.0   81  3  Mazda GLC 4
34.7 4 105.0   63.00   2215   14.9   81  1  Plymouth Horizon 4
34.4 4 98.00   65.00   2045   16.2   81  1  Ford Escort 4W
29.9 4 98.00   65.00   2380   20.7   81  1  Ford Escort 2H
33.0 4 105.0   74.00   2190   14.2   81  2  Volkswagen Jetta
34.5 4 100.0   .       2320   15.8   81  2  Renault 18I
33.7 4 107.0   75.00   2210   14.4   81  3  Honda Prelude
32.4 4 108.0   75.00   2350   16.8   81  3  Toyota Corolla
32.9 4 119.0   100.0   2615   14.8   81  3  Datsun 200SX
31.6 4 120.0   74.00   2635   18.3   81  3  Mazda 626
28.1 4 141.0   80.00   3230   20.4   81  2  Peugeot 505S Turbo Diesel
30.7 6 145.0   76.00   3160   19.6   81  2  Volvo Diesel
25.4 6 168.0   116.0   2900   12.6   81  3  Toyota Cressida
24.2 6 146.0   120.0   2930   13.8   81  3  Datsun 810 Maxima
22.4 6 231.0   110.0   3415   15.8   81  1  Buick Century
26.6 8 350.0   105.0   3725   19.0   81  1  Oldsmobile Cutlass LS
20.2 6 200.0   88.00   3060   17.1   81  1  Ford Granada GL
17.6 6 225.0   85.00   3465   16.6   81  1  Chrysler Lebaron Salon
28.0 4 112.0   88.00   2605   19.6   82  1  Chevrolet Cavalier
27.0 4 112.0   88.00   2640   18.6   82  1  Chevrolet Cavalier Wagon
34.0 4 112.0   88.00   2395   18.0   82  1  Chevrolet Cavalier 2-Door
31.0 4 112.0   85.00   2575   16.2   82  1  Pontiac J2000 SE Hatchback
29.0 4 135.0   84.00   2525   16.0   82  1  Dodge Aries SE
27.0 4 151.0   90.00   2735   18.0   82  1  Pontiac Phoenix
24.0 4 140.0   92.00   2865   16.4   82  1  Ford Fairmont Futura
23.0 4 151.0   .       3035   20.5   82  1  AMC Concord DL
36.0 4 105.0   74.00   1980   15.3   82  2  Volkswagen Rabbit L
37.0 4 91.00   68.00   2025   18.2   82  3  Mazda GLC Custom L
31.0 4 91.00   68.00   1970   17.6   82  3  Mazda GLC Custom
38.0 4 105.0   63.00   2125   14.7   82  1  Plymouth Horizon Miser
36.0 4 98.00   70.00   2125   17.3   82  1  Mercury Lynx L
36.0 4 120.0   88.00   2160   14.5   82  3  Nissan Stanza XE
36.0 4 107.0   75.00   2205   14.5   82  3  Honda Accord
34.0 4 108.0   70.00   2245   16.9   82  3  Toyota Corolla
38.0 4 91.00   67.00   1965   15.0   82  3  Honda Civic
32.0 4 91.00   67.00   1965   15.7   82  3  Honda Civic (Auto)
38.0 4 91.00   67.00   1995   16.2   82  3  Datsun 310 GX
25.0 6 181.0   110.0   2945   16.4   82  1  Buick Century Limited
38.0 6 262.0   85.00   3015   17.0   82  1  Oldsmobile Cutlass Ciera (Diesel)
26.0 4 156.0   92.00   2585   14.5   82  1  Chrysler Lebaron Medallion
22.0 6 232.0   112.0   2835   14.7   82  1  Ford Granada L
32.0 4 144.0   96.00   2665   13.9   82  3  Toyota Celica GT
36.0 4 135.0   84.00   2370   13.0   82  1  Dodge Charger 2.2
27.0 4 151.0   90.00   2950   17.3   82  1  Chevrolet Camaro
27.0 4 140.0   86.00   2790   15.6   82  1  Ford Mustang GL
44.0 4 97.00   52.00   2130   24.6   82  2  VW Pickup
32.0 4 135.0   84.00   2295   11.6   82  1  Dodge Rampage
28.0 4 120.0   79.00   2625   18.6   82  1  Ford Ranger
31.0 4 119.0   82.00   2720   19.4   82  1  Chevy S-10
;

ods graphics on;

proc adaptivereg data=autompg plots=all;
   class cylinders year origin;
   model mpg = cylinders displacement horsepower
               weight acceleration year origin / additive;
run;

