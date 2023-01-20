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

resource connectionToKeyVault 'Microsoft.ServiceLinker/linkers@2022-05-01' =  if(!empty(keyVaultName)) {
  name: '${name}_kv'
  scope: webApp
  properties: {
    targetService: {
      id: keyVault.id
      type: 'AzureResource'
    }
    clientType: 'none'
    authInfo: {
      authType: 'systemAssignedIdentity'
    }
  }
}

resource connectionToTargetDB 'Microsoft.ServiceLinker/linkers@2022-05-01' = {
  name: '${name}_db'
  scope: webApp
  properties: {
    targetService: {
      id: targetResourceId
      type: 'AzureResource'
    }
    secretStore: {
      keyVaultId: !empty(keyVault) ? keyVault.id : ''
    }
    authInfo: {
      authType: authType
      name: dbUserName
      secretInfo: {
        secretType: 'rawValue'
        value: dbUserPassword
      }
    }
    clientType: runtimeName
  }
  dependsOn: [
    connectionToKeyVault
  ]
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = if (!empty(keyVaultName)) {
  name: keyVaultName
  scope: resourceGroup()
}

resource webApp 'Microsoft.Web/sites@2022-03-01' existing = {
  name: webAppName
  scope: resourceGroup()
}
