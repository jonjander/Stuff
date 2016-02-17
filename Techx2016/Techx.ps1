Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1'
Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\ExpressRoute\ExpressRoute.psd1'

#Get Providers
$providers=Get-AzureDedicatedCircuitServiceProvider
$providers | ogv

#Creating a new circuit
$Bandwidth = 200
$CircuitName = "Contoso01"
$ServiceProvider = "TeleCity Group"
$Location = "London"
$billingType = "MeteredData" #/UnlimitedData
$sku = "Standard" #/Premium

$cir=New-AzureDedicatedCircuit -CircuitName $CircuitName -ServiceProviderName $ServiceProvider -Bandwidth $Bandwidth -Location $Location -billingType $billingType -Sku $sku

#Getting service key
Get-AzureDedicatedCircuit


#Linking a VNet in the same Azure subscription to an ExpressRoute circuit
New-AzureDedicatedCircuitLink -ServiceKey "*****************************" -VNetName "MyVNet"


#Linking a VNet in a different Azure subscription to an ExpressRoute circuit

#Circuit owner operations

#Creating an authorization
New-AzureDedicatedCircuitLinkAuthorization -ServiceKey "**************************" -Description "Dev-Test Links" -Limit 2 -MicrosoftIds 'devtest@contoso.com'
#Reviewing authorizations
Get-AzureDedicatedCircuitLinkAuthorization -ServiceKey: "**************************"
#Update
set-AzureDedicatedCircuitLinkAuthorization -ServiceKey "**************************" -AuthorizationId "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"-Limit 5
#Delete
Remove-AzureDedicatedCircuitLinkAuthorization -ServiceKey "*****************************" -AuthorizationId "###############################"


#Circuit user operations

#Reviewing authorizations
Get-AzureAuthorizedDedicatedCircuit
#Redeeming link authorizations
New-AzureDedicatedCircuitLink –servicekey "&&&&&&&&&&&&&&&&&&&&&&&&&&" –VnetName 'SalesVNET1' 

















#New Route
New-AzureRouteTable -Name 'DirectInternetRouteTable' -Location uswest

Get-AzureRouteTable -Name 'DirectInternetRouteTable' | Set-AzureRoute -RouteName 'Direct Internet Range 0' -AddressPrefix 0.0.0.0/0 -NextHopType Internet

#https://azure.microsoft.com/sv-se/documentation/articles/app-service-app-service-environment-network-configuration-expressroute/