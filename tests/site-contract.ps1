$ErrorActionPreference = 'Stop'
$siteRoot = Split-Path -Parent $PSScriptRoot
$htmlPath = Join-Path $siteRoot 'dist\index.html'
$html = Get-Content -Raw -LiteralPath $htmlPath

$requiredMarkers = @(
  'class="hero santuario"',
  'Faça da sua casa um lugar onde a fé permanece.',
  'assets/maria-hero.png',
  'assets/maria-offer.png',
  'id="materiais"',
  'id="comprar"',
  'prefers-reduced-motion',
  'aria-label="Navegação principal"',
  '52 títulos',
  'class="section mockups"',
  'assets/mockup-collection.png',
  'assets/mockup-tools.png',
  'sacred-ornament',
  'hero-product-proof',
  'assets/hero-complete-collection.png',
  '12 encontros + 4 volumes<br>+ kit de bônus'
)

foreach ($marker in $requiredMarkers) {
  if (-not $html.Contains($marker)) {
    throw "Marcador obrigatório ausente: $marker"
  }
}

$assets = @('maria-hero.png', 'maria-offer.png', 'product-manual.png', 'product-collection.png', 'product-tools.png', 'mockup-collection.png', 'mockup-tools.png', 'hero-complete-collection.png')
foreach ($asset in $assets) {
  $assetPath = Join-Path $siteRoot "dist\assets\$asset"
  if (-not (Test-Path -LiteralPath $assetPath)) {
    throw "Recurso obrigatório ausente: $asset"
  }
}

Write-Output 'PASS: contrato Santuário em Casa atendido.'
