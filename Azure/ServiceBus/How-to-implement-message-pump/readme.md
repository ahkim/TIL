# How to implement message pump

### Multi-Threaded Message Pump

There are three different types of message pump each has pros and cons. The holy grail of building a message pump is the constrained concurrency. 

- Single Thread
	- Easy to implement
	- In-Order processing
	- Slow message throughput
	- Wasteful of resources
- Multiple Threads
	- Improved throughput
	- Message order not preserved
	- Has potential to flood downstream systems
- Constrained Concurrency
	- Limit processing to set number of threads
	- Can provide optimal throughput
	- OnMessage available in Service Bus SDK allows us to implement this easily. 

### OnMessage implementation for Constrained Concurrency

```c#
// create custom message processing options
// Note that you can create a message pump with default option but then it will be single threaded.
var options = new OnMessageOptions()
{
	// we will manually complete or dead-letter messages
	AutoComplete = false,

	// Process up to 30 message concurrently
	// This determins the throughput. But, depends on capacity in downstream systems, 
	// more than certain amount of concurrent calls won't increase throughput. 
	MaxConcurrentCalls = 30,

	// Renew message lock if it takes a while to process
	// Note that this will avoiding duplicate messages.  
	AutoRenewTimeout = TimeSpan.FromSeconds(30),
}

// Create a message pump on the client
m_QueueClient.OnMessage(message => ProcessMessage(message), options);

// Method called to process messages
private void ProcessMessage(BrokeredMessage message)
{
	// Process the message

	// Complete the message
    message.Complete();
}

```
