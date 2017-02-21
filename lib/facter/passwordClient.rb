Facter.add('passwordclient') do
  setcode do
    Facter::Core::Execution.exec('facter ipaddress | sha256sum | base64 | head -c 30')
  end
end
