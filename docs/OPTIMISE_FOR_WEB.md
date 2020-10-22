# Optimise web images for performance

As webpages get too heavy the script included here tries to optimise JPG images using the convert binary.

This is inspired by https://developers.google.com/speed/docs/insights/OptimizeImages and
depends on arg-parser.sh included in this repo.

## Run command

`bin/web-image-optimiser.sh`

It will find all jpg files and convert/optimise them to a compression and format that looks lossless to the
common human eye.

### Notes
- https://developers.google.com/speed/webp/docs/cwebp
- https://web.dev/uses-webp-images/?utm_source=lighthouse&utm_medium=unknown
- https://web.dev/codelab-serve-images-webp/

[Go Back](../README.md)
