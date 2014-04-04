<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dotml="http://www.martin-loetzsch.de/DOTML" >
	
 	<xsl:template match='/ModelViews/ServicesView' mode='list'>
		<table class='table table-bordered table-hover'>
			<xsl:apply-templates select='Service' mode='list'>
				<xsl:sort select='count(*/Message)' order='descending' data-type='number'/>
			</xsl:apply-templates>
		</table>
	</xsl:template>
	
	<xsl:template match='Service' mode='list'>
		<xsl:variable name='publish-to' select="ServiceConnections/ServiceConnection[@type='publish']"/>
		<xsl:variable name='subscribe-to' select="ServiceConnections/ServiceConnection[@type='subscribe']"/>
		<xsl:variable name='total-rows'>
			<xsl:choose>
				<xsl:when test='count($publish-to) >= count($subscribe-to)'>
					<xsl:value-of select='count($publish-to)'/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select='count($subscribe-to)'/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			<tr >	
				<td class='bg-info' colspan='5'>
				<h4>
				<xsl:value-of select='@short'/>
				<xsl:text> </xsl:text>
				<small><xsl:value-of select='@name'/></small>
				
				<span class='pull-right'>
					<small>
						<xsl:if test='Publish/Message'>
							<span class='text-muted'>Published: </span>
							<xsl:text> </xsl:text>
							<span class='badge' title='Published messages'>
								<xsl:value-of select='count(Publish/Message)'/>
							</span>
							<xsl:text>   </xsl:text>
						</xsl:if>
						<xsl:if test='Subscribe/Message'>
							<span class='text-muted'>Subscribed: </span>
							<xsl:text> </xsl:text>
							<span class='badge' title='Subscribed messages'>
								<xsl:value-of select='count(Subscribe/Message)'/>
							</span>
						</xsl:if>
					</small>
				</span>
				</h4>
				</td>
			</tr>
			<xsl:comment>
				Rows: <xsl:value-of select='$total-rows'/>
				Subscribed connections: <xsl:value-of select='count($subscribe-to)'/>
				Published connections: <xsl:value-of select='count($publish-to)'/>
			</xsl:comment>
			<xsl:call-template name='services-row'>
				<xsl:with-param name='row-no'>1</xsl:with-param>
				<xsl:with-param name='total-rows' select='$total-rows' />
				<xsl:with-param name='subscribe-to' select='$subscribe-to'/>
				<xsl:with-param name='publish-to' select='$publish-to'/>
			</xsl:call-template>
			
	</xsl:template>
	
	<xsl:template name='services-row'>
		<xsl:param name='row-no'>1</xsl:param>
		<xsl:param name='total-rows'>0</xsl:param>
		<xsl:param name='subscribe-to' />
		<xsl:param name='publish-to'/>
		<xsl:choose> 
			<xsl:when test='$row-no > $total-rows' />
			<xsl:otherwise>
				<xsl:comment> Row No: <xsl:value-of select='$row-no'/> of <xsl:value-of select='$total-rows'/></xsl:comment>
				<tr>
					<xsl:call-template name='subscribe-row'>
						<xsl:with-param name='row-no' select='$row-no'/>
						<xsl:with-param name='subscribe-to' select='$subscribe-to'/>
					</xsl:call-template>
					<xsl:choose>
						<xsl:when test='$row-no = 1'>
							<td class='text-center' rowspan='{$total-rows}'>
								<div class='btn btn-primary btn-lg' disabled="disabled"><xsl:value-of select='@name'/></div>
							</td>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
					<xsl:call-template name='publish-row'>
						<xsl:with-param name='row-no' select='$row-no'/>
						<xsl:with-param name='publish-to' select='$publish-to'/>
					</xsl:call-template>
				</tr>
				<xsl:call-template name='services-row'>
					<xsl:with-param name='row-no' select='$row-no + 1' />
					<xsl:with-param name='total-rows' select='$total-rows' />
					<xsl:with-param name='subscribe-to' select='$subscribe-to' />
					<xsl:with-param name='publish-to' select='$publish-to' />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name='subscribe-row'>
		<xsl:param name='row-no'>99</xsl:param>
		<xsl:param name='subscribe-to'/>
		<xsl:variable name='connection' select='$subscribe-to[position() = $row-no]'/>
		<xsl:comment> Row No: <xsl:value-of select='$row-no'/> of <xsl:value-of select='count($subscribe-to)'/> (<xsl:value-of select='$connection/@name'/>)</xsl:comment>
		<xsl:choose>
			<xsl:when test='$row-no > count($subscribe-to)'>
				<xsl:comment>Row: <xsl:value-of select='$row-no'/></xsl:comment>
				<td/>
				<td/>
			</xsl:when>
			<xsl:otherwise>
				<td class='text-center'>
					<xsl:variable name='current-id' select='$connection/ancestor::Service/@id'/>
					<xsl:choose>
						<!-- internal message -->
						<xsl:when test='$connection[@id-ref = $current-id]'>
							<div class='btn btn-default' disabled="disabled"><xsl:value-of select='$connection/@name'/></div>
						</xsl:when>
						<xsl:otherwise>
							<div class='btn btn-info' disabled="disabled"><xsl:value-of select='$connection/@name'/></div>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class='text-left'>
					<xsl:for-each select='$connection/Message'>
						<xsl:variable name='msg' select="key('messages-by-id', @id-ref)"/>
						<div>
							<span class='label label-warning'><xsl:value-of select='$msg/@index'/></span>
							<span class='label label-default'>
								<xsl:value-of select='$msg/@name'/>
							</span>
						</div>
					</xsl:for-each>
				</td>
			</xsl:otherwise>
		</xsl:choose>	</xsl:template>
	
	<xsl:template name='publish-row'>
		<xsl:param name='row-no'>99</xsl:param>
		<xsl:param name='publish-to'/>
		<xsl:variable name='connection' select='$publish-to[position() = $row-no]'/>
		<xsl:choose>
			<xsl:when test='$row-no > count($publish-to)'>
				<xsl:comment>Row: <xsl:value-of select='$row-no'/></xsl:comment>
				<td/>
				<td/>
			</xsl:when>
			<xsl:otherwise>
				<td class='text-left'>
					<xsl:for-each select='$connection/Message'>
						<xsl:variable name='msg' select="key('messages-by-id', @id-ref)"/>
						<div>
							<span class='label label-warning'><xsl:value-of select='$msg/@index'/></span>
							<xsl:text> </xsl:text>	
							<span class='label label-default'>
								<xsl:value-of select='$msg/@name'/>
							</span>
						</div>
					</xsl:for-each>
				</td>
				<td class='text-center'>
					<xsl:variable name='current-id' select='$connection/ancestor::Service/@id'/>
					<xsl:choose>
						<!-- internal message -->
						<xsl:when test='$connection[@id-ref = $current-id]'>
							<div class='btn btn-default' disabled="disabled"><xsl:value-of select='$connection/@name'/></div>
						</xsl:when>
						<xsl:otherwise>
							<div class='btn btn-info' disabled="disabled"><xsl:value-of select='$connection/@name'/></div>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match='Service' mode='list-panel'>
		<hr/>
		<div class="panel panel-default">		
			<div class="panel-heading">
				<span class="glyphicon glyphicon-asterisk"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select='@short'/>
				<xsl:text> </xsl:text>
				<small><xsl:value-of select='@name'/></small>
				<span class='pull-right'>
					<small>
						<xsl:if test='Publish/Message'>
							<span class='text-muted'>Published: </span>
							<xsl:text> </xsl:text>
							<span class='badge' title='Published messages'>
								<xsl:value-of select='count(Publish/Message)'/>
							</span>
							<xsl:text>   </xsl:text>
						</xsl:if>
						<xsl:if test='Subscribe/Message'>
							<span class='text-muted'>Subscribed: </span>
							<xsl:text> </xsl:text>
							<span class='badge' title='Subscribed messages'>
								<xsl:value-of select='count(Subscribe/Message)'/>
							</span>
						</xsl:if>
					</small>
				</span>
			</div>
			<div class="panel-body">
				<xsl:if test='*/Message'>
					<table class='table table-bordered'>
						<xsl:apply-templates select='*/Message' mode='list'>
							<xsl:sort select='@name' />
						</xsl:apply-templates>
					</table>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match='Publish/Message' mode='list'>
		<xsl:variable name='service' select='ancestor::Service'/>
		<xsl:variable name='msg' select="key('messages-by-id', @id-ref)"/>
		<tr>
			<td class='bg-primary'>
				<span class='badge' title='Publisher'>
									<xsl:value-of select='$service/@name'/>
				</span>
				<xsl:text> </xsl:text>	
				<span class="glyphicon glyphicon-arrow-right"/>
			</td>
			<td>
				<span class='label label-success'><xsl:value-of select='$msg/@index'/></span>
				<xsl:text> </xsl:text>	
				<span class='label label-default'>
					<xsl:value-of select='$msg/@name'/>
				</span>
				<xsl:text> </xsl:text>	
				<span class="glyphicon glyphicon-arrow-right"/>
			</td>
			<td class='bg-info'></td>
		</tr>
	</xsl:template>
	
	<xsl:template match='Subscribe/Message' mode='list'>
		<xsl:variable name='service' select='ancestor::Service'/>
		<xsl:variable name='msg' select="key('messages-by-id', @id-ref)"/>
		<tr class=''>
			<td class='bg-info'></td>
			<td>
				<span class="glyphicon glyphicon-arrow-right"/>
				<xsl:text> </xsl:text>	
				<span class='label label-warning'><xsl:value-of select='$msg/@index'/></span>
				<xsl:text> </xsl:text>	
				<span class='label label-default'>
					<xsl:value-of select='$msg/@name'/>
				</span>
			</td>
			<td class='bg-primary'>
				<xsl:text> </xsl:text>	
				<span class="glyphicon glyphicon-arrow-right"/>
				<xsl:text> </xsl:text>	
				<span class='badge' title='Subscriber'>
									<xsl:value-of select='$service/@name'/>
				</span>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
