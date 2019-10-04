# DEPRECATION NOTICE: This profile has been deprecated.
# It will be removed on version 1.0.0 of psick module.
# Use equivalent class tp_profile::postgresql in the tp_profile module as replacement
# psick::postgresql::tp
#
# @summary This psick profile manages postgresql with Tiny Puppet (tp)
#
# @example Include it to install postgresql
#   include psick::postgresql::tp
#
# @example Include in PSICK via hiera (yaml)
#   psick::profiles::linux_classes:
#     postgresql: psick::postgresql::tp
#
# @example Manage extra configs via hiera (yaml) with templates based on custom options
#   psick::postgresql::tp::ensure: present
#   psick::postgresql::tp::resources_hash:
#     tp::conf:
#       postgresql:
#         epp: profile/postgresql/postgresql.conf.epp
#       postgresql::dot.conf:
#         epp: profile/postgresql/dot.conf.epp
#         base_dir: conf
#   psick::postgresql::tp::options_hash:
#     key: value
#
# @example Enable default auto configuration, if configurations are available
#   for the underlying system and the given auto_conf value, they are
#   automatically added (Default value is inherited from global $::psick::auto_conf
#   psick::postgresql::tp::auto_conf: 'default'
#
# @param manage If to actually manage any resource in this profile or not
# @param ensure If to install or remove postgresql. Valid values are present, absent, latest
#   or any version string, matching the expected postgresql package version.
# @param resources_hash An hash of tp::conf and tp::dir resources for postgresql.
#   tp::conf params: https://github.com/example42/puppet-tp/blob/master/manifests/conf.pp
#   tp::dir params: https://github.com/example42/puppet-tp/blob/master/manifests/dir.pp
# @param resources_auto_conf_hash The default resources hash if auto_conf is set. Default
#   value is based on $::psick::auto_conf. Can be overridden or set to an empty hash.
#   The final resources manages are the ones specified here and in $resources_hash.
#   Check psick::postgresql::tp:resources_auto_conf_hash in data/$auto_conf/*.yaml for
#   the auto_conf defaults.
# @param install_hash An hash of valid params to pass to tp::install defines. Useful to
#   manage specific params that are not automatically defined.
# @param options_hash An open hash of options to use in the templates referenced
#   in the tp::conf entries of the $resources_hash.
# @param options_auto_conf_hash The default options hash if auto_conf is set.
#   Check psick::postgresql::tp:options_auto_conf_hash in data/$auto_conf/*.yaml for
#   the auto_conf defaults.
# @param settings_hash An hash of tp settings to override default postgresql file
#   paths, package names, repo info and whatever can match Tp::Settings data type:
#   https://github.com/example42/puppet-tp/blob/master/types/settings.pp
# @param auto_prereq If to automatically install eventual dependencies for postgresql.
#   Set to false if you have problems with duplicated resources, being sure that you
#   manage the prerequistes to install postgresql (other packages, repos or tp installs).
# @param no_noop Set noop metaparameter to false to all the resources of this class.
#   This overrides client site noop setting but not $psick::noop_mode.
class psick::postgresql::tp (
  Psick::Ensure   $ensure                   = 'present',
  Boolean         $manage                   = $::psick::manage,
  Hash            $resources_hash           = {},
  Hash            $resources_auto_conf_hash = {},
  Hash            $install_hash             = {},
  Hash            $options_hash             = {},
  Hash            $options_auto_conf_hash   = {},
  Hash            $settings_hash            = {},
  Boolean         $auto_prereq              = $::psick::auto_prereq,
  Boolean         $no_noop                  = false,
) {

  if $manage {
    notify { 'Deprecated profile psick::postgresql::tp':
      message => 'This profile has been deprecated. It will be removed on version 1.0.0 of psick module. Use equivalent class tp_profile::postgresql in the tp_profile module as replacement',
    }
    if !$::psick::noop_mode and $no_noop {
      info('Forced no-noop mode in psick::postgresql::tp')
      noop(false)
    }
    $options_all = $options_auto_conf_hash + $options_hash
    $install_defaults = {
      ensure        => $ensure,
      options_hash  => $options_all,
      settings_hash => $settings_hash,
      auto_repo     => $auto_prereq,
      auto_prereq   => $auto_prereq,
    }
    tp::install { 'postgresql':
      * => $install_defaults + $install_hash,
    }

    # tp::conf iteration based on $resources_hash['tp::conf']
    $file_ensure = $ensure ? {
      'absent' => 'absent',
      default  => 'present',
    }
    $conf_defaults = {
      ensure        => $file_ensure,
      options_hash  => $options_all,
      settings_hash => $settings_hash,
    }
    $tp_confs = pick($resources_auto_conf_hash['tp::conf'], {}) + pick($resources_hash['tp::conf'], {})
    # All the tp::conf defines declared here
    $tp_confs.each | $k,$v | {
      tp::conf { $k:
        * => $conf_defaults + $v,
      }
    }

    # tp::dir iteration on $resources_hash['tp::dir']
    $dir_defaults = {
      ensure             => $file_ensure,
      settings_hash      => $settings_hash,
    }
    # All the tp::dir defines declared here
    $tp_dirs = pick($resources_auto_conf_hash['tp::dir'], {}) + pick($resources_hash['tp::dir'], {})
    $tp_dirs.each | $k,$v | {
      tp::dir { $k:
        * => $dir_defaults + $v,
      }
    }
  }
}
