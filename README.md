# POV-Ray-test
Test based on Umbrella POV-Ray datasets https://curate.nd.edu/show/3n203x8348g

# Run the script:
```console
$ time ./run_test.sh
```
Sample output:

```console
Render Time:
  Photon Time:      No photons
  Radiosity Time:   No radiosity
  Trace Time:       0 hours  2 minutes  2 seconds (122.110 seconds)
              using 48 thread(s) with 5712.020 CPU-seconds total
POV-Ray finished

Elapsed time: 153 seconds

real    2m32.078s
user    0m1.032s
sys     0m0.260s
```

# Run tests in a loop

## Without using Docker cache
```console
$ ./run_test_multiple_no_cache.sh 1000 abousselmi/docker-alpine-povray:latest
```

## Using Docker cache
```console
$ ./run_test_multiple_use_cache.sh 1000 abousselmi/docker-alpine-povray
```

Sample output:

```console
==> loop 97 | elapsed time (s): 367
==> loop 98 | elapsed time (s): 568
==> loop 99 | elapsed time (s): 365
==> loop 100 | elapsed time (s): 634
==> number of loops: 100
==> total time: 64635 seconds
```
