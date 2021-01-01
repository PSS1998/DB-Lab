/*a*/
select jc.name from "Jobs".job_category as jc;

/*b*/
select jc."name",COUNT(*) from "Jobs".job j 
inner join "Jobs".job_category jc on jc.id = j.job_category_id
inner join "Process".process pc on pc.id = j.process_id 
inner join "Recruiter".application_evaluation ae on ae.recruiter_id = pc.recruiter_i
GROUP BY jc."name",ae."hired"
HAVING ae.hired=0::bit;

/*c*/
select jp."name" from "Jobs".job j 
inner join "Jobs".job_position jp on jp.id = j.job_position_id 
inner join "Applicant".application a on a.jobs_id = j.id 
where a.applicant_id = '5deb6ea4-6ca8-4b6e-a7f0-d4f7335668bf';

select a.applicant_id from "Jobs".job j 
inner join "Jobs".job_position jp on jp.id = j.job_position_id 
inner join "Applicant".application a on a.jobs_id = j.id 
GROUP BY a.applicant_id 
HAVING count(*)=0;

/*e*/
select o."name", jp."name" from "Jobs".job j 
full outer join "Jobs".job_position jp on jp.id = j.job_position_id 
full outer join "Jobs".organization o on o.id = j.organizations_id;

/*f*/
select a2.first_name , a2.last_name , a2.summary , a2.email , a2.phone from "Jobs".job j 
inner join "Applicant".application a on a.jobs_id = j.id
inner join "Applicant".applicant a2 on a2.id = a.applicant_id 
inner join "Applicant".application_document ad on ad.application_id = a.id 
inner join "Applicant"."document" d on d.id = ad.document_id 
where d."document" is not null;

/*g*/


/*h*/
select in2.pass Interview , a2.pass Test from "Applicant".application a
inner join "Interview".application_test at on at.application_id = a.id 
inner join "Interview".interview i on i.application_id = a.id 
inner join "Interview".answers a2 on a2.application_test = at.id 
inner join "Interview".interview_note in2 on in2.interview_id = i.id
where a.applicant_id = '5deb6ea4-6ca8-4b6e-a7f0-d4f7335668bf';

/*j*/
select jp."name" , count(*) from "Jobs".job j 
inner join "Jobs".job_platform jp on jp.id = j.job_platform_id 
GROUP BY jp.id;

