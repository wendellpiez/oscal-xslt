<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="specs/fedramp-xslt-validate.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0"
                exclude-result-prefixes="#all">
   
   <xsl:template match="/">
      <html lang="en">
         <head>
            <title>
               <xsl:value-of select="metadata/title"/>
            </title>
            <xsl:call-template name="css-style"/>
         </head>
           <xsl:apply-templates/>
      </html>
   </xsl:template>
   
   <xsl:template match="metadata">
      <xsl:for-each select="title">
         <h1>
            <xsl:apply-templates/>
         </h1>
      </xsl:for-each>
      <section>
         <xsl:apply-templates select="." mode="add-class"/>
         <details>
            <summary>
               <xsl:apply-templates select="." mode="get-label"/>
            </summary>
            <xsl:call-template name="pack-box">
               <xsl:with-param name="label" as="xs:string">Metadata</xsl:with-param>
               <xsl:with-param name="contents" select="child::*"/>
            </xsl:call-template>
         </details>
      </section>
   </xsl:template>
   <xsl:template name="css-style">
      <link rel="stylesheet" href="../nist-emulation.css"/>
      <style type="text/css" xml:space="preserve">

main { font-family: Cambria, Times, serif }

.frm   { font-family: Calibri, Arial, sans-serif }

span.label { display: inline-block }
.lbl { background-color: darkslateblue; color: white; padding: 0.2em; width: max-content }

.h2 { font-size: 120% }

details[open] > summary { margin-bottom: 0.5em }

details { border: thin solid black; padding: 0.4em; margin-top: 0.6em }

section > details > summary { font-size: 120%; font-weight: bold }

div.remarks { margin-top: 0.4em; padding: 0.5em; outline: thin solid black; background-color: gainsboro }
div.remarks * { margin: 0em }

div.description { margin-top: 0.4em; padding: 0.5em; outline: thin solid black; background-color: whitesmoke }
div.description * { margin: 0em }

div.box { padding: 0.4em; border: thin solid black; margin: 0.5em 0em }

div.description, div.remarks  {
  max-width: 40em }

.box > *:first-child { margin-top: 0em }
.box > *:last-child { margin-bottom: 0em }

p.lbl { margin: 0em }
p.lbl + p { margin:0em }

.pln { font-weight: normal; font-style: normal }

span.linktext { font-weight: bold }

div.prop div.remarks { margin-left: 2em; font-size: 90% }
div.status div.remarks { margin-left: 2em; font-size: 90% }

.tbd { background-color: goldenrod !important }

     </style>
   </xsl:template>
   
   <!--<xsl:template match="system-information | authorization-boundary | data-flow | network-architecture | leveraged-authorization | user | information-type | protocol | inventory-item | implemented-component | 
      authorized-privilege | component | implemented-requirement | set-parameter | responsible-role | responsible-party | export
      | confidentiality-impact | integrity-impact | availability-impact | by-component | statement | resource | provided | responsibility | satisfied | inherited">-->
   
   <xsl:template priority="101" match="system-implementation">
      <section>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:copy-of select="@id"/>
         <details>
            <summary>
               <xsl:apply-templates select="." mode="get-label"/>
            </summary>
            <xsl:apply-templates select="* except (component | inventory-item)"/>
            
            <xsl:call-template name="pack-box">
               <xsl:with-param name="label" as="xs:string">components</xsl:with-param>
               <xsl:with-param name="contents" select="child::component"/>
            </xsl:call-template>            
            <xsl:call-template name="pack-box">
               <xsl:with-param name="label" as="xs:string">inventory</xsl:with-param>
               <xsl:with-param name="contents" select="child::inventory-item"/>
            </xsl:call-template>            
         </details>
      </section>
   </xsl:template>
   
   <xsl:template match="control-implementation" priority="100">
      <section>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:next-match/>
      </section>
   </xsl:template>
   
   <xsl:template match="statement[empty(child::*)] | implementation-status[empty(child::*)]">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates select="." mode="get-label"/>
      </p>
   </xsl:template>
   
   
   
   <xsl:template priority="10" match="back-matter">
      <section>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:copy-of select="@id"/>
         <details>
            <summary>
               <xsl:apply-templates select="." mode="get-label"/>
            </summary>
            <xsl:call-template name="pack-box">
               <xsl:with-param name="label" as="xs:string">resource-list</xsl:with-param>
               <xsl:with-param name="contents" select="child::*"/>
            </xsl:call-template>
         </details>
      </section>
   </xsl:template>
   
   
   <xsl:template name="pack-box">
      <xsl:param name="label" required="true" as="xs:string"/>
      <xsl:param name="contents" select="()" as="element()*"/>
      <xsl:where-populated>
         <div class="{ $label } hako1">
            <xsl:apply-templates select="$contents"/>
         </div>
      </xsl:where-populated>
   </xsl:template>
   
   <xsl:template priority="101" match="control-implementation | component | implemented-requirement | statement | by-component | provided | responsibility | inherited | satisfied">
      <details>
         <xsl:apply-templates select="." mode="add-class"/>
         <summary class="h4 frm">
            <xsl:apply-templates select="." mode="get-label"/>
            <!-- for any that have a title or 'selected' (impact levels) ... -->
            <xsl:for-each select="title | selected">
               <xsl:text>: </xsl:text>
               <xsl:apply-templates/>
            </xsl:for-each>
         </summary>
         
         <!-- inside implemented-requirement:
   prop link set-parameter responsible-role statement by-component remarks-->
         
         <xsl:apply-templates
            select="child::* except (inventory-item | set-parameter | responsible-role | implemented-requirement | statement | by-component)"/>
         
         <xsl:call-template name="pack-box">
            <xsl:with-param name="label" as="xs:string">inventory</xsl:with-param>
            <xsl:with-param name="contents" select="child::inventory-item"/>
         </xsl:call-template>
         <xsl:call-template name="pack-box">
            <xsl:with-param name="label" as="xs:string">param-settings</xsl:with-param>
            <xsl:with-param name="contents" select="child::set-parameter"/>
         </xsl:call-template>
         <xsl:call-template name="pack-box">
            <xsl:with-param name="label" as="xs:string">responsible-roles</xsl:with-param>
            <xsl:with-param name="contents" select="child::responsible-role"/>
         </xsl:call-template>
         <xsl:call-template name="pack-box">
            <xsl:with-param name="label" as="xs:string">controls-box</xsl:with-param>
            <xsl:with-param name="contents" select="child::implemented-requirement"/>
         </xsl:call-template>
         <xsl:call-template name="pack-box">
            <xsl:with-param name="label" as="xs:string">statements-box</xsl:with-param>
            <xsl:with-param name="contents" select="child::statement"/>
         </xsl:call-template>
         <xsl:call-template name="pack-box">
            <xsl:with-param name="label" as="xs:string">by-components-box</xsl:with-param>
            <xsl:with-param name="contents" select="child::by-component"/>
         </xsl:call-template>
         
      </details>
   </xsl:template>
   
   
   <xsl:template match="system-security-plan">
      <body class="ssp-body">
         <xsl:apply-templates/>
      </body>
   </xsl:template>
   
   <xsl:template match="metadata/title"/>
   
   <xsl:template match="import-profile">
      <p>
         <xsl:apply-templates mode="add-class"       select="."/>
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates select="@href"/>
      </p>
   </xsl:template>

   <xsl:template match="import-profile/@href" expand-text="true">
      <a href="{.}" class="import">{ . }</a>
   </xsl:template>
   
   <xsl:template match="*" mode="decorate">
      <xsl:param name="label">
         <xsl:apply-templates select="." mode="get-label"/>
      </xsl:param>
      <p class="frm lbl">
         <xsl:sequence select="$label"/>
      </p>
      <xsl:text> </xsl:text>
   </xsl:template>
   
   <xsl:template match="*" mode="decorate-inline">
      <xsl:param name="label">
         <xsl:apply-templates select="." mode="get-label"/>
      </xsl:param>
      <span class="frm lbl">
         <xsl:sequence select="$label"/>
      </span>
      <xsl:text> </xsl:text>
   </xsl:template>
   
   <xsl:template match="*" mode="get-label" expand-text="true">
      <xsl:message>Needing label for '{ name() }'</xsl:message>
      <xsl:text>[label not defined for { name() }]</xsl:text>
   </xsl:template>
   
   <xsl:template match="metadata" mode="get-label">Metadata</xsl:template>
   <xsl:template match="remarks" mode="get-label">Remarks</xsl:template>
   <xsl:template match="description" mode="get-label">Description</xsl:template>
   <xsl:template match="link" mode="get-label">Link</xsl:template>
   <xsl:template match="revision" mode="get-label">Revision</xsl:template>
   
   
   <xsl:template match="diagram" mode="get-label">Diagram</xsl:template>
   <xsl:template match="caption" mode="get-label">Caption</xsl:template>
   
   <xsl:template match="import-profile" mode="get-label">Import profile</xsl:template>
   
   <xsl:template match="system-characteristics | system-implementation | control-implementation | back-matter">
      <section>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:copy-of select="@id"/>
         <details>
            <summary>
               <xsl:apply-templates select="." mode="get-label"/>
            </summary>
            <xsl:apply-templates/>
         </details>
      </section>
   </xsl:template>
   
   
   <xsl:template match="implemented-component[empty(child::*)]">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates select="." mode="get-label"/>
         <xsl:for-each select="key('component-by-uuid',@component-uuid)/title">
            <xsl:text>: </xsl:text>
            <span class="">
               <xsl:apply-templates/>
            </span>
         </xsl:for-each>
      </p>
   </xsl:template>
   
   <xsl:template match="statement[empty(child::*)] | implementation-status[empty(child::*)]">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates select="." mode="get-label"/>
      </p>
   </xsl:template>
   

<!-- set-parameter permits only value and remarks so we
   can place a p when remarks are missing-->
   <xsl:template match="set-parameter[empty(remarks)]">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates select="." mode="get-label"/>
         <xsl:apply-templates select="." mode="show-in-summary"/>
      </p>
   </xsl:template>
   
   <xsl:template match="system-information | authorization-boundary | data-flow | network-architecture | leveraged-authorization | user | information-type | protocol | inventory-item | implemented-component | 
      authorized-privilege | component | implemented-requirement | set-parameter | responsible-role | responsible-party | export
      | confidentiality-impact | integrity-impact | availability-impact | by-component | statement | resource | provided | responsibility | satisfied | inherited">
      <details>
         <xsl:apply-templates select="." mode="add-class"/>
         <summary class="h4 frm">
            <xsl:apply-templates select="." mode="get-label"/>
            <!-- for any that have a title or 'selected' (impact levels) ... -->
            <xsl:apply-templates select="." mode="show-in-summary"/>
         </summary>
         <xsl:apply-templates/>
      </details>
   </xsl:template>
   
   <xsl:template match="responsible-role[empty(*)]" priority="101">
      <h4 class="h4 frm">
            <xsl:apply-templates select="." mode="get-label"/>
            <!-- for any that have a title or 'selected' (impact levels) ... -->
            <xsl:apply-templates select="." mode="show-in-summary"/>
         </h4>
   </xsl:template>
   
   <xsl:template match="*" mode="show-in-summary">
      <xsl:for-each select="title | selected">
         <xsl:text>: </xsl:text>
         <xsl:apply-templates mode="#current"/>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="inventory-item" mode="show-in-summary">
      <xsl:for-each select="description/child::*[1]">
         <xsl:text>: </xsl:text>
         <xsl:apply-templates mode="#current"/>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="set-parameter" mode="show-in-summary" expand-text="true">
      <xsl:apply-templates select="value" mode="#current"/>
   </xsl:template>
   
   <xsl:template match="set-parameter/value" mode="show-in-summary">
      <b class="val">
         <xsl:apply-templates/>
      </b>
   </xsl:template>
   
   <xsl:template match="set-parameter/label" mode="param-head" expand-text="true"> [{ . }]</xsl:template>
   
   <xsl:template match="set-parameter/select" mode="param-head">
      <xsl:text></xsl:text>
   </xsl:template>
   
   


   <xsl:template match="implementation-status">
      <div>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="make-header" select="."/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   
   <xsl:template match="system-name-short | system-id | role-id | party-uuid | document-id">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template match="prop[exists(remarks)]">
      <div>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:next-match/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="prop">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates select="@value"/>
      </p>
   </xsl:template>
   
   <xsl:template match="status[exists(remarks)]">
      <div>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:next-match/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="status">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates select="@state"/>
      </p>
   </xsl:template>
   
   <xsl:template match="system-name">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template mode="get-label" match="system-id">System ID</xsl:template>
   
   <xsl:template mode="get-label" match="user">User</xsl:template>
   <xsl:template mode="get-label" match="role">Role</xsl:template>
   
   <xsl:template mode="get-label" match="component">System component</xsl:template>
   
   <xsl:template mode="get-label" match="by-component">
      <xsl:text>Implementation</xsl:text>
      <xsl:apply-templates select="." mode="xref"/>
   </xsl:template>

   <xsl:template mode="get-label" match="inherited">
      <xsl:text>Inherited control implementation </xsl:text>
      <xsl:apply-templates select="." mode="xref"/>
   </xsl:template>
   
   <xsl:template mode="get-label" match="responsibility">
      <xsl:text>Responsibility</xsl:text>
      <xsl:apply-templates select="." mode="xref"/>
   </xsl:template>
   
   <xsl:template mode="get-label" match="satisfied">
      <xsl:text>Satisfies responsibility</xsl:text>
      <xsl:apply-templates select="." mode="xref"/>
   </xsl:template>

   <xsl:template mode="get-label" match="export">Control implementation for export</xsl:template>
   
   <xsl:template mode="get-label" match="provided">Provided capability</xsl:template>
   
   <xsl:template mode="xref" match="by-component">
      <xsl:for-each select="key('component-by-uuid', @component-uuid)">
         <xsl:text> </xsl:text>
         <a href="#{@uuid}">
            <xsl:apply-templates select="(title,@uuid)[1]"/>
         </a>
      </xsl:for-each>
      <xsl:if test="empty(key('component-by-uuid', @component-uuid))" expand-text="true">
         <i> [component { @component-uuid}]</i>
      </xsl:if>
   </xsl:template>
   
   <xsl:template mode="xref" match="inherited | responsibility">
      <xsl:for-each select="key('provided-by-uuid', @provided-uuid)">
         <xsl:text> </xsl:text>
         <xsl:apply-templates select="." mode="ref"/>
      </xsl:for-each>
      <xsl:if test="empty(key('component-by-uuid', @provided-uuid))">
         <i> [provider cannot be referenced]</i>
      </xsl:if>
   </xsl:template>
   
   <xsl:template mode="xref" match="satisfied">
      <xsl:for-each select="key('provided-by-uuid', @responsibility-uuid)">
         <xsl:text> </xsl:text>
         <xsl:apply-templates select="." mode="ref"/>
      </xsl:for-each>
      <xsl:if test="empty(key('component-by-uuid', @responsibility-uuid))">
         <i> [provider cannot be referenced]</i>
      </xsl:if>
   </xsl:template>
   
   <xsl:template mode="get-label" match="short-name" expand-text="true">{ local-name(..) ! ( (substring(.,1,1)!upper-case(.)) || substring(.,2) ) } name (short)</xsl:template>
   <xsl:template mode="get-label" match="system-information">System information</xsl:template>
   <xsl:template mode="get-label" match="system-name">System name (full)</xsl:template>
   
   <xsl:template mode="get-label" match="system-characteristics" expand-text="true">System{ system-name/(': ' || .) }{ system-name-short/(' (' || . || ')' )}</xsl:template>
   
   <xsl:template mode="get-label" match="system-name-short">System name (short)</xsl:template>
   <xsl:template mode="get-label" match="system-implementation">System composition and configuration</xsl:template>
   
   <xsl:template mode="get-label" match="inventory-item">Inventory item</xsl:template>
   
   <xsl:template mode="get-label" match="implementation-status" expand-text="true">
      <xsl:text>Implementation status</xsl:text>
      <xsl:for-each select="@state">
         <xsl:text> </xsl:text>
         <span class="pln">{ . }</span>
      </xsl:for-each>
   </xsl:template>
   
   
   
   
   <xsl:template mode="get-label" match="protocol" expand-text="true">Protocol <code>{ @name }</code></xsl:template>
   
   <xsl:template mode="get-label" match="responsible-party" expand-text="true">Responsible party{ @role-id/(': ' || .) }</xsl:template>
   
   <xsl:template mode="get-label" match="statement" expand-text="true">Statement{ @statement-id/(': ' || .) }</xsl:template>
   
   <xsl:template mode="get-label" match="responsible-role" expand-text="true">Responsible role{ @role-id/(': ' || .) }</xsl:template>
   
   <xsl:template mode="get-label" match="document-id" expand-text="true">Document ID{ @scheme/(': ' || .) }</xsl:template>
   
   <xsl:template mode="get-label" match="control-implementation" expand-text="true">
      <xsl:text>Security implementation</xsl:text>
      <xsl:variable name="gloss" as="xs:string*">
         <xsl:for-each-group select="implemented-requirement"
            group-by="true()" expand-text="true">{ count(current-group()) } { if (count(current-group()) ne 1) then 'controls' else 'control' }</xsl:for-each-group>
         <xsl:for-each-group select="set-parameter"
            group-by="true()" expand-text="true">{ count(current-group()) } parameter { if (count(current-group()) ne 1) then 'settings' else 'setting' }</xsl:for-each-group>
      </xsl:variable>
      <xsl:if test="exists($gloss[normalize-space(.)])" expand-text="true"> ({ string-join($gloss,', ') })</xsl:if>
   </xsl:template>
   
   <xsl:template mode="get-label" match="implemented-requirement" expand-text="true">Implemented requirement: control <code class="idt">{ @control-id }</code></xsl:template>
   
   <xsl:template mode="get-label" match="set-parameter" expand-text="true">Parameter setting <code class="idt">{ @param-id }</code></xsl:template>
   
   <xsl:template mode="get-label" match="citation">
      <xsl:text>Citation</xsl:text>
      <xsl:for-each select="text">
         <b>
         <xsl:text>: </xsl:text>
         <xsl:apply-templates/>
         </b>
      </xsl:for-each>
   </xsl:template>
   
   
   <xsl:template mode="get-label" match="implemented-component">Implemented component</xsl:template>
   
   <xsl:template mode="get-label" match="back-matter">Back matter</xsl:template>
   
   <xsl:template match="short-name">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <!--<xsl:template match="description[empty(*)]">
      <xsl:call-template name="warn-if-tracing">
         <xsl:with-param name="warning">Empty 'description' element...</xsl:with-param>
      </xsl:call-template>
   </xsl:template>  -->
   
   <xsl:template match="security-sensitivity-level">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template mode="get-label" match="security-sensitivity-level">Security sensitivity level</xsl:template>
   
   <!--<xsl:template match="system-information">
      <div class="system-information">
         <xsl:apply-templates/>
      </div>
   </xsl:template>-->
   
   <xsl:template match="component/purpose">
      <p class="purpose">
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template match="leveraged-authorization/title | user/title | component/title | information-type/title | authorized-privilege/title | protocol/title | resource/title"/>
   
   
   <xsl:template mode="get-label" match="information-type">Information type</xsl:template>
   
   <xsl:template match="categorization">
      <p class="categorization">
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template mode="decorate-inline" match="prop" expand-text="true">
      <span class="frm lbl"><b>{ @name }</b> property{ @ns/(' in namespace ' || .)}</span>
      <xsl:text> </xsl:text>
   </xsl:template>
   
   <xsl:template mode="get-label" match="prop" expand-text="true">{@ns/(.||':')}{@name} property</xsl:template>
   
      <xsl:template mode="get-label" match="value">Value</xsl:template>
      
      <xsl:template mode="get-label" match="resource">Resource</xsl:template>
      
      <xsl:template mode="get-label" match="role-id">Role ID</xsl:template>
   
   <xsl:template mode="get-label" match="port-range">Port range</xsl:template>
   
   <xsl:template mode="get-label" match="party-uuid">Party UUID</xsl:template>
   
   <xsl:template mode="decorate-inline" match="categorization" expand-text="true">
      <span class="frm lbl">{ @system/(. || ' ') }categorization</span>
      <xsl:text> </xsl:text>
   </xsl:template>
   
   <xsl:template match="information-type-id">
      <xsl:apply-templates/>
   </xsl:template>
   
   
   <xsl:template mode="get-label" match="confidentiality-impact">Impact level | Confidentiality</xsl:template>
   
   <xsl:template mode="get-label" match="integrity-impact">Impact level | Integrity</xsl:template>
   
   <xsl:template mode="get-label" match="availability-impact">Impact level | Availability</xsl:template>
   
   <xsl:template match="adjustment-justification">
      <div>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="decorate" select="."/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="security-impact-level">
      <div>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="security-objective-confidentiality | security-objective-integrity | security-objective-availability">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template mode="get-label" match="security-objective-confidentiality">Security objective | Confidentiality</xsl:template>
   
   <xsl:template mode="get-label" match="security-objective-integrity">Security objective | Integrity</xsl:template>
   
   <xsl:template mode="get-label" match="security-objective-availability">Security objective | Availability</xsl:template>
   
   <xsl:template mode="get-label" match="adjustment-justification">Explanation of adjustment</xsl:template>
   
   <xsl:template mode="get-label" match="status">Status</xsl:template>
   
   
   <xsl:template match="authorization-boundary" mode="get-label">Authorization Boundary</xsl:template>
      
   <xsl:template match="network-architecture" mode="get-label">Network Architecture</xsl:template>
   
   <xsl:template match="data-flow" mode="get-label">Data flow</xsl:template>
   
   <xsl:template match="purpose" mode="get-label">Component purpose</xsl:template>
   
   
   <xsl:template match="diagram | caption">
      <div>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates select="." mode="make-header"/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="*" mode="make-header" expand-text="true">
      <h4 class="frm lbl">
         <xsl:apply-templates select="." mode="get-label"/>
      </h4>
   </xsl:template>
   
   <xsl:template match="remarks" mode="make-header" expand-text="true">
      <h4 class="frm lbl">
         <xsl:apply-templates select="." mode="get-label"/>
         <xsl:for-each select="parent::*">
            <span class="pln"> (<xsl:apply-templates select="." mode="get-label"/>)</span>
         </xsl:for-each>
      </h4>
   </xsl:template>
   
   <xsl:template match="leveraged-authorization" mode="get-label">Leveraged Authorization</xsl:template>
   
   <xsl:template match="authorized-privilege" mode="get-label">Authorized Privilege</xsl:template>
   
   <xsl:template match="function-performed">
         <p>
            <xsl:apply-templates select="." mode="add-class"/>
            <xsl:apply-templates select="." mode="decorate-inline"/>
            <xsl:apply-templates/>
         </p>
   </xsl:template>
   
   <xsl:template match="port-range">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates select="." mode="decorate-inline"/>
         <xsl:apply-templates select="@transport, @start, @end"/>
      </p>
   </xsl:template>
   
   <xsl:template match="port-range/@*" expand-text="true">
      <xsl:if test="position() gt 1"> |  </xsl:if>
      <span class="frm">{ local-name(.) }: </span>
      <xsl:value-of select="."/>
   </xsl:template>
   
   <xsl:template match="metadata//party-uuid">
      <p class="party-reference">
         <xsl:apply-templates select="key('party-by-uuid',.)" mode="show-party"/>
      </p>
   </xsl:template>
   
   <xsl:key name="party-by-uuid" match="party" use="@uuid"/>
   
   <xsl:template mode="ref" match="party">
      <xsl:value-of select="child::name"/>
   </xsl:template>
   
   <xsl:template match="metadata//role-id">
      <p class="party-reference">
         <xsl:apply-templates select="key('role-by-id',.)" mode="show-role"/>
      </p>
   </xsl:template>
   
   <xsl:key name="role-by-id" match="role" use="@id"/>
   
   <xsl:template mode="role" match="party">
      <xsl:value-of select="child::short-name"/>
   </xsl:template>
   
   <xsl:key name="component-by-uuid" match="component" use="@uuid"/>
   
   <xsl:template mode="ref" match="component">
      <xsl:value-of select="(child::title,@uuid)[1]"/>
   </xsl:template>
   
   <xsl:key name="provided-by-uuid" match="provided | responsibility" use="@uuid"/>
   
   <xsl:template mode="ref" match="provided | responsibility">
      <xsl:value-of select="(child::title,@uuid)[1]"/>
   </xsl:template>
   
   <xsl:template match="set-parameter/*" priority="-0.1">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates select="." mode="decorate-inline"/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template match="base | selected">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates select="." mode="decorate-inline"/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template match="date-authorized">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates select="." mode="decorate-inline"/>
         <xsl:apply-templates/>
         <span class="annote">
           <xsl:text expand-text="true"> ({ format-date(.,'[MNn,3-3] [D] [Y]') })</xsl:text>
         </span>
      </p>
   </xsl:template>
   
   <xsl:template mode="decorate-inline" match="base | selected" expand-text="true">
      <!-- Capitalize local-name()     -->
      <span class="frm lbl">{ local-name() ! ( (substring(.,1,1)!upper-case(.)) || substring(.,2) ) }</span>
      <xsl:text> </xsl:text>
   </xsl:template>
   
   <xsl:template mode="decorate-inline" match="link" expand-text="true">
      <span class="frm lbl">Link { @rel ! ( '(' || . || ')' ) }</span>
      <xsl:text> </xsl:text>
   </xsl:template>
   
   
   <xsl:template mode="decorate-inline" match="date-authorized">
      <span class="frm lbl">Date authorized</span>
      <xsl:text> </xsl:text>
   </xsl:template>
   
   <xsl:template match="link">
      <p class="link">
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates select="@href, @media-type"/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template match="link/text">
      <xsl:text> </xsl:text>
      <span>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates/>
      </span>
   </xsl:template>
   
   <xsl:template match="@media-type" expand-text="true"> ({ . })</xsl:template>
   
   <!--<xsl:template mode="make-header" match="system-characteristics">
      <span class="h2 frm lbl">System Characteristics</span>
   </xsl:template>
   
   <xsl:template mode="make-header" match="system-implementation">
      <span class="h2 frm lbl">System Implementation</span>
   </xsl:template>-->
   
   
   <xsl:template match="citation | rlink">
      <div>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <!-- Captured in the citatation head -->
   <xsl:template match="citation/text"/>
   
   <xsl:template match="hash | base64">
      <p>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="decorate-inline" select="."/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template mode="get-label" match="rlink">Resource link</xsl:template>
      
   <xsl:template mode="get-label" match="hash" expand-text="true">Hash{ @algorithm/(': ' || .) }</xsl:template>
   
   <xsl:template mode="get-label" match="base64" expand-text="true">Base 64 data{ @media-type/(' (' || . || ')' ) }</xsl:template>
   
   
   <xsl:template match="remarks">
      <div>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="make-header" select="."/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="description">
      <div>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:apply-templates mode="make-header" select="."/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
<!-- Often we don't want a header or box around the description -
     when required and/or appearing first -->
   <xsl:template match="information-type/description | network-architecture/description | authorization-boundary/description | data-flow/description | control-implementation/description | component/description | inventory-item/description | by-component/description | resource/description | export/description | provided/description | responsibility/description | satisfied/description | inherited/description">
      <xsl:apply-templates/>
   </xsl:template>
   
   <!-- In the special case of an inventory item with a one-line description, we drop it, because it is acquired into the details/summary above it.  -->
   <xsl:template priority="10" match="inventory-item/description[count(child::*) = 1]"/>
   
   <xsl:template match="p | table | pre | ul | ol | li | h1 | h2 | h3 | h4 | h5 | h6 | code |      
      a | img | strong | em | b | i | sup | sub">
      <xsl:apply-templates select="." mode="html-ns"/>
   </xsl:template>
   
   <xsl:template match="insert" mode="html-ns">
      <xsl:apply-templates select="." mode="#default"/>
   </xsl:template>
   
   <xsl:template match="*" mode="html-ns">
      <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates mode="#current"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template mode="add-class" match="*">
      <xsl:attribute name="class">
         <xsl:value-of separator=" ">
            <xsl:apply-templates select="." mode="class-name"/>
         </xsl:value-of>
      </xsl:attribute>
   </xsl:template>
   
   <xsl:template mode="class-name" match="information-type | confidentiality-impact | integrity-impact | availability-impact | adjustment-justification | statement | authorization-boundary | network-architecture | data-flow | diagram | caption | citation" as="xs:string*">
      <xsl:text>box</xsl:text>
      <xsl:next-match/>
   </xsl:template>
   
   <xsl:template mode="class-name" match="party-uuid | component-id | role-id" as="xs:string*">
      <xsl:text>tbd</xsl:text>
      <xsl:next-match/>
   </xsl:template>
   
   <xsl:template mode="class-name" match="link/text" as="xs:string*">linktext</xsl:template>
      
   <xsl:template mode="class-name" match="*" as="xs:string*">
      <xsl:sequence select="(@name!string(.), tokenize(@class,' '), local-name()) => distinct-values()"/>
   </xsl:template>
   
   
   
   
   <!-- parents of responsible-role -  component | implemented-requirement | statement | by-component | provided | responsibility | inherited | satisfied-->
   <!--<xsl:template match="system-characteristics | system-implementation | back-matter">
      <section>
         <xsl:apply-templates select="." mode="add-class"/>
         <xsl:copy-of select="@id"/>
         <details>
            <summary>
               <xsl:apply-templates select="." mode="get-label"/>
            </summary>
            <xsl:apply-templates/>
         </details>
      </section>
   </xsl:template>-->
   
   
   
   <!--
main { font-family: Cambria, Times, serif }

.frm   { font-family: Calibri, Arial, sans-serif }

span.label { display: inline-block }
.lbl { background-color: darkslateblue; color: white; padding: 0.2em; width: max-content }

.h2 { font-size: 120% }

details[open] > summary { margin-bottom: 0.5em }

details { border: thin solid black; padding: 0.4em; margin-top: 0.6em }

section > details > summary { font-size: 120%; font-weight: bold }

div.remarks { margin-top: 0.4em; padding: 0.5em; outline: thin solid black; background-color: gainsboro }
div.remarks * { margin: 0em }

div.description { margin-top: 0.4em; padding: 0.5em; outline: thin solid black; background-color: whitesmoke }
div.description * { margin: 0em }

div.box { padding: 0.4em; border: thin solid black; margin: 0.5em 0em }

div.description, div.remarks  {
  max-width: 40em }

.box > *:first-child { margin-top: 0em }
.box > *:last-child { margin-bottom: 0em }

p.lbl { margin: 0em }
p.lbl + p { margin:0em }

.pln { font-weight: normal; font-style: normal }

span.linktext { font-weight: bold }

div.prop div.remarks { margin-left: 2em; font-size: 90% }
div.status div.remarks { margin-left: 2em; font-size: 90% }

.tbd { background-color: goldenrod !important }
-->
   
</xsl:stylesheet>