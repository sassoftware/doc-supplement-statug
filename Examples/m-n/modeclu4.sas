 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MODECLU4                                            */
 /*   TITLE: MODECLUS Analysis of Birth & Death Rates            */
 /* PRODUCT: SAS                                                 */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: CLUSTER                                             */
 /*   PROCS: MODECLUS SGPLOT                                     */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Modeclus Analysis of Birth and Death Rates in 74 Countries in 1976';

data vital;
   input Country $20. Birth Death;
   datalines;
Afghanistan          52 30
Algeria              50 16
Angola               47 23
Argentina            22 10
Australia            16 8
Austria              12 13
Bangladesh           47 19
Belgium              12 12
Brazil               36 10
Bulgaria             17 10
Burma                38 15
Cameroon             42 22
Canada               16 7
Chile                22 7
China                31 11
Taiwan               26 5
Colombia             34 10
Cuba                 20 6
Czechoslovakia       19 11
Ecuador              42 11
Eqypt                39 13
Ethiopia             48 23
France               14 11
German Dem Rep       12 14
Germany, Fed Rep Of  10 12
Ghana                46 14
Greece               16 9
Guatemala            40 14
Hungary              18 12
India                36 15
Indonesia            38 16
Iran                 42 12
Iraq                 48 14
Italy                14 10
Ivory Coast          48 23
Japan                16 6
Kenya                50 14
Korea, Dem Peo Rep   43 12
Korea, Republic Of   26 6
Madagascar           47 22
Malaysia             30 6
Mexico               40 7
Morocco              47 16
Mozambique           45 18
Nepal                46 20
Netherlands          13 8
Nigeria              49 22
Pakistan             44 14
Peru                 40 13
Philippines          34 10
Poland               20 9
Portugal             19 10
Rhodesia             48 14
Romania              19 10
Saudi Arabia         49 19
South Africa         36 12
Spain                18 8
Sri Lanka            26 9
Sudan                49 17
Sweden               12 11
Switzerland          12 9
Syria                47 14
Tanzania             47 17
Thailand             34 10
Turkey               34 12
Ussr                 18 9
Uganda               48 17
United Kingdom       12 12
United States        15 9
Upper Volta          50 28
Venezuela            36 6
Vietnam              42 17
Yugoslavia           18 8
Zaire                45 18
;

proc sgplot;
   scatter y=death x=birth;
run;

proc modeclus data=vital out=out m=1 2 3 4 5 6 k=4 to 10 by 2 short;
   var birth death;
run;

proc sgplot;
   scatter y=death x=birth / markerchar=cluster;
   by _k_ _method_;
run;
