# TORMES
An automated pipeline for whole bacterial genome analysis directly from raw Illumina sequencing data.  

<br>

## Contents  
  * [Introduction](#introduction)
  * [Installation](#installation)
      * [Required dependencies](#required-dependencies)
  * [Usage](#usage)
  * [Output](#output)
  * [Customizing the report](#report)
  * [Enabling further analysis for *Escherichia* and *Salmonella*](#genera)
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

Example:
```
tormes --metadata salmonella_metadata.txt --output Salmonella_TORMES_2018 --reference S_enterica-CT02021853.fasta --threads 32 --genera Salmonella
```


## License
TORMES is a free software, licensed under [GPLv3](https://github.com/nmquijada/tormes/blob/master/LICENSE).
