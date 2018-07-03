
function Get-TexLive {
	<#
	.SYNOPSIS
	Install TeX Live

	.DESCRIPTION

	.EXAMPLE
	Get-TexLive

	#>

	$texlive_source = 'ftp://tug.org/historic/systems/texlive/2017/tlnet-final/install-tl.zip'
	$texlive_path = 'C:/install-tl.zip'

	(New-Object System.Net.WebClient).DownloadFile($texlive_source, $texlive_path)
}

# fun begins
Get-TexLive
Expand-Archive 'C:/install-tl.zip' -DestinationPath 'C:/'
Set-Content -Path 'C:/profile' -Value 'selected_scheme scheme-full'