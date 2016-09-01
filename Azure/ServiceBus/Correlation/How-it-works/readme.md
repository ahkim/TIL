# How correlation works in ASB

#### How message correlation works in concept?

![](http://i.imgur.com/d4LgMAh.png)

- Each message have correlation identifier 
	- Often in message header

### What is it for?

- To group related messages together
	- Sequence of messages
		- Please note the sequence of message retains when replier responds to requestor in a diagram above.
- To implement request-reply message pattern
	- Correlate reply with request 

### Correlation in ASB and how it is different with the concept

![](http://i.imgur.com/cUVLwHt.png)

This is what message looks like in ASB. You can see two identifier in header. Unlike it's naming, CorrelationId doesn't actually serve the correlation but SessionId does.  

- CorrelationId 
	- Used for more efficient routing between topics and subscriptions
	
- SessionId
	- Used to correlate messages in receiving applications
		- This serves grouping related messages together
		- This serves implementing request-reply message pattern

### Grouping related messages together

```c#
// Sender
/////////
// Create a description for the queue.
// Sessions are required on messaging entities
QueueDescription rfidCheckoutQueueDescription =
    new QueueDescription(AccountDetails.QueueName)
    {
        // Comment in to require sessions
        RequiresSession = true
    };

// Create a queue based on the queue description.
namespaceMgr.CreateQueue(rfidCheckoutQueueDescription);

// SessionId set before sending message
// Create a new brokered message from the order item RFID tag.
BrokeredMessage tagRead = new BrokeredMessage(rfidTag);

// Comment in to set message id.
tagRead.MessageId = rfidTag.TagId;

// Comment in to set session id.
tagRead.SessionId = sessionId;

// Receiver
///////////

// it requires a session, you can't use a regular client receive function or message pump
// you first need to accept a message session
var messageSession = queueClient.AcceptMessageSession();

// either this
var receivedTagRead = messageSession.Receive(TimeSpan.FromSeconds(5));

// or message pump
messageSession.OnMessage(message =>
{
	// Process message
});

```
### Implementing request-reply message pattern(in Async)

![](http://i.imgur.com/ZnFKETZ.png)

- Request Queue doesn't require a session
	- but needs to set ReplyToSessionID value

```c#
// Sender
/////////

// Create Request and Response Queue Clients
// Please note that we are not creating a request queue here (presumes it already exists and it doesn't require session)
QueueClient requestQueueClient = 
    factory.CreateQueueClient(AccountDetails.RequestQueueName);
QueueClient responseQueueClient = 
    factory.CreateQueueClient(AccountDetails.ResponseQueueName);

// Create a session identifyer for the response message
string responseSessionId = Guid.NewGuid().ToString();

// Create a message using text as the body.
BrokeredMessage requestMessage = new BrokeredMessage(text);

// Set the appropriate message properties.
requestMessage.ReplyToSessionId = responseSessionId; 

// Send the message on the request queue.
requestQueueClient.Send(requestMessage);

// Accept a message session.
MessageSession responseSession = 
    responseQueueClient.AcceptMessageSession(responseSessionId);

// Receive the response message.
BrokeredMessage responseMessage = responseSession.Receive();

// Receiver
///////////

// Create Response With Sessions 
// Please note that receiver here creates a queue with requiring session. This queue could exist instead(with requiring session).
QueueDescription responseQueueDescription = 
    new QueueDescription(AccountDetails.ResponseQueueName)
{
    RequiresSession = true
};
namespaceMgr.CreateQueue(responseQueueDescription);

// Create Request and Response Queue Clients
QueueClient requestQueueClient = 
    factory.CreateQueueClient(AccountDetails.RequestQueueName);
QueueClient responseQueueClient = 
    factory.CreateQueueClient(AccountDetails.ResponseQueueName);

requestQueueClient.OnMessage(message =>
    {
        // Deserialize the message body into text.
        string text = message.GetBody<string>();
        Console.WriteLine("Received: " + text);
        Thread.Sleep(DateTime.Now.Millisecond * 20);

        string echoText = "Echo: " + text;

        // Create a response message using echoText as the message body.
        BrokeredMessage responseMsg = new BrokeredMessage(echoText);

        // Set the session id
        responseMsg.SessionId = message.ReplyToSessionId;

        // Send the response message.
        responseQueueClient.Send(responseMsg);
        Console.WriteLine("Sent: " + echoText);
    }, new OnMessageOptions (){ AutoComplete = true, MaxConcurrentCalls = 10 });

```
