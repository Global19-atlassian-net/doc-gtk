<?xml version='1.0' encoding='ISO-8859-1' ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">

<!-- $Id: util.xsl,v 1.3 2001-08-12 12:08:10 jmoore Exp $ -->
		
<!-- ================== Utility Functions ============================ -->

<!--
  * Function:	get.class.title
  * Params:	classentry - The classentry node
  * Returns:	The classentry's classes Title
-->
 <xsl:template name="get.class.title">
  <xsl:param name="classentry"/>

  <xsl:value-of select="$classentry/classmeta/classtitle"/>
  
 </xsl:template>

<!--
 * Function:	get.classentry.from.title
 * Params:	title - The title of the classentry we are looking for
 * 		[root - the root to start seaching from]
 * Returns	The classentry's node
-->
 <xsl:template name="get.classentry.from.title">
  <xsl:param name="title" />	 
  <xsl:param name="root" select="/"/>

  <xsl:copy-of select="$root//classentry[classmeta/classtitle = $title]"/>
 
 </xsl:template>

<!--
  * Function:	get.enum.title
  * Params:	enum - The enum we want the title for
  * Returns:	The enum's title
-->
 <xsl:template name="get.enum.title">
  <xsl:param name="enum" />

  <xsl:value-of select="$enum/enumname"/>
 </xsl:template>

<!--
  * Function:	new.line
  * Returns:	A new line
-->
 <xsl:template name="new.line">
  <xsl:choose>
   <xsl:when test="$output.mode='html'">
    <br />
   </xsl:when>
   <xsl:otherwise>
	   <!-- TODO: Find newline code -->
    <xsl:text></xsl:text>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

</xsl:stylesheet>
