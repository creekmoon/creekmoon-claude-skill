@echo off
chcp 65001 >nul 2>&1
setlocal
set "_s=%~f0"
set "_t=%TEMP%\csk_%RANDOM%.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$f=[System.IO.File]::ReadAllLines('%_s%');$i=0;foreach($l in $f){if($l -eq '##PS##'){break};$i++};$ps=($f[($i+1)..($f.Length-1)]) -join [System.Environment]::NewLine;[System.IO.File]::WriteAllText('%_t%',$ps,[System.Text.Encoding]::UTF8)"
powershell -NoProfile -ExecutionPolicy Bypass -File "%_t%"
del "%_t%" 2>nul
exit /b
##PS##
# =============================================================
# Creekmoon Claude Skill Installer
# =============================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "SilentlyContinue"
$Host.UI.RawUI.WindowTitle = "Creekmoon Skill Installer"

function cw {
    param([string]$t, [string]$c = "White", [switch]$n)
    if ($n) { Write-Host $t -ForegroundColor $c -NoNewline }
    else     { Write-Host $t -ForegroundColor $c }
}

function Get-Ver([string]$txt) {
    if ($txt -match '(?m)^version:\s*(.+)$') { return $Matches[1].Trim() }
    return "N/A"
}

function Write-Sep { cw ("-" * 68) DarkGray }

# ----------------------------------------------------------------
Clear-Host
cw ("=" * 68) Cyan
cw "  Creekmoon Claude Skill Installer" Cyan
cw ("=" * 68) Cyan
Write-Host ""

# ================================================================
# Step 0  连通性检测
# ================================================================
cw "[ Step 0 ]  检测仓库连通性" Yellow
Write-Host ""

$SRC = [ordered]@{
    GitHub = @{
        raw   = "https://raw.githubusercontent.com/creekmoon/creekmoon-claude-skill/master"
        clone = "https://github.com/creekmoon/creekmoon-claude-skill.git"
        api   = "https://api.github.com/repos/creekmoon/creekmoon-claude-skill/contents"
        ms    = [int]::MaxValue; ok = $false
    }
    Gitee = @{
        raw   = "https://gitee.com/creekmoon/creekmoon-claude-skill/raw/master"
        clone = "https://gitee.com/creekmoon/creekmoon-claude-skill.git"
        api   = "https://gitee.com/api/v5/repos/creekmoon/creekmoon-claude-skill/contents"
        ms    = [int]::MaxValue; ok = $false
    }
}

foreach ($name in $SRC.Keys) {
    $s = $SRC[$name]
    try {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $null = Invoke-WebRequest "$($s.raw)/README.md" -UseBasicParsing -TimeoutSec 8
        $sw.Stop()
        $s.ok = $true; $s.ms = [int]$sw.ElapsedMilliseconds
        cw ("  [OK]   {0,-8}  {1} ms" -f $name, $s.ms) Green
    } catch {
        cw ("  [FAIL] {0,-8}  连接失败" -f $name) Red
    }
}

$best = $SRC.GetEnumerator() | Where-Object { $_.Value.ok } | Sort-Object { $_.Value.ms } | Select-Object -First 1
if (-not $best) {
    Write-Host ""
    cw "  错误：无法连接到任何仓库，请检查网络后重试。" Red
    Read-Host "`n按 Enter 退出"; exit 1
}

$rawBase  = $best.Value.raw
$cloneUrl = $best.Value.clone
$apiUrl   = $best.Value.api
Write-Host ""
cw ("  -> 使用 {0}（延迟 {1} ms）" -f $best.Key, $best.Value.ms) Cyan

# ================================================================
# Step 1  选择安装位置
# ================================================================
Write-Host ""; Write-Sep
cw "[ Step 1 ]  选择安装位置" Yellow
Write-Host ""
cw ("  [1]  全局安装   ->  {0}\.claude\skills" -f $env:USERPROFILE) White
cw ("  [2]  当前目录   ->  {0}\.claude\skills" -f (Get-Location)) White
Write-Host ""

$pick = ""
while ($pick -ne "1" -and $pick -ne "2") {
    $pick = (Read-Host "  请选择 (1/2)").Trim()
}

$targetDir = if ($pick -eq "1") {
    cw "  -> 已选择：全局安装" Cyan
    Join-Path $env:USERPROFILE ".claude\skills"
} else {
    cw "  -> 已选择：当前目录" Cyan
    Join-Path (Get-Location) ".claude\skills"
}

# ================================================================
# Step 2  Skill 列表 & 版本对比
# ================================================================
Write-Host ""; Write-Sep
cw "[ Step 2 ]  获取 Skill 列表及版本信息..." Yellow
Write-Host ""

# 从远程 API 动态获取目录列表
$dirs = @()
try {
    $json = (Invoke-WebRequest $apiUrl -UseBasicParsing -Headers @{"User-Agent"="creekmoon-installer/1.0"} -TimeoutSec 10).Content
    $dirs = ($json | ConvertFrom-Json) |
            Where-Object { $_.type -eq "dir" -and $_.name -match "^creekmoon-" } |
            Select-Object -ExpandProperty name
} catch {}

if ($dirs.Count -eq 0) {
    cw "  (远程 API 不可用，使用内置列表)" DarkGray
    $dirs = @(
        "creekmoon-apidoc-spec",
        "creekmoon-cerydra-codify",
        "creekmoon-code-style",
        "creekmoon-lightcone-memory",
        "creekmoon-prd-spec",
        "creekmoon-trd-spec",
        "creekmoon-weekly-report"
    )
}

$skillList = [System.Collections.Generic.List[pscustomobject]]::new()
$idx = 0
foreach ($d in $dirs) {
    $idx++
    cw ("  [{0:D2}] {1} ..." -f $idx, $d) DarkGray -n

    $rv = "N/A"; $lv = "未安装"
    try {
        $rv = Get-Ver (Invoke-WebRequest "$rawBase/$d/SKILL.md" -UseBasicParsing -TimeoutSec 10).Content
    } catch {}

    $lp = Join-Path $targetDir "$d\SKILL.md"
    if (Test-Path $lp) { $lv = Get-Ver (Get-Content $lp -Raw) }

    $st = if ($lv -eq "未安装")     { "[new]"    }
          elseif ($lv -eq $rv)       { "[ok]"     }
          else                       { "[update]" }

    $stColor = if ($st -eq "[ok]") {"Green"} elseif ($st -eq "[update]") {"Yellow"} else {"Gray"}
    cw "  $st" $stColor

    $skillList.Add([pscustomobject]@{ i=$idx; d=$d; rv=$rv; lv=$lv; st=$st })
}

# 渲染表格
Write-Host ""
$hdr = "{0,-4} {1,-34} {2,-12} {3,-14} {4}" -f "#", "Skill 名称", "远程版本", "已安装版本", "状态"
$sep68 = "-" * 68
cw $sep68 DarkGray
cw $hdr White
cw $sep68 DarkGray
foreach ($s in $skillList) {
    $c = if ($s.st -eq "[ok]") {"Green"} elseif ($s.st -eq "[update]") {"Yellow"} else {"Gray"}
    cw ("{0,-4} {1,-34} {2,-12} {3,-14} {4}" -f $s.i, $s.d, $s.rv, $s.lv, $s.st) $c
}
cw $sep68 DarkGray

# ================================================================
# Step 3  选择并安装
# ================================================================
Write-Host ""; Write-Sep
cw "[ Step 3 ]  选择要安装 / 更新的 Skill" Yellow
Write-Host ""
cw "  序号（逗号分隔）| A = 全选 | Q = 退出       示例: 1,3,5  或  A" DarkGray
Write-Host ""

$raw = ""
while ([string]::IsNullOrWhiteSpace($raw)) { $raw = (Read-Host "  请输入").Trim() }

if ($raw -match '^[Qq]$') {
    Write-Host ""; cw "  已退出，未安装任何内容。" Gray
    Read-Host "`n按 Enter 退出"; exit 0
}

$todo = [System.Collections.Generic.List[pscustomobject]]::new()
if ($raw -match '^[Aa]$') {
    $skillList | ForEach-Object { $todo.Add($_) }
} else {
    $nums = @($raw -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ })
    $skillList | Where-Object { $_.i -in $nums } | ForEach-Object { $todo.Add($_) }
}

if ($todo.Count -eq 0) {
    Write-Host ""; cw "  未选中任何 Skill，退出。" Gray
    Read-Host "`n按 Enter 退出"; exit 0
}

Write-Host ""; cw "  将安装以下 Skill：" Cyan
$todo | ForEach-Object { cw ("    - {0}" -f $_.d) White }
Write-Host ""

# 检查 git 是否可用
$gitOk = $false
try { $null = git --version 2>&1; $gitOk = ($LASTEXITCODE -eq 0) } catch {}

$tmp = Join-Path $env:TEMP ("csk_" + (Get-Random))

if ($gitOk) {
    cw "  正在 clone 仓库（首次可能稍慢）..." Yellow
    git clone --depth 1 $cloneUrl $tmp 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        cw "  git clone 失败，改用 HTTP 逐文件下载..." Yellow
        $gitOk = $false
    } else {
        cw "  clone 完成" Green
    }
}

if (-not $gitOk) {
    New-Item -ItemType Directory $tmp -Force | Out-Null
    cw "  通过 HTTP 下载 Skill 文件..." Yellow
    foreach ($s in $todo) {
        $st = Join-Path $tmp $s.d; New-Item -ItemType Directory $st -Force | Out-Null
        try {
            $content = (Invoke-WebRequest "$rawBase/$($s.d)/SKILL.md" -UseBasicParsing -TimeoutSec 15).Content
            [System.IO.File]::WriteAllText("$st\SKILL.md", $content, [System.Text.Encoding]::UTF8)
            cw ("    [OK]   {0}" -f $s.d) Green
        } catch {
            cw ("    [FAIL] {0}" -f $s.d) Red
        }
    }
}

# 确保目标目录存在
if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory $targetDir -Force | Out-Null }

# 复制 Skill 到目标目录
Write-Host ""; cw "  安装中..." Yellow
$okCount = 0
foreach ($s in $todo) {
    $from = Join-Path $tmp $s.d
    $to   = Join-Path $targetDir $s.d
    if (Test-Path $from) {
        if (Test-Path $to) { Remove-Item $to -Recurse -Force -ErrorAction SilentlyContinue }
        Copy-Item $from $to -Recurse -Force
        cw ("  [OK]   {0}" -f $s.d) Green
        $okCount++
    } else {
        cw ("  [SKIP] {0}  (源文件未找到)" -f $s.d) Yellow
    }
}

Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
cw ("=" * 68) Cyan
cw ("  完成！成功安装 {0} / {1} 个 Skill" -f $okCount, $todo.Count) Cyan
cw ("  安装路径：{0}" -f $targetDir) Cyan
cw ("=" * 68) Cyan
Write-Host ""
Read-Host "按 Enter 退出"
