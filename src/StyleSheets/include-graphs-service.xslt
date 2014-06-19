<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:dotml="http://www.martin-loetzsch.de/DOTML" 
	>
	
	<xsl:param name='cluster'>1</xsl:param>
	<xsl:param name='message-format'>label</xsl:param>
	
	<xsl:template match='Service[@id]' mode='include'>Yes</xsl:template>
	
	<xsl:template match="Service[@id]" mode='graph'>
		<xsl:param name="filename"/>
		<dotml:graph file-name="{$filename}" label="Service: {@name}" rankdir="LR" fontname="{$fontname}" fontcolor="{$focus-color}" fontsize="{$font-size-h1}" labelloc='t' >
			<xsl:apply-templates select='.' mode='node'/>
			<xsl:apply-templates select='.' mode='link'/>
		</dotml:graph>
	</xsl:template>
	
	<!-- Render the Service nodes either as a cluster or a single node -->
	<xsl:template match='Service' mode='node'>
		<xsl:choose>
			<xsl:when test='string-length($cluster) = 0'>
				<xsl:call-template name='render-service'/>
			</xsl:when>
			<xsl:otherwise>
				<dotml:cluster id='{concat("svc", @id)}' 
					label='{@name}' labeljust='l' labelloc="t" 
					style='filled' fillcolor='{$focus-bgcolor}' color="{$focus-color}" 
					fontname="{$fontname}" fontcolor="{$focus-color}" fontsize="{$font-size-h2}"> 
					<xsl:call-template name='render-service'/>
				</dotml:cluster>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:for-each select="ServiceConnections/ServiceConnection">
		<dotml:node id='{concat(@type, @id-ref)}' style="solid" shape="box" label='{@name}' 
			fillcolor='{$focus-bgcolor}' color="{$focus-color}" 
			fontname="{$fontname}" fontsize="{$font-size-h2}" fontcolor="{$focus-color}" />
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template name='render-service'>
		<xsl:variable name='service' select='.'/>
		<dotml:node id='{@id}' style="solid" shape="box" label='{@name}' fillcolor='{$focus-bgcolor}' color="{$focus-color}" 
		fontname="{$fontname}" fontsize="{$font-size-h2}" fontcolor="{$focus-color}" />
		
		<!-- show the messages as nodes? -->
		<xsl:choose>
			<xsl:when test="$message-format = 'node'">
				<xsl:for-each select='Publish/Message'>
					<xsl:variable name='message-id' select="concat($service/@id, '_', @id-ref)"/>
					<dotml:node id="{$message-id}" style="solid" shape="ellipse" label='{@name}' 
					  fillcolor='{$focus-bgcolor}' color="{$message-color}" 
					  fontname="{$fontname}" fontsize="{$font-size-h3}" fontcolor="{$message-color}"/>
					<dotml:edge from="{$service/@id}" to="{$message-id}" color='{$message-color}'  />
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	<!-- Render the links from published messages to services -->
	<xsl:template match='Service' mode='link'>
		<xsl:comment> Links for <xsl:value-of select='@name'/>  </xsl:comment>
		<xsl:variable name="service" select='.'/>
		
		<xsl:choose>
			<xsl:when test="$message-format = 'node'">
				<xsl:for-each select="ServiceConnections/ServiceConnection[@type='publish']/Message">
					<xsl:variable name='message-id' select="concat($service/@id, '_', @id-ref)"/>
					<xsl:variable name='to' select='../@id-ref'/>
					<dotml:edge from="{$message-id}" to="{$to}" color='{$message-color}' />
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="ServiceConnections/ServiceConnection[@type='publish']">
					<xsl:variable name='label'>
						<xsl:if test="$message-format = 'label'">
							<xsl:call-template name='concat-names'>
								<xsl:with-param name='nodes' select='Message'/>
							</xsl:call-template>
						</xsl:if>
					</xsl:variable>
					<dotml:edge from="{$service/@id}" to="{@id-ref}" label='{$label}' 
					  color="{$message-color}" fontname="{$fontname}" fontcolor="{$message-color}" fontsize="{$font-size-h2}" />
				</xsl:for-each>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="concat-names">
		<xsl:param name="nodes" select='*'/>
		<xsl:for-each select='$nodes[@name]'>
			<xsl:if test='position() > 1'>\n</xsl:if>
			<xsl:value-of select='@name'/>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
