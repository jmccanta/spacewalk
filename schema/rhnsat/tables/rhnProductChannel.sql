--
-- $Id$
--

create table
rhnProductChannel
(
	channel_id	number
			constraint rhn_pc_cid_nn not null 
			constraint rhn_pc_cid_fk
				references rhnChannel(id)
				on delete cascade,
	product_id	number
			constraint rhn_pc_pid_nn not null
			constraint rhn_pc_pid_fk
				references rhnProduct(id),
	created		date default (sysdate)
			constraint rhn_pc_created_nn not null,
	modified	date default (sysdate)
			constraint rhn_pc_modified_nn not null
)
	storage ( freelists 16 )
	enable row movement
	initrans 32;

create index rhn_pc_cid_pid_idx
	on rhnProductChannel ( channel_id, product_id )
	tablespace [[64k_tbs]]
	storage ( freelists 16 )
	initrans 32;
alter table rhnProductChannel add constraint rhn_pc_cid_pid_idx
	unique ( channel_id, product_id );

create index rhn_pc_pid_cid_idx
	on rhnProductChannel ( product_id, channel_id )
	tablespace [[64k_tbs]]
	storage ( freelists 16 )
	initrans 32;

-- $Log$
-- Revision 1.1  2003/03/11 00:37:16  pjones
-- bugzilla: 85516
--
-- public errata schema checkin
--
-- bretm, you owe me cookies.
--
