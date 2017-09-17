# @summary Manages prerequisite classes in Linux. They are applied before the others
#
# This class manages prerequisites resources for all the other classes.
# Basically package repositories, subscriptions and eventually proxy server to
# use.
# This psick class is the only one included by default on the base psicks.
#
# @param manage If to actually manage any resource. Set to false to disable
#   any effect of the pre psick.
#
# @param rpmgpg_class Name of the class to include to manage gpgkeys on rpm
#                     based systems
# @param rhn_class Name of the class to include to manage RHN on RedHat family
# @param repo_class Name of the class to include to manage additional repos
# @param proxy_class Name of the class to include to the system's proxy server
#
# @example Including additional classes for rpmgpg and repo
#    psick::pre::linux::rpmgpg_class: '::psick::pre::gpgkeys'
#    psick::pre::linux::repo_class: '::psick::repo'
#
class psick::pre::linux (
  # General switch. If false nothing is done.
  Boolean $manage      = true,

  String $rpmgpg_class = '',
  String $rhn_class    = '',
  String $repo_class   = '',
  String $proxy_class  = '',
) {

  if $rpmgpg_class != '' and $::osfamily =~ /RedHat|Suse/ and $manage {
    contain $rpmgpg_class
  }

  if $rhn_class != '' and $::osfamily =~ /RedHat|Suse/ and $manage {
    contain $rhn_class
  }

  if $repo_class != '' and $manage {
    contain $repo_class
  }

  if $proxy_class != '' and $manage {
    contain $proxy_class
  }
}
