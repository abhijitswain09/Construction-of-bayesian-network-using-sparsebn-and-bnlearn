nextflow.enable.dsl=2
params.expression = null
params.whitelist = null
params.outdir = 'results'
process SPARSEBN {
    tag 'sparsebn'
    conda "${projectDir}/environment.yml"
    cpus 4
    memory '16 GB'
    input:
    path expression
    path whitelist
    path script
    output:
    path 'sparsebn.Rdata', emit: model
    path 'mm2.txt', emit: edges
    path 'data2.csv', optional: true, emit: csv
    script:
    """
    cp "${expression}" filtered_rpkm.txt
    cp "${whitelist}" whitelist_TF_AP1
    Rscript "${script}"
    """
    stub:
    """touch sparsebn.Rdata mm2.txt data2.csv"""
}
workflow {
    if (!params.expression || !params.whitelist) error 'Provide --expression and --whitelist'
    SPARSEBN(file(params.expression, checkIfExists: true),
             file(params.whitelist, checkIfExists: true),
             file("${projectDir}/sparsebn.R", checkIfExists: true))
}
