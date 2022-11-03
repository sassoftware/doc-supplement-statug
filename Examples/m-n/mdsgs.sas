
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: mdsgs                                               */
/*   TITLE: Getting Started Example for PROC MDS                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multidimensional scaling                            */
/*   PROCS: MDS                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MDS                                            */
/*    MISC:                                                     */
/****************************************************************/

title 'Analysis of Flying Mileages between Ten U.S. Cities';

ods graphics on;

proc mds data=sashelp.mileages level=absolute;
   id city;
run;
