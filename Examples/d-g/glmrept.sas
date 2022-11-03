 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: GLMREPT                                             */
 /*   TITLE: Analysis of Repeated Measures Design                */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: analysis of variance, repeated measures analysis    */
 /*   PROCS: GLM                                                 */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

*-----------------------------------------------------------------+
|                                                                 |
|        Multivariate Analysis of a Repeated Measures Design      |
|                                                                 |
|    Each subject receives 3 treatments, t1-t3, in random order. A|
| data step is used to code an intercept and treatment contrasts. |
| Subjects are also classified as male/female. GLM is used to test|
| treatment, sex, and treatment*sex effects.                      |
|                                                                 |
+-----------------------------------------------------------------;

title 'Multivariate Analysis of a Repeated Measures Design';

data;
   input sex $ t1-t3;
   intercep = 1;
   mean = (t1 + t2 + t3) / 3;
   t12 = t1 - t2;
   t13 = t1 - t3;
   dummy = (sex = 'M') - (sex = 'F');
   datalines;
F 1 2 4
F 2 3 1
F 2 1 3
F 1 3 2
M 1 2 4
M 2 1 5
M 2 1 3
;

proc print;
   run;

*--------------------------old way-------------------------;

proc glm;
   model t12 t13 = intercep dummy/noint; manova h=intercep;
   title2 'Test of Treatment Effect';
run; quit;

proc glm;
   class sex;
   model mean = sex;
   title2 'Test of Sex Effect';
run; quit;

proc glm;
   class sex;
   model t12 t13 = sex; manova h=sex;
   title2 'Test of Treatment by Sex Interaction';
run; quit;

*--------------------------new way-------------------------;

proc glm;
   class sex;
   model t1-t3=sex;
   repeated treatmnt 3 contrast(1);
   title2 'Repeated Measures Analysis using REPEATED Statement';
run; quit;
