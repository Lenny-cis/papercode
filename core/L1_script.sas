%base_certification(inds=L0.sino_person_certification,outds=L1.certification);
%base_org(inds=L0.sino_org,outds=L1.org);
%base_person(inds=L0.sino_person,outds=L1.person,baseCertds=L1.certification);
%base_person(inds=L0.sino_person_address,outds=L1.address,baseCertds=L1.certification);
%base_person(inds=L0.sino_person_employment,outds=L1.employment,baseCertds=L1.certification);
%base_loanApply(inds=L0.sino_loan_apply,outds=L1.apply,baseCertds=L1.certification);
%base_loan(inds=L0.sino_loan,outds=L1.loan,baseCertds=L1.certification);
%base_creditRecord(inds=L0.sino_credit_record,outds=L1.record,baseOrgds=L1.org,baseCertds=L1.certification);
