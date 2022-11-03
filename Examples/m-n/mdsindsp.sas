 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: mdsindsp                                            */
 /*   TITLE: MDS Plots of Group & Individual Configuration Spaces*/
 /* PRODUCT: stat                                                */
 /*  SYSTEM: all                                                 */
 /*    KEYS: multidimensional scaling,                           */
 /*   PROCS: mds plot                                            */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'MDS Plots of Group & Individual Configuration Spaces';
title2 'Judged Similarity of Common Computer Languages';

data language;
   input (Algol APL Assembly Basic C Cobol Fortran
          JCL Lisp Machine Matrix Pascal PLI Snobol) (1.) Subject $ 20-27;
   retain Subr '        ';
   if subject = ' ' then subject = subr; else subr = subject;
   datalines;
0                  Charlie
1
20
312
3121
30111
312623
2132122
21211111
006000000
2700221020
61112731111
711527312128
2310110111021
0                  Dave D.
4
20
537
5562
30575
752723
0701211
47114213
108433202
7824326750
76927542531
753286426216
6521642281326
0                  Wayne M.
1
11
511
5125
90142
321953
0031111
62143310
117011110
3318416010
51184441315
512854514158
6116374141477
0                  Craige
5
33
654
6834
55664
765554
1181111
56336342
229475412
4724516151
86358461636
863564616368
6534535282465
0                  Warren
3
10
433
6233
41253
422544
0010000
24002110
005101020
4703212020
83147440104
731465401057
1221120030012
0                  Dale
0
10
412
6123
41222
723754
1001122
04013111
009111122
4725223141
81224121416
812223414168
4222211131463
0                  Ed
4
40
554
7327
50244
732444
0000000
50244353
209221205
3812200041
55467362632
943685726328
4225483231055
0                  Blair
3
11
431
5422
32113
541544
2163121
32012111
001000000
5612425010
55226151004
642264510046
2101111020211
0                  John
1
00
553
5145
20354
510313
0000000
21116200
005111000
4503204010
61044440005
720556665358
2301211000112
0                  Ginger
3
60
505
9085
40244
606964
0000000
46320520
009282503
3805426063
90758580372
907586703729
4004472063755
;

proc sort data=language;
   by subject;
run;

ods graphics on;
proc mds fit=squared data=language similar=10 level=ordinal untie
   coef=diagonal out=out pfit;
   var algol--snobol;
   subject subject;
   title3 'Individual Differences Analysis with UNTIE';
run;

proc sql;
   create table inspace as  /* data set to contain individual spaces */
   select outa.dim1*outb.dim1 as indim1, /* muliply configuration ...*/
          outa.dim2*outb.dim2 as indim2, /* by dimension coeficients */
          outa._name_ as Language,       /* use nicer name           */
          outb.subject as Subject
   from out as outa, out as outb     /* join data set with itself    */
   where outa._type_='CONFIG' and    /* select group configuration   */
         outb._type_='DIAGCOEF'      /* select dimension coeficients */
   order by subject;                 /* sort by subject              */
run;

proc template;
   define statgraph plot;
      begingraph;
         entrytitle 'Individual Configuration Spaces';
         layout overlayequated / equatetype=fit;
            scatterplot y=indim2 x=indim1 / datalabel=language;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=inspace template=plot;
   by subject;
   label indim1 = 'Dimension 1' indim2 = 'Dimension 2';
run;

ods graphics off;
