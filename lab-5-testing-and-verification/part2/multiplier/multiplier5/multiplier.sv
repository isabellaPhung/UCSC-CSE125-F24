/* Generated by Yosys 0.45 (git sha1 9ed031ddd, clang++ 14.0.0-1ubuntu1.1 -fPIC -O3) */

(* top =  1  *)
(* \library  = "work" *)
(* hdlname = "multiplier" *)
(* src = "multiplier_pre.sv:1.8-1.18" *)
module multiplier(b_i, product_o, a_i);
  wire _0000_;
  wire _0001_;
  wire _0002_;
  wire _0003_;
  wire _0004_;
  wire _0005_;
  wire _0006_;
  wire _0007_;
  wire _0008_;
  wire _0009_;
  wire _0010_;
  wire _0011_;
  wire _0012_;
  wire _0013_;
  wire _0014_;
  wire _0015_;
  wire _0016_;
  wire _0017_;
  wire _0018_;
  wire _0019_;
  wire _0020_;
  wire _0021_;
  wire _0022_;
  wire _0023_;
  wire _0024_;
  wire _0025_;
  wire _0026_;
  wire _0027_;
  wire _0028_;
  wire _0029_;
  wire _0030_;
  wire _0031_;
  wire _0032_;
  wire _0033_;
  wire _0034_;
  wire _0035_;
  wire _0036_;
  wire _0037_;
  wire _0038_;
  wire _0039_;
  wire _0040_;
  wire _0041_;
  wire _0042_;
  wire _0043_;
  wire _0044_;
  wire _0045_;
  wire _0046_;
  wire _0047_;
  wire _0048_;
  wire _0049_;
  wire _0050_;
  wire _0051_;
  wire _0052_;
  wire _0053_;
  wire _0054_;
  wire _0055_;
  wire _0056_;
  wire _0057_;
  wire _0058_;
  wire _0059_;
  wire _0060_;
  wire _0061_;
  wire _0062_;
  wire _0063_;
  wire _0064_;
  wire _0065_;
  wire _0066_;
  wire _0067_;
  wire _0068_;
  wire _0069_;
  wire _0070_;
  wire _0071_;
  wire _0072_;
  wire _0073_;
  wire _0074_;
  wire _0075_;
  wire _0076_;
  wire _0077_;
  wire _0078_;
  wire _0079_;
  wire _0080_;
  wire _0081_;
  wire _0082_;
  wire _0083_;
  wire _0084_;
  wire _0085_;
  wire _0086_;
  wire _0087_;
  wire _0088_;
  wire _0089_;
  wire _0090_;
  wire _0091_;
  wire _0092_;
  wire _0093_;
  wire _0094_;
  wire _0095_;
  wire _0096_;
  wire _0097_;
  wire _0098_;
  wire _0099_;
  wire _0100_;
  wire _0101_;
  wire _0102_;
  wire _0103_;
  wire _0104_;
  wire _0105_;
  wire _0106_;
  wire _0107_;
  wire _0108_;
  wire _0109_;
  wire _0110_;
  wire _0111_;
  wire _0112_;
  wire _0113_;
  wire _0114_;
  wire _0115_;
  wire _0116_;
  wire _0117_;
  wire _0118_;
  wire _0119_;
  wire _0120_;
  wire _0121_;
  wire _0122_;
  wire _0123_;
  wire _0124_;
  wire _0125_;
  wire _0126_;
  wire _0127_;
  wire _0128_;
  wire _0129_;
  wire _0130_;
  wire _0131_;
  wire _0132_;
  wire _0133_;
  wire _0134_;
  wire _0135_;
  wire _0136_;
  wire _0137_;
  wire _0138_;
  wire _0139_;
  wire _0140_;
  wire _0141_;
  wire _0142_;
  wire _0143_;
  wire _0144_;
  wire _0145_;
  wire _0146_;
  wire _0147_;
  wire _0148_;
  wire _0149_;
  wire _0150_;
  wire _0151_;
  wire _0152_;
  wire _0153_;
  wire _0154_;
  wire _0155_;
  wire _0156_;
  wire _0157_;
  wire _0158_;
  wire _0159_;
  wire _0160_;
  wire _0161_;
  wire _0162_;
  wire _0163_;
  wire _0164_;
  wire _0165_;
  wire _0166_;
  wire _0167_;
  wire _0168_;
  wire _0169_;
  wire _0170_;
  wire _0171_;
  wire _0172_;
  wire _0173_;
  wire _0174_;
  wire _0175_;
  wire _0176_;
  wire _0177_;
  wire _0178_;
  wire _0179_;
  wire _0180_;
  wire _0181_;
  wire _0182_;
  wire _0183_;
  wire _0184_;
  wire _0185_;
  wire _0186_;
  wire _0187_;
  wire _0188_;
  wire _0189_;
  wire _0190_;
  wire _0191_;
  wire _0192_;
  wire _0193_;
  wire _0194_;
  wire _0195_;
  wire _0196_;
  wire _0197_;
  wire _0198_;
  wire _0199_;
  wire _0200_;
  wire _0201_;
  wire _0202_;
  wire _0203_;
  wire _0204_;
  wire _0205_;
  wire _0206_;
  wire _0207_;
  wire _0208_;
  wire _0209_;
  wire _0210_;
  wire _0211_;
  wire _0212_;
  wire _0213_;
  wire _0214_;
  wire _0215_;
  wire _0216_;
  wire _0217_;
  wire _0218_;
  wire _0219_;
  wire _0220_;
  wire _0221_;
  wire _0222_;
  wire _0223_;
  wire _0224_;
  wire _0225_;
  wire _0226_;
  wire _0227_;
  wire _0228_;
  wire _0229_;
  wire _0230_;
  wire _0231_;
  wire _0232_;
  wire _0233_;
  wire _0234_;
  wire _0235_;
  wire _0236_;
  wire _0237_;
  wire _0238_;
  wire _0239_;
  wire _0240_;
  wire _0241_;
  wire _0242_;
  wire _0243_;
  wire _0244_;
  wire _0245_;
  wire _0246_;
  wire _0247_;
  wire _0248_;
  wire _0249_;
  wire _0250_;
  wire _0251_;
  wire _0252_;
  wire _0253_;
  wire _0254_;
  wire _0255_;
  wire _0256_;
  wire _0257_;
  wire _0258_;
  wire _0259_;
  wire _0260_;
  wire _0261_;
  wire _0262_;
  wire _0263_;
  wire _0264_;
  wire _0265_;
  wire _0266_;
  wire _0267_;
  wire _0268_;
  wire _0269_;
  wire _0270_;
  wire _0271_;
  wire _0272_;
  wire _0273_;
  wire _0274_;
  wire _0275_;
  wire _0276_;
  wire _0277_;
  wire _0278_;
  wire _0279_;
  wire _0280_;
  wire _0281_;
  wire _0282_;
  wire _0283_;
  wire _0284_;
  wire _0285_;
  wire _0286_;
  wire _0287_;
  wire _0288_;
  wire _0289_;
  wire _0290_;
  wire _0291_;
  wire _0292_;
  wire _0293_;
  wire _0294_;
  wire _0295_;
  wire _0296_;
  wire _0297_;
  wire _0298_;
  wire _0299_;
  wire _0300_;
  wire _0301_;
  wire _0302_;
  wire _0303_;
  wire _0304_;
  wire _0305_;
  wire _0306_;
  wire _0307_;
  wire _0308_;
  wire _0309_;
  wire _0310_;
  wire _0311_;
  wire _0312_;
  wire _0313_;
  wire _0314_;
  wire _0315_;
  wire _0316_;
  wire _0317_;
  wire _0318_;
  wire _0319_;
  wire _0320_;
  wire _0321_;
  wire _0322_;
  wire _0323_;
  wire _0324_;
  wire _0325_;
  wire _0326_;
  wire _0327_;
  wire _0328_;
  wire _0329_;
  wire _0330_;
  wire _0331_;
  wire _0332_;
  wire _0333_;
  wire _0334_;
  wire _0335_;
  wire _0336_;
  wire _0337_;
  wire _0338_;
  wire _0339_;
  wire _0340_;
  wire _0341_;
  wire _0342_;
  wire _0343_;
  wire _0344_;
  wire _0345_;
  wire _0346_;
  wire _0347_;
  wire _0348_;
  wire _0349_;
  wire _0350_;
  wire _0351_;
  wire _0352_;
  wire _0353_;
  wire _0354_;
  wire _0355_;
  wire _0356_;
  wire _0357_;
  wire _0358_;
  wire _0359_;
  wire _0360_;
  wire _0361_;
  wire _0362_;
  wire _0363_;
  wire _0364_;
  wire _0365_;
  wire _0366_;
  wire _0367_;
  wire _0368_;
  wire _0369_;
  wire _0370_;
  wire _0371_;
  wire _0372_;
  wire _0373_;
  wire _0374_;
  wire _0375_;
  wire _0376_;
  wire _0377_;
  wire _0378_;
  wire _0379_;
  wire _0380_;
  wire _0381_;
  wire _0382_;
  wire _0383_;
  wire _0384_;
  wire _0385_;
  wire _0386_;
  wire _0387_;
  wire _0388_;
  wire _0389_;
  wire _0390_;
  wire _0391_;
  wire _0392_;
  wire _0393_;
  wire _0394_;
  wire _0395_;
  wire _0396_;
  wire _0397_;
  wire _0398_;
  wire _0399_;
  wire _0400_;
  wire _0401_;
  wire _0402_;
  wire _0403_;
  wire _0404_;
  wire _0405_;
  wire _0406_;
  wire _0407_;
  wire _0408_;
  wire _0409_;
  wire _0410_;
  wire _0411_;
  wire _0412_;
  wire _0413_;
  wire _0414_;
  wire _0415_;
  wire _0416_;
  wire _0417_;
  wire _0418_;
  wire _0419_;
  wire _0420_;
  wire _0421_;
  wire _0422_;
  wire _0423_;
  wire _0424_;
  wire _0425_;
  wire _0426_;
  wire _0427_;
  wire _0428_;
  wire _0429_;
  wire _0430_;
  wire _0431_;
  wire _0432_;
  wire _0433_;
  wire _0434_;
  wire _0435_;
  wire _0436_;
  wire _0437_;
  wire _0438_;
  wire _0439_;
  wire _0440_;
  wire _0441_;
  wire _0442_;
  wire _0443_;
  wire _0444_;
  wire _0445_;
  wire _0446_;
  wire _0447_;
  wire _0448_;
  wire _0449_;
  wire _0450_;
  wire _0451_;
  wire _0452_;
  wire _0453_;
  wire _0454_;
  wire _0455_;
  wire _0456_;
  wire _0457_;
  wire _0458_;
  wire _0459_;
  wire _0460_;
  wire _0461_;
  wire _0462_;
  wire _0463_;
  wire _0464_;
  wire _0465_;
  wire _0466_;
  wire _0467_;
  wire _0468_;
  wire _0469_;
  wire _0470_;
  wire _0471_;
  wire _0472_;
  wire _0473_;
  wire _0474_;
  wire _0475_;
  wire _0476_;
  wire _0477_;
  wire _0478_;
  wire _0479_;
  wire _0480_;
  wire _0481_;
  wire _0482_;
  wire _0483_;
  wire _0484_;
  wire _0485_;
  wire _0486_;
  wire _0487_;
  wire _0488_;
  wire _0489_;
  wire _0490_;
  wire _0491_;
  wire _0492_;
  wire _0493_;
  wire _0494_;
  wire _0495_;
  wire _0496_;
  wire _0497_;
  wire _0498_;
  wire _0499_;
  wire _0500_;
  wire _0501_;
  wire _0502_;
  wire _0503_;
  wire _0504_;
  wire _0505_;
  wire _0506_;
  wire _0507_;
  wire _0508_;
  wire _0509_;
  wire _0510_;
  wire _0511_;
  wire _0512_;
  wire _0513_;
  wire _0514_;
  wire _0515_;
  wire _0516_;
  wire _0517_;
  wire _0518_;
  wire _0519_;
  wire _0520_;
  wire _0521_;
  wire _0522_;
  wire _0523_;
  wire _0524_;
  wire _0525_;
  wire _0526_;
  wire _0527_;
  wire _0528_;
  wire _0529_;
  wire _0530_;
  wire _0531_;
  wire _0532_;
  wire _0533_;
  wire _0534_;
  wire _0535_;
  wire _0536_;
  wire _0537_;
  wire _0538_;
  wire _0539_;
  wire _0540_;
  wire _0541_;
  wire _0542_;
  wire _0543_;
  wire _0544_;
  wire _0545_;
  wire _0546_;
  wire _0547_;
  wire _0548_;
  wire _0549_;
  wire _0550_;
  wire _0551_;
  wire _0552_;
  wire _0553_;
  wire _0554_;
  wire _0555_;
  wire _0556_;
  wire _0557_;
  wire _0558_;
  wire _0559_;
  wire _0560_;
  wire _0561_;
  wire _0562_;
  wire _0563_;
  wire _0564_;
  wire _0565_;
  wire _0566_;
  wire _0567_;
  wire _0568_;
  wire _0569_;
  wire _0570_;
  wire _0571_;
  wire _0572_;
  wire _0573_;
  wire _0574_;
  wire _0575_;
  wire _0576_;
  wire _0577_;
  wire _0578_;
  wire _0579_;
  wire _0580_;
  wire _0581_;
  wire _0582_;
  wire _0583_;
  wire _0584_;
  wire _0585_;
  wire _0586_;
  wire _0587_;
  wire _0588_;
  wire _0589_;
  wire _0590_;
  wire _0591_;
  wire _0592_;
  wire _0593_;
  wire _0594_;
  wire _0595_;
  wire _0596_;
  wire _0597_;
  wire _0598_;
  wire _0599_;
  wire _0600_;
  wire _0601_;
  wire _0602_;
  wire _0603_;
  wire _0604_;
  wire _0605_;
  wire _0606_;
  wire _0607_;
  wire _0608_;
  wire _0609_;
  wire _0610_;
  wire _0611_;
  wire _0612_;
  wire _0613_;
  wire _0614_;
  wire _0615_;
  wire _0616_;
  wire _0617_;
  wire _0618_;
  wire _0619_;
  wire _0620_;
  wire _0621_;
  wire _0622_;
  wire _0623_;
  wire _0624_;
  wire _0625_;
  wire _0626_;
  wire _0627_;
  wire _0628_;
  wire _0629_;
  wire _0630_;
  wire _0631_;
  wire _0632_;
  wire _0633_;
  wire _0634_;
  wire _0635_;
  wire _0636_;
  wire _0637_;
  wire _0638_;
  wire _0639_;
  wire _0640_;
  wire _0641_;
  wire _0642_;
  wire _0643_;
  wire _0644_;
  wire _0645_;
  wire _0646_;
  wire _0647_;
  wire _0648_;
  wire _0649_;
  wire _0650_;
  wire _0651_;
  wire _0652_;
  wire _0653_;
  wire _0654_;
  wire _0655_;
  wire _0656_;
  wire _0657_;
  wire _0658_;
  wire _0659_;
  wire _0660_;
  wire _0661_;
  wire _0662_;
  wire _0663_;
  wire _0664_;
  wire _0665_;
  wire _0666_;
  wire _0667_;
  wire _0668_;
  wire _0669_;
  wire _0670_;
  wire _0671_;
  wire _0672_;
  wire _0673_;
  wire _0674_;
  wire _0675_;
  wire _0676_;
  wire _0677_;
  wire _0678_;
  wire _0679_;
  wire _0680_;
  wire _0681_;
  wire _0682_;
  wire _0683_;
  wire _0684_;
  wire _0685_;
  wire _0686_;
  wire _0687_;
  wire _0688_;
  wire _0689_;
  wire _0690_;
  wire _0691_;
  wire _0692_;
  wire _0693_;
  wire _0694_;
  wire _0695_;
  wire _0696_;
  wire _0697_;
  wire _0698_;
  wire _0699_;
  wire _0700_;
  wire _0701_;
  wire _0702_;
  wire _0703_;
  wire _0704_;
  wire _0705_;
  wire _0706_;
  wire _0707_;
  wire _0708_;
  wire _0709_;
  wire _0710_;
  wire _0711_;
  wire _0712_;
  wire _0713_;
  wire _0714_;
  wire _0715_;
  wire _0716_;
  wire _0717_;
  wire _0718_;
  wire _0719_;
  wire _0720_;
  wire _0721_;
  wire _0722_;
  wire _0723_;
  wire _0724_;
  wire _0725_;
  (* src = "multiplier_pre.sv:2.30-2.33" *)
  input [7:-2] a_i;
  wire [7:-2] a_i;
  (* src = "multiplier_pre.sv:7.17-7.20" *)
  wire [7:-4] a_w;
  (* src = "multiplier_pre.sv:3.30-3.33" *)
  input [6:-4] b_i;
  wire [6:-4] b_i;
  (* src = "multiplier_pre.sv:7.22-7.25" *)
  wire [7:-4] b_w;
  (* src = "multiplier_pre.sv:4.32-4.41" *)
  output [14:-6] product_o;
  wire [14:-6] product_o;
  assign _0324_ = ~(a_i[-2] & b_i[0]);
  assign _0335_ = ~(a_i[-1] & b_i[-1]);
  assign _0346_ = _0335_ ^ _0324_;
  assign _0357_ = ~(a_i[0] & b_i[-2]);
  assign _0367_ = _0357_ ^ _0346_;
  assign _0378_ = ~(a_i[-2] & b_i[-1]);
  assign _0389_ = a_i[-1] & b_i[-2];
  assign _0400_ = _0378_ | ~(_0389_);
  assign _0411_ = a_i[0] & b_i[-3];
  assign _0421_ = _0389_ ^ _0378_;
  assign _0432_ = _0411_ & ~(_0421_);
  assign _0443_ = _0400_ & ~(_0432_);
  assign _0454_ = _0443_ ^ _0367_;
  assign _0465_ = a_i[1] & b_i[-3];
  assign _0475_ = a_i[2] & b_i[-4];
  assign _0486_ = ~(_0475_ ^ _0465_);
  assign _0497_ = _0486_ ^ _0454_;
  assign _0508_ = ~_0497_;
  assign _0519_ = _0421_ ^ _0411_;
  assign _0529_ = ~(a_i[-2] & b_i[-2]);
  assign _0540_ = a_i[-1] & b_i[-3];
  assign _0551_ = _0529_ | ~(_0540_);
  assign _0562_ = a_i[0] & b_i[-4];
  assign _0573_ = _0540_ ^ _0529_;
  assign _0583_ = _0562_ & ~(_0573_);
  assign _0594_ = _0551_ & ~(_0583_);
  assign _0605_ = _0594_ | _0519_;
  assign _0615_ = a_i[1] & b_i[-4];
  assign _0626_ = ~(_0594_ ^ _0519_);
  assign _0637_ = _0615_ & ~(_0626_);
  assign _0648_ = _0605_ & ~(_0637_);
  assign _0658_ = _0648_ ^ _0508_;
  assign _0669_ = _0626_ ^ _0615_;
  assign _0679_ = _0573_ ^ _0562_;
  assign _0690_ = a_i[-2] & b_i[-3];
  assign _0701_ = a_i[-1] & b_i[-4];
  assign _0706_ = _0701_ & _0690_;
  assign _0707_ = _0706_ & ~(_0679_);
  assign _0708_ = _0707_ & ~(_0669_);
  assign product_o[-2] = ~(_0708_ ^ _0658_);
  assign _0709_ = ~(a_i[-2] & b_i[1]);
  assign _0710_ = ~(a_i[-1] & b_i[0]);
  assign _0711_ = _0710_ ^ _0709_;
  assign _0712_ = ~(a_i[0] & b_i[-1]);
  assign _0713_ = _0712_ ^ _0711_;
  assign _0714_ = _0335_ | _0324_;
  assign _0715_ = _0346_ & ~(_0357_);
  assign _0716_ = _0714_ & ~(_0715_);
  assign _0717_ = _0716_ ^ _0713_;
  assign _0718_ = a_i[1] & b_i[-2];
  assign _0719_ = a_i[2] & b_i[-3];
  assign _0720_ = _0719_ ^ _0718_;
  assign _0721_ = a_i[3] & b_i[-4];
  assign _0722_ = ~_0721_;
  assign _0723_ = _0722_ ^ _0720_;
  assign _0724_ = _0723_ ^ _0717_;
  assign _0725_ = _0443_ | _0367_;
  assign _0000_ = _0454_ & ~(_0486_);
  assign _0001_ = _0725_ & ~(_0000_);
  assign _0002_ = _0001_ ^ _0724_;
  assign _0003_ = _0475_ & _0465_;
  assign _0004_ = ~_0003_;
  assign _0005_ = _0004_ ^ _0002_;
  assign _0006_ = _0508_ & ~(_0648_);
  assign _0007_ = _0006_ ^ _0005_;
  assign _0008_ = _0708_ & ~(_0658_);
  assign product_o[-1] = ~(_0008_ ^ _0007_);
  assign _0009_ = ~(a_i[-2] & b_i[3]);
  assign _0010_ = ~(a_i[-1] & b_i[2]);
  assign _0011_ = _0010_ ^ _0009_;
  assign _0012_ = ~(a_i[0] & b_i[1]);
  assign _0013_ = _0012_ ^ _0011_;
  assign _0014_ = ~(a_i[-2] & b_i[2]);
  assign _0015_ = a_i[-1] & b_i[1];
  assign _0016_ = _0014_ | ~(_0015_);
  assign _0017_ = a_i[0] & b_i[0];
  assign _0018_ = _0015_ ^ _0014_;
  assign _0019_ = _0017_ & ~(_0018_);
  assign _0020_ = _0016_ & ~(_0019_);
  assign _0021_ = _0020_ ^ _0013_;
  assign _0022_ = a_i[1] & b_i[0];
  assign _0023_ = a_i[2] & b_i[-1];
  assign _0024_ = _0023_ ^ _0022_;
  assign _0025_ = ~(a_i[3] & b_i[-2]);
  assign _0026_ = _0025_ ^ _0024_;
  assign _0027_ = _0026_ ^ _0021_;
  assign _0028_ = ~(_0018_ ^ _0017_);
  assign _0029_ = _0710_ | _0709_;
  assign _0030_ = _0711_ & ~(_0712_);
  assign _0031_ = _0029_ & ~(_0030_);
  assign _0032_ = _0031_ | ~(_0028_);
  assign _0033_ = a_i[1] & b_i[-1];
  assign _0034_ = a_i[2] & b_i[-2];
  assign _0035_ = _0034_ ^ _0033_;
  assign _0036_ = a_i[3] & b_i[-3];
  assign _0037_ = _0036_ ^ _0035_;
  assign _0038_ = _0031_ ^ _0028_;
  assign _0039_ = _0037_ & ~(_0038_);
  assign _0040_ = _0032_ & ~(_0039_);
  assign _0041_ = _0040_ ^ _0027_;
  assign _0042_ = _0034_ & _0033_;
  assign _0043_ = _0036_ & _0035_;
  assign _0044_ = _0043_ | _0042_;
  assign _0045_ = a_i[4] & b_i[-3];
  assign _0046_ = a_i[5] & b_i[-4];
  assign _0047_ = ~(_0046_ ^ _0045_);
  assign _0048_ = _0047_ ^ _0044_;
  assign _0049_ = _0048_ ^ _0041_;
  assign _0050_ = ~(_0038_ ^ _0037_);
  assign _0051_ = _0716_ | _0713_;
  assign _0052_ = _0717_ & ~(_0723_);
  assign _0053_ = _0051_ & ~(_0052_);
  assign _0054_ = _0053_ | ~(_0050_);
  assign _0055_ = _0719_ & _0718_;
  assign _0056_ = _0720_ & ~(_0722_);
  assign _0057_ = _0056_ | _0055_;
  assign _0058_ = a_i[4] & b_i[-4];
  assign _0059_ = _0058_ ^ _0057_;
  assign _0060_ = _0053_ ^ _0050_;
  assign _0061_ = _0059_ & ~(_0060_);
  assign _0062_ = _0054_ & ~(_0061_);
  assign _0063_ = _0062_ ^ _0049_;
  assign _0064_ = _0058_ & _0057_;
  assign _0065_ = ~_0064_;
  assign _0066_ = _0065_ ^ _0063_;
  assign _0067_ = _0060_ ^ _0059_;
  assign _0068_ = _0001_ | _0724_;
  assign _0069_ = _0002_ & ~(_0004_);
  assign _0070_ = _0068_ & ~(_0069_);
  assign _0071_ = _0070_ | _0067_;
  assign _0072_ = ~(_0071_ ^ _0066_);
  assign _0073_ = ~(_0070_ ^ _0067_);
  assign _0074_ = _0006_ & ~(_0005_);
  assign _0075_ = _0074_ & ~(_0073_);
  assign _0076_ = ~(_0075_ ^ _0072_);
  assign _0077_ = _0074_ ^ _0073_;
  assign _0078_ = _0008_ & ~(_0007_);
  assign _0079_ = _0078_ & ~(_0077_);
  assign product_o[1] = _0079_ ^ _0076_;
  assign _0080_ = ~(a_i[-2] & b_i[4]);
  assign _0081_ = ~(a_i[-1] & b_i[3]);
  assign _0082_ = _0081_ ^ _0080_;
  assign _0083_ = ~(a_i[0] & b_i[2]);
  assign _0084_ = _0083_ ^ _0082_;
  assign _0085_ = _0010_ | _0009_;
  assign _0086_ = _0011_ & ~(_0012_);
  assign _0087_ = _0085_ & ~(_0086_);
  assign _0088_ = _0087_ ^ _0084_;
  assign _0089_ = ~(a_i[1] & b_i[1]);
  assign _0090_ = ~(a_i[2] & b_i[0]);
  assign _0091_ = _0090_ ^ _0089_;
  assign _0092_ = ~(a_i[3] & b_i[-1]);
  assign _0093_ = _0092_ ^ _0091_;
  assign _0094_ = _0093_ ^ _0088_;
  assign _0095_ = _0020_ | _0013_;
  assign _0096_ = _0021_ & ~(_0026_);
  assign _0097_ = _0095_ & ~(_0096_);
  assign _0098_ = _0097_ ^ _0094_;
  assign _0099_ = ~(_0023_ & _0022_);
  assign _0100_ = _0024_ & ~(_0025_);
  assign _0101_ = _0099_ & ~(_0100_);
  assign _0102_ = ~(a_i[4] & b_i[-2]);
  assign _0103_ = ~(a_i[5] & b_i[-3]);
  assign _0104_ = _0103_ ^ _0102_;
  assign _0105_ = ~(a_i[6] & b_i[-4]);
  assign _0106_ = _0105_ ^ _0104_;
  assign _0107_ = _0106_ ^ _0101_;
  assign _0108_ = _0046_ & _0045_;
  assign _0109_ = ~_0108_;
  assign _0110_ = _0109_ ^ _0107_;
  assign _0111_ = _0110_ ^ _0098_;
  assign _0112_ = _0040_ | _0027_;
  assign _0113_ = _0041_ & ~(_0048_);
  assign _0114_ = _0112_ & ~(_0113_);
  assign _0115_ = _0114_ ^ _0111_;
  assign _0116_ = _0044_ & ~(_0047_);
  assign _0117_ = _0116_ ^ _0115_;
  assign _0118_ = _0062_ | _0049_;
  assign _0119_ = _0063_ & ~(_0065_);
  assign _0120_ = _0118_ & ~(_0119_);
  assign _0121_ = _0120_ ^ _0117_;
  assign _0122_ = _0071_ | _0066_;
  assign _0123_ = ~(_0122_ ^ _0121_);
  assign _0124_ = _0075_ & ~(_0072_);
  assign _0125_ = _0079_ & _0076_;
  assign _0126_ = ~(_0125_ | _0124_);
  assign product_o[2] = _0126_ ^ _0123_;
  assign _0127_ = a_i[-2] & b_i[5];
  assign _0128_ = _0127_ ^ a_i[7];
  assign _0129_ = ~(a_i[-1] & b_i[4]);
  assign _0130_ = _0129_ ^ _0128_;
  assign _0131_ = _0081_ | _0080_;
  assign _0132_ = _0082_ & ~(_0083_);
  assign _0133_ = _0131_ & ~(_0132_);
  assign _0134_ = _0133_ ^ _0130_;
  assign _0135_ = ~(a_i[0] & b_i[3]);
  assign _0136_ = ~(a_i[1] & b_i[2]);
  assign _0137_ = _0136_ ^ _0135_;
  assign _0138_ = ~(a_i[2] & b_i[1]);
  assign _0139_ = _0138_ ^ _0137_;
  assign _0140_ = _0139_ ^ _0134_;
  assign _0141_ = _0087_ | _0084_;
  assign _0142_ = _0088_ & ~(_0093_);
  assign _0143_ = _0141_ & ~(_0142_);
  assign _0144_ = _0143_ ^ _0140_;
  assign _0145_ = _0090_ | _0089_;
  assign _0146_ = _0091_ & ~(_0092_);
  assign _0147_ = _0145_ & ~(_0146_);
  assign _0148_ = ~(a_i[3] & b_i[0]);
  assign _0149_ = ~(a_i[4] & b_i[-1]);
  assign _0150_ = _0149_ ^ _0148_;
  assign _0151_ = ~(a_i[5] & b_i[-2]);
  assign _0152_ = _0151_ ^ _0150_;
  assign _0153_ = _0152_ ^ _0147_;
  assign _0154_ = _0103_ | _0102_;
  assign _0155_ = _0104_ & ~(_0105_);
  assign _0156_ = _0154_ & ~(_0155_);
  assign _0157_ = _0156_ ^ _0153_;
  assign _0158_ = _0157_ ^ _0144_;
  assign _0159_ = _0097_ | _0094_;
  assign _0160_ = _0098_ & ~(_0110_);
  assign _0161_ = _0159_ & ~(_0160_);
  assign _0162_ = _0161_ ^ _0158_;
  assign _0163_ = _0106_ | _0101_;
  assign _0164_ = _0107_ & ~(_0109_);
  assign _0165_ = _0163_ & ~(_0164_);
  assign _0166_ = a_i[6] & b_i[-3];
  assign _0167_ = ~_0166_;
  assign _0168_ = _0167_ ^ _0165_;
  assign _0169_ = a_i[7] & ~(b_i[-4]);
  assign _0170_ = ~_0169_;
  assign _0171_ = _0170_ ^ _0168_;
  assign _0172_ = _0171_ ^ _0162_;
  assign _0173_ = _0114_ | _0111_;
  assign _0174_ = _0116_ & _0115_;
  assign _0175_ = _0173_ & ~(_0174_);
  assign _0176_ = ~(_0175_ ^ _0172_);
  assign _0177_ = _0117_ & ~(_0120_);
  assign _0178_ = _0177_ ^ _0176_;
  assign _0179_ = _0122_ | _0121_;
  assign _0180_ = ~(_0126_ | _0123_);
  assign _0181_ = _0179_ & ~(_0180_);
  assign product_o[3] = _0181_ ^ _0178_;
  assign _0182_ = a_i[-2] & b_i[6];
  assign _0183_ = a_i[-1] & b_i[5];
  assign _0184_ = _0183_ ^ _0182_;
  assign _0185_ = ~(a_i[0] & b_i[4]);
  assign _0186_ = _0185_ ^ _0184_;
  assign _0187_ = ~(_0127_ & a_i[7]);
  assign _0188_ = _0128_ & ~(_0129_);
  assign _0189_ = _0187_ & ~(_0188_);
  assign _0190_ = _0189_ ^ _0186_;
  assign _0191_ = ~(a_i[1] & b_i[3]);
  assign _0192_ = ~(a_i[2] & b_i[2]);
  assign _0193_ = _0192_ ^ _0191_;
  assign _0194_ = ~(a_i[3] & b_i[1]);
  assign _0195_ = _0194_ ^ _0193_;
  assign _0196_ = _0195_ ^ _0190_;
  assign _0197_ = _0133_ | _0130_;
  assign _0198_ = _0134_ & ~(_0139_);
  assign _0199_ = _0197_ & ~(_0198_);
  assign _0200_ = _0199_ ^ _0196_;
  assign _0201_ = _0136_ | _0135_;
  assign _0202_ = _0137_ & ~(_0138_);
  assign _0203_ = _0201_ & ~(_0202_);
  assign _0204_ = ~(a_i[4] & b_i[0]);
  assign _0205_ = a_i[5] & b_i[-1];
  assign _0206_ = ~(_0205_ ^ _0204_);
  assign _0207_ = a_i[6] & b_i[-2];
  assign _0208_ = ~_0207_;
  assign _0209_ = _0208_ ^ _0206_;
  assign _0210_ = _0209_ ^ _0203_;
  assign _0211_ = _0149_ | _0148_;
  assign _0212_ = _0150_ & ~(_0151_);
  assign _0213_ = _0211_ & ~(_0212_);
  assign _0214_ = _0213_ ^ _0210_;
  assign _0215_ = _0214_ ^ _0200_;
  assign _0216_ = _0143_ | _0140_;
  assign _0217_ = _0144_ & ~(_0157_);
  assign _0218_ = _0216_ & ~(_0217_);
  assign _0219_ = _0218_ ^ _0215_;
  assign _0220_ = _0152_ | _0147_;
  assign _0221_ = _0153_ & ~(_0156_);
  assign _0222_ = _0220_ & ~(_0221_);
  assign _0223_ = a_i[7] & ~(b_i[-3]);
  assign _0224_ = _0223_ ^ _0222_;
  assign _0225_ = _0224_ ^ _0219_;
  assign _0226_ = _0161_ | _0158_;
  assign _0227_ = _0162_ & ~(_0171_);
  assign _0228_ = _0226_ & ~(_0227_);
  assign _0229_ = _0228_ ^ _0225_;
  assign _0230_ = _0167_ | _0165_;
  assign _0231_ = _0168_ & ~(_0170_);
  assign _0232_ = _0230_ & ~(_0231_);
  assign _0233_ = _0232_ ^ _0229_;
  assign _0234_ = _0175_ | _0172_;
  assign _0235_ = ~(_0234_ ^ _0233_);
  assign _0236_ = _0177_ & ~(_0176_);
  assign _0237_ = ~(_0179_ | _0178_);
  assign _0238_ = _0237_ | _0236_;
  assign _0239_ = _0178_ | _0123_;
  assign _0240_ = _0239_ | _0126_;
  assign _0241_ = _0240_ & ~(_0238_);
  assign product_o[4] = _0241_ ^ _0235_;
  assign _0242_ = a_i[-1] & b_i[6];
  assign _0243_ = ~(_0242_ ^ _0182_);
  assign _0244_ = a_i[0] & b_i[5];
  assign _0245_ = _0244_ ^ _0243_;
  assign _0246_ = ~(_0183_ & _0182_);
  assign _0247_ = _0184_ & ~(_0185_);
  assign _0248_ = _0246_ & ~(_0247_);
  assign _0249_ = _0248_ ^ _0245_;
  assign _0250_ = ~(a_i[1] & b_i[4]);
  assign _0251_ = ~(a_i[2] & b_i[3]);
  assign _0252_ = _0251_ ^ _0250_;
  assign _0253_ = ~(a_i[3] & b_i[2]);
  assign _0254_ = _0253_ ^ _0252_;
  assign _0255_ = _0254_ ^ _0249_;
  assign _0256_ = _0189_ | _0186_;
  assign _0257_ = _0190_ & ~(_0195_);
  assign _0258_ = _0256_ & ~(_0257_);
  assign _0259_ = _0258_ ^ _0255_;
  assign _0260_ = _0192_ | _0191_;
  assign _0261_ = _0193_ & ~(_0194_);
  assign _0262_ = _0260_ & ~(_0261_);
  assign _0263_ = ~(a_i[4] & b_i[1]);
  assign _0264_ = a_i[5] & b_i[0];
  assign _0265_ = ~(_0264_ ^ _0263_);
  assign _0266_ = a_i[6] & b_i[-1];
  assign _0267_ = ~_0266_;
  assign _0268_ = _0267_ ^ _0265_;
  assign _0269_ = _0268_ ^ _0262_;
  assign _0270_ = _0204_ | ~(_0205_);
  assign _0271_ = _0206_ & ~(_0208_);
  assign _0272_ = _0270_ & ~(_0271_);
  assign _0273_ = _0272_ ^ _0269_;
  assign _0274_ = _0273_ ^ _0259_;
  assign _0275_ = _0199_ | _0196_;
  assign _0276_ = _0200_ & ~(_0214_);
  assign _0277_ = _0275_ & ~(_0276_);
  assign _0278_ = _0277_ ^ _0274_;
  assign _0279_ = _0209_ | _0203_;
  assign _0280_ = _0210_ & ~(_0213_);
  assign _0281_ = _0279_ & ~(_0280_);
  assign _0282_ = a_i[7] & ~(b_i[-2]);
  assign _0283_ = _0282_ ^ _0281_;
  assign _0284_ = _0283_ ^ _0278_;
  assign _0285_ = _0218_ | _0215_;
  assign _0286_ = _0219_ & ~(_0224_);
  assign _0287_ = _0285_ & ~(_0286_);
  assign _0288_ = _0287_ ^ _0284_;
  assign _0289_ = _0223_ & ~(_0222_);
  assign _0290_ = _0289_ ^ _0288_;
  assign _0291_ = _0228_ | _0225_;
  assign _0292_ = _0229_ & ~(_0232_);
  assign _0293_ = _0291_ & ~(_0292_);
  assign _0294_ = _0293_ ^ _0290_;
  assign _0295_ = _0234_ | _0233_;
  assign _0296_ = ~(_0241_ | _0235_);
  assign _0297_ = _0295_ & ~(_0296_);
  assign product_o[5] = _0297_ ^ _0294_;
  assign _0298_ = a_i[0] & b_i[6];
  assign _0299_ = _0298_ ^ _0243_;
  assign _0300_ = ~(_0242_ & _0182_);
  assign _0301_ = _0244_ & ~(_0243_);
  assign _0302_ = _0300_ & ~(_0301_);
  assign _0303_ = _0302_ ^ _0299_;
  assign _0304_ = ~(a_i[1] & b_i[5]);
  assign _0305_ = a_i[2] & b_i[4];
  assign _0306_ = ~(_0305_ ^ _0304_);
  assign _0307_ = a_i[3] & b_i[3];
  assign _0308_ = ~_0307_;
  assign _0309_ = _0308_ ^ _0306_;
  assign _0310_ = _0309_ ^ _0303_;
  assign _0311_ = _0248_ | _0245_;
  assign _0312_ = _0249_ & ~(_0254_);
  assign _0313_ = _0311_ & ~(_0312_);
  assign _0314_ = _0313_ ^ _0310_;
  assign _0315_ = _0251_ | _0250_;
  assign _0316_ = _0252_ & ~(_0253_);
  assign _0317_ = _0315_ & ~(_0316_);
  assign _0318_ = ~(a_i[4] & b_i[2]);
  assign _0319_ = a_i[5] & b_i[1];
  assign _0320_ = _0319_ ^ _0318_;
  assign _0321_ = a_i[6] & b_i[0];
  assign _0322_ = _0321_ ^ _0320_;
  assign _0323_ = _0322_ ^ _0317_;
  assign _0325_ = _0263_ | ~(_0264_);
  assign _0326_ = _0265_ & ~(_0267_);
  assign _0327_ = _0325_ & ~(_0326_);
  assign _0328_ = _0327_ ^ _0323_;
  assign _0329_ = _0328_ ^ _0314_;
  assign _0330_ = _0258_ | _0255_;
  assign _0331_ = _0259_ & ~(_0273_);
  assign _0332_ = _0330_ & ~(_0331_);
  assign _0333_ = _0332_ ^ _0329_;
  assign _0334_ = ~(_0268_ | _0262_);
  assign _0336_ = _0269_ & ~(_0272_);
  assign _0337_ = ~(_0336_ | _0334_);
  assign _0338_ = a_i[7] & ~(b_i[-1]);
  assign _0339_ = _0338_ ^ _0337_;
  assign _0340_ = _0339_ ^ _0333_;
  assign _0341_ = _0277_ | _0274_;
  assign _0342_ = _0278_ & ~(_0283_);
  assign _0343_ = _0341_ & ~(_0342_);
  assign _0344_ = _0343_ ^ _0340_;
  assign _0345_ = _0282_ & ~(_0281_);
  assign _0347_ = ~_0345_;
  assign _0348_ = _0347_ ^ _0344_;
  assign _0349_ = _0287_ | _0284_;
  assign _0350_ = _0289_ & _0288_;
  assign _0351_ = _0349_ & ~(_0350_);
  assign _0352_ = ~(_0351_ ^ _0348_);
  assign _0353_ = _0290_ & ~(_0293_);
  assign _0354_ = ~(_0295_ | _0294_);
  assign _0355_ = _0354_ | _0353_;
  assign _0356_ = _0294_ | _0235_;
  assign _0358_ = _0238_ & ~(_0356_);
  assign _0359_ = _0358_ | _0355_;
  assign _0360_ = ~_0126_;
  assign _0361_ = _0356_ | _0239_;
  assign _0362_ = _0360_ & ~(_0361_);
  assign _0363_ = ~(_0362_ | _0359_);
  assign product_o[6] = _0363_ ^ _0352_;
  assign _0364_ = _0298_ & ~(_0243_);
  assign _0365_ = _0300_ & ~(_0364_);
  assign _0366_ = _0365_ ^ _0299_;
  assign _0368_ = a_i[1] & b_i[6];
  assign _0369_ = a_i[2] & b_i[5];
  assign _0370_ = ~(_0369_ ^ _0368_);
  assign _0371_ = a_i[3] & b_i[4];
  assign _0372_ = _0371_ ^ _0370_;
  assign _0373_ = _0372_ ^ _0366_;
  assign _0374_ = _0302_ | _0299_;
  assign _0375_ = _0303_ & ~(_0309_);
  assign _0376_ = _0374_ & ~(_0375_);
  assign _0377_ = _0376_ ^ _0373_;
  assign _0379_ = _0304_ | ~(_0305_);
  assign _0380_ = _0306_ & ~(_0308_);
  assign _0381_ = _0379_ & ~(_0380_);
  assign _0382_ = a_i[4] & b_i[3];
  assign _0383_ = a_i[5] & b_i[2];
  assign _0384_ = ~(_0383_ ^ _0382_);
  assign _0385_ = a_i[6] & b_i[1];
  assign _0386_ = _0385_ ^ _0384_;
  assign _0387_ = _0386_ ^ _0381_;
  assign _0388_ = _0318_ | ~(_0319_);
  assign _0390_ = _0321_ & ~(_0320_);
  assign _0391_ = _0388_ & ~(_0390_);
  assign _0392_ = _0391_ ^ _0387_;
  assign _0393_ = _0392_ ^ _0377_;
  assign _0394_ = _0313_ | _0310_;
  assign _0395_ = _0314_ & ~(_0328_);
  assign _0396_ = _0394_ & ~(_0395_);
  assign _0397_ = _0396_ ^ _0393_;
  assign _0398_ = ~(_0322_ | _0317_);
  assign _0399_ = _0323_ & ~(_0327_);
  assign _0401_ = ~(_0399_ | _0398_);
  assign _0402_ = a_i[7] & ~(b_i[0]);
  assign _0403_ = _0402_ ^ _0401_;
  assign _0404_ = _0403_ ^ _0397_;
  assign _0405_ = _0332_ | _0329_;
  assign _0406_ = _0333_ & ~(_0339_);
  assign _0407_ = _0405_ & ~(_0406_);
  assign _0408_ = _0407_ ^ _0404_;
  assign _0409_ = _0338_ & ~(_0337_);
  assign _0410_ = _0409_ ^ _0408_;
  assign _0412_ = _0343_ | _0340_;
  assign _0413_ = _0344_ & ~(_0347_);
  assign _0414_ = _0412_ & ~(_0413_);
  assign _0415_ = _0414_ ^ _0410_;
  assign _0416_ = _0351_ | _0348_;
  assign _0417_ = ~(_0363_ | _0352_);
  assign _0418_ = _0416_ & ~(_0417_);
  assign product_o[7] = _0418_ ^ _0415_;
  assign _0419_ = a_i[2] & b_i[6];
  assign _0420_ = ~(_0419_ ^ _0368_);
  assign _0422_ = a_i[3] & b_i[5];
  assign _0423_ = _0422_ ^ _0420_;
  assign _0424_ = _0423_ ^ _0366_;
  assign _0425_ = _0365_ | _0299_;
  assign _0426_ = _0366_ & ~(_0372_);
  assign _0427_ = _0425_ & ~(_0426_);
  assign _0428_ = _0427_ ^ _0424_;
  assign _0429_ = ~(_0369_ & _0368_);
  assign _0430_ = _0371_ & ~(_0370_);
  assign _0431_ = _0429_ & ~(_0430_);
  assign _0433_ = a_i[4] & b_i[4];
  assign _0434_ = a_i[5] & b_i[3];
  assign _0435_ = ~(_0434_ ^ _0433_);
  assign _0436_ = a_i[6] & b_i[2];
  assign _0437_ = _0436_ ^ _0435_;
  assign _0438_ = _0437_ ^ _0431_;
  assign _0439_ = ~(_0383_ & _0382_);
  assign _0440_ = _0385_ & ~(_0384_);
  assign _0441_ = _0439_ & ~(_0440_);
  assign _0442_ = _0441_ ^ _0438_;
  assign _0444_ = _0442_ ^ _0428_;
  assign _0445_ = _0376_ | _0373_;
  assign _0446_ = _0377_ & ~(_0392_);
  assign _0447_ = _0445_ & ~(_0446_);
  assign _0448_ = _0447_ ^ _0444_;
  assign _0449_ = ~(_0386_ | _0381_);
  assign _0450_ = _0387_ & ~(_0391_);
  assign _0451_ = ~(_0450_ | _0449_);
  assign _0452_ = a_i[7] & ~(b_i[1]);
  assign _0453_ = _0452_ ^ _0451_;
  assign _0455_ = _0453_ ^ _0448_;
  assign _0456_ = _0396_ | _0393_;
  assign _0457_ = _0397_ & ~(_0403_);
  assign _0458_ = _0456_ & ~(_0457_);
  assign _0459_ = _0458_ ^ _0455_;
  assign _0460_ = _0402_ & ~(_0401_);
  assign _0461_ = ~_0460_;
  assign _0462_ = _0461_ ^ _0459_;
  assign _0463_ = _0407_ | _0404_;
  assign _0464_ = _0409_ & _0408_;
  assign _0466_ = _0463_ & ~(_0464_);
  assign _0467_ = ~(_0466_ ^ _0462_);
  assign _0468_ = _0410_ & ~(_0414_);
  assign _0469_ = ~(_0416_ | _0415_);
  assign _0470_ = _0469_ | _0468_;
  assign _0471_ = _0415_ | _0352_;
  assign _0472_ = _0471_ | _0363_;
  assign _0473_ = _0472_ & ~(_0470_);
  assign product_o[8] = _0473_ ^ _0467_;
  assign _0474_ = a_i[3] & b_i[6];
  assign _0476_ = _0474_ ^ _0420_;
  assign _0477_ = _0476_ ^ _0366_;
  assign _0478_ = _0366_ & ~(_0423_);
  assign _0479_ = _0425_ & ~(_0478_);
  assign _0480_ = _0479_ ^ _0477_;
  assign _0481_ = ~(_0419_ & _0368_);
  assign _0482_ = _0422_ & ~(_0420_);
  assign _0483_ = _0481_ & ~(_0482_);
  assign _0484_ = a_i[4] & b_i[5];
  assign _0485_ = a_i[5] & b_i[4];
  assign _0487_ = ~(_0485_ ^ _0484_);
  assign _0488_ = a_i[6] & b_i[3];
  assign _0489_ = _0488_ ^ _0487_;
  assign _0490_ = _0489_ ^ _0483_;
  assign _0491_ = ~(_0434_ & _0433_);
  assign _0492_ = _0436_ & ~(_0435_);
  assign _0493_ = _0491_ & ~(_0492_);
  assign _0494_ = _0493_ ^ _0490_;
  assign _0495_ = _0494_ ^ _0480_;
  assign _0496_ = _0427_ | _0424_;
  assign _0498_ = _0428_ & ~(_0442_);
  assign _0499_ = _0496_ & ~(_0498_);
  assign _0500_ = _0499_ ^ _0495_;
  assign _0501_ = _0437_ | _0431_;
  assign _0502_ = _0438_ & ~(_0441_);
  assign _0503_ = _0501_ & ~(_0502_);
  assign _0504_ = b_i[2] | ~(a_i[7]);
  assign _0505_ = ~(_0504_ ^ _0503_);
  assign _0506_ = _0505_ ^ _0500_;
  assign _0507_ = _0447_ | _0444_;
  assign _0509_ = _0448_ & ~(_0453_);
  assign _0510_ = _0507_ & ~(_0509_);
  assign _0511_ = _0510_ ^ _0506_;
  assign _0512_ = _0452_ & ~(_0451_);
  assign _0513_ = _0512_ ^ _0511_;
  assign _0514_ = _0458_ | _0455_;
  assign _0515_ = _0459_ & ~(_0461_);
  assign _0516_ = _0514_ & ~(_0515_);
  assign _0517_ = _0516_ ^ _0513_;
  assign _0518_ = _0466_ | _0462_;
  assign _0520_ = ~(_0473_ | _0467_);
  assign _0521_ = _0518_ & ~(_0520_);
  assign product_o[9] = _0521_ ^ _0517_;
  assign _0522_ = _0366_ & ~(_0476_);
  assign _0523_ = _0425_ & ~(_0522_);
  assign _0524_ = ~(_0523_ ^ _0477_);
  assign _0525_ = _0474_ & ~(_0420_);
  assign _0526_ = _0481_ & ~(_0525_);
  assign _0527_ = a_i[4] & b_i[6];
  assign _0528_ = a_i[5] & b_i[5];
  assign _0530_ = ~(_0528_ ^ _0527_);
  assign _0531_ = a_i[6] & b_i[4];
  assign _0532_ = _0531_ ^ _0530_;
  assign _0533_ = _0532_ ^ _0526_;
  assign _0534_ = ~(_0485_ & _0484_);
  assign _0535_ = _0488_ & ~(_0487_);
  assign _0536_ = _0534_ & ~(_0535_);
  assign _0537_ = _0536_ ^ _0533_;
  assign _0538_ = ~(_0537_ ^ _0524_);
  assign _0539_ = _0479_ | _0477_;
  assign _0541_ = _0480_ & ~(_0494_);
  assign _0542_ = _0539_ & ~(_0541_);
  assign _0543_ = ~(_0542_ ^ _0538_);
  assign _0544_ = _0489_ | _0483_;
  assign _0545_ = _0490_ & ~(_0493_);
  assign _0546_ = _0544_ & ~(_0545_);
  assign _0547_ = b_i[3] | ~(a_i[7]);
  assign _0548_ = ~(_0547_ ^ _0546_);
  assign _0549_ = ~(_0548_ ^ _0543_);
  assign _0550_ = _0499_ | _0495_;
  assign _0552_ = _0500_ & ~(_0505_);
  assign _0553_ = _0550_ & ~(_0552_);
  assign _0554_ = ~(_0553_ ^ _0549_);
  assign _0555_ = ~(_0504_ | _0503_);
  assign _0556_ = _0555_ ^ _0554_;
  assign _0557_ = _0510_ | _0506_;
  assign _0558_ = _0512_ & _0511_;
  assign _0559_ = _0557_ & ~(_0558_);
  assign _0560_ = ~(_0559_ ^ _0556_);
  assign _0561_ = _0513_ & ~(_0516_);
  assign _0563_ = ~(_0518_ | _0517_);
  assign _0564_ = _0563_ | _0561_;
  assign _0565_ = _0517_ | _0467_;
  assign _0566_ = _0470_ & ~(_0565_);
  assign _0567_ = ~(_0566_ | _0564_);
  assign _0568_ = _0565_ | _0471_;
  assign _0569_ = _0359_ & ~(_0568_);
  assign _0570_ = _0567_ & ~(_0569_);
  assign _0571_ = _0568_ | _0361_;
  assign _0572_ = _0360_ & ~(_0571_);
  assign _0574_ = _0572_ | ~(_0570_);
  assign product_o[10] = ~(_0574_ ^ _0560_);
  assign _0575_ = a_i[5] & b_i[6];
  assign _0576_ = ~(_0575_ ^ _0527_);
  assign _0577_ = a_i[6] & b_i[5];
  assign _0578_ = _0577_ ^ _0576_;
  assign _0579_ = _0578_ ^ _0526_;
  assign _0580_ = ~(_0528_ & _0527_);
  assign _0581_ = _0531_ & ~(_0530_);
  assign _0582_ = _0580_ & ~(_0581_);
  assign _0584_ = _0582_ ^ _0579_;
  assign _0585_ = ~(_0584_ ^ _0524_);
  assign _0586_ = _0523_ | _0477_;
  assign _0587_ = ~(_0537_ | _0524_);
  assign _0588_ = _0586_ & ~(_0587_);
  assign _0589_ = ~(_0588_ ^ _0585_);
  assign _0590_ = _0532_ | _0526_;
  assign _0591_ = _0533_ & ~(_0536_);
  assign _0592_ = _0590_ & ~(_0591_);
  assign _0593_ = b_i[4] | ~(a_i[7]);
  assign _0595_ = ~(_0593_ ^ _0592_);
  assign _0596_ = ~(_0595_ ^ _0589_);
  assign _0597_ = _0542_ | _0538_;
  assign _0598_ = ~(_0548_ | _0543_);
  assign _0599_ = _0597_ & ~(_0598_);
  assign _0600_ = ~(_0599_ ^ _0596_);
  assign _0601_ = ~(_0547_ | _0546_);
  assign _0602_ = _0601_ ^ _0600_;
  assign _0603_ = ~_0602_;
  assign _0604_ = _0553_ | _0549_;
  assign _0606_ = _0555_ & ~(_0554_);
  assign _0607_ = _0604_ & ~(_0606_);
  assign _0608_ = _0607_ ^ _0603_;
  assign _0609_ = _0559_ | _0556_;
  assign _0610_ = _0574_ & ~(_0560_);
  assign _0611_ = _0609_ & ~(_0610_);
  assign product_o[11] = _0611_ ^ _0608_;
  assign _0612_ = a_i[6] & b_i[6];
  assign _0613_ = _0612_ ^ _0576_;
  assign _0614_ = _0613_ ^ _0526_;
  assign _0616_ = ~(_0575_ & _0527_);
  assign _0617_ = _0577_ & ~(_0576_);
  assign _0618_ = _0616_ & ~(_0617_);
  assign _0619_ = _0618_ ^ _0614_;
  assign _0620_ = ~(_0619_ ^ _0524_);
  assign _0621_ = ~(_0584_ | _0524_);
  assign _0622_ = _0586_ & ~(_0621_);
  assign _0623_ = ~(_0622_ ^ _0620_);
  assign _0624_ = _0578_ | _0526_;
  assign _0625_ = _0579_ & ~(_0582_);
  assign _0627_ = _0624_ & ~(_0625_);
  assign _0628_ = b_i[5] | ~(a_i[7]);
  assign _0629_ = ~(_0628_ ^ _0627_);
  assign _0630_ = ~(_0629_ ^ _0623_);
  assign _0631_ = _0588_ | _0585_;
  assign _0632_ = ~(_0595_ | _0589_);
  assign _0633_ = _0631_ & ~(_0632_);
  assign _0634_ = ~(_0633_ ^ _0630_);
  assign _0635_ = ~(_0593_ | _0592_);
  assign _0636_ = _0635_ ^ _0634_;
  assign _0638_ = _0599_ | _0596_;
  assign _0639_ = _0601_ & ~(_0600_);
  assign _0640_ = _0638_ & ~(_0639_);
  assign _0641_ = ~(_0640_ ^ _0636_);
  assign _0642_ = _0603_ & ~(_0607_);
  assign _0643_ = ~(_0609_ | _0608_);
  assign _0644_ = ~(_0643_ | _0642_);
  assign _0645_ = _0608_ | _0560_;
  assign _0646_ = _0574_ & ~(_0645_);
  assign _0647_ = _0644_ & ~(_0646_);
  assign product_o[12] = _0647_ ^ _0641_;
  assign _0649_ = _0612_ & ~(_0576_);
  assign _0650_ = _0616_ & ~(_0649_);
  assign _0651_ = _0650_ ^ _0614_;
  assign _0652_ = ~(_0651_ ^ _0524_);
  assign _0653_ = ~(_0619_ | _0524_);
  assign _0654_ = _0586_ & ~(_0653_);
  assign _0655_ = ~(_0654_ ^ _0652_);
  assign _0656_ = _0613_ | _0526_;
  assign _0657_ = _0614_ & ~(_0618_);
  assign _0659_ = _0656_ & ~(_0657_);
  assign _0660_ = a_i[7] & ~(b_i[6]);
  assign _0661_ = _0660_ ^ _0659_;
  assign _0662_ = ~(_0661_ ^ _0655_);
  assign _0663_ = _0622_ | _0620_;
  assign _0664_ = ~(_0629_ | _0623_);
  assign _0665_ = _0663_ & ~(_0664_);
  assign _0666_ = ~(_0665_ ^ _0662_);
  assign _0667_ = ~(_0628_ | _0627_);
  assign _0668_ = _0667_ ^ _0666_;
  assign _0670_ = _0633_ | _0630_;
  assign _0671_ = _0635_ & ~(_0634_);
  assign _0672_ = _0670_ & ~(_0671_);
  assign _0673_ = ~(_0672_ ^ _0668_);
  assign _0674_ = _0640_ | _0636_;
  assign _0675_ = ~(_0647_ | _0641_);
  assign _0676_ = _0674_ & ~(_0675_);
  assign product_o[13] = _0676_ ^ _0673_;
  assign _0677_ = ~(_0651_ | _0524_);
  assign _0678_ = _0586_ & ~(_0677_);
  assign _0680_ = _0678_ ^ _0652_;
  assign _0681_ = _0614_ & ~(_0650_);
  assign _0682_ = _0656_ & ~(_0681_);
  assign _0683_ = _0682_ ^ _0660_;
  assign _0684_ = _0683_ ^ _0680_;
  assign _0685_ = _0654_ | _0652_;
  assign _0686_ = ~(_0661_ | _0655_);
  assign _0687_ = _0685_ & ~(_0686_);
  assign _0688_ = _0687_ ^ _0684_;
  assign _0689_ = _0660_ & ~(_0659_);
  assign _0691_ = _0689_ ^ _0688_;
  assign _0692_ = _0665_ | _0662_;
  assign _0693_ = _0667_ & ~(_0666_);
  assign _0694_ = _0692_ & ~(_0693_);
  assign _0695_ = _0694_ ^ _0691_;
  assign _0696_ = _0672_ | _0668_;
  assign _0697_ = ~(_0674_ | _0673_);
  assign _0698_ = _0696_ & ~(_0697_);
  assign _0699_ = _0673_ | _0641_;
  assign _0700_ = ~(_0699_ | _0644_);
  assign _0702_ = _0698_ & ~(_0700_);
  assign _0703_ = _0699_ | _0645_;
  assign _0704_ = _0574_ & ~(_0703_);
  assign _0705_ = _0702_ & ~(_0704_);
  assign product_o[14] = _0705_ ^ _0695_;
  assign product_o[0] = ~(_0078_ ^ _0077_);
  assign product_o[-6] = a_i[-2] & b_i[-4];
  assign product_o[-5] = _0701_ ^ _0690_;
  assign product_o[-4] = ~(_0706_ ^ _0679_);
  assign product_o[-3] = ~(_0707_ ^ _0669_);
  assign a_w = { a_i, 2'h0 };
  assign b_w = { b_i[6], b_i };
endmodule
