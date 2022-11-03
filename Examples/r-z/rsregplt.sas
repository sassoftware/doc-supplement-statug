 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: RSREGPLT                                            */
 /*   TITLE: High Resolution Plot of Response Surface and Ridge  */
 /* PRODUCT: STAT GRAPH                                          */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: response surface methods, graphics                  */
 /*   PROCS: RSREG GCONTOUR                                      */
 /*    DATA: Frankel (1961), reported in Myers (1976), p. 158.   */
 /*                                                              */
  /*     REF: Myers, Raymond H. (1976), "Response Surface Metho-  */
 /*              dology", Blacksburg, Virginia: Virginia Poly-   */
 /*              technic Institute and State University.         */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

 /*
 /  The data is from a rotatable central composite design with two
 /  factor variables: the object is to find the settings of process
 /  time and temperature which maximize the yield of a chemical.
 /---------------------------------------------------------------*/
data design;
   length Position $ 1;
   input Time Temp MBT Position;
   label time = "Reaction Time (Hours)"
         temp = "Temperature (Degrees Centigrade)"
         mbt  = "Percent Yield Mercaptobenzothiazole";
   datalines;
      4.0   250   83.8  3
      4.0   250   82.0  9
      6.3   229   81.3  2
      6.3   271   83.1  2
     12.0   220   84.7  2
     12.0   250   82.4  1
     12.0   250   82.9  7
     12.0   250   81.2  6
     12.0   280   57.9  8
     17.7   229   85.3  8
     17.7   271   72.7  2
     20.0   250   81.7  2
     ;

 /*
 /  RSREG compute the predicted surface on a grid of points over
 /  the region of interest in its surface plot; output that plot
 /  in CONTOUR.  Also output the ridge of maximum predicted yield
 /  in RIDGE.
 /---------------------------------------------------------------*/

ods graphics on;
proc rsreg data=design plots=surface;
   model mbt = time temp / lackfit predict;
   ridge max outr=ridge;
   ods output contour=contour;
run;

 /*
 /  To draw arrows from the previous ridge value to the next value,
 /  you need coordinates for the base of the arrow (time0,temp0)
 /  and the head of the arrow (time1,temp1).
 /---------------------------------------------------------------*/

data ridge start;
   set ridge;
   retain time0 temp0 time1 temp1 0;
   keep time0 temp0 time1 temp1;
   time1=time;
   temp1=temp;
   if (_n_>1) then output ridge;
   time0=time;
   temp0=temp;
run;

 /*
 /  The surface plots use internal names for the X and Y grid
 /  coordinates.
 /  PROC CONTENTS shows you the names and their labels, and the
 /  next data step gives the variables more appropriate names.
 /  _X_Time and _X_Temp are the values for the design points.
 /---------------------------------------------------------------*/

proc contents data=contour;
run;
data contour(rename=(Factor1_0_1_0_0=time
                     Factor2_0_1_0_0=temp
                     Predicted0_1_0_0=pred
                     StandardError0_1_0_0=stderr));
   set contour;
run;

 /*
 /  Finally put the surface and the ridge data together.
 /---------------------------------------------------------------*/

data contour;
   merge contour ridge;
run;

 /*
 /  You can display the template that creates the Stat.RSREG.Graphics.Contour
 /  plot with this command:
 /     proc template; source Stat.RSREG.Graphics.Contour;
 /  The important parts are extracted into the MYTPL template, which
 /  is then combined with the CONTOUR data by the PROC SGRENDER call.
 /---------------------------------------------------------------*/

proc template;
define statgraph mytpl;
   BeginGraph / designWidth=540;
    entrytitle "Response Contour for MBT with Ridge of Maximum Predicted Yield";
    layout overlay / aspectratio=1
                     yaxisopts=(gridDisplay=auto_off
                                offsetmin=0 offsetmax=0
                                linearopts=(thresholdmin=0 thresholdmax=0))
                     xaxisopts=(gridDisplay=auto_off
                                offsetmin=0 offsetmax=0
                                linearopts=(thresholdmin=0 thresholdmax=0));
      contourplotparm z=stderr y=time x=temp
         / colormodel=TwoColorRamp contourtype=gradient nlevels=1 name="StdErr";
      contourplotparm z=pred y=time x=temp
         / contourtype=labeledline linelabelformat=best5. NHINT=10
           primary=true;
      scatterplot x=_X_Temp y=_X_Time / name="Design"
           markerattrs=GraphDataDefault(color=GraphOutlier:ContrastColor);
      vectorplot yorigin=time0 y=time1 xorigin=temp0 x=temp1;
      continuouslegend "StdErr" / title="Standard Error";
   endlayout;
   EndGraph;
end;
run;

proc sgrender data=contour template=mytpl;
run;

ods html close;
