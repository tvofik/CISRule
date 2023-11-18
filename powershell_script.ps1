# working powershell script 
$collection = '
{
  "Version": "v2.0.0",
  "Checks": [
    {
      "Path": "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System:DontDisplayLastUserName",
      "ExpectedValue": 0
    },
    {
      "Path":"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System:EnableLUA",
      "ExpectedValue": 1
    },
    {
      "Path": "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System:EnableUwpStartupTasks",
      "ExpectedValue": 2
    },
    {
      "Path": "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System:EnableCursorSuppression",
      "ExpectedValue": 1
    },
    {
      "Path": "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System:ConsentPromptBehaviorAdmin",
      "ExpectedValue": 5
    }
  ]
}
'

$baseRegistryPath = "HKLM:\"
$compliant = 0
$nonComplaint = 0

$collectionObject = ConvertFrom-Json $collection

$version = $collectionObject.Version

foreach ($check in $collectionObject.Checks) {
  $PathParts = ($check.Path).Split(":")
  $expectedValue = $check.ExpectedValue

  $registryPath = $PathParts[0]
  $propertyName = $PathParts[-1]

  $fullregistryPath = $baseRegistryPath + $registryPath.Trim()
    
  $result = (Get-ItemProperty -Path $fullregistryPath).$propertyName

  if ($result -eq $expectedValue) {
    $compliant++
  }
  else {
    $nonComplaint++
  }
}

Write-Host "Completed CIS Checks $version`nRESULT: $compliant compliant and $nonComplaint non-compliant items"