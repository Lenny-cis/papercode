* ---------------------------------------;
* --------------- formats ---------------;
* ---------------------------------------;
* 各种formats;

proc format;

	* ---------------------------------;
	* ---------- 常用formats ----------;
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
	* ---------- 数据转换用formats ------------;
	* ----------------------------------------;
	* 婚姻状态;
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
		10='未婚'
		20='已婚'
		21='初婚'
		22='再婚'
		23='复婚'
		30='丧偶'
		40='离婚'
		other='未知';

	%let _FN_MARRIAGE=8;

	* 学历相关;
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
		10='研究生'
		20='本科'
		30='专科'
		40='中专'
		50='技校'
		60='高中'
		70='初中'
		80='小学'
		90='文盲'
		other='未知';

	%let _FN_iedulevel=10;

	invalue eduLevelToEduLevelA
		50=40
		80=70
		90=70
		other=[d.];
	
	%let _FN_eduLevelToEduLevelA=7;

	value eduLevelA
		10='研究生'
		20='本科'
		30='专科'
		40='中专技校'
		60='高中'
		70='初中及以下'
		other='未知';

	%let _FN_eduLevelA=7;

	* 学位;
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
		1='名誉博士'
		2='博士'
		3='硕士'
		4='学士'
		other='未知';

	%let _FN_edudegree=5;

	* 联系人类型;
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
		1='父子（女）'
		2='母子（女）'
		3='配偶'
		4='子女'
		5='其他亲属'
		6='同事'
		7='朋友'
		8='兄弟姐妹'
		other='未知';

	%let _FN_contactrelation=9;

	* 职业;
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
		1='国家机关、党群组织、企业、事业单位负责人'
		2='专业技术人员'
		3='办事人员和有关人员'
		4='商业、服务业人员'
		5='农、林、牧、渔、水利业生产人员'
		6='生产、运输设备操作人员及有关人员'
		7='军人'
		other='未知';

	%let _FN_occupation=8;

	* 行业;
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
		1='农、林、牧、渔业'
		2='采掘业'
		3='制造业'
		4='电力、燃气及水的生产和供应业'
		5='建筑业'
		6='交通运输、仓储和邮政业'
		7='信息传输、计算机服务和软件业'
		8='批发和零售业'
		9='住宿和餐饮业'
		10='金融业'
		11='房地产业'
		12='租赁和商务服务业'
		13='科学研究、技术服务业和地质勘察业'
		14='水利、环境和公共设施管理业'
		15='居民服务和其他服务业'
		16='教育'
		17='卫生、社会保障和社会福利业'
		18='文化、体育和娱乐业'
		19='公共管理和社会组织'
		20='国际组织'
		other='未知';

	%let _FN_industry=21;

	invalue industryToIndustryA
		20=19
		other=[d.0];

	%let _FN_industryToIndustryA=20;

	value industryA
		1='农、林、牧、渔业'
		2='采掘业'
		3='制造业'
		4='电力、燃气及水的生产和供应业'
		5='建筑业'
		6='交通运输、仓储和邮政业'
		7='信息传输、计算机服务和软件业'
		8='批发和零售业'
		9='住宿和餐饮业'
		10='金融业'
		11='房地产业'
		12='租赁和商务服务业'
		13='科学研究、技术服务业和地质勘察业'
		14='水利、环境和公共设施管理业'
		15='居民服务和其他服务业'
		16='教育'
		17='卫生、社会保障和社会福利业'
		18='文化、体育和娱乐业'
		19='公共管理、社会组织、国际组织'
		other='未知';

	%let _FN_industryA=20;

	* 职务;
	invalue iposition
		'1'=1
		'2'=2
		'3'=3
		'4'=4
		'9'=.
		other=.;

	%let _FN_iposition=5;

	value position
		1='高级领导'
		2='中级领导'
		3='一般员工'
		4='其他'
		other='未知';

	%let _FN_position=5;

	* 职称;
	invalue ititle
		'0'=0
		'1'=1
		'2'=2
		'3'=3
		'9'=.
		other=.;

	%let _FN_ititle=5;

	value title
		0='无'
		1='高级'
		2='中级'
		3='初级'
		other='未知';
	
	%let _FN_title=5;

	* 居住状况;
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
	
	value condition
		1='自置'
		2='按揭'
		3='亲属楼宇'
		4='集体宿舍'
		5='租房'
		6='共有住宅'
		other='未知';

	%let _FN_condition=7;

	* resCond重分类;
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
		1='自置'
		2='按揭'
		3='亲属楼宇'
		4='集体宿舍'
		5='租房与共有住宅'
		other='未知';
	
	%let _FN_resCondA=6;

	* 贷款类型生成;
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

	* 贷款类型;
	value loantype
		11='个人住房贷款'
		12='个人商用房贷款'
		13='个人住房公积金贷款'
		21='个人汽车消费贷款'
		31='个人助学贷款'
		41='个人经营性贷款'
		51='农户贷款'
		91='个人消费贷款'
		other='未知';

	%let _FN_loantype=9;

	* 贷款申请状态;
	invalue sapplystate
		'1'=1
		'2'=2
		'3'=3
		other=.;

	%let _FN_sapplystate=4;

	value applystate
		1='申请中'
		2='已批准'
		3='未通过'
		other=.;

	%let _FN_applystate=4;

	* 贷款担保类型生成;
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
		1='质押（含保证金）'
		2='抵押'
		3='自然人保证'
		4='信用/免担保'
		5='组合（含自然人保证）'
		6='组合（不含自然人保证）'
		7='农户联保'
		other='未知';

	%let _FN_guaranteeway=8;

	* 贷款担保类型->是否为担保贷款;
	invalue guranteewayToLtgt
		4=1
		1-3=2
		5-7=2
		other=.;

	%let _FN_guranteewayToLtgt=3;

	* 是否为担保贷款（担保类型简化）;
	value ltgt
		1='信用'
		2='非信用'
		other='未知';

	%let _FN_ltgt=3;

	* 贷款金额->贷款金额类型;
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

	* 贷款金额类型;
	value ltamt
		1='1K以下'
		2='1K-2.5K'
		3='2.5K-5K'
		4='5K-10K'
		5='10K-50K'
		6='50K-100K'
		7='100K以上'
		other='未知';

	%let _FN_ltamt=8;

	* 贷款总月数->贷款期限长度类型;
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

	* 贷款期限长度类型;
	value ltterm
		1='1个月及以下'
		2='3个月及以下'
		3='6个月及以下'
		4='1年及以下'
		5='2年及以下'
		6='2年以上'
		other='未知';

	%let _FN_ltterm=7;

	* 贷款还款频率;
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
		1='日'
		2='周'
		3='月'
		4='季'
		5='半年'
		6='年'
		7='一次性'
		8='不定期'
		other='其他';

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
		1='严格对齐'
		2='开立日对齐'
		3='到期日对齐'
		4='其他日对齐'
		other='非对齐';

	%let _FN_termalign=5;

	* termsfreq对应一年内的期数;
	invalue termsfreqTo1YearTerms
		1=365
		2=52
		3=12
		4=4
		5=2
		6=1
		other=.;

	%let _FN_termsfreqTo1YearTerms=7;

	* 贷款账户状态;
	invalue iaccountstat
		'1'=1
		'2'=2
		'3'=3
		'4'=4
		'5'=5
		other=.;

	%let _FN_iaccountstat=6;

	value accountstat
		1='正常'
		2='逾期'
		3='结清'
		4='呆账（待核销）'
		5='转出'
		other='未知';

	%let _FN_accountstat=6;

	* 贷款账户终态;
	value acctfinstat
		10='未开立'
		21='正常存续'
		22='提前还款结清'
		23='提前核销'
		29='提前其他负面结清'
		31='到期存续'
		32='到期正常结清'
		33='到期核销'
		39='到期其他负面结清'
		41='超期存续'
		42='超期结清'
		43='超期核销'
		49='超期其他负面结清'
		other='未知';

	%let _FN_acctfinstat=14;

	* 贷款5级分类生成;
	invalue iclass5stat
		'1'=1
		'2'=2
		'3'=3
		'4'=4
		'5'=5
		'9'=.
		other=.;

	%let _FN_iclass5stat=6;

	* 贷款5级分类;
	value class5stat
		1='正常'
		2='关注'
		3='次级'
		4='可疑'
		5='损失'
		other='未知';

	%let _FN_class5stat=6;

	* 信用报告查询原因生成;
	invalue sreason
		'贷款审批'=1
		'贷后管理'=2
		'本人查询'=3
		'异议查询'=4
		'担保资格审查'=5
		'金融监管'=6
		'司法调查'=7
		'未知原因'=.
		other=.;

	%let _FN_sreason=8;

	* 信用报告查询原因;
	value reason
		1='贷款审批'
		2='贷后管理'
		3='本人查询'
		4='异议查询'
		5='担保资格审查'
		6='金融监管'
		7='司法调查'
		other='未知';

	%let _FN_requestreason=8;

	* 信用报告查询类型->查询结果;
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

	* 信用报告查询结果;
	value result
		1='查得'
		2='未查得'
		other='未知';

	%let _FN_requestresult=3;

	* 信用报告查询类型->查询渠道;
	*	1	在线单笔;
	*	2	在线批量;
	*	3	直连单笔;
	*	4 	直连批量;	
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

	* 信用报告查询渠道;
	value channel
		1='在线单笔'
		2='在线批量'
		3='直连单笔'
		4='直连批量'
		other='未知';

	%let _FN_requestchannel=5;

	* 24月还款状态;
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

	* n月还款状态;
	value paystat
		11='未开立账户'
		20='正常（当月不需要还款）'
		21='正常'
		31='逾期1-30天'
		32='逾期31-60天'
		33='逾期61-90天'
		34='逾期91-120天'
		35='逾期121-150天'
		36='逾期151-180天'
		37='逾期180天以上'
		40='结清'
		41='以资抵债'
		42='担保人代还'
		43='结束'
		other='未知';

	%let _FN_paystat=15;
	
	* 还款编码;
	value paycode
		11='开立时点-全额支付'
		12='开立时点-部分支付'
		13='开立时点-超额支付'
		14='开立时点-无支付计划'
		15='开立时点-计划外支付'
		21='一般时点-全额支付'
		22='一般时点-部分支付'
		23='一般时点-超额支付'
		24='一般时点-无支付计划'
		25='一般时点-计划外支付'
		31='到期时点-全额支付'
		32='到期时点-部分支付'
		33='到期时点-超额支付'
		34='到期时点-无支付计划'
		35='到期时点-计划外支付'
		41='过期时点-全额支付'
		42='过期时点-部分支付'
		43='过期时点-超额支付'
		44='过期时点-无支付计划'
		45='过期时点-计划外支付'
		other='未知';

	%let _FN_paycode=21;

	* 还款模式;
	value paytype
		1='等额本息'
		2='息票'
		3='等额本金'
		other='未知';

	%let _FN_paytype=4;

	* 还款对齐类型;
	value payalign
		1='双对齐'
		2='左对齐'
		3='右对齐'
		4='中对齐'
		9='非对齐'
		other='未知';

	%let _FN_payalign=6;

	* 逾期月数;
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
		1='正常'
		2='逾期1-30天'
		3='逾期31-60天'
		4='逾期61-90天'
		5='逾期91-180天'
		6='逾期180天以上'
		other='未知';

	%let _FN_mpd=7;

	* 24月还款状态与mpd间的转换关系;
	* 将负面结清的情况映射为缺失的说明;
	*	D、Z等负面结清情况下，不适宜被映射为正常，但也无法合理认定逾期程度;
	* 	C结清按规范说明也包含负面结清的情况，因此也无法准确认定逾期的程度;
	*	由于mpd的合成将使用多来源、多期数据，其他来源或其他期的数据中可以获取更为准确的逾期信息;
	*	因此这里将其映射到缺失，从而不干扰其他来源的信息对mpd的判定;
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

	* 坏定义;
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

	* 性别;
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
		1='男'
		2='女'
		other='未知';
	
	%let FM_gender=3;

	* 年收入;

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

	* 年龄;
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
	
	* 年龄分组;
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
		other='未知';

	%let _FN_ageToLevel=12;

	* 年龄分组A;
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
		10='58以上'
		other='未知';

	%let _FN_ageLevelA=11;

	* 城市分级转换;
	* 注：城市分级已调整，以下映射关系已不再使用，暂时保留;
	invalue cityNameToCityLevel
		'北京'=1
		'上海'=1
		'广州'=1
		'深圳'=1
		'成都'=2
		'杭州'=2
		'武汉'=2
		'天津'=2
		'南京'=2
		'重庆'=2
		'西安'=2
		'长沙'=2
		'青岛'=2
		'沈阳'=2
		'大连'=2
		'厦门'=2
		'苏州'=2
		'宁波'=2
		'无锡'=2
		'福州'=3
		'合肥'=3
		'郑州'=3
		'哈尔滨'=3
		'佛山'=3
		'济南'=3
		'东莞'=3
		'昆明'=3
		'太原'=3
		'南昌'=3
		'南宁'=3
		'温州'=3
		'石家庄'=3
		'长春'=3
		'泉州'=3
		'贵阳'=3
		'常州'=3
		'珠海'=3
		'金华'=3
		'烟台'=3
		'海口'=3
		'惠州'=3
		'乌鲁木齐'=3
		'徐州'=3
		'嘉兴'=3
		'潍坊'=3
		'洛阳'=3
		'南通'=3
		'扬州'=3
		'汕头'=3
		other=4;
	%let _FN_cityNameToCityLevel=4;

	* 城市分级;
	value cityLevel
		1='一线城市'
		2='二线城市'
		3='三线城市'
		4='四线城市'
		other='其他';

	%let _FN_cityLevel=5;

	* 行政区划编码到城市分级转换;
	* 不包含行政区划编码为两位的直辖市;
	invalue areaCodeToCityLevel
		4401=1		/*	广州		*/
		4403=1		/*	深圳		*/
		5101=2		/*	成都		*/
		3301=2		/*	杭州		*/
		4201=2		/*	武汉		*/
		3201=2		/* 	南京		*/
		6101=2		/*	西安		*/
		4301=2		/*	长沙		*/
		3702=2		/*	青岛		*/
		2101=2		/*	沈阳		*/
		2102=2		/*	大连		*/
		3502=2		/*	厦门		*/
		3205=2		/*	苏州		*/
		3302=2		/*	宁波		*/
		3202=2		/*	无锡		*/
		3501=3		/*	福州		*/
		3401=3		/*	合肥		*/
		4101=3		/*	郑州		*/
		2301=3		/*	哈尔滨	*/
		4406=3		/*	佛山		*/
		3701=3		/*	济南		*/
		4419=3		/*	东莞		*/
		5301=3		/*	昆明		*/
		1401=3		/*	太原		*/
		3601=3		/*	南昌		*/
		4501=3		/*	南宁		*/
		3303=3		/*	温州		*/
		1301=3		/*	石家庄	*/
		2201=3		/*	长春		*/
		3505=3		/*	泉州		*/
		5201=3		/*	贵阳		*/
		3204=3		/*	常州		*/
		4404=3		/*	珠海		*/
		3307=3		/*	金华		*/
		3706=3		/*	烟台		*/
		4601=3		/*	海口		*/
		4413=3		/*	惠州		*/
		6501=3		/*	乌鲁木齐	*/
		3203=3		/*	徐州		*/
		3304=3		/*	嘉兴		*/
		3707=3		/*	潍坊		*/
		4103=3		/*	洛阳		*/
		3206=3		/*	南通		*/
		3210=3		/*	扬州		*/
		4405=3		/*	汕头		*/
		other=4;

	%let _FN_areaCodeToCityLevel=4;

	* 电话号码个数转换format;
	invalue mphoneToLevel
		0=1
		0-1=2
		1-2=3
		2-3=4
		3-high=5
		other=1;

	%let _FN_mphoneToLevel=5;

	value mphoneLevel
		1='无手机号'
		2='个人使用'
		3='2人共享'
		4='3人共享'
		5='4及以上人共享';
	
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
		1='小于1年'
		2='1-2年'
		3='2-3年'
		4='3-5年'
		5='5-10年'
		6='10-20年'
		7='20年以上'
		other='不详';

	%let _FN_currJobYearLevel=8;

	* 通用百分比分组 每10%为一组;
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
		2='0(不含)-10%'
		3='10-20%'
		4='20-30%'
		5='30-40%'
		6='40-50%'
		7='50-60%'
		8='60-70%'
		9='70-80%'
		10='80-90%'
		11='90-100%(不含)'
		12='100%'
		other='其他';

	%let _FN_pctLevel=13;

	* 通用利率分组;
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
		1='0或负利率'
		2='0-2.5%'
		3='2.5-5%'
		4='5-7.5%'
		5='7.5-10%'
		6='10-15%'
		7='15-20%'
		8='20-25%'
		9='25-30%'
		10='30-40%'
		11='40%以上'
		other='其他';

	%let _FN_rateLevel=12;

	* 通用贷款金额分组;
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
		8='250K以上'
		other='其他';

	%let _FN_loanMoneyLevel=9;

	* 通用贷款笔数分组;
	invalue acctToLevel
		0=1
		0-1=2
		1-2=3
		2-3=4
		3-high=5
		other=.;

	%let _FN_acctToLevel=6;

	value acctLevel
		1='0笔'
		2='1笔'
		3='2笔'
		4='3笔'
		5='3笔以上'
		other='其他';

	%let _FN_acctLevel=6;

	* 通用账龄分组;
	* 账龄单位为月;
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
		1='0-3个月'
		2='3-6个月'
		3='6-12个月'
		4='12-24个月'
		5='24-36个月'
		6='36个月以上'
		other='其他';

	%let _FN_mobLevel=7;

	* 通用机构数分组;
	invalue orgToLevel
		0=1
		0-1=2
		1-2=3
		2-high=4
		other=.;

	%let _FN_orgToLevel=5;

	value orgLevel
		1='0个机构'
		2='1个机构'
		3='2个机构'
		4='3个机构及以上'
		other='其他';

	%let _FN_orgLevel=5;

	* 通用ratio转换;
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
		11='500以上'
		other='其他';

	%let _FN_ratioLevel=12;
	
	* 省代码到省名称转换;
	value province
		11='北京'
		12='天津'
		13='河北'
		14='山西'
		15='内蒙古'
		21='辽宁'
		22='吉林'
		23='黑龙江'
		31='上海'
		32='江苏'
		33='浙江'
		34='安徽'
		35='福建'
		36='江西'
		37='山东'
		41='河南'
		42='湖北'
		43='湖南'
		44='广东'
		45='广西'
		46='海南'
		50='重庆'
		51='四川'
		52='贵州'
		53='云南'
		54='西藏'
		61='陕西'
		62='甘肃'
		63='青海'
		64='宁夏'
		65='新疆'
		other='其他';

	%let _FN_province=32;

	* 省名称到省代码转换;
	invalue provinceNameToCode
		'北京'=11 '北京市'=11
		'天津'=12 '天津市'=12
		'河北'=13 '河北省'=13
		'山西'=14 '山西省'=14
		'内蒙古'=15 '内蒙'=15 '内蒙古自治区'=15
		'辽宁'=21 '辽宁省'=21
		'吉林'=22 '吉林省'=22
		'黑龙江'=23 '黑龙江省'=23
		'上海'=31 '上海市'=31
		'江苏'=32 '江苏省'=32
		'浙江'=33 '浙江省'=33
		'安徽'=34 '安徽省'=34
		'福建'=35 '福建省'=35
		'江西'=36 '江西省'=36
		'山东'=37 '山东省'=37
		'河南'=41 '河南省'=41 
		'湖北'=42 '湖北省'=42 
		'湖南'=43 '湖南省'=43
		'广东'=44 '广东省'=44
		'广西'=45 '广西省'=45
		'海南'=46 '海南省'=46
		'重庆'=50 '重庆市'=50
		'四川'=51 '四川省'=51
		'贵州'=52 '贵州省'=52
		'云南'=53 '云南省'=53
		'西藏'=54 '西藏自治区'=54
		'陕西'=61 '陕西省'=61
		'甘肃'=62 '甘肃省'=62
		'青海'=63 '青海省'=63
		'宁夏'=64 '宁夏自治区'=64 '宁夏回族自治区'=64
		'新疆'=65 '新疆自治区'=65 '新疆维吾尔自治区'=65
		other=.;
	
	%let _FN_provinceNameToCode=32;

	* 省区简化;
	* 将观测较少的省份进行合并;
	invalue provinceToProvinceA
		54=100
		62=100
		63=100
		64=100
		65=100
		other=[d.];
	%let _FN_provinceToProvinceA=28;

	value eduLevelA
		10='研究生'
		20='本科'
		30='专科'
		40='中专技校'
		60='高中'
		70='初中及以下'
		other='未知';

	%let _FN_eduLevelA=7;

	* 电信运营商;
	invalue telCorpToCode
		'中国移动'=1
		'中国联通'=2
		'中国电信'=3
		other=.;

	%let _FN_telCorpToCode=4;

	value telCorp
		1='中国移动'
		2='中国联通'
		3='中国电信'
		other='其他';

	%let _FN_telCorp=4;

	* mobstd分组;
	invalue mobstdToLevel
		0-1=1
		1-2=2
		2-3=3
		3-6=4
		6-high=5
		other=.;

	%let _FN_mobstdToLevel=6;

	value mobstdLevel
		1='0-1月'
		2='1-2月'
		3='2-3月'
		4='3-6月'
		5='6月以上'
		other='其他';

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
		1='无逾期'
		2='逾期0-1月'
		3='逾期1-2月'
		4='逾期2-3月'
		5='逾期3-6月'
		6='逾期6-12月'
		7='逾期12-24月'
		8='逾期24-36月'
		9='逾期36月以上'
		other='其他';

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
		1='无逾期'
		2='大于24个月'
		3='12-24个月'
		4='6-12个月'
		5='3-6个月'
		6='小于3个月'
		other='其他';

	%let _FN_pdspeedLevel=7;

	* irr分组;
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
		11='33%以上'
		other='其他';

	%let _FN_irrLevel=12;

	* gtp分组;
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
		other='其他';

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
		8='200%以上'
		other='其他';

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
		other='其他';

	%let _FN_ppLevel=5;
	
		* 特殊交易类型生成;
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

	* 特殊交易类型;
	value spectype
		1='展期'
		2='担保人代还'
		3='以资抵债'
		4='部分提前还款'
		5='全部提前还款'
		6='长期拖欠'
		7='法律诉讼'
		8='贷款欺诈'
		other='未知';

	%let _FN_spectype=9;
	
	* 特殊交易类型->是否为负面信息;
	
	invalue spectyeToNeg
		6-8=1
		1-5=2
		other=.
	;

	%let _FN_spectyeToNeg=3;

	* 是否为负面特殊交易类型（担保类型简化）;
	value sptn
		1='负面信息'
		2='非负面信息'
		other='未知';

	%let _FN_sptn=3;
	
	value termsfreqToInt
		1='dtday'
		2='dtweek'
		3='dtmonth'
		4='dtqtr'
		5='dtsemiyear'
		6='dtyear'
		other='';
	;
quit;

* format状态个数映射表生成;
%*genGlobalFormatNMaps;
