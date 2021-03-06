# get-sphinx CHANGELOG

This file is used to list changes made by each version of get sphinx.

## 0.7.1 (2019-01-17)

  - Use gcim to deprecate Get-WmiObject command with Powershell 6 or later (following latest Docker image from Microsoft)
  - Update PATH to make.exe with new installation from Chocolatey (compatible with old PATH)

## 0.7.0 (2018-09-24)

  - Build filenames with spaces from hats (^)

## 0.6.2 (2018-09-20)

  - Clean up old artifacts before building

## 0.6.1 (2018-08-31)

  - Support custom source while building texlive 2017 for Windows

   To set Tex Live source, please add TEXLIVE_SOURCE in build-arg while issuing ` docker build `.

## 0.6.0 (2018-08-31)

  - Dockerfile for texlive 2018 for Windows
  - Collect artifacts in output in doc source

## 0.5.0 (2018-08-10)

  - Add Pandoc converter
  - Update build sequence to generate docx as well

## 0.4.0 (2018-07-25)

  - Build single HTTML by default

## 0.3.1 (2018-07-22)

  - Add Batch Build regardless of the depth levels of directories from input source

## 0.3.0 (2018-07-11)

  - Add Batch Build with the depth level of 1

## 0.2.2 (2018-07-05)

  - Add Cloud Sphinx Theme v1.9.4

## 0.2.1 (2018-07-05)

  - Add MinGW to image to use make

## 0.2.0 (2018-07-04)

  - Add image which includes Python 3.6.5, Sphinx and Tex Live 2017

## 0.1.0 (Unkown)

  - Powershell script to install Python 3.6.5, Sphinx and MikTex
