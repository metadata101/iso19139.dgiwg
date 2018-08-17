<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xlink="http://www.w3.org/1999/xlink"
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
                              title="Schematron validation for ISO19115/ISO19139:2007 DGIWG 2.0 Profile"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>
         
        <xsl:value-of select="$archiveNameParameter"/>
         
        <xsl:value-of select="$fileNameParameter"/>
         
        <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gmd" prefix="gmd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/srv" prefix="srv"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gco" prefix="gco"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.fao.org/geonetwork" prefix="geonet"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/DMF20_SC01"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/DMF20_SC02"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/DMF20_SC03"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/DMF20_SC04"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/DMF20_SC05"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/DMF20_SC06"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schematron validation for ISO19115/ISO19139:2007 DGIWG 2.0 Profile</svrl:text>
   <xsl:variable name="resourceTypeCodeList">dataset;series;service;tile;nonGeographicDataset;document;product</xsl:variable>
   <xsl:variable name="standardNames">urn:dgiwg:metadata:dmf:2.0:profile:all;urn:dgiwg:metadata:dmf:2.0:profile:core</xsl:variable>

   <!--PATTERN
        $loc/strings/DMF20_SC01-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/DMF20_SC01"/>
   </svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
      <xsl:variable name="value" select="gmd:language/gmd:LanguageCode/@codeListValue"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$value"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$value">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/DMF20_SC01.alert"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$value">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$value">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/DMF20_SC01.report"/>
               <xsl:text/> "<xsl:text/>
               <xsl:copy-of select="normalize-space($value)"/>
               <xsl:text/>"</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>

   <!--PATTERN
        $loc/strings/DMF20_SC02-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/DMF20_SC02"/>
   </svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
      <xsl:variable name="value" select="gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$value"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$value">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/DMF20_SC02.missing"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$value='utf8'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$value='utf8'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/DMF20_SC02.alert"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$value">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$value">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/DMF20_SC02.report"/>
               <xsl:text/> "<xsl:text/>
               <xsl:copy-of select="normalize-space($value)"/>
               <xsl:text/>"</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>

   <!--PATTERN
        $loc/strings/DMF20_SC03-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/DMF20_SC03"/>
   </svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
      <xsl:variable name="value" select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$value"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$value">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/DMF20_SC03.missing"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="exists(tokenize($resourceTypeCodeList, ';')[. = $value])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="exists(tokenize($resourceTypeCodeList, ';')[. = $value])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/DMF20_SC03.unknown"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$value">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$value">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/DMF20_SC03.report"/>
               <xsl:text/> "<xsl:text/>
               <xsl:copy-of select="normalize-space($value)"/>
               <xsl:text/>"</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>

   <!--PATTERN
        $loc/strings/DMF20_SC04-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/DMF20_SC04"/>
   </svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
      <xsl:variable name="value" select="gmd:metadataStandardName/gco:CharacterString"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$value"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$value">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/DMF20_SC04.missing"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$value">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$value">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/DMF20_SC04.report"/>
               <xsl:text/> "<xsl:text/>
               <xsl:copy-of select="normalize-space($value)"/>
               <xsl:text/>"</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>

   <!--PATTERN
        $loc/strings/DMF20_SC05-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/DMF20_SC05"/>
   </svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
      <xsl:variable name="value" select="gmd:metadataStandardVersion/gco:CharacterString"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$value"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$value">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/DMF20_SC05.missing"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$value">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$value">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/DMF20_SC05.report"/>
               <xsl:text/> "<xsl:text/>
               <xsl:copy-of select="normalize-space($value)"/>
               <xsl:text/>"</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>

   <!--PATTERN
        $loc/strings/DMF20_SC06-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/DMF20_SC06"/>
   </svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
      <xsl:variable name="rstype" select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue"/>
      <xsl:variable name="required"
                    select="not($rstype='nonGeographicDataset') and not($rstype='service')"/>
      <xsl:variable name="exist"
                    select="count(gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox) +                                          count(gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/EX_GeographicDescription) &gt; 0"/>
      <xsl:variable name="ok" select="($required and $exist) or not($required)"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$ok"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$ok">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/DMF20_SC06.alert"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$required">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$required">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/DMF20_SC06.report.required"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="not($required)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not($required)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/DMF20_SC06.report.notrequired"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="$ok">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$ok">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/DMF20_SC06.report"/>
               <xsl:text/> "<xsl:text/>
               <xsl:copy-of select="$required"/>
               <xsl:text/>"</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
</xsl:stylesheet>