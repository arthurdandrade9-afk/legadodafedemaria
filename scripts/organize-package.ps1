$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Resolve-Path (Join-Path $siteRoot '..\outputs\legado-de-fe-com-maria')
$packageRoot = Join-Path $sourceRoot 'PACOTE-FINAL-LEGADO-DE-FE'

$folders = @(
  '00-COMECE-AQUI',
  '01-MANUAL-DA-JORNADA',
  '02-CAMINHOS-DE-MARIA',
  '03-CADERNO-DO-LEGADO',
  '04-CARTOES-DE-ORACAO\cartoes-individuais',
  '05-CALENDARIO-MARIANO',
  '06-NOVENA-E-LADAINHA',
  '07-PEQUENOS-COM-MARIA',
  '08-TODOS-OS-NOMES-DE-MARIA',
  '09-CATALOGO-VISUAL',
  '10-EDICAO-REUNIDA',
  '11-VERSOES-PREENCHIVEIS'
)

foreach ($folder in $folders) {
  New-Item -ItemType Directory -Force -Path (Join-Path $packageRoot $folder) | Out-Null
}

$copies = @{
  'LEIA-ME.md' = '00-COMECE-AQUI\LEIA-ME.md'
  'manifesto-lancamento.json' = '00-COMECE-AQUI\manifesto-lancamento.json'
  '01-manual-legado-de-fe-com-maria.pdf' = '01-MANUAL-DA-JORNADA\01-manual-legado-de-fe-com-maria.pdf'
  '02-caminhos-de-maria-volume-1.pdf' = '02-CAMINHOS-DE-MARIA\volume-1.pdf'
  '03-caminhos-de-maria-volume-2.pdf' = '02-CAMINHOS-DE-MARIA\volume-2.pdf'
  '04-caminhos-de-maria-volume-3.pdf' = '02-CAMINHOS-DE-MARIA\volume-3.pdf'
  '05-caminhos-de-maria-volume-4.pdf' = '02-CAMINHOS-DE-MARIA\volume-4.pdf'
  '06-caderno-do-legado.pdf' = '03-CADERNO-DO-LEGADO\caderno-do-legado.pdf'
  '07-cartoes-caminhos-de-maria.pdf' = '04-CARTOES-DE-ORACAO\cartoes-frente-e-verso.pdf'
  '08-calendario-um-ano-com-maria.pdf' = '05-CALENDARIO-MARIANO\calendario-um-ano-com-maria.pdf'
  '09-guia-nove-dias-e-ladainha.pdf' = '06-NOVENA-E-LADAINHA\guia-nove-dias-e-ladainha.pdf'
  '10-pequenos-com-maria.pdf' = '07-PEQUENOS-COM-MARIA\pequenos-com-maria.pdf'
  '11-todos-os-nomes-de-maria-piloto.pdf' = '08-TODOS-OS-NOMES-DE-MARIA\todos-os-nomes-de-maria.pdf'
  '11-catalogo-legado-de-fe-com-maria.pdf' = '09-CATALOGO-VISUAL\catalogo-legado-de-fe-com-maria.pdf'
  '12-legado-de-fe-com-maria-edicao-completa.pdf' = '10-EDICAO-REUNIDA\legado-de-fe-com-maria-edicao-reunida.pdf'
  'versoes-preenchiveis\manual-legado-de-fe-com-maria-preenchivel.pdf' = '11-VERSOES-PREENCHIVEIS\manual-preenchivel.pdf'
  'versoes-preenchiveis\caderno-do-legado-preenchivel.pdf' = '11-VERSOES-PREENCHIVEIS\caderno-preenchivel.pdf'
}

foreach ($source in $copies.Keys) {
  Copy-Item -LiteralPath (Join-Path $sourceRoot $source) -Destination (Join-Path $packageRoot $copies[$source]) -Force
}

Copy-Item -Path (Join-Path $sourceRoot 'cartoes-individuais\*.png') -Destination (Join-Path $packageRoot '04-CARTOES-DE-ORACAO\cartoes-individuais') -Force

Write-Output "Pacote final organizado em: $packageRoot"
