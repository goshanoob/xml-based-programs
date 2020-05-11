<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="no" />
  <xsl:param name="param" />

  <!-- на входе ТППА -->
  <xsl:variable name="колСТ" select="max(//tr/td[1])" />
  
  
  <xsl:template match="/">
    <html><table>
      <xsl:call-template name="получитьТМОМРТК" />
    </table></html>
  </xsl:template>
  
  
  
   <xsl:template name="получитьТМОМРТК">
    <xsl:param name="номерСТ" select="1" />
    <xsl:param name="суммаКолОМ" select="0" />
    
    <xsl:if test="$колСТ &gt;= $номерСТ">
      <xsl:variable name="ТМОМ" select="document(concat($param,'/ТМОМ_',$номерСТ,'.html'))" />
	  <xsl:for-each select="$ТМОМ//tr">
	   <tr><td>
	    <xsl:value-of select="number(td[1])+$суммаКолОМ" />
	   </td>
	   <xsl:copy-of select="subsequence(td,2)" /> 
	   </tr><xsl:text>&#xA;</xsl:text>
	  </xsl:for-each>
  
	  
      <xsl:call-template name="получитьТМОМРТК">
        <xsl:with-param name="номерСТ" select="$номерСТ+1" />
        <xsl:with-param name="суммаКолОМ" select="$суммаКолОМ+max($ТМОМ//tr/td[1])" /> </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  
</xsl:stylesheet>