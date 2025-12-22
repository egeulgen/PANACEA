## Test environments
* local OS X 26.2, R 4.5.2
* macOS-latest (on GitHub-Actions), R 4.5.2
* windows-latest (on GitHub-Actions), R 4.5.2
* ubuntu-latest (on GitHub-Actions), R 4.5.2
* ubuntu-latest (on GitHub-Actions), R devel
* ubuntu-latest (on GitHub-Actions), R 4.4.3
* win-builder (devel and release)

## R CMD check results
0 errors ✔ | 0 warnings ✔ | 0 notes ✔
  
  This is a minor release for 'PANACEA', fixing the CRAN errors due to strong
  dependencies on a package from Bioconductor data annotation repository. The
  package was moved to 'Suggests' and code was updated to conditionally execute
  if installed, raising an informative message if not.
  
## Downstream dependencies
There are currently no downstream dependencies for this package.
