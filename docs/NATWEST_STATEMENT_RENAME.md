# Bank Statement rename

## Requirements
- bash
- pdftotext 

## Description

This script currently works with Natwest bank account statements only, do not use it on other files. Any other type of 
statements or files from other banks might have a different format and the script might produce undesired results.

Natwest, just like many other banks, allow the download of bank statements in PDF format. However, their developers are 
lazy enough not to give any decent naming to the PDF files when you download it.
For instance, your current account statement of account 12345678 from Feb to March 2023 currently is downloaded with the
name following the convention of a [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) number given to 
this report when such report/PDF is downloaded. This is a computer friendly format but tells you nothing so it is 
impossible to know what each report contains.

This script uses pdftotxt to then find out the period of the statement and use the period end date. By default the name
is prefixed with `statement_` so a statement for period ending 04 April 2023 would be named as `statement_20230404.pdf`.
The script can also be given an argument, `file-prefix` , and it will use this instead of `statement_`.

To run this script you can `git clone` the repository, then cd to the folder where statements are and run

`PATHTO-bash-essentials/bin/natwest-statement-rename.sh`
or
`PATHTO-bash-essentials/bin/natwest-statement-rename.sh file-prefix="current-account_12345678_`
if you want to give a different file prefix.

# DISCLAIMER
Notice, this script is shared and provided with no guarantees. You are free to use is as per license but any undesired 
results are out of our control. It is your responsibility to ensure that the script works for you so do not use it with
real data unless you have a back-up or a disaster recovery solution after using the script.
Also notice that any trademarks mentioned are of the respective companies and used here only as a reference to the 
proprietor with no claim of ownership or licensing.

[Go Back](../README.md)
