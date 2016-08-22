# How does MSMQ ensure At least once & At most once?

More detail in [here](http://www.4guysfromrolla.com/webtech/041300-1.4.shtml)

You can choose from three types of messages `express`/`recoverable`/`transactional`. 

`At least once` can be ensured by `express` and `recoverable` messaging. `At most once` can be ensured by `transactional`. 

`For express and recoverable` messaging, it is configurable via setting the `delivery property of each message` to send. 

`For transactional messaging`, create a transactional queue by setting `Transactional property to true`. 

  **At-Most-Once Delivery**
  
  The postal service is a good example of at-most-once delivery. If I post a letter to a friend it will be delivered to its destination at most once, with a very small chance that it will get lost. There is no way that the receiver will receive two copies of the letter.
  
  In messaging systems at-least-once delivery is the most supported semantic. In enterprise applications it is often not considered sufficiently reliable.
  
  **At Least Once Delivery**
  
  Suppose I photocopy my letter, then post the copy to a friend and ask him to call me once he has received it. If I don’t get a call within one week I can make another copy of the letter and resend it and wait another week for a call. This ensures that my friend will get the letter, assuming the address is correct, but there is also a chance that he will be on vacation, or forget to call, or call me when I am out and not leave a message. In this scenario my friend will receive the letter, but may end up getting two or more copies of the same letter.
  
  from [here](http://www.cloudcasts.net/devguide/Default.aspx?id=12006)
