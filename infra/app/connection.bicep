param name string
param authType string
//param appResourceId string
param targetResourceId string
param runtimeName string
param dbUserName string
param keyVaultName string
param webAppName string

@secure()
param dbUserPassword string

module connections '../core/host/servicelinker.bicep' = {
  name: name
  params: {
    name: name
    authType: authType
    //appResourceId: appResourceId
    targetResourceId: targetResourceId
    runtimeName: runtimeName
    dbUserName: dbUserName
    dbUserPassword: dbUserPassword
    keyVaultName: keyVaultName
    webAppName: webAppName
  }
}
