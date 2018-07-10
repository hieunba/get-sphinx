$Docs = "C:\Docs"
$ErrorLog = "$Docs\Errors.log"

function Start-Build {
param(
    [string]$source = "C:\docs"
)
    cd $source

    If (Test-Path "$source\source") { 

        try {
           make clean html
           make latex
           cd build\latex
           latexmk -pdfxe
        } Catch {
            "ERROR building for $source : $_" | Add-Content $ErrorLog
        }
    } Else {
       "No source found. Skip building for $source" | Add-Content $ErrorLog
    }
     
}

function Batch-Build {
    If (Test-Path "$Docs\source") {
        Write-Host "Found source directory in $Docs"
        Start-Build -source $Docs
    }
    Else
    {
       $BuildList = $(Get-ChildItem -Attributes Directory $Docs | Select Name -ExpandProperty Name)
       If ($BuildList.Count -eq 0) {
           tlmgr.bat --version
       } Else {
           Foreach ($i in $BuildList) {
               Start-Build -source "$Docs\$i"
           }
       }
    }
}

# start building
If ([System.IO.File]::Exists($ErrorLog)) {
    Out-Null > $ErrorLog
}
Batch-Build
cd $Docs