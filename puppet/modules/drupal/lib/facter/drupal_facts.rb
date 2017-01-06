facts = {
  'drupal_root'          => 'Drupal root',
  'drupal_bootstrap'     => 'Drupal bootstrap',
  'drupal_db_driver'     => 'Database driver',
  'drupal_db_hostname'   => 'Database hostname',
  'drupal_db_username'   => 'Database username',
  'drupal_db_name'       => 'Database name',
  'drupal_drush_version' => 'Drush version',
}
status = {}

begin
  Facter::Util::Resolution.exec("drush core-status 2>/dev/null").each do |line|
    key, val = line.split(':') if line
    status[key.strip] = val.strip
  end

  facts.each do |fact, name|
    Facter.add(fact) do
      setcode do
        status[name]
      end
    end
  end
rescue Exception => e
end
