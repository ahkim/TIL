# How to implement a wire tap

### what is it for?

![](http://i.imgur.com/q1RF1qi.png)

This is to address inspecting messages that travel on a point to point channel. Inserting a subscriber into a main channel as a second channel enables monitoring of messages. 

### How do you implement in Azure Service Bus?

All we do is adding a subscriber which subscribes to all the messages. 

![](http://i.imgur.com/2eyKIkQ.png)

```c#
// Creating a monitor

var manager = NamespaceManager.CreateFromConnectionString
    (SbConnectionString);
var subName = "wiretap-" + Guid.NewGuid().ToString();

// Create a subscription that will expire
manager.CreateSubscription(new SubscriptionDescription(TopicPath, subName)
    {
        AutoDeleteOnIdle = TimeSpan.FromMinutes(5)
    });


var subClient = SubscriptionClient.CreateFromConnectionString
    (SbConnectionString, TopicPath, subName);

// Receive messages and display properties
subClient.OnMessage(message =>
{
    Console.Write("Message received:");
    foreach (var item in message.Properties)
    {
        Console.Write(" {0}={1}", item.Key, item.Value);
    }
    Console.WriteLine();
});
```
