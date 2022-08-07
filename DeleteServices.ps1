[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [switch] $DeleteByName = $false,

    [Parameter(Mandatory=$false)]
    [switch] $DeleteByTag = $false,

    [Parameter(Mandatory=$false)]
    [switch] $DeleteByWildCard = $false
)
$services = ''
if ($DeleteByName){
    $RGName = Read-Host "Please enter the resource group name"
    $services = Get-AzResourceGroup -Name $RGName
    Write-Host "Deleting Resource Group by name " $RGName " starting..."
    Get-AzResourceGroup -Name $RGName | Remove-AzResourceGroup -Force #Deleting command
    Write-Host "Resource group " $RGName " deleted successfully, along with all its Azure services."
}
if ($DeleteByTag){
    $RGTagKey = Read-Host "Please enter the tag key name"
    $RGTagValue = Read-Host "Please enter the tag value"
    $services = Get-AzResourceGroup -Tag @{$RGTagKey=$RGTagValue}
    Write-Host "Deleting Resource Groups by tag with key value as " $RGTagKey " and value as " $RGTagValue " starting..."
    $services | ForEach-Object -Parallel{
            Write-Host  "Deleting Resource Group: " $_.ResourceGroupName
            Get-AzResourceGroup -Name $_.ResourceGroupName | Remove-AzResourceGroup -Force
            Write-Host "Resource group: " $_.ResourceGroupName " deleted"
        }
    Write-Host "Resource groups with tag " $RGTagKey " and value " $RGTagValue " deleted successfully."
}
if ($DeleteByWildCard){
    $RGWildCard = Read-Host "Please enter the wildcard"
    $services = Get-AzResourceGroup -Name  *$RGWildCard*
    Write-Host "Deleting Resource Groups that contain wild card " $RGWildCard " starting..."
    $services | ForEach-Object -Parallel{
            Write-Host  "Deleting Resource Group: " $_.ResourceGroupName
            Get-AzResourceGroup -Name $_.ResourceGroupName | Remove-AzResourceGroup -Force
            Write-Host "Resource group: " $_.ResourceGroupName " deleted"
        } #deleting process
    Write-Host "Resource groups with their Azure services deleted successfully."
}
