# Why you need JSON message serialization

### Data Contract Serialization

Following is a typical Data Contract Serialization. [DataContract] inherits System.Runtime.Serialization and it enables the object Serializable. BrokeredMessage create serialize object and you can deserialize this back with PizzaOrder class(meaning that you need this class). 

![](http://i.imgur.com/1nnNgGM.png)

### Issues with Data Contract Serialization

- Cross Platform Compatibility
	- Binary serialization limits cross-platform compatibility.
	- Proprietary to Microsoft Platform. 
- Message Deserialization
	- You need class libraries to deserialize messages
	- Intermediary applications like monitoring tool cannot inspect message body. 
- Versioning Issues
	- Application smay use different versions of message classes and this may break serialization. 

### JSON Message Serialization

- JSON : JavaScript Object Notation
- Provides cross-platform message serialization options
- JSON strings can be serialized to and from message bodies
- More efficient than XML serialization
- Allows looser coupling between applications

![](http://i.imgur.com/Yifuph4.png)

### How to serialize with JSON

** using newtonsoft json library*

![](http://i.imgur.com/H2lFSTx.png)

### How to deserialize JSON

![](http://i.imgur.com/yibscr4.png)

Note that you don't need a PizzaOrder Class to deserialize the message body. This is why it is better, decoupling programming model. 
