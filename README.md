# Overview

Simple commandline client written in Ruby for the http://convertible.io/
online file conversion platform. See the website for more info.

# Basic usage

Usage: convertible [options] [file1 [file2]]

Convert file1 to file2.

# Converting files

Without any file arguments data will be read from STDIN and written to STDOUT.
If only one filename (file1) is present, data will be read from STDIN and the result will
be written to file1. Use the -c switch to invert this behaviour so data is
read from file1 and written to STDOUT.

By default, input and output formats will be guessed from any filenames given. Use -i and -o
options to override. When using STDIN and/or STDOUT you have to use one or both of these options
to specify the format of the data. To specify a file format, use the well known file name postfix
(i.e. pdf for PDF documents) or the official mime type string like application/pdf.

convert pdf to plain text:
convertible document.pdf document.txt

convert pdf to plain text reading from STDIN:
convertible -i pdf document.txt < document.pdf

convert pdf to plain text writing to STDOUT:
convertible -c -o txt document.pdf > document.txt

convert pdf to plain text using both STDIN/STDOUT:
convertible -i pdf -o txt < document.pdf > document.txt


# Querying supported conversions

To query supported conversions or to check wether a given conversion is possible, use the 
-s switch together with a given input filename or format (-i) and an optional output filename / format:

show all supported conversions:
convertible -s

show supported output formats for OpenOffice text:
convertible -s -i odt

check wether doc can be converted to pdf:
convertible -s -i doc -o pdf

