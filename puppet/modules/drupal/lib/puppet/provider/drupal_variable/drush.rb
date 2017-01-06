Puppet::Type.type(:drupal_variable).provide(:drush) do
  desc "Manage Drupal variables via Drush"

  commands :drush => 'drush'

  def self.instances
    vars = []
    begin
      drush('site-alias').reject{|s| s.start_with? '@' }.collect{|s| s.chomp }.each do |site|
        Puppet.debug "Loading variables for #{site}"
        # This is SHITTY! But the json exporter is broke
        drush('variable-get', '-l', site).each do |line|
          if match = line.match(/^(\w+): (\d+|".+")$/) # These regexes just get rid of complex values.
            name  = "#{site}::#{match[1]}"
            value = match[2].gsub(/^\"|\"$/, '')
            Puppet.debug "drups: Creating #{name}:#{value}"
            vars << new(:ensure => :present, :name => name, :value => value)

            # that evil hoodoo that you do to work around the unexpected things it do
            vars << new(:ensure => :present, :name => match[1], :value => value) if site=='default'
          end
        end
      end
    rescue Puppet::ExecutionFailure => e
      Puppet.debug "Drupal variables: #{e.message}"
    end
    vars
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
    @property_hash[:ensure] == :present
  end

  def create
    begin
      value = resource[:value]
      @property_hash[:ensure] = :present
    rescue Puppet::ExecutionFailure => e
      raise Puppet::Error, "Couldn't set #{resource[:name]} to #{resource[:value]} (#{e.message})"
    end
  end

  def destroy
    begin
      drush('variable-delete', '--exact', '--yes', resource[:name])
      @property_hash[:ensure] = :absent
    rescue Puppet::ExecutionFailure => e
      raise Puppet::Error, "Couldn't delete #{resource[:name]} (#{e.message})"
    end
  end

  def value
    @property_hash[:value] || :absent
  end

  def value=(should)
    drush('variable-set', '--exact', '-l', resource[:site], resource[:name], should)
    @property_hash[:value] = should
  end

end
