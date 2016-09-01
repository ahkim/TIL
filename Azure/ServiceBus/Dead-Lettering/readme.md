# Dead-lettering

### Dead lettering patterns

Following is what enterpriseintegrationpatterns.com suggests as patterns to deal with message which cannot be processed. 

- Dead Letter Channel
	- The messaging system moves messages to a dead-letter channel
- Invalid Message Channel
	- The receiving application moves messages to an invalid message channel

In ASB, both of these patterns are implemented with dead lettering functionality

### Dead-lettering Scenarios

- Processing Failure
	- receiving app fails repeatedly to process
- Poison Message
	- content makes it not possible to process
- Expired Message

### Dead-letter sub-queues

![](http://i.imgur.com/gTwfzLk.png)

- Queues
	- Each queue has a dead-letter sub-queue
- Subscriptions
	- Each subscription has a dead-letter sub-queue

### How does it get dead-lettered?

- Implicit Dead-Lettering
	- Max delivery count exceeded
	- Message expired
		- when expiry enabled on queue or subscription
	- Routing failure exception
		- when enabled on subscription
- Explicit Dead-Lettering
	- Dead-lettered by receiving application
		- manually dead letter and **you can specify reason and description**

### Issues with implicit Dead lettering

- They contain no meaningful information as to the cause of processing failure
- May not be the best way to handle processing failures
- Consider this as a safety net

### How to implicitly and explicitly dead letter?

#### Implicit

```c#
var subscriptionDescription = new SubscriptionDescription("topic", "subscription")
{
	MaxDeliveryCount = 5;
};

namespaceManager.CreateSubscription(subscriptionDescription);
```

#### Explicit

```c#
// Following inserts DeadLetterReason and DeadLetterErrorDescription property in Message header. 
orderMsg.DeadLetter("Invalid order", "Error in billing address");

catch(MessagingException mex)
{
	if(message.DeliveryCount > 3)
	{
		message.DeadLetter(mex.Message, mex.ToString());
	}
	else
	{
		// Abaondon the message
		// When this is called, message will be immediately available in the queue again. 
		// Sometimes, commenting this out is better not to quickly exhaust delivery count. Vice versa. 
		message.Abandon();
	}
}
```
