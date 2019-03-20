#Creating a Storage account and  container in a New resource group
$appdirectory="d:\Users\mandarl\Desktop\storage" #publish files need to be placed on this location or directory
$resouregroupname = "Resourcgrouptest"
$webappname="awdocswebapp1" ########Enter a New name for webapp before executing this script########
$location="eastus"
$SubscriptionIdval = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" #Change the Subscription key
$containerName = "quickstartblobs" # Container Name

# Executing that cmdlet opens a challenge/response window, enter your credentials 
Login-AzureRMAccount 


# Changing the Subscritption ID before executing the following Cmdlets
Set-AzureRmContext -SubscriptionId  $SubscriptionIdval # Changing the Subscritption ID before executing the following Cmdlets

# Creating a New resource-group
New-AzureRmResourceGroup -Name $resouregroupname -Location $location 



#Creating a storage account
$rnd = (New-Guid).ToString().Split('-')[0]
$storageAccountName = "storageaccgspnew"
$storageSku = 'Standard_LRS'
$newStorageParams = @{
    ResourceGroupName = $resouregroupname
    AccountName       = $storageAccountName
    Location          = $location
    SkuName           = $storageSku
   
}
$storageAccount = New-AzureRmStorageAccount @newStorageParams
$ctx = $storageAccount.Context
$storageAccount

#Get storage account connection string
$accountKey = Get-AzureRmStorageAccountKey -ResourceGroupName $resouregroupname -AccountName $storageAccountName |
    Where-Object {$_.KeyName -eq 'Key1'} | Select-Object -ExpandProperty Value
$storageConnectionString = "DefaultEndpointsProtocol=https;AccountName=$storageAccountName;AccountKey=$accountKey"

#Creating Storage container
New-AzureStorageContainer -Name $containerName -Permission Container -Context $ctx


#Uploading Files
$files = Get-ChildItem $appdirectory
foreach($file in $files)
{
$localfile = "$appdirectory\$file"
$remotefile ="storage/$file"  # Need to enter the Container folder name"
Set-AzureStorageBlobContent -FIle $localfile -Container $containerName -Blob $remotefile -Context $ctx -Force
}
