# PANACEA: Personalized Network-based Anti-Cancer Therapy Evaluation

Identification of the most appropriate pharmacotherapy for each patient
based on genomic alterations is a major challenge in personalized
oncology. `PANACEA` is a collection of personalized anti-cancer drug
prioritization approaches utilizing network methods. The methods utilize
personalized "driverness" scores from 'driveR' to rank drugs, mapping
these onto a protein-protein interaction network (PIN). The
"distance-based" method scores each drug based on these scores and
distances between drugs and genes to rank given drugs. The "RWR" method
propagates these scores via a random-walk with restart framework to rank
the drugs.

## See also

[`score_drugs`](https://egeulgen.github.io/PANACEA/reference/score_drugs.md)
for the wrapper function for scoring of drugs via network-based methods

## Author

**Maintainer**: Ege Ulgen <egeulgen@gmail.com>
([ORCID](https://orcid.org/0000-0003-2090-3621)) \[copyright holder\]
