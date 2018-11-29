# TORMES
An automated pipeline for whole bacterial genome analysis directly from raw Illumina sequencing data.  

<br>

## Contents  
  * [Introduction](#introduction)
  * [Installation](#installation)
      * [Required dependencies](#required-dependencies)
  * [Usage](#usage)
      * [Obligatory options](#obligatory-options)  
  * [Output](#output)
  * [License](#license)
  * [Citation](#citation)

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

The files used for this example, that were used in TORMES publication, can be found [here](https://github.com/nmquijada/tormes/).

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

An example of the interactive web-like file that TORMES generates can be visualized [here](https://nmquijada.github.io/tormes/)

<br>

## License
TORMES is a free software, licensed under [GPLv3](https://github.com/nmquijada/tormes/blob/master/LICENSE).
