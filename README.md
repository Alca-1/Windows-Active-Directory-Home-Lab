# Windows Active Directory Home Lab on Proxmox

A hands-on Windows infrastructure lab built in Proxmox to practice Active Directory, DNS, Group Policy, file permissions, PowerShell automation, delegated administration, least privilege, and Windows LAPS.

## Environment

| System | Role | Operating System | IP Address |
|---|---|---|---|
| DC01 | Domain Controller, DNS, File Server | Windows Server 2022 | 192.168.20.20 |
| CLIENT01 | Domain Workstation | Windows 11 Pro | DHCP / 192.168.20.100 |

**Domain:** `adlab.test`  
**Lab Network:** `192.168.20.0/24`

## Technologies

- Active Directory Domain Services
- DNS
- Group Policy
- Windows LAPS
- PowerShell
- RSAT
- SMB / NTFS permissions
- Proxmox VE
- Windows 11 Pro
- Windows Server 2022


## Active Directory

The domain was structured with separate Organizational Units for users, computers, and administrative accounts.

![Active Directory Structure](screenshots/ad-ou-structure.png)

![Active Directory Groups](screenshots/ad-groups.png)

Security groups were used for departmental access, helpdesk delegation, and LAPS permissions.

File access follows the AGDLP model:

```text
Account → Global Group → Domain Local Group → Permission
```

Example:

```text
IT User
   ↓
GG_IT_Users
   ↓
FS_IT_RW
   ↓
\\DC01\IT
```

![A users membership in a group](screenshots/user-member-gg.png)

![AGDLP Group Membership](screenshots/domain-local-group.png)