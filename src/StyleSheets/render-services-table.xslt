<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dotml="http://www.martin-loetzsch.de/DOTML" >
	
 <xsl:output
     method="html"
     doctype-system="about:legacy-compat"
     encoding="UTF-8"
     indent="yes" />

	<xsl:key name='messages-by-id' match='Message[@id]' use='@id'/>
	
	<xsl:variable name='crlf'>
</xsl:variable>

	<xsl:template match='/ModelViews/ServicesView' mode='table'>
		<xsl:variable name='publish-services' select='Service[Publish/Message]'/>
		<xsl:variable name='subscribe-services' select='Service[Subscribe/Message]'/>
		
		<div class="table-responsive">
		<table class="table table-bordered table-hover">
			<tr>
				<th colspan='1'/>
				<th colspan="{count($publish-services)}">Publish</th>
			</tr>
			<tr>
				<th>Subscribe</th>
				<xsl:for-each select='$publish-services'>
					<xsl:sort select='count(Publish/Message)' order='descending' data-type='number'/>
					<xsl:call-template name='service-name'>
						<xsl:with-param name='messages' select='Publish/Message'/>
						<xsl:with-param name='id'>pub-</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</tr>
			<!--
			<tr>
				<th colspan='2' data-toggle='collapse' href='#row_pub_msgs'>Published Messages</th>
				<xsl:for-each select='$publish-services'>
					<xsl:sort select='count(Publish/Message)' order='descending' data-type='number'/>
					<xsl:choose>
						<xsl:when test='Publish/Message'>
							<td title="{concat(@name, ' publishes ', count(Publish/Message), 'message(s)')}">
								<small>
									<a data-toggle='collapse' href='#svc_{@id}_pub_msgs'><xsl:value-of select='count(Publish/Message)'/></a>
									<ul id='svc_{@id}_pub_msgs' class='collapse'>
										<xsl:for-each select='Publish/Message'>
											<li><xsl:value-of select='@name'/></li>
										</xsl:for-each>
									</ul>
								</small>
								
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>.</td>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</tr>
			-->
			<xsl:for-each select='$subscribe-services'>
				<xsl:sort select='count(Subscribe/Message)' order='descending' data-type='number'/>
				<xsl:variable name='subscribed-by' select='.'/>
				<tr>
					<xsl:call-template name='service-name'>
						<xsl:with-param name='messages' select='Subscribe/Message'/>
						<xsl:with-param name='id'>sub-</xsl:with-param>
					</xsl:call-template>
					<!--
					<xsl:choose>
						<xsl:when test='Subscribe/Message'>
							<td>
								<small>
									<a data-toggle='collapse' href='#svc_{@id}_sub_msgs'>Subscribes <xsl:value-of select='count(Subscribe/Message)'/> message(s)</a>
									<ul id='svc_{@id}_sub_msgs' class='collapse'>
										<xsl:for-each select='Subscribe/Message'>
											<li><xsl:value-of select='@name'/></li>
										</xsl:for-each>
									</ul>
								</small>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>.</td>
						</xsl:otherwise>
					</xsl:choose>
					-->
					<xsl:for-each select='$publish-services'>
						<xsl:sort select='count(Publish/Message)' order='descending' data-type='number'/>
						<xsl:variable name='published-by' select='.'/>
						<xsl:variable name='div-id' select="concat($subscribed-by/@id,'_', $published-by/@id)"/>
 						<xsl:variable name='connection' select="$published-by/ServiceConnections/ServiceConnection[@type='publish' and @id-ref = $subscribed-by/@id ]"/>
						<xsl:choose>
							<xsl:when test='$connection'>
								<td class='success' data-toggle='collapse' href='#{$div-id}'>
									<small>
										<xsl:for-each select='$connection/Message'>
											<xsl:variable name='msg' select="key('messages-by-id', @id-ref)"/>
											<span class='label label-success' title='{$msg/@name}'><xsl:value-of select='$msg/@index'/></span>
										</xsl:for-each>
									</small>
									<small id='{$div-id}' class='collapse'>
										<xsl:for-each select='$connection/Message'>
											<xsl:variable name='msg' select="key('messages-by-id', @id-ref)"/>
											<li><span class='label label-default'><xsl:value-of select='$msg/@index'/></span>
												<xsl:text> </xsl:text>
												<xsl:value-of select='$msg/@name'/>
											</li>
										</xsl:for-each>
									</small>
								</td>
							</xsl:when>
							<xsl:otherwise><td/></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>
		</div>
	</xsl:template>
	
	<xsl:template name='service-name'>
		<xsl:param name='messages'/>
		<xsl:param name='id'/>
		<th class='info' data-toggle='collapse' href='#{concat($id, @id)}'>
			<div title='{@name}' >
				<xsl:if test='$messages'>
					<span class='badge'><xsl:value-of select='count($messages)'/></span>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:choose>
					<xsl:when test='@short'>
						<xsl:value-of select='@short'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select='@name'/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<small>
				<xsl:for-each select='$messages'>
					<xsl:variable name='msg' select="key('messages-by-id', @id-ref)"/>
					<span class='label label-info' title='{$msg/@name}'><xsl:value-of select='$msg/@index'/></span>
				</xsl:for-each>
			</small>
			<small id='{concat($id, @id)}' class='collapse'>
				
				<xsl:for-each select='$messages'>
					<xsl:variable name='msg' select="key('messages-by-id', @id-ref)"/>
					<li><span class='label label-default'><xsl:value-of select='$msg/@index'/></span>
					<xsl:text> </xsl:text>
					<xsl:value-of select='$msg/@name'/>
					</li>
				</xsl:for-each>
				
			</small>
		</th>
	</xsl:template>
	
	<xsl:template match="/">
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Bootstrap 101 Template</title>

    <!-- Bootstrap -->
    <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="css/services.css" rel="stylesheet"/>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Services</a>
        </div>
        <div class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li class="active"><a href="#top">Home</a></li>
            <li><a href="#services">Services</a></li>
            <li><a href="#adapters">Adapters</a></li>
            <li><a href="#messages">Messages</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </div>

  <a name='top'/>
  <div class="container">
	<xsl:apply-templates select='/ModelViews/ServicesView' mode='table'/>
  </div>
<hr/>
  <a name='services'/>
  <div class='container'>
	<xsl:apply-templates select='/ModelViews/ServicesView' mode='list'/>
  </div>
  
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="lib/jquery/jquery.min.js"/>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="lib/bootstrap/js/bootstrap.min.js"/>
  </body>
</html>
  </xsl:template> 

</xsl:stylesheet>
