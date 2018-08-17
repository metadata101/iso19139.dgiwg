<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">

  <xsl:import href="../../iso19139/layout/utility-tpl.xsl"/>
  <xsl:include href="utility-tpl-multilingual.xsl"/>

  <xsl:template name="get-iso19139.dgiwg-title">
    <xsl:call-template name="get-iso19139-title"/>
  </xsl:template>

	<xsl:template name="get-iso19139.dgiwg-is-service">
		<xsl:call-template name="get-iso19139-is-service"/>
	</xsl:template>

	<xsl:template name="get-iso19139.dgiwg-extents-as-json">
		<xsl:call-template name="get-iso19139-extents-as-json"/>
	</xsl:template>

  <xsl:template name="get-iso19139.dgiwg-online-source-config">
    <xsl:param name="pattern"/>
    <xsl:call-template name="get-iso19139-online-source-config">
        <xsl:with-param name="pattern" select="$pattern"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>

