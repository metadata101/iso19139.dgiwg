<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- DGIWG 2.0 SCHEMATRON-->

    <sch:title xmlns="http://www.w3.org/2001/XMLSchema">Schematron validation for ISO19115/ISO19139:2007 DGIWG 2.0 Profile</sch:title>

    <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
    <sch:ns prefix="gmd" uri="http://www.isotc211.org/2005/gmd"/>
    <sch:ns prefix="srv" uri="http://www.isotc211.org/2005/srv"/>
    <sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>
    <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
    <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>

    <sch:let name="resourceTypeCodeList">dataset;series;service;tile;nonGeographicDataset;document;product</sch:let>
    <sch:let name="standardNames">urn:dgiwg:metadata:dmf:2.0:profile:all;urn:dgiwg:metadata:dmf:2.0:profile:core</sch:let>

    <!-- SC01 METADATA LANGUAGE -->
    <sch:pattern>
        <sch:title>$loc/strings/DMF20_SC01</sch:title>
        <sch:rule context="//gmd:MD_Metadata">
            <sch:let name="value" value="gmd:language/gmd:LanguageCode/@codeListValue"/>

            <sch:assert test="$value">$loc/strings/DMF20_SC01.alert</sch:assert>
            <sch:report test="$value"><sch:value-of select="$loc/strings/DMF20_SC01.report"/> "<sch:value-of select="normalize-space($value)"/>"</sch:report>

        </sch:rule>
    </sch:pattern>

    <!-- SC02 METADATA CHARSET -->
    <sch:pattern>
        <sch:title>$loc/strings/DMF20_SC02</sch:title>
        <sch:rule context="//gmd:MD_Metadata">
            <sch:let name="value" value="gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue"/>

            <sch:assert test="$value">$loc/strings/DMF20_SC02.missing</sch:assert>
            <sch:assert test="$value='utf8'">$loc/strings/DMF20_SC02.alert</sch:assert>
            <sch:report test="$value"><sch:value-of select="$loc/strings/DMF20_SC02.report"/> "<sch:value-of select="normalize-space($value)"/>"</sch:report>

        </sch:rule>
    </sch:pattern>

    <!-- SC03 HIERARCHY LEVEL -->
    <sch:pattern>
        <sch:title>$loc/strings/DMF20_SC03</sch:title>
        <sch:rule context="//gmd:MD_Metadata">
            <sch:let name="value" value="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue"/>

            <sch:assert test="$value">$loc/strings/DMF20_SC03.missing</sch:assert>
            <sch:assert test="exists(tokenize($resourceTypeCodeList, ';')[. = $value])">$loc/strings/DMF20_SC03.unknown</sch:assert>-->

            <sch:report test="$value"><sch:value-of select="$loc/strings/DMF20_SC03.report"/> "<sch:value-of select="normalize-space($value)"/>"</sch:report>

        </sch:rule>
    </sch:pattern>


    <!-- SC04 METADATA STANDARD NAME-->
    <sch:pattern>
        <sch:title>$loc/strings/DMF20_SC04</sch:title>
        <sch:rule context="//gmd:MD_Metadata">
            <sch:let name="value" value="gmd:metadataStandardName/gco:CharacterString"/>

            <sch:assert test="$value">$loc/strings/DMF20_SC04.missing</sch:assert>
            <sch:report test="$value"><sch:value-of select="$loc/strings/DMF20_SC04.report"/> "<sch:value-of select="normalize-space($value)"/>"</sch:report>

        </sch:rule>
    </sch:pattern>

    <!-- SC05 METADATA STANDARD VERSION-->
    <sch:pattern>
        <sch:title>$loc/strings/DMF20_SC05</sch:title>
        <sch:rule context="//gmd:MD_Metadata">
            <sch:let name="value" value="gmd:metadataStandardVersion/gco:CharacterString"/>

            <sch:assert test="$value">$loc/strings/DMF20_SC05.missing</sch:assert>
            <sch:report test="$value"><sch:value-of select="$loc/strings/DMF20_SC05.report"/> "<sch:value-of select="normalize-space($value)"/>"</sch:report>

        </sch:rule>
    </sch:pattern>

    <!-- SC06 GEOGRAPHIC EXTENTS -->
    <sch:pattern>
        <sch:title>$loc/strings/DMF20_SC06</sch:title>
        <sch:rule context="//gmd:MD_Metadata">

            <sch:let name="rstype" value="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue"/>
            <sch:let name="required" value="not($rstype='nonGeographicDataset') and not($rstype='service')"/>
            <sch:let name="exist" value="count(gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox) +
                                         count(gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/EX_GeographicDescription) > 0"/>
            <sch:let name="ok" value="($required and $exist) or not($required)"/>

            <sch:assert test="$ok">$loc/strings/DMF20_SC06.alert</sch:assert>
            <sch:report test="$required"><sch:value-of select="$loc/strings/DMF20_SC06.report.required"/></sch:report>
            <sch:report test="not($required)"><sch:value-of select="$loc/strings/DMF20_SC06.report.notrequired"/></sch:report>
            <sch:report test="$ok"><sch:value-of select="$loc/strings/DMF20_SC06.report"/> "<sch:value-of select="$ok"/>"</sch:report>

        </sch:rule>
    </sch:pattern>


    <!-- 5.3.2 RSTYPN:
        RSTYPN value shall differ from RSTYPE when it is set, in
        order to provide a more comprehensive name for the type of
        resource. -->

    <!-- 5.3.2 RSTYPN:
        RSTYPN should be documented if RSTYPE not equal to dataset -->

    <!-- 5.3.2 RSTOPIC:
        Mandatory if RSTYPE equal to dataset or series   -->

    <!-- 5.3.3 DGITYP:
        Not applicable to non-geographic data -->

    <!-- 5.3.3 RSSERI:
        This metadata element is not applicable to series and services. -->

    <!-- 5.3.3 RSSHNA:
        This metadata element is not applicable to series and services. -->


    <!-- 5.3.4 SROPRS
        Mandatory if coupling type is tight or mixed. -->

    <!-- 5.3.4 SRCORS
        Only applicable to tightly coupled services. -->


    <!-- 5.3.8 RSEXT
        Except for non-geographic data and loose services, one
        extent of type bounding box or geographic identifier is
        mandatory.

        !!! Already covered by SC06 -->

    <!-- 5.3.9 RSDATE
        When RSTYPE is dataset or series, there should be one
        creation date. -->

    <!-- 5.3.9 RSDATE
        For a service, use the publication date of the service. -->


    <!-- 5.3.12 RSONLLC
        Mandatory for services

        !!! Already covered by SC11 -->


</sch:schema>
