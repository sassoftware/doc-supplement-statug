/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: facex6                                              */
/*   TITLE: Documentation Example 6 for PROC FACTOR             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: factor analysis                                     */
/*   PROCS: FACTOR                                              */
/****************************************************************/

/*
This example illustrates the creation and uses of path diagrams.
*/

options validvarname=any;
data jobratings;
   input ('Communication Skills'n
      'Problem Solving'n
      'Learning Ability'n
      'Judgment under Pressure'n
      'Observational Skills'n
      'Willingness to Confront Problems'n
      'Interest in People'n
      'Interpersonal Sensitivity'n
      'Desire for Self-Improvement'n
      'Appearance'n
      'Dependability'n
      'Physical Ability'n
      'Integrity'n
      'Overall Rating'n) (1.);
   datalines;
26838853879867
74758876857667
56757863775875
67869777988997
99997798878888
89897899888799
89999889899798
87794798468886
35652335143113
89888879576867
76557899446397
97889998898989
76766677598888
77667676779677
63839932588856
25738811284915
88879966797988
87979877959679
87989975878798
99889988898888
78876765687677
88889888899899
88889988878988
67646577384776
78778788799997
76888866768667
67678665746776
33424476664855
65656765785766
54566676565866
56655566656775
88889988868887
89899999898799
98889999899899
57554776468878
53687777797887
68666716475767
78778889798997
67364767565846
77678865886767
68698955669998
55546866663886
68888999998989
97787888798999
76677899799997
44754687877787
77876678798888
76668778799797
57653634361543
76777745653656
76766665656676
88888888878789
88977888869778
58894888747886
58674565473676
76777767777777
77788878789798
98989987999868
66729911474713
98889976999988
88786856667748
77868887897889
99999986999999
46688587616886
66755778486776
87777788889797
65666656545976
73574488887687
74755556586596
76677778789797
87878746777667
86776955874877
77888767778678
65778787778997
58786887787987
65787766676778
86777875468777
67788877757777
77778967855867
67887876767777
24786585535866
46532343542533
35566766676784
11231214211211
76886588536887
57784788688589
56667766465666
66787778778898
77687998877997
76668888546676
66477987589998
86788976884597
77868765785477
99988888987888
65948933886457
99999877988898
96636736876587
98676887798968
87878877898979
88897888888788
99997899799799
99899899899899
76656399567486
;

ods graphics on;
proc factor data=jobratings(drop='Overall Rating'n)
   priors=smc rotate=quartimin;
   pathdiagram;
   pathdiagram fuzz=0.4 title='Directed Paths with Loadings Greater Than 0.4';
   pathdiagram fuzz=0.4 arrange=grip scale=0.85 notitle;
label
   'Judgment under Pressure'n ='Judgment'
   'Communication Skills'n = 'Comm Skills'
   'Interpersonal Sensitivity'n = 'Sensitivity'
   'Willingness to Confront Problems'n = 'Confront Problems'
   'Desire for Self-Improvement'n = 'Self-Improve'
   'Observational Skills'n = 'Obs Skills'
   'Dependability'n = 'Dependable';
run;
ods graphics off;

