/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CATEX2                                              */
/*   TITLE: Example 2 for PROC CATMOD                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis                           */
/*   PROCS: CATMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC CATMOD chapter          */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*----------------------------------------------------------------
 Example 2: Mean Score Response Function, r=3 Responses

                Dumping Syndrome Data
                ---------------------
 Four surgical operations for duodenal ulcers were compared
 in a clinical trial at four hospitals. The response was the
 severity of an undesirable complication called dumping
 syndrome. The operations were

      a. drainage and vagotomy
      b. 25% resection and vagotomy
      c. 50% resection and vagotomy
      d. 75% resection

 From: Grizzle, Starmer, and Koch (1969, 489-504).
----------------------------------------------------------------*/

data operate;
   input Hospital Treatment $ Severity $ wt @@;
   datalines;
1 a none 23    1 a slight  7    1 a moderate 2
1 b none 23    1 b slight 10    1 b moderate 5
1 c none 20    1 c slight 13    1 c moderate 5
1 d none 24    1 d slight 10    1 d moderate 6
2 a none 18    2 a slight  6    2 a moderate 1
2 b none 18    2 b slight  6    2 b moderate 2
2 c none 13    2 c slight 13    2 c moderate 2
2 d none  9    2 d slight 15    2 d moderate 2
3 a none  8    3 a slight  6    3 a moderate 3
3 b none 12    3 b slight  4    3 b moderate 4
3 c none 11    3 c slight  6    3 c moderate 2
3 d none  7    3 d slight  7    3 d moderate 4
4 a none 12    4 a slight  9    4 a moderate 1
4 b none 15    4 b slight  3    4 b moderate 2
4 c none 14    4 c slight  8    4 c moderate 3
4 d none 13    4 d slight  6    4 d moderate 4
;

title 'Dumping Syndrome Data';
proc catmod data=operate order=data ;
   weight wt;
   response 0  0.5  1;
   model Severity=Treatment Hospital / freq oneway design;
   title2 'Main-Effects Model';
quit;
