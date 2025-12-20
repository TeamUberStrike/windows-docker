# Install IIS with typical features + HTTP Activation
Enable-WindowsOptionalFeature -Online -FeatureName @(
    "IIS-WebServerRole",
    "IIS-WebServer",
    "IIS-CommonHttpFeatures",
    "IIS-StaticContent",
    "IIS-DefaultDocument",
    "IIS-DirectoryBrowsing",
    "IIS-HttpErrors",
    "IIS-ApplicationDevelopment",
    "IIS-ASPNET45",
    "IIS-NetFxExtensibility45",
    "IIS-ISAPIExtensions"
) -All

Install-WindowsFeature `
    Net-Framework-Core, `
    NET-HTTP-Activation, `
    NET-WCF-HTTP-Activation45


$sharedPath = Join-Path $env:USERPROFILE "Desktop\Shared\production"
$productionPath = "C:\production"
New-Item -Path $productionPath -ItemType Directory -Force

if (Test-Path -Path $sharedPath -PathType Container) {
    Copy-Item "$sharedPath\*" $productionPath -Recurse -Force
}
else {
    Write-Error "Source directory does not exist: $sharedPath"
    exit 1
}

$webservicePath = Join-Path $productionPath "Artifacts\UberStrike.DataCenter.WebService"
if (-not (Test-Path $webservicePath)) {
  Write-Error "webservice directory missing: $webservicePath"
  exit 1
}

$webserviceName = "UberStrikeWebService"

if (Get-Website -Name $webserviceName -ErrorAction SilentlyContinue) {
    Write-Host "Website '$webserviceName' already exists. Exiting script."
    exit
}

if (Get-Website -Name "Default Web Site" -ErrorAction SilentlyContinue) {
    Remove-Website -Name "Default Web Site"
}

# Create app pool
New-WebAppPool -Name "UberStrikeAppPool"

# Create website
New-Website -Name "UberStrikeWebService" -Port 80 -PhysicalPath $webservicePath -ApplicationPool "UberStrikeAppPool"

Start-Website -Name $webseriveName

