* ---------------------------------------;
* --------------- formats ---------------;
* ---------------------------------------;
* ����formats;

proc format;

	* ---------------------------------;
	* ---------- ����formats ----------;
	* ---------------------------------;

	value intscope
		low-<0=-1
		0=0
		0<-high=1;

	%let _FN_INTSCOPE=3;

	invalue flagToDummy
		low-0=0
		other=1;
	%let _FN_flagToDummy=2;

	value dummy
		0='NO'
		1='YES'
		other='N/A';
	%let _FN_other=3;
	
	invalue historyToNum
		'1'=1
		'2'=2
		'3'=3
		'4'=4
		'5'=5
		'6'=6
		'7'=7
		'8'=8
		'9'=9
		'0'=0
		other=.;
	%let _FN_historyToNum=11;
	
	* ----------------------------------------;
	* ---------- ����ת����formats ------------;
	* ----------------------------------------;
	* ����״̬;
	invalue imarriage 
		'10'=10
		'20'=20
		'21'=21
		'22'=22
		'23'=23
		'30'=30
		'40'=40
		'90'=.
		other=.;

	%let _FN_IMARRIAGE=8;

	value marriage
		10='δ��'
		20='�ѻ�'
		21='����'
		22='�ٻ�'
		23='����'
		30='ɥż'
		40='���'
		other='δ֪';

	%let _FN_MARRIAGE=8;

	* ѧ�����;
	invalue iedulevel
		'10'=10
		'20'=20
		'30'=30
		'40'=40
		'50'=50
		'60'=60
		'70'=70
		'80'=80
		'90'=90
		'99'=.
		other=.;
	
	%let _FN_iedulevel=10;

	value eduLevel
		10='�о���'
		20='����'
		30='ר��'
		40='��ר'
		50='��У'
		60='����'
		70='����'
		80='Сѧ'
		90='��ä'
		other='δ֪';

	%let _FN_iedulevel=10;

	invalue eduLevelToEduLevelA
		50=40
		80=70
		90=70
		other=[d.];
	
	%let _FN_eduLevelToEduLevelA=7;

	value eduLevelA
		10='�о���'
		20='����'
		30='ר��'
		40='��ר��У'
		60='����'
		70='���м�����'
		other='δ֪';

	%let _FN_eduLevelA=7;

	* ѧλ;
	invalue iedudegree
		'0'=.
		'1'=1
		'2'=2
		'3'=3
		'4'=4
		'9'=.
		other=.;
	
	%let _FN_iedudegree=5;
			
	value edudegree
		1='������ʿ'
		2='��ʿ'
		3='˶ʿ'
		4='ѧʿ'
		other='δ֪';

	%let _FN_edudegree=5;

	* ��ϵ������;
	invalue scontactrelation
		'0'=1
		'1'=2
		'2'=3
		'3'=4
		'4'=5
		'5'=6
		'6'=7
		'7'=8
		other=.;
	
	%let _FN_scontactrelation=9;

	value contactrelation
		1='���ӣ�Ů��'
		2='ĸ�ӣ�Ů��'
		3='��ż'
		4='��Ů'
		5='��������'
		6='ͬ��'
		7='����'
		8='�ֵܽ���'
		other='δ֪';

	%let _FN_contactrelation=9;

	* ְҵ;
  	invalue soccupation
		'0'=1
		'1'=2
		'3'=3
		'4'=4
		'5'=5
		'6'=6
		'X'=7
		other=.;

	%let _FN_soccupation=8;

	value occupation
		1='���һ��ء���Ⱥ��֯����ҵ����ҵ��λ������'
		2='רҵ������Ա'
		3='������Ա���й���Ա'
		4='��ҵ������ҵ��Ա'
		5='ũ���֡������桢ˮ��ҵ������Ա'
		6='�����������豸������Ա���й���Ա'
		7='����'
		other='δ֪';

	%let _FN_occupation=8;

	* ��ҵ;
	invalue sindustry
		'A'=1
		'B'=2
		'C'=3
		'D'=4
		'E'=5
		'F'=6
		'G'=7
		'H'=8
		'I'=9
		'J'=10
		'K'=11
		'L'=12
		'M'=13
		'N'=14
		'O'=15
		'P'=16
		'Q'=17
		'R'=18
		'S'=19
		'T'=20
		'Z'=.
		other=.;

	%let _FN_sindustry=21;

	value industry
		1='ũ���֡�������ҵ'
		2='�ɾ�ҵ'
		3='����ҵ'
		4='������ȼ����ˮ�������͹�Ӧҵ'
		5='����ҵ'
		6='��ͨ���䡢�ִ�������ҵ'
		7='��Ϣ���䡢��������������ҵ'
		8='����������ҵ'
		9='ס�޺Ͳ���ҵ'
		10='����ҵ'
		11='���ز�ҵ'
		12='���޺��������ҵ'
		13='��ѧ�о�����������ҵ�͵��ʿ���ҵ'
		14='ˮ���������͹�����ʩ����ҵ'
		15='����������������ҵ'
		16='����'
		17='��������ᱣ�Ϻ���ḣ��ҵ'
		18='�Ļ�������������ҵ'
		19='���������������֯'
		20='������֯'
		other='δ֪';

	%let _FN_industry=21;

	invalue industryToIndustryA
		20=19
		other=[d.0];

	%let _FN_industryToIndustryA=20;

	value industryA
		1='ũ���֡�������ҵ'
		2='�ɾ�ҵ'
		3='����ҵ'
		4='������ȼ����ˮ�������͹�Ӧҵ'
		5='����ҵ'
		6='��ͨ���䡢�ִ�������ҵ'
		7='��Ϣ���䡢��������������ҵ'
		8='����������ҵ'
		9='ס�޺Ͳ���ҵ'
		10='����ҵ'
		11='���ز�ҵ'
		12='���޺��������ҵ'
		13='��ѧ�о�����������ҵ�͵��ʿ���ҵ'
		14='ˮ���������͹�����ʩ����ҵ'
		15='����������������ҵ'
		16='����'
		17='��������ᱣ�Ϻ���ḣ��ҵ'
		18='�Ļ�������������ҵ'
		19='���������������֯��������֯'
		other='δ֪';

	%let _FN_industryA=20;

	* ְ��;
	invalue iposition
		'1'=1
		'2'=2
		'3'=3
		'4'=4
		'9'=.
		other=.;

	%let _FN_iposition=5;

	value position
		1='�߼��쵼'
		2='�м��쵼'
		3='һ��Ա��'
		4='����'
		other='δ֪';

	%let _FN_position=5;

	* ְ��;
	invalue ititle
		'0'=0
		'1'=1
		'2'=2
		'3'=3
		'9'=.
		other=.;

	%let _FN_ititle=5;

	value title
		0='��'
		1='�߼�'
		2='�м�'
		3='����'
		other='δ֪';
	
	%let _FN_title=5;

	* ��ס״��;
	invalue scondition
		'1'=1
		'2'=2
		'3'=3
		'4'=4
		'5'=5
		'6'=6
		'7'=.
		'8'=.
		other=.;

	%let _FN_scondition=7;
	
	value residenceCondition
		1='����'
		2='����'
		3='����¥��'
		4='��������'
		5='�ⷿ'
		6='����סլ'
		other='δ֪';

	%let _FN_residenceCondition=7;

	* resCond�ط���;
	invalue resCondToResCondA
		1=1
		2=2
		3=3
		4=4
		5=5
		6=5
		other=.;

	%let _FN_resCondToResCondA=6;

	value resCondA
		1='����'
		2='����'
		3='����¥��'
		4='��������'
		5='�ⷿ�빲��סլ'
		other='δ֪';
	
	%let _FN_resCondA=6;

	* ������������;
	invalue sloantype
		'11'=11
		'12'=12
		'13'=13
		'21'=21
		'31'=31
		'41'=41
		'51'=51
		'91'=91
		other=.;

	%let _FN_sloantype=9;

	* ��������;
	value loantype
		11='����ס������'
		12='�������÷�����'
		13='����ס�����������'
		21='�����������Ѵ���'
		31='������ѧ����'
		41='���˾�Ӫ�Դ���'
		51='ũ������'
		91='�������Ѵ���'
		other='δ֪';

	%let _FN_loantype=9;

	* ��������״̬;
	invalue sapplystate
		'1'=1
		'2'=2
		'3'=3
		other=.;

	%let _FN_sapplystate=4;

	value applystate
		1='������'
		2='����׼'
		3='δͨ��'
		other=.;

	%let _FN_applystate=4;

	* �������������;
	invalue iguaranteeway
		'1'=1
		'2'=2
		'3'=3
		'4'=4
		'5'=5
		'6'=6
		'7'=7
		'9'=.
		other=.;

	%let _FN_iguaranteeway=8;

	value guaranteeway
		1='��Ѻ������֤��'
		2='��Ѻ'
		3='��Ȼ�˱�֤'
		4='����/�ⵣ��'
		5='��ϣ�����Ȼ�˱�֤��'
		6='��ϣ�������Ȼ�˱�֤��'
		7='ũ������'
		other='δ֪';

	%let _FN_guaranteeway=8;

	* ���������->�Ƿ�Ϊ��������;
	invalue guranteewayToLtgt
		4=1
		1-3=2
		5-7=2
		other=.;

	%let _FN_guranteewayToLtgt=3;

	* �Ƿ�Ϊ��������������ͼ򻯣�;
	value ltgt
		1='����'
		2='������'
		other='δ֪';

	%let _FN_ltgt=3;

	* ������->����������;
	invalue loanamountToLtamt
		0-1000=1
		1000-2500=2
		2500-5000=3
		5000-10000=4
		10000-50000=5
		50000-100000=6
		100000-high=7
		other=.;

	%let _FN_loanamountToLtamt=8;

	* ����������;
	value ltamt
		1='1K����'
		2='1K-2.5K'
		3='2.5K-5K'
		4='5K-10K'
		5='10K-50K'
		6='50K-100K'
		7='100K����'
		other='δ֪';

	%let _FN_ltamt=8;

	* ����������->�������޳�������;
	invalue totalmonthToLtterm
		0<-1=1
		1<-3=2
		3<-6=3
		6<-12=4
		12<-24=5
		24<-36=6
		36<-60=7
		60<-high=8
		other=.;

	%let _FN_totalmonthToLtterm=9;

	* �������޳�������;
	value ltterm
		1='1���¼�����'
		2='3���¼�����'
		3='6���¼�����'
		4='1�꼰����'
		5='2�꼰����'
		6='2������'
		other='δ֪';

	%let _FN_ltterm=7;

	* �����Ƶ��;
	invalue stermsfreq
		'01'=1
		'02'=2
		'03'=3
		'04'=4
		'05'=5
		'06'=6
		'07'=7
		'08'=8
		other=.;

	%let _FN_stermsfreq=9;

	value termsfreq
		1='��'
		2='��'
		3='��'
		4='��'
		5='����'
		6='��'
		7='һ����'
		8='������'
		other='����';

	%let _FN_termsfreq=9;

	invalue termsfreqToDays
		1=1
		2=7
		3=30
		4=90
		5=180
		6=360
		other=.;

	%let _FN_termsfreqToDays=7;

	value termalign
		1='�ϸ����'
		2='�����ն���'
		3='�����ն���'
		4='�����ն���'
		other='�Ƕ���';

	%let _FN_termalign=5;

	* termsfreq��Ӧһ���ڵ�����;
	invalue termsfreqTo1YearTerms
		1=365
		2=52
		3=12
		4=4
		5=2
		6=1
		other=.;

	%let _FN_termsfreqTo1YearTerms=7;

	* �����˻�״̬;
	invalue iaccountstat
		'1'=1
		'2'=2
		'3'=3
		'4'=4
		'5'=5
		other=.;

	%let _FN_iaccountstat=6;

	value accountstat
		1='����'
		2='����'
		3='����'
		4='���ˣ���������'
		5='ת��'
		other='δ֪';

	%let _FN_accountstat=6;

	* �����˻���̬;
	value acctfinstat
		10='δ����'
		21='��������'
		22='��ǰ�������'
		23='��ǰ����'
		29='��ǰ�����������'
		31='���ڴ���'
		32='������������'
		33='���ں���'
		39='���������������'
		41='���ڴ���'
		42='���ڽ���'
		43='���ں���'
		49='���������������'
		other='δ֪';

	%let _FN_acctfinstat=14;

	* ����5����������;
	invalue iclass5stat
		'1'=1
		'2'=2
		'3'=3
		'4'=4
		'5'=5
		'9'=.
		other=.;

	%let _FN_iclass5stat=6;

	* ����5������;
	value class5stat
		1='����'
		2='��ע'
		3='�μ�'
		4='����'
		5='��ʧ'
		other='δ֪';

	%let _FN_class5stat=6;

	* ���ñ����ѯԭ������;
	invalue sreason
		'��������'=1
		'�������'=2
		'���˲�ѯ'=3
		'�����ѯ'=4
		'�����ʸ����'=5
		'���ڼ��'=6
		'˾������'=7
		'δ֪ԭ��'=.
		other=.;

	%let _FN_sreason=8;

	* ���ñ����ѯԭ��;
	value requestreason
		1='��������'
		2='�������'
		3='���˲�ѯ'
		4='�����ѯ'
		5='�����ʸ����'
		6='���ڼ��'
		7='˾������'
		other='δ֪';

	%let _FN_requestreason=8;

	* ���ñ����ѯ����->��ѯ���;
	invalue irequesttypeToResult
		'0'=1
		'1'=1
		'2'=1
		'3'=2
		'4'=2
		'5'=2
		'6'=1
		'7'=2
		other=.;

	%let _FN_irequesttypeToResult=3;

	* ���ñ����ѯ���;
	value requestresult
		1='���'
		2='δ���'
		other='δ֪';

	%let _FN_requestresult=3;

	* ���ñ����ѯ����->��ѯ����;
	*	1	���ߵ���;
	*	2	��������;
	*	3	ֱ������;
	*	4 	ֱ������;	
	invalue irequesttypeToChannel
		'0'=1
		'1'=2
		'2'=4
		'3'=1
		'4'=2
		'5'=4
		'6'=3
		'7'=3
		other=.;

	%let _FN_irequesttypeToChannel=5;

	* ���ñ����ѯ����;
	value requestchannel
		1='���ߵ���'
		2='��������'
		3='ֱ������'
		4='ֱ������'
		other='δ֪';

	%let _FN_requestchannel=5;

	* 24�»���״̬;
	invalue spaystat1month
		'/'=11
		'*'=20
		'N'=21
		'1'=31
		'2'=32
		'3'=33
		'4'=34
		'5'=35
		'6'=36
		'7'=37
		'C'=40
		'Z'=41
		'D'=42
		'G'=43
		other=.;

	%let _FN_spaystat1month=15;

	* n�»���״̬;
	value paystat
		11='δ�����˻�'
		20='���������²���Ҫ���'
		21='����'
		31='����1-30��'
		32='����31-60��'
		33='����61-90��'
		34='����91-120��'
		35='����121-150��'
		36='����151-180��'
		37='����180������'
		40='����'
		41='���ʵ�ծ'
		42='�����˴���'
		43='����'
		other='δ֪';

	%let _FN_paystat=15;
	
	* �������;
	value paycode
		11='����ʱ��-ȫ��֧��'
		12='����ʱ��-����֧��'
		13='����ʱ��-����֧��'
		14='����ʱ��-��֧���ƻ�'
		15='����ʱ��-�ƻ���֧��'
		21='һ��ʱ��-ȫ��֧��'
		22='һ��ʱ��-����֧��'
		23='һ��ʱ��-����֧��'
		24='һ��ʱ��-��֧���ƻ�'
		25='һ��ʱ��-�ƻ���֧��'
		31='����ʱ��-ȫ��֧��'
		32='����ʱ��-����֧��'
		33='����ʱ��-����֧��'
		34='����ʱ��-��֧���ƻ�'
		35='����ʱ��-�ƻ���֧��'
		41='����ʱ��-ȫ��֧��'
		42='����ʱ��-����֧��'
		43='����ʱ��-����֧��'
		44='����ʱ��-��֧���ƻ�'
		45='����ʱ��-�ƻ���֧��'
		other='δ֪';

	%let _FN_paycode=21;

	* ����ģʽ;
	value paytype
		1='�ȶϢ'
		2='ϢƱ'
		3='�ȶ��'
		other='δ֪';

	%let _FN_paytype=4;

	* �����������;
	value payalign
		1='˫����'
		2='�����'
		3='�Ҷ���'
		4='�ж���'
		9='�Ƕ���'
		other='δ֪';

	%let _FN_payalign=6;

	* ��������;
	invalue monthpastdueToMpd
		0=1
		0<-1=2
		1<-2=3
		2<-3=4
		3<-6=5
		6<-high=6
		other=.;

	%let _FN_monthpastdueToMpd=7;

	invalue monthFromTermToMpd
		0=1
		0<-<1=2
		1-<2=3
		2-<3=4
		3-<6=5
		6-high=6
		other=.;

	%let _FN_monthFromTermToMpd=7;

	value mpd
		1='����'
		2='����1-30��'
		3='����31-60��'
		4='����61-90��'
		5='����91-180��'
		6='����180������'
		other='δ֪';

	%let _FN_mpd=7;

	* 24�»���״̬��mpd���ת����ϵ;
	* �������������ӳ��Ϊȱʧ��˵��;
	*	D��Z�ȸ����������£������˱�ӳ��Ϊ��������Ҳ�޷������϶����ڳ̶�;
	* 	C���尴�淶˵��Ҳ��������������������Ҳ�޷�׼ȷ�϶����ڵĳ̶�;
	*	����mpd�ĺϳɽ�ʹ�ö���Դ���������ݣ�������Դ�������ڵ������п��Ի�ȡ��Ϊ׼ȷ��������Ϣ;
	*	������ｫ��ӳ�䵽ȱʧ���Ӷ�������������Դ����Ϣ��mpd���ж�;
	invalue paystatToMpd
		11=.
		20=1
		21=1
		31=2
		32=3
		33=4
		34=5
		35=5
		36=5
		37=6
		40=.
		41=.
		42=.
		43=.
		other=.;

	%let _FN_paystatToMpd=7;

	invalue mpdToMinDays
		1=0
		2=1
		3=31
		4=61
		5=91
		6=181
		other=0;

	%let _FN_mpdToMinDays=7;

	* ������;
	value bad
		1='Good'
		2='Uncertain'
		3='Bad'
		other='Unknown';

	%let _FN_bad=4;

	* badToDummy;
	invalue badToDummy
		1=0
		3=1
		other=.;
	
	%let _FN_badToDummy=3;

	* �Ա�;
	invalue certIdToGender
		1=1
		2=2
		3=1
		4=2
		5=1
		6=2
		7=1
		8=2
		9=1
		0=2
		other=.;

	%let _FN_certIdToGender=3;

	value gender
		1='��'
		2='Ů'
		other='δ֪';
	
	%let FM_gender=3;

	* ������;

	invalue incomeToLevel
		0=1
		0<-25000=2
		25000-50000=3
		50000-100000=4
		100000-200000=5
		200000-500000=6
		500000-1000000=7
		1000000-high=8
		other=.;

	%let _FN_incomeToLevel=9;

	value incomeLevel
		1='0'
		2='0-25K'
		3='25-50K'
		4='50-100K'
		5='100-200K'
		6='200-500K'
		7='500K-1M'
		8='>1M'
		other='N/A';

	%let _FN_incomeLevel=9;

	* ����;
	invalue ageToLevel
		low-<18=1
		18-22=2
		23-27=3
		28-32=4
		33-37=5
		38-42=6
		43-47=7
		48-52=8
		53-57=9
		58-62=10
		63-high=11
		other=.;

	%let _FN_ageToLevel=12;
	
	* �������;
	value ageLevel
		1='<18'
		2='18-22'
		3='23-27'
		4='28-32'
		5='33-37'
		6='38-42'
		7='43-47'
		8='48-52'
		9='53-57'
		10='58-62'
		11='>=63'
		other='δ֪';

	%let _FN_ageToLevel=12;

	* �������A;
	invalue ageToLevelA
		low-<18=1
		18-22=2
		23-27=3
		28-32=4
		33-37=5
		38-42=6
		43-47=7
		48-52=8
		53-57=9
		58-high=10
		other=.;

	%let _FN_ageToLevelA=11;

	value ageLevelA
		1='<18'
		2='18-22'
		3='23-27'
		4='28-32'
		5='33-37'
		6='38-42'
		7='43-47'
		8='48-52'
		9='53-57'
		10='58����'
		other='δ֪';

	%let _FN_ageLevelA=11;

	* ���зּ�ת��;
	* ע�����зּ��ѵ���������ӳ���ϵ�Ѳ���ʹ�ã���ʱ����;
	invalue cityNameToCityLevel
		'����'=1
		'�Ϻ�'=1
		'����'=1
		'����'=1
		'�ɶ�'=2
		'����'=2
		'�人'=2
		'���'=2
		'�Ͼ�'=2
		'����'=2
		'����'=2
		'��ɳ'=2
		'�ൺ'=2
		'����'=2
		'����'=2
		'����'=2
		'����'=2
		'����'=2
		'����'=2
		'����'=3
		'�Ϸ�'=3
		'֣��'=3
		'������'=3
		'��ɽ'=3
		'����'=3
		'��ݸ'=3
		'����'=3
		'̫ԭ'=3
		'�ϲ�'=3
		'����'=3
		'����'=3
		'ʯ��ׯ'=3
		'����'=3
		'Ȫ��'=3
		'����'=3
		'����'=3
		'�麣'=3
		'��'=3
		'��̨'=3
		'����'=3
		'����'=3
		'��³ľ��'=3
		'����'=3
		'����'=3
		'Ϋ��'=3
		'����'=3
		'��ͨ'=3
		'����'=3
		'��ͷ'=3
		other=4;
	%let _FN_cityNameToCityLevel=4;

	* ���зּ�;
	value cityLevel
		1='һ�߳���'
		2='���߳���'
		3='���߳���'
		4='���߳���'
		other='����';

	%let _FN_cityLevel=5;

	* �����������뵽���зּ�ת��;
	* ������������������Ϊ��λ��ֱϽ��;
	invalue areaCodeToCityLevel
		4401=1		/*	����		*/
		4403=1		/*	����		*/
		5101=2		/*	�ɶ�		*/
		3301=2		/*	����		*/
		4201=2		/*	�人		*/
		3201=2		/* 	�Ͼ�		*/
		6101=2		/*	����		*/
		4301=2		/*	��ɳ		*/
		3702=2		/*	�ൺ		*/
		2101=2		/*	����		*/
		2102=2		/*	����		*/
		3502=2		/*	����		*/
		3205=2		/*	����		*/
		3302=2		/*	����		*/
		3202=2		/*	����		*/
		3501=3		/*	����		*/
		3401=3		/*	�Ϸ�		*/
		4101=3		/*	֣��		*/
		2301=3		/*	������	*/
		4406=3		/*	��ɽ		*/
		3701=3		/*	����		*/
		4419=3		/*	��ݸ		*/
		5301=3		/*	����		*/
		1401=3		/*	̫ԭ		*/
		3601=3		/*	�ϲ�		*/
		4501=3		/*	����		*/
		3303=3		/*	����		*/
		1301=3		/*	ʯ��ׯ	*/
		2201=3		/*	����		*/
		3505=3		/*	Ȫ��		*/
		5201=3		/*	����		*/
		3204=3		/*	����		*/
		4404=3		/*	�麣		*/
		3307=3		/*	��		*/
		3706=3		/*	��̨		*/
		4601=3		/*	����		*/
		4413=3		/*	����		*/
		6501=3		/*	��³ľ��	*/
		3203=3		/*	����		*/
		3304=3		/*	����		*/
		3707=3		/*	Ϋ��		*/
		4103=3		/*	����		*/
		3206=3		/*	��ͨ		*/
		3210=3		/*	����		*/
		4405=3		/*	��ͷ		*/
		other=4;

	%let _FN_areaCodeToCityLevel=4;

	* �绰�������ת��format;
	invalue mphoneToLevel
		0=1
		0-1=2
		1-2=3
		2-3=4
		3-high=5
		other=1;

	%let _FN_mphoneToLevel=5;

	value mphoneLevel
		1='���ֻ���'
		2='����ʹ��'
		3='2�˹���'
		4='3�˹���'
		5='4�������˹���';
	
	%let _FN_mphoneLevel=5;

	invalue mphoneShareToLevel
		0=1
		1=2
		2-high=3
		other=.;

	invalue mphoneunqToLevel
		0=1
		1=2
		2-high=3
		other=.;


	* currJobYear -> currJobYearLevel;
	invalue currJobYearToLevel
		0-1=1
		1-2=2
		2-3=3
		3-5=4
		5-10=5
		10-20=6
		20-high=7
		other=.;

	%let _FN_currJobYearToLevel=8;

	value currJobYearLevel
		1='С��1��'
		2='1-2��'
		3='2-3��'
		4='3-5��'
		5='5-10��'
		6='10-20��'
		7='20������'
		other='����';

	%let _FN_currJobYearLevel=8;

	* ͨ�ðٷֱȷ��� ÿ10%Ϊһ��;
	invalue pctToLevel
		0=1
		0<-<0.1=2
		0.1-<0.2=3
		0.2-<0.3=4
		0.3-<0.4=5
		0.4-<0.5=6
		0.5-<0.6=7
		0.6-<0.7=8
		0.7-<0.8=9
		0.8-<0.9=10
		0.9-<1=11
		1=12
		other=.;	
	
	%let _FN_pctToLevel=13;

	value pctLevel
		1='0%'
		2='0(����)-10%'
		3='10-20%'
		4='20-30%'
		5='30-40%'
		6='40-50%'
		7='50-60%'
		8='60-70%'
		9='70-80%'
		10='80-90%'
		11='90-100%(����)'
		12='100%'
		other='����';

	%let _FN_pctLevel=13;

	* ͨ�����ʷ���;
	invalue rateToLevel
		low-0=1
		0-0.025=2
		0.025-0.05=3
		0.05-0.075=4
		0.075-0.1=5
		0.1-0.15=6
		0.15-0.2=7
		0.2-0.25=8
		0.25-0.3=9
		0.3-0.4=10
		0.4-high=11
		other=.;
	
	%let _FN_rateToLevel=12;

	value rateLevel
		1='0������'
		2='0-2.5%'
		3='2.5-5%'
		4='5-7.5%'
		5='7.5-10%'
		6='10-15%'
		7='15-20%'
		8='20-25%'
		9='25-30%'
		10='30-40%'
		11='40%����'
		other='����';

	%let _FN_rateLevel=12;

	* ͨ�ô��������;
	invalue loanMoneyToLevel
		0=1
		0-5000=2
		5000-10000=3
		10000-20000=4
		20000-50000=5
		50000-100000=6
		100000-250000=7
		250000-high=8
		other=.;

	%let _FN_loanMoneyToLevel=9;

	value loanMoneyLevel
		1='0'
		2='0-5K'
		3='5K-10K'
		4='10K-20K'
		5='20K-50K'
		6='50K-100K'
		7='100K-250K'
		8='250K����'
		other='����';

	%let _FN_loanMoneyLevel=9;

	* ͨ�ô����������;
	invalue acctToLevel
		0=1
		0-1=2
		1-2=3
		2-3=4
		3-high=5
		other=.;

	%let _FN_acctToLevel=6;

	value acctLevel
		1='0��'
		2='1��'
		3='2��'
		4='3��'
		5='3������'
		other='����';

	%let _FN_acctLevel=6;

	* ͨ���������;
	* ���䵥λΪ��;
	invalue	mobToLevel
		0-3=1
		3-6=2
		6-12=3
		12-24=4
		24-36=5
		36-high=6
		other=.;

	%let _FN_mobToLevel=7;

	value mobLevel
		1='0-3����'
		2='3-6����'
		3='6-12����'
		4='12-24����'
		5='24-36����'
		6='36��������'
		other='����';

	%let _FN_mobLevel=7;

	* ͨ�û���������;
	invalue orgToLevel
		0=1
		0-1=2
		1-2=3
		2-high=4
		other=.;

	%let _FN_orgToLevel=5;

	value orgLevel
		1='0������'
		2='1������'
		3='2������'
		4='3������������'
		other='����';

	%let _FN_orgLevel=5;

	* ͨ��ratioת��;
	invalue ratioToLevel
		0=1
		0<-<0.2=2
		0.2-<0.4=3
		0.4-<0.6=4
		0.6-<0.8=5
		0.8-<1.0=6
		1-<2=7
		2-<3=8
		3-<4=9
		4-<5=10
		5-high=11
		other=.;

	%let _FN_ratioToLevel=12;

	value ratioLevel
		1='0%'
		2='0-20%'
		3='20-40%'
		4='40-60%'
		5='60-80%'
		6='80-100%'
		7='100-200%'
		8='200-300%'
		9='300-400%'
		10='400-500%'
		11='500����'
		other='����';

	%let _FN_ratioLevel=12;
	
	* ʡ���뵽ʡ����ת��;
	value province
		11='����'
		12='���'
		13='�ӱ�'
		14='ɽ��'
		15='���ɹ�'
		21='����'
		22='����'
		23='������'
		31='�Ϻ�'
		32='����'
		33='�㽭'
		34='����'
		35='����'
		36='����'
		37='ɽ��'
		41='����'
		42='����'
		43='����'
		44='�㶫'
		45='����'
		46='����'
		50='����'
		51='�Ĵ�'
		52='����'
		53='����'
		54='����'
		61='����'
		62='����'
		63='�ຣ'
		64='����'
		65='�½�'
		other='����';

	%let _FN_province=32;

	* ʡ���Ƶ�ʡ����ת��;
	invalue provinceNameToCode
		'����'=11 '������'=11
		'���'=12 '�����'=12
		'�ӱ�'=13 '�ӱ�ʡ'=13
		'ɽ��'=14 'ɽ��ʡ'=14
		'���ɹ�'=15 '����'=15 '���ɹ�������'=15
		'����'=21 '����ʡ'=21
		'����'=22 '����ʡ'=22
		'������'=23 '������ʡ'=23
		'�Ϻ�'=31 '�Ϻ���'=31
		'����'=32 '����ʡ'=32
		'�㽭'=33 '�㽭ʡ'=33
		'����'=34 '����ʡ'=34
		'����'=35 '����ʡ'=35
		'����'=36 '����ʡ'=36
		'ɽ��'=37 'ɽ��ʡ'=37
		'����'=41 '����ʡ'=41 
		'����'=42 '����ʡ'=42 
		'����'=43 '����ʡ'=43
		'�㶫'=44 '�㶫ʡ'=44
		'����'=45 '����ʡ'=45
		'����'=46 '����ʡ'=46
		'����'=50 '������'=50
		'�Ĵ�'=51 '�Ĵ�ʡ'=51
		'����'=52 '����ʡ'=52
		'����'=53 '����ʡ'=53
		'����'=54 '����������'=54
		'����'=61 '����ʡ'=61
		'����'=62 '����ʡ'=62
		'�ຣ'=63 '�ຣʡ'=63
		'����'=64 '����������'=64 '���Ļ���������'=64
		'�½�'=65 '�½�������'=65 '�½�ά���������'=65
		other=.;
	
	%let _FN_provinceNameToCode=32;

	* ʡ����;
	* ���۲���ٵ�ʡ�ݽ��кϲ�;
	invalue provinceToProvinceA
		54=100
		62=100
		63=100
		64=100
		65=100
		other=[d.];
	%let _FN_provinceToProvinceA=28;

	value eduLevelA
		10='�о���'
		20='����'
		30='ר��'
		40='��ר��У'
		60='����'
		70='���м�����'
		other='δ֪';

	%let _FN_eduLevelA=7;

	* ������Ӫ��;
	invalue telCorpToCode
		'�й��ƶ�'=1
		'�й���ͨ'=2
		'�й�����'=3
		other=.;

	%let _FN_telCorpToCode=4;

	value telCorp
		1='�й��ƶ�'
		2='�й���ͨ'
		3='�й�����'
		other='����';

	%let _FN_telCorp=4;

	* mobstd����;
	invalue mobstdToLevel
		0-1=1
		1-2=2
		2-3=3
		3-6=4
		6-high=5
		other=.;

	%let _FN_mobstdToLevel=6;

	value mobstdLevel
		1='0-1��'
		2='1-2��'
		3='2-3��'
		4='3-6��'
		5='6������'
		other='����';

	%let _FN_mobstdLevel=6;

	* monthpdToLevel;
	invalue monthpdToLevel
		0=1
		0-1=2
		1-2=3
		2-3=4
		3-6=5
		6-12=6
		12-24=7
		24-36=8
		36-high=9
		other=.;

	%let _FN_monthpdToLevel=10;

	value monthpdLevel
		1='������'
		2='����0-1��'
		3='����1-2��'
		4='����2-3��'
		5='����3-6��'
		6='����6-12��'
		7='����12-24��'
		8='����24-36��'
		9='����36������'
		other='����';

	%let _FN_monthpdLevel=10;

	* pdspeedToLevel;
	invalue pdspeedToLevel
		0=1
		0-0.0417=2
		0.0417-0.0833=3
		0.0833-0.1667=4
		0.1667-0.3333=5
		0.3333-high=6
		other=.;

	%let _FN_pdspeedToLevel=7;

	value pdspeedLevel
		1='������'
		2='����24����'
		3='12-24����'
		4='6-12����'
		5='3-6����'
		6='С��3����'
		other='����';

	%let _FN_pdspeedLevel=7;

	* irr����;
	invalue irrToLevel
		low-0.06=1
		0.06-0.09=2
		0.09-0.12=3
		0.12-0.15=4
		0.15-0.18=5
		0.18-0.21=6
		0.21-0.24=7
		0.24-0.27=8
		0.27-0.30=9
		0.30-0.33=10
		0.33-high=11
		other=.;

	%let _FN_irrToLevel=12;

	value irrLevel
		1='<6%'
		2='6-9%'
		3='9-12%'
		4='12-15%'
		5='15-18%'
		6='18-21%'
		7='21-24%'
		8='24-27%'
		9='27-30%'
		10='30-33%'
		11='33%����'
		other='����';

	%let _FN_irrLevel=12;

	* gtp����;
	invalue gtpToLevel
		0=1
		0.00-0.33=2
		0.33-0.66=3
		0.66-<1=4
		1=5
		other=.;	
	
	%let _FN_gtpToLevel=6;

	value gtpLevel
		1='0%'
		2='0-33%'
		3='33-66%'
		4='66-100%'
		5='100%'
		other='����';

	%let _FN_gtpLevel=6;

	* balIncomeRatioLevel;
	invalue balIncomeRatioToLevel
		0=1
		0-0.2=2
		0.2-0.4=3
		0.4-0.6=4
		0.6-0.8=5
		0.8-1.0=6
		1.0-2.0=7
		2.0-high=8
		other=.;

	%let _FN_balIncomeRatioToLevel=9;

	value balIncomeRatioLevel
		1='0%'
		2='0-20%'
		3='20-40%'
		4='40-60%'
		5='60-80%'
		6='80-100%'
		7='100-200%'
		8='200%����'
		other='����';

	%let _FN_balIncomeRatioLevel=9;

	* ppLevel;
	invalue ppToLevel
		0-0.3333=1
		0.3333-0.6667=2
		0.6667-<1=3
		1=4
		other=.;	

	%let _FN_ppToLevel=5;
	
	value ppLevel
		1='0-33%'
		2='33-66%'
		3='66-100%'
		4='100%'
		other='����';

	%let _FN_ppLevel=5;
	
		* ���⽻����������;
	invalue speculiartradetype
		'1'=1
		'2'=2
		'3'=3
		'4'=4
		'5'=5
		'6'=6
		'7'=7
		'8'=8
		other=.;

	%let _FN_speculiartradetype=9;

	* ���⽻������;
	value spectype
		1='չ��'
		2='�����˴���'
		3='���ʵ�ծ'
		4='������ǰ����'
		5='ȫ����ǰ����'
		6='������Ƿ'
		7='��������'
		8='������թ'
		other='δ֪';

	%let _FN_spectype=9;
	
	* ���⽻������->�Ƿ�Ϊ������Ϣ;
	
	invalue spectyeToNeg
		6-8=1
		1-5=2
		other=.
	;

	%let _FN_spectyeToNeg=3;

	* �Ƿ�Ϊ�������⽻�����ͣ��������ͼ򻯣�;
	value sptn
		1='������Ϣ'
		2='�Ǹ�����Ϣ'
		other='δ֪';

	%let _FN_sptn=3;
	
	* integer individual(II) to binary;
	* II2B+value+Informat;
	invalue II2B1I
		1=1
		other=0
	;
	invalue II2B2I
		2=1
		other=0
	;
	invalue II2B3I
		3=1
		other=0
	;
	invalue II2B4I
		4=1
		other=0
	;
	invalue II2B5I
		5=1
		other=0
	;
	invalue II2B6I
		6=1
		other=0
	;

	* float interval(FL) to binary;
	* IL2B+S+start+E+end+LeftEqual+RightEqual+informat;
	
	* (0,1];
	invalue FL2BS0E1RI
		0<-1=1
		other=0
	;
	* (0,2];
	invalue FL2BS0E2RI
		0<-2=1
		other=0
	;
	* (0,3];
	invalue FL2BS0E3RI
		0<-3=1
		other=0
	;
	* (0,4];
	invalue FL2BS0E4RI
		0<-4=1
		other=0
	;
	* (0,5];
	invalue FL2BS0E5RI
		0<-5=1
		other=0
	;
	* (0,6];
	invalue FL2BS0E6RI
		0<-6=1
		other=0
	;
	* (0,+inf);
	invalue FL2BS0I
		0<-high=1
		other=0
	;
	* (1,+inf);
	invalue FL2BS1I
		1<-high=1
		other=0
	;
	* (2,+inf);
	invalue FL2BS2I
		2<-high=1
		other=0
	;
	* (3,+inf);
	invalue FL2BS3I
		3<-high=1
		other=0
	;
	* (4,+inf);
	invalue FL2BS4I
		4<-high=1
		other=0
	;
	* (5,+inf);
	invalue FL2BS5I
		5<-high=1
		other=0
	;
	* (6,+inf);
	invalue FL2BS6I
		6<-high=1
		other=0
	;
	* (7,+inf);
	invalue FL2BS7I
		7<-high=1
		other=0
	;
	* (24,+inf);
	invalue FL2BS24I
		24<-high=1
		other=0
	;
	* (0,1k);
	invalue FL2BS0E1kI
		0<-<1000=1
		other=0
	;
	* [1K,2.5k);
	invalue FL2BS1kE2P5kLI
		1000-<2500=1
		other=0
	;
	* [2.5k,5k);
	invalue FL2BS2P5kE5kLI
		2500-<5000=1
		other=0
	;
	* [5k,10k);
	invalue FL2BS5kE10kLI
		5000-<10000=1
		other=0
	;
	* [10k,25k);
	invalue FL2BS10kE25kLI
		10000-<25000=1
		other=0
	;
	* [25k,+inf);
	invalue FL2BS25kLI
		25000-high=1
		other=0
	;
quit;

* format״̬����ӳ�������;
%*genGlobalFormatNMaps;