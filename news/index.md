# Changelog

## PANACEA (development version)

## PANACEA 1.1.0

CRAN release: 2025-12-22

### Minor Changes and Bug Fixes

- Moved `org.Hs.eg.db` from “Imports” to “Suggests” per new CRAN policy,
  [`convert2alias()`](https://egeulgen.github.io/PANACEA/reference/convert2alias.md)
  returns found genes if `org.Hs.eg.db` is not installed, raising a
  message.

## PANACEA 1.0.1

CRAN release: 2023-08-19

### Minor Changes and Bug Fixes

- Added a `NEWS.md` file to track changes to the package.
- fixed a CRAN error due to a package documentation issue
  ([\#2](https://github.com/egeulgen/PANACEA/issues/2))
