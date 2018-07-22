$Docs = "C:\Docs"
$ErrorLog = "$Docs\Errors.log"

function Get-DocumentList {
<#
.SYNOPSIS
List document sources can be compiled
.DESCRIPTION
Find all source directories inside the given source and return a list that can be built
.EXAMPLE
Get-DocumentList -source C:\Docs
.PARAMETER source
INput source directory where to find document sources
#>
param(
    [string]$source = "C:\Docs"
)
    If (Test-Path $source) {
         $(ls -Filter source -Attributes Directory -Recurse $source | Select FullName -ExpandProperty FullName) 
    } Else {
         @()
    }
}

function Start-Build {
<#
.SYNOPSIS
Generate HTML and PDF from sphinx source
.DESCRIPTION
Generate HTML and PDF from sphinx source
.EXAMPLE
Start-Build -source C:\Docs
.PARAMETER source
Document source to build
#>
param(
    [string]$source = "C:\Docs"
)
    If (Test-Path $source\..\Makefile) {
        cd $source\..
    } Else {
        cd $source
    }

    If (Test-Path $pwd\source) { 

        try {
           make clean html
           make latex
           cd build\latex
           latexmk -pdfxe
        } Catch {
            Write-Host -ForeGroundColor Red "ERROR building for $source : $_"
        }
    } Else {
       Write-Host -ForeGroundColor DarkYellow "No a valid source. Skipping building for $source"
    }
     
}

function Start-BatchBuild {
<#
.SYNOPSIS
Generate HTML and PDF for a list
.DESCRIPTION
Generate HTML and PDF for a list. This list contains document sources path.
.EXAMPLE
Start-BatchBuild -BatchList "C:\Docs\sphinxsource"
.PARAMETER BatchList
List of document source path to build. By default, it is empty.
#>
param(
    [Array]$BatchList = @()
)
    
    If ($BatchList.Count -eq 0) {
        Write-Host -ForeGround DarkYellow "Document list was empty."
        Write-Host -ForegroundColor DarkMagenta "Please checking the document source."
    } 
    Else
    {
        Foreach ($item in $BatchList) {
             Write-Host -ForegroundColor Green "Building $item .." 
             Start-Build -source "$item"
        }
    }
}

# start building
If ([System.IO.File]::Exists($ErrorLog)) {
    Out-Null > $ErrorLog
}
Start-BatchBuild -BatchList $(Get-DocumentList)
cd $Docs