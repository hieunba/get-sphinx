# Sphinx with Tex Live-2017 with Python 3.6.x

This image contains [Sphinx](http://www.sphinx-doc.org/en/master/index.html), [Python](https://www.python.org/) 3.6.x and [Tex Live-2017](http://www.tug.org/texlive/) to help building PDF from [reStructedText](http://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html).

## Requirements

- [docker](https://docker.com)

This image should work with:

- Windows 10
- Windows Server 2016
- Linux (see How to get it section)

You can follow this guide [Docker installation](https://docs.docker.com/docker-for-windows/install/) to help to install docker on Windows.

## How to get it?

From Windows Powershell, pull the image with:

```sh
docker pull hieunghiemba/texlive-2017-windows
```

Or from terminal in Linux, pull the following image with:

```sh
docker pull hieunghiemba/texlive-2017
```

## How to run this?

This short guide shows how to use the image on Windows. Linux should be the same.

After pulling, we can start to compile documents.

Assuming the documents are in _'C:/Users/user/Documents/reStructedText'_, we mount it to new container from pulled image like this:

```
docker run --rm -it -v C:/Users/user/Documents/reStructedText:C:/docs hieunghiemba/texlive-2017-windows powershell
```

You must have access to the Powershell with the working directory is 'C:/docs' which your documents mounted and stored.

To make the PDF file, please do the following steps:

```
./make.bat latex
```
```
cd build/latex
```
```
latexmk.exe -pdfxe
```

After compiling done, you will get your PDF file in 'build/latex' directory.

## Note

The Windows image was built natively by Windows platform then it's quite big but you do not have to touch your system like installing libraries, or dependencies, etc.
