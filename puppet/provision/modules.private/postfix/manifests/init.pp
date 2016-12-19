class postfix(
  $master_cf_source,
  $main_cf_source,
) {

  anchor { '::postfix::begin': }
    -> class { '::postfix::install': }
    -> class { '::postfix::config': }
    ~> class { '::postfix::service': }
    -> anchor { '::postfix::end': }

}
