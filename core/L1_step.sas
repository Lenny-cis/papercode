* 身份信息;
%macro base_certification(inds=,outds=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local t_ds;%let t_ds=%createTemp(D);%local &t_ds.;

	%if not %dsExist(&inds.) %then %error(INDS does not exist!&sysparm.);
	%if %isBlank(&outds.) %then %let outds=&inds.;

	%local certIdStmt certInfostmt orgcodeStmt getdateStmt istateStmt dropStmt;

	%genChkCertId(out=certid,scerttype=scerttype,scertno=scertno,res=&tres.);%let certidStmt=&&&tres.;
	%genFromCertId(var=certid,outgender=gender,outage=age,outarea=area,res=&tres.);%let certInfostmt=&&&tres.;
	%genChkOrgcode(out=orgcode,sorgcode=sorgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%genChkGetdate(out=getdate,dgetdate=dgetdate,res=&tres.);%let getdateStmt=&&&tres.;
	%chkIstate(istate=istate,res=&tres.);%let istateStmt=&&&tres.;
	%let dropStmt=%str(%quote(
		drop spin smsgfilename ilineno iauthflag ipbcstate scerttype scertno sorgcode dgetdate istate stoporgcode;
	));

	data &t_ds.;
		set &inds.;
		%unquote(&certidStmt.);
		%unquote(&certInfostmt.);
		%unquote(&orgcodeStmt.);
		%unquote(&getdateStmt.);
		%unquote(&istateStmt.);
		%unquote(&dropStmt.);
		rename iid=ipersonid;
		label iid=' ';
	run;
	proc sort data=&t_ds. out=&outds. nodupkey;
		by certid;
	run;
	%dropds(&t_ds.);

%mend base_certification;
* 机构;
%macro base_org(inds=,outds=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local t_ds;%let t_ds=%createTemp(D);%local &t_ds.;

	%if not %dsExist(&inds.) %then %error(INDS does not exist!&sysparm.);
	%if %isBlank(&outds.) %then %let outds=&inds.;

	%local certIdStmt getdateStmt dropStmt;
	%genChkOrgcode(sorgcode=stoporgcode,out=toporgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%let dropStmt=%str(%quote(
		drop sremark szippassword ssecret isearchlimit inowsearch sreporttype spbcorgcode squeryauth ireqlimit inowreq stoporgcode;
	));

	data &outds.;
		set &inds.;
		%unquote(&orgcodeStmt.);
		%unquote(&dropStmt.);
	run;

%mend base_org;
* 个人信息;
%macro base_person(inds=,outds=,baseCertds=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tres2;%let tres2=%createTemp(V);%local &tres2.;

	%if (not %dsExist(&inds)) or (not %dsExist(&baseCertds.)) %then %error(INDS or BASEDS doesnot exist! &syspbuff);
	%if %isBlank(&outds.) %then %let outds=&inds;

	%local hashcert;
	%local hashcertstmt orgcodeStmt getdateStmt istateStmt dropStmt;
	%genhashfilter(ds=&baseCertds.,keyVars=ipersonid,dataVars=&KEY_PERSON.,outhash=&tres2.,res=&tres.);%let hashcertStmt=&&&tres.;%let hashcert=&&&tres2.;
	%genChkOrgcode(sorgcode=sorgcode,out=orgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%genChkGetdate(dgetdate=dgetdate,out=getdate,res=&tres.);%let getdateStmt=&&&tres.;
	%chkIstate(istate=istate,res=&tres.);%let istateStmt=&&&tres.;

	%local stmts stmtsN stmt i j;
	%if %upcase(%scan(&inds.,-1,%str(.))) eq SINO_PERSON %then %do;
		%let stmts=marriagestmt eduLevelstmt eduDegreestmt firstContactRelationstmt secondContactRelationstmt
			firstcontactnamestmt secondcontactnamestmt
			mobiletelstmt firstcontacttelstmt secondcontacttelstmt
			mailZipstmt
		;
		%varsCount(vars=&stmts.,res=&tres.);%let stmtsN=&&&tres.;
		%do i=1 %to &stmtsN.;
			%varsN(vars=&stmts.,n=&i.,res=&tres.);%let stmt=&&&tres.;
			%local &stmt.;
		%end;
		%genWithFormatEnum(out=marriage,enum=imarriage,informat=imarriage,format=marriage,res=&tres.);%let marriagestmt=&&&tres.;
		%genWithFormatEnum(out=eduLevel,enum=ieduLevel,informat=ieduLevel,format=eduLevel,res=&tres.);%let eduLevelstmt=&&&tres.;
		%genWithFormatEnum(out=eduDegree,enum=ieduDegree,informat=ieduDegree,format=eduDegree,res=&tres.);%let eduDegreestmt=&&&tres.;
		%genWithFormatEnum(out=firstContactRelation,enum=sfirstContactRelation,informat=scontactRelation,format=contactrelation,res=&tres.);%let firstContactRelationstmt=&&&tres.;
		%genWithFormatEnum(out=secondContactRelation,enum=ssecondContactRelation,informat=scontactRelation,format=contactrelation,res=&tres.);%let secondContactRelationstmt=&&&tres.;
		%genName(out=firstcontactname,name=sfirstcontactname,res=&tres.);%let firstcontactnamestmt=&&&tres.;
		%genName(out=secondcontactname,name=ssecondcontactname,res=&tres.);%let secondcontactnamestmt=&&&tres.;
		%genMphone(out=mobiletel,mphone=smobiletel,res=&tres.);%let mobiletelstmt=&&&tres.;
		%genMphone(out=firstcontacttel,mphone=sfirstcontacttel,res=&tres.);%let firstcontacttelstmt=&&&tres.;
		%genMphone(out=secondcontacttel,mphone=ssecondcontacttel,res=&tres.);%let secondcontacttelstmt=&&&tres.;
		%genZip(out=mailZip,var=szip,res=&tres.);%let mailZipstmt=&&&tres.;
	%end;
	%else %if %upcase(%scan(&inds.,-1,%str(.))) eq SINO_PERSON_EMPLOYMENT %then %do;
		%let stmts=occupationstmt industrystmt positionstmt titlestmt
			companyZipstmt annualIncomestmt jobstartyearstmt companystmt
		;
		%varsCount(vars=&stmts.,res=&tres.);%let stmtsN=&&&tres.;
		%do i=1 %to &stmtsN.;
			%varsN(vars=&stmts.,n=&i.,res=&tres.);%let stmt=&&&tres.;
			%local &stmt.;
		%end;
		%genWithFormatEnum(out=occupation,enum=soccupation,informat=soccupation,format=occupation,res=&tres.);%let occupationstmt=&&&tres.;
		%genWithFormatEnum(out=industry,enum=sindustry,informat=sindustry,format=industry,res=&tres.);%let industrystmt=&&&tres.;
		%genWithFormatEnum(out=position,enum=iposition,informat=iposition,format=position,res=&tres.);%let positionstmt=&&&tres.;
		%genWithFormatEnum(out=title,enum=ititle,informat=ititle,format=title,res=&tres.);%let titlestmt=&&&tres.;
		%genZip(out=companyZip,var=scompanyzip,res=&tres.);%let companyZipstmt=&&&tres.;
		%genMoney(out=annualIncome,var=iannualIncome,iszero=1,res=&tres.);%let annualIncomestmt=&&&tres.;
		%genStartyear(out=jobstartyear,var=sstartyear,cert=certid,res=&tres.);%let jobstartyearstmt=&&&tres.;
		%genName(out=company,name=scompany,res=&tres.);%let companystmt=&&&tres.;
	%end;
	%else %if %upcase(%scan(&inds.,-1,%str(.))) eq SINO_PERSON_ADDRESS %then %do;
		%let stmts=conditionstmt homeZipstmt;
		%varsCount(vars=&stmts.,res=&tres.);%let stmtsN=&&&tres.;
		%do i=1 %to &stmtsN.;
			%varsN(vars=&stmts.,n=&i.,res=&tres.);%let stmt=&&&tres.;
			%local &stmt.;
		%end;
		%genWithFormatEnum(out=condition,enum=scondition,informat=scondition,format=condition,res=&tres.);%let conditionstmt=&&&tres.;
		%genZip(out=homeZip,var=szip,res=&tres.);%let homeZipstmt=&&&tres.;
	%end;
	%else %error(DS ERROR!);
	%let dropStmt=%str(%quote(
		drop smsgfilename ilineno itrust stoporgcode istate ipbcstate sorgcode dgetdate istate stoporgcode;
	));

	data &outds;
		%unquote(&hashcertstmt.);
		set &inds;
		if not &hashcert..find(key:ipersonid);
		%unquote(&orgcodeStmt.);
		%unquote(&getdateStmt.);
		%unquote(&istateStmt.);
		%unquote(&dropStmt.);
		%do j=1 %to &stmtsN.;
			%varsN(vars=&stmts.,n=&j.,res=&tres.);%let stmt=&&&tres.;
			%unquote(&&&stmt.);
		%end;
	run;

%mend base_person;
* 申请信息;
%macro base_loanApply(inds=,outds=,basecertds=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tres2;%let tres2=%createTemp(V);%local &tres2.;
	%local t_ds;%let t_ds=%createTemp(D);%local &t_ds.;

	%if not (%dsExist(&inds.) and %dsExist(&basecertds.)) %then %error(INDS does not exist!&sysparm.);
	%if %isBlank(&outds.) %then %let outds=&inds.;

	%local hashcert;
	%local hashcertstmt certIdStmt orgcodeStmt getdateStmt busidateStmt istateStmt dropStmt;
	%local loantypestmt applystatestmt certnamestmt applyamountstmt applymonthdurationstmt;
	%genhashfilter(ds=&baseCertds.,keyVars=&KEY_PERSON.,outhash=&tres2.,res=&tres.);%let hashcertStmt=&&&tres.;%let hashcert=&&&tres2.;
	%genChkCertId(out=certid,scerttype=scerttype,scertno=scertno,res=&tres.);%let certidStmt=&&&tres.;
	%genChkOrgcode(sorgcode=sorgcode,out=orgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%genChkGetdate(dgetdate=dgetdate,out=getdate,res=&tres.);%let getdateStmt=&&&tres.;
	%genChkBusiDate(outdate=applydate,outmonth=applymonth,date=ddate,res=&tres.);%let busidateStmt=&&&tres.;
	%chkIstate(istate=istate,res=&tres.);%let istateStmt=&&&tres.;

	%genWithFormatEnum(out=loantype,enum=stype,informat=sloantype,format=loantype,res=&tres.);%let loantypestmt=&&&tres.;
	%genWithFormatEnum(out=applystate,enum=sstate,informat=sapplystate,format=applystate,res=&tres.);%let applystatestmt=&&&tres.;
	%genName(out=certname,name=sname,res=&tres.);%let certnamestmt=&&&tres.;
	%genMoney(out=applyamount,var=imoney,iszero=0,res=&tres.);%let applyamountstmt=&&&tres.;
	%genApplymonth(out=applymonthduration,var=imonthcount,res=&tres.);%let applymonthdurationstmt=&&&tres.;
	%let dropStmt=%str(%quote(
		drop smsgfilename ilineno stoporgcode istate ipbcstate scerttype scertno sorgcode dgetdate ddate istate;
	));

	data &outds.;
		%unquote(&hashcertstmt.);
		set &inds.;
		%unquote(&certidStmt.);
		%unquote(&orgcodeStmt.);
		%unquote(&getdateStmt.);
		%unquote(&busidateStmt.);
		%unquote(&istateStmt.);
		%unquote(&loantypestmt.);
		%unquote(&applystatestmt.);
		%unquote(&certnamestmt.);
		%unquote(&applyamountstmt.);
		%unquote(&applymonthdurationstmt.);
		%unquote(&dropStmt.);
		if not &hashcert..find(key:&KEY_PERSON.);
	run;
%mend base_loanapply;
* 业务信息;
%macro base_loan(inds=,outds=,basecertds=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tres2;%let tres2=%createTemp(V);%local &tres2.;
	%local t_ds;%let t_ds=%createTemp(D);%local &t_ds.;

	%if not (%dsExist(&inds.) and %dsExist(&basecertds.)) %then %error(INDS does not exist!&sysparm.);
	%if %isBlank(&outds.) %then %let outds=&inds.;

	%local stmts stmtsN stmt i;
	%local hashcert hashcertstmt;
	%let stmts=
		certIdStmt orgcodeStmt getdateStmt opendateStmt closedateStmt busidateStmt istateStmt
		loantypestmt guaranteewaystmt termsfreqstmt accountstatstmt class5statstmt certnamestmt
		monthdurationstmt monthunpaidstmt treatypayduestmt curtermspastduestmt termspastduestmt maxtermspastduestmt
		treatypayamountstmt creditlimitstmt scheduledamountstmt actualpayamountstmt balancestmt
		amountpastduestmt amountpastdue30stmt amountpastdue60stmt amountpastdue90stmt amountpastdue180stmt
		paystat24monthstmt pay1Mstmt finstataccstmt finstatpaystatstmt datafinishstmt totalmonthstmt currmonthstmt totaltermstmt currtermstmt
		APDXMPDstmt paystateMPDstmt curtermPDMPDstmt
		openclosestmt openbillingstmt ballimitstmt amp30limitstmt amp60limitstmt amp90limitstmt amp180limitstmt limitmissstmt
		totaltermcurrtermstmt totaltermcurrtermPDstmt totaltermtermPDstmt totaltermmaxtermPDstmt
		finstatchkeqstmt monthpastduestmt
		dropStmt
	;
	%varsCount(vars=&stmts.,res=&tres.);%let stmtsN=&&&tres.;
	%local &stmts.;
	%genhashfilter(ds=&baseCertds.,keyVars=&KEY_PERSON.,outhash=&tres2.,res=&tres.);%let hashcertStmt=&&&tres.;%let hashcert=&&&tres2.;
	%genChkCertId(out=certid,scerttype=scerttype,scertno=scertno,res=&tres.);%let certidStmt=&&&tres.;
	%genChkOrgcode(sorgcode=sorgcode,out=orgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%genChkGetdate(dgetdate=dgetdate,out=getdate,res=&tres.);%let getdateStmt=&&&tres.;
	%genChkBusiDate(outdate=dateopened,outmonth=openmonth,date=ddateopened,res=&tres.);%let opendateStmt=&&&tres.;
	%genChkBusiDate(outdate=dateclosed,outmonth=closemonth,date=ddateclosed,res=&tres.);%let closedateStmt=&&&tres.;
	%genChkBusiDate(outdate=billingdate,outmonth=billingmonth,date=dbillingdate,res=&tres.);%let busidateStmt=&&&tres.;
	%chkIstate(istate=istate,res=&tres.);%let istateStmt=&&&tres.;

	%genWithFormatEnum(out=loantype,enum=sloantype,informat=sloantype,format=loantype,res=&tres.);%let loantypestmt=&&&tres.;
	%genWithFormatEnum(out=guaranteeway,enum=iguaranteeway,informat=iguaranteeway,format=guaranteeway,res=&tres.);%let guaranteewaystmt=&&&tres.;
	%genWithFormatEnum(out=termsfreq,enum=stermsfreq,informat=stermsfreq,format=termsfreq,res=&tres.);%let termsfreqstmt=&&&tres.;
	%genWithFormatEnum(out=accountstat,enum=iaccountstat,informat=iaccountstat,format=accountstat,res=&tres.);%let accountstatstmt=&&&tres.;
	%genWithFormatEnum(out=class5stat,enum=iclass5stat,informat=iclass5stat,format=class5stat,res=&tres.);%let class5statstmt=&&&tres.;
	%genName(out=certname,name=sname,res=&tres.);%let certnamestmt=&&&tres.;
	%genWithStrint(out=monthduration,var=smonthduration,iszero=0,res=&tres.);%let monthdurationstmt=&&&tres.;
	%genWithStrint(out=monthunpaid,var=smonthunpaid,iszero=1,res=&tres.);%let monthunpaidstmt=&&&tres.;
	%genWithStrint(out=treatypaydue,var=streatypaydue,iszero=0,res=&tres.);%let treatypayduestmt=&&&tres.;
	%genInt(out=curtermspastdue,var=icurtermspastdue,iszero=1,res=&tres.);%let curtermspastduestmt=&&&tres.;
	%genInt(out=termspastdue,var=itermspastdue,iszero=1,res=&tres.);%let termspastduestmt=&&&tres.;
	%genInt(out=maxtermspastdue,var=imaxtermspastdue,iszero=1,res=&tres.);%let maxtermspastduestmt=&&&tres.;
	%genWithStrint(out=treatypayamount,var=itreatypayamount,iszero=1,res=&tres.);%let treatypayamountstmt=&&&tres.;
	%genMoney(out=creditlimit,var=icreditlimit,iszero=0,res=&tres.);%let creditlimitstmt=&&&tres.;
	%genMoney(out=scheduledamount,var=ischeduledamount,iszero=0,res=&tres.);%let scheduledamountstmt=&&&tres.;
	%genMoney(out=actualpayamount,var=iactualpayamount,iszero=0,res=&tres.);%let actualpayamountstmt=&&&tres.;
	%genMoney(out=balance,var=ibalance,iszero=0,res=&tres.);%let balancestmt=&&&tres.;
	%genMoney(out=amountpastdue,var=iamountpastdue,iszero=0,res=&tres.);%let amountpastduestmt=&&&tres.;
	%genMoney(out=amountpastdue30,var=iamountpastdue30,iszero=0,res=&tres.);%let amountpastdue30stmt=&&&tres.;
	%genMoney(out=amountpastdue60,var=iamountpastdue60,iszero=0,res=&tres.);%let amountpastdue60stmt=&&&tres.;
	%genMoney(out=amountpastdue90,var=iamountpastdue90,iszero=0,res=&tres.);%let amountpastdue90stmt=&&&tres.;
	%genMoney(out=amountpastdue180,var=iamountpastdue180,iszero=0,res=&tres.);%let amountpastdue180stmt=&&&tres.;

	%genPaystat24month(out=paystat24month,var=spaystat24month,res=&tres.);%let paystat24monthstmt=&&&tres.;
	%genPaystate(out=paystat1month,var=paystat24month,res=&tres.);%let pay1Mstmt=&&&tres.;
	%genFinishstateAccountstat(out=FinishstateAccountstat,var=accountstat,dateopened=dateopened,dateclosed=dateclosed,billingdate=billingdate,res=&tres.);%let finstataccstmt=&&&tres.;
	%genFinishstatePaystate(out=FinishstatePaystate,var=paystat1month,dateopened=dateopened,dateclosed=dateclosed,billingdate=billingdate,res=&tres.);%let finstatpaystatstmt=&&&tres.;
	%genFinishdate(out=datefinish,finstate=FinishstateAccountstat,billingdate=billingdate,res=&tres.);%let datafinishstmt=&&&tres.;
	%genTermDuration(out=totalmonth,varStart=dateopened,varEnd=dateclosed,res=&tres.);%let totalmonthstmt=&&&tres.;
	%genTermDuration(out=currmonth,varStart=dateopened,varEnd=billingdate,res=&tres.);%let currmonthstmt=&&&tres.;
	%genTermDuration(out=totalterm,varStart=dateopened,varEnd=dateclosed,termsfreq=termsfreq,res=&tres.);%let totaltermstmt=&&&tres.;
	%genTermDuration(out=currterm,varStart=dateopened,varEnd=billingdate,termsfreq=termsfreq,res=&tres.);%let currtermstmt=&&&tres.;

	%genWithAPDXMPD(out=APDXMPD,apd=amountpastdue,apd30=amountpastdue30,apd60=amountpastdue60,apd90=amountpastdue90,apd180=amountpastdue180,res=&tres.);%let APDXMPDstmt=&&&tres.;
	%genWithPaystateMPD(out=paystateMPD,var=paystat1month,res=&tres.);%let paystateMPDstmt=&&&tres.;
	%genWithcurtermPDMPD(out=curtermPDMPD,termsfreq=termsfreq,curtermsPD=curtermspastdue,dateclosed=dateclosed,billingdate=billingdate,res=&tres.);%let curtermPDMPDstmt=&&&tres.;
	%genMax(vars=APDXMPD paystateMPD curtermPDMPD,out=monthpastdue,res=&tres.);%let monthpastduestmt=&&&tres.;

	%chkGt(large=dateclosed,small=dateopened,iseq=0,res=&tres.,method=delete);%let openclosestmt=&&&tres.;
	%chkGt(large=billingdate,small=dateopened,iseq=1,res=&tres.,method=delete);%let openbillingstmt=&&&tres.;
	%chkGt(large=creditlimit,small=balance,iseq=1,res=&tres.,method=misssmall);%let ballimitstmt=&&&tres.;
	%chkGt(large=creditlimit,small=amountpastdue30,iseq=1,res=&tres.,method=misssmall);%let amp30limitstmt=&&&tres.;
	%chkGt(large=creditlimit,small=amountpastdue60,iseq=1,res=&tres.,method=misssmall);%let amp60limitstmt=&&&tres.;
	%chkGt(large=creditlimit,small=amountpastdue90,iseq=1,res=&tres.,method=misssmall);%let amp90limitstmt=&&&tres.;
	%chkGt(large=creditlimit,small=amountpastdue180,iseq=1,res=&tres.,method=misssmall);%let amp180limitstmt=&&&tres.;
	%chkMissing(var=creditlimit,res=&tres.);%let limitmissstmt=&&&tres.;
	%chkGt(large=totalterm,small=currterm,iseq=1,res=&tres.,method=misssmall);%let totaltermcurrtermstmt=&&&tres.;
	%chkGt(large=totalterm,small=curtermspastdue,iseq=1,res=&tres.,method=misssmall);%let totaltermcurrtermPDstmt=&&&tres.;
	%chkGt(large=totalterm,small=termspastdue,iseq=1,res=&tres.,method=misssmall);%let totaltermtermPDstmt=&&&tres.;
	%chkGt(large=totalterm,small=maxtermspastdue,iseq=1,res=&tres.,method=misssmall);%let totaltermmaxtermPDstmt=&&&tres.;
	%chkeq(vara=FinishstateAccountstat,varb=FinishstatePaystate,res=&tres.,method=delete);%let finstatchkeqstmt=&&&tres.;
	%let dropStmt=%str(%quote(
		drop smsgfilename ilineno stoporgcode istate ipbcstate scerttype scertno sorgcode dgetdate dbillingdate istate;
	));

	data &outds.;
		%unquote(&hashcertStmt);
		set &inds.;
		%do i=1 %to &stmtsN.;
			%varsN(vars=&stmts.,n=&i.,res=&tres.);%let stmt=&&&tres.;
			%unquote(&&&stmt.);
		%end;
		if not &hashcert..find(key:&KEY_PERSON.);
	run;
%mend base_loan;
* 信用报告;
%macro base_creditRecord(inds=,outds=,baseOrgds=,baseCertds=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tres2;%let tres2=%createTemp(V);%local &tres2.;
	%local t_ds;%let t_ds=%createTemp(D);%local &t_ds.;

	%if not (%dsExist(&inds.) and %dsExist(&baseOrgds.) and %dsExist(&baseCertds.)) %then %error(DS does not exist!&sysparm.);
	%if %isBlank(&outds.) %then %let outds=&inds.;

	%local hashorg hashcert;
	%local hashorgStmt hashcertStmt certIdStmt getdateStmt dropStmt;
	%local reasonstmt resultstmt channelstmt certnamestmt;
	%genhashfilter(ds=&baseOrgds.,keyVars=sorgcode,dataVars=toporgcode,outhash=&tres2.,res=&tres.);%let hashorgStmt=&&&tres.;%let hashorg=&&&tres2.;
	%genhashfilter(ds=&baseCertds.,keyVars=&KEY_PERSON.,outhash=&tres2.,res=&tres.);%let hashcertStmt=&&&tres.;%let hashcert=&&&tres2.;
	%genChkCertId(out=certid,scerttype=scerttype,scertno=scertno,res=&tres.);%let certidStmt=&&&tres.;
	%genChkGetdate(dgetdate=drequesttime,out=requesttime,res=&tres.);%let getdateStmt=&&&tres.;

	%genWithFormatEnum(out=reason,enum=sreason,informat=sreason,format=reason,res=&tres.);%let reasonstmt=&&&tres.;
	%genWithFormatEnum(out=result,enum=irequesttype,informat=irequesttypeToResult,format=result,res=&tres.);%let resultstmt=&&&tres.;
	%genWithFormatEnum(out=channel,enum=irequesttype,informat=irequesttypeToChannel,format=channel,res=&tres.);%let channelstmt=&&&tres.;
	%genName(out=certname,name=sname,res=&tres.);%let certnamestmt=&&&tres.;
	%let dropStmt=%str(%quote(
		drop sorgcode sorgname sdepname iuserid susername dcreatetime splatename sserialnumber sfilepath scerttypename scerttype scertno drequesttime;
	));

	data &outds.;
		%unquote(&hashorgStmt);
		%unquote(&hashcertStmt);
		set &inds.;
		%unquote(&certidStmt.);
		if not &hashorg..find(key:sorgcode);
		if not &hashcert..find(key:&KEY_PERSON.);
		%unquote(&getdateStmt.);
		%unquote(&reasonstmt.);
		%unquote(&resultstmt.);
		%unquote(&channelstmt.);
		%unquote(&certnamestmt.);
		%unquote(&dropStmt.);
		rename toporgcode=orgcode;
	run;

%mend base_creditRecord;
* 去除重复数据;
%macro removeDupData(inds=,outds=,keyVars=,sortVars=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local t_ds;%let t_ds=%createTemp(D);

	%if %isBlank(&keyVars.) or %isBlank(&sortVars.) %then %error(PARAM is missing!&syspbuff.);
	%if %isBlank(&outds.) %then %let outds=&inds.;
	%if not %dsExist(&inds.) %then %error(DS does not exist!);
	
	%local vars lastKeyVar;
	%local dsvars;

	%let vars=&keyVars. &sortVars.;
	%getDsVarsList(ds=&inds.,res=&tres.);%let dsvars=&&&tres.;
	%RelativeComplement(sources=&vars.,targets=&dsvars.,res=&tres.);
	%if not %isBlank(&&&tres.) %then %error(&&&tres. does not in &inds.);

	%let lastKeyVar=%scan(&keyVars.,-1,%str( ));
	proc sort data=&inds. out=&t_ds.;
		by &keyVars. &sortVars.;
	run;
	data &outds.;
		set &t_ds.;
		by &keyVars. &sortVars.;
		if last.&lastKeyVar.;
	run;
	%dropds(&t_ds.);
%mend;
* 业务静态信息;
%macro loanStatic(inds=,outds=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tres2;%let tres2=%createTemp(V);%local &tres2.;
	%local t_ds;%let t_ds=%createTemp(D);
	%local t_ds2;%let t_ds2=%createTemp(D);
	%local t_ds3;%let t_ds3=%createTemp(D);

	%if %isBlank(&outds.) %then %let outds=&inds.;
	%if not %dsExist(&inds.) %then %error(DS does not exist!);

	%local staticVars sqlVarsStmt calStmt;
	%local dsvars;
	%local staticVarsN staticVar i;
	%local calVar;

	%let staticVars=&VARS_LOAN_STATIC.;
	%getDsVarsList(ds=&inds.,res=&tres.);%let dsvars=&&&tres.;
	%RelativeComplement(sources=&staticVars.,targets=&dsvars.,res=&tres.);
	%if not %isBlank(&&&tres.) %then %error(&&&tres. does not in &inds.);
	%let calVar=%createTemp(V);

	%varsCount(vars=&staticVars.,res=&tres.);%let staticVarsN=&&&tres.;
	%do i=1 %to &staticVarsN.;
		%local t_var;%let t_var=%createTemp(V);
		%varsN(vars=&staticVars.,n=&i.,res=&tres.);%let staticVar=&&&tres.;
		%if &i. eq 1 %then %do;
			%let sqlVarsStmt=count(distinct &staticVar.)-1 as &t_var.;
			%let calStmt=calculated &t_var.;
		%end;
		%else %do;
			%let sqlVarsStmt=&sqlVarsStmt.%str(,)count(distinct &staticVar.)-1 as &t_var.;
			%let calStmt=&calStmt.%str(,)calculated &t_var.;
		%end;
	%end;
	proc sql noprint;
		create table &t_ds.(keep=iloanid) as
		select iloanid,%unquote(&sqlVarsStmt.),sign(sum(%unquote(&calStmt.))) as &calVar. 
		from &inds. 
		group by iloanid
		having &calVar. gt 0;
	quit;
	%local hashloan hashstmt;
	%genhashfilter(ds=&t_ds.,keyVars=iloanid,outhash=&tres2.,res=&tres.);
	%let hashloan=&&&tres2.;%let hashstmt=&&&tres.;
	proc sort data=&inds. out=&t_ds2.;
		by iloanid dgetdate;
	run;
	data &t_ds3.;
	%unquote(&hashstmt.);
		set &t_ds2.;
		by iloanid dgetdate;
		if last.iloanid;
		if not &hashloan..find(key:iloanid);
		keep iloanid &staticVars.;
	run;
	%local hashstatic hashstaticstmt;
	%genhashfilter(ds=&t_ds3.,keyVars=iloanid,dataVars=&staticVars.,outhash=&tres2.,res=&tres.);
	%let hashstatic=&&&tres2.;%let hashstaticstmt=&&&tres.;
	data &outds.(drop=rc);
		%unquote(&hashstaticstmt.);
		set &t_ds2.;
		rc=&hashstatic..find(key:iloanid);
	run;
	%dropds(&t_ds.);
	%dropds(&t_ds2.);
	%dropds(&t_ds3.);
%mend;
