alter table "Process".process_fake 
add column "Desc" varchar;

alter table "Process".process_fake 
drop column description;


drop table "Process".process_fake;