$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot
$productRoot = Resolve-Path (Join-Path $siteRoot '..\outputs\legado-de-fe-com-maria')
$previewRoot = Join-Path $siteRoot 'dist\assets\previews'
New-Item -ItemType Directory -Force -Path $previewRoot | Out-Null

function Export-PdfPage {
  param(
    [Parameter(Mandatory)] [string] $Pdf,
    [Parameter(Mandatory)] [int] $Page,
    [Parameter(Mandatory)] [string] $Name
  )
  $source = Join-Path $productRoot $Pdf
  $target = Join-Path $previewRoot $Name
  & pdftoppm -singlefile -jpeg -jpegopt 'quality=88,progressive=y,optimize=y' -r 120 -f $Page -l $Page $source $target
  if ($LASTEXITCODE -ne 0) { throw "Falha ao gerar prévia: $Pdf página $Page" }
}

$jobs = @(
  @('01-manual-legado-de-fe-com-maria.pdf', 1, 'manual-01-capa'),
  @('01-manual-legado-de-fe-com-maria.pdf', 4, 'manual-02-mapa'),
  @('01-manual-legado-de-fe-com-maria.pdf', 5, 'manual-03-abertura'),
  @('01-manual-legado-de-fe-com-maria.pdf', 14, 'manual-04-encontro'),
  @('01-manual-legado-de-fe-com-maria.pdf', 15, 'manual-05-registro'),
  @('01-manual-legado-de-fe-com-maria.pdf', 47, 'manual-06-legado'),
  @('02-caminhos-de-maria-volume-1.pdf', 1, 'volume-1-01-capa'),
  @('02-caminhos-de-maria-volume-1.pdf', 3, 'volume-1-02-interno'),
  @('02-caminhos-de-maria-volume-1.pdf', 14, 'volume-1-03-interno'),
  @('03-caminhos-de-maria-volume-2.pdf', 1, 'volume-2-01-capa'),
  @('03-caminhos-de-maria-volume-2.pdf', 3, 'volume-2-02-interno'),
  @('03-caminhos-de-maria-volume-2.pdf', 14, 'volume-2-03-interno'),
  @('04-caminhos-de-maria-volume-3.pdf', 1, 'volume-3-01-capa'),
  @('04-caminhos-de-maria-volume-3.pdf', 3, 'volume-3-02-interno'),
  @('04-caminhos-de-maria-volume-3.pdf', 14, 'volume-3-03-interno'),
  @('05-caminhos-de-maria-volume-4.pdf', 1, 'volume-4-01-capa'),
  @('05-caminhos-de-maria-volume-4.pdf', 3, 'volume-4-02-interno'),
  @('05-caminhos-de-maria-volume-4.pdf', 14, 'volume-4-03-interno'),
  @('06-caderno-do-legado.pdf', 1, 'caderno-01-capa'),
  @('06-caderno-do-legado.pdf', 2, 'caderno-02-interno'),
  @('06-caderno-do-legado.pdf', 4, 'caderno-03-interno'),
  @('08-calendario-um-ano-com-maria.pdf', 1, 'calendario-01-capa'),
  @('08-calendario-um-ano-com-maria.pdf', 2, 'calendario-02-interno'),
  @('08-calendario-um-ano-com-maria.pdf', 5, 'calendario-03-interno'),
  @('09-guia-nove-dias-e-ladainha.pdf', 1, 'novena-01-capa'),
  @('09-guia-nove-dias-e-ladainha.pdf', 2, 'novena-02-interno'),
  @('09-guia-nove-dias-e-ladainha.pdf', 5, 'novena-03-interno'),
  @('10-pequenos-com-maria.pdf', 1, 'pequenos-01-capa'),
  @('10-pequenos-com-maria.pdf', 2, 'pequenos-02-interno'),
  @('10-pequenos-com-maria.pdf', 4, 'pequenos-03-interno'),
  @('11-catalogo-legado-de-fe-com-maria.pdf', 1, 'catalogo-01-capa'),
  @('11-catalogo-legado-de-fe-com-maria.pdf', 2, 'catalogo-02-interno'),
  @('11-catalogo-legado-de-fe-com-maria.pdf', 6, 'catalogo-03-interno'),
  @('11-catalogo-legado-de-fe-com-maria.pdf', 10, 'catalogo-04-interno'),
  @('11-todos-os-nomes-de-maria-piloto.pdf', 1, 'nomes-01-capa'),
  @('11-todos-os-nomes-de-maria-piloto.pdf', 2, 'nomes-02-como-ler'),
  @('11-todos-os-nomes-de-maria-piloto.pdf', 3, 'nomes-03-remedios'),
  @('11-todos-os-nomes-de-maria-piloto.pdf', 4, 'nomes-04-perpetuo-socorro'),
  @('11-todos-os-nomes-de-maria-piloto.pdf', 5, 'nomes-05-aparecida')
)

foreach ($job in $jobs) {
  Export-PdfPage -Pdf $job[0] -Page $job[1] -Name $job[2]
}

foreach ($card in 1, 9, 21, 28, 40, 52) {
  $number = $card.ToString('00')
  Copy-Item -LiteralPath (Join-Path $productRoot "cartoes-individuais\cartao-$number.png") -Destination (Join-Path $previewRoot "cartao-$number.png") -Force
}

Write-Output "Prévias geradas: $(@($jobs).Count + 6)"
