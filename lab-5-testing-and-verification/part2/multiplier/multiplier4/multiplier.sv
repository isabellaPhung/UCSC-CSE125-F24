/* Generated by Yosys 0.45 (git sha1 9ed031ddd, clang++ 14.0.0-1ubuntu1.1 -fPIC -O3) */

(* top =  1  *)
(* \library  = "work" *)
(* hdlname = "multiplier" *)
(* src = "multiplier_pre.sv:1.8-1.18" *)
module multiplier(b_i, product_o, a_i);
  wire _000_;
  wire _001_;
  wire _002_;
  wire _003_;
  wire _004_;
  wire _005_;
  wire _006_;
  wire _007_;
  wire _008_;
  wire _009_;
  wire _010_;
  wire _011_;
  wire _012_;
  wire _013_;
  wire _014_;
  wire _015_;
  wire _016_;
  wire _017_;
  wire _018_;
  wire _019_;
  wire _020_;
  wire _021_;
  wire _022_;
  wire _023_;
  wire _024_;
  wire _025_;
  wire _026_;
  wire _027_;
  wire _028_;
  wire _029_;
  wire _030_;
  wire _031_;
  wire _032_;
  wire _033_;
  wire _034_;
  wire _035_;
  wire _036_;
  wire _037_;
  wire _038_;
  wire _039_;
  wire _040_;
  wire _041_;
  wire _042_;
  wire _043_;
  wire _044_;
  wire _045_;
  wire _046_;
  wire _047_;
  wire _048_;
  wire _049_;
  wire _050_;
  wire _051_;
  wire _052_;
  wire _053_;
  wire _054_;
  wire _055_;
  wire _056_;
  wire _057_;
  wire _058_;
  wire _059_;
  wire _060_;
  wire _061_;
  wire _062_;
  wire _063_;
  wire _064_;
  wire _065_;
  wire _066_;
  wire _067_;
  wire _068_;
  wire _069_;
  wire _070_;
  wire _071_;
  wire _072_;
  wire _073_;
  wire _074_;
  wire _075_;
  wire _076_;
  wire _077_;
  wire _078_;
  wire _079_;
  wire _080_;
  wire _081_;
  wire _082_;
  wire _083_;
  wire _084_;
  wire _085_;
  wire _086_;
  wire _087_;
  wire _088_;
  wire _089_;
  wire _090_;
  wire _091_;
  wire _092_;
  wire _093_;
  wire _094_;
  wire _095_;
  wire _096_;
  wire _097_;
  wire _098_;
  wire _099_;
  wire _100_;
  wire _101_;
  wire _102_;
  wire _103_;
  wire _104_;
  wire _105_;
  wire _106_;
  wire _107_;
  wire _108_;
  wire _109_;
  wire _110_;
  wire _111_;
  wire _112_;
  wire _113_;
  wire _114_;
  wire _115_;
  wire _116_;
  wire _117_;
  wire _118_;
  wire _119_;
  wire _120_;
  wire _121_;
  wire _122_;
  wire _123_;
  wire _124_;
  wire _125_;
  wire _126_;
  wire _127_;
  wire _128_;
  wire _129_;
  wire _130_;
  wire _131_;
  wire _132_;
  wire _133_;
  wire _134_;
  wire _135_;
  wire _136_;
  wire _137_;
  wire _138_;
  wire _139_;
  wire _140_;
  wire _141_;
  wire _142_;
  wire _143_;
  wire _144_;
  wire _145_;
  wire _146_;
  wire _147_;
  wire _148_;
  wire _149_;
  wire _150_;
  wire _151_;
  wire _152_;
  wire _153_;
  wire _154_;
  wire _155_;
  wire _156_;
  wire _157_;
  wire _158_;
  wire _159_;
  wire _160_;
  wire _161_;
  wire _162_;
  wire _163_;
  wire _164_;
  wire _165_;
  wire _166_;
  wire _167_;
  wire _168_;
  wire _169_;
  wire _170_;
  wire _171_;
  wire _172_;
  wire _173_;
  wire _174_;
  wire _175_;
  wire _176_;
  wire _177_;
  wire _178_;
  wire _179_;
  wire _180_;
  wire _181_;
  wire _182_;
  wire _183_;
  wire _184_;
  wire _185_;
  wire _186_;
  wire _187_;
  wire _188_;
  wire _189_;
  wire _190_;
  wire _191_;
  wire _192_;
  wire _193_;
  wire _194_;
  wire _195_;
  wire _196_;
  wire _197_;
  wire _198_;
  wire _199_;
  wire _200_;
  wire _201_;
  wire _202_;
  wire _203_;
  wire _204_;
  wire _205_;
  wire _206_;
  wire _207_;
  wire _208_;
  wire _209_;
  wire _210_;
  wire _211_;
  wire _212_;
  wire _213_;
  wire _214_;
  wire _215_;
  wire _216_;
  wire _217_;
  wire _218_;
  wire _219_;
  wire _220_;
  wire _221_;
  wire _222_;
  wire _223_;
  wire _224_;
  wire _225_;
  wire _226_;
  wire _227_;
  wire _228_;
  wire _229_;
  wire _230_;
  wire _231_;
  wire _232_;
  wire _233_;
  wire _234_;
  wire _235_;
  wire _236_;
  wire _237_;
  wire _238_;
  wire _239_;
  wire _240_;
  wire _241_;
  wire _242_;
  wire _243_;
  wire _244_;
  wire _245_;
  wire _246_;
  wire _247_;
  wire _248_;
  wire _249_;
  wire _250_;
  wire _251_;
  wire _252_;
  wire _253_;
  wire _254_;
  wire _255_;
  wire _256_;
  wire _257_;
  wire _258_;
  wire _259_;
  wire _260_;
  wire _261_;
  wire _262_;
  wire _263_;
  wire _264_;
  wire _265_;
  wire _266_;
  wire _267_;
  wire _268_;
  wire _269_;
  wire _270_;
  wire _271_;
  wire _272_;
  wire _273_;
  wire _274_;
  wire _275_;
  wire _276_;
  wire _277_;
  wire _278_;
  wire _279_;
  wire _280_;
  wire _281_;
  wire _282_;
  wire _283_;
  wire _284_;
  wire _285_;
  wire _286_;
  wire _287_;
  wire _288_;
  wire _289_;
  wire _290_;
  wire _291_;
  wire _292_;
  wire _293_;
  wire _294_;
  wire _295_;
  wire _296_;
  wire _297_;
  wire _298_;
  wire _299_;
  wire _300_;
  wire _301_;
  wire _302_;
  wire _303_;
  wire _304_;
  wire _305_;
  wire _306_;
  wire _307_;
  wire _308_;
  wire _309_;
  wire _310_;
  wire _311_;
  wire _312_;
  wire _313_;
  wire _314_;
  wire _315_;
  wire _316_;
  wire _317_;
  wire _318_;
  wire _319_;
  wire _320_;
  wire _321_;
  wire _322_;
  wire _323_;
  wire _324_;
  wire _325_;
  wire _326_;
  wire _327_;
  wire _328_;
  wire _329_;
  wire _330_;
  wire _331_;
  wire _332_;
  wire _333_;
  wire _334_;
  wire _335_;
  wire _336_;
  wire _337_;
  wire _338_;
  wire _339_;
  wire _340_;
  wire _341_;
  wire _342_;
  wire _343_;
  wire _344_;
  wire _345_;
  wire _346_;
  wire _347_;
  wire _348_;
  wire _349_;
  wire _350_;
  wire _351_;
  wire _352_;
  wire _353_;
  wire _354_;
  wire _355_;
  wire _356_;
  wire _357_;
  wire _358_;
  wire _359_;
  wire _360_;
  wire _361_;
  wire _362_;
  wire _363_;
  wire _364_;
  wire _365_;
  wire _366_;
  wire _367_;
  wire _368_;
  wire _369_;
  wire _370_;
  wire _371_;
  wire _372_;
  wire _373_;
  wire _374_;
  wire _375_;
  wire _376_;
  wire _377_;
  wire _378_;
  wire _379_;
  wire _380_;
  wire _381_;
  wire _382_;
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
  assign _028_ = _358_ | _355_;
  assign _029_ = _028_ | _027_;
  assign _030_ = ~(_029_ ^ _026_);
  assign _031_ = _028_ ^ _027_;
  assign _032_ = _360_ & ~(_359_);
  assign _033_ = _032_ & _031_;
  assign product_o[6] = ~(_033_ ^ _030_);
  assign _034_ = ~(a_i[5] & b_i[0]);
  assign _035_ = ~(b_i[1] & a_i[4]);
  assign _036_ = _035_ ^ _034_;
  assign _037_ = ~(b_i[2] & a_i[3]);
  assign _038_ = _037_ ^ _036_;
  assign _039_ = _362_ | _361_;
  assign _040_ = _363_ & ~(_364_);
  assign _041_ = _039_ & ~(_040_);
  assign _042_ = _041_ ^ _038_;
  assign _043_ = ~(b_i[3] & a_i[2]);
  assign _044_ = ~(b_i[4] & a_i[1]);
  assign _045_ = _044_ ^ _043_;
  assign _046_ = ~(b_i[5] & a_i[0]);
  assign _047_ = _046_ ^ _045_;
  assign _048_ = _047_ ^ _042_;
  assign _049_ = _372_ | _365_;
  assign _050_ = _373_ & ~(_378_);
  assign _051_ = _049_ & ~(_050_);
  assign _052_ = _051_ ^ _048_;
  assign _053_ = _375_ | _374_;
  assign _054_ = _376_ & ~(_377_);
  assign _055_ = _053_ & ~(_054_);
  assign _056_ = b_i[6] & a_i[-1];
  assign _057_ = _056_ ^ _055_;
  assign _058_ = _057_ ^ _014_;
  assign _059_ = _058_ ^ _052_;
  assign _060_ = _009_ | _379_;
  assign _061_ = _010_ & ~(_015_);
  assign _062_ = _060_ & ~(_061_);
  assign _063_ = _062_ ^ _059_;
  assign _064_ = _014_ & ~(_013_);
  assign _065_ = ~_064_;
  assign _066_ = _065_ ^ _063_;
  assign _067_ = _016_ & ~(_025_);
  assign _068_ = _067_ ^ _066_;
  assign _069_ = _029_ | _026_;
  assign _070_ = _033_ & ~(_030_);
  assign _071_ = _069_ & ~(_070_);
  assign product_o[7] = _071_ ^ _068_;
  assign _072_ = ~(a_i[6] & b_i[0]);
  assign _073_ = ~(b_i[1] & a_i[5]);
  assign _074_ = _073_ ^ _072_;
  assign _075_ = ~(b_i[2] & a_i[4]);
  assign _076_ = _075_ ^ _074_;
  assign _077_ = _035_ | _034_;
  assign _078_ = _036_ & ~(_037_);
  assign _079_ = _077_ & ~(_078_);
  assign _080_ = _079_ ^ _076_;
  assign _081_ = ~(b_i[3] & a_i[3]);
  assign _082_ = ~(b_i[4] & a_i[2]);
  assign _083_ = _082_ ^ _081_;
  assign _084_ = ~(b_i[5] & a_i[1]);
  assign _085_ = _084_ ^ _083_;
  assign _086_ = _085_ ^ _080_;
  assign _087_ = _041_ | _038_;
  assign _088_ = _042_ & ~(_047_);
  assign _089_ = _087_ & ~(_088_);
  assign _090_ = _089_ ^ _086_;
  assign _091_ = _044_ | _043_;
  assign _092_ = _045_ & ~(_046_);
  assign _093_ = _091_ & ~(_092_);
  assign _094_ = b_i[6] & a_i[0];
  assign _095_ = _094_ ^ _093_;
  assign _096_ = _095_ ^ _056_;
  assign _097_ = _096_ ^ _090_;
  assign _098_ = _051_ | _048_;
  assign _099_ = _052_ & ~(_058_);
  assign _100_ = _098_ & ~(_099_);
  assign _101_ = _100_ ^ _097_;
  assign _102_ = _055_ | ~(_056_);
  assign _103_ = _014_ & ~(_057_);
  assign _104_ = _102_ & ~(_103_);
  assign _105_ = _104_ ^ _101_;
  assign _106_ = _062_ | _059_;
  assign _107_ = _063_ & ~(_065_);
  assign _108_ = _106_ & ~(_107_);
  assign _109_ = ~(_108_ ^ _105_);
  assign _110_ = _066_ | ~(_067_);
  assign _111_ = ~(_069_ | _068_);
  assign _112_ = _110_ & ~(_111_);
  assign _113_ = _068_ | _030_;
  assign _114_ = _033_ & ~(_113_);
  assign _115_ = _112_ & ~(_114_);
  assign product_o[8] = _115_ ^ _109_;
  assign _116_ = ~(a_i[7] & b_i[0]);
  assign _117_ = ~(b_i[1] & a_i[6]);
  assign _118_ = _117_ ^ _116_;
  assign _119_ = ~(b_i[2] & a_i[5]);
  assign _120_ = _119_ ^ _118_;
  assign _121_ = _073_ | _072_;
  assign _122_ = _074_ & ~(_075_);
  assign _123_ = _121_ & ~(_122_);
  assign _124_ = _123_ ^ _120_;
  assign _125_ = ~(b_i[3] & a_i[4]);
  assign _126_ = b_i[4] & a_i[3];
  assign _127_ = ~(_126_ ^ _125_);
  assign _128_ = b_i[5] & a_i[2];
  assign _129_ = ~_128_;
  assign _130_ = _129_ ^ _127_;
  assign _131_ = _130_ ^ _124_;
  assign _132_ = _079_ | _076_;
  assign _133_ = _080_ & ~(_085_);
  assign _134_ = _132_ & ~(_133_);
  assign _135_ = _134_ ^ _131_;
  assign _136_ = _082_ | _081_;
  assign _137_ = _083_ & ~(_084_);
  assign _138_ = _136_ & ~(_137_);
  assign _139_ = b_i[6] & a_i[1];
  assign _140_ = _139_ ^ _138_;
  assign _141_ = _140_ ^ _094_;
  assign _142_ = _141_ ^ _135_;
  assign _143_ = _089_ | _086_;
  assign _144_ = _090_ & ~(_096_);
  assign _145_ = _143_ & ~(_144_);
  assign _146_ = _145_ ^ _142_;
  assign _147_ = _093_ | ~(_094_);
  assign _148_ = _056_ & ~(_095_);
  assign _149_ = _147_ & ~(_148_);
  assign _150_ = ~(_149_ ^ _146_);
  assign _151_ = _100_ | _097_;
  assign _152_ = _101_ & ~(_104_);
  assign _153_ = _151_ & ~(_152_);
  assign _154_ = _153_ ^ _150_;
  assign _155_ = _108_ | _105_;
  assign _156_ = _114_ | ~(_112_);
  assign _157_ = _156_ & ~(_109_);
  assign _158_ = _155_ & ~(_157_);
  assign product_o[9] = _158_ ^ _154_;
  assign _159_ = b_i[1] & a_i[7];
  assign _160_ = b_i[2] & a_i[6];
  assign _161_ = ~(_160_ ^ _159_);
  assign _162_ = _117_ | _116_;
  assign _163_ = _118_ & ~(_119_);
  assign _164_ = _162_ & ~(_163_);
  assign _165_ = _164_ ^ _161_;
  assign _166_ = b_i[3] & a_i[5];
  assign _167_ = b_i[4] & a_i[4];
  assign _168_ = ~(_167_ ^ _166_);
  assign _169_ = b_i[5] & a_i[3];
  assign _170_ = _169_ ^ _168_;
  assign _171_ = _170_ ^ _165_;
  assign _172_ = _123_ | _120_;
  assign _173_ = _124_ & ~(_130_);
  assign _174_ = _172_ & ~(_173_);
  assign _175_ = _174_ ^ _171_;
  assign _176_ = _125_ | ~(_126_);
  assign _177_ = _127_ & ~(_129_);
  assign _178_ = _176_ & ~(_177_);
  assign _179_ = b_i[6] & a_i[2];
  assign _180_ = _179_ ^ _178_;
  assign _181_ = _180_ ^ _139_;
  assign _182_ = _181_ ^ _175_;
  assign _183_ = _134_ | _131_;
  assign _184_ = _135_ & ~(_141_);
  assign _185_ = _183_ & ~(_184_);
  assign _186_ = _185_ ^ _182_;
  assign _187_ = _138_ | ~(_139_);
  assign _188_ = _094_ & ~(_140_);
  assign _189_ = _187_ & ~(_188_);
  assign _190_ = _189_ ^ _186_;
  assign _191_ = _145_ | _142_;
  assign _192_ = _146_ & ~(_149_);
  assign _193_ = _191_ & ~(_192_);
  assign _194_ = ~(_193_ ^ _190_);
  assign _195_ = _153_ | ~(_150_);
  assign _196_ = ~(_155_ | _154_);
  assign _197_ = _196_ | ~(_195_);
  assign _198_ = _154_ | _109_;
  assign _199_ = _198_ | _115_;
  assign _200_ = _199_ & ~(_197_);
  assign product_o[10] = _200_ ^ _194_;
  assign _201_ = b_i[2] & a_i[7];
  assign _202_ = _160_ & _159_;
  assign _203_ = ~(_202_ ^ _201_);
  assign _204_ = b_i[3] & a_i[6];
  assign _205_ = b_i[4] & a_i[5];
  assign _206_ = ~(_205_ ^ _204_);
  assign _207_ = b_i[5] & a_i[4];
  assign _208_ = _207_ ^ _206_;
  assign _209_ = ~(_208_ ^ _203_);
  assign _210_ = _164_ | _161_;
  assign _211_ = _165_ & ~(_170_);
  assign _212_ = _210_ & ~(_211_);
  assign _213_ = _212_ ^ _209_;
  assign _214_ = ~(_167_ & _166_);
  assign _215_ = _169_ & ~(_168_);
  assign _216_ = _214_ & ~(_215_);
  assign _217_ = b_i[6] & a_i[3];
  assign _218_ = _217_ ^ _216_;
  assign _219_ = _218_ ^ _179_;
  assign _220_ = _219_ ^ _213_;
  assign _221_ = _174_ | _171_;
  assign _222_ = _175_ & ~(_181_);
  assign _223_ = _221_ & ~(_222_);
  assign _224_ = _223_ ^ _220_;
  assign _225_ = _178_ | ~(_179_);
  assign _226_ = _139_ & ~(_180_);
  assign _227_ = _225_ & ~(_226_);
  assign _228_ = _227_ ^ _224_;
  assign _229_ = _185_ | _182_;
  assign _230_ = _186_ & ~(_189_);
  assign _231_ = _229_ & ~(_230_);
  assign _232_ = ~(_231_ ^ _228_);
  assign _233_ = _193_ | _190_;
  assign _234_ = ~(_200_ | _194_);
  assign _236_ = _233_ & ~(_234_);
  assign product_o[11] = _236_ ^ _232_;
  assign _237_ = b_i[3] & a_i[7];
  assign _238_ = b_i[4] & a_i[6];
  assign _239_ = ~(_238_ ^ _237_);
  assign _240_ = b_i[5] & a_i[5];
  assign _241_ = _240_ ^ _239_;
  assign _242_ = ~(_202_ & _201_);
  assign _243_ = ~(_208_ | _203_);
  assign _244_ = _242_ & ~(_243_);
  assign _246_ = ~(_244_ ^ _241_);
  assign _247_ = ~(_205_ & _204_);
  assign _248_ = _207_ & ~(_206_);
  assign _249_ = _247_ & ~(_248_);
  assign _250_ = b_i[6] & a_i[4];
  assign _251_ = _250_ ^ _249_;
  assign _252_ = _251_ ^ _217_;
  assign _253_ = ~(_252_ ^ _246_);
  assign _254_ = _212_ | _209_;
  assign _255_ = _213_ & ~(_219_);
  assign _256_ = _254_ & ~(_255_);
  assign _257_ = _256_ ^ _253_;
  assign _258_ = _216_ | ~(_217_);
  assign _259_ = _179_ & ~(_218_);
  assign _260_ = _258_ & ~(_259_);
  assign _261_ = _260_ ^ _257_;
  assign _262_ = _223_ | _220_;
  assign _263_ = _224_ & ~(_227_);
  assign _264_ = _262_ & ~(_263_);
  assign _265_ = ~(_264_ ^ _261_);
  assign _267_ = _231_ | _228_;
  assign _268_ = ~(_233_ | _232_);
  assign _269_ = _267_ & ~(_268_);
  assign _270_ = _232_ | _194_;
  assign _271_ = _197_ & ~(_270_);
  assign _272_ = _269_ & ~(_271_);
  assign _273_ = _270_ | _198_;
  assign _274_ = _156_ & ~(_273_);
  assign _275_ = _272_ & ~(_274_);
  assign product_o[12] = _275_ ^ _265_;
  assign _277_ = b_i[4] & a_i[7];
  assign _278_ = b_i[5] & a_i[6];
  assign _279_ = ~(_278_ ^ _277_);
  assign _280_ = ~_279_;
  assign _281_ = ~(_238_ & _237_);
  assign _282_ = _240_ & ~(_239_);
  assign _283_ = _281_ & ~(_282_);
  assign _284_ = b_i[6] & a_i[5];
  assign _285_ = _284_ ^ _283_;
  assign _286_ = _285_ ^ _250_;
  assign _288_ = _286_ ^ _280_;
  assign _289_ = _244_ | _241_;
  assign _290_ = ~(_252_ | _246_);
  assign _291_ = _289_ & ~(_290_);
  assign _292_ = ~(_291_ ^ _288_);
  assign _293_ = _249_ | ~(_250_);
  assign _294_ = _217_ & ~(_251_);
  assign _295_ = _293_ & ~(_294_);
  assign _296_ = ~(_295_ ^ _292_);
  assign _297_ = _256_ | _253_;
  assign _299_ = _257_ & ~(_260_);
  assign _300_ = _297_ & ~(_299_);
  assign _301_ = ~(_300_ ^ _296_);
  assign _302_ = _264_ | _261_;
  assign _303_ = ~(_275_ | _265_);
  assign _304_ = _302_ & ~(_303_);
  assign product_o[13] = _304_ ^ _301_;
  assign _305_ = b_i[5] & a_i[7];
  assign _306_ = ~(_278_ & _277_);
  assign _307_ = b_i[6] & a_i[6];
  assign _309_ = _307_ ^ _306_;
  assign _310_ = _309_ ^ _284_;
  assign _311_ = _310_ ^ _305_;
  assign _312_ = _280_ & ~(_286_);
  assign _313_ = _312_ ^ _311_;
  assign _314_ = _283_ | ~(_284_);
  assign _315_ = _250_ & ~(_285_);
  assign _316_ = _314_ & ~(_315_);
  assign _317_ = _316_ ^ _313_;
  assign _318_ = _291_ | _288_;
  assign _320_ = ~(_295_ | _292_);
  assign _321_ = _318_ & ~(_320_);
  assign _322_ = _321_ ^ _317_;
  assign _323_ = _300_ | _296_;
  assign _324_ = ~(_302_ | _301_);
  assign _325_ = _323_ & ~(_324_);
  assign _326_ = _301_ | _265_;
  assign _327_ = ~(_326_ | _275_);
  assign _328_ = _325_ & ~(_327_);
  assign product_o[14] = _328_ ^ _322_;
  assign product_o[5] = _032_ ^ _031_;
  assign product_o[0] = b_i[0] & a_i[-2];
  assign _235_ = a_i[-1] & b_i[0];
  assign _245_ = b_i[1] & a_i[-2];
  assign product_o[1] = _245_ ^ _235_;
  assign _266_ = a_i[0] & b_i[0];
  assign _276_ = b_i[1] & a_i[-1];
  assign _287_ = _276_ ^ _266_;
  assign _298_ = b_i[2] & a_i[-2];
  assign _308_ = ~_298_;
  assign _319_ = _308_ ^ _287_;
  assign _329_ = _245_ & _235_;
  assign product_o[2] = ~(_329_ ^ _319_);
  assign _330_ = ~(a_i[1] & b_i[0]);
  assign _331_ = ~(b_i[1] & a_i[0]);
  assign _332_ = _331_ ^ _330_;
  assign _333_ = ~(b_i[2] & a_i[-1]);
  assign _334_ = _333_ ^ _332_;
  assign _335_ = ~(_276_ & _266_);
  assign _336_ = _287_ & ~(_308_);
  assign _337_ = _335_ & ~(_336_);
  assign _338_ = _337_ ^ _334_;
  assign _339_ = b_i[3] & a_i[-2];
  assign _340_ = ~_339_;
  assign _341_ = _340_ ^ _338_;
  assign _342_ = _329_ & ~(_319_);
  assign product_o[3] = ~(_342_ ^ _341_);
  assign _343_ = ~(a_i[2] & b_i[0]);
  assign _344_ = ~(b_i[1] & a_i[1]);
  assign _345_ = _344_ ^ _343_;
  assign _346_ = ~(b_i[2] & a_i[0]);
  assign _347_ = _346_ ^ _345_;
  assign _348_ = _331_ | _330_;
  assign _349_ = _332_ & ~(_333_);
  assign _350_ = _348_ & ~(_349_);
  assign _351_ = _350_ ^ _347_;
  assign _352_ = b_i[3] & a_i[-1];
  assign _353_ = b_i[4] & a_i[-2];
  assign _354_ = ~(_353_ ^ _352_);
  assign _355_ = _354_ ^ _351_;
  assign _356_ = _337_ | _334_;
  assign _357_ = _338_ & ~(_340_);
  assign _358_ = _356_ & ~(_357_);
  assign _359_ = ~(_358_ ^ _355_);
  assign _360_ = _342_ & ~(_341_);
  assign product_o[4] = ~(_360_ ^ _359_);
  assign _361_ = ~(a_i[4] & b_i[0]);
  assign _362_ = ~(b_i[1] & a_i[3]);
  assign _363_ = _362_ ^ _361_;
  assign _364_ = ~(b_i[2] & a_i[2]);
  assign _365_ = _364_ ^ _363_;
  assign _366_ = ~(a_i[3] & b_i[0]);
  assign _367_ = b_i[1] & a_i[2];
  assign _368_ = _366_ | ~(_367_);
  assign _369_ = b_i[2] & a_i[1];
  assign _370_ = _367_ ^ _366_;
  assign _371_ = _369_ & ~(_370_);
  assign _372_ = _368_ & ~(_371_);
  assign _373_ = _372_ ^ _365_;
  assign _374_ = ~(b_i[3] & a_i[1]);
  assign _375_ = ~(b_i[4] & a_i[0]);
  assign _376_ = _375_ ^ _374_;
  assign _377_ = ~(b_i[5] & a_i[-1]);
  assign _378_ = _377_ ^ _376_;
  assign _379_ = _378_ ^ _373_;
  assign _380_ = ~(_370_ ^ _369_);
  assign _381_ = _344_ | _343_;
  assign _382_ = _345_ & ~(_346_);
  assign _000_ = _381_ & ~(_382_);
  assign _001_ = _000_ | ~(_380_);
  assign _002_ = b_i[3] & a_i[0];
  assign _003_ = b_i[4] & a_i[-1];
  assign _004_ = _003_ ^ _002_;
  assign _005_ = b_i[5] & a_i[-2];
  assign _006_ = _005_ ^ _004_;
  assign _007_ = _000_ ^ _380_;
  assign _008_ = _006_ & ~(_007_);
  assign _009_ = _001_ & ~(_008_);
  assign _010_ = _009_ ^ _379_;
  assign _011_ = ~(_003_ & _002_);
  assign _012_ = _005_ & _004_;
  assign _013_ = _011_ & ~(_012_);
  assign _014_ = b_i[6] & a_i[-2];
  assign _015_ = _014_ ^ _013_;
  assign _016_ = ~(_015_ ^ _010_);
  assign _017_ = ~(_007_ ^ _006_);
  assign _018_ = _350_ | _347_;
  assign _019_ = _351_ & ~(_354_);
  assign _020_ = _018_ & ~(_019_);
  assign _021_ = _020_ | ~(_017_);
  assign _022_ = _353_ & _352_;
  assign _023_ = _020_ ^ _017_;
  assign _024_ = _022_ & ~(_023_);
  assign _025_ = _021_ & ~(_024_);
  assign _026_ = _025_ ^ _016_;
  assign _027_ = _023_ ^ _022_;
  assign a_w = { a_i, 2'h0 };
  assign b_w = { b_i[6], b_i[6:0], 4'h0 };
  assign product_o[-1:-6] = 6'h00;
endmodule
