* 生成证件号码;
%macro genChkCertId(flag=,out=,scerttype=,scertno=,res=) /parmbuff;
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
		if &flag.;
		&out.=&scertno.;
		drop &area. &ymd. &chk. &l.;
	));
	%let &res.=&tstmt.;
%mend genChkCertId;

* 生成机构号;
%macro genChkOrgcode(flag=,out=,sorgcode=,res=) /parmbuff;
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
		if &flag.;
		&out.=&sorgcode.;
		drop &length.;
	));
	%let &res.=&tstmt.;
%mend genChkOrgcode;
* 生成数据获取时间;
%macro genChkGetdate(flag=,out=,dgetdate=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&dgetdate.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&dgetdate.));
		if &flag. then do;
			&flag.=(&NFCS_START_DATE. le &dgetdate. lt &NFCS_END_DATE.);
		end;
		if &flag.;
		&out.=&dgetdate.;
	));
	%let &res.=&tstmt.;
%mend genChkGetdate;
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
		if &flag.;
	));
	%let &res.=&tstmt.;
%mend chkIstate;
* 生成业务时间;
%macro genChkBusiDate(flag=,outdate=,outmonth=,date=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&flag.) or %isBlank(&outdate.) or %isBlank(&outmonth.) or %isBlank(&date.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);

	%local tstmt;

	%let tstmt=%str(%quote(
		&flag.=(not missing(&date.));
		if &flag. then do;
			&flag.=(&BIZ_START_DATE. le &date. lt &BIZ_END_DATE.);
		end;
		if &flag.;
		&outdate.=&date.;
		&outmonth.=intnx('dtmonth',&date.,0,'b');
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
%macro genName(flag=,out=,name=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&name.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&name.));
		if &flag. then do;
			&flag.=(&name. in(&NAME_BL.));
		end;
		if &flag. then &out.=compress(&name.);
		else &out.='';
	));
	%let &res.=&tstmt.;
%mend genName;
* 枚举变量;
%macro genWithFormatEnum(flag=,out=,enum=,format=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&flag.) or %isBlank(&out.) or %isBlank(&enum.) or %isBlank(&format.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);

	%local tstmt;
	%formatExist(lib=work,fmt=&format.,isInformat=1,res=&tres.);%if not &&&tres. %then %error(&format. does not exist!);
	%let tstmt=%str(%quote(
		&flag.=(not missing(&enum.));
		if &flag. then &out=inputn(upcase(compress(&enum.)),&format.);
	));
	%let &res.=&tstmt.;
%mend genWithFormatEnum;
* 生成电话号码;
%macro genMphone(flag=,out=,mphone=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&mphone.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&mphone.));
		if &flag. then do;
			&flag.=(length(compress(&mphone.)) ne &LENGTH_MPHONE.);
			if &flag. then do;
				&flag.=prxmatch(&REG_MPHONE.,compress(&mphone.));
			end;
		end;
		if &flag. then &out.=prxchange(&REG_MPHONE_DOT,-1,compress(&mphone.));
		else &out.='';
	));
	%let &res.=&tstmt.;
%mend genMphone;
* 生成邮编;
%macro genZip(flag=,out=,var=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=(length(compress(&var.)) ne &LENGTH_ZIP.);
			if &flag. then do;
				&flag.=prxmatch(&REG_ZIP.,compress(&var.));
			end;
		end;
		if &flag. then &out.=&var.;
		else &out.='';
	));
	%let &res.=&tstmt.;
%mend genMphone;
* 金额类;
%macro genMoney(flag=,out=,var=,iszero=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt zerostmt;

	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%if %isBlank(&iszero.) %then %let iszero=1;

	%if &iszero. %then %let zerostmt=ge;
	%else zerostmt=gt;
	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=(&var. &zerostmt. 0);
		end;
		if &flag. then &out.=&var.;
		else call missing(&out.);
	));
	%let &res.=&tstmt.;
%mend genMoney;
* 工作开始时间;
%macro genStartyear(flag=,out=,var=,cert=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) or %isBlank(&cert.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.) and not missing(&cert.));
		if &flag. then do;
			&flag.=(&JOB_START_YEAR. le &var. le &JOB_END_YEAR.);
			if &flag. then do;
				&flag.=((jobstartyear-substr(&cert.,7,4)*1) ge &JOB_START_AGE);
			end;
		end;
		if &flag. then &out.=&var.;
		else call missing(&out.);
	));
	%let &res.=&tstmt.;
%mend genStartyear;
* 申请月数;
%macro genApplymonth(flag=,out=,var=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=(&var. gt 0));
		end;
		if &flag. then do;
			if &var. lt 1 then &out.=&var.;
			else &out.=round(&var.,1);
		end;
		else &out.='';
	));
	%let &res.=&tstmt.;
%mend genApplymonth;
* 字符转自然数;
%macro genWithStrint(flag=,out=,var=,iszero=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt zerostmt;

	%local nn;
	%let nn=%createTemp(V);
	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%if %isBlank(&iszero.) %then %let iszero=1;

	%if &iszero. %then %let zerostmt=ge;
	%else zerostmt=gt;
	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=prxmatch(&REG_NN.,compress(&var.));
			if &flag. then do;
				&nn.=input(&var.,best.);
				&flag.=(&nn. &zerostmt. 0);
			end;
		end;
		if &flag. &out.=&nn.;
		else call missing(&out.);
		drop &nn.;
	));
	%let &res.=&tstmt.;
%mend genWithStrPint;
* 自然数;
%macro genInt(flag=,out=,var=,iszero=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt zerostmt;

	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%if %isBlank(&iszero.) %then %let iszero=1;

	%if &iszero. %then %let zerostmt=ge;
	%else zerostmt=gt;
	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=not(floor(&var.) lt &var. lt ceil(&var.));
			if &flag. then do;
				&flag.=(&var. &zerostmt. 0);
			end;
		end;
		if &flag. &out.=&var.;
		else call missing(&out.);
	));
	%let &res.=&tstmt.;
%mend genInt;
* 地区代码;
%macro genAreacode(flag=,out=,var=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=prxmatch(&REG_AREACODE.,&var.);
		end;
		if &flag. then &out.=&var.;
		else &out.='';
	));
	%let &res.=&tstmt.;
%mend genAreacode;
* 24月还款状态;
%macro genPaystat24month(flag=,out=,var=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local isHead MPD c i;
	%let isHead=%createTemp(V);
	%let MPD=%createTemp(V);
	%let c=%createTemp(V);
	%let i=%createTemp(V);

	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&flag.=(length(&var.) eq &LENGTH_PAYSTAT24MONTH.);
			if &flag. then do;
				&flag.=prxmatch(&REG_PAYSTAT.,&var.);
				if &flag. then do;
					&isHead.=1;
					&MPD.=0;
					do &i.=1 to &LENGTH_PAYSTAT24MONTH.;
						&c.=substr(&var.,&i.,1);
						select (&c.);
							when(prxmatch('/[1-7]/')) do;
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
		if &flag. then &out.=&var.;
		else &out.='';
		drop &isHead. &MPD. &c. &i.;
	));
	%let &res.=&tstmt.;
%mend genPaystat24month;
* 比较校验gt;
%macro chkGt(flag=,large=,small=,iseq=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt iseqstmt;

	%if %isBlank(&large.) or %isBlank(&flag.) or %isBlank(&small.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);
	%if %isBlank(&iseq.) %then %let iseq=1;

	%if &iseq. %then %let iseqstmt=ge;
	%else %let iseqstmt=gt;
	%let tstmt=%str(%quote(
		&flag.=(not missing(&large.) and not missing(&small.));
		if &flag. then do;
			&flag.=(&large. &iseqstmt. &small.);
		end;
		if &flag.;
	));
	%let &res.=&tstmt.;

%mend;
* 24月还款状态paystate;
%macro genPaystate(flag=,out=,var=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local paystatemonth;
	%let paystatemonth=%createTemp(V);

	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.));
		if &flag. then do;
			&paystatemonth.=substr(&var.,24,1);
		end;
		&out.=inputn(&paystatemonth.,'spaystat1month');
		drop &paystatemonth.;
	));
	%let &res.=&tstmt.;
%mend genPaystate;
* 账户终态_账户状态;
%macro genFinishstateAccountstat(flag=,out=,var=,dateopened=,dateclosed=,billingdate=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.) and not missing(&dateopened.) and not missing(&dateclosed.) and not missing(&billingdate.));
		if &flag. then do;
			if &billingdate. lt &dateopened. then &out=10;
			else if intck('dtmonth',&billingdate.,&dateclose.,'c') ge 1 then do;
				if &var. in (1,2,5) then &out.=21;
				else if &var.=3 then &out.=22;
				else if &var.=4 then &out.=23;
			end;
			else if intck('dtmonth',&billingdate.,&dateclose.,'c') lt 1 then do;
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
	));
	%let &res.=&tstmt.;
%mend;
* 账户终态_还款状态;
%macro genFinishstatePaystate(flag=,out=,var=,dateopened=,dateclosed=,billingdate=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.) and not missing(&dateopened.) and not missing(&dateclosed.) and not missing(&billingdate.));
		if &flag. then do;
			if &billingdate. lt &dateopened. then &out=10;
			else if intck('dtmonth',&billingdate.,&dateclose.,'c') ge 1 then do;
				if &var. in (11,20,21,31,32,33,34,35,36,37) then &out.=21;
				else if &var.=40 then &out.=22;
				else if &var.=43 then &out.=23;
				else if &var. in(41,42) then &out.=29;
			end;
			else if intck('dtmonth',&billingdate.,&dateclose.,'c') lt 1 then do;
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
	));
	%let &res.=&tstmt.;
%mend genFinishstatePaystate;
* 相等判断;
%macro chkeq(flag=,out=,vara=,varb=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local paystatemonth;
	%let paystatemonth=%createTemp(V);

	%if %isBlank(&vara.) or %isBlank(&varb.) or %isBlank(&flag.) or %isBlank(&out.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&vara.) and not missing(&varb.));
		if &flag. then do;
			&flag.=(&vara. eq &varb.);
		end;
		if &flag.;
		&out.=&vara.;
	));
	%let &res.=&tstmt.;
%mend chkeq;
* 结清时间;
%macro genFinishdate(flag=,var=,out=,finstate=,billingdate=,res=);
	%local tres;%let tres=%createTemp(V);%local &tres.;
	%local tstmt;

	%local paystatemonth;
	%let paystatemonth=%createTemp(V);

	%if %isBlank(&var.) or %isBlank(&flag.) or %isBlank(&out.) or %isBlank(&finstate.) or %isBlank(&billingdate.) %then %error(PARAM is missing!&syspbuff.);
	%if not %refExist(&res.) %then %error(RES does not exist!);

	%let tstmt=%str(%quote(
		&flag.=(not missing(&var.) and not missing(&finstate.) and not missing(&billingdate.));
		if &flag. then do;
			call missing(&out.);
			if &finstate. not in(&SET_ACCTFINSTAT_OPEN.) then &out.=&billingdate.;
		end;
	));
	%let &res.=&tstmt.;
%mend;
