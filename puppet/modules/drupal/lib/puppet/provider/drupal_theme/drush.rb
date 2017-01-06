Puppet::Type.type(:drupal_theme).provide(:drush) do
  desc "Manage Drupal themes via Drush"

  commands :drush => 'drush'

  def self.instances
    mods = []
    begin
      drush('site-alias').reject{|s| s.start_with? '@' }.collect{|s| s.chomp }.each do |site|
        Puppet.debug "Loading themes for #{site}"
        drush('pm-list', '-l', site).each do |line|
          if match = line.match(/(\S+) +(.+) +\((.+)\) +Theme +(Enabled|Disabled|Not installed) +(\S+)/)
            mods << new(:ensure  => match[4].downcase.to_sym,
                        :package => match[1],
                        :label   => match[2],
                        :name    => "#{site}::#{match[3]}",
                        :version => match[5])

            # that evil hoodoo that you do to work around the unexpected things it do
            mods << new(:ensure  => match[4].downcase.to_sym,
                        :package => match[1],
                        :label   => match[2],
                        :name    => match[3],
                        :version => match[5]) if site=='default'
          end
        end
      end
    rescue Puppet::ExecutionFailure => e
      Puppet.debug "Drupal themes: #{e.message}"
    end
    mods
  end

  def self.prefetch(resources)
    vars = instances
    resources.each do |name, res|
      if provider = vars.find{ |v| v.name == res.title }
        res.provider = provider
      end
    end
  end

  def exists?
    [:present, :enabled].include? @property_hash[:ensure]
  end

  def create
    if drush('pm-info', resource[:name], '-l', resource[:site]).include? 'was not found'
      if resource[:version]
        drush('pm-download', "#{resource[:name]}-#{resource[:version]}", '-l', resource[:site], '--yes')
      else
        drush('pm-download', resource[:name], '-l', resource[:site], '--yes')
      end
    end

    drush('pm-enable', resource[:name], '-l', resource[:site], '--yes')
    @property_hash[:ensure] = :present
  end

  def destroy
    drush('pm-disable', resource[:name], '-l', resource[:site], '--yes')
    @property_hash[:ensure] = :disabled
  end

  def uninstall
    drush('pm-disable', resource[:name], '-l', resource[:site], '--yes') if @property_hash[:ensure] != :disabled
    drush('pm-uninstall', resource[:name], '-l', resource[:site], '--yes')
    @property_hash[:ensure] = :uninstalled
  end

  def version
    @property_hash[:version]
  end

  def version=(should)
    drush('pm-download', "#{resource[:name]}-#{should}", '-l', resource[:site], '--yes')
    drush('pm-enable', resource[:name], '-l', resource[:site], '--yes')
    @property_hash[:version] = should
  end

  [:package, :label].each do |prop|
    define_method(prop) { @property_hash[prop] }
    define_method("#{prop}=") do |v|
      fail "#{prop} is read only."
    end
  end

end
