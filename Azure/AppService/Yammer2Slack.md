# Yammer message in a group to Slack channel using Azure Logic App

This is how easy it is from a designer view. Add api app for yammer and slack in sequence and configure login. Done. 

![](http://i.imgur.com/kb9AsDe.png)

When you switch to codeview, you can configure more in detail(trigger interval, etc.)

```json
{
    "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-04-01-preview/workflowdefinition.json#",
    "actions": {
        "Post_Message": {
            "inputs": {
                "host": {
                    "api": {
                        "runtimeUrl": "https://logic-apis-australiasoutheast.azure-apim.net/apim/slack"
                    },
                    "connection": {
                        "name": "@parameters('$connections')['slack_1']['connectionId']"
                    }
                },
                "method": "post",
                "path": "/chat.postMessage",
                "queries": {
                    "channel": "#teamupdates_yammer",
                    "text": "@{triggerBody()?['content_excerpt']}"
                }
            },
            "runAfter": {},
            "type": "ApiConnection"
        }
    },
    "contentVersion": "1.0.0.0",
    "outputs": {},
    "parameters": {
        "$connections": {
            "defaultValue": {},
            "type": "Object"
        }
    },
    "triggers": {
        "When_there_is_a_new_message_in_a_group": {
            "inputs": {
                "host": {
                    "api": {
                        "runtimeUrl": "https://logic-apis-australiasoutheast.azure-apim.net/apim/yammer"
                    },
                    "connection": {
                        "name": "@parameters('$connections')['yammer']['connectionId']"
                    }
                },
                "method": "get",
                "path": "/trigger/in_group/@{encodeURIComponent(string(6281351))}.json"
            },
            "recurrence": {
                "frequency": "Hour",
                "interval": 1
            },
            "splitOn": "@triggerBody()?.messages",
            "type": "ApiConnection"
        }
    }
}
```
