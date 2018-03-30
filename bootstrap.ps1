####################
Set-ExecutionPolicy Unrestricted

 ######################################
 # Configuration parameters           #
 ######################################

 ######################################
 # Notes                              #
 ######################################
 # ez_setup.py used to install easy_install which is hosted at https://bootstrap.pypa.io/ez_setup.py
 # Due to the implementation of TLS v1.2, then need to upload to Dropbox
 $arch = $env:PROCESSOR_ARCHITECTURE.ToLower()
 $py27_dir = "C:\Python27"
 $py27_exe_path = "$py27_dir\python.exe"
 $easy_install_exe_path = "$py27_dir\Scripts\easy_install.exe"
 $default_download_path = $env:TMP

function Install-MikTex {
    <#
    .SYNOPSIS
    Install MikTex

    .DESCRIPTION
    Install MikTex 2.9.6643-x64. Currently supports installing from pre-built binary file.

    .EXAMPLE
    Install-MikTex

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [Boolean]
        $Source = $false,
        [Parameter(Mandatory=$false)]
        [String]
        $Repository = "$env:TMP\miktex"
    )
    $miktex_reg_path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MikTex 2.9'
    if (Test-RegistryKeyValue -Path $miktex_reg_path -Name 'MikTex 2.9') {
        Write-Host "MikTex 2.9 installed." -ForegroundColor Magenta
        return $true
    }

    if (-Not $Source) {
        $miktex_amd64_setup_url = 'https://www.dropbox.com/s/vj2g3c4hih8gabb/basic-miktex-2.9.6643-x64.exe?dl=1'
        $miktex_amd64_setup_checksum = '792983b8945ddafc5285cb9942d9d88550ef3af0f8d4add9acd057233ff84584'
        $miktex_download_path = "$env:TMP\basic-miktex-setup.exe" 

        if ($arch -eq 'amd64') {
            $fileHash = Get-FileHash $miktex_download_path -Algorithm SHA256
            if ($fileHash -eq $miktex_amd64_setup_checksum) {
                Write-Host "MixTek installation binary staged. Skip downloading." -ForegroundColor Yellow
            } else 
            {
                (New-Object System.Net.WebClient).DownloadFile($miktex_amd64_setup_url, $miktex_download_path)
            }
            Write-Host "Installng MikTex.." -ForegroundColor Magenta
            Start-Process $miktex_download_path -ArgumentList @('--unattended', '--auto-install=yes') -Wait
        }
        else 
        {
            Write-Host "MikTex does not support $env:PROCESSOR_ARCHITECTURE platform." -ForegroundColor Yellow
        }
    }
    else 
    {
  
        $deploy_setup_url = 'https://www.dropbox.com/s/aavayoshtp2kzp0/miktexsetup.amd64.exe?dl=1'
        $deploy_setup_checksum = 'da42decf97617682c5a02b84260c46bb80b9ff9cd26e365ab0c0d9619c38387c'
        $deploy_setup_path = "$env:TMP\miktex_deploy.exe"
 
        if ($deploy_setup_path) {
            if (-Not ((Get-FileHash $deploy_setup_path -Algorithm SHA256) -eq $deploy_setup_checksum)) {
                Write-Host "Downloading MikTex deploy utility.." -ForegroundColor Magenta
                (New-Object System.Net.WebClient).DownloadFile($deploy_setup_url, $deploy_setup_path)
            }
            else
            {
                Write-Host "MikTek deploy utility staged. Skipped downloading."
            }
        }    
      
        Write-Host "Preparing MikTek local repository at $Repository" -ForeGroundColor Magenta
        Start-Process $deploy_setup_path -ArgumentList @('--verbose', "--local-package-repository=$Repository --package-set=complete download") -Wait
        Write-Host "Installing MikTek from local repository..." -ForeGroundColor Magenta
        Start-Process $deploy_setup_path -ArgumentList @('--quiet', "--local-package-repository=$Repository --package-set=basic install") -Wait
  
    }
}

function Test-RegistryKeyValue
{
    <#
    .SYNOPSIS
    Tests if a registry value exists or a product has installed which has a registry value exists in Uninstall.

    .DESCRIPTION
    The usual ways for checking if a registry value exists don't handle when a value simply has an empty or null value.  This function actually checks if a key has a value with a given name.

    .EXAMPLE
    Test-RegistryKeyValue -Path 'hklm:\Software\Carbon\Test' -Name 'Title'

    Returns `True` if `hklm:\Software\Carbon\Test` contains a value named 'Title'.  `False` otherwise.

    Test-RegistryKeyValue -Path `hklm:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Milk` -Name `Milk`

    Returns `True` if `hklm:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Milk` or 
    if it contains `DisplayName` has a value of 'Milk'. `False` otherwise.

    .DERIVE
    This was referred to the work of Aaron Jensen on stackoverflow, or at 
    https://stackoverflow.com/questions/5648931/test-if-registry-value-exists#5652674
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        # The path to the registry key where the value should be set.  Will be created if it doesn't exist.
        $Path,

        [Parameter(Mandatory=$true)]
        [string]
        # The name of the value being set.
        $Name
    )

    if( -not (Test-Path -Path $Path -PathType Container) )
    {
        return $false
    }

    $properties = Get-ItemProperty -Path $Path 
    if( -not $properties )
    {
        return $false
    }

    if ($properties.DisplayName -eq $Name)
    {
        return $true
    }

    $member = Get-Member -InputObject $properties -Name $Name
    if( $member )
    {
        return $true
    }
    else
    {
        return $false
    }

}

function Install-Python {
  <#
  .SYNOPSIS
  Install Python for Windows and install easy_install

  .DESCRIPTION
  By default, installing Pyhon 2.7.14 if no version was specified

  .EXAMPLE
  Install-Python

  #>

  [CmdletBinding()]
  param(
      [Parameter(Mandatory=$false)]
      [string]
      $version = "2.7.14"
  )

  $python_exe_path      = "C:\Python27\python.exe"
  $python_download_url  = "https://www.python.org/ftp/python/$version/python-$version.$arch.msi"
  $python_download_path = "$env:TMP\python-$version.$arch.msi"

  if (-Not (Test-Path $python_download_path)) {
    (New-Object System.Net.WebClient).DownloadFile($python_download_url, $python_download_path)
  }
 
  Get-Python-Setup-Files

  foreach ($member in (Get-WmiObject -Class Win32_Product)) { if ($member.Name -like '*Python*') { $python_installed = $true } }

  if (-Not $python_installed) {
    Start-Process msiexec.exe -ArgumentLIst @('/q', "/i $python_download_path") -Wait
  }
  if (-Not (Test-Path $easy_install_exe_path)) {
    Start-Process python.exe -ArgumentList @("$Location\ez_setup.py") -Wait
  }
}

function Install-Sphinx {
  if (-Not (Test-Path $py27_exe_path)) {
    Write-Host "Python was missing. Installing it.." -ForegroundColor Magenta
    Install-Python
  }
  # Environment is not populated at this session
  if (Test-Path $easy_install_exe_path) {
    Start-Process $easy_install_exe_path -ArgumentList @('sphinx') -Wait
  } 
  else 
  {
    Write-Host "easy_install was not found. Please install it first." -ForegroundColor Red
  }
}

function Get-Python-Setup-Files {
    <#
    .SYNOPSIS
    Get Python setup files

    .DESCRIPTION
    Python setup files include ez_setup.py and get-pip.py. They are fetched from Internet and stores to TMP dir

    .EXAMPLE
    Get-Python-Setup-Files
    #>
    $easy_setup_url = "https://www.dropbox.com/s/14vztnkqf4ayhp3/ez_setup.py?dl=1"
    $get_pip_url = "https://raw.github.com/pypa/pip/master/contrib/get-pip.py"

    (New-Object System.Net.WebClient).DownloadFile($easy_setup_url, "$default_download_path\ez_setup.py")
    (New-Object System.Net.WebClient).DownloadFile($get_pip_url, "$default_download_path\get-pip.py")
    
    # If IE engine is available, can use Invoke-WebRequest to fetch file
    # but to be safe, using .Net framework one.
    #    Invoke-WebRequest -Uri $ez_setup_url -OutFile "distribute_setup.py"
}

# Prepare
if (-Not ([Environment]::GetEnvironmentVariable("Path") | Select-String Python27)) {
  [Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\Python27;C:\Python27\Scripts\", "Machine")
}


# Start
Install-Python
Install-Sphinx
Install-MikTex