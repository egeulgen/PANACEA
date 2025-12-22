# Network Propagation (Random-walk with Restart)

Network Propagation (Random-walk with Restart)

## Usage

``` r
network_propagation(prior_vec, W_prime, alpha, max.iter = 1000, eps = 1e-04)
```

## Arguments

- prior_vec:

  vector of prior knowledge on selected genes (names are gene symbols)

- W_prime:

  (Laplacian-normalized, symmetric) adjacency matrix

- alpha:

  restart parameter, controlling trade-off between prior information and
  network smoothing

- max.iter:

  maximum allowed number of iterations (default = 1000)

- eps:

  epsilon value to assess the L2 norm of the difference between
  iterations (default = 1e-4)

## Value

vector of propagation values

## Details

Implementing RWR following the following publications: Cowen L, Ideker
T, Raphael BJ, Sharan R. Network propagation: a universal amplifier of
genetic associations. Nat Rev Genet. 2017 Sep;18(9):551–62. Shnaps O,
Perry E, Silverbush D, Sharan R. Inference of personalized drug targets
via network propagation. Pac Symp Biocomput. 2016;21:156–67.
