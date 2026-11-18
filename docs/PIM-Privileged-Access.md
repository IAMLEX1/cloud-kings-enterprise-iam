
# Cloud Kings Enterprise IAM
## Microsoft Entra Privileged Identity Management (PIM)

### 1. Project Overview

**Technology:** Microsoft Entra ID Privileged Identity Management (PIM)  
**Environment:** Lex1 Directory (previous hands-on environment)  
**Privileged User:** Daniel James  
**Role:** User Administrator  
**Access Model:** Just-in-Time (JIT) Privileged Access

### 2. Business Scenario

Daniel James is an IAM administrator who requires temporary User Administrator privileges to perform approved identity administration tasks.

Instead of granting permanent privileged access, Microsoft Entra PIM allows Daniel to activate the role only when required.

**Security objectives:**
- Enforce least-privilege access.
- Reduce standing administrative privileges.
- Require MFA and justification for activation.
- Limit privileged access duration.
- Support auditing and accountability.

### 3. PIM Configuration

The following settings were configured:

| Setting | Configuration |
|---|---|
| Privileged role | User Administrator |
| Assignment type | Eligible |
| Eligibility duration | 1 month |
| Activation maximum duration | 8 hours |
| MFA on activation | Required |
| Justification on activation | Required |
| Approval on activation | Not required |
| Permanent eligible assignment | Disabled |
| Permanent active assignment | Disabled |

Daniel received an eligible User Administrator role assignment for April 30–May 30, 2026.

### 4. Just-in-Time Role Activation

Daniel accessed Microsoft Entra PIM and activated his eligible User Administrator role.

**Verified activation details:**
- User: Daniel James
- Role: User Administrator
- Directory: Lex1
- Activation: April 30, 2026, 20:17 UTC
- Scheduled expiration: May 1, 2026, 04:17 UTC
- Duration: 8 hours
- Justification: Performing user administration tasks using Just-in-time privileged access

The activation notification and the PIM Active assignments screen confirm successful activation.

### 5. Automatic Expiration and Deactivation

Microsoft Entra PIM automatically expires an activated role when its configured activation duration ends.

An administrator can also deactivate their own active role early using the PIM portal.

**Microsoft Graph PowerShell example (not executed in this exercise):**

```powershell
Connect-MgGraph -Scopes "RoleAssignmentSchedule.ReadWrite.Directory"

$params = @{
    action = "selfDeactivate"
    principalId = "<Daniel-Object-ID>"
    roleDefinitionId = "<User-Administrator-Role-ID>"
    directoryScopeId = "/"
    justification = "Privileged task completed"
}

New-MgRoleManagementDirectoryRoleAssignmentScheduleRequest `
    -BodyParameter $params
```

This example illustrates early deactivation of an active role assignment. It requires the appropriate authenticated user context and an existing active assignment.

**Evidence limitation:** The screenshots confirm successful activation and its scheduled end time, but do not independently verify the expiration or early deactivation event.

### 6. Auditing and Compliance

IAM engineers can investigate privileged access using:

- Microsoft Entra PIM activation history.
- Microsoft Entra audit logs.
- Role assignment and activation notifications.
- Activation timestamps and justification.
- Role assignment expiration records.

**Audit questions:**
1. Who received privileged access?
2. Which privileged role was assigned?
3. Who activated the role?
4. When was it activated?
5. Why was the access needed?
6. When was access scheduled to expire?

These controls support privileged access governance and audit investigations.

### 7. Evidence

Store the following screenshots under `evidence/PIM/`:

1. `01-Eligible-Assignment.png`
2. `02-Eligible-Role.png`
3. `03-Activation-Requirements.png`
4. `04-Role-Activated.png`
5. `05-Activation-Notification.png`

These screenshots were captured in the earlier Lex1 directory.

### 8. Interview Explanation

"I configured Microsoft Entra Privileged Identity Management for the User Administrator role.

I assigned Daniel James eligible access instead of permanent administrative privileges.

I configured MFA and justification requirements, along with an eight-hour activation limit.

Daniel successfully activated the role, and I captured the active assignment and activation notification as evidence.

This exercise demonstrated just-in-time privileged access, least privilege, and time-limited administrative access."

### 9. Troubleshooting Knowledge

**Scenario:** An eligible administrator cannot activate their privileged role.

Investigation steps:

1. Confirm the eligible assignment exists and has not expired.
2. Check whether MFA requirements are satisfied.
3. Review any required approval or Conditional Access controls.
4. Inspect PIM activation history and Entra audit logs.
5. Verify the role becomes active after successful activation.

**Expected result:** The administrator can activate approved privileges for a limited period without receiving permanent privileged access.

### 10. Project Status

- PIM role configuration: Completed
- Eligible role assignment: Completed
- MFA and justification requirements: Configured
- Successful JIT activation: Verified
- Activation notification: Verified
- Automatic expiration: Documented conceptually
- Early deactivation PowerShell: Example only
- Audit investigation: Documented conceptually

**Conclusion:** This exercise demonstrates hands-on configuration and successful activation of time-limited privileged access using Microsoft Entra PIM.
