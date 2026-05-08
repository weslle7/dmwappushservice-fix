# Executar como ADMIN / SYSTEM

Write-Output "=== Iniciando correção do dmwappushservice ==="

# 1. Corrigir configuração do serviço
sc.exe config dmwappushservice type= share | Out-Null
sc.exe config dmwappushservice binPath= "C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p" | Out-Null
sc.exe config dmwappushservice start= auto | Out-Null
sc.exe config dmwappushservice obj= "NT AUTHORITY\LocalService" password= "" | Out-Null

Write-Output "Serviço configurado"

# 2. Garantir que a chave Svchost contém o serviço (SEM sobrescrever)
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost"
$current = (Get-ItemProperty -Path $regPath).LocalServiceNetworkRestricted

if ($current -notcontains "dmwappushservice") {
    Write-Output "Adicionando dmwappushservice ao grupo svchost..."

    $new = $current + "dmwappushservice"

    Set-ItemProperty -Path $regPath -Name LocalServiceNetworkRestricted -Value $new
} else {
    Write-Output "dmwappushservice já está no grupo svchost"
}

# 3. Reiniciar serviço
Write-Output "Reiniciando serviço..."

try {
    Stop-Service dmwappushservice -Force -ErrorAction SilentlyContinue
} catch {}

Start-Service dmwappushservice -ErrorAction SilentlyContinue

# 4. Validar status
$svc = Get-Service dmwappushservice

if ($svc.Status -eq "Running") {
    Write-Output "OK: Serviço está em execução"
} else {
    Write-Output "AVISO: Serviço não iniciou (pode exigir reboot)"
}

