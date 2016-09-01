# How message correlation works in concept?

![](http://i.imgur.com/d4LgMAh.png)

- Each message have correlation identifier 
	- Often in message header

# What is it for?

- To group related messages together
	- Sequence of messages
		- Please note the sequence of message retains when replier responds to requestor in a diagram above.
- To implement request-reply message pattern
	- Correlate reply with request 

# Correlation in ASB and how it is different with the concept

![](http://i.imgur.com/cUVLwHt.png)

This is what message looks like in ASB. You can see two identifier in header. Unlike it's naming, CorrelationId doesn't actually serve the correlation but SessionId does.  

- CorrelationId 
	- Used for more efficient routing between topics and subscriptions
	
- SessionId
	- Used to correlate messages in receiving applications
		- This serves grouping related messages together
		- This serves implementing request-reply message pattern
