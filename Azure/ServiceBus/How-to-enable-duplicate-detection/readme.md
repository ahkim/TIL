# How to enable duplicate detection

### Key facts

- Duplicate detection can be enabled on queues and topics
	- Set RequiresDuplicateDetection property to true
- Duplicate detection is based on MessageId property of messages
	- Sending application must set this explicitly
- Duplicate messages are not dead-lettered

### Set RequiresDuplicateDetection property

```c#
// Create a description for the queue.
QueueDescription rfidCheckoutQueueDescription =
    new QueueDescription(AccountDetails.QueueName)
    {
        // Comment in to require duplicate detection
        RequiresDuplicateDetection = true,
        DuplicateDetectionHistoryTimeWindow = TimeSpan.FromMinutes(60),
    };

// Create a queue based on the queue description.
namespaceMgr.CreateQueue(rfidCheckoutQueueDescription);
```

### Set Message ID

- Messages will have unique message IDs when created
- Message ID must be explicitly set before message is sent

```c#
// Create a new brokered message from the order item RFID tag.
BrokeredMessage tagRead = new BrokeredMessage(rfidTag);

// Comment in to set message id.
tagRead.MessageId = Guid.NewGuid().ToString();
```

