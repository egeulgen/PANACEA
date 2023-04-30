## Test environments
* local OS X 13.3, R 4.3.0
* macOS-latest (on GitHub-Actions), R 4.3.0
* windows-latest (on GitHub-Actions), R 4.3.0
* ubuntu-latest (on GitHub-Actions), R 4.3.0
* ubuntu-latest (on GitHub-Actions), R devel
* ubuntu-latest (on GitHub-Actions), R 4.2.3
* win-builder (devel and release)
* Rhub - `rhub::check_for_cran()`, `rhub::check(platform = 'ubuntu-rchk')`, 
  `rhub::check_with_sanitizers()`

## R CMD check results
There were no ERRORs, WARNINGs. 

There were 2 NOTEs:

❯ checking CRAN incoming feasibility ... [3s/12s] NOTE
  Maintainer: ‘Ege Ulgen <egeulgen@gmail.com>’
  
  New submission
  
❯ checking installed package size ... NOTE
    installed size is  6.7Mb
    sub-directories of 1Mb or more:
      data   6.0Mb

  This is the initial submission for 'PANACEA'. The large file in the indicated
  sub-directory is necessary for the package to work. Hence, I cannot discard it.
  
## Downstream dependencies
There are currently no downstream dependencies for this package.
