# @summary Manages prerequisite classes in Windows. They are applied before the others
#
# This class manages prerequisites resources for all the other classes.
# Basically package repositories, subscriptions and eventually proxy server to
# use.
# This psick class is the only one included by default on the base psicks.
#
# @param firstboot_class Name of a class that is supposed to run or do something
#  only at first boot. Use it for example to set correct hostnames or basic settings
#  and then trigger a reboot for clear afterward aoperations, such as domain join
# @param proxy_class Name of the class to include to the system's proxy server
# @param repo_class Name of the class to include to manage package repos
#  like chocolatey
#
# @example Including additional classes for rpmgpg and repo
#    psick::pre::windows::firstboot_class: '::psick::windows::firstboot'
#    psick::pre::windows::proxy_class: '::psick::windows::proxy'
#    psick::pre::windows::repo_class: '::chocolatey'
#
class psick::pre::windows (
  # General switch. If false nothing is done.
  Boolean $manage         = true,

  String $firstboot_class = '',
  String $proxy_class     = '',
  String $repo_class      = '',
) {

  if $firstboot_class != '' and $manage {
    contain $firstboot_class
  }

  if $proxy_class != '' and $manage {
    contain $proxy_class
  }

  if $repo_class != '' and $manage {
    contain $repo_class
  }

}
