# How message correlation works?

![](http://i.imgur.com/d4LgMAh.png)

- Each message have correlation identifier 
	- Often in message header

# What is it for?

- To group related messages together
	- Sequence of messages
		- Please note the sequence of message retains when replier responds to requestor in a diagram above.
- To implement request-reply message pattern
	- Correlate reply with request 
