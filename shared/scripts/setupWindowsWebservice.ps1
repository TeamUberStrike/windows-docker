# Install IIS with typical features + HTTP Activation
Enable-WindowsOptionalFeature -Online -FeatureName `
    IIS-WebServerRole, `
    IIS-WebServer, `
    IIS-CommonHttpFeatures, `
    IIS-StaticContent, `
    IIS-DefaultDocument, `
    IIS-DirectoryBrowsing, `
    IIS-HttpErrors, `
    IIS-ApplicationDevelopment, `
    IIS-ASPNET45, `
    IIS-NetFxExtensibility45, `
    IIS-ISAPIExtensions

Install-WindowsFeature `
    Net-Framework-Core, `
    IIS-ManagementConsole, `
    NET-HTTP-Activation, `
    NET-WCF-HTTP-Activation45

# Create site directory
$sitePath = "C:\production\Artifacts\UberStrike.DataCenter.WebService"
New-Item -Path $sitePath -ItemType Directory -Force

# Create app pool
New-WebAppPool -Name "UberStrikeAppPool"

# Create website
New-Website -Name "UberStrikeWebService" -Port 80 -PhysicalPath $sitePath -ApplicationPool "UberStrikeAppPool"

Stop-Website "Default Web Site"
Start-Website -Name "UberStrikeWebService"

