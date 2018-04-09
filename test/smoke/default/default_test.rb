unless os.linux?
  describe command('python.exe --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match (/Python 3.6.5/) }
  end
  describe command('easy_install --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match (/setuptools 39.[0-9].[0-9]/) }
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
