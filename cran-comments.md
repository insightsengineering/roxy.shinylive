## Comments

#### 2024-11-21

Updates:
- Removed LICENSE file and its reference in the DESCRIPTION file.
- Used single quotes for package names etc.
- This package does not have any references to the academic publications hence no changes on that regard.
- Added README.md.

Please let me know if I can provide any more information.

Thank you,
Pawel

#### 2024-11-20

Thanks,

The LICENSE file is only needed if you have additional restrictions to
the license which you have not? In that case omit the file and its
reference in the DESCRIPTION file.

Please always write package names, software names and API (application
programming interface) names in single quotes in title and description.
e.g: --> 'roxygen2', ...
Please note that package names are case sensitive.

If there are references describing the methods in your package, please
add these in the description field of your DESCRIPTION file in the form
authors (year) <doi:...>
authors (year, ISBN:...)
or if those are not available: <https:...>
with no space after 'doi:', 'https:' and angle brackets for
auto-linking. (If you want to add a title as well please put it in
quotes: "Title")

Please fix and resubmit.

Best,
Benjamin Altmann

#### 2024-11-19

Initial submission.

## R CMD check results

0 errors | 0 warnings | 1 note

─  checking CRAN incoming feasibility ... [2s/15s] NOTE (15.3s)
   Maintainer: ‘Pawel Rucki <pawel.rucki@roche.com>’

   New submission
