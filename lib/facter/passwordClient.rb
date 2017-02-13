Facter.add('passwordClientBackup') do
  setcode do
    Facter::Core::Execution.exec('/usr/bin/facter ipaddress | sha256sum | base64 | head -c 30')
  end
end
