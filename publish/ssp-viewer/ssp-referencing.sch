<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <sch:ns prefix="o"  uri="http://csrc.nist.gov/ns/oscal/1.0"/>
    
    <xsl:key name="component-by-uuid" match="component" use="@uuid"/>
    
    <xsl:key name="party-by-uuid" match="party" use="@uuid"/>
    
    <xsl:key name="provided-by-uuid" match="provided | responsibility" use="@uuid"/>
    
    <xsl:key name="role-by-id" match="role" use="@id"/>
    
    <!-- Align with https://github.com/usnistgov/OSCAL/issues/1062 for specs -->
    
    <sch:pattern>
        <sch:rule context="o:implemented-component">
            <sch:let name="component" value="key('component-by-uuid',@component-uuid)"/>
            <sch:assert test="exists($component)" role="warning">Component <sch:value-of select="@component-uuid"/> is not found in this document</sch:assert>
            <!--
            param-id
              warns if target is not a parameter
            control-id
              warns if target is not a control
            statement-id
              scope - imported baseline (as catalog)
              warns if not a 'part' of type (or inside type) 'statement'
            
            component-uuid
                implemented-component/@component-uuid
                by-component/@component-uuid
              errors if not a component listed in this document
              
              if full component instance (target) can be linked/resolved in processing scope, display can 'acquire' it -
                see prop/@name
                  'implementation-point'
                  'inherited-uuid'
                  'leveraged-authorization-uuid'
            
            provided-uuid | responsibility-uuid
                 all targeting 'provided' in the same document
                   or in an inherited SSP (leveraged or otherwise)?
                 or 'provided | responsibility'?
                 
               responsibility/@provided-uuid
               inherited/@provided-uuid
               satisfied/@responsibility-uuid
                 
            
            responsibility-uuid "Identifies a 'provided' assembly associated with this assembly." - shouldn't it be 'provided-uuid'?
            
            //role-id?
            -->
        </sch:rule>
    </sch:pattern>
</sch:schema>