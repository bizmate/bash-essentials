# Environment Variables replace

Replaces template file placeholders with values from environment variables.

## Parameters

* file - compulsary relative path to file
* debug - if set the script will echo some debugging information

## Templates

These should contain placeholders wrapped by percentage character.

For instance

```
This is a text with a %placeholder%
```
If an environment variable named `placeholder` exists then its value will be replaced in the text.

### Example

```
bin/bash-docker.sh /mnt/bin/env-replace.sh file=fixtures/sample-test-file.yaml
```

[Go Back](../README.md)
