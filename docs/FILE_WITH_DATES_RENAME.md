# Rename Files with Specific Dates

Quite often online systems spit out files with naming formatting that you might not like. For instance bank statements 
as well as credit cards sometimes to come out as `statement_DD-MM-YYYY.pdf` . This format does not help when ordering 
files by name and instead I prefer to use `statement_YYYYMMDD` as this will guarantee that when ordering by name also 
the files will be ordered by date depending on their name.

## Dry run
Run script without applying the rename changes, to preview the changes before applying them
```
bin/file-with-dates-rename.sh file-prefix=Credit
```
The above will get files such as `Credit_DD-MM-YYYY.pdf` and move/rename it to `Credit_YYYYMMDD.pdf`

## Apply changes

Once happy with dry runs you can apply changes with the `rename` parameter.

```
bin/file-with-dates-rename.sh file-prefix=Credit rename=1
```

[Go Back](../README.md)
