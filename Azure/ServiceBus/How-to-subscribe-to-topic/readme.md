# How to subscribe using filter

### Types of filter

- SQL Filter
	- Expression defined in "TSQL Like" expression
	- Message properties dictionary used in expression evaluation
- Correlation Filter
	- Only supports equals operation
	- Improved performance for basic filtering
	- Can be applied to many properties in message header

### Default filter to be created when not specified

```c#
// Add a default subscription
namespaceMgr.CreateSubscription("ordertopic", "allOrdersSubscription");
```
![](http://i.imgur.com/Yek7ZIt.png)

### Subscription using SQL Filter

- Values used in filters must be available in message header properties connection

```c#
// Sender application
/////////////////////
// Create a message from the order.
BrokeredMessage orderMsg = new BrokeredMessage(order);

// Promote properties.
orderMsg.Properties.Add("Loyalty", order.HasLoyltyCard);
orderMsg.Properties.Add("Items", order.Items);
orderMsg.Properties.Add("Value", order.Value);
orderMsg.Properties.Add("Region", order.Region);

// Set the CorrelationId to the region.
orderMsg.CorrelationId = order.Region;

// Send the message.
OrderTopicclient.Send(orderMsg);


// Receiver application
///////////////////////
// Add a subscription for USA region
namespaceMgr.CreateSubscription(TopicPath, "usaSubscription", new SqlFilter("Region = 'USA'"));

// Add a subscription for large orders
namespaceMgr.CreateSubscription(TopicPath, "largeOrderSubscription", new SqlFilter("Item > 30"));

// Add a subscription for loyal customers in the USA region
namespaceMgr.CreateSubscription(TopicPath, "loyaltySubscription", new SqlFilter("Loyalty = true AND Region = 'USA'"));
```

- Duplicate detection can be enabled on queues and topics
	- Set RequiresDuplicateDetection property to true
- Duplicate detection is based on MessageId property of messages
	- Sending application must set this explicitly
- Duplicate messages are not dead-lettered

### Promoting Properties

![](http://i.imgur.com/ABRqbjI.png)

- Message body data cannot be used to route messages
- Fields used for message routing are promoted to message header

![](http://i.imgur.com/asOMQgx.png)

### Subscription using Correlation Filter

- Can be used to perform filtering on values in properties colletion
- However, it can filter on values in various context properties like
	- CorrelationId, ContentType, Label, MessageId, ReplyTo, ReplyToSessinId, SessionId, To

```c#
// Sender application
/////////////////////

// Set the CorrelationId to the region.
orderMsg.CorrelationId = order.Region;

// Send the message.
OrderTopicclient.Send(orderMsg);

// Receiver application
///////////////////////

// Add correlation subscription for UK orders
// Here, filtering a message with CorrelationId = "UK"
NamespaceMgr.CreateSubscription(TopicPath, "ukSubscription", new CorrelationFilter("UK"));

// Add correlation subscription for test messages
// Here, filtering a message with Label = "Test" (also in context)

// Receiver application
NamespaceMgr.CreateSubscription(TopicPath, "ukSubscription", new CorrelationFilter() { Label = "Test" });

```
