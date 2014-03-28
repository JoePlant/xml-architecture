<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dotml="http://www.martin-loetzsch.de/DOTML" >
	
	<xsl:output method="xml" indent="yes" />
	
	<xsl:param name='cluster'></xsl:param>
	
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
		<xsl:apply-templates select="/Models/Services"/>
	</xsl:template>
	
	<xsl:template match="/Models/Services">
		<dotml:graph file-name="services" label="Services View" rankdir="LR" fontname="{$fontname}" fontcolor="{$focus-color}" fontsize="{$font-size-h1}" labelloc='t' >			
			<xsl:apply-templates select='Service' mode='node'/>
			<xsl:apply-templates select='Service' mode='link'/>
		</dotml:graph>
	</xsl:template>
	
	<!--
    <Service id="EG" name="Customer Service">
      <Publish>
        <Message name="Customer Created" />
        <Message name="Customer Updated" />
      </Publish>
      <Connections>
        <Connection type="publish" name="Loans Service" id-ref="E1">
          <Message name="Customer Updated" />
        </Connection>
        <Connection type="publish" name="Accounts Service" id-ref="EKC">
          <Message name="Customer Created" />
        </Connection>
      </Connections>
    </Service>
	-->
	<xsl:template match='Service' mode='node'>
		<xsl:choose>
			<xsl:when test='string-length($cluster) = 0'>
				<xsl:call-template name='render-service'/>
			</xsl:when>
			<xsl:otherwise>
				<dotml:cluster id='{concat("cluster", position())}' 
					label='{@name}' labeljust='l' labelloc="t" 
					style='filled' fillcolor='{$focus-bgcolor}' color="{$focus-color}" 
					fontname="{$fontname}" fontcolor="{$focus-color}" fontsize="{$font-size-h2}"> 
					<xsl:call-template name='render-service'/>
				</dotml:cluster>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='render-service'>
		<xsl:variable name='service' select='.'/>
		<dotml:node id='{@id}' style="solid" shape="box" label='{@name}' fillcolor='{$focus-bgcolor}' color="{$focus-color}" fontname="{$fontname}" fontsize="{$font-size-h2}" />
		<xsl:for-each select='Publish/Message'>
			<xsl:variable name='message-id' select="concat($service/@id, '_', @id-ref)"/>
			<dotml:node id="{$message-id}" style="solid" shape="parallelogram" label='{@name}' fillcolor='{$focus-bgcolor}' color="{$message-color}" fontname="{$fontname}" fontsize="{$font-size-h3}" />
			<dotml:edge from="{$service/@id}" to="{$message-id}" color='{$message-color}' />
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match='Service' mode='link'>
		<xsl:comment> Links for <xsl:value-of select='@name'/>  </xsl:comment>
		<xsl:variable name="service" select='.'/>
		<xsl:for-each select="Connections/Connection[@type='publish']/Message">
			<xsl:variable name='message-id' select="concat($service/@id, '_', @id-ref)"/>
			<xsl:variable name='to' select='../@id-ref'/>
			<dotml:edge from="{$message-id}" to="{$to}" color='{$message-color}' />
		</xsl:for-each>
	</xsl:template>

<!--
	<xsl:template match='cluster'>
		<dotml:cluster id='{concat("cluster", position())}' 
				label='{@name}' labeljust='l' labelloc="t" 
				style='filled' fillcolor='{$focus-bgcolor}' color="{$focus-color}" 
				fontname="{$fontname}" fontcolor="{$focus-color}" fontsize="{$font-size-h2}">
			<xsl:apply-templates select='node'/>
		</dotml:cluster>
	</xsl:template>
	
	<xsl:template match='node'>
		<dotml:node id='{@name}' style="solid" shape="box" label='{@name}' fillcolor='{$focus-bgcolor}' color="{$focus-color}" />
	</xsl:template>
	
	<xsl:template match='cluster' mode='link'>
		<xsl:for-each select='link'>
			<dotml:edge from="{@from}" to="{@to}" color='{$other-color}' />
		</xsl:for-each>
	</xsl:template>
	-->
</xsl:stylesheet>
