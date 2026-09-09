Import-Module ActiveDirectory

# Path to CSV file
$CsvPath = "<Path to your CSV file>"

$Domain = "adlab.test"

$Password = Read-Host "Enter temporary password for new users" -AsSecureString

# Import users
$Users = Import-Csv -Path $CsvPath

foreach ($User in $Users) {
    $FirstName  = $User.FirstName
    $LastName   = $User.LastName
    $Username   = $User.Username
    $Department = $User.Department
    $Group      = $User.Group

    # Select OU based on department
    switch ($Department) {
        "IT" {
            $OU = "OU=IT,OU=Lab-users,DC=adlab,DC=test"
        }
        "HR" {
            $OU = "OU=HR,OU=Lab-users,DC=adlab,DC=test"
        }

        default {
            Write-Warning "Unknown department '$Department' for $Username. Skipping user."
            continue
        }
    }

    # Check if user already exists
    $ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue

    if ($ExistingUser) {
        Write-Host "User $Username already exists - skipping."
    }
    else {
        Write-Host "Creating user: $Username"
        New-ADUser `
            -Name "$FirstName $LastName" `
            -GivenName $FirstName `
            -Surname $LastName `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@$Domain" `
            -Department $Department `
            -Path $OU `
            -AccountPassword $Password `
            -Enabled $true `
            -ChangePasswordAtLogon $true

        # Add user to department security group
        Add-ADGroupMember `
            -Identity $Group `
            -Members $Username

        Write-Host "Added $Username to $Group"
        Write-Host ""
    }
}

Write-Host "User provisioning completed."