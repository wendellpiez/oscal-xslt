<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:c="http://www.w3.org/ns/xproc-step" version="3.0"
   xmlns:cx="http://xmlcalabash.com/ns/extensions"
   xmlns:ox="http://csrc.nist.gov/ns/oscal-xslt"
   type="ox:DOWNLOAD-CONVERTERS"
   name="DOWNLOAD-CONVERTERS">
   
   <!--
      
      try pxf:copy extension step?
      (would that work with non-XML as well? apparently not)
      
      Since we can't know the URI after downloading, we jerry-rig the file save
      
      <p:input port="source" sequence="true">
      <p:document href="https://github.com/usnistgov/OSCAL/releases/download/v1.1.2/oscal_catalog_xml-to-json-converter.xsl"/>
      <p:document href="https://github.com/usnistgov/OSCAL/releases/download/v1.1.2/oscal_catalog_json-to-xml-converter.xsl"/>      
   </p:input>
   
   <p:for-each>
      <p:variable name="filename" select="(base-uri(.) ! tokenize(.,'/'))[last()]"/>
      <p:store>
         <p:with-option name="href" select="'../lib/' || $filename"/>
      </p:store>
   </p:for-each>-->
      
   <p:input port="resource-names">
      <p:inline>
         <download path="https://github.com/usnistgov/OSCAL/releases/download/v1.1.2">
            <resource dir="oscal-converters">oscal_catalog_xml-to-json-converter.xsl</resource>
            <resource dir="oscal-converters">oscal_catalog_json-to-xml-converter.xsl</resource>
            <resource dir="oscal-schemas">oscal_catalog_schema.xsd</resource>
            <resource dir="oscal-schemas">oscal_catalog_schema.json</resource>
         </download>
      </p:inline>
   </p:input>
   
   <p:variable name="download-path" select="download/@path/string(.)"/>
   
   <p:for-each message="Saving resources in ./lib ...">
      <!-- iterating over each 'resource' as a discrete document node -->
      <p:with-input select="download/resource"/>
      <p:variable name="my-name" select="string(.)"/>
      <p:variable name="dir" select="/*/@dir"/>
      
      <!-- No exception handling since a failed load often produces a result
           making it difficult to anticipate what a failure looks like - -->
      <p:load href="{ ($download-path,$my-name) => string-join('/') }"/>
      <p:store message="... { $dir ! (. || '/')}{ $my-name }" href="{ ('lib',$dir,$my-name) => string-join('/')}"/>
   </p:for-each>
   
</p:declare-step>