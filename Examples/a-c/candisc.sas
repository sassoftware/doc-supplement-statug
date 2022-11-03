 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: CANDISC                                             */
 /*   TITLE: Canonical Discriminant Analyses Of Cars Data Set    */
 /* PRODUCT: SAS/STAT                                            */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: discriminant analysis, multivariate analysis        */
 /*   PROCS: CANDISC SGPLOT                                      */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

data cars;
   input Origin $ 1-8 Make $ 10-19 Model $ 21-36
         (MPG Reliability Acceleration Braking Handling Ride
          Visibility Comfort Quiet Cargo) (1.);
   datalines;
GMC      Buick      Century         3334444544
GMC      Buick      Electra         2434453555
GMC      Buick      Lesabre         2354353545
GMC      Buick      Regal           3244443424
GMC      Buick      Riviera         2354553543
GMC      Buick      Skyhawk         3232423224
GMC      Buick      Skylark         4145555422
GMC      Chevrolet  Camaro          2254541241
GMC      Chevrolet  Caprice Classic 2445353555
GMC      Chevrolet  Chevette        5335425223
GMC      Chevrolet  Citation        4155555525
GMC      Chevrolet  Corvette        2153542242
GMC      Chevrolet  Malibu          3333444544
GMC      Chevrolet  Monte Carlo     3253353544
GMC      Chevrolet  Monza           2142233114
Chrysler Dodge      Aspen           2143333424
Chrysler Dodge      Colt Hatchback  5544445434
Chrysler Dodge      Diplomat        2153343434
Chrysler Dodge      Mirada          2143432434
Chrysler Dodge      Omni 024        4345535225
Chrysler Dodge      St Regis        1154353545
Ford     Ford       Fairmont        3324345434
Ford     Ford       Fiesta          5445344414
Ford     Ford       Granada         2233233233
Ford     Ford       Ltd             3354354555
Ford     Ford       Mustang         3244323222
Ford     Ford       Pinto           4134313222
Ford     Ford       Thunderbird     2354344444
Ford     Mercury    Bobcat          4134313212
Ford     Mercury    Capri           3154322222
Ford     Mercury    Cougar XR7      2454444444
Ford     Mercury    Marquis         3354354555
Ford     Mercury    Monarch         2353232232
Ford     Mercury    Zephyr          3124345434
GMC      Oldsmobile Cutlass         3443444544
GMC      Oldsmobile Delta 88        2435353555
GMC      Oldsmobile 98              2445353555
GMC      Oldsmobile Omega           4155555522
GMC      Oldsmobile Starfire        2133522154
GMC      Oldsmobile Toronado        3323443544
Chrysler Plymouth   Champ           5544445434
Chrysler Plymouth   Gran Fury       2134353535
Chrysler Plymouth   Horizon         4345535235
Chrysler Plymouth   Volare          2153333424
GMC      Pontiac    Bonneville      2345353555
GMC      Pontiac    Firebird        1153551231
GMC      Pontiac    Grand Prix      3224432434
GMC      Pontiac    Lemans          3333444544
GMC      Pontiac    Phoenix         4155554415
GMC      Pontiac    Sunbird         3134533234
;

proc candisc data=cars out=outcan;
   class origin;
   var acceleration handling ride visibility cargo;
run;

proc sgplot;
   scatter y=can2 x=can1 / group=origin datalabel=model;
run;
