# Messaging semantics

More detail in [here](http://www.cloudcasts.net/devguide/Default.aspx?id=12006)

> **At-Most-Once Delivery**
> 
> The postal service is a good example of at-most-once delivery. If I post a letter to a friend it will be delivered to its destination at most once, with a very small chance that it will get lost. There is no way that the receiver will receive two copies of the letter.
> 
> In messaging systems at-least-once delivery is the most supported semantic. In enterprise applications it is often not considered sufficiently reliable.
> 
> **At Least Once Delivery**
> 
> Suppose I photocopy my letter, then post the copy to a friend and ask him to call me once he has received it. If I don’t get a call within one week I can make another copy of the letter and resend it and wait another week for a call. This ensures that my friend will get the letter, assuming the address is correct, but there is also a chance that he will be on vacation, or forget to call, or call me when I am out and not leave a message. In this scenario my friend will receive the letter, but may end up getting two or more copies of the same letter.
> 
> When using a messaging system that supports at-most-once delivery developers can implement retry logic to ensure that the message reaches the destination. One of the side-effects of implementing this is that there is a chance that more than one copy of the message will be delivered to the destination. In some scenarios this is acceptable, as the receiving of duplicate messages will not affect business processes, in other scenarios it is not.
> 
> **Exactly Once Delivery**
> 
> Now suppose that I post my friend a copy of the letter, and then call him a week later to check if the letter has arrived. I make sure that he confirms that it has not been delivered before sending another copy of the letter. I also place a codeword on the back of the letter and tell him that if he receives another letter with the same codeword that he should burn it instead of opening it. I now have a way to ensure exactly-once-delivery.
> 
> In messaging systems duplicate detection and a two-phase commit protocol can be used to ensure that exactly-once-delivery can be achieved, even when the underlying transport mechanisms only support at-most-once delivery. Service Bus queues, topics and subscriptions provide support for duplicate detection and transactional operations.
> 
> **Ordered Delivery**
> 
> There are many scenarios where the order in which messages are processed in is critical. Consider a system where order and order update messages for a line-of-business application are received and processed. If the system attempts to process an order update message before an order message is processed the update operation will fail. If two update messages are sent for the same order the updates must be made to the line-of-business system in the order in which they are sent otherwise the older update may overwrite the newer one.
> 
> Service Bus queues and topics guarantee ordered delivery of messages, meaning that the message placed on a queue or topic will be received in the same order. There are, however, some exceptions to this. If a receiving application chooses to defer a message then other messages can be received before the deferred message, and deferred messages can be received in any order using message receipts. It is the responsibility of the receiving application to ensure that any required ordering of deferred messages is performed.
> 
> Ordered delivery does not necessarily mean ordered processing. In load-balanced scenarios with more than one receiver, the messages may be delivered to the receivers in a sequential order, but there is no guarantee that the receivers will complete the processing of the messages in that order. If this is the case a solution would be to ensure that there is only one active receiver using active-passive clustering, or implement logic to ensure that messages are processed in order.
