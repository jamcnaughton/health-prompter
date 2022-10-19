[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
$Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
Write-Output "Health Prompter"
$count = 0
while (1) {
    $count++
    $wsh = New-Object -ComObject WScript.Shell
    $wsh.SendKeys('+{F15}')
    if ($count -eq 30) {
        $RawXml = [xml] $Template.GetXml()
        ($RawXml.toast.visual.binding.text|where {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode("Health Prompter [$(Get-Date)]")) > $null
        ($RawXml.toast.visual.binding.text|where {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode("Stand up, walk around and rest your eyes.")) > $null
        $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $SerializedXml.LoadXml($RawXml.OuterXml)
        $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
        $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)
        $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
        $Notifier.Show($Toast);
        $count = 0
        Write-Output "[$(Get-Date)] Stand up, walk around and rest your eyes."
    }
    Start-Sleep -seconds 59
} 