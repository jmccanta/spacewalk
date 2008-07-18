-- $Id$
--

create table
rhnPackageConflicts
(
        package_id      number
                        constraint rhn_pkg_conflicts_pid_nn not null
                        constraint rhn_pkg_conflicts_package_fk
                                references rhnPackage(id),
        capability_id   number
                        constraint rhn_pkg_conflicts_cid_nn not null
                        constraint rhn_pkg_conflicts_cap_fk
                                references rhnPackageCapability(id),
        sense           number default(0) -- comes from RPMSENSE_*
                        constraint rhn_pkg_conflicts_sense_nn not null,
        created         date default (sysdate)
                        constraint rhn_pkg_conflicts_ctime_nn not null,
        modified        date default (sysdate)
                        constraint rhn_pkg_conflicts_mtime_nn not null
)
	storage ( freelists 16 )
	enable row movement
	initrans 32;

create unique index rhn_pkg_confl_pid_cid_s_uq
	on rhnPackageConflicts(package_id, capability_id, sense)
	tablespace [[64k_tbs]]
	storage ( freelists 16 )
	initrans 32;

create index rhn_pkg_conflicts_cid_idx
	on rhnPackageConflicts(capability_id)
        tablespace [[64k_tbs]]
	storage ( freelists 16 )
	initrans 32
	nologging;

create or replace trigger
rhn_pkg_conflicts_mod_trig
before insert or update on rhnPackageConflicts
for each row
begin
        :new.modified := sysdate;
end;
/
show errors

-- create or replace trigger
-- rhn_pkg_csense_map_trig
-- after insert or update on rhnPackageConflicts
-- for each row
-- begin
--	buildPackageSenseMap(:new.sense);
-- end;
-- /
-- show errors

--
-- $Log$
-- Revision 1.9  2004/12/07 20:18:56  cturner
-- bugzilla: 142156, simplify the triggers
--
-- Revision 1.8  2003/01/30 16:11:28  pjones
-- storage parameters, also fix deps to make it build again
--
-- Revision 1.7  2003/01/24 16:42:23  pjones
-- last_modified on rhnPackage and rhnPackageSource
--
-- Revision 1.6  2002/05/09 05:23:29  gafton
-- new style comments
--
-- Revision 1.5  2002/04/13 21:29:19  misa
-- Commented out everything related to bitwiseAnd
--
-- Revision 1.4  2002/03/19 22:41:31  pjones
-- index tablespace names to match current dev/qa/prod (rhn_ind_xxx)
--
-- Revision 1.3  2002/02/21 16:27:19  pjones
-- rhn_ind -> [[64k_tbs]]
-- rhn_ind_02 -> [[server_package_index_tablespace]]
-- rhn_tbs_02 -> [[server_package_tablespace]]
--
-- for perl-Satcon so satellite can be created more directly.
--
-- Revision 1.2  2001/09/24 16:33:36  pjones
-- index renames
--
-- Revision 1.1  2001/09/13 18:05:29  pjones
-- new provides/requires/conflicts/obsoletes...
--
