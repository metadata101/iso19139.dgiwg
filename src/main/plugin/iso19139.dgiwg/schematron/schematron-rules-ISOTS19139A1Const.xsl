<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                exclude-result-prefixes="#all"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is
      the preferred method for meta-stylesheets to use where possible.
    -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <xsl:include xmlns:svrl="http://purl.oclc.org/dsdl/svrl" href="../../../xsl/utils-fn.xsl"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="lang"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="thesaurusDir"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="rule"/>
   <xsl:variable xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="loc"
                 select="document(concat('../loc/', $lang, '/', $rule, '.xml'))"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p_1"
                          select="1+       count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+     count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@
              <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans
      (Top-level element has index)
    -->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH-->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2-->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="ISO / TS 19139 Table A.1 Constraints"
                              schemaVersion="1.2">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>
         
        <xsl:value-of select="$archiveNameParameter"/>
         
        <xsl:value-of select="$fileNameParameter"/>
         
        <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:text>
    This Schematron schema is designed to test the constraints presented in ISO / TS 19139 Table A.1.
  </svrl:text>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gmd" prefix="gmd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gco" prefix="gco"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gmx" prefix="gmx"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.fao.org/geonetwork" prefix="geonet"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/srv" prefix="srv"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Language Encoding</xsl:attribute>
            <svrl:text>The Language must be documented if not defined by the encoding standard.</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Characterset Encoding</xsl:attribute>
            <svrl:text>
      The CharacterSet must be documented if not defined by the encoding standard and ISO/IEC 10646 is not used.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Characterset Encoding</xsl:attribute>
            <svrl:text>
      The CharacterSet must be documented if ISO/IEC 10646 is not used
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Dataset Extent</xsl:attribute>
            <svrl:text>
      If MD_Metadata.hierarchyLevel is 'dataset' then a bounding box extent or description must be provided
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Dataset Topic Category</xsl:attribute>
            <svrl:text>
      If MD_Metadata.hierarchyLevel does not equal 'dataset' then topicCategory is not mandatory
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">AggregateDataSet</xsl:attribute>
            <svrl:text>
      Either 'aggregateDataSetName' or 'aggregateDataSetIdentifier' must be documented
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Constraints: Other Restrictions</xsl:attribute>
            <svrl:text>
      OtherConstraints must be documented if accessConstraints = 'otherRestrictions'
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ISO19139A1_ROW7_InnerTextPattern</xsl:attribute>
            <xsl:attribute name="name">ISO19139A1_ROW7_InnerTextPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Dataset Lineage</xsl:attribute>
            <svrl:text>
      'report' or 'lineage' role is mandatory if scope.DQ_Scope.level = 'dataset'
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">LevelDescription</xsl:attribute>
            <svrl:text>
      'levelDescription' is mandatory if 'level' is not 'dataset' or 'series'
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Dataset or Series Lineage</xsl:attribute>
            <svrl:text>
    If DQ_DataQuality.scope.level is 'dataset' or 'series' and no source or processStep is provided, then lineage statement is mandatory
      If (count(source) + count(processStep) = 0) and (DQ_DataQuality.scope.level = 'dataset'
      or 'series') then statement is mandatory
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Lineage Source and ProcessStep</xsl:attribute>
            <svrl:text>
      'source' role is mandatory if LI_Lineage.statement and 'processStep' role are not documented
    </svrl:text>
            <svrl:text>
      'processStep' role is mandatory if LI_Lineage.statement and 'source' role are not documented
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Source</xsl:attribute>
            <svrl:text>
      'description' is mandatory if 'sourceExtent' is not documented
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Source Extent</xsl:attribute>
            <svrl:text>
      'sourceExtent' is mandatory if 'description' is not documented
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">MD_Georectified: checkPointAvailability</xsl:attribute>
            <svrl:text>
      'checkPointDescription' is mandatory if 'checkPointAvailability' = 1
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">MD_Band: maxValue and minValue</xsl:attribute>
            <svrl:text>
      'units' is mandatory if 'maxValue' or 'minValue' are provided
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Density</xsl:attribute>
            <svrl:text>
      'densityUnits' is mandatory if 'density' is provided
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Distribution Format</xsl:attribute>
            <svrl:text>
      MD_Distribution must contain a distributionFormat or distributorFormat
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">DataType</xsl:attribute>
            <svrl:text>
      If 'dataType' is not 'codelist', 'enumeration' or 'codeListElement', then 'obligation',
      'maximumOccurrence' and 'domainValue' are mandatory
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ISO19139A1_ROW19_InnerTextPattern_Obligation</xsl:attribute>
            <xsl:attribute name="name">ISO19139A1_ROW19_InnerTextPattern_Obligation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ISO19139A1_ROW19_GcoTypeTestPattern_MaximumOccurrence</xsl:attribute>
            <xsl:attribute name="name">ISO19139A1_ROW19_GcoTypeTestPattern_MaximumOccurrence</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ISO19139A1_ROW19_GcoTypeTestPattern_DomainValue</xsl:attribute>
            <xsl:attribute name="name">ISO19139A1_ROW19_GcoTypeTestPattern_DomainValue</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Obligation</xsl:attribute>
            <svrl:text>
      If 'obligation' equals 'conditional' then 'condition' is mandatory
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ISO19139A1_ROW20_GcoTypeTestPattern</xsl:attribute>
            <xsl:attribute name="name">ISO19139A1_ROW20_GcoTypeTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">DataType</xsl:attribute>
            <svrl:text>
      If 'dataType' equals 'codeListElement' then 'domainCode' is mandatory
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ISO19139A1_ROW21_GcoTypeTestPattern</xsl:attribute>
            <xsl:attribute name="name">ISO19139A1_ROW21_GcoTypeTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">DataType</xsl:attribute>
            <svrl:text>
      If 'dataType' does not equal 'codeListElement' then 'shortName' is mandatory
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ISO19139A1_ROW22_GcoTypeTestPattern</xsl:attribute>
            <xsl:attribute name="name">ISO19139A1_ROW22_GcoTypeTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Extent</xsl:attribute>
            <svrl:text>
      EX_Extent must include a description, geographicElement, temporalExent or VerticalElement
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Responsible Party</xsl:attribute>
            <svrl:text>
      Responsible Party must include an Indvidual Name, or Organisation Name, or Position Name
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Distance Unit of Measurement</xsl:attribute>
            <svrl:text>
      Distance: the distance Unit of Measurement must be instantiated using the UomLength_PropertyType
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ISO19139A1_ROW25_GcoUomTestPattern</xsl:attribute>
            <xsl:attribute name="name">ISO19139A1_ROW25_GcoUomTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Length Unit of Measurement</xsl:attribute>
            <svrl:text>
      Length: The length Unit of Measurement must be instantiated using the UomLength_PropertyType
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ISO19139A1_ROW26_GcoUomTestPattern</xsl:attribute>
            <xsl:attribute name="name">ISO19139A1_ROW26_GcoUomTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Scale Unit of Measurement</xsl:attribute>
            <svrl:text>
      Scale: The scale Unit of Measurement must be instantiated using the UomScale_PropertyType
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ISO19139A1_ROW27_GcoUomTestPattern</xsl:attribute>
            <xsl:attribute name="name">ISO19139A1_ROW27_GcoUomTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Angle Unit of Measurement</xsl:attribute>
            <svrl:text>
      Angle: The angle Unit of Measurement must be instantiated using the UomAngle_PropertyType
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ISO19139A1_ROW28_GcoUomTestPattern</xsl:attribute>
            <xsl:attribute name="name">ISO19139A1_ROW28_GcoUomTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element Values or Nil Reason Attributes</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">ISO / TS 19139 Table A.1 Constraints</svrl:text>

   <!--PATTERN
        Language Encoding-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Language Encoding</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>

   <!--PATTERN
        Characterset Encoding-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Characterset Encoding</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>

   <!--PATTERN
        Characterset Encoding-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Characterset Encoding</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>

   <!--PATTERN
        Dataset Extent-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Dataset Extent</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata | //*[@gco:isoType = 'gmd:MD_Metadata']"
                 priority="1000"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata | //*[@gco:isoType = 'gmd:MD_Metadata']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((not(gmd:hierarchyLevel) or gmd:hierarchyLevel/*/@codeListValue='dataset')                   and (count(gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox) +                   count(gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicDescription)) &gt;= 1) or                   (gmd:hierarchyLevel/*/@codeListValue != 'dataset')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((not(gmd:hierarchyLevel) or gmd:hierarchyLevel/*/@codeListValue='dataset') and (count(gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox) + count(gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicDescription)) &gt;= 1) or (gmd:hierarchyLevel/*/@codeListValue != 'dataset')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        If MD_Metadata.hierarchyLevel is 'dataset' then a bounding box extent or geographic description must be provided
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>

   <!--PATTERN
        Dataset Topic Category-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Dataset Topic Category</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata | //*[@gco:isoType = 'gmd:MD_Metadata']"
                 priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata | //*[@gco:isoType = 'gmd:MD_Metadata']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(not(gmd:hierarchyLevel) or (gmd:hierarchyLevel/*/@codeListValue = 'dataset'))                   and (gmd:identificationInfo/*/gmd:topicCategory) or                   gmd:hierarchyLevel/*/@codeListValue != 'dataset'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(not(gmd:hierarchyLevel) or (gmd:hierarchyLevel/*/@codeListValue = 'dataset')) and (gmd:identificationInfo/*/gmd:topicCategory) or gmd:hierarchyLevel/*/@codeListValue != 'dataset'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_DataIdentification: The topicCategory element is mandatory if the hierarchyLevel is dataset.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>

   <!--PATTERN
        AggregateDataSet-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">AggregateDataSet</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_AggregateInformation | //*[@gco:isoType = 'gmd:MD_AggregateInformation']"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_AggregateInformation | //*[@gco:isoType = 'gmd:MD_AggregateInformation']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="gmd:aggregateDataSetName or gmd:aggregateDataSetIdentifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:aggregateDataSetName or gmd:aggregateDataSetIdentifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_AggregateInformation: Either 'aggregateDataSetName' or 'aggregateDataSetIdentifier' must be documented.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>

   <!--PATTERN
        Constraints: Other Restrictions-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Constraints: Other Restrictions</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_LegalConstraints | //*[@gco:isoType='gmd:MD_LegalConstraints']"
                 priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_LegalConstraints | //*[@gco:isoType='gmd:MD_LegalConstraints']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(count(gmd:accessConstraints/*[@codeListValue = 'otherRestrictions']) &gt;= 1 and                   gmd:otherConstraints) or                   count(gmd:accessConstraints/*[@codeListValue = 'otherRestrictions']) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(count(gmd:accessConstraints/*[@codeListValue = 'otherRestrictions']) &gt;= 1 and gmd:otherConstraints) or count(gmd:accessConstraints/*[@codeListValue = 'otherRestrictions']) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_LegalConstraints: OtherConstraints must be documented if accessConstraints = 'otherRestrictions'.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(count(gmd:useConstraints/*[@codeListValue = 'otherRestrictions']) &gt;= 1 and                   gmd:otherConstraints) or                   count(gmd:useConstraints/*[@codeListValue = 'otherRestrictions']) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(count(gmd:useConstraints/*[@codeListValue = 'otherRestrictions']) &gt;= 1 and gmd:otherConstraints) or count(gmd:useConstraints/*[@codeListValue = 'otherRestrictions']) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_LegalConstraints: OtherConstraints must be documented if useConstraints = 'otherRestrictions'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>

   <!--PATTERN
        ISO19139A1_ROW7_InnerTextPattern-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_LegalConstraints | //*[@gco:isoType='gmd:MD_LegalConstraints']"
                 priority="1000"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_LegalConstraints | //*[@gco:isoType='gmd:MD_LegalConstraints']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(count(gmd:otherConstraints) = 0) or                   (string-length(normalize-space(gmd:otherConstraints)) &gt; 0) or                   (gmd:otherConstraints/@gco:nilReason = 'inapplicable' or                   gmd:otherConstraints/@gco:nilReason = 'missing' or                   gmd:otherConstraints/@gco:nilReason = 'template' or                   gmd:otherConstraints/@gco:nilReason = 'unknown' or                   gmd:otherConstraints/@gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(count(gmd:otherConstraints) = 0) or (string-length(normalize-space(gmd:otherConstraints)) &gt; 0) or (gmd:otherConstraints/@gco:nilReason = 'inapplicable' or gmd:otherConstraints/@gco:nilReason = 'missing' or gmd:otherConstraints/@gco:nilReason = 'template' or gmd:otherConstraints/@gco:nilReason = 'unknown' or gmd:otherConstraints/@gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The '<xsl:text/>
                  <xsl:copy-of select="name(gmd:otherConstraints)"/>
                  <xsl:text/>' element should have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>

   <!--PATTERN
        Dataset Lineage-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Dataset Lineage</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:DQ_DataQuality | //*[@gco:isoType = 'gmd:DQ_DataQuality']"
                 priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:DQ_DataQuality | //*[@gco:isoType = 'gmd:DQ_DataQuality']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(gmd:scope/*/gmd:level/*/@codeListValue = 'dataset') and ((count(gmd:report) + count(gmd:lineage)) &gt; 0) or                   (gmd:scope/*/gmd:level/*/@codeListValue != 'dataset')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(gmd:scope/*/gmd:level/*/@codeListValue = 'dataset') and ((count(gmd:report) + count(gmd:lineage)) &gt; 0) or (gmd:scope/*/gmd:level/*/@codeListValue != 'dataset')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        DQ_DataQuality: 'Report' or 'Lineage' roles are mandatory if scope.DQ_Scope.level = 'dataset'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>

   <!--PATTERN
        LevelDescription-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">LevelDescription</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:DQ_Scope | //*[@gco:isoType = 'gmd:DQ_Scope']" priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:DQ_Scope | //*[@gco:isoType = 'gmd:DQ_Scope']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="gmd:level/*/@codeListValue = 'dataset' or gmd:level/*/@codeListValue = 'series' or gmd:levelDescription"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:level/*/@codeListValue = 'dataset' or gmd:level/*/@codeListValue = 'series' or gmd:levelDescription">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        DQ_Scope: 'levelDescription' is mandatory if 'level' is not 'dataset' or 'series'.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>

   <!--PATTERN
        Dataset or Series Lineage-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Dataset or Series Lineage</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:LI_Lineage | //*[@gco:isoType = 'gmd:LI_Lineage']" priority="1000"
                 mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:LI_Lineage | //*[@gco:isoType = 'gmd:LI_Lineage']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((count(gmd:source) + count(gmd:processStep) = 0) and                   (../../gmd:scope/*/gmd:level/*/@codeListValue = 'dataset' or ../../gmd:scope/*/gmd:level/*/@codeListValue = 'series') and                   count(gmd:statement) = 1) or                   (../../gmd:scope/*/gmd:level/*/@codeListValue != 'dataset' or ../../gmd:scope/*/gmd:level/*/@codeListValue != 'series')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((count(gmd:source) + count(gmd:processStep) = 0) and (../../gmd:scope/*/gmd:level/*/@codeListValue = 'dataset' or ../../gmd:scope/*/gmd:level/*/@codeListValue = 'series') and count(gmd:statement) = 1) or (../../gmd:scope/*/gmd:level/*/@codeListValue != 'dataset' or ../../gmd:scope/*/gmd:level/*/@codeListValue != 'series')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        LI_Lineage: If DQ_DataQuality.scope.level is 'dataset' or 'series' and no source or processStep is provided, then lineage statement is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>

   <!--PATTERN
        Lineage Source and ProcessStep-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Lineage Source and ProcessStep</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:LI_Lineage | //*[@gco:isoType = 'gmd:LI_Lineage']" priority="1000"
                 mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:LI_Lineage | //*[@gco:isoType = 'gmd:LI_Lineage']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(not(gmd:statement) and not(gmd:processStep) and gmd:source) or                   (not(gmd:statement) and not(gmd:source) and gmd:processStep) or                   gmd:statement"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(not(gmd:statement) and not(gmd:processStep) and gmd:source) or (not(gmd:statement) and not(gmd:source) and gmd:processStep) or gmd:statement">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        LI_Lineage: 'source' role is mandatory if LI_Lineage.statement and 'processStep' role are not documented.
        LI_Lineage: 'processStep' role is mandatory if LI_Lineage.statement and 'source' role are not documented.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>

   <!--PATTERN
        Source-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Source</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:LI_Source | //*[@gco:isoType = 'gmd:LI_Source']" priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:LI_Source | //*[@gco:isoType = 'gmd:LI_Source']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="gmd:sourceExtent or gmd:description"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:sourceExtent or gmd:description">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        LI_Source: 'description' is mandatory if 'sourceExtent' is not documented.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

   <!--PATTERN
        Source Extent-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Source Extent</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:LI_Source | //*[@gco:isoType = 'gmd:LI_Source']" priority="1000"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:LI_Source | //*[@gco:isoType = 'gmd:LI_Source']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="gmd:sourceExtent or gmd:description"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:sourceExtent or gmd:description">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        LI_Source: 'sourceExtent' is mandatory if 'description' is not documented.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>

   <!--PATTERN
        MD_Georectified: checkPointAvailability-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">MD_Georectified: checkPointAvailability</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Georectified | //*[@gco:isoType = 'gmd:MD_Georectified']"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Georectified | //*[@gco:isoType = 'gmd:MD_Georectified']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(gmd:checkPointAvailability/gco:Boolean = '1' or                   gmd:checkPointAvailability/gco:Boolean = 'true') and                   gmd:checkPointDescription"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(gmd:checkPointAvailability/gco:Boolean = '1' or gmd:checkPointAvailability/gco:Boolean = 'true') and gmd:checkPointDescription">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_Georectified: 'checkPointDescription' is mandatory if 'checkPointAvailability' = 1
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>

   <!--PATTERN
        MD_Band: maxValue and minValue-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">MD_Band: maxValue and minValue</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Band | //*[@gco:isoType = 'gmd:MD_Band']" priority="1000"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Band | //*[@gco:isoType = 'gmd:MD_Band']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((gmd:maxValue or gmd:minValue) and gmd:units) or                   (not(gmd:maxValue) and not(gmd:minValue) and not(gmd:units))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((gmd:maxValue or gmd:minValue) and gmd:units) or (not(gmd:maxValue) and not(gmd:minValue) and not(gmd:units))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_Band: 'units' is mandatory if 'maxValue' or 'minValue' are provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>

   <!--PATTERN
        Density-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Density</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Medium | //*[@gco:isoType = 'gmd:MD_Medium']" priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Medium | //*[@gco:isoType = 'gmd:MD_Medium']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(gmd:density and gmd:densityUnits) or (not(gmd:density) and not(gmd:densityUnits))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(gmd:density and gmd:densityUnits) or (not(gmd:density) and not(gmd:densityUnits))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_Medium: 'densityUnits' is mandatory if 'density' is provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>

   <!--PATTERN
        Distribution Format-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Distribution Format</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Distribution | //*[@gco:isoType = 'gmd:MD_Distribution']"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Distribution | //*[@gco:isoType = 'gmd:MD_Distribution']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:distributionFormat) &gt; 0 or                   count(gmd:distributor/*/gmd:distributorFormat) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:distributionFormat) &gt; 0 or count(gmd:distributor/*/gmd:distributorFormat) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_Distribution / MD_Format must contain a distributionFormat or distributorFormat.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>

   <!--PATTERN
        DataType-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">DataType</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_ExtendedElementInformation | //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']"
                 priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_ExtendedElementInformation | //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(gmd:dataType/*/@codeListValue = 'codelist' or                   gmd:dataType/*/@codeListValue = 'enumeration' or                   gmd:dataType/*/@codeListValue = 'codelistElement') or                   gmd:obligation"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(gmd:dataType/*/@codeListValue = 'codelist' or gmd:dataType/*/@codeListValue = 'enumeration' or gmd:dataType/*/@codeListValue = 'codelistElement') or gmd:obligation">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_ExtendedElementInformation: If 'dataType' is not 'codelist',
        'enumeration' or 'codelistElement', then 'obligation' is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(gmd:dataType/*/@codeListValue = 'codelist' or                   gmd:dataType/*/@codeListValue = 'enumeration' or                   gmd:dataType/*/@codeListValue = 'codelistElement') or                   gmd:maximumOccurrence"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(gmd:dataType/*/@codeListValue = 'codelist' or gmd:dataType/*/@codeListValue = 'enumeration' or gmd:dataType/*/@codeListValue = 'codelistElement') or gmd:maximumOccurrence">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_ExtendedElementInformation: If 'dataType' is not 'codelist',
        'enumeration' or 'codelistElement', then 'maximumOccurence' is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(gmd:dataType/*/@codeListValue = 'codelist' or                   gmd:dataType/*/@codeListValue = 'enumeration' or                   gmd:dataType/*/@codeListValue = 'codelistElement') or                   gmd:domainValue"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(gmd:dataType/*/@codeListValue = 'codelist' or gmd:dataType/*/@codeListValue = 'enumeration' or gmd:dataType/*/@codeListValue = 'codelistElement') or gmd:domainValue">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_ExtendedElementInformation: If 'dataType' is not 'codelist',
        'enumeration' or 'codelistElement', then 'domainValue' is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>

   <!--PATTERN
        ISO19139A1_ROW19_InnerTextPattern_Obligation-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_ExtendedElementInformation | //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_ExtendedElementInformation | //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(count(gmd:obligation) = 0) or                   (string-length(normalize-space(gmd:obligation)) &gt; 0) or                   (gmd:obligation/@gco:nilReason = 'inapplicable' or                   gmd:obligation/@gco:nilReason = 'missing' or                   gmd:obligation/@gco:nilReason = 'template' or                   gmd:obligation/@gco:nilReason = 'unknown' or                   gmd:obligation/@gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(count(gmd:obligation) = 0) or (string-length(normalize-space(gmd:obligation)) &gt; 0) or (gmd:obligation/@gco:nilReason = 'inapplicable' or gmd:obligation/@gco:nilReason = 'missing' or gmd:obligation/@gco:nilReason = 'template' or gmd:obligation/@gco:nilReason = 'unknown' or gmd:obligation/@gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The '<xsl:text/>
                  <xsl:copy-of select="name(gmd:obligation)"/>
                  <xsl:text/>' element should have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>

   <!--PATTERN
        ISO19139A1_ROW19_GcoTypeTestPattern_MaximumOccurrence-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_ExtendedElementInformation/gmd:maximumOccurrence |                //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']/gmd:maximumOccurrence"
                 priority="1000"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_ExtendedElementInformation/gmd:maximumOccurrence |                //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']/gmd:maximumOccurrence"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                   (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                   @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>

   <!--PATTERN
        ISO19139A1_ROW19_GcoTypeTestPattern_DomainValue-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_ExtendedElementInformation/gmd:domainValue |                //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']/gmd:domainValue"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_ExtendedElementInformation/gmd:domainValue |                //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']/gmd:domainValue"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                   (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                   @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

   <!--PATTERN
        Obligation-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Obligation</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_ExtendedElementInformation | //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']"
                 priority="1000"
                 mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_ExtendedElementInformation | //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((gmd:obligation/*/@codeListValue = 'conditional') and gmd:condition) or                   gmd:obligation/*/@codeListValue != 'conditional' or not(gmd:obligation)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((gmd:obligation/*/@codeListValue = 'conditional') and gmd:condition) or gmd:obligation/*/@codeListValue != 'conditional' or not(gmd:obligation)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_ExtendedElementInformation: If 'obligation' equals 'conditional' then 'condition' is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

   <!--PATTERN
        ISO19139A1_ROW20_GcoTypeTestPattern-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_ExtendedElementInformation/gmd:condition |                //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']/gmd:condition"
                 priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_ExtendedElementInformation/gmd:condition |                //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']/gmd:condition"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                   (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                   @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

   <!--PATTERN
        DataType-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">DataType</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_ExtendedElementInformation | //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']"
                 priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_ExtendedElementInformation | //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((gmd:dataType/*/@codeListValue = 'codelistElement') and gmd:domainCode) or                   gmd:dataType/*/@codeListValue != 'codelistElement'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((gmd:dataType/*/@codeListValue = 'codelistElement') and gmd:domainCode) or gmd:dataType/*/@codeListValue != 'codelistElement'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_ExtendedElementInformation: If 'dataType' equals 'codeListElement' then 'domainCode' is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

   <!--PATTERN
        ISO19139A1_ROW21_GcoTypeTestPattern-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_ExtendedElementInformation/gmd:domainCode |                //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']/gmd:domainCode"
                 priority="1000"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_ExtendedElementInformation/gmd:domainCode |                //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']/gmd:domainCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                   (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                   @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

   <!--PATTERN
        DataType-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">DataType</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_ExtendedElementInformation | //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']"
                 priority="1000"
                 mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_ExtendedElementInformation | //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((gmd:dataType/*/@codeListValue != 'codelistElement') and gmd:shortName) or                   gmd:dataType/*/@codeListValue = 'codelistElement'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((gmd:dataType/*/@codeListValue != 'codelistElement') and gmd:shortName) or gmd:dataType/*/@codeListValue = 'codelistElement'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_ExtendedElementInformation: If 'dataType' does not equal 'codeListElement' then 'shortName' is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>

   <!--PATTERN
        ISO19139A1_ROW22_GcoTypeTestPattern-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_ExtendedElementInformation/gmd:shortName |                //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']/gmd:shortName"
                 priority="1000"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_ExtendedElementInformation/gmd:shortName |                //*[@gco:isoType = 'gmd:MD_ExtendedElementInformation']/gmd:shortName"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                   (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                   @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>

   <!--PATTERN
        Extent-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Extent</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:EX_Extent | //*[@gco:isoType = 'gmd:EX_Extent']" priority="1000"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:EX_Extent | //*[@gco:isoType = 'gmd:EX_Extent']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:description) + count(gmd:geographicElement) +                   count(gmd:temporalElement) + count(gmd:verticalElement) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:description) + count(gmd:geographicElement) + count(gmd:temporalElement) + count(gmd:verticalElement) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        EX_Extent must include a description, geographicElement, temporalExent or VerticalElement
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>

   <!--PATTERN
        Responsible Party-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Responsible Party</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:CI_ResponsibleParty | //*[@gco:isoType = 'gmd:CI_ResponsibleParty']"
                 priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:CI_ResponsibleParty | //*[@gco:isoType = 'gmd:CI_ResponsibleParty']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:individualName) + count(gmd:organisationName) + count(gmd:positionName) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:individualName) + count(gmd:organisationName) + count(gmd:positionName) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Responsible Party must include an Indvidual Name, or Organisation Name, or Position Name
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>

   <!--PATTERN
        Distance Unit of Measurement-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Distance Unit of Measurement</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>

   <!--PATTERN
        ISO19139A1_ROW25_GcoUomTestPattern-->


  <!--RULE
      -->
<xsl:template match="//gco:Distance" priority="1000" mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gco:Distance"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(./@uom) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(./@uom) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The '<xsl:text/>
                  <xsl:copy-of select="name(../..)"/>
                  <xsl:text/>/<xsl:text/>
                  <xsl:copy-of select="name(..)"/>
                  <xsl:text/>/<xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/>' element must have a uom attribute.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>

   <!--PATTERN
        Length Unit of Measurement-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Length Unit of Measurement</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>

   <!--PATTERN
        ISO19139A1_ROW26_GcoUomTestPattern-->


  <!--RULE
      -->
<xsl:template match="//gco:Length" priority="1000" mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gco:Length"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(./@uom) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(./@uom) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The '<xsl:text/>
                  <xsl:copy-of select="name(../..)"/>
                  <xsl:text/>/<xsl:text/>
                  <xsl:copy-of select="name(..)"/>
                  <xsl:text/>/<xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/>' element must have a uom attribute.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>

   <!--PATTERN
        Scale Unit of Measurement-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Scale Unit of Measurement</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>

   <!--PATTERN
        ISO19139A1_ROW27_GcoUomTestPattern-->


  <!--RULE
      -->
<xsl:template match="//gco:Scale" priority="1000" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gco:Scale"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(./@uom) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(./@uom) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The '<xsl:text/>
                  <xsl:copy-of select="name(../..)"/>
                  <xsl:text/>/<xsl:text/>
                  <xsl:copy-of select="name(..)"/>
                  <xsl:text/>/<xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/>' element must have a uom attribute.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>

   <!--PATTERN
        Angle Unit of Measurement-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Angle Unit of Measurement</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>

   <!--PATTERN
        ISO19139A1_ROW28_GcoUomTestPattern-->


  <!--RULE
      -->
<xsl:template match="//gco:Angle" priority="1000" mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gco:Angle"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(./@uom) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(./@uom) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The '<xsl:text/>
                  <xsl:copy-of select="name(../..)"/>
                  <xsl:text/>/<xsl:text/>
                  <xsl:copy-of select="name(..)"/>
                  <xsl:text/>/<xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/>' element must have a uom attribute.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>

   <!--PATTERN
        Element Values or Nil Reason Attributes-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element Values or Nil Reason Attributes</svrl:text>

  <!--RULE
      -->
<xsl:template match="//*" priority="1000" mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="name() = 'geonet:element' or count(*[name()!='geonet:element']) &gt; 0 or                     namespace-uri() = 'http://www.isotc211.org/2005/gco' or                     namespace-uri() = 'http://www.isotc211.org/2005/gmx' or                     namespace-uri() = 'http://www.opengis.net/gml/3.2' or                     namespace-uri() = 'http://www.opengis.net/gml' or                     @codeList or                     @codeListValue or                     local-name() = 'MD_TopicCategoryCode' or                     local-name() = 'URL' or                     (@gco:nilReason = 'inapplicable' or                     @gco:nilReason = 'missing' or                     @gco:nilReason = 'template' or                     @gco:nilReason = 'unknown' or                     @gco:nilReason = 'withheld') or                     @xlink:href"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="name() = 'geonet:element' or count(*[name()!='geonet:element']) &gt; 0 or namespace-uri() = 'http://www.isotc211.org/2005/gco' or namespace-uri() = 'http://www.isotc211.org/2005/gmx' or namespace-uri() = 'http://www.opengis.net/gml/3.2' or namespace-uri() = 'http://www.opengis.net/gml' or @codeList or @codeListValue or local-name() = 'MD_TopicCategoryCode' or local-name() = 'URL' or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld') or @xlink:href">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The '<xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/>' element has no child elements.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>
</xsl:stylesheet>