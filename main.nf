nextflow.enable.dsl=2
params.expression = null
params.whitelist = null
params.outdir = 'results'
process SPARSEBN {
  tag 'sparsebn'
  conda "${projectDir}/environment.yml"
  input: path expression; path whitelist
  output: path 'sparsebn.Rdata'; path 'mm2.txt'; path 'data2.csv', optional: true
  script:
  """
  cp "${expression}" filtered_rpkm.txt
  cp "${whitelist}" whitelist_TF_AP1
  Rscript sparsebn.R
  """
}
workflow {
  if (!params.expression || !params.whitelist) error 'Provide --expression and --whitelist'
  SPARSEBN(file(params.expression, checkIfExists: true), file(params.whitelist, checkIfExists: true))
}