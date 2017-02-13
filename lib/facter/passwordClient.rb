Facter.add('passwordClientBackup') do
  setcode do
    Facter::Core::Execution.exec('/usr/bin/facter ipaddress ')
  end
end
