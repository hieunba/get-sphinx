$Docs = "C:\Docs"
$ErrorLog = "$Docs\Errors.log"

function Create-DocumentStore {
<#
.SYNOPSIS
Prepare directory structure for storing artifacts
.DESCRIPTION
Prepare directory structure for storing artifacts
.EXAMPLE
Create-DocumentStore
.PARAMETER stores
Input stores or a collection of directories, default, "PDF, Doc, HTML"
#>
param(
    [Array]$stores = @("PDF", "HTML", "Doc")
)
    foreach ($item in $stores) {
        If (-not (Test-Path "$Docs\output\$item")) {
            mkdir "$Docs\output\$item"
        }
    }
}

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

        $doc_name = $(ls | Select -ExpandProperty Parent -First 1).ToString()
        try {
           $build_dir = $pwd
           make clean singlehtml
           cd build\singlehtml
           pandoc -o "$doc_name.docx" index.html
           cd $build_dir
           make latex
           cd build\latex
           latexmk -pdfxe
           cd $build_dir
           mv "build\singlehtml\$doc_name.docx" "$Docs\output\Doc"
           If (-not (Test-Path "$Docs\output\HTML\$doc_name")) {
               mv build\singlehtml "$Docs\output\HTML\$doc_name"
           }
           cp build\latex\*.pdf "$Docs\output\PDF"
           make clean
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
        Create-DocumentStore
        Foreach ($item in $BatchList) {
             Write-Host -ForegroundColor Green "Building $item .."
             Start-Build -source "$item"
        }
    }
}

function clean_with_retries {
    $stop_try = $false
    $retry_count = 1
    $document_source = $args[0]
    $max_retries = 5
    $retry_sleep = 10
    do {
        try {
            Remove-Item -Recurse "$document_source" -ErrorVariable $err -ErrorAction Stop
            Write-Host -ForegroundColor Green "Successfully deleted the old artifacts at $document_source"
            $stop_try = $true
        }
        catch {
            if ($retry_count -gt $max_retries) {
                Write-Host -ForegroundColor Cyan "Tried $max_retries times, all failed! Check if any artifact is being used."
                $stop_try = $true
                exit 1
            } else {
                Write-Host -ForegroundColor Red "Failed to clean up $document_source - retrying after $retry_sleep seconds"
                Start-Sleep -Seconds $retry_sleep
                $retry_count = $retry_count + 1
            }
        }
    }
    while ($stop_try -eq $false)
}

# start building
If ([System.IO.File]::Exists($ErrorLog)) {
    Out-Null > $ErrorLog
}
If (Test-Path "$Docs\output" ) {
    Write-Host -ForegroundColor DarkGreen "Cleaning old artifacts.."
    Write-Host ""
    clean_with_retries "$Docs\output"
}
Start-BatchBuild -BatchList $(Get-DocumentList)
cd $Docs
