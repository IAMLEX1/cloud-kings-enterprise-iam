
Import-Module ActiveDirectory
$ErrorActionPreference = "Stop"

# Approved HR transfer request
$username = "mjohnson"
$newDepartment = "Engineering"
$newTitle = "Cloud Engineer"

$engineeringOU = "OU=Engineering,OU=Cloud Kings Tech LLC,DC=cyberarklab,DC=local"

$oldGroups = @(
    "GG-CK-IT",
    "GG-CK-IT-Support"
)

$newGroups = @(
    "GG-CK-Engineering",
    "GG-CK-Cloud-Engineers"
)

try {
    $user = Get-ADUser -Identity $username -Properties MemberOf

    # Validate destination before making changes
    Get-ADOrganizationalUnit -Identity $engineeringOU | Out-Null

    foreach ($group in ($oldGroups + $newGroups)) {
        Get-ADGroup -Identity $group | Out-Null
    }

    # Update employee attributes
    Set-ADUser -Identity $username `
        -Department $newDepartment `
        -Title $newTitle

    # Move employee into Engineering OU
    Move-ADObject `
        -Identity $user.DistinguishedName `
        -TargetPath $engineeringOU

    # Remove previous job access
    foreach ($group in $oldGroups) {
        Remove-ADGroupMember -Identity $group `
            -Members $username -Confirm:$false
    }

    # Assign new job access
    foreach ($group in $newGroups) {
        Add-ADGroupMember -Identity $group -Members $username
    }

    Write-Host "MOVER COMPLETED: $username" -ForegroundColor Green
    Write-Host "Department: $newDepartment"
    Write-Host "Title: $newTitle"
    Write-Host "Old IT groups removed; Engineering groups assigned."
}
catch {
    Write-Host "MOVER FAILED: $($_.Exception.Message)" -ForegroundColor Red
}
