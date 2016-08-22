# BizTalk versioning strategies discussion

I would like to highlight a few things that we may have to consider regarding schema versioning. Of course, the purpose of writing this is to seek a best strategy which has least impact and perfect fit for our project. Please take some time to read before we have a discussion.

### Why do we version?
: There is a difference between versioning BizTalk artifacts(including schema) and versioning other .Net assemblies. I will address this later. But, we first need to make sure what the purpose of this practice. 

We are versioning schema because..

* We have schema changes required in next release(including common schema)
* Common schema is used by most other schemas regardless of return type.
* These changes may involve removal of some elements, data types in current schemas and also addition elements, etc. 

###	Do we need to support old schema?
: Once we release new schemas, the forms that are already processed or waiting to be processed on SharePoint will not be valid anymore. To avoid this, we should continue to support old schemas. 

###	Does BizTalk support Side-By-Side deployment?
: As BizTalk recognizes message by its message type which is comprised of target namespace of the schema + root element name, the schemas deployed to BizTalk should have unique message type. So, deploying schema to BizTalk which has same message type is forbidden and expected to get error message by BizTalk engine. However, if you version the assembly of schema project, BizTalk actually allows you to deploy Side-By-Side. In this case, most recent schema assembly will be picked up and used by other BizTalk artefacts like Orchestration, etc. 

###	Pros and Cons of Side-By-Side deployment
**Pros** :  Assembly versioning and Side-By-Side deployment is useful when you have long running transactions (like months and years) and you are never allowed to stop BizTalk services. 

**Cons** : However, not cleaning up previous set of deployment package adds complexity. And it also does not solve issue of supporting old schema. Supporting old schema can only be resolved by explicit version of BizTalk. I will address this later.

### Do we need Side-By-Side deployment at all?
: From my experience releasing version 1.0.2 to production last time, we are allowed to deploy during business hours. If this is the case way forward, Side-By-Side deployment would just add complexity. I recommend we just update assembly file version instead of assembly version. 

###	So, what’s the explicit schema versioning in BizTalk?
: BizTalk recognizes message by its message type. Therefore, the best practice of versioning schema is updating its target namespace explicitly. For this reason, I have previously suggested schema namespace and endpoints folder to have numerical values approach. Please refer to attachment.

###	What does it take for explicit versioning?
: The impact is not small. Message type is a fundamental of BizTalk messaging. We change a fundamental, we will have to change most others as well. 

* Schemas
* Endpoints
* Maps
* Orchestrations
* Deployment package

Well, that’s pretty much everything of BizTalk artifacts. SharePoint would also need to support old InfoPath schemas. To verify old and new schemas are supported, we may have to go through some rigorous testing as well.

###	Any alternative to have least impact?
: The best way to avoid hassle of versioning would be… not versioning at all. But, in this case, we can’t support old schemas. However, as long as we acknowledge issues and be careful with what to change, add and delete in schemas, we may be able to avoid versioning them. 
