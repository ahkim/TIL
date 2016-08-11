# How to use external assembly in custom xslt?

When you need to do some funky things in BizTalk map and it isn't available from out of the box mapping, then you most likely choose a custom xslt option. 

To do so, you will generate xslt out of "Test Map", save this xslt somewhere and point it from Grid properties.

![](http://i.imgur.com/RN1eRGG.png)

When you do that, you could also points a xml file for Custom Entension XML. This is necessary in case you need to use external assembly in your custom xslt like following.

```xslt
<ns0:param>
  <xsl:attribute name="name">
    <xsl:value-of select="$var:v3" />
  </xsl:attribute>
  <xsl:variable name="var:v4" select="ScriptNS0:ReturnBrand(&quot;IAG&quot; , string(s1:KeyAccountNumber/text()))" />
  <xsl:value-of select="$var:v4" />
</ns0:param>
```

Please note `ScriptNS0` above and how it maps in following.

```xml
<ExtensionObjects>
   <ExtensionObject
      Namespace="http://schemas.microsoft.com/BizTalk/2003/ScriptNS0"
      AssemblyName="AKLab.BizTalk.Helpers, Version=1.0.0.0, Culture=neutral, PublicKeyToken=efdd4f5fe95e7b87"
      ClassName="AKLab.BizTalk.Helpers.MapHelper" />
</ExtensionObjects>
```
