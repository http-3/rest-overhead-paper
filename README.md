# Rest Overhead Paper
## Contents
Here you will find:
- The results of the Benchmarks conducted on [Mistral](https://www.dkrz.de/up/systems/mistral) and WR Cluster, published in our paper :
[Investigating the Overhead of the REST Protocol when Using Cloud Services for HPC Storage](https://hps.vi4io.org)
- The scripts needed to reproduce the Benchmarks in a HPC Cluster, to note here that the REST benchmark can also be used outside an HPC environment.

### Benchmarks
#### Prerequisites
The following tools and applications should be installed and properly configured to be able to reproduce the tests. Of course, hardware requirements like Infiniband are a must to accomplish some benchmarks.
- lighttp
- wrk and wrk2
- likwid
- h2load
- openlitespeed

#### Measurements
- The latency and throuthput tests, described in section 4.3 and 4.4, can be launched using the wrk2-bench.sh script on the client side , the server is supposed to be running on the same or on another node. Sample results can be found in ./results/WR/wrk2results, they can be plotted using the plotwrk2.sh script.
- The tests in section 4.5 can be reproduced using the launcher-likbench.sh script ; this is a [Slurm](https://slurm.schedmd.com/overview.html) Batch script that will allocate 2 nodes and start the benchmark on them, if the slurm workload manager is not available, it is possible to use the likbench.sh directly. Sample results can be found in ./results/WR/likbenchsswrkresults-west3-1-1-20190414-233540. The exporttodblikbench.sh is used to export the obtained results to a SQLite Database for analysis and plotting.
- To launch the REST Benchmark found in section 4.6 ,the launcher-likbenchosu.sh script is used. Sample results can be found in ./results/Mistral/likbenchresults and the SQLite export script exporttodblikbench.sh can be used here.
- The MPI benchmark defined in section 4.6 can be started using the launcher-OSU-lik.openmpi script, the use of TCP or RDMA is controlled by setting the corresponding BTL (byte transfer layer) parameter in the script.
- The tests found in section 5.1 can be reproduced using launcher-openlite-h2load.sh, the results can be exported to SQLite using exporttodblik-h2load-bench.sh.

#### Analysis
The SQLite databases are imported into Excel and used to plot the different diagrams and to validate the performance model