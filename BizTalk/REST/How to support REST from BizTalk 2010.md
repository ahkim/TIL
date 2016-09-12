# How to support REST service consumption from BizTalk 2010

### Why doesn't it support?

Question has to from here. 

#### BizTalk requires a message!

> This is somewhat problematic as all parameters for a GET or DELETE request is passed along with the URI, not the payload. Because of this, we need to intercept the request and create a “real” message using the parameters passed on by the URI. Using a dynamic URI’s reveals yet an other challenge, as URI’s are generally of a static nature for BizTalk. This is where the WebHttpBinding comes in to place, as it let’s us define a base URI which our service (Receive Location) will listen to, regardless of what proceeds the base URI, 

	http://somedomamin.com/Customers(1234)

#### BizTalk only accepts POST!

> This was the most difficult problem to solve, and I’ll get more into detail on this later. But the basic principle is that upon creating the message described before, it will add necessary meta data to the message to let BizTalk think this is a POST message.

#### BizTalk only understand XML!

> If the consumer sends a GET request to the service, it also passes along information in the HTTP header, letting us know what format is expected. This is done through the “Accept” header, and could be either “application/xml” or “application/json” (there are others, but xml and json are the only supported ones using the REST Start Kit).

> In case of a GET request, the outgoing message will get converted from XML to JSON using JSON.Net. If the consumer sends a POST request, the header could state: Content-Type: application/json. If this is the case, the incoming request will also be converted.

### Step 1 - Add behavior to resolve all above

[Rest Starter Kit](http://biztalkrest.codeplex.com/) is a beginning point to start all. Add this and update as needed to resolve issues above. 

Note : You *have to* use **WebHttpBinding**.

### Step 2 - Add behavior to handle OAuth authentication

Most REST service now requires OAuth authentication. You will need to add another wcf behavior to resolve this. 

[SfdcREstAuthInspector](https://developer.salesforce.com/page/Calling_the_Force.com_REST_API_from_BizTalk_Server) is a great start. 

### Step 3 - Add behavior to handle exceptions

As you progress further, you will have trouble in exception handling. You need to additional wcf behavior to handle this. 

[This](https://code.msdn.microsoft.com/BizTalk-Server-REST-Error-52fa4ff0) is a great start. 

Note : Following is *very* important in configuring the behavior. 

- Change the WCF-Custom adapter binding to **customBinding**
- Remove the textMessageEncoding binding element and add the **webMessageEncoding** instead
- Add the custom WebRequestInterceptor extension
- Set the httpTransport element “**ManualAddressing**” attribute to **true**
	- If not, you will end up with endpoint not found exception
