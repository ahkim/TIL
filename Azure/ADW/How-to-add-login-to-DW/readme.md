# How to add login to Azure SQL/DW

Once database is created, we can't change the server admin. 

![](http://i.imgur.com/AgpInKP.png)

So, in case you need to add service account login and assign role membership later end, login as a server admin and go through following. 

```sql
-- first, connect to the master database
-- Note how you escape special characters in password
Create LOGIN [svc_dev.DB@aklab.com.au] WITH password='5dU\Wdj=0'''; 
-- switch to BIDW
CREATE USER [svc_dev.DB@aklab.com.au] FROM LOGIN [svc_dev.DB@aklab.com.au];
EXEC sp_addrolemember 'db_owner', [svc_dev.DB@aklab.com.au];
```
