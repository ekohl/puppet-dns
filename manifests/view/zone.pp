define dns::view::zone (
  $zone,
  $view           = $title,
  $publicviewpath = $::dns::publicviewpath,
  $viewconfigpath = $::dns::viewconfigpath,
  $zonetype       = 'master',
  $forward        = 'first',
  $forwarders     = [],
  $manage_file    = true,
  $zonefilename   = undef,
  $allow_transfer = [],
  $allow_query    = [],
  $also_notify    = [],
  $masters        = [],
  $dns_notify     = undef,
) {
  $target = $view ? {
    '_GLOBAL_' => $publicviewpath,
    default    => "${viewconfigpath}/${view}.conf",
  }
  $_dns_notify = $dns_notify

  concat::fragment {"dns_zones+10_${view}_${zone}.dns":
    target  => $target,
    content => template('dns/named.zone.erb'),
    order   => "${view}-11-${zone}-1",
  }

  if $view != '_GLOBAL_' {
    Dns::View[$view] -> Class['dns']
  }
}
