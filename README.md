[![Anaconda-Server Badge](https://anaconda.org/nmquijada/tormes/badges/version.svg)](https://anaconda.org/nmquijada/tormes)
[![Anaconda-Server Badge](https://anaconda.org/nmquijada/tormes/badges/latest_release_date.svg)](https://anaconda.org/nmquijada/tormes)
[![Anaconda-Server Badge](https://anaconda.org/nmquijada/tormes/badges/installer/conda.svg)](https://conda.anaconda.org/nmquijada)
[![Anaconda-Server Badge](https://anaconda.org/nmquijada/tormes/badges/downloads.svg)](https://conda.anaconda.org/nmquijada)
<br>

# TORMES
TORMES is An automated and user-friendly pipeline for whole bacterial genome analysis of your genomes (previously assembled or downloaded from any repository) and/or your raw Illumina paired-end sequencing data, regardless the number of bacterial isolates, their origin or taxonomy.

TORMES has been deviced to be run by following very simple commands, such as:  
```tormes --metadata my-metadata.txt --output tormes-output```  

Additinonally, further options can be added to the software, as described in the following sections of this manual.

<br>

## UPDATE 08 June 2021: TORMES version 1.3.0 is released!

This new version comes with a number of improvements!:

 -	Specific analyses for *Klebsiella* by enabling the ```--genera Klebsiella``` option. The specific analyses include: plasmid detection by using PlasmidFinder, detection of point mutations associated with antimicrobial resistance by using PointFinder and subtyping of the isolates based on surface polysaccharide locus: complex capsule (K) and on complex LPS (O) locus by using Kaptive.
 -  Possibility to perform nucleotide gene searches from user custom databases (must be nucleotide databases as the search is based on BLASTN by using ABRicate) by using the ```--custom_genes_db``` option (for instance ```--custom_genes_db "mydb1 mydb2 mydb3"```). You can use as many custom databases as you want. The custom databases must have been previously formatted and installed in TORMES (see the instructions in the [Wiki](https://github.com/nmquijada/tormes/wiki/Installing-and-using-custom-nucleotide-databases-in-TORMES)).
 -  You can set the maximum number of threads to use for genome assembly by using the ```--max_cpus_per_assembly``` option. For instance, if you set ```--threads 48``` (which set the maximum number of threads for TORMES to use to 48) and ```--max_cpus_per_assembly 8```, this will make TORMES to perform 6 assemblies in parallel by using 8 threads per assembly. Further descriptions of advantages and disadvantages will be discussed in the Wiki soon.
 -  Set the minimum contig length of your assemblies by using the ```--min_contig_len``` option (default=200).
 -  Possibility to modify the minimum percentage of coverage and identity of genes’ searches by using the ```--gene_min_cov``` and the ```--gene_min_id``` options, respectively (default = 80).
 -  Disable genome annotation by Prokka and just perform gene prediction with Prodigal (```--only_gene_prediction``` option. Default=no)
 -  You can set further options to be parsed to Prodigal as a string after the ```--prodigal_options``` flag (it requires the ```--only_gene_prediction``` option to enabled).
 -  A “citation.txt” file will be created in your run including the citations of each of the software and databases that were used in your analysis (will also be included in the “Citations” section of the tormes-report). TORMES is a pipeline that rely on all the software included in each "citations.txt" file and we strongly encourage to cite them all when citing TORMES (some excamples will appear in the Wiki soon)
 -  The "DT" R package is now used for the tormes-report generation, which renders interactive tables in the *tormes_report.html* file.


<br>

*All the information contained in this README refers to **TORMES version 1.3.0***
Get track of the improvements in TORMES pipeline in the [Versions history](#versions-history) section.
For further information or additional uses you can also visit the [TORMES wiki](https://github.com/nmquijada/tormes/wiki).


<br>

## Contents
  * [What is TORMES?](#what-is-tormes)
  * [Installation](#installation)
      * [Required dependencies](#required-dependencies)
  * [Usage](#usage)
      * [Obligatory options](#obligatory-options)
  * [Output](#output)
  * [Rendering customized reports](#rendering-customized-reports)
  * [Citation](#citation)
  * [Acknowledgements](#acknowledgements)
  * [Open-source and networking community](#open-source-and-networking-community)
  * [License](#license)
  * [Versions history](#versions-history)

<br>

## What is TORMES?

TORMES is an open-source, user-friendly pipeline for whole bacterial genome sequencing (WGS) analysis directly from raw Illumina paired-end sequenceing data. Since *version 1.1* TORMES can also analyze already assembled genomes, alone or in combination with raw sequencing data.
TORMES work with every bacterial WGS dataset, regardless the number, origin or species. By following very simple instructions, TORMES automates all steps included in a typical WGS analysis, including:

1) Sequence quality filtering
2) *De novo* genome assembly
3) Draft genome ordering against a reference (optional)
4) Taxonomic identification based on *k*-mers
5) Extraction of rRNA genes and taxonomic identification based on the 16S rRNA gene
6) Genome annotation
7) Multi-Locus Sequence Typing (MLST, optional)
8) Antibiotic resistance genes screening
9) Virulence genes screening
10) Pangenome comparison (optional)

When working with *Escherichia*, *Klebsiella* or *Salmonella* sequencing data, extensive analysis can be enabled (by using the `-g/--genera` option), including:

11) Antibiotic resistance screening based on point mutations
12) Plasmid replicons screening
13) Serotyping (only for *Escherichia* and *Salmonella*)
14) fimH-Typing (only for *Escherichia*)
15) Subtyping based on surface polysaccharide locus: complex capsule (K) and on complex LPS (O) locus (only for *Klebsiella*)

Once the WGS analysis is ended, TORMES summarizes the results in an interactive web-like file that can be opened in any web browser, making the results easy to analyze, compare and share.

16) Interactive report generation (customizable)

<br>

***Overview of the TORMES pipeline***
<img align="center" src="https://github.com/nmquijada/tormes/blob/gh-pages/wiki-images/Summary-figure.png" width="80%">

<br>

TORMES is written in a combination of Bash, R and R Markdown. Once the WGS is ended, TORMES will automatically generate a RMarkdown file (unique for each analysis) that will be use to render the report in R environment. This file is susceptible for user's modification and the generation of user-specific reports (by including additional information, tables, figures, *etc.*). Additional information can be found in the [Rendering customized reports](#rendering-customized-reports) section.
TORMES is a pipeline, and for its use it is necessary the utilization of a lot of bioinformatic tools that constitutes the backbone of TORMES and that are listed in the [Required dependencies](#required-dependencies) section. Therefore, TORMES users are encourage to cite the software included in each TORMES run. For an example on how to do so, click [here](https://github.com/nmquijada/tormes/wiki/How-to-cite-TORMES-and-the-included-software).  

<br>

The availability of open-source, user-friendly pipelines, will broaden the application of certain technologies, such as WGS, where the bottleneck sometimes rely in the complex bioinformatic analysis of the great amount of data that is generated by high-throughput DNA sequencing (HTS) platforms. TORMES was devised with this aim, inspired by some excellent currently available software, such as [Nullarbor](https://github.com/tseemann/nullarbor), [EnteroBase](https://enterobase.warwick.ac.uk/) and the [Center for Genomic Epidemiology](https://cge.cbs.dtu.dk/services/). Nowadays, there are other alternatives for conducting WGS analysis, as more software are appearing regularly, such as the recently published [Bactopia](https://github.com/bactopia/bactopia) and [ASA³P](https://github.com/oschwengers/asap). Every software offers different features towards specific outcomes, providing the users with a wide variety of option to face WGS.
We would like TORMES to be regularly updated with the most novel tools and databases, and to improve the pipeline taking into account users' suggestions.

<br>

## Installation

TORMES is a pipeline that requires a lot of dependencies to work. It has been devised to be used as a conda environment. For installing TORMES an all its dependencies run:

```
wget https://anaconda.org/nmquijada/tormes-1.3.0/2021.06.08.113021/download/tormes-1.3.0.yml
conda env create -n tormes-1.3.0 --file tormes-1.3.0.yml
```
<br>

To activate TORMES environment run:

```
conda activate tormes-1.3.0
```
<br>

Additionally, the first time you are using TORMES, run (after activating TORMES environment):

```
tormes-setup
```

This step will install additional dependencies not available in conda and will automatically create the **config_file.txt** required for TORMES to work (see below).
This script will download the [MiniKraken2_v1_8GB](https://ccb.jhu.edu/software/kraken2/index.shtml?t=downloads) database required for Kraken2 to work. This database takes ~8 GB space and it is downloaded by default in order to facilitate TORMES installation. If the user has enough disk space and RAM power, we encourage to download and install the "Standard Kraken2 Database" by following the instructions provided by [Kraken2 developers](https://github.com/DerrickWood/kraken2/wiki/Manual#standard-kraken-2-database). The "Standard Kraken2 Database" will increase the sensitivity of the taxonomic identification. However, this is not needed for running TORMES. It will equally work with the MiniKraken2_v1_8GB.

<br>

If you were already using a previous version of TORMES, sometimes conda runs into issues when installing more than one version of TORMES due to the differential version of the included dependencies (each new version of TORMES includes the current version of the dependencies).
If you run into such problems, just remove the previous TORMES environment and "clean up" the system by doing:
```
conda env remove -n tormes-1.2.1
conda clean --all
```

<br>

### Required dependencies
TORMES is a pipeline and it requires several dependencies to work (all of them will be installed with the conda environment):
  * [ABRicate](https://github.com/tseemann/abricate)
  * [Barrnap](https://github.com/tseemann/barrnap)
  * [FastTree](http://meta.microbesonline.org/fasttree/)
  * [GNUParallel](https://www.gnu.org/software/parallel/)
  * [ImageMagick](http://www.imagemagick.org/)
  * [Kraken2](https://github.com/DerrickWood/kraken2)
  * [Megahit](https://github.com/voutcn/megahit)
  * [mlst](https://github.com/tseemann/mlst)
  * [Prinseq](http://prinseq.sourceforge.net/)
  * [Prodigal](https://github.com/hyattpd/Prodigal)
  * [progrressiveMauve](http://darlinglab.org/mauve/mauve.html)
  * [Prokka](https://github.com/tseemann/prokka)
  * [Quast](http://quast.sourceforge.net/quast)
  * [R](https://cran.r-project.org/)
    * R packages: [ggtree](https://bioconductor.org/packages/release/bioc/html/ggtree.html), [knitr](https://cran.r-project.org/web/packages/knitr/index.html), [plotly](https://cran.r-project.org/web/packages/plotly/index.html), [RColorBrewer](https://cran.r-project.org/web/packages/RColorBrewer/index.html), [reshape2](https://cran.r-project.org/web/packages/reshape2/index.html), [rmarkdown](https://cran.r-project.org/web/packages/rmarkdown/index.html), [treeio](https://bioconductor.org/packages/release/bioc/html/treeio.html)
  * [RDP Classifier](https://github.com/rdpstaff/RDPTools)
  * [Roary](https://sanger-pathogens.github.io/Roary/)
  * [roary2svg.pl](https://github.com/sanger-pathogens/Roary/blob/master/contrib/roary2svg/roary2svg.pl)
  * [Sickle](https://github.com/najoshi/sickle)
  * [SPAdes](http://cab.spbu.ru/software/spades/)
  * [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)

Additional software when working with `-g/--genera Escherichia`.
  * [PointFinder](https://bitbucket.org/genomicepidemiology/pointfinder)
  * [FimTyper](https://bitbucket.org/genomicepidemiology/fimtyper/overview)
  * [SerotypeFinder](https://bitbucket.org/genomicepidemiology/serotypefinder)

Additional software when working with `-g/--genera Klebsiella`.
  * [Kaptive](https://github.com/katholt/Kaptive)
  * [PointFinder](https://bitbucket.org/genomicepidemiology/pointfinder)

Additional software when working with `-g/--genera Salmonella`.
  * [PointFinder](https://bitbucket.org/genomicepidemiology/pointfinder)
  * [SISTR](https://lfz.corefacility.ca/sistr-app/)

TORMES will look to the software included in the **config_file.txt**, which is a simple tab-separated text file indicating the software/database and its location. An automatic config_file.txt will be created after running `tormes-setup` command. However, you can change the PATH to each software if other software version would like to be used (if you do so, respect software names and tab-separation in the config_file.txt).
You can find an example of the config_file.txt [here](https://github.com/nmquijada/tormes/blob/master/files/config_file.txt).


<br>

## Usage
```
Usage: tormes [options]

        OBLIGATORY OPTIONS:
          -m/--metadata           Path to the file with the metadata regarding the samples (raw reads and/or genomes)
                                  The metadata file must have an specific organization for the program to work.
                                  If you don't have any or you would like to have an example or extra information, please type:
                                  tormes example-metadata
          -o/--output             Path and name of the output directory

        OTHER OPTIONS:
          -a/--adapter            Path to the adapters file
                                  (default="PATH/TO/TORMES/files/adapters.fasta")
          --assembler             Select the assembler to use. Options available: 'spades', 'megahit'
                                  (default='spades')
          -c/--config             Path to the configuration file with the location of all dependencies
                                  (default="PATH/TO/TORMES/files/config_file.txt")
          --citation              Show citation of TORMES
          --custom_genes_db       <string> space-separated list of custom genes databases names.
                                  Requires the previous installation of the databases in TORMES (see https://github.com/nmquijada/tormes/wiki/Installing-and-using-custom-nucleotide-databases-in-TORMES for more instructions)
          --fast                  Faster analysis (default='0')
                                   * 'trimmomatic' is used for read quality filtering
                                   * 'megahit' is used as assembler
                                   * contig ordering and pangenome analysis are disabled
                                   * only gene prediction but not annotation is performed
          --filtering             Select the software for filtering the reads.
                                  Options available: 'prinseq', 'sickle', 'trimmomatic'
                                  (default="prinseq")
          -g/--genera             Type genera name to allow special analysis (default='none')
                                  Options available: 'Escherichia', 'Klebsiella', 'Salmonella'
          --gene_min_id           Minimum identity (%) of a gene against the database to be considered (default=80)
          --gene_min_cov          Minimum coverage (%) of a gene against the database to be considered (default=80)
          -h/--help               Show this help
          --max_cpus_per_assembly Set the maximum threads to use per assembly (default=the same as -t/--threads option)
          --min_len               Minimum length (bp) to the reads to survive after filtering (default=125) <integer>
          --min_contig_len        Minimum length (bp) of each contig to be kept in the genome after the assembly (default=200) <integer>
          --no_mlst               Disable MLST analysis (default='0')
          --no_pangenome          Disable pangenome analysis (default='0')
          --only_gene_prediction  Only gene prediction (Prodigal) but not annotation of the genes (Prokka) is performed.
                                  Pangenome analysis (Roary) will be also disabled (default='0')
          --prodigal_options      <string> Only whith "--only_gene_prediction". Specify further options for Prodigal (distinct to -a -d -f -i and -o)
          -q/--quality            Minimum mean phred score of the reads to survive after filtering (default=$QUALITY) <integer>
          -r/--reference          Type path to reference genome (fasta, gbk) (default='none')
                                  Reference will be ONLY used for contig ordering of the draft genome
          -t/--threads            Number of threads to use (default=1) <integer>
          --title                 Path to a file containing the title in the project that will be used as title in the report
                                  Avoid using special characters. TORMES will perform a default title if this option is not used
          -v/--version            Show version

```
<br>

Example:
```
tormes --metadata salmonella_metadata.txt --output Salmonella_TORMES_2020 --threads 32 --genera Salmonella
```
<br>

### Obligatory options
A metadata text file is needed for TORMES to work by using the `-m/--metadata` option. If you would like to know a shortcut for generating this file automatically from all your samples, please visit [this section of the Wiki](https://github.com/nmquijada/tormes/wiki/Shortcut-to-generate-the-metadata-file-for-TORMES).  

This metadata file will include all the information regarding the sample and requires an specific organization:
 - Columns should be tab separated.
 - First column must me called `Samples` and harbor samples names (avoid special characters ($, \*, ...) and spaces or names composed only by numbers).
 - Second column must be called `Read1` and harbor the path to the R1 (forward) reads (either fastq or fastq.gz). In the case you would like to include already assembled genomes in your analysis (with or without raw sequencing reads samples in the same analysis), this column has to contain the word "GENOME" (beware the capital letters!) for the already assembled genomes samples.
 - Third column must be called `Read2` and harbor the path to the R2 (reverse) reads (either fastq or fastq.gz). In the case you are including already assembled genomes in your analysis, this column must harbor the path to the genome (in FASTA format).
 - Fourth (and so on) columns are descriptive. The information included here is not needed for TORMES to work but will be included in the interactive report. You can add as many description columns as needed (including information such as isolation date or source, different codification of each sample, *etc*.). Spaces can be added here.

<br>

ONLY ONE METADATA FILE IS NEEDED! You must combine the information of raw reads and/or genomes in the same metadata file.
This is an **example** of how the metadata file should look like:

Samples | Read1 | Read2 | Description1 | Description2 |
------- | ----- | ----- | ------------ | ------------ |
Sample1 | PATH to Forward read  | Path to Reverse read | Description 1 of Sample 1 | Description 2 of Sample 1 |
Sample2 | PATH to Forward read  | Path to Reverse read | Description 1 of Sample 2 | Description 2 of Sample 2 |
Sample3 | GENOME | PATH to genome | Description 1 of Sample 3 | Description 2 of Sample 3 |

<br>

If problems are encountered when performing the metadata file, you can generate a template metadata file by typing: `tormes example-metadata`.
This command will generate a file called `samples_metadata.txt` in your working directory that can be used as a template for your own dataset.

<br>

## Output
TORMES stores every file generated during the analysis is different directories regarding the step within the analysis (assembly, annotation, *etc.*), all of them included within the main output directory specified with the `-o/--output` option:

- **annotation**: one directory per sample containing all the annotation files generated by [Prokka](https://github.com/tseemann/prokka).
- **antibiotic_resistance_genes**: results of the scrrening for antibiotic resistance genes by using [Abricate](https://github.com/tseemann/abricate) against three databases: ARG-ANNOT, CARD and ResFinder.
- **assembly**: files resulting from genome assembly with [SPAdes](http://cab.spbu.ru/software/spades/) or [Megahit](https://github.com/voutcn/megahit) (in gzipped directories, to unzip them type `tar xzf file-name.tgz`).
- **cleaned_reads**: reads that survived after quality filtering using [Prinseq](http://prinseq.sourceforge.net/), [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) or [Sickle](https://github.com/najoshi/sickle).
- **genome_stats**: genome stats generated with [Quast](http://quast.sourceforge.net/quast).
- **genomes**: stores the assembled genomes from raw reads and/or the genomes included in the metadata. If the `-r/--reference` option is used, genomes will be ordered against a reference by using [Mauve](http://darlinglab.org/mauve/mauve.html) and stored here. Contigs < 200 bp are removed.
- **mlst**: results of Multi-Locus Sequence Typing (MLST) by using [mlst](https://github.com/tseemann/mlst).
- **pangenome**: results of pangenome comparison between the samples by using [Roary](https://sanger-pathogens.github.io/Roary/).
- **report_files.tgz**: files necessary for the generation of the interactive web-like report. See further instructions [here](https://github.com/nmquijada/tormes/wiki/The-tormes-report-files).
- **rRNA-genes**: contains three different directories for each of the rRNA genes, 5S, 16S and 23S, that were extracted from each genome by using [Barrnap](https://github.com/tseemann/barrnap). Each directory contains one fasta file per sample harboring the respective rRNA gense sequence(s).
- **sequencing_assembly_report.txt**: tabulated file including information of the sequencing (number of reads, average read length, sequencing depth), the assembly (number of contigs, genome length, average contig length, N50, GC content) and consensus taxonomic assignment.
- **taxonomic_identification**: contains the taxonomic identification results for each sample, either based on *k*-mers by using [Kraken2](https://github.com/DerrickWood/kraken2) or the 16S rRNA gene by using the [RDP Classifier](https://github.com/rdpstaff/RDPTools).
- **tormes.log**: log file of TORMES analysis progress.
- **tormes_report.html**: web-interactive report generated automatically after WGS analysis that summarizes the results. Can be open in any browser, shared and analyzed in a simple way.
- **virulence_genes**: results of the scrrening for virulence genes by using [Abricate](https://github.com/tseemann/abricate) against the [Virulence Factors Database](http://www.mgc.ac.cn/VFs/).

<br>

Once the WGS analysis is ended, TORMES summarizes the results in a interactive web-like report file. An example of a report file can be visualized [here](https://nmquijada.github.io/tormes/files/).
For the generation of the report file, `tormes` calls `tormes-report` (included in the TORMES pipeline) that generates a *rmarkdown* file (in [R](https://cran.r-project.org/) environment), called `tormes_report.Rmd`, that can be modified by the user for the generation of customized reports without the need of re-running the entire analysis.
Since *TORMES version 1.1*, a `render_report.sh` script is generated in the "report_files" directory, that easies the rendering of a new report from the command line (see below).

<br>

## Rendering customized reports

*More detailed instructions will be provided in the [TORMES wiki](https://github.com/nmquijada/tormes/wiki#customize-reports)*

Reports are generated after rendering the "**tormes_report.Rmd**" file in R environment. This file is automatically generated after TORMES WGS analysis is ended and it is unique for each study. The file is written in R Markdown code and it can be manually modified and used for the generation of customized reports.
R Markdown is a file format for creating dynamic documents with R. Excellent documentation about this format is already available in the [R Markdown from R Studio webpage](https://rmarkdown.rstudio.com/). The R Markdown [Reference Guide](http://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf) and [Cheat Sheet](https://www.rstudio.com/wp-content/uploads/2016/03/rmarkdown-cheatsheet-2.0.pdf) are also recommended.
The user is encouraged to modify the "**tormes_report.Rmd**" file for the generation of user-customized reports by following the guidelines above. Once the "**tormes_report.Rmd**" file has been modified, it can be used to render a new report by using the following instructions (TORMES environment might be activated):

<br>

First, the directory containing the reports has to be unzipped:
```
tar xzf report_files.tgz
```

In the `report_files` directory you will find the "*tormes_report.Rmd*" that can be modified.
Since TORMES *version 1.1*, a script called "**render_report.sh**" will be found in the `report_files` directory.
Once the *tormes_report.Rmd* file has been appropiately modified, a new html report can be generated by typing:

```
./render_report.sh
```

<br>

This command will generate a new "**tormes_report.html**".
**Please note** that all the information (tables, figures, *etc.*) that is wanted to be included in the report file, **need** to be in the same directory as the "tormes_report.Rmd" file.

<br>

## Citation

Please cite the following pubication if you are using TORMES:

<br>


Narciso M. Quijada, David Rodríguez-Lázaro, Jose María Eiros and Marta Hernández (2019). TORMES: an automated pipeline for whole bacterial genome analysis. *Bioinformatics*, 35(21), 4207–4212, https://doi.org/10.1093/bioinformatics/btz220


<br>

The dependencies described in [this section](#required-dependencies) are the backbone of TORMES, and users must cite them when using TORMES. You can find an example on how to do so [in this section of the Wiki](https://github.com/nmquijada/tormes/wiki/How-to-cite-TORMES-and-the-included-software).

<br>

## Acknowledgements

TORMES was devised and initially developed in the **Instituto Tecnológico Agrario de Castilla y León (ITACyL, Valladolid, Spain)** in collaboration with the **University of Burgos (UBU, Burgos, Spain)** and the **Hospital Universitario del Río Hortega (Valladolid, Spain)**. The same institutions are still responsible of the continous development and maintainance of the sofware, aswell as new collaboration institutions and partners. That is the case of the **University of Veterinary Medicine of Vienna (Vienna, Austria)** and the **Austrian Competence Center for Feed and Food Quality, Safety and Innovation (FFoQSI GmbH, Tulln, Austria)**.

<br>

Additionally, we have the luck to count with new collaborators apart from the included in the main citation of TORMES, that are actively involved in the development and improvement of the software. Their work is very much appreciated and their names will appear in future publications of the software. Great thanks to **David Abad (Instituto Tecnológico Agrario de Castilla y León, ITACyL, Valladolid, Spain)** and **Bradley J. Hart (UniSA: Clinical and Health Sciences, University of South Australia, Adelaide, Australia)**.

<br>

## Open-source and networking community

TORMES was devised with the aim of being an open-source and easy tool that everybody can use for their WGS experiments. Bacterial bioinformatics is developing rapidly, and the availability of open code and tools is crucial for the scientific community to benefit from these developments.

Additionally, TORMES is intended to be a networking project with users providing their feedback and personal experience so that TORMES can become a more complete pipeline including as many analyses and genera as possible.
There’s been more than a year since we launch this tool and we are very happy with the responses from the community. Most of the suggestions are considered for further improvements of the TORMES pipeline and some users have also shared their code that could be used to extend TORMES analysis and/or to overcome some issues/challenges.
We are working for a finer tool for WGS that can be freely provided to the community and definitively the feedback from users is being pivotal.

<br>

- [**@biobrad**](https://github.com/biobrad) has developed [**Tormesbot**]( https://github.com/biobrad/tormesbot/wiki/Tormesbot), a tool to assist other microbiologists who are not computer savvy in manipulating the metadata and parsing arguments to a HPC environment.

<br>

## License
TORMES is a free software, licensed under [GPLv3](https://github.com/nmquijada/tormes/blob/master/LICENSE).

<br>

## Versions history
Get track of the improvements of each version [here](https://github.com/nmquijada/tormes/releases).
- **v.1.3.\*** (June 2021, *current*)
- **v.1.2.\*** (October 2020): New features: Kraken2 is now used instead of Kraken, increasing the sensitivity and speed for the taxonomic identification based on *k*-mers. Additionally, rRNA genes will be extracted from the genomes and the 16S rRNA genes will be  used for taxonomic classification by using the RDP Classifier.
- **v.1.1.\*** (April 2020): New features: Enables the option to include already assembled genomes into the analysis, alone or in combination with raw sequencing data. Script "*render_report.sh*" is automatically generated in the "report_files" directory for easy generate the report.
- **v.1.0.\*** (April 2019): original version of the TORMES pipeline.
