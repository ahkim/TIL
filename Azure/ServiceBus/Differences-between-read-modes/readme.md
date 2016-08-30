# Differences between read modes

### Receive and Delete Mode

```c#
// Create a queue client receive and elete receive mode.
// Default read mode is Peek Lock. So, you have to explicitly specify if you want Receive and Delete mode. 
QueueClient client = QueueClient.CreateFromConnectionString(connectionString, QueueName, ReceiveMode.ReceiveAndDelete);

while(true)
{
	// Receive a message.
	BrokeredMessage infoMsg = client.Receive(TimeSpan.FromSeconds(10));

	if(infoMsg != null)
	{
		// Deserialize the message
		// Note that you don't have to specify .Complete() here.
		// Message will be deleted after read automatically.
		ProductInfo info = infoMsg.GetBody<ProductInfo>();
		Console.WriteLine("Received: {0} information.", info.Name);
	}
}
```

### Peek Lock Mode

```c#
// Create a queue client. 
QueueClient client = QueueClient.CreateFromConnectionString(connectionString, QueueName);

while(true)
{
	// Receive a message.
	BrokeredMessage infoMsg = client.Receive(TimeSpan.FromSeconds(10));

	if(infoMsg != null)
	{
		// Deserialize the message		
		ProductInfo info = infoMsg.GetBody<ProductInfo>();
		Console.WriteLine("Received: {0} information.", info.Name);

		// Complete the receive.
		// Note that you have to specify .Complete() here.
		// If not, message will be visible again from the queue 
		// and we will end up receiving same message again. 
		// Default maximum receive count is 10. So, the message 
		// will be processed 10 times and automatically dead lettered.   
		infoMsg.Complete();
	}
}
```
