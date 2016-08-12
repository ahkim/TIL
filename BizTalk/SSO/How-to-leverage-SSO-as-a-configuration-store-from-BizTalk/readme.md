# How to leverage SSO as a configuration store from BizTalk

BizTalk comes with SSO Database. What this means is that you can leverage SSO as your key-value pair data store. This is scale-able, secure, genuine to BizTalk way of saving/retrieving data. No need to bother with registry key, configuration file, etc. Here goes how you use it. 

### Installation

Download the tool from microsoft [here](https://www.microsoft.com/en-us/download/details.aspx?id=14524) and install. When you have multiple BizTalk Servers(Application server), don't bother installing them from every machine. Just install from one. Whatever you do on the tool will be saved and read from SSO database. 

### Add application, key-value pairs

You will find the tool in following. 

    C:\Program Files (x86)\Microsoft Services\SSO Application Configuration\SSO Application Configuration.msc

Lanch, add application and key value pairs like this. 

![](http://i.imgur.com/ef0z4w6.png)

### How to retrieve from BizTalk

You need add a reference to following assembly in your helper project. 

	C:\Program Files\Common Files\Enterprise Single Sign-On\Microsoft.BizTalk.Interop.SSOClient.dll

Then create a class as below. 

```c#
using Microsoft.BizTalk.SSOClient.Interop;

    public class ConfigurationPropertyBag : IPropertyBag
    {
        private HybridDictionary properties;
        internal ConfigurationPropertyBag()
        {
            properties = new HybridDictionary();
        }
        public void Read(string propName, out object ptrVar, int errLog)
        {
            ptrVar = properties[propName];
        }
        public void Write(string propName, ref object ptrVar)
        {
            properties.Add(propName, ptrVar);
        }
        public bool Contains(string key)
        {
            return properties.Contains(key);
        }
        public void Remove(string key)
        {
            properties.Remove(key);
        }
    }

    public static class SSOClientHelper
    {
        private static string idenifierGUID = "ConfigProperties";

        /// <summary>
        /// Read method helps get configuration data
        /// </summary>        
        /// <param name="appName">The name of the affiliate application to represent the configuration container to access</param>
        /// <param name="propName">The property name to read</param>
        /// <returns>
        ///  The value of the property stored in the given affiliate application of this component.
        /// </returns>
        public static string Read(string appName, string propName)
        {
            try
            {
                SSOConfigStore ssoStore = new SSOConfigStore();
                ConfigurationPropertyBag appMgmtBag = new ConfigurationPropertyBag();
                ((ISSOConfigStore) ssoStore).GetConfigInfo(appName, idenifierGUID, SSOFlag.SSO_FLAG_RUNTIME, (IPropertyBag) appMgmtBag);
                object propertyValue = null;
                appMgmtBag.Read(propName, out propertyValue, 0);
                return (string)propertyValue;
            }
            catch (Exception e)
            {
                System.Diagnostics.Trace.WriteLine(e.Message);
                throw;
            }
        }
    }
```

Now you can retrieve a value for a key like this. 

```c#
	string ret = SSOClientHelper.Read("Test", "TestKey1");
```
