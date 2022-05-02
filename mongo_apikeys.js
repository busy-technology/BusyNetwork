use busy
let apiKeyMap = [
    {
        apiKey: 'hckch874867487njkbjvw89797',
        accessGroup: 'BusyAdmin',
    },
]

for (var i = 0; i < apiKeyMap.length; i++) {
    db.apikeys.insertOne({ accessgroup : apiKeyMap[i].accessGroup, apikey: apiKeyMap[i].apiKey , usernickname: 'Admin' })
 }