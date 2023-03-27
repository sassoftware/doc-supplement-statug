/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SPPEX3                                              */
/*   TITLE: Documentation Example 3 for PROC SPP                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: spatial analysis, spatial point patterns            */
/*   PROCS: SPP                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SPP, EXAMPLE 3                                 */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;

proc iml;
   start Uniform2d(n, a, b);
      u = j(n, 2);
      call randgen(u, "Uniform");
      return( u # (a||b) );
   finish;

   start HomogPoissonProcess(lambda, a, b);
      n = 1;
      call randgen(n,"Poisson", lambda*2500);
      return( Uniform2d(n, a, b) );
   finish;

   start InhomogPoissonProcess(a, b) global(lambda0);
      u = HomogPoissonProcess(lambda0, a, b);
      lambda = Intensity(u[,1], u[,2]);
      r = shape(.,sum(lambda<=lambda0),1);
      call randgen(r,"Bernoulli", lambda[loc(lambda<=lambda0)]/lambda0);
      return( u[loc(r),] );
   finish;

   reset storage=sasuser.SPPThin;
   store module=Uniform2d
         module=HomogPoissonProcess
         module=InhomogPoissonProcess;
quit;

proc iml;
   %let xH = Hills[iHill,1];
   %let yH = Hills[iHill,2];
   %let hH = Hills[iHill,3];
   %let rH = Hills[iHill,4];

   start Elevation(x,y) global(Hills);
      Elevation = 0;
      do iHill = 1 to nrow(Hills);
         Height = &hH*exp(-((x - &xH)##2 + (y - &yH)##2)/&rH);
         Elevation = Elevation + Height;
      end;
      return(Elevation);
   finish;

   start Slope(x,y) global(Hills);
      xslope = 0;
      yslope = 0;
      do iHill = 1 to nrow(Hills);
         Height = &hH*exp(-((x - &xH)##2 + (y - &yH)##2)/&rH);
         dxHeight = -2*Height#(x - &xH)/&rH;
         dyHeight = -2*Height#(y - &yH)/&rH;
         xslope   = xslope + dxHeight;
         yslope   = yslope + dyHeight;
      end;
      Slope = sqrt(xslope##2 + yslope##2);
      return(Slope);
   finish;

   start Intensity(x,y) global(lambda0);
      lin = 0.5 - 2*Elevation(x,y) - 10*Slope(x,y);
      return(exp(lin));
   finish;

   lambda0 = exp(0.5);

   reset storage=sasuser.SPPFlowers;
   store lambda0 module=Elevation module=Slope module=Intensity;
quit;

proc iml;
   reset storage=sasuser.SPPThin;
   load module=Uniform2d
        module=HomogPoissonProcess
        module=InhomogPoissonProcess;

   reset storage=sasuser.SPPFlowers;
   load  module=Elevation module=Slope module=Intensity lambda0;

   a = 50;
   b = 50;

   Hills = { 9.2 48.5 0.2 13.0,
           46.1 48.5 0.3 26.6,
            2.5  3.3 0.7 26.2,
           42.7  3.4 0.9 14.9,
           13.6 34.5 1.0 11.3,
           34.4 20.6 0.3 14.4,
           23.8 42.2 0.4 29.5,
           29.1 18.9 0.5 25.3,
           46.6 46.5 0.3 14.9,
           19.6 23.6 0.5  8.4};

   call randseed(12345);

   free Cov;
   Cov = j((a+1) * (b+1), 5, 0);
   do x = 0 to a; do y = 0 to b;
      Cov[x#(a+1)+y+1,] =  (x || y || Elevation(x,y) || Slope(x,y)
                           || Intensity(x,y));
   end; end;

   create Covariates var {"x" "y" "Elevation" "Slope" "Intensity"};
   append from Cov;
   close Covariates;

   Hills = Hills // {25 5 2 15};
   z = InhomogPoissonProcess(a, b);

   create Events var {"x" "y"};
   append from z;
   close;

quit;

data simAll;
   set Events(in=e) Covariates;
   Flowers = e;
run;

proc spp data=simAll plots(equate)=(trends observations);
   process trees = (x, y /area=(0,0,50,50) Event=Flowers);
   trend grad = field(x,y, Elevation);
   trend elev = field(x,y, Slope);
run;

proc spp data=simAll seed=1  plots(equate)=(residual);
   process trees = (x,y /area=(0,0,50,50) Event=Flowers) /quadrat(4,2 /details);
   trend elev = field(x,y, Elevation);
   trend slope = field(x,y, Slope);
   model trees = elev slope/residual(b=5) gof;
run;

