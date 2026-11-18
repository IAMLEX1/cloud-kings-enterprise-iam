Import-Module ActiveDirectory
$ErrorActionPreference = "Stop"

$employees = Import-Csv "C:\CloudKings\HR-Intake\NewHires.csv"

$departments = @{
    IT = @{
        OU = "OU=IT,OU=Cloud Kings Tech LLC,DC=cyberarklab,DC=local"
        Group = "GG-CK-IT"
    }
    FINANCE = @{
        OU = "OU=Finance,OU=Cloud Kings Tech LLC,DC=cyberarklab,DC=local"
        Group = "GG-CK-Finance"
    }
}

foreach ($employee in $employees) {
    $username = $employee.Username.Trim()
    $department = $employee.Department.Trim().ToUpper()

    try {
        if ([string]::IsNullOrWhiteSpace($username) -or
            [string]::IsNullOrWhiteSpace($employee.FirstName) -or
            [string]::IsNullOrWhiteSpace($employee.LastName) -or
            [string]::IsNullOrWhiteSpace($employee.JobTitle)) {
            throw "Missing required employee information."
        }

        if (-not $departments.ContainsKey($department)) {
            throw "Unknown department: $department"
        }

        if (Get-ADUser -Filter "SamAccountName -eq '$username'") {
            Write-Host "SKIPPED: $username already exists."
            continue
        }

        $mapping = $departments[$department]

        New-ADUser `
            -Name "$($employee.FirstName) $($employee.LastName)" `
            -GivenName $employee.FirstName `
            -Surname $employee.LastName `
            -SamAccountName $username `
            -UserPrincipalName "$username@cyberarklab.local" `
            -Department $department `
            -Title $employee.JobTitle `
            -Company "Cloud Kings Tech LLC" `
            -Path $mapping.OU `
            -Enabled $false

        Add-ADGroupMember -Identity $mapping.Group -Members $username

        Add-ADGroupMember -Identity "GG-CloudKings-EntraSync" -Members $username

        Write-Host "CREATED (DISABLED): $username" -ForegroundColor Green

    }
    catch {
        Write-Host "FAILED: $username - $($_.Exception.Message)" -ForegroundColor Red
    }
}