--
-- $Id$
--

create table
rhnUserGroupType
(
	id		number
			constraint rhn_userGroupType_id_nn not null
			constraint rhn_userGroupType_id_pk primary key
				using index tablespace [[64k_tbs]],
	label		varchar2(64)
			constraint rhn_userGroupType_label_nn not null,
	name		varchar2(64)
			constraint rhn_userGroupType_name_nn not null,
	created		date default(sysdate)
			constraint rhn_userGroupType_created_nn not null,
	modified	date default(sysdate)
			constraint rhn_userGroupType_modified_nn not null
)
	storage ( freelists 16 )
	enable row movement
	initrans 32;

create sequence rhn_usergroup_type_seq;

create index rhn_usergrouptype_label_id_idx
	on rhnUserGroupType ( label, id )
	tablespace [[64k_tbs]]
	storage ( freelists 16 )
	initrans 32;
alter table rhnUserGroupType add
	constraint rhn_usergrouptype_label_uq unique ( label );

-- $Log$
-- Revision 1.17  2004/04/16 12:29:54  misa
-- Removing duplicates to make nightly builds happy
--
-- Revision 1.16  2003/04/29 15:22:20  pjones
-- last one, now the tables all look like they should when the change
-- is applied
--
-- Revision 1.14  2003/03/28 20:39:47  pjones
-- bugzilla: 87558
-- change the indexing on these to make errata mail queries a little lighter
--
-- Revision 1.13  2003/01/30 16:11:28  pjones
-- storage parameters, also fix deps to make it build again
--
-- Revision 1.12  2002/05/10 22:00:48  pjones
-- add rhnFAQClass, and make it a dep for rhnFAQ
-- add grants where appropriate
-- add cvs id/log where it's been missed
-- split data out where appropriate
-- add excludes where appropriate
-- make sure it still builds (at least as sat).
-- (really this time)
--
