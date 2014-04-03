<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dotml="http://www.martin-loetzsch.de/DOTML" >
	
 <xsl:output
     method="html"
     doctype-system="about:legacy-compat"
     encoding="UTF-8"
     indent="yes" />

	<xsl:include href='render-services-table.xslt'/>
	
	<xsl:key name='messages-by-id' match='Message[@id]' use='@id'/>
	
	<xsl:variable name='crlf'>
</xsl:variable>


	<xsl:template match="/">
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Services Analysis</title>

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
  <br/>
  
  <div class="container">
<hr/>
	<h3>Summary</h3>
	<xsl:apply-templates select='/ModelViews/ServicesView' mode='table'/>
<hr/>
  <a name='services'/>
  <h3>Services</h3>
	<xsl:apply-templates select='/ModelViews/ServicesView' mode='list'/>

<hr/>
  <a name='adapters'/>
  <h3>Adapters</h3>
  
<hr/>
  <a name='messages'/>
  <h3>Messages</h3>  
  </div>
<hr/>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="lib/jquery/jquery.min.js"/>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="lib/bootstrap/js/bootstrap.min.js"/>
  </body>
</html>
  </xsl:template> 

</xsl:stylesheet>
