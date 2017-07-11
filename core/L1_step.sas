libname L0 "&Ltest_PATH.";
libname L1 "&L1_PATH.";
* 身份信息;
%macro base_certification(inds=,outds=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local t_ds;%let t_ds=%createTemp(D);%local &t_ds.;

	%if not %dsExist(&inds.) %then %error(INDS does not exist!&sysparm.);
	%if %isBlank(&outds.) %then %let outds=&inds.;

	%local certIdStmt orgcodeStmt getdateStmt istateStmt dropStmt;

	%genCertId(flag=_F_certid,out=certid,scerttype=scerttype,scertno=scertno,res=&tres.);%let certidStmt=&&&tres.;
	%genOrgcode(flag=_F_orgcode,out=orgcode,sorgcode=sorgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%genGetdate(flag=_F_getdate,out=getdate,dgetdate=dgetdate,res=&tres.);%let getdateStmt=&&&tres.;
	%chkIstate(flag=_F_istate,istate=istate,res=&tres.);%let istateStmt=&&&tres.;
	%let dropStmt=%str(%quote(
		drop spin smsgfilename ilineno iauthflag ipbcstate scerttype scertno sorgcode dgetdate istate stoporgcode;
	));

	data &t_ds.;
		set &inds.;
		length certId $&LENGTH_CERTID. orgcode $&LENGTH_ORGCODE.;
		format getdate &FORMAT_DATE.;
		%unquote(&certidStmt.);
		%unquote(&orgcodeStmt.);
		%unquote(&getdateStmt.);
		%unquote(&istateStmt.);
		%unquote(&dropStmt.);
		rename iid=ipersonid;
		label iid=' ';
	run;
	%flagfilter(inds=&t_ds.,outds=&t_ds.);
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
	%genOrgcode(flag=_F_orgcode,sorgcode=stoporgcode,out=toporgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%let dropStmt=%str(%quote(
		drop sremark szippassword ssecret isearchlimit inowsearch sreporttype spbcorgcode squeryauth ireqlimit inowreq stoporgcode;
	));

	data &outds.;
		set &inds.;
		length orgcode $&LENGTH_ORGCODE.;
		%unquote(&orgcodeStmt.);
		%unquote(&dropStmt.);
	run;

	%flagfilter(inds=&outds.,outds=&outds.);
%mend base_org;
* 个人信息;
%macro base_person(inds=,outds=,baseCertds=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tres2;%let tres2=%createTemp(V);%local &tres2.;

	%if (not %dsExist(&inds)) or (not %dsExist(&baseCertds.)) %then %error(INDS or BASEDS doesnot exist! &syspbuff);
	%if %isBlank(&outds.) %then %let outds=&inds;

	%local hashcert;
	%local hashcertstmt orgcodeStmt getdateStmt istateStmt dropStmt;
	%genhashfilter(ds=&baseCertds.,keyVars=&KEY_PERSON.,dataVars=certid,outhash=&tres2.,res=&tres.);%let hashcertStmt=&&&tres.;%let hashcert=&&&tres2.;
	%genOrgcode(flag=_F_orgcode,sorgcode=sorgcode,out=orgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%genGetdate(flag=_F_getdate,dgetdate=dgetdate,out=getdate,res=&tres.);%let getdateStmt=&&&tres.;
	%chkIstate(flag=_F_istate,istate=istate,res=&tres.);%let istateStmt=&&&tres.;
	%let dropStmt=%str(%quote(
		drop smsgfilename ilineno itrust stoporgcode istate ipbcstate sorgcode dgetdate istate stoporgcode;
	));

	data &outds;
		%unquote(&hashcertstmt.);
		set &inds;
		length orgcode $ &LENGTH_ORGCODE;
		format 	getDate &FORMAT_DATE;
		%unquote(&orgcodeStmt.);
		%unquote(&getdateStmt.);
		%unquote(&istateStmt.);
		%unquote(&dropStmt.);
		if not &hashcert..find(key:&KEY_PERSON.);
	run;
	%flagfilter(inds=&outds.,outds=&outds.);
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
	%genhashfilter(ds=&baseCertds.,keyVars=&KEY_PERSON.,outhash=&tres2.,res=&tres.);%let hashcertStmt=&&&tres.;%let hashcert=&&&tres2.;
	%genCertId(flag=_F_certid,out=certid,scerttype=scerttype,scertno=scertno,res=&tres.);%let certidStmt=&&&tres.;
	%genOrgcode(flag=_F_orgcode,sorgcode=sorgcode,out=orgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%genGetdate(flag=_F_getdate,dgetdate=dgetdate,out=getdate,res=&tres.);%let getdateStmt=&&&tres.;
	%genBusiDate(flag=_F_busidate,outdate=applydate,outmonth=applymonth,date=ddate,res=&tres.);%let busidateStmt=&&&tres.;
	%chkIstate(flag=_F_istate,istate=istate,res=&tres.);%let istateStmt=&&&tres.;
	%let dropStmt=%str(%quote(
		drop smsgfilename ilineno stoporgcode istate ipbcstate scerttype scertno sorgcode dgetdate ddate istate;
	));

	data &outds.;
		%unquote(&hashcertstmt.);
		set &inds.;
		length certId $&LENGTH_CERTID. orgcode $&LENGTH_ORGCODE.;
		format getdate applydate applymonth &FORMAT_DATE.;
		%unquote(&certidStmt.);
		%unquote(&orgcodeStmt.);
		%unquote(&getdateStmt.);
		%unquote(&busidateStmt.);
		%unquote(&istateStmt.);
		%unquote(&dropStmt.);
		if not &hashcert..find(key:&KEY_PERSON.);
	run;
	%flagfilter(inds=&outds.,outds=&outds.);
%mend base_loanapply;
* 业务信息;
%macro base_loan(inds=,outds=,basecertds=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tres2;%let tres2=%createTemp(V);%local &tres2.;
	%local t_ds;%let t_ds=%createTemp(D);%local &t_ds.;

	%if not (%dsExist(&inds.) and %dsExist(&basecertds.)) %then %error(INDS does not exist!&sysparm.);
	%if %isBlank(&outds.) %then %let outds=&inds.;

	%local hashcert;
	%local hashcertstmt certIdStmt orgcodeStmt getdateStmt busidateStmt istateStmt dropStmt;
	%genhashfilter(ds=&baseCertds.,keyVars=&KEY_PERSON.,outhash=&tres2.,res=&tres.);%let hashcertStmt=&&&tres.;%let hashcert=&&&tres2.;
	%genCertId(flag=_F_certid,out=certid,scerttype=scerttype,scertno=scertno,res=&tres.);%let certidStmt=&&&tres.;
	%genOrgcode(flag=_F_orgcode,sorgcode=sorgcode,out=orgcode,res=&tres.);%let orgcodeStmt=&&&tres.;
	%genGetdate(flag=_F_getdate,dgetdate=dgetdate,out=getdate,res=&tres.);%let getdateStmt=&&&tres.;
	%genBusiDate(flag=_F_busidate,outdate=billingdate,outmonth=billingmonth,date=dbillingdate,res=&tres.);%let busidateStmt=&&&tres.;
	%chkIstate(flag=_F_istate,istate=istate,res=&tres.);%let istateStmt=&&&tres.;
	%let dropStmt=%str(%quote(
		drop smsgfilename ilineno stoporgcode istate ipbcstate scerttype scertno sorgcode dgetdate dbillingdate istate;
	));

	data &outds.;
		%unquote(&hashcertStmt);
		set &inds.;
		length certId $&LENGTH_CERTID. orgcode $&LENGTH_ORGCODE.;
		format getdate billingdate billingmonth &FORMAT_DATE.;
		%unquote(&certidStmt.);
		%unquote(&orgcodeStmt.);
		%unquote(&getdateStmt.);
		%unquote(&busidateStmt.);
		%unquote(&istateStmt.);
		%unquote(&dropStmt.);
		if not &hashcert..find(key:&KEY_PERSON.);
	run;
	%flagfilter(inds=&outds.,outds=&outds.);
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
	%genhashfilter(ds=&baseOrgds.,keyVars=sorgcode,dataVars=toporgcode,outhash=&tres2.,res=&tres.);%let hashorgStmt=&&&tres.;%let hashorg=&&&tres2.;
	%genhashfilter(ds=&baseCertds.,keyVars=certid,outhash=&tres2.,res=&tres.);%let hashcertStmt=&&&tres.;%let hashcert=&&&tres2.;
	%genCertId(flag=_F_certid,out=certid,scerttype=scerttype,scertno=scertno,res=&tres.);%let certidStmt=&&&tres.;
	%genGetdate(flag=_F_requesttime,dgetdate=drequesttime,out=requesttime,res=&tres.);%let getdateStmt=&&&tres.;
	%let dropStmt=%str(%quote(
		drop sorgname sdepname iuserid susername dcreatetime splatename sserialnumber sfilepath scerttypename scerttype scertno drequesttime;
	));

	data &outds.;
		%unquote(&hashorgStmt);
		%unquote(&hashcertStmt);
		set &inds.;
		length certId $&LENGTH_CERTID.;
		format requesttime &FORMAT_DATE.;
		%unquote(&certidStmt.);
		%unquote(&getdateStmt.);
		%unquote(&dropStmt.);
		if not &hashorg..find(key:sorgcode);
		if not &hashcert..find(key:certid);
	run;

	%flagfilter(inds=&outds.,outds=&outds.);
%mend base_creditRecord;
