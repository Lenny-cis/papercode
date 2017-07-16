* 生成证件号码;
%macro genChkCertId(out=,scerttype=,scertno=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&scerttype.) or %isBlank(&scertno.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%local flag area ymd chk l;

	%let flag=%createTemp(V);
	%let area=%createTemp(V);
	%let ymd=%createTemp(V);
	%let chk=%createTemp(V);
	%let l=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. $&LENGTH_CERTID.;
		&flag.=(not missing(&scerttype.));
		&flag.=(&flag. and (not missing(&scertno.)));
		if &flag. then do;
			&flag.=(&scerttype. eq '0');
			if &flag. then do;
				&flag.=((length(&scertno.) eq &LENGTH_CERTID.) and prxmatch(&REG_CERTNO.,compress(&scertno.)));
				if &flag. then do;
					&area.=substr(&scertno.,1,2);
					&ymd.=substr(&scertno.,7,8);
					&flag.=prxmatch(&REG_AREA.,compress(&area.));
					&flag.=(&flag. and prxmatch(&REG_YYYYMMDD.,compress(&ymd.)));
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
		if &flag.;
		&out.=compress(&scertno.);
		drop &area. &ymd. &chk. &l. &flag. &scerttype. &scertno.;
	));
	%let &res.=&tstmt.;
%mend genChkCertId;
* 证件信息提取;
%macro genFromCertId(var=,outgender=,outage=,outarea=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&outgender.) or %isBlank(&outage.) or %isBlank(&outarea.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%local flag;
	%let flag=%createTemp(V);
	%local year;
	%let year=%substr(%dtvToDs(&DATABASE_DATE.),1,4);
	%let tstmt=%str(%quote(
		length &outgender. &LENGTH_ENUM. &outage. 3 &outarea. 3;
		format &outarea. province. &outgender. gender.;
		&flag.=(not missing(&var.));
		if &flag. then do;
			&outgender.=inputn(substr(&var.,17,1),'certIdToGender');
			&outage.=&year.-inputn(substr(&var.,7,4),'best');
			&outarea.=substr(&var.,1,2)*1;
		end;
		drop &flag.;
	));
	%let &res.=&tstmt.;
%mend;
* 生成机构号;
%macro genChkOrgcode(out=,sorgcode=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&sorgcode.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%local length;
	%let length=%createTemp(V);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		length  &out. $&LENGTH_ORGCODE.;
		&flag.=(not missing(&sorgcode.));
		if &flag. then do;
			&length.=length(compress(&sorgcode.));
			&flag.=(&length. eq &LENGTH_ORGCODE.);
			if &flag. then do;
				&flag.=(prxmatch(&REG_ORGCODE.,compress(&sorgcode.)));
			end;
		end;
		if &flag.;
		&out.=compress(&sorgcode.);
		drop &length. &flag. &sorgcode.;
	));
	%let &res.=&tstmt.;
%mend genChkOrgcode;
* 生成数据获取时间;
%macro genChkGetdate(out=,dgetdate=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&dgetdate.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		format &out. &FORMAT_DATE.;
		&flag.=(not missing(&dgetdate.));
		if &flag. then do;
			&flag.=(&NFCS_START_DATE. le &dgetdate. lt &NFCS_END_DATE.);
		end;
		if &flag.;
		&out.=&dgetdate.;
		drop &flag. &dgetdate.;
	));
	%let &res.=&tstmt.;
%mend genChkGetdate;
* 检查istate;
%macro chkIstate(istate=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&istate.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&istate.));
		if &flag. then do;
			&flag.=(&istate. eq 0);
		end;
		if &flag.;
		drop &istate. &flag.;
	));
	%let &res.=&tstmt.;
%mend chkIstate;
* 生成业务时间;
%macro genChkBusiDate(outdate=,outmonth=,date=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&outdate.) or %isBlank(&outmonth.) or %isBlank(&date.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%local flag;
	%let flag=%createTemp(V);

	%local tstmt;

	%let tstmt=%str(%quote(
		format &outdate. &outmonth. &FORMAT_DATE.;
		&flag.=(not missing(&date.));
		if &flag. then do;
			&flag.=(&BIZ_START_DATE. le &date. lt &BIZ_END_DATE.);
		end;
		if &flag.;
		&outdate.=&date.;
		&outmonth.=intnx('dtmonth',&date.,0,'b');
		drop &flag. &date.;
	));
	%let &res.=&tstmt.;
%mend genChkBusiDate;
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
* 生成名字;
%macro genName(out=,name=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&name.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. $&LENGTH_NAME.;
		&flag.=(not missing(&name.));
		if &flag. then do;
			&flag.=(&name. not in(&NAME_BL.));
		end;
		if &flag. then &out.=compress(&name.);
		else &out.='';
		drop &flag. &name.;
	));
	%let &res.=&tstmt.;
%mend genName;
* 枚举变量;
%macro genWithFormatEnum(out=,enum=,informat=,format=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&out.) or %isBlank(&enum.) or %isBlank(&format.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%formatExist(lib=work,fmt=&informat.,isInformat=1,res=&tres.);%if &&&tres. eq 0 %then %error(&informat. does not exist!);
	%formatExist(lib=work,fmt=&format.,isInformat=0,res=&tres.);%if &&&tres. eq 0 %then %error(&format. does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%local tstmt;
	%let tstmt=%str(%quote(
		length &out. &LENGTH_ENUM.;
		format &out. &format..;
		&flag.=(not missing(&enum.));
		if &flag. then &out=inputn(compress(&enum.),"&informat.");
		drop &flag. &enum.;
	));
	%let &res.=&tstmt.;
%mend genWithFormatEnum;
* 生成电话号码;
%macro genMphone(out=,mphone=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&mphone.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. $&LENGTH_MPHONE.;
		&flag.=(not missing(&mphone.));
		if &flag. then do;
			&flag.=(length(compress(&mphone.)) eq &LENGTH_MPHONE.);
			if &flag. then do;
				&flag.=prxmatch(&REG_MPHONE.,compress(&mphone.));
			end;
		end;
		if &flag. then &out.=prxchange(&REGC_MPHONE_DOT.,-1,compress(&mphone.));
		else &out.='';
		drop &flag. &mphone.;
	));
	%let &res.=&tstmt.;
%mend genMphone;
* 生成邮编;
%macro genZip(out=,var=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. $&LENGTH_ZIP.;
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=(length(compress(&var.)) eq &LENGTH_ZIP.);
			if &flag. then do;
				&flag.=prxmatch(&REG_ZIP.,compress(&var.));
			end;
		end;
		if &flag. then &out.=compress(&var.);
		else &out.='';
		drop &flag. &var.;
	));
	%let &res.=&tstmt.;
%mend genzip;
* 金额类;
%macro genMoney(out=,var=,iszero=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt zerostmt;

	%if %isBlank(&var.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%if %isBlank(&iszero.) %then %let iszero=1;
	%local flag;
	%let flag=%createTemp(V);

	%if &iszero. %then %let zerostmt=ge;
	%else %let zerostmt=gt;
	%let tstmt=%str(%quote(
		length &out. 8;
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=(&var. &zerostmt. 0);
		end;
		if &flag. then &out.=&var.;
		else call missing(&out.);
		drop &flag. &var.;
	));
	%let &res.=&tstmt.;
%mend genMoney;
* 工作开始时间;
%macro genStartyear(out=,var=,cert=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&out.) or %isBlank(&cert.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. 4;
		&flag.=(not missing(&var.) and not missing(&cert.));
		if &flag. then do;
			&flag.=(&JOB_START_YEAR. le &var. le &JOB_END_YEAR.);
			if &flag. then do;
				&flag.=((&var.-substr(&cert.,7,4)*1) ge &JOB_START_AGE.);
			end;
		end;
		if &flag. then &out.=&var.;
		else call missing(&out.);
		drop &flag. &var.;
	));
	%let &res.=&tstmt.;
%mend genStartyear;
* 申请月数;
%macro genApplymonth(out=,var=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. 8;
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=(&var. gt 0);
		end;
		if &flag. then do;
			if &var. lt 1 then &out.=&var.;
			else &out.=round(&var.,1);
		end;
		else call missing(&out.);
		drop &flag. &var.;
	));
	%let &res.=&tstmt.;
%mend genApplymonth;
* 字符转自然数;
%macro genWithStrint(out=,var=,iszero=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt zerostmt;

	%local nn;
	%let nn=%createTemp(V);
	%if %isBlank(&var.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%if %isBlank(&iszero.) %then %let iszero=1;
	%local flag;
	%let flag=%createTemp(V);

	%if &iszero. %then %let zerostmt=ge;
	%else %let zerostmt=gt;
	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=prxmatch(&REG_NN.,compress(&var.));
			if &flag. then do;
				&nn.=input(&var.,best.);
				&flag.=(&nn. &zerostmt. 0);
			end;
		end;
		if &flag. then &out.=&nn.;
		else call missing(&out.);
		drop &flag. &var. &nn.;
	));
	%let &res.=&tstmt.;
%mend genWithStrint;
* 自然数;
%macro genInt(out=,var=,iszero=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt zerostmt;

	%if %isBlank(&var.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%if %isBlank(&iszero.) %then %let iszero=1;
	%local flag;
	%let flag=%createTemp(V);

	%if &iszero. %then %let zerostmt=ge;
	%else %let zerostmt=gt;
	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=not(floor(&var.) lt &var. lt ceil(&var.));
			if &flag. then do;
				&flag.=(&var. &zerostmt. 0);
			end;
		end;
		if &flag. then &out.=&var.;
		else call missing(&out.);
		drop &flag. &var.;
	));
	%let &res.=&tstmt.;
%mend genInt;
* 地区代码;
%macro genAreacode(out=,var=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=prxmatch(&REG_AREACODE.,compress(&var.));
		end;
		if &flag. then &out.=&compress(&var.);
		else call missing(&out.);
		drop &flag. &var.;
	));
	%let &res.=&tstmt.;
%mend genAreacode;
* 24月还款状态;
%macro genPaystat24month(out=,var=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local isHead MPD c i;
	%let isHead=%createTemp(V);
	%let MPD=%createTemp(V);
	%let c=%createTemp(V);
	%let i=%createTemp(V);

	%if %isBlank(&var.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=(length(compress(&var.)) eq &LENGTH_PAYSTAT24MONTH.);
			if &flag. then do;
				&flag.=prxmatch(&REG_PAYSTAT.,compress(&var.));
				if &flag. then do;
					&isHead.=1;
					&MPD.=0;
					do &i.=1 to &LENGTH_PAYSTAT24MONTH.;
						&c.=compress(substr(&var.,&i.,1));
						select (&c.);
							when('1','2','3','4','5','6','7') do;
								if &isHead. then &MPD.=&c.*1;
								else do;
									&MPD.=&MPD.+1;
									&flag.=(&c.*1 le &MPD.);
								end;
								&isHead.=0;
							end;
							when('N','*') do;
								&MPD.=0;
								&isHead.=0;
							end;
							when('.') do;
								if &MPD. gt 0 then &MPD.=&MPD.+1;
							end;
							when('#','C','D','G','Z') do;
							end;
							otherwise;
						end;
					end;
				end;
			end;
		end;
		if &flag.;
		&out.=compress(&var.);
		drop &isHead. &MPD. &c. &i. &var. &flag.;
	));
	%let &res.=&tstmt.;
%mend genPaystat24month;
* 24月还款状态paystate;
%macro genPaystate(out=,var=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local paystatemonth;
	%let paystatemonth=%createTemp(V);

	%if %isBlank(&var.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. &LENGTH_ENUM.;
		format &out. paystat.;
		&flag.=(not missing(&var.));
		if &flag. then do;
			&paystatemonth.=substr(&var.,24,1);
		end;
		&out.=inputn(&paystatemonth.,'spaystat1month');
		drop &paystatemonth. &flag.;
	));
	%let &res.=&tstmt.;
%mend genPaystate;
* 账户终态_账户状态;
%macro genFinishstateAccountstat(out=,var=,dateopened=,dateclosed=,billingdate=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. &LENGTH_ENUM.;
		format &out. acctfinstat.;
		&flag.=(not missing(&var.) and not missing(&dateopened.) and not missing(&dateclosed.) and not missing(&billingdate.));
		if &flag. then do;
			if &billingdate. lt &dateopened. then &out=10;
			else if intck('dtmonth',&billingdate.,&dateclosed.,'c') ge 1 then do;
				if &var. in (1,2,5) then &out.=21;
				else if &var.=3 then &out.=22;
				else if &var.=4 then &out.=23;
			end;
			else if intck('dtmonth',&billingdate.,&dateclosed.,'c') lt 1 then do;
				if &var.=2 then &out.=31;
				else if &var. in (1,3,5) then &out.=32;
				else if &var.=4 then &out.=33;
			end;
			if &billingdate. gt &dateclosed. then do;
				if intck('dtmonth',&dateclosed.,&billingdate.,'c') <= &ACCTFINSTAT_EXPIRE_MONTH then do;
					if &var. in (1,2) then &out.=41;
					else if &var.=3 then &out.=42;
					else if &var.=4 then &out.=43;
					else if &var.=5 then &out.=49;
				end;
				else &out.=49;
			end;
		end;
		drop &flag.;
	));
	%let &res.=&tstmt.;
%mend;
* 账户终态_还款状态;
%macro genFinishstatePaystate(out=,var=,dateopened=,dateclosed=,billingdate=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. &LENGTH_ENUM.;
		format &out. acctfinstat.;
		&flag.=(not missing(&var.) and not missing(&dateopened.) and not missing(&dateclosed.) and not missing(&billingdate.));
		if &flag. then do;
			if &billingdate. lt &dateopened. then &out=10;
			else if intck('dtmonth',&billingdate.,&dateclosed.,'c') ge 1 then do;
				if &var. in (11,20,21,31,32,33,34,35,36,37) then &out.=21;
				else if &var.=40 then &out.=22;
				else if &var.=43 then &out.=23;
				else if &var. in(41,42) then &out.=29;
			end;
			else if intck('dtmonth',&billingdate.,&dateclosed.,'c') lt 1 then do;
				if &var. in(31,32,33,34,35,36,37) then &out.=31;
				else if &var. in (20,21,40) then &out.=32;
				else if &var.=43 then &out.=33;
				else if &var. in (41,42) then &out.=39;
			end;
			if &billingdate. gt &dateclosed. then do;
				if intck('dtmonth',&dateclosed.,&billingdate.,'c') <= &ACCTFINSTAT_EXPIRE_MONTH then do;
					if &var. in (20,21,31,32,33,34,35,36,37) then &out.=41;
					else if &var.=40 then &out.=42;
					else if &var.=43 then &out.=43;
					else if &var. in (41,42) then &out.=49;
				end;
				else &out.=49;
			end;
		end;
		drop &flag.;
	));
	%let &res.=&tstmt.;
%mend genFinishstatePaystate;
* 结清时间;
%macro genFinishdate(out=,finstate=,billingdate=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local paystatemonth;
	%let paystatemonth=%createTemp(V);

	%if %isBlank(&out.) or %isBlank(&finstate.) or %isBlank(&billingdate.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		format &out. &FORMAT_DATE.;
		&flag.=(not missing(&finstate.) and not missing(&billingdate.));
		if &flag. then do;
			call missing(&out.);
			if &finstate. not in(&SET_ACCTFINSTAT_OPEN.) then &out.=&billingdate.;
		end;
		drop &flag.;
	));
	%let &res.=&tstmt.;
%mend;
* 计算期数，天/周/月/季/半年/年数计算;
%macro genTermDuration(out=,varStart=,varEnd=,termsfreq=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local dd dm cm;
	%let sd=%createTemp(V);
	%let ed=%createTemp(V);
	%let cm=%createTemp(V);

	%if %isBlank(&varStart.) or %isBlank(&out.) or %isBlank(&varEnd.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%if %isBlank(&termsfreq.) %then %let termsfreq=3;
	%local flag;
	%let flag=%createTemp(V);
	%local method;
	%let method=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. 8 &method. $10;
		&flag.=(not missing(&varStart.) and not missing(&varEnd.));
		if &flag. then do;
			&flag.=(&varEnd. ge &varStart.);
			if &flag. then do;
				select(&termsfreq.);
					when(1,3,4,5,6) do;
						&sd.=day(datepart(&varStart.));
						&ed.=day(datepart(&varEnd.));
						&method.=putn(&termsfreq,'termsfreqToInt');
						&cm.=intck(&method.,&varStart.,&varEnd.,'c');
						if &sd. eq &ed. then &out.=&cm.;
						else &out.=&cm.+1;
					end;
					when(2) do;
						&sd.=weekday(datepart(&varStart.));
						&ed.=weekday(datepart(&varEnd.));
						&method.=putn(&termsfreq,'termsfreqToInt');
						&cm.=intck(&method.,&varStart.,&varEnd.,'c');
						if &sd. eq &ed. then &out.=&cm.;
						else &out.=&cm.+1;
					end;
					otherwise call missing(&out.);
				end;
			end;
		end;
		drop &cm. &sd. &ed. &method. &flag.;
	));
	%let &res.=&tstmt.;
%mend genTermDuration;
* 逾期月数;
%macro genWithAPDXMPD(out=,apd=,apd30=,apd60=,apd90=,apd180=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local paystatemonth;
	%let paystatemonth=%createTemp(V);

	%if %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. 8;
		&flag.=1;
		if &flag. then do;
			if &apd180. gt 0 then &out.=7;
			else if &apd90. gt 0 then &out.=4;
			else if &apd60. gt 0 then &out.=3;
			else if &apd30. gt 0 then &out.=2;
			else if &apd. gt 0 then &out.=1;
			else &out.=0;
		end;
		drop &flag.;
	));
	%let &res.=&tstmt.;
%mend;
%macro genWithPaystateMPD(var=,out=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local paystatemonth;
	%let paystatemonth=%createTemp(V);

	%if %isBlank(&var.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		length &out. 8;
		&flag.=(not missing(&var.));
		if &flag. then do;
			select(&var.);
				when(20,21) &out.=0;
				when(31) &out.=1; 
				when(32) &out.=2; 
				when(33) &out.=3; 
				when(34) &out.=4; 
				when(35) &out.=5; 
				when(36) &out.=6; 
				when(37) &out.=7; 
				otherwise call missing(&out.);
			end;
		end;
		drop &flag.;
	));
	%let &res.=&tstmt.;
%mend;
%macro genWithcurtermPDMPD(out=,termsfreq=,curtermsPD=,dateclosed=,billingdate=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local paystatemonth;
	%let paystatemonth=%createTemp(V);

	%if %isBlank(&curtermsPD.) or %isBlank(&out.) or %isBlank(&dateclosed.) or %isBlank(&billingdate.) or %isBlank(&termsfreq.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%local flag;
	%let flag=%createTemp(V);

	%local t_out t_res;
	%let t_out=%createTemp(V);
	%genTermDuration(out=&t_out.,varStart=&dateclosed.,varEnd=&billingdate.,res=&tres.);%let t_res=&&&tres.;

	%let tstmt=%str(%quote(
		length &out. 8;
		%unquote(&t_res.);
		&flag.=(not missing(&curtermsPD.) and not missing(&termsfreq.) and not missing(&dateclosed.) and not missing(&billingdate.));
		if &flag. then do;
			select(&termsfreq.);
				when(1) &out.=sum(&curtermsPD./30.42,&t_out.);
				when(2) &out.=sum(&curtermsPD./4.33,&t_out.); 
				when(3) &out.=sum(&curtermsPD.,&t_out.); 
				when(4) &out.=sum(&curtermsPD.*3,&t_out.); 
				when(5) &out.=sum(&curtermsPD.*6,&t_out.); 
				when(6) &out.=sum(&curtermsPD.*12,&t_out.); 
				otherwise call missing(&out.);
			end;
		end;
		drop &flag. &t_out.;
	));
	%let &res.=&tstmt.;
%mend;
* 相等判断;
%macro chkeq(vara=,varb=,res=,method=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local paystatemonth;
	%let paystatemonth=%createTemp(V);

	%if %isBlank(&vara.) or %isBlank(&varb.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%if %isBlank(&method.) %then %let method=DELETE;
	%else %let method=%upcase(&method.);

	%local methodstmt;
	%if &method. eq DELETE %then %let methodstmt=%str(%quote(delete;));
	%else %if &method. eq MISSA %then %let methodstmt=%str(%quote(call missing(&vara.);));
	%else %if &method. eq MISSB %then %let methodstmt=%str(%quote(call missing(&varb.);));
	%else %if &method. eq MISSALL %then %let methodstmt=%str(%quote(call missing(&vara.);call missing(&varb.);));
	%else %error(METHOD is illegal!);

	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&vara.) and not missing(&varb.));
		if &flag. then do;
			&flag.=(&vara. eq &varb.);
		end;
		if not &flag. then do;
			%unquote(&methodstmt.);
		end;
		drop &flag.;
	));
	%let &res.=&tstmt.;
%mend chkeq;
* 比较校验gt;
%macro chkGt(large=,small=,iseq=,res=,method=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt iseqstmt;

	%if %isBlank(&large.) or %isBlank(&small.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%if %isBlank(&iseq.) %then %let iseq=1;
	%if %isBlank(&method.) %then %let method=DELETE;
	%else %let method=%upcase(&method.);

	%local flag;
	%let flag=%createTemp(V);

	%local methodstmt;
	%if &method. eq DELETE %then %let methodstmt=%str(%quote(delete;));
	%else %if &method. eq MISSLARGE %then %let methodstmt=%str(%quote(call missing(&large.);));
	%else %if &method. eq MISSSMALL %then %let methodstmt=%str(%quote(call missing(&small.);));
	%else %if &method. eq MISSALL %then %let methodstmt=%str(%quote(call missing(&large.);call missing(&small.);));
	%else %error(METHOD is illegal!);

	%if &iseq. %then %let iseqstmt=ge;
	%else %let iseqstmt=gt;
	%let tstmt=%str(%quote(
		&flag.=(not missing(&large.) and not missing(&small.));
		if &flag. then do;
			&flag.=(&large. &iseqstmt. &small.);
		end;
		if not &flag. then do;
			%unquote(&methodstmt.);
		end;
		drop &flag.;
	));
	%let &res.=&tstmt.;
%mend;
* 缺失检查;
%macro chkMissing(var=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt iseqstmt;

	%if %isBlank(&var.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%local flag;
	%let flag=%createTemp(V);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag.;
		drop &flag.;
	));
	%let &res.=&tstmt.;
%mend;
* 取最大;
%macro genMax(vars=,out=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&vars.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%local sqlvars;
	%let sqlvars=%sasVarsToSql(&vars.);
	%let tstmt=%str(%quote(
		&out.=max(&sqlvars.);
	));
	%let &res.=&tstmt.;
%mend;
