--
-- $Id$
--

create table
rhnServerProfilePackage
(
        server_profile_id       number
	    	    	    	constraint rhn_sprofile_spid_nn not null
	    	    	    	constraint rhn_sprofile_spid_fk
				    	references rhnServerProfile(id)
					on delete cascade,
        name_id                 number
	    	    	    	constraint rhn_sprofile_nid_nn not null
	    	    	    	constraint rhn_sprofile_nid_fk
				    	references rhnPackageName(id),
        evr_id                  number 
	    	    	    	constraint rhn_sprofile_evrid_nn not null
	    	    	    	constraint rhn_sprofile_evrid_fk
				    	references rhnPackageEvr(id)
)
	storage ( freelists 16 )
	enable row movement
	initrans 32;

create index rhn_sprof_sp_sne_idx on
        rhnServerProfilePackage(server_profile_id, name_id, evr_id)
	tablespace [[64k_tbs]]
	storage ( freelists 16 )
	initrans 32
	nologging;

-- $Log$
-- Revision 1.6  2003/10/07 14:12:49  pjones
-- bugzilla: none -- cascade deps on rhnServerProfilePackage to make deletes
-- simpler
--
-- Revision 1.5  2003/01/30 16:11:28  pjones
-- storage parameters, also fix deps to make it build again
--
-- Revision 1.4  2002/11/08 17:20:58  pjones
-- update these as they're apparently actually going to be used.
-- This version does the PK index the "new" way, which we should use going
-- forward.
--
-- Revision 1.3  2002/05/10 22:00:48  pjones
-- add rhnFAQClass, and make it a dep for rhnFAQ
-- add grants where appropriate
-- add cvs id/log where it's been missed
-- split data out where appropriate
-- add excludes where appropriate
-- make sure it still builds (at least as sat).
-- (really this time)
--
