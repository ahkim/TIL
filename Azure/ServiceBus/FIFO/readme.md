# Implementing FIFO with ASB queue

### Don't get confused between two different queue, Azure Queue vs Azure Service Bus Queue

Check the differences [here](https://azure.microsoft.com/en-us/documentation/articles/service-bus-azure-and-service-bus-queues-compared-contrasted/) and [here](http://www.cloudcasts.net/devguide/Default.aspx?id=12004)

### Azure Service Bus queue also doesn't guarantee FIFO (without messaging session)

> The guaranteed FIFO pattern in Service Bus queues requires the use of messaging sessions. In the event that the application crashes while processing a message received in the Peek & Lock mode, the next time a queue receiver accepts a messaging session, it will start with the failed message after its time-to-live (TTL) period expires.

But, it is not clear what exactly it means to use a messaging session. Discussion about this is found [here](http://stackoverflow.com/questions/12151293/azure-service-bus-and-messaging-sessions). Following sample code and very well documented explanation can be found [here](http://www.cloudcasts.net/devguide/Default.aspx?id=13030). 

```c#
// Creating a Session Aware Queue
/////////////////////////////////////////////////////////////////

// Create a queue with duplicate detection
// with a detection history window of one hour,
// and requires sessions.

QueueDescription rfidCheckoutQueueDescription =
    new QueueDescription("rfidcheckout")
    {
        RequiresSession = true, // this one is important
        RequiresDuplicateDetection = true,
        DuplicateDetectionHistoryTimeWindow = new TimeSpan(0, 1, 0)
    };
 
// Create a queue that supports duplicate detection.
namespaceMgr.CreateQueue(rfidCheckoutQueueDescription);

```

```c#
// Sending Messages using Sessions
/////////////////////////////////////////////////////////////////

// Create a unique OrderId
string orderId = Guid.NewGuid().ToString();
Console.WriteLine("OrderId: {0}", orderId);
 
while (position < 10)
{
    // Create a new brokered message from the order item RFID tag.
    BrokeredMessage tagRead = new BrokeredMessage(orderItems[position]);
 
    // Set the SessionId of the message to the OrderId
    tagRead.SessionId = orderId;
 
    // Set the Message Id to the ID of the RFID tag.
    tagRead.MessageId = orderItems[position].TagId;
 
    // Send the message
    queueClient.Send(tagRead);
    Console.WriteLine("Sent: {0}", orderItems[position].Product);
 
    // Randomly cause a duplicate message to be sent.
    if (random.NextDouble() > 0.4) position++;
    sentCount++;
 
    Thread.Sleep(100);
}

```

```c#
// Receiving Message Sessions
/////////////////////////////////////////////////////////////////

while (true)
{
    int receivedCount = 0;
    double billTotal = 0.0;
 
    // Accept a message session and handle any timeout exceptions.
    MessageSession orderSession = null;
    while (orderSession == null)
    {
        try
        {
            Console.ForegroundColor = ConsoleColor.Magenta;
            Console.WriteLine("Accepting message session...");
 
            // Accept the message session
            orderSession = queueClient.AcceptMessageSession();
 
            Console.WriteLine("Session accepted.");
        }
        catch (TimeoutException ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
               
    Console.ForegroundColor = ConsoleColor.Cyan;
    Console.WriteLine("Processing order");
    Console.WriteLine(orderSession.SessionId);
    Console.ForegroundColor = ConsoleColor.Cyan;
 
    // Receive the order batch tag read messages.              
    while (true)
    {
        //BrokeredMessage receivedTagRead = queueClient.Receive(TimeSpan.FromSeconds(5));
 
        // Receive the tag read messages from the message session.
        BrokeredMessage receivedTagRead = orderSession.Receive(TimeSpan.FromSeconds(5));
 
        if (receivedTagRead != null)
        {
            RfidTag tag = receivedTagRead.GetBody<RfidTag>();
            Console.WriteLine("Bill for {0}", tag.Product);
            receivedCount++;
            billTotal += tag.Price;
 
            // Mark the message as complete
            receivedTagRead.Complete();
        }
        else
        {
            break;
        }
    }
 
    if (receivedCount > 0)
    {
        // Bill the customer.
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine
            ("Bill customer £{0} for {1} items.", billTotal, receivedCount);
        Console.WriteLine();
        Console.ResetColor();
    }
}
 
```
