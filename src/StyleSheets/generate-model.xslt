<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

	<xsl:output method="xml" indent="yes" />
	
	<xsl:key name='sub-msg-by-name' match='Subscribe/Message' use='@name'/>
	<xsl:key name='pub-msg-by-name' match='Publish/Message' use='@name'/>
	
	<xsl:key name='messages-by-name' match='Message' use='@name'/>

	<xsl:key name='services-by-name' match='Service' use='@name'/>

	<xsl:key name='sub-msg-by-service-name' match='Subscribe/Message' use="concat(../../../@name, '-', @name)"/>
	<xsl:key name='pub-msg-by-service-name' match='Publish/Message' use="concat(../../../@name, '-', @name)"/>
	
	<xsl:variable name='messages' select="//Message[count(. | key('messages-by-name', @name)[1]) = 1]"/>
	
	<xsl:template match="Service">
		<xsl:copy>
			<xsl:call-template name='service-id'/>
			<xsl:apply-templates select='@*'/>
			<xsl:variable name='this-service' select='.'/> 
			<xsl:variable name='publish-messages' select='$messages[@name = $this-service/Adapter/Publish/Message/@name]'/>
			<xsl:variable name='subscribe-messages' select='$messages[@name = $this-service/Adapter/Subscribe/Message/@name]'/>

				<xsl:if test='count($publish-messages) > 0'>
					<xsl:element name='Publish'>
						<xsl:for-each select='$publish-messages'>
							<xsl:call-template name='message-node'/>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>

				<xsl:if test='count($subscribe-messages) > 0'>
					<xsl:element name='Subscribe'>
						<xsl:for-each select='$subscribe-messages'>
							<xsl:call-template name='message-node'/>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>

	
			<xsl:variable name='publish-to-services' 
				select="key('sub-msg-by-name', Adapter/Publish/Message/@name)/ancestor::Service" />
			<xsl:variable name='subscribe-to-services' 
				select="key('pub-msg-by-name', Adapter/Subscribe/Message/@name)/ancestor::Service" />
				
			<xsl:if test='(count($publish-to-services) + count($subscribe-to-services)) > 0'>
				<xsl:element name='ServiceConnections'>
				<xsl:if test='count($publish-to-services) > 0'>
					<xsl:for-each select='$publish-to-services'>
						<xsl:variable name='service' select='.'/>
						<xsl:element name='ServiceConnection'>
							<xsl:attribute name='type'>publish</xsl:attribute>
							<xsl:attribute name='name'><xsl:value-of select='@name'/></xsl:attribute>
							<xsl:call-template name='service-id'>
								<xsl:with-param name='attr'>id-ref</xsl:with-param>
							</xsl:call-template>
							<xsl:for-each select='$messages'>
								<xsl:sort select='@name'/>
								<xsl:variable name='publish' select="key('pub-msg-by-service-name', concat($this-service/@name, '-', @name))"/>
								<xsl:variable name='subscribe' select="key('sub-msg-by-service-name', concat($service/@name, '-', @name)) "/>
								<xsl:if test='(count($publish) > 0) and (count($subscribe) > 0)'>
									<xsl:call-template name='message-node'/>
								</xsl:if>
							</xsl:for-each>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test='count($subscribe-to-services) > 0'>
					<xsl:for-each select='$subscribe-to-services'>
						<xsl:variable name='service' select='.'/>
						<xsl:element name='Connection'>
							<xsl:attribute name='type'>subscribe</xsl:attribute>
							<xsl:attribute name='name'><xsl:value-of select='@name'/></xsl:attribute>
							<xsl:call-template name='service-id'>
								<xsl:with-param name='attr'>id-ref</xsl:with-param>
							</xsl:call-template>
							<xsl:for-each select='$messages'>
								<xsl:sort select='@name'/>
								<xsl:variable name='publish' select="key('pub-msg-by-service-name', concat($service/@name, '-', @name))"/>
								<xsl:variable name='subscribe' select="key('sub-msg-by-service-name', concat($this-service/@name, '-', @name)) "/>
								<xsl:if test='(count($publish) > 0) and (count($subscribe) > 0)'>
									<xsl:call-template name='message-node'/>
								</xsl:if>
							</xsl:for-each>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
				</xsl:element>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<xsl:template match='/'>
		<Models>
			<Messages>
				<xsl:for-each select='$messages'>
					<xsl:sort select='@name'/>
					<Message id='{generate-id(.)}' name="{@name}" publish-count="{count(key('pub-msg-by-name', @name))}" subscribe-count="{count(key('sub-msg-by-name', @name))}"/>
				</xsl:for-each>
			</Messages>
			<Services>
				<xsl:apply-templates select='Architecture/Service'/>
			</Services>
		</Models>				
	</xsl:template>
	
	<xsl:template name='service-id'>
		<xsl:param name='name' select='@name'/>
		<xsl:param name='attr'>id</xsl:param>
		<xsl:variable name='service' select="key('services-by-name', $name)"/>
		<xsl:choose>
			<xsl:when test='$service/@name'>
				<xsl:attribute name='{$attr}'><xsl:value-of select="generate-id($service)"/></xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='message-id'>
		<xsl:param name='name' select='@name'/>
		<xsl:param name='attr'>id</xsl:param>
		<xsl:variable name='message' select="$messages[@name=$name]"/>
		<xsl:choose>
			<xsl:when test='$message/@name'>
				<xsl:attribute name='{$attr}'><xsl:value-of select="generate-id($message)"/></xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name='message-node'>
		<xsl:param name='name' select='@name'/>
		<xsl:variable name='message' select="$messages[@name=$name]"/>
		<xsl:choose>
			<xsl:when test='$message/@name'>
				<Message name='{$message/@name}' id-ref="{generate-id($message)}" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
	
</xsl:stylesheet>

