Facter.add('passwordclient') do
  setcode do
  	if File.exist? '/usr/bin/facter'
    	Facter::Core::Execution.exec('/usr/bin/facter ipaddress | sha256sum | base64 | head -c 30')
    else
    	Facter::Core::Execution.exec('/opt/puppetlabs/bin/facter ipaddress | sha256sum | base64 | head -c 30')
    end
  end
end
