#!/usr/bin/env nextflow
/*
========================================================================================
                         nf-core/exome
========================================================================================
 nf-core/exome Analysis Pipeline.
 #### Homepage / Documentation
 https://github.com/nf-core/exome
----------------------------------------------------------------------------------------
*/

include { EXOME } from './workflows/EXOME.nf'

workflow {
    EXOME()
}
