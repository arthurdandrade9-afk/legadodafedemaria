$ErrorActionPreference = 'Stop'
$siteRoot = Split-Path -Parent $PSScriptRoot
$htmlPath = Join-Path $siteRoot 'dist\index.html'
$html = Get-Content -Raw -LiteralPath $htmlPath
$vitrinePath = Join-Path $siteRoot 'dist\vitrine.html'
if (Test-Path -LiteralPath $vitrinePath) {
  $html += Get-Content -Raw -LiteralPath $vitrinePath
}

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
  'class="section demonstracao"',
  'Veja por dentro do Legado de Fé com Maria',
  'assets/preview-manual-inside.png',
  'assets/preview-caminhos-inside.png',
  'Cada título vai além do nome',
  '12 entregáveis + 1 edição reunida',
  'Mais de 300 páginas de conteúdo',
  '51 páginas no manual principal',
  '60 campos preenchíveis',
  '104 páginas de cartões',
  '52 cartões individuais',
  'class="section vitrine"',
  'class="deliverable-showcase"',
  'data-deliverable="manual"',
  'data-deliverable="volume-1"',
  'data-deliverable="volume-2"',
  'data-deliverable="volume-3"',
  'data-deliverable="volume-4"',
  'data-deliverable="caderno"',
  'data-deliverable="cartoes"',
  'data-deliverable="calendario"',
  'data-deliverable="novena"',
  'data-deliverable="pequenos"',
  'data-deliverable="catalogo"',
  'data-deliverable="nomes-de-maria"',
  'id="preview-dialog"'
)

foreach ($marker in $requiredMarkers) {
  if (-not $html.Contains($marker)) {
    throw "Marcador obrigatório ausente: $marker"
  }
}

$deliverableCount = ([regex]::Matches($html, 'data-deliverable="[^"]+"')).Count
if ($deliverableCount -ne 12) {
  throw "Esperados 12 entregáveis demonstrados; encontrados: $deliverableCount"
}

$previewCount = ([regex]::Matches($html, 'class="preview-shot')).Count
if ($previewCount -lt 35) {
  throw "Esperadas pelo menos 35 prévias reais; encontradas: $previewCount"
}

$imageMatches = [regex]::Matches($html, '<img[^>]+src="([^"]+)"[^>]+alt="([^"]+)"')
foreach ($match in $imageMatches) {
  $src = $match.Groups[1].Value
  $alt = $match.Groups[2].Value.Trim()
  if ([string]::IsNullOrWhiteSpace($alt)) {
    throw "Imagem sem descrição: $src"
  }
  if ($src.StartsWith('assets/')) {
    $assetPath = Join-Path $siteRoot (Join-Path 'dist' $src.Replace('/', '\'))
    if (-not (Test-Path -LiteralPath $assetPath)) {
      throw "Recurso referenciado e ausente: $src"
    }
  }
}

if ($html.Contains('12 encontros + 4 volumes<br>+ kit de bônus')) {
  throw 'A promessa genérica antiga ainda está no hero.'
}

Write-Output 'PASS: contrato Santuário em Casa atendido.'
