options dlcreatedir;

%global DTAT_PATH;
%let DATA_PATH=F:\NFCS\;

%global DATABASE_DATE;
%let DATABASE_DATE=%dsToDtv(20170701);

%global FORMAT_DATE;
%let FORMAT_DATE=E8601DN.;

%global L0_PATH L1_PATH Ltest_PATH;
%let L0_PATH=&DATA_PATH.L0;
%let L1_PATH=&DATA_PATH.L1;
%let Ltest_PATH=&DATA_PATH.Ltest;

%global LENGTH_CERTID REG_AREA REG_YYYYMMDD REG_CERTNO;
%let LENGTH_CERTID=18;
%let REG_AREA='/(1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|(71)|(8[1-2])/';
%let REG_YYYYMMDD='/((\d{3}[1-9]|\d{2}[1-9]\d|\d{1}[1-9]\d{2}|[1-9]\d{3})(((0[13578]|1[02])(0\d|[12]\d|3[01]))|((0[4679]|11)(0\d|[12]\d|30))|((02)(0\d|1\d|2[0-8]))))|(((\d{2}(0[48]|[2468][048]|[13579][26]))|((0[48]|[2468][048]|[3579][26])00))0229)/';
%let REG_CERTNO='/\d{17}[\d|X]/';

%global LENGTH_ORGCODE REG_ORGCODE;
%let LENGTH_ORGCODE=14;
%let REG_ORGCODE='/(Q1[\w|\d]{8})(\d[1-9]|[1-9]\d|\w\d|\w\w|\d\w)(00)/';

%global NFCS_START_DATE NFCS_END_DATE;
%let NFCS_START_DATE=%dsToDtv(20100101);
%let NFCS_END_DATE=&DATABASE_DATE;
