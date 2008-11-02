#
# Copyright (c) 2008 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 2 (GPLv2). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
# along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
# 
# Red Hat trademarks are not licensed under GPLv2. No permission is
# granted to use or replicate Red Hat trademarks that are incorporated
# in this software or its documentation. 
#


from common import log_debug
from server.rhnLib import InvalidAction, ShadowAction
from server.action.utils import SubscribedChannel,\
                                ChannelPackage, \
                                PackageInstallScheduler, \
                                NoActionInfo, \
                                PackageNotFound
from server.rhnChannel import subscribe_to_tools_channel

__rhnexport__ = ['schedule_virt_host_pkg_install', 'add_tools_channel']

def add_tools_channel(server_id, action_id):
    subscribe_to_tools_channel(server_id)
    raise ShadowAction("Subscribed server to tools channel.")

def schedule_virt_host_pkg_install(server_id, action_id):
    """
        ShadowAction that schedules a package installation action for the
        rhn-virtualization-host and osad packages.
    """
    log_debug(3)
    
    virt_host_package_name = "rhn-virtualization-host"
    messaging_package_name = "osad"

    tools_channel = SubscribedChannel(server_id, "rhn-tools")
    found_tools_channel = tools_channel.is_subscribed_to_channel()

    if not found_tools_channel:
        raise InvalidAction("System not subscribed to the RHN Tools channel.")

    rhn_v12n_package = ChannelPackage(server_id, virt_host_package_name)

    if not rhn_v12n_package.exists():
        raise InvalidAction("Could not find the rhn-virtualization-host package.")

    messaging_package = ChannelPackage(server_id, messaging_package_name)

    if not messaging_package.exists():
        raise InvalidAction("Could not find the osad package.")

    try:
        rhn_v12n_install_scheduler = PackageInstallScheduler(server_id, action_id, rhn_v12n_package)
        rhn_v12n_install_scheduler.schedule_package_install()

        messaging_package = PackageInstallScheduler(server_id, action_id, messaging_package)
        messaging_package.schedule_package_install()
    except NoActionInfo, nai:
        raise InvalidAction(str(nai))
    except PackageNotFound, pnf:
        raise InvalidAction(str(pnf))
    except Exception, e:
        raise InvalidAction(str(e))

    log_debug(3, "Completed scheduling install of rhn-virtualization-host and osad!")
    raise ShadowAction("Scheduled installation of RHN Virtualization Host packages.")

