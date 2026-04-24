$salida = "C:\P09\ultimos_10_fallos_autenticacion.txt"
$inicio = (Get-Date).AddHours(-4)

New-Item -ItemType Directory -Path "C:\P09" -Force | Out-Null

$ids = 4625, 4771, 4776

$eventos = Get-WinEvent -FilterHashtable @{
    LogName   = 'Security'
    Id        = $ids
    StartTime = $inicio
} -ErrorAction SilentlyContinue |
Sort-Object TimeCreated -Descending |
Select-Object -First 10

if (-not $eventos) {
    "No se encontraron eventos recientes de fallo de autenticación." |
        Out-File -FilePath $salida -Encoding UTF8
}
else {
    foreach ($e in $eventos) {
        @"
Fecha: $($e.TimeCreated)
ID: $($e.Id)
Proveedor: $($e.ProviderName)
Mensaje:
$($e.Message)
------------------------------------------------------------
"@ | Out-File -FilePath $salida -Encoding UTF8 -Append
    }
}

Write-Host "Reporte generado en: $salida"