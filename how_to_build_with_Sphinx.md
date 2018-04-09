# How to build with Sphinx

## Install sphinx

Assuming you are using Powershell, please do the following steps:

1) Open Powershell with Administrative rights

2) Issue the following command

`   iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/hieunba/get-sphinx/master/scripts/install.ps1'))   `

## Clone or download your Sphinx documents source

Download your Sphinx documents and save somewhere. For example, I download a sample document at https://hieunghiemba@bitbucket.org/ykil/documents.git and save to My Documents.

1) Open Powershell or Command Prompt

2) Change directory to Sphinx source

`   cd $env:PROFILE\Documents   `

3) Choose a source

We have several sources in downloaded documents, assuming _TechNote-HCP_ByonicByologic_Jan2018_ is used.

`   cd TechNote-HCP_ByonicByologic_Jan2018   `

4) Build with sphinx

`   sphinx-build.exe source html`

```
Running Sphinx v1.7.2
making output directory...
loading pickled environment... not yet created
building [mo]: targets for 0 po files that are out of date
building [html]: targets for 3 source files that are out of date
updating environment: 3 added, 0 changed, 0 removed
reading sources... [100%] special
looking for now-outdated files... none found
pickling environment... done
checking consistency... done
preparing documents... done
writing output... [100%] special
generating indices... genindex
writing additional pages... search
copying images... [100%] files_static/images/HCP_Analysis_image19.png
copying static files... done
copying extra files... done
dumping search index in English (code: en) ... done
dumping object inventory... done
build succeeded.

The HTML pages are in html.
```
5) If output says build succeeded, then everything is fine.

You will find a directory named 'html' with your document.

Have fun!
