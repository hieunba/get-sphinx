# Sphinx with Tex Live-2018 with Python 3.6.x

This image contains [Sphinx](http://www.sphinx-doc.org/en/master/index.html), [Python](https://www.python.org/) 3.6.x and [Tex Live](http://www.tug.org/texlive/) to help building PDF from [reStructedText](http://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html).

## Requirements

- [docker](https://docker.com)

This image should work with:

- Windows 10
- Windows Server 2016
- Linux (see How to get it section)

Please check *_Install Docker for Windows_* section for how to get Docker running.

## Quickstart

To build your documents:

```
docker run --rm -it -v C:/path/to/reStructedText:C:/docs hieunghiemba/texlive-2018-windows
```

All sub-directories in the source which contains the appropriate contents will be built.
You can find PDF file _'build/latex'_ of each built directory.

To have more details information, please check *_How to compile documents_* section.

## Documentation

- [Install Docker for Windows](https://docs.docker.com/docker-for-windows/install/)
- [Build from source](https://github.com/hieunba/get-sphinx/wiki/Build-from-source)
- [How to compile documents](https://github.com/hieunba/get-sphinx/wiki/How-to-compile)

## Note

The Windows image was built natively by Windows platform then it's quite big but you do not have to touch your system like installing libraries, or dependencies, etc.
