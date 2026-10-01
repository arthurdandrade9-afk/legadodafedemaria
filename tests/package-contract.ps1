$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot
$productRoot = Resolve-Path (Join-Path $siteRoot '..\outputs\legado-de-fe-com-maria')
$packageRoot = Join-Path $productRoot 'PACOTE-FINAL-LEGADO-DE-FE'

$requiredFiles = @(
  '00-COMECE-AQUI\LEIA-ME.md',
  '01-MANUAL-DA-JORNADA\01-manual-legado-de-fe-com-maria.pdf',
  '02-CAMINHOS-DE-MARIA\volume-1.pdf',
  '02-CAMINHOS-DE-MARIA\volume-2.pdf',
  '02-CAMINHOS-DE-MARIA\volume-3.pdf',
  '02-CAMINHOS-DE-MARIA\volume-4.pdf',
  '03-CADERNO-DO-LEGADO\caderno-do-legado.pdf',
  '04-CARTOES-DE-ORACAO\cartoes-frente-e-verso.pdf',
  '05-CALENDARIO-MARIANO\calendario-um-ano-com-maria.pdf',
  '06-NOVENA-E-LADAINHA\guia-nove-dias-e-ladainha.pdf',
  '07-PEQUENOS-COM-MARIA\pequenos-com-maria.pdf',
  '08-TODOS-OS-NOMES-DE-MARIA\todos-os-nomes-de-maria.pdf',
  '09-CATALOGO-VISUAL\catalogo-legado-de-fe-com-maria.pdf',
  '10-EDICAO-REUNIDA\legado-de-fe-com-maria-edicao-reunida.pdf',
  '11-VERSOES-PREENCHIVEIS\manual-preenchivel.pdf',
  '11-VERSOES-PREENCHIVEIS\caderno-preenchivel.pdf'
)

foreach ($relativePath in $requiredFiles) {
  $fullPath = Join-Path $packageRoot $relativePath
  if (-not (Test-Path -LiteralPath $fullPath)) {
    throw "Arquivo do pacote ausente: $relativePath"
  }
}

$pageExpectations = @{
  '01-MANUAL-DA-JORNADA\01-manual-legado-de-fe-com-maria.pdf' = 51
  '02-CAMINHOS-DE-MARIA\volume-1.pdf' = 31
  '02-CAMINHOS-DE-MARIA\volume-2.pdf' = 31
  '02-CAMINHOS-DE-MARIA\volume-3.pdf' = 30
  '02-CAMINHOS-DE-MARIA\volume-4.pdf' = 31
  '03-CADERNO-DO-LEGADO\caderno-do-legado.pdf' = 7
  '04-CARTOES-DE-ORACAO\cartoes-frente-e-verso.pdf' = 104
  '05-CALENDARIO-MARIANO\calendario-um-ano-com-maria.pdf' = 9
  '06-NOVENA-E-LADAINHA\guia-nove-dias-e-ladainha.pdf' = 11
  '07-PEQUENOS-COM-MARIA\pequenos-com-maria.pdf' = 6
  '08-TODOS-OS-NOMES-DE-MARIA\todos-os-nomes-de-maria.pdf' = 5
  '09-CATALOGO-VISUAL\catalogo-legado-de-fe-com-maria.pdf' = 10
  '10-EDICAO-REUNIDA\legado-de-fe-com-maria-edicao-reunida.pdf' = 174
}

foreach ($relativePath in $pageExpectations.Keys) {
  $pdfPath = Join-Path $packageRoot $relativePath
  $metadata = & pdfinfo $pdfPath
  $pagesLine = $metadata | Where-Object { $_ -match '^Pages:\s+(\d+)' }
  if (-not $pagesLine) { throw "Não foi possível contar as páginas: $relativePath" }
  $actualPages = [int]([regex]::Match($pagesLine, '\d+').Value)
  if ($actualPages -ne $pageExpectations[$relativePath]) {
    throw "Paginação divergente em ${relativePath}: esperado $($pageExpectations[$relativePath]), encontrado $actualPages"
  }
}

$cardFolder = Join-Path $packageRoot '04-CARTOES-DE-ORACAO\cartoes-individuais'
$cardCount = @(Get-ChildItem -LiteralPath $cardFolder -Filter '*.png' -File).Count
if ($cardCount -ne 52) {
  throw "Esperados 52 cartões individuais; encontrados: $cardCount"
}

Write-Output 'PASS: pacote final organizado com todos os entregáveis.'
