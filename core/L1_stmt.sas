* 生成证件号码;
%macro genCertId(flag=,out=,scerttype=,scertno=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&scerttype.) or %isBlank(&scertno.) or %isBlank(&flag.) or %isBlank(&out.)
		%then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%local area ymd chk l;

	%let area=%createTemp(V);
	%let ymd=%createTemp(V);
	%let chk=%createTemp(V);
	%let l=%createTemp(V);

	%let tstmt=%str(%quote(

		&flag.=(not missing(&scerttype.));
		&flag.=(&flag. and (not missing(&scertno.)));
		if &flag. then do;
			&flag.=(&scerttype. eq '0');
			if &flag. then do;
				&flag.=((length(&scertno.) eq &LENGTH_CERTID.) and prxmatch(&REG_CERTNO.,&scertno.));
				if &flag. then do;
					&area.=substr(&scertno.,1,2);
					&ymd.=substr(&scertno.,7,8);
					&flag.=prxmatch(&REG_AREA.,&area.);
					&flag.=(&flag. and prxmatch(&REG_YYYYMMDD.,&ymd.));
					if &flag. then do;
						&l.=substr(&scertno.,18,1);
						if upcase(&l.) eq 'X' then &l.=10;
						&chk.=mod(substr(&scertno.,1,1)*7
						+substr(&scertno.,2,1)*9
						+substr(&scertno.,3,1)*10
						+substr(&scertno.,4,1)*5
						+substr(&scertno.,5,1)*8
						+substr(&scertno.,6,1)*4
						+substr(&scertno.,7,1)*2
						+substr(&scertno.,8,1)*1
						+substr(&scertno.,9,1)*6
						+substr(&scertno.,10,1)*3
						+substr(&scertno.,11,1)*7
						+substr(&scertno.,12,1)*9
						+substr(&scertno.,13,1)*10
						+substr(&scertno.,14,1)*5
						+substr(&scertno.,15,1)*8
						+substr(&scertno.,16,1)*4
						+substr(&scertno.,17,1)*2
						+&l.,11);
						&flag.=((&chk. eq 1) and &flag.);
					end;
				end;
			end;
		end;
		if &flag. then &out.=&scertno.;
		else &out.='';
		drop &area. &ymd. &chk. &l.;
	));
	%let &res.=&tstmt.;
%mend genCertId;

* 生成机构号;
%macro genOrgcode(flag=,out=,sorgcode=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&sorgcode.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%local length;
	%let length=%createTemp(V);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&sorgcode.));
		if &flag. then do;
			&length.=length(compress(&sorgcode.));
			&flag.=(&length. eq &LENGTH_ORGCODE.);
			if &flag. then do;
				&flag.=(prxmatch(&REG_ORGCODE.,&sorgcode.));
			end;
		end;
		if &flag. then &out.=&sorgcode.;
		else &out.='';
		drop &length.;
	));
	%let &res.=&tstmt.;
%mend;
* 生成数据获取时间;
%macro genGetdate(flag=,out=,dgetdate=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&dgetdate.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&dgetdate.));
		if &flag. then do;
			&flag.=(&NFCS_START_DATE. le &dgetdate. lt &NFCS_END_DATE.);
		end;
		if &flag. then &out.=&dgetdate.;
		else &out=.;
	));
	%let &res.=&tstmt.;
%mend genGetdate;
* 检查istate;
%macro chkIstate(flag=,istate=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&istate.) or %isBlank(&flag.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&istate.));
		if &flag. then do;
			&flag.=(&istate. eq 0);
		end;
	));
	%let &res.=&tstmt.;
%mend chkIstate;
* 生成业务时间;
%macro genBusiDate(flag=,outdate=,outmonth=,date=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&flag.) or %isBlank(&outdate.) or %isBlank(&outmonth.) or %isBlank(&date.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);

	%local tstmt;

	%let tstmt=%str(%quote(
		&flag.=(not missing(&date.));
		if &flag. then do;
			&flag.=(&BIZ_START_DATE. le &date. lt &BIZ_END_DATE.);
		end;
		if &flag. then do;
			&outdate.=&date.;
			&outmonth.=intnx('dtmonth',&date.,0,'b');
		end;
		else do;
			&outdate.=.;
			&outmonth.=.;
		end;
	));
	%let &res.=&tstmt.;
%mend genBusiDate;
* hash过滤语句;
%macro genhashfilter(ds=,keyVars=,dataVars=,outhash=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if (%isBlank(&keyVars.) and %isBlank(&dataVars.)) %then %error(Required param is empty! &syspbuff);
	%if not %dsExist(&ds.) %then %error(DS does not exist!&syspbuff);
	%if not (%refExist(&res.) and %refExist(&outhash.)) %then %error(RES or OUTHASH is illegal!);

	%local dsVars baseVars baseKeyVars baseDataVars;
	%let baseVars=&keyVars. &dataVars.;
	%getDsVarsList(ds=&ds.,res=&tres.);%let dsVars=&&&tres.;
	%RelativeComplement(sources=&baseVars.,targets=&dsVars.,res=&tres.);
	%if not %isBlank(&&&tres.) %then %error(&&&tres. does not in &ds.);
	%let baseKeyVars=%sasVarsToQuote(&keyVars.);
	%let baseDataVars=%sasVarsToQuote(&dataVars.);

	%local tstmt keyStmt dataStmt;
	%let &outhash.=%createTemp(V);
	%if not %isBlank(&keyVars.) %then %let keyStmt=&&&outhash...definekey(&baseKeyVars.);
	%if not %isBlank(&dataVars.) %then %let dataStmt=&&&outhash...definedata(&baseDataVars.);
	%let tstmt=%str(%quote(
		if _n_ eq 1 then do;
			if 0 then set &ds.(keep=&baseVars.);
			declare hash &&&outhash.(dataset:"&ds.(keep=&baseVars.)");
			%unquote(&keyStmt.);
			%unquote(&dataStmt.);
			&&&outhash...definedone();
		end;
	));
	%let &res.=&tstmt.;
%mend genhashfilter;
