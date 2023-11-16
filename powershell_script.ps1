# working powershell script 
$collection = '
[
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
'

$baseRegistryPath = "HKLM:\"
$compliant = 0
$nonComplaint = 0

$collectionObject = ConvertFrom-Json $collection

foreach ($item in $collectionObject) {
  $PathParts = ($item.Path).Split(":")
  $expectedValue = $item.ExpectedValue

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

Write-Host "Completed CIS Checks`nRESULT: $compliant compliant and $nonComplaint non-compliant items"
