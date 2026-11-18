# Cloud Kings - HR Leaver Automation
# Employee: Maze Johnson
# Ticket: CK-IAM-003

Disable-ADAccount -Identity "mjohnson"

Get-ADUser "mjohnson" -Properties Enabled |
    Select-Object Name, SamAccountName, Enabled