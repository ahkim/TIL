# How does MSMQ ensure At least once & At most once?

More detail in [here](http://www.4guysfromrolla.com/webtech/041300-1.4.shtml)

You can choose from three types of messages `express`/`recoverable`/`transactional`. 

`At least once` can be ensured by `express` and `recoverable` messaging. `At most once` can be ensured by `transactional`. 

`For express and recoverable` messaging, it is configurable via setting the `delivery property of each message` to send. 

`For transactional messaging`, create a transactional queue by setting `Transactional property to true`. 
