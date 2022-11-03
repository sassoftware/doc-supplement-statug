/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SPPEX1                                              */
/*   TITLE: Documentation Example 1 for PROC SPP                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: spatial analysis, spatial point patterns            */
/*   PROCS: SPP                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SPP, EXAMPLE 1                                 */
/*    MISC:                                                     */
/****************************************************************/

data amacrine;
   input X Y Type $ @@;
   label Type='Cell Type';
   datalines;
0.0224   0.0243   on
0.0243   0.1028   on
0.1626   0.1477   on
0.1215   0.0729   on
0.2411   0.0486   on
0.0766   0.1776   on
0.1047   0.2579   on
0.043    0.3645   on
0.1084   0.4      on
0.1981   0.2841   on
0.2505   0.2776   on
0.2215   0.1617   on
0.3421   0.1963   on
0.2953   0.0729   on
0.3953   0.0579   on
0.4121   0.1439   on
0.3449   0.2841   on
0.3121   0.3514   on
0.0701   0.5215   on
0.0972   0.657    on
0.0757   0.7355   on
0.0299   0.872    on
0.0393   0.9869   on
0.0757   0.8252   on
0.1972   0.8617   on
0.1561   0.9411   on
0.2159   0.7757   on
0.1935   0.6533   on
0.2084   0.5458   on
0.228    0.428    on
0.3383   0.4776   on
0.315    0.5832   on
0.3467   0.5636   on
0.3449   0.3832   on
0.4318   0.3262   on
0.4804   0.2542   on
0.5243   0.1925   on
0.5215   0.1159   on
0.5075   0.0234   on
0.5991   0.0252   on
0.6393   0.1196   on
0.6402   0.2579   on
0.6262   0.3523   on
0.5748   0.3897   on
0.4617   0.4271   on
0.4813   0.4897   on
0.472    0.6822   on
0.3636   0.7551   on
0.3505   0.6953   on
0.3      0.8112   on
0.2738   0.9084   on
0.2673   0.9813   on
0.3804   0.8785   on
0.4327   0.8402   on
0.5037   0.8813   on
0.5477   0.9308   on
0.5645   0.8028   on
0.5271   0.5907   on
0.6103   0.6757   on
0.6598   0.7813   on
0.6542   0.8318   on
0.6411   0.972    on
0.7084   0.9626   on
0.7421   0.8981   on
0.7869   0.7645   on
0.7467   0.6355   on
0.6748   0.6019   on
0.6477   0.5579   on
0.614    0.472    on
0.671    0.1841   on
0.7495   0.2523   on
0.7495   0.0963   on
0.7654   0.0299   on
0.9056   0.1514   on
0.9093   0.2206   on
0.9355   0.2019   on
0.9056   0.3093   on
0.986    0.3299   on
0.943    0.428    on
0.7486   0.4047   on
0.7832   0.4084   on
0.7935   0.3234   on
0.7869   0.4953   on
0.9056   0.515    on
0.8673   0.572    on
0.8636   0.6374   on
0.8065   0.7093   on
0.8636   0.7486   on
0.8533   0.8495   on
0.8561   0.9579   on
0.9346   0.9009   on
0.9991   0.9888   on
1.0645   0.9262   on
1.0262   0.7916   on
0.9822   0.6794   on
1.029    0.5271   on
1.0673   0.4729   on
1.0869   0.5598   on
1.0981   0.6953   on
1.1607   0.7383   on
1.1093   0.8252   on
1.1617   0.9224   on
1.2832   0.8514   on
1.3103   0.9766   on
1.4234   0.9112   on
1.4738   0.829    on
1.4869   0.9916   on
1.557    0.9374   on
1.5972   0.9449   on
1.5766   0.8327   on
1.586    0.7729   on
1.4804   0.7121   on
1.4234   0.7981   on
1.3355   0.757    on
1.2206   0.7626   on
1.1402   0.6495   on
1.2477   0.6523   on
1.3645   0.6523   on
1.3776   0.5598   on
1.5467   0.6037   on
1.5794   0.628    on
1.5907   0.4598   on
1.4907   0.4963   on
1.4393   0.4477   on
1.3187   0.4766   on
1.328    0.5505   on
1.2159   0.5299   on
1.185    0.4168   on
1.1766   0.3047   on
1.2561   0.3832   on
1.285    0.2589   on
1.3449   0.3421   on
1.3748   0.3607   on
1.357    0.2262   on
1.4944   0.3467   on
1.5439   0.2589   on
1.5421   0.1626   on
1.4037   0.1841   on
1.4766   0.1318   on
1.4421   0.0318   on
1.5196   0.0393   on
1.3271   0.0579   on
1.3075   0.157    on
1.1935   0.1617   on
1.1972   0.0822   on
1.1925   0.0084   on
1.2682   0.014    on
1.0318   0.0486   on
1.0785   0.2196   on
1.0458   0.2374   on
1.0467   0.2907   on
1.0495   0.3804   on
0.072    0.0215   off
0.0766   0.1692   off
0.0944   0.2692   off
0.1523   0.3308   off
0.2065   0.3505   off
0.2486   0.2206   off
0.2355   0.1327   off
0.2112   0.0617   off
0.1589   0.0916   off
0.328    0.0206   off
0.3449   0.0785   off
0.4009   0.1121   off
0.3748   0.214    off
0.3112   0.3065   off
0.0439   0.4589   off
0.1262   0.5664   off
0.1888   0.4514   off
0.3084   0.4131   off
0.2822   0.5252   off
0.214    0.5841   off
0.2822   0.5991   off
0.228    0.7103   off
0.1262   0.6626   off
0.0112   0.8168   off
0.0346   0.9645   off
0.1262   0.8561   off
0.1598   0.9654   off
0.1916   0.8121   off
0.2738   0.8682   off
0.3449   0.9047   off
0.4084   0.8944   off
0.3832   0.772    off
0.3355   0.7327   off
0.4065   0.6692   off
0.4168   0.6028   off
0.4645   0.6991   off
0.5112   0.7187   off
0.5346   0.7682   off
0.557    0.8093   off
0.4645   0.9486   off
0.5421   0.971    off
0.6336   0.8645   off
0.7075   0.9374   off
0.7645   0.971    off
0.8299   0.8486   off
0.7533   0.8271   off
0.7262   0.7383   off
0.6308   0.6869   off
0.5308   0.6093   off
0.5243   0.5617   off
0.4383   0.4785   off
0.5271   0.3832   off
0.4187   0.3505   off
0.5374   0.2589   off
0.5112   0.1748   off
0.4953   0.1019   off
0.5037   0.0785   off
0.5598   0.0841   off
0.6336   0.0318   off
0.6121   0.1355   off
0.6159   0.3093   off
0.6355   0.4206   off
0.6187   0.5065   off
0.6748   0.571    off
0.771    0.6028   off
0.8009   0.5243   off
0.7505   0.4486   off
0.7121   0.3336   off
0.7065   0.2374   off
0.7495   0.1523   off
0.7308   0.0215   off
0.8972   0.043    off
0.8514   0.1383   off
0.8215   0.2327   off
0.8168   0.3103   off
0.9075   0.2626   off
0.8598   0.3776   off
0.9009   0.4598   off
0.8981   0.5579   off
0.7935   0.6664   off
0.8925   0.715    off
0.9009   0.9514   off
0.9953   0.886    off
0.943    0.8121   off
0.9991   0.7636   off
0.9981   0.6822   off
0.9664   0.6084   off
1.0037   0.5542   off
0.9925   0.4336   off
0.972    0.3075   off
1.0421   0.1505   off
1.0047   0.0645   off
1.0701   0.2308   off
1.1009   0.2551   off
1.0523   0.3271   off
1.1318   0.3701   off
1.0953   0.4636   off
1.1299   0.5794   off
1.1215   0.7579   off
1.1224   0.8486   off
1.0617   0.9542   off
1.2178   0.1168   off
1.2234   0.0037   off
1.3738   0.0318   off
1.329    0.1224   off
1.4495   0.0757   off
1.5439   0.0542   off
1.5841   0.1449   off
1.4262   0.1916   off
1.3252   0.2243   off
1.3944   0.2804   off
1.5028   0.2439   off
1.5178   0.3308   off
1.443    0.3841   off
1.4009   0.3486   off
1.2598   0.3037   off
1.2271   0.2252   off
1.2505   0.3364   off
1.1944   0.4421   off
1.3327   0.415    off
1.4579   0.4757   off
1.5785   0.529    off
1.5935   0.6252   off
1.4318   0.5533   off
1.3822   0.6252   off
1.3178   0.572    off
1.285    0.6514   off
1.2682   0.6925   off
1.2019   0.6589   off
1.1925   0.5822   off
1.2701   0.7505   off
1.2159   0.8654   off
1.2346   0.9374   off
1.3673   0.9411   off
1.3271   0.8374   off
1.4271   0.8748   off
1.4935   0.8346   off
1.5234   0.9953   off
1.5766   0.8187   off
1.5729   0.729    off
1.457    0.6822   off
1.4168   0.7374   off
;

proc spp data=amacrine edgecorr=on seed=1
         plots(equate)= (observations(attr=mark) K);
   process cells= (X,Y / area=(0,0,1.6,1) mark=Type)
                  / K cross=types('on' 'off');
run;