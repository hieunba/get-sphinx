unless os.linux?
  # Tests check with py laucher for version 3 only
  describe command('py -3 --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match (/Python 3.[5-9].[0-9]/) }
  end
  describe command('py -3 -m easy_install --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match (/setuptools ([0-9][0-9]).[0-9].[0-9]/) }
  end
  describe command('sphinx-build --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match (/sphinx-build 1.[0-9].[0-9]/) }
  end
  describe command('sphinx-quickstart --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match (/sphinx-quickstart 1.[0-9].[0-9]/) }
  end
end
