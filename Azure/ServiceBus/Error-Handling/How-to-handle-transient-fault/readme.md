# How to handle transient fault?

### Flow of transient fault handling

![](http://i.imgur.com/2q39PyD.png)

### How to determine whether it is a transient fault?

- MessagingException class conveniently have a property called IsTransient

> * IsTransient : True if exception is considered transient and to be retried
> * Data : Get data associated with the exception
> * Detail : Provides detailed information about the exception

### Options to handle transient fault

- Using built-in error handling
	- Available in Service Bus Client API
	- Enabled by default
	- Behavior can be customized
- Using Transient Fault Handling Application Block(topaz)
	- Additional installation
	- Different programming model
	- More sophisticated exception handling

### Default behavior of built in transient fault handling

- Exponential back off
- Randomness introduced into retry times
- Takes around 20-30 seconds to fail
- Good for back-end async services
	- but not for user interfaces where you want to response fast back to client

### How to create a retry policy

```c#
var topicClient = messagingFactory.CreateTopicClient("notifications");
var retryPolicy = new RetryExponential(TimeSpan.Zero, TimeSpan.FromSecond(5), 10); // minBackOff(TimeSpan), maxBackOff(TimeSpan), maxRetryCount(int)
topicClient.RetryPolicy = retryPolicy;
```

### How to set not to retry?

- Where a quick response of failure should be displayed to a user
- When retry logic isn't required

```c#
var topicClient = messagingFactory.CreateTopicClient("notifications");
topicClient.RetryPolicy = new NoRetry();
```
