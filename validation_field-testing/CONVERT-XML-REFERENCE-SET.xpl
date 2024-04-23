<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:c="http://www.w3.org/ns/xproc-step" version="3.0"
   xmlns:cx="http://xmlcalabash.com/ns/extensions"
   xmlns:ox="http://csrc.nist.gov/ns/oscal-xslt"
   type="ox:CONVERT-XML-REFERENCE-SET"
   name="CONVERT-XML-REFERENCE-SET"
   >
   
   
   
   <p:input port="samples" sequence="true">
      <!-- for the XML, invalid documents are marked with a PI <?ERROR ?> to show an expectation of INVALID -->
      <p:document href="../reference-sets/catalog-model/xml/fully-valid/okay-catalog.xml"/>
      
   </p:input>
   
   <p:for-each>
      <p:variable name="base" select="base-uri(.)"/>
      <p:variable name="json-file" select="replace($base,'xml','json')"/>

      <p:xslt>
         <p:with-input port="stylesheet" href="../lib/oscal-converters/oscal_catalog_xml-to-json-converter.xsl"/>
         <p:with-option name="parameters" select="map{'indent': 'yes'}"/>
      </p:xslt>
      
      <p:store message="Writing JSON file {$json-file} ... " href="{$json-file}"/>
      
   </p:for-each>

   
</p:declare-step>