[![GitHub Actions CI Status](https://github.com/mskcc/rediscoverte/actions/workflows/ci.yml/badge.svg)](https://github.com/msk/rediscoverte/actions/workflows/ci.yml)
[![GitHub Actions Linting Status](https://github.com/mskcc/rediscoverte/actions/workflows/linting.yml/badge.svg)](https://github.com/msk/rediscoverte/actions/workflows/linting.yml)[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX)
[![nf-test](https://img.shields.io/badge/unit_tests-nf--test-337ab7.svg)](https://www.nf-test.com)

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A523.04.0-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Seqera Platform](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Seqera%20Platform-%234256e7)](https://cloud.seqera.io/launch?pipeline=https://github.com/mskcc/rediscoverte)

## Introduction

**msk/rediscoverte** is a bioinformatics pipeline that quantifies genome-wide TE expression in RNA sequencing data. This is the nextflow pipeline for REdiscoverTE found here: https://github.com/ucsffrancislab/REdiscoverTE

1. Index transcriptome ([`Salmon Index`](https://combine-lab.github.io/salmon/getting_started/#indexing-txome))
2. Quantify reads ([`Salmon Quant`](https://combine-lab.github.io/salmon/getting_started/#quantifying-samples))
3. Run REdiscoverTE ([`REdiscoverTE`](https://github.com/ucsffrancislab/REdiscoverTE))

## Usage

> [!NOTE]
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how to set-up Nextflow. Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline) with `-profile test` before running the workflow on actual data.

#### Running nextflow @ MSKCC

If you are runnning this pipeline on a MSKCC cluster you need to make sure nextflow is properly configured for the HPC envirornment:

```bash
module load java/jdk-17.0.8
module load singularity/3.7.1
export PATH=$PATH:/path/to/nextflow/binary
export SINGULARITY_TMPDIR=/path/to/network/storage/for/singularity/tmp/files
export NXF_SINGULARITY_CACHEDIR=/path/to/network/storage/for/singularity/cache
```

### Running the pipeline

First, prepare a samplesheet with your input data that looks as follows:

`samplesheet.csv`:

```csv
sample,fastq
SAMPLE_SINGLE_END,input_R1.fq.gz
```

Each row represents a fastq file (single-end) or a pair of fastq files (paired end).

Now, you can run the pipeline using:

```bash
nextflow run main.nf \
   -profile singularity,juno \
   --input samplesheet.csv \
   --outdir <OUTDIR>
```

> [!WARNING]
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option. Custom config files including those provided by the `-c` Nextflow option can be used to provide any configuration _**except for parameters**_;
> see [docs](https://nf-co.re/usage/configuration#custom-configuration-files).

## Credits

msk/rediscoverte was originally written by [nikhil](https://github.com/nikhil).

We thank the following people for their extensive assistance in the development of this pipeline:

<!-- TODO nf-core: If applicable, make list of people who have also contributed -->

## Contributions and Support

If you would like to contribute to this pipeline, please see the [contributing guidelines](.github/CONTRIBUTING.md).

## Citations

> Kong, Y., Rose, C.M., Cass, A.A. et al. Transposable element expression in tumors is associated with immune infiltration and increased antigenicity. Nat Commun 10, 5228 (2019). https://doi.org/10.1038/s41467-019-13035-2

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

This pipeline uses code and infrastructure developed and maintained by the [nf-core](https://nf-co.re) community, reused here under the [MIT license](https://github.com/nf-core/tools/blob/master/LICENSE).

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).
