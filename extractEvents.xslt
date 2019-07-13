<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/schedule">
    <events>
      <xsl:apply-templates select="//event"/>
    </events>
  </xsl:template>

  <xsl:template match="event">
    <!-- <event> -->
    <!--   <xsl:value-of select="title" /> -->
    <!-- </event> -->
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>

<!--  xalan -in schedule.xml -xsl trafo.xslt -out events.xml  -->
