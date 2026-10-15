# this config file is sourced by the main bash pipeline


# specify a directory where results should be written. This directory will contain two subdirs:
#  data: the 'trimmed' subdir will contain the fastq files output by cutadapt, which trims adapters/primers but quality trimming is not done (Q threshold set at 2)
#  results: to contain tagged copies of the metadata and config files, as well as 2 directories ('dada2' and 'diversity_diffabundTAG, where TAG is the same text tag added to metadata and config files)
PROJECT_DIR="~/sharedscratch/CGEBMPnnnA_rerun" # this should be a directory existing or to be created within an existing directory; data and result directories will be created within this one. tilde ok.

# name of the project to be included at top of html outputs
PROJECT="Alzheimers_Microbiome"

# suffix on copies of config,metadata files and on diversity_diffabund_* dir; this may be an empty string
ANALYSIS_SUFFIX="_demo"

# path to metadata csv file, either relative to run dir or absolute; may also be tsv format; \r carriage return characters usually removed if these are output from excel
METADATA_PATH="~/sharedscratch/CGEBMPnnnA_rerun/scripts/metadata2.csv"

# trimming variables
# clips remove primer sequence on the 5p end of reads, which is external to the amplicon. clips 0+ in length SUPERCEDE ADAPTER_R* and PRIMER_R* variables
# set clip lengths to -1 to use adapter and primer sequences; setting clip lengths 0+ causes ADAPTER_R* and PRIMER_R* and TRIM_N to be ignored
CLIP5_R1=-1 # doing alignment-based primer removal
CLIP5_R2=-1
#CLIP5_R1=20 # V1V2 primer size, if doing hard-clipping of primers
#CLIP5_R2=18
#CLIP5_R1=17 # V3V4 primer size
#CLIP5_R2=21
#CLIP5_R1=15 # archaea primer size
#CLIP5_R2=20
#CLIP5_R1=22 # fungal ITS primer size
#CLIP5_R2=20

# supply sequences of adapters and primers to use in alignment-based trimming. It should be noted that for amplicons (e.g. 16S V4) that are shorter than the read length, the R2 primer/adapter sequences may be observed in the R1 sequence, and vice versa
# Nextera transposase adapters
ADAPTER_R1="TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG" ### 5 VARIABLES FOR CURRENT TRIMMING METHODS (CUTADAPT AND FASTQC, TRIMMING ADAPTERS/PRIMERS ONLY, NO QUALITY TRIMMING)
ADAPTER_R2="GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG"

# primer sequences - these are ignored if CLIP5_R1 and CLIP5_R2 are set
# V1V2 primers (good for bacterial samples)
PRIMER_R1="AGMGTTYGATYMTGGCTCAG"
PRIMER_R2="GCTGCCTCCCGTAGGAGT"
# V3V4 primers
#PRIMER_R1="CCTACGGGNGGCWGCAG"
#PRIMER_R2="GACTACHVGGGTATCTAATCC"
# V4 primers, same as R1 primer for archaea
#PRIMER_R1="CAGCMGCCGCGGTAA"
#PRIMER_R2="GACTACHVGGGTATCTAATCC" # same as V3V4 primer_r2
# primers for archaea, note in second nested round of PCR, same adapter_r1,2 as above are used
#PRIMER_R1="CAGCMGCCGCGGTAA"
#PRIMER_R2="GGACTACVSGGGTATCTAAT"
# fungal ITS primers
#PRIMER_R1="CTTGGTCATTTAGAGGAAGTAA"
#PRIMER_R2="GCTGCGTTCTTCATCGATGC"
TRIM_N="--trim-n" # trim_n is either "" or "--trim-n", the cutadapt option that removes N from either end.



# VARIABLES FOR DADA2 FILTERING

DATA_TO_ANALYSE="trimmed" # "raw" or "pretrimmed" or "trimmed" or "none" (no analysis, only initial QC); do we use pretrimmed data or raw after all?
READ1_TRUNC_LEN=200
READ2_TRUNC_LEN=225 # Pnnn R2s are better quality than R1
MAX_EXP_ERRORS_PER_READ1=2 # default Inf
MAX_EXP_ERRORS_PER_READ2=2
MIN_AMPLICON_LENGTH=0 # default 0-600, only set this if necessary and after looking at one round with no filtering
MAX_AMPLICON_LENGTH=600
TRUNC_Q_READ1=2 # rarely used: clip at first occurrence of this quality (default 2)
TRUNC_Q_READ2=2

# taxon database - a fasta file with kingdom, phylum, etc. forming the sequence headers
# for bacterial and/or archaeal reads, use SILVA 138
GENUS_DB="/uoa/scratch/shared/cgebm/silva_db/silva_nr_v138_train_set.fa.gz"
SPECIES_DB="/uoa/scratch/shared/cgebm/silva_db/silva_species_assignment_v138.fa.gz"
TAXON_LEVELS="Kingdom,Phylum,Class,Order,Family,Genus,Species"

#GENUS_DB="/uoa/scratch/shared/cgebm/pr2_euk_db/pr2_version_5.0.0_SSU_dada2.fasta.gz" # v5.0.0 updated to 20230515, has Diversispora(ceae)
#SPECIES_DB=""
#TAXON_LEVELS="Domain,Supergroup,Division,Subdivision,Class,Order,Family,Genus,Species"
# from online post by PR2, see https://pr2-database.org/documentation/pr2-taxonomy-9-levels/
# ascertained for fungi from searches of individual taxa names, TAXON_LEVELS="Superkingdom,Clade1,Clade2,Kingdom,Phylum,Subphylum,Class,Genus,Species"

# for fungal ITS sequences
#GENUS_DB="/uoa/scratch/shared/cgebm/unite_fungi_db/unite_04.04.2024_dev_dada2.fasta.gz"
#SPECIES_DB=""
#TAXON_LEVELS="Kingdom,Phylum,Class,Order,Family,Genus,Species"

# for eukaryote 12s mitochondrial DNA
#GENUS_DB="/uoa/scratch/shared/cgebm/midori_euk_db/MIDORI2_UNIQ_NUC_GB268_srRNA_DADA2.fasta.gz"
#SPECIES_DB=""
#TAXON_LEVELS="Kingdom,Phylum,Class,Order,Family,Genus,Species"

# VARIABLES FOR DIVERSITY AND DIFFERENTIAL ABUNDANCE ANALYSIS

# this is a semicolon-separated list of statements that either include or exclude taxa at a given level. If multiple taxa are to be included or excluded, these are comma-separated. Inclusion is indicated by _IS_ and exclusion by _NOT_. Criteria are applied seqeuntially left to right.
TAXON_FILTER_STRING="Kingdom_IS_Bacteria,Archaea;Phylum_NOT_Cyanobacteria/Chloroplast;Class_NOT_Chloroplast;Family_NOT_Mitochondria"

# abundance analysis config - first var1 level is the control; all levels must be present more than once (for fungi, make positive control first level?)
# format: <metadata-varname>:<varlevel1>,<varlevel2>,...<varleveln>
VAR1="Group:Control,Alzheimers,AlzCB" # AlzCB is Alzheimers with challenging behaviour

# var2_levels can be numeric or character, will be converted to character - first var2 level is the control;
# format: <metadata-varname>:<varlevel1>,<varlevel2>,...<varleveln>
# if var2 != "", all levels must be present more than once (for fungi, make positive control first level?)
# if var2 == "", set VAR2=""; DO NOT use plain colon.
VAR2=""

# subject - include this if plots are to be shown with subject as same colour. if a fraction (subj_thresh) of subjects are present in multiple levels of all main variables, subject will be fitted in alpha-diversity and DA analysis and regressed out of normalised counts.
VARSUBJ="Volunteer" # "<metadata-varname>" or "" # NOTE: do NOT include levels as you would for VAR1 and VAR2. If varsubj is specified as "", each sample will be handled as if coming from an independent supject.
SUBJ_THRESH=0.25 # where VARSUBJ is "", i.e. unspecified, SUBJ_THRESH will have no effect

# variable showing biological reps. samples belonging to the same biol_rep are technical AND WILL BE MERGED. to specify no technical reps, varbiolrep: ""
VARBIOLREP="Volunteer" # "<metadata-varname>" or ""

# names in first column of metadata, which form first part of fastq filename; for fungi, put positive control samples in here in a second analysis run. the names here are in the first column of the metadata spreadsheet generated by the fastq_dir_to_samplesheet.py python program
# format: <sample-name1>,<sample-name2>,...<sample-namen>
SAMPLE_REMOVE="povestrainmix"

POS_CONTROL_NAME="" # "MSC1010-ITS" # pos control listed here should only be ONE sample name at most and ONLY if it is a BACTERIAL Zymo or ATCC 16S mock community control - it will be compared to both. In ALL OTHER CASES use empty string here and treat pos controls as regular samples.

# alpha diversity measures. these values will be provided directly to the phyloseq::estimate_richness function 'measures' option. Default measures are 'Observed', 'Shannon' (See https://rdrr.io/bioc/phyloseq/man/estimate_richness.html)
# Default measures are as follows
#  Observed: a straightforward count of the taxa in a sample with 1+ counts
#  Shannon: a classic measure of entropy, which is maximised when all taxa in a sample have equal counts
#  InvSimpson: inverse Simpson is an estimate of how many main, equally-abundant taxa are in a sample (e.g. InvSimpson == n when there are n equally abundant taxa)
# format: <metric1>,<metric2>,...<metricn>
ALPHA_DIV_MEASURES="Observed,Shannon,InvSimpson"

ASV_MIN_DEPTH=20
ASV_MIN_FRAC_SAMPLES=0.5
CLEAN_SAMPLE_MINCOUNT=500

TOP_N_GENERA=20
FDR_THRESH=0.25

PLOT_OUTLIER_CORR="false" # "true" means include count data without DESeq2 outlier correction in graphs

# do_diff_abund - allows the user to skip differential abundance analysis, stopping after beta diversity analysis.
# format: "true" or "false"
DO_DIFF_ABUND="true"

