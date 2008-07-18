--
-- $Id$
--

create table
rhnChannelPackageArchCompat
(
        channel_arch_id	number
                        constraint rhn_cp_ac_caid_nn not null
                        constraint rhn_cp_ac_caid_fk 
				references rhnChannelArch(id),
	package_arch_id	number
			constraint rhn_cp_ac_paid_nn not null
			constraint rhn_cp_ac_paid_fk
				references rhnPackageArch(id),
	created		date default(sysdate)
			constraint rhn_cp_ac_created_nn not null,
	modified	date default(sysdate)
			constraint rhn_cp_ac_modified_nn not null
)
	storage ( freelists 16 )
	enable row movement
	initrans 32;

create index rhn_cp_ac_caid_paid
	on rhnChannelPackageArchCompat(
		channel_arch_id, package_arch_id)
	tablespace [[64k_tbs]]
	storage ( freelists 16 )
	initrans 32;
alter table rhnChannelPackageArchCompat add constraint rhn_cp_ac_caid_paid_uq
	unique ( channel_arch_id, package_arch_id );

create index rhn_cp_ac_paid_caid
	on rhnChannelPackageArchCompat(
	 	package_arch_id, channel_arch_id)
	tablespace [[64k_tbs]]
	storage ( freelists 16 )
	initrans 32;

create or replace trigger
rhn_cp_ac_mod_trig
before insert or update on rhnChannelPackageArchCompat
for each row
begin
        :new.modified := sysdate;
end;
/
show errors

-- $Log$
-- Revision 1.3  2003/01/30 16:11:28  pjones
-- storage parameters, also fix deps to make it build again
--
-- Revision 1.2  2002/11/14 17:05:19  misa
-- Drop preference, we don't need it here
--
-- Revision 1.1  2002/11/13 21:50:21  pjones
-- new arch system
--
