# TORMES
An automated pipeline for whole bacterial genome analysis directly from raw Illumina sequencing data.  
(*repository under development*)

## Contents  
  * [What is TORMES?](#what-is-tormes)
  * [Installation](#installation)
      * [Required dependencies](#required-dependencies)
  * [Usage](#usage)
      * [Obligatory options](#obligatory-options)  
  * [Output](#output)
  * [Customizing the summary-report](#custom-report)
  * [License](#license)
  * [Citation](#citation)

<br>

## What is TORMES?

TORMES is an open-source, user-friendly pipeline for whole bacterial genome sequencing (WGS) analysis directly from raw Illumina paired-end sequence data. TORMES does not have a limited numbers of samples to work and by following simple instructions, TORMES automates all steps included in a typical WGS analysis, including:  

1) Sequence quality filtering
2) *De novo* genome assembly
3) Draft genome ordering against a reference
4) Genome annotation
5) Multi-Locus Sequence Typing (MLST)
6) Antibiotic resistance genes screening
7) Virulence genes screening
8) Pangenome comparison

When working with *Escherichia* or *Salmonella* sequence data, extensive analysis can be enabled (by using the `-g/--genera`option), including:

9) Antibiotic resistance screening based on point mutations
10) Plasmid replicons screening
11) Serotyping
12) fimH-Typing (only for *Escherichia*)

Once the analysis is finished, TORMES generates an interactive web-like report that can be opened in a web browser and shared and revised by researchers in a simple manner.


<br>

## Installation

Download and install TORMES from the latest release from the GitHub reporsitory:  
```
git clone --recursive https://github.com/nmquijada/tormes.git

./tormes/install.sh
```

Three folders will be found:

  * **bin**: includes the **tormes** (whole pipeline) and **tormes-report** (generates the interactive web-like report) pipelines.
  * **files**: 
      * adapters.fa: sequencing adaptors (will be used by Trimmomatic to remove them from the sequencing data)
      * config_file.txt: tab separated file withe the locations of the third-party tools used by tormes.
      * resfinder_notes.txt: tab separated file containing antibiotic resistance genes of the Resfinder database and antibiotic family they confer resistance to. It will be used by tormes-report for creating a figure for the interactive web-like report.
  * **example-data**: all data used in TORMES' publication.  
  
<br>

### Required dependencies
TORMES is a pipeline and it requires several dependencies to work:  
  * [ABRicate](https://github.com/tseemann/abricate)
  * [FastTree](http://meta.microbesonline.org/fasttree/)
  * [GNUParallel](https://www.gnu.org/software/parallel/)
  * [Kraken](https://ccb.jhu.edu/software/kraken/)
  * [mlst](https://github.com/tseemann/mlst)
  * [Prinseq](http://prinseq.sourceforge.net/)
  * [progrressiveMauve](http://darlinglab.org/mauve/mauve.html)
  * [Prokka](https://github.com/tseemann/prokka)
  * [Quast](http://quast.sourceforge.net/quast)
  * [Roary](https://sanger-pathogens.github.io/Roary/)
  * [roary2svg.pl](https://github.com/sanger-pathogens/Roary/blob/master/contrib/roary2svg/roary2svg.pl)
  * [SPAdes](http://cab.spbu.ru/software/spades/)
  * [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)
  * [R](https://cran.r-project.org/)
  
Additional software when working with `-g/--genera Escherichia`.
  * [FimTyper](https://bitbucket.org/genomicepidemiology/fimtyper/overview)
  * [SerotypeFinder](https://bitbucket.org/genomicepidemiology/serotypefinder)
  
Additional software when working with `-g/--genera Salmonella`.
  * [SISTR](https://lfz.corefacility.ca/sistr-app/)
  
Third-party software must be installed by the user and locations must be included in the **config_file.txt**.  
You can find an example of the **config_file.txt** [here](https://github.com/nmquijada/tormes/tree/master/files/config_files.txt). (Tab-separated format)  
** We are working in an automated protocol for third-party software installation that will be released soon **


<br>

## Usage
```
Usage: tormes [options]

OBLIGATORY OPTIONS:
        -m/--metadata   Path to the file with the metadata regarding the samples
                        The file must have an specific organization for the program to work
                        If you don't have any or you would like to have an example or extra information,
                        please type:
                        tormes example-metadata
        -o/--output     Path and name of the output directory
        -r/--reference  Type path to reference genome (fasta, gbk)

OTHER OPTIONS:
        -a/--adapter    Path to the adapters file
        -c/--config     Path to the configuration file with the location of all dependencies
        --fast          Disable pangenome analysis for a quicker analysis (default='0')
        -g/--genera     Type genera name to allow special analysis (default='none')
                        Options available: Escherichia, Salmonella
        -h/--help       Show this help
        -q/--quality    Minimum mean phred score of the reads to survive (default=25) <integer>
        -t/--threads    Number of threads to use (default=1) <integer>
        --title         Path to a file containing the title in the project that will be used as title in the report
                        Avoid using special characters. TORMES will perform a default title if this option is not used
        -v/--version    Show version

```
<br>

Example:
```
tormes --metadata salmonella_metadata.txt --output Salmonella_TORMES_2018 --reference S_enterica-CT02021853.fasta --threads 32 --genera Salmonella
```
<br>

### Obligatory options
A metadata text file is needed for TORMES to work by using the `-m/--metadata` option. This file will include all the information regarding the sample and requires an specific organization:  
 - Columns should be tab separated.
 - First column must me called `Samples` and harbor samples names (avoid special characters).
 - Second column must be called `Read1` and harbor the path to the R1 (forward) reads (either fastq or fastq.gz).
 - Third column must be called `Read2` and harbor the path to the R2 (reverse) reads (either fastq or fastq.gz).
 - Fourth (and so on) columns are descriptive. The information included here is not needed for TORMES to work but will be included in the interactive report. You can add as many description columns as needed (including information such as isolation date or source, different codification of each sample, *etc*.).
 
<br>

This is an example of how the metadata file should looks like:  

Samples | Read1 | Read2 | Description1 | Description2 |
------- | ----- | ----- | ------------ | ------------ |
Sample1 | Forward read location | Reverse read location | Description 1 of Sample 1 | Description 2 of Sample 1 |
Sample2 | Forward read location | Reverse read location | Description 1 of Sample 2 | Description 2 of Sample 2 |

<br>

If problems are encountered when performing the metadata file, you can generate a template metadata file by typing: `tormes example-metadata`.  
This command will generate a file called `samples_metadata.txt` in your working directory that can be used as a template for your own dataset.

<br>

## Output
TORMES stores every file generated during the analysis is different directories regarding the step within the analysis (assembly, annotation, *etc.*), all of them included within the main output directory specified with the `-o/--output` option:  

- **annotation**: one directory per sample containing all the annotation files generated by [Prokka](https://github.com/tseemann/prokka).
- **antibiotic_resistance_genes**: results of the scrrening for antibiotic resistance genes by using [Abricate](https://github.com/tseemann/abricate) against three databases: ARG-ANNOT, CARD and ResFinder.
- **assembly**: files resulting from genome assembly with [SPAdes](http://cab.spbu.ru/software/spades/) (in gzipped directories, to unzip them type `tar xzf file-name.tgz`) and the assembly stats generated with [Quast](http://quast.sourceforge.net/quast).
- **cleaned_reads**: reads the survived after quality filtering using [Prinseq](http://prinseq.sourceforge.net/) and [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic).
- **draft_genomes**: stores the draft genomes once ordered against the reference included by the `-r/--reference`option by using [Mauve](http://darlinglab.org/mauve/mauve.html). Contigs < 200 bp are removed.
- **mlst**: results of Multi-Locus Sequence Typing (MLST) by using [mlst](https://github.com/tseemann/mlst).
- **pangenome**: results of pangenome comparison based on the presence/absence of genes between the samples by using [Roary](https://sanger-pathogens.github.io/Roary/).
- **report_files.tgz**: files necessary for the generation of the interactive web-like report. See further instructions here.
- **sequencing_assembly_report.txt**: tabulated file including information of the sequencing (number of reads, average read length, sequencing depth), the assembly (number of contigs, genome length, average contig length, N50, GC content) and consensus taxonomic assignment.
- **species_identification**: consensus taxonomic assignment of each sample by using [Kraken](https://ccb.jhu.edu/software/kraken/).
- **tormes.log**: log file of TORMES analysis progress.
- **tormes_report.html**: web-interactive report generated automatically after WGS analysis that summarizes the results. Can be open in any browser, shared and analyzed in a simple way.
- **virulence_genes**: results of the scrrening for virulence genes by using [Abricate](https://github.com/tseemann/abricate) against the [Virulence Factors Database](http://www.mgc.ac.cn/VFs/).

<br>

Once the analysis is finished, TORMES summarizes the results in a interactive web-like report. An example of a report file can be visualized [here](https://nmquijada.github.io/tormes/files/).

<br>

## Customizing the summary-report

<br>

## License
TORMES is a free software, licensed under [GPLv3](https://github.com/nmquijada/tormes/blob/master/LICENSE).
