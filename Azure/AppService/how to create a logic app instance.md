# Triggering a Logic App Instance

### Manual 
makes the Logic app an endpoint for you call 

### Recurrence

a simple trigger that fires based on a schedule

### HTTP

polling an HTTP web endpoint. The HTTP endpoint must conform to a specific triggering contract - either by using a 202-async pattern, or by returning an array

### ApiConnection 

polling like HTTP, however, takes advantage of the Microsoft managed APIs

### HTTPWebhook

opens an endpoint like Manual, but will also call out to the specified URL to register and unregister

### ApiConnectionWebhook

like HTTPWebhook, but taking advantage of the Microsoft managed APIs
