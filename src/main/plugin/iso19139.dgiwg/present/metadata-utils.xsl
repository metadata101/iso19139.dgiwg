<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:srv="http://www.isotc211.org/2005/srv"
    xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:java="java:org.fao.geonet.util.XslUtil"
    version="2.0">

    <xsl:import href="../../iso19139/present/metadata-utils.xsl"/>

    <xsl:template name="dgiwg_get_crs">
        <xsl:param name="md"/>

        <xsl:variable name="rsi"
                      select="$md/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier|
                              $md/gmd:referenceSystemInfo/
                                   *[contains(@gco:isoType, 'MD_ReferenceSystem')]/gmd:referenceSystemIdentifier/gmd:RS_Identifier"/>

        <xsl:variable name="crsCodespace" select="$rsi/gmd:codeSpace/gco:CharacterString"/>
        <xsl:variable name="crsCode"      select="$rsi/gmd:code/gco:CharacterString"/>
        <xsl:variable name="crsVersion"   select="$rsi/gmd:version/gco:CharacterString"/>
        <!--http://www.opengis.net/def/crs/EPSG/0/4326-->

        <xsl:variable name="version" select="if (string($crsVersion) != '') then $crsVersion else '0'"/>
        
        <!-- some heuristic -->
        <xsl:choose>
            <xsl:when test="substring-before($crsCode,':') = 'EPSG'">http://www.opengis.net/def/crs/EPSG/<xsl:value-of select="$version"/>/<xsl:value-of select="substring-after($crsCode,':')"/></xsl:when>
            <xsl:otherwise>http://www.opengis.net/def/crs/UNKNOWN/0/<xsl:value-of select="$crsCode"/></xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
