﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dotml="http://www.martin-loetzsch.de/DOTML" >
	
	<xsl:output method="xml" indent="yes" />
	
	<!-- default is show messages on labels-->
	<!-- options are node, label, none, '' -->
	<xsl:param name='message-format'>node</xsl:param>
	
	<xsl:param name='title'>Adapters</xsl:param>
	
	<xsl:param name='direction'>LR</xsl:param>
	
	<xsl:variable name="record-color">#EEEEEE</xsl:variable>
	<xsl:variable name="border-color">#AAAAAA</xsl:variable>
	<xsl:variable name="background-color">#FFFFFF</xsl:variable>
	<xsl:variable name="message-color">#87D200</xsl:variable>
	
	<xsl:variable name="focus-color">#C4014B</xsl:variable>
	<xsl:variable name="focus-bgcolor">#EEEEEE</xsl:variable>
	<xsl:variable name="focus-text-color">#FFFFFF</xsl:variable>
	<xsl:variable name="other-color">#333333</xsl:variable>
	
	<xsl:variable name="material-other">#CCCCCC</xsl:variable>
	<xsl:variable name="workcenter-color">#2FB4E9</xsl:variable>
	<xsl:variable name="red-color">#FF0000</xsl:variable>
	
	<xsl:variable name='fontname'>Verdana</xsl:variable>
	<xsl:variable name='font-size-h1'>10.0</xsl:variable>
	<xsl:variable name='font-size-h2'>9.0</xsl:variable>
	<xsl:variable name='font-size-h3'>8.0</xsl:variable>
	
	<xsl:template match="/" >
		<xsl:apply-templates select="/ModelViews/AdaptersView"/>
	</xsl:template>
	
	<xsl:template match="/ModelViews/AdaptersView">
		<dotml:graph file-name="services" label="{$title}" rankdir="{$direction}" fontname="{$fontname}" fontsize="{$font-size-h1}" labelloc='t' >			
			<xsl:apply-templates select='Service' mode='node'/>
			<xsl:apply-templates select='Service' mode='link'/>
		</dotml:graph>
	</xsl:template>
	
	<!-- Render the Service nodes as a cluster -->
	<xsl:template match='Service' mode='node'>
		<dotml:cluster id='{concat("svc_", @id)}' 
			label='{@name}' labeljust='l' labelloc="t" 
			style='filled' fillcolor='{$focus-bgcolor}' color="{$focus-color}" 
			fontname="{$fontname}" fontcolor="{$focus-color}" fontsize="{$font-size-h2}"> 
			<xsl:call-template name='render-service'/>
		</dotml:cluster>
	</xsl:template>

	<xsl:template name='render-service'>
		<xsl:for-each select='Adapter'>
			<xsl:variable name='adapter' select='.'/>
			<dotml:node id='{@id}' style="solid" shape="box" label='{@application}' fillcolor='{$focus-bgcolor}' color="{$focus-color}" 
				fontname="{$fontname}" fontsize="{$font-size-h2}" fontcolor="{$focus-color}" />

			<!-- show the messages as nodes? -->
			<xsl:choose>
				<xsl:when test="$message-format = 'node'">
					<xsl:for-each select='Publish/Message'>
						<xsl:variable name='message-id' select="concat($adapter/@id, '_', @id-ref)"/>
						<dotml:node id="{$message-id}" style="solid" shape="ellipse" label='{@name}' 
						  fillcolor='{$focus-bgcolor}' color="{$message-color}" 
						  fontname="{$fontname}" fontsize="{$font-size-h3}" fontcolor="{$message-color}"/>
						<dotml:edge from="{$adapter/@id}" to="{$message-id}" color='{$message-color}'  />
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	<!-- Render the links from published messages to services -->
	<xsl:template match='Service' mode='link'>
		<xsl:comment> Links for <xsl:value-of select='@name'/>  </xsl:comment>
		<xsl:for-each select='Adapter'>
			<xsl:variable name="adapter" select='.'/>
			<xsl:choose>
				<xsl:when test="$message-format = 'node'">
					<xsl:for-each select="AdapterConnections/AdapterConnection[@type='publish']/Message">
						<xsl:variable name='message-id' select="concat($adapter/@id, '_', @id-ref)"/>
						<xsl:variable name='to' select='../@id-ref'/>
						<dotml:edge from="{$message-id}" to="{$to}" color='{$message-color}' />
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="AdapterConnections/AdapterConnection[@type='publish']">
						<xsl:variable name='label'>
							<xsl:if test="$message-format = 'label'">
								<xsl:call-template name='concat-names'>
									<xsl:with-param name='nodes' select='Message'/>
								</xsl:call-template>
							</xsl:if>
						</xsl:variable>
						<dotml:edge from="{$adapter/@id}" to="{@id-ref}" label='{$label}' 
						  color="{$message-color}" fontname="{$fontname}" fontcolor="{$message-color}" fontsize="{$font-size-h2}" />
					</xsl:for-each>				
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="concat-names">
		<xsl:param name="nodes" select='*'/>
		<xsl:for-each select='$nodes[@name]'>
			<xsl:if test='position() > 1'>\n</xsl:if>
			<xsl:value-of select='@name'/>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
