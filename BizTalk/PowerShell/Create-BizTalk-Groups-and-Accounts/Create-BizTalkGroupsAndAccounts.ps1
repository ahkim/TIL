<#
    .SYNOPSIS
    
    .DESCRIPTION
    This script is written to help domain administrator to create BizTalk security groups and service accounts
    with naming standard following in mind. Using this, you could segregate environments from one another within
    the same domain. 
    
    Service Accounts will be created in the form of svc-BTS-{Env}-{Role}
    
    e.g. 
    - svc-BTS-DEV-Host
    - svc-BTS-DEV-IsHost
    - svc-BTS-DEV-RuleEn
    - svc-BTS-DEV-SSO

    Security groups will be created in the form of BTS-{Env} {Group name}

    e.g.
    - BTS-DEV Admins
    - BTS-DEV SSO Admins
    - BTS-DEV Affiliate SSO Admins
    - BTS-DEV InProcess Hosts
    - BTS-DEV Isolated Hosts
    - BTS-DEV Operaters
    - BTS-DEV B2B Operators
    - BTS-DEV BAM Portal Users

    Step 1)

    BizTalk security groups and services accounts will be created in following Organization Unit by default. 
    You would need to adjust the script for your environment accordingly. 

    Root
        Service Accounts
            {Env}
                BizTalk

    Creating above Organization Unit in PowerShell is also included but commented out by default. 

    Step 2)

    Regions called "Set environment variables" and "Create/Update BizTalk Admin User Account and add to local 
    Administrators group on BizTalk Server" includes configurable values. Please update. 

    Step 3)

    Passwords for service accounts are default to "P@ssword". Please update these based on security policy and
    also update provided excel file with changed password detail and give back to BizTalk Admin User as he or 
    she would need this to install and configure BizTalk going forward.

    Step 4)

    Open Administrative PowerShell console, and set the execution policy to Unrestricted.  

    Set-ExecutionPolicy Unrestricted

    Step 5)

    Run Create-BizTalkGroupsAndAccounts.ps1
        
    .EXAMPLE
    Create-BizTalkGroupsAndAccounts
    
	.NOTES
	Filename:     Create-BizTalkGroupsAndAccounts.ps1
	
	Maintenance History
	Name	           Date		 	Version		C/R		Description        
	----------------------------------------------------------------------------------
	Aaron Kim		   2015-08-25	1.0.0				Created
    Mikael Sand         2016-08-08   1.0.1              Minor syntax bug patch when using subdomains.
#>

##-----------------------------------------------------------------------
## Function: Main
## Purpose: Main logic
##-----------------------------------------------------------------------
Function Main
{

    #region Set environment variables
    #example of domains
    #No subdomain: test.com
    # $Domain is "test"
    # $TopLevelDomain is "com"
    
    #Subdomain: corp.test.com
    # $Subdomain is "test"
    # $Domain is "test"
    # $TopLevelDomain is "com"

    $Env = "DEV"
    $SubDomain = ""
    $Domain = ""
    $TopLevelDomain = ""

    # Set your BtsOuPath. This Path must exist!
    $BtsOuPath = ""

    # If you do not want to use the sample Ou-paths. Update the code below to hard code your Ou.
    # Path to create the BizTalk groups and service accounts. e.g. OU={something},OU={something-branch},OU={Organization},DC={subdomain},DC={domain},DC={TopLevelDomain}
    # This Path must exist and can be created using the code below.
    #if ($SubDomain) {
    #   $BtsOuPath = "OU=BizTalk,OU=$Env,OU=Service Accounts,DC=$Subdomain,DC=$Domain,DC=$TopLevelDomain"
    #}
    #else {
    #    $BtsOuPath = "OU=BizTalk,OU=$Env,OU=Service Accounts,DC=$Domain,DC=$TopLevelDomain"  
    #}
    
    # If you would like to create a path in like in the sample, you could use following command.
    #NEW-ADOrganizationalUnit "Service Accounts"
    #if ($SubDomain) {
    #    NEW-ADOrganizationalUnit $Env -path "OU=Service Accounts,DC=$Subdomain,DC=$Domain,DC=$TopLevelDomain"
    #    NEW-ADOrganizationalUnit BizTalk -path "OU=$Env,OU=Service Accounts,DC=$Subdomain,DC=$Domain,DC=$TopLevelDomain"
    #}
    #else {
    #    NEW-ADOrganizationalUnit $Env -path "OU=Service Accounts,DC=$Domain,DC=$TopLevelDomain"
    #    NEW-ADOrganizationalUnit BizTalk -path "OU=$Env,OU=Service Accounts,DC=$Domain,DC=$TopLevelDomain"  
    #}
    
    # Please update with domain administrator's user account or group
    $DomainAdmin = "Domain Admins"

    # Service Accounts and Passwords
    $BTSHost = "svc-BTS-$Env-Host"
    $BTSIsolatedHost = "svc-BTS-$Env-IsHost"
    $BTSRuleEn = "svc-BTS-$Env-RuleEn"
    $BTSSSOSvc = "svc-BTS-$Env-SSO"

    # Convert the plain text passwords
    $BTSHostPassword = ConvertTo-SecureString "TomorrowsIntegration!" -AsPlainText -Force
    $BTSIsoHostPassword = ConvertTo-SecureString "TomorrowsIntegration!" -AsPlainText -Force
    $BTSRuleEnPassword = ConvertTo-SecureString "TomorrowsIntegration!" -AsPlainText -Force
    $BTSSSOSvcPassword = ConvertTo-SecureString "TomorrowsIntegration!" -AsPlainText -Force

    #endregion

    #No more assigning variables below this point.

    #region Create/Update BizTalk Admin User Account and add to local Administrators group on BizTalk Server 

    # BizTalk Admin User account - This is a user account for someone who will install and configure BizTalk farm. 
    # Most likely, at least user account must have been already created. In that case, update following line and comment out account creation part in this region. 
    $BtsAdmin = $Env+"BTSAdm"

    # Path where to create the BizTalk Admin User e.g. CN=Users,DC={subdomain},DC={domain},DC={TopLevelDomain}
    if ($SubDomain) {
       $AdminOuPath = "CN=Users,DC=$SubDomain,DC=$Domain,DC=$TopLevelDomain"
    }
    else {
        $AdminOuPath = "CN=Users,DC=$Domain,DC=$TopLevelDomain"  
    }
    
    # Convert the plain text passwords
    $BtsAdminPassword = ConvertTo-SecureString "TomorrowsIntegration!" -AsPlainText -Force
    # Comment out following two in case BizTalk Admin user account is already created. 
    # As this is a user account not a service account, allowed password to expire and let user to change the password at logon. Please update according to security policy. 
    New-ADUser -SamAccountName $BtsAdmin -AccountPassword $BtsAdminPassword -name $BtsAdmin -enabled $true -PasswordNeverExpires $false -CannotChangePassword $false -ChangePasswordAtLogon $true -Path $AdminOuPath
    Write-Host "User account $BtsAdmin was successfully created" -Fore DarkGreen

    # BizTalk Admin User account should be a member of local Administrators group on BizTalk Server. 
    # Update computer name accordingly and add more lines if there is more than 1 BizTalk Server.
    $computer1 = ""
    
    if ($SubDomain) {
        Add-DomainUserToLocalGroup -computer $computer1 -group Administrators -domain $Subdomain"."$Domain"."$TopLevelDomain -user $BtsAdmin
    }
    else {
        Add-DomainUserToLocalGroup -computer $computer1 -group Administrators -domain $Domain"."$TopLevelDomain -user $BtsAdmin  
    }
    
    Write-Host "User account $BtsAdmin was successfully added into Local Administrators group of $computer1" -Fore DarkGreen
    #endregion

    #region Create Security Groups

    $BTSAdminsDesc = "Administrators who have the least privileges necessary to perform administrative tasks"
    $SSOAdminsDesc = "Administrators of the Enterprise Single Sign-On (SSO) service"
    $SSOAffAdminsDesc = "Administrators of certain SSO affiliate applications"
    $BTSOpsDesc = "Operators who Have a low privilege role with access only to monitoring and troubleshooting actions"
    $BTSInProessHostsDesc = "In-Process BizTalk Host Group"
    $BTSIsolatedHostsDesc = "Isolated BizTalk Host Group"
    $BTSB2BOpsDesc = "Operators to perform all Party management operation"
    $BAMPortalUsersDesc = "Users who have access to BAM Portal Web site"

    New-ADGroup -Name "BTS-$Env Admins" -GroupCategory Security -GroupScope Global -DisplayName "BTS-$Env Admins" -Path $BtsOuPath -Description $BTSAdminsDesc
    New-ADGroup -Name "BTS-$Env SSO Admins" -GroupCategory Security -GroupScope Global -DisplayName "BTS-$Env SSO Admins" -Path $BtsOuPath -Description $SSOAdminsDesc
    New-ADGroup -Name "BTS-$Env Affiliate SSO Admins" -GroupCategory Security -GroupScope Global -DisplayName "BTS-$Env Affiliate SSO Admins" -Path $BtsOuPath -Description $SSOAffAdminsDesc
    New-ADGroup -Name "BTS-$Env Operaters" -GroupCategory Security -GroupScope Global -DisplayName "BTS-$Env Operaters" -Path $BtsOuPath -Description $BTSOpsDesc
    New-ADGroup -Name "BTS-$Env InProcess Hosts" -GroupCategory Security -GroupScope Global -DisplayName "BTS-$Env InProcess Hosts" -Path $BtsOuPath -Description $BTSInProessHostsDesc
    New-ADGroup -Name "BTS-$Env Isolated Hosts" -GroupCategory Security -GroupScope Global -DisplayName "BTS-$Env Isolated Hosts" -Path $BtsOuPath -Description $BTSIsolatedHostsDesc
    New-ADGroup -Name "BTS-$Env B2B Operators" -GroupCategory Security -GroupScope Global -DisplayName "BTS-$Env B2B Operators" -Path $BtsOuPath -Description $BTSB2BOpsDesc
    # In case BAM Portal to be used
    New-ADGroup -Name "BTS-$Env BAM Portal Users" -GroupCategory Security -GroupScope Global -DisplayName "BTS-$Env BAM Portal Users" -Path $BtsOuPath -Description $BAMPortalUsersDesc
    Write-Host "Security groups were successfully created in AD" -Fore DarkGreen
    #endregion
 
    #region Create Service Accounts
    # As these are service accounts, password expiration is not recommended which can cause serious disruption of service. 
    New-ADUser -SamAccountName $BTSHost -AccountPassword $BTSHostPassword -name $BTSHost -enabled $true -PasswordNeverExpires $true -CannotChangePassword $true -ChangePasswordAtLogon $false -Path $BtsOuPath
    New-ADUser -SamAccountName $BTSIsolatedHost -AccountPassword $BTSIsoHostPassword -name $BTSIsolatedHost -enabled $true -PasswordNeverExpires $true -CannotChangePassword $true -ChangePasswordAtLogon $false -Path $BtsOuPath
    New-ADUser -SamAccountName $BTSRuleEn -AccountPassword $BTSRuleEnPassword -name $BTSRuleEn -enabled $true -PasswordNeverExpires $true -CannotChangePassword $true -ChangePasswordAtLogon $false -Path $BtsOuPath
    New-ADUser -SamAccountName $BTSSSOSvc -AccountPassword $BTSSSOSvcPassword -name $BTSSSOSvc -enabled $true -PasswordNeverExpires $true -CannotChangePassword $true -ChangePasswordAtLogon $false -Path $BtsOuPath
    Write-Host "Service Accounts were successfully created in AD" -Fore DarkGreen

    #endregion

    #region Add accounts to right security groups

    # Add BizTalk Admin User account to BizTalk Administrators Group
    Add-ADPrincipalGroupMembership -Identity $BtsAdmin -MemberOf "BTS-$Env Admins" 
    # Add Service Accounts to belonging BizTalk groups
    Add-ADPrincipalGroupMembership -Identity $BTSSSOSvc -MemberOf "BTS-$Env SSO Admins"
    Add-ADPrincipalGroupMembership -Identity "BTS-$Env Admins" -MemberOf "BTS-$Env SSO Admins"
    Add-ADPrincipalGroupMembership -Identity "BTS-$Env Admins" -MemberOf "BTS-$Env Affiliate SSO Admins"
    Add-ADPrincipalGroupMembership -Identity $BTSHost -MemberOf "BTS-$Env InProcess Hosts"
    Add-ADPrincipalGroupMembership -Identity $BTSIsolatedHost -MemberOf "BTS-$Env Isolated Hosts"
    Add-ADPrincipalGroupMembership -Identity "BTS-$Env Admins" -MemberOf "BTS-$Env BAM Portal Users"
    Write-Host "Service Accounts were successfully added into BizTalk Security Groups" -Fore DarkGreen
 
    # Add the domain admin to all groups
    Add-ADPrincipalGroupMembership -Identity $DomainAdmin -MemberOf "BTS-$Env Admins"
    Add-ADPrincipalGroupMembership -Identity $DomainAdmin -MemberOf "BTS-$Env SSO Admins"
    Add-ADPrincipalGroupMembership -Identity $DomainAdmin -MemberOf "BTS-$Env Affiliate SSO Admins"
    Add-ADPrincipalGroupMembership -Identity $DomainAdmin -MemberOf "BTS-$Env InProcess Hosts"
    Add-ADPrincipalGroupMembership -Identity $DomainAdmin -MemberOf "BTS-$Env Isolated Hosts"
    Add-ADPrincipalGroupMembership -Identity $DomainAdmin -MemberOf "BTS-$Env BAM Portal Users"
    Write-Host "$DomainAdmin is successfully added into every BizTalk Security Group" -Fore DarkGreen

    #endregion

}

##-----------------------------------------------------------------------
## Function: Add-DomainUserToLocalGroup
## Purpose: Remotely add domain user to local group on a specified computer
##-----------------------------------------------------------------------
Function Add-DomainUserToLocalGroup 
{ 
    [cmdletBinding()] 
    Param( 
        [Parameter(Mandatory=$True)] 
        [string]$computer, 
        [Parameter(Mandatory=$True)] 
        [string]$group, 
        [Parameter(Mandatory=$True)] 
        [string]$domain, 
        [Parameter(Mandatory=$True)] 
        [string]$user 
    ) 

    $de = [ADSI]"WinNT://$computer/$Group,group" 
    $de.psbase.Invoke("Add",([ADSI]"WinNT://$domain/$user").path) 
}

Main
