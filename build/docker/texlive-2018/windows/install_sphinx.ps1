<#
  .SYNOPSIS
  Install Sphinx

  .DESCRIPTION
  Install Sphinx based on Python 3.6.x.

  .EXAMPLE
  install_sphinx.ps1

  .EXAMPLE
  install_sphinx.ps1 -pythonVersion '3.6.5'

#>
param(
  [string]$pythonVersion = '3.6.5'
)


######################################
# Configuration parameters           #
######################################

$arch = $env:PROCESSOR_ARCHITECTURE.ToLower()

function Find-Python {
  # Check if Python 3.x installed or not

  # Select the correct command to work with WmiObject
  # because Get-WmiObject has been deprecated in Powershell Core.

  $currentVersion = if ($PSVersionTable.PSVersion.Major -lt 6) {
    (gwmi -Class Win32_Product | Where { $_.Name -match 'Python.*Executables' }).Version
  } else {
    (gcim -Class Win32_Product | Where { $_.Name -match 'Python.*Executables' }).Version
  }

  if ($currentVersion -match $pythonVersion.SubString(0,1)) {
    return $true;
  } elseif ($currentVersion -match $pythonVersion) {
    return $true;
  } else {
    return $false;
  }
}

function Install-Python {

  $version = $pythonVersion

  $python_exe_path 	  = "$env:PROGRAMFILES\Python36\python.exe"
  $python_download_url  = "https://www.python.org/ftp/python/$version/python-$version-$arch.exe"
  $python_download_path = "$env:TMP\python-$version-$arch.exe"

  if (-Not (Test-Path $python_download_path)) {
    (New-Object System.Net.WebClient).DownloadFile($python_download_url, $python_download_path)
  }

  if (-Not $(Find-Python)) {
    Write-Host "Python was missing. Install python $version..." -ForegroundColor Magenta
    Start-Process $python_download_path -ArgumentList @('/quiet', "InstallAllUsers=1 PrependPath=1 Include_test=0") -Wait
  }
}

function Install-Sphinx {
  $easy_install_exe_path = "$env:PROGRAMFILES\Python36\Scripts\easy_install.exe"
  Start-Process py -ArgumentList @('-3', '-m pip', 'install sphinx') -Wait
}

# Start
# Need to work with TLSv1.2 also
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12;
Install-Python
Install-Sphinx
