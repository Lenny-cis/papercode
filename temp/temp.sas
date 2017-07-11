* flag��ʶ�۲�ɾ��;
%macro flagfilter(inds=,outds=,flags=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if not %dsExist(&inds.) %then %error(INDS does not exist!&sysparm.);
	%if %isBlank(&outds.) %then %let outds=&inds.;

	%local varsList;
	%local dsVarsN dsVar i;
	%local flagsN flag j;
	%getDsVarsList(inds=&inds.,res=&tres.);%let varslist=&&&tres.;
	%if %isBlank(&flags.) %then %do;
		%varsCount(vars=&varsList.,res=&tres.);%let dsVarsN=&&&tres.;
		%do i=1 %to &dsVarsN.;
			%varsN(vars=&varsList.,n=&i.,res=&tres.);%let dsVar=&&&tres.;
			%if %length(&dsVar.) gt 3 %then %do;
				%substr(&dsVar.,1,3) eq _F_ %then %let flags=&flags. &dsVar.;
			%end;
		%end;
	%end;
	%else %do;
		%intersection(a=&flags.,b=&varsList.,res=&tres.);%let flags=&&&tres.;
	%end;
	data &outds.;
		set &inds.;
		%varsCount(vars=&flags.,res=&tres.);%let flagsN=&&&tres.;
		%do j=1 %to &flagsN.;
			%varsN(vars=&flags.,n=&j.,res=&tres.);%let flag=&&&tres.;
			if &flag.;
		%end;
		drop &flags.;
	run;

%mend flagfilter;
* ���������;
%macro varsCount(vars=,res=);
	%local sw res var i;
	%let sw=1;
	%let i=1;
	%if not %refExist(&res) %then %error(RES is not valid!);
	%let &res=0;
	%if %isBlank(&vars) %then %return;
	%do %while(&sw);
		%let var=%qscan(&vars,&i,,QS);
		%if %isBlank(&var) %then %let sw=0;
		%else %do;
			%let &res=&i;
			%let i=%eval(&i+1);
		%end;
	%end;
%mend varsCount;
* ��N�������;
%macro varsN(vars=,n=,res=);
	%if not %refExist(&res) %then %error(RES is not valid!);
	%let &res=%str();
	%if %isBlank(&vars) or %isBlank(&n) %then %return;
	%if &n=0 %then %return;
	%let &res=%qscan(&vars,&n,,QS);
%mend;
* �����ȥ��;
%macro varsUnique(vars=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&vars.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%let &res.=%str();

	%local varsN var i;
	%varsCount(vars=&vars.,res=&tres.);%let varsN=&&&tres.;
	%do i=1 %to &varsN.;
		%varsN(vars=&vars.,n=&i.,res=&tres.);%let var=&&&tres.;
		%if not(&var. in(&&&res.)) %then %let &res.=&&&res. &var.;
	%end;
%mend;
* ���������;
%macro intersection(a=,b=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&a.) or %isBlank(&b.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%let &res.=%str();

	options minoperator;

	%local aN bN avar bvar i j;

	%varsUnique(vars=&a.,res=&tres.);%let a=&&&tres.;
	%varsUnique(vars=&b.,res=&tres.);%let b=&&&tres.;
	%varsCount(vars=&a.,res=&tres.);%let aN=&&&tres.;
	%varsCount(vars=&b.,res=&tres.);%let bN=&&&tres.;
	%do i=1 %to &aN.;
		%varsN(vars=&a.,n=&i.,res=&tres.);%let avar=&&&tres.;
		%if &avar. in (&b.) %then %let &res.=&res. &avar.;
	%end;
	%do j=1 %to &bN.;
		%varsN(vars=&b.,n=&j.,res=&tres.);%let bvar=&&&tres.;
		%if &bvar. in (&a.) %then %let &res.=&res. &bvar.
	%end;

	options nominoperator;
%mend intersection;
* ���������;
%macro union(a=,b=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&a.) or %isBlank(&b.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%let &res.=&b.;

	options minoperator;

	%local aN avar i;

	%varsUnique(vars=&a.,res=&tres.);%let a=&&&tres.;
	%varsUnique(vars=&b.,res=&tres.);%let b=&&&tres.;
	%varsCount(vars=&a.,res=&tres.);%let aN=&&&tres.;
	%do i=1 %to &aN.;
		%varsN(vars=&a.,n=&i.,res=&tres.);%let avar=&&&tres.;
		%if not(&avar. in (&b.)) %then %let &res.=&res. &avar.;
	%end;

	options nominoperator;
%mend union;
* �������Բ��������;
%macro RelativeComplement(sources=,targets=,res=) /parmbuff;
	%local tres;%let tres=%createTemp(V);%local &tres.;

	%if %isBlank(&sources.) or %isBlank(&targets.) %then %error(Required param is empty! &syspbuff);
	%if not %refExist(&res.) %then %error(RES is illegal!);
	%let &res.=%str();

	options minoperator;

	%local sourcesN source i;

	%varsUnique(vars=&sources.,res=&tres.);%let sources=&&&tres.;
	%varsUnique(vars=&targets.,res=&tres.);%let targets=&&&tres.;
	%varsCount(vars=&sources.,res=&tres.);%let sourcesN=&&&tres.;
	%do i=1 %to &sourcesN.;
		%varsN(vars=&sources.,n=&i.,res=&tres.);%let source=&&&tres.;
		%if not(&source. in(&targets.)) %then %let &res.=&&&res. &source.;
	%end;

	options nominoperator;
%mend RelativeComplement;
