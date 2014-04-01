<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dotml="http://www.martin-loetzsch.de/DOTML" >
	
 <xsl:output
     method="html"
     doctype-system="about:legacy-compat"
     encoding="UTF-8"
     indent="yes" />
	

	<xsl:template match='/ModelViews/ServicesView' mode='table'>
		<xsl:variable name='services' select='Service'/>
		<div class="table-responsive">
		<table class="table table-bordered table-hover">
			<tr>
				<th colspan='2'/>
				<th colspan="{count($services)}">Publish</th>
			</tr>
			<tr>
				<th><!-- Subscribe--></th>
				<th>Subscribed Messages</th>
				<xsl:for-each select='$services'>
					<th><xsl:value-of select='@name'/></th>
				</xsl:for-each>
			</tr>
			<tr>
				<th colspan='2'>Published Messages</th>
				<xsl:for-each select='$services'>
					<xsl:choose>
						<xsl:when test='Publish/Message'>
							<td>
								<small>
									<a data-toggle='collapse' href='#svc_{@id}_pub_msgs'><xsl:value-of select='count(Publish/Message)'/> messages published</a>
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
			<xsl:for-each select='$services'>
				<xsl:variable name='subscribed-by' select='.'/>
				<tr>
					<th><xsl:value-of select='@name'/></th>
					<xsl:choose>
						<xsl:when test='Subscribe/Message'>
							<td>
								<small>
									<a data-toggle='collapse' href='#svc_{@id}_sub_msgs'><xsl:value-of select='count(Subscribe/Message)'/> messages subscribed</a>
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
					<xsl:for-each select='$services'>
						<xsl:variable name='published-by' select='.'/>
						<xsl:variable name='div-id' select="concat($subscribed-by/@id,'_', $published-by/@id)"/>
						<td>
						<xsl:variable name='connection' select="$published-by/ServiceConnections/ServiceConnection[@type='publish' and @id-ref = $subscribed-by/@id ]"/>
						<xsl:choose>
							<xsl:when test='$connection'>
								<small>
									<div data-toggle='collapse' href='#{$div-id}'><xsl:value-of select='count($connection/Message)'/> messages </div>
										<ul id='{$div-id}' class='collapse'>
										<xsl:for-each select='$connection/Message'>
											<li><xsl:value-of select='@name'/></li>
										</xsl:for-each>
									</ul>
								</small>
							</xsl:when>
							<xsl:otherwise>.</xsl:otherwise>
						</xsl:choose>
						</td>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>
		</div>
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

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
  <div class="container">
	<xsl:apply-templates select='/ModelViews/ServicesView' mode='table'/>
	
	</div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="lib/jquery/jquery.min.js"/>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="lib/bootstrap/js/bootstrap.min.js"/>
  </body>
</html>
  </xsl:template> 

</xsl:stylesheet>
