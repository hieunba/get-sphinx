<#
  .SYNOPSIS
  Install Sphinx + MiKTeK

  .DESCRIPTION
  Install Sphinx based on Python 3.x and add MiKTeX to support LaTex.

  .EXAMPLE
  install.ps1

  .EXAMPLE
  install.ps1 -pythonVersion '3.6.5'

#>
param(
  [string]$pythonVersion = '3.6.5'
)


######################################
# Configuration parameters           #
######################################

$arch = $env:PROCESSOR_ARCHITECTURE.ToLower()

function Install-MikTex {
    <#
    .SYNOPSIS
    Install MikTex

    .DESCRIPTION
    Install MikTex 2.9.6643-x64. Currently supports installing from pre-built binary file.

    .EXAMPLE
    Install-MikTex

    #>
    param(
        [Boolean]
        $Source = $false,
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
        if (-Not (Test-Path $miktex_download_path))
        {
            Write-Host "Downloading MiKTeX installation binary..." -ForegroundColor Magenta
            (New-Object System.Net.WebClient).DownloadFile($miktex_amd64_setup_url, $miktex_download_path)
        }
        else
        {
            $fileHash = Get-FileHash $miktex_download_path -Algorithm SHA256
            if ($fileHash -eq $miktex_amd64_setup_checksum) {
                Write-Host "MiKTeX installation binary staged. Skip downloading." -ForegroundColor Yellow
            }
            else
            {
                Write-Host "Checksum mismatched. Redownloading MiKTeX installation binary... " -ForegroundColor Magenta
                (New-Object System.Net.WebClient).DownloadFile($miktex_amd64_setup_url, $miktex_download_path)
            }
        }
        Write-Host "Installng MikTex..." -ForegroundColor Magenta
        Start-Process $miktex_download_path -ArgumentList @('--unattended', '--auto-install=yes') -Wait
    }
    else
    {

        $deploy_setup_url = 'https://www.dropbox.com/s/aavayoshtp2kzp0/miktexsetup.amd64.exe?dl=1'
        $deploy_setup_checksum = 'da42decf97617682c5a02b84260c46bb80b9ff9cd26e365ab0c0d9619c38387c'
        $deploy_setup_path = "$env:TMP\miktex_deploy.exe"

        if ($deploy_setup_path) {
            if (-Not ((Get-FileHash $deploy_setup_path -Algorithm SHA256) -eq $deploy_setup_checksum)) {
                Write-Host "Downloading MikTex deploy utility..." -ForegroundColor Magenta
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

    .EXAMPLE
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

  $version = $pythonVersion

  $python_exe_path 	  = "$env:PROGRAMFILES\Python36\python.exe"
  $python_download_url  = "https://www.python.org/ftp/python/$version/python-$version-$arch.exe"
    $python_download_path = "$env:TMP\python-$version-$arch.exe"

  if (-Not (Test-Path $python_download_path)) {
    (New-Object System.Net.WebClient).DownloadFile($python_download_url, $python_download_path)
  }

  $products = Get-WmiObject -Class Win32_Product

  foreach ($member in $products) { if ($member.Name -like "Python $version Exe*") { $python3_installed = $true } }

  if (-Not $python3_installed) {
    Write-Host "Python was missing. Install python $version..." -ForegroundColor Magenta
    Start-Process $python_download_path -ArgumentList @('/quiet', "InstallAllUsers=1 PrependPath=1 Include_test=0") -Wait
  }
}

function Install-Sphinx {
  $easy_install_exe_path = "$env:PROGRAMFILES\Python36\Scripts\easy_install.exe"
  Start-Process $easy_install_exe_path -ArgumentList @('sphinx') -Wait
}

# Start
Install-Python
Install-Sphinx
Install-MikTex
