<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="no" />
  <xsl:param name="path" />
  <xsl:variable name="k" select="count(//html/table/tr)" />
  <xsl:template match="/">
    <html><table>
      <xsl:call-template name="копировать" />
    </table></html>
  </xsl:template>
  <xsl:template name="копировать">
    <xsl:param name="номерТППД" select="1" />
    <xsl:param name="суммаСтрок" select="1" />
    <xsl:if test="$номерТППД &lt;=  $k">
      <xsl:variable name="НМС" select="//tr[$номерТППД]/td[1]" />
      <xsl:variable name="НПД" select="//tr[$номерТППД]/td[2]" />
      <xsl:variable name="колСтрок" select="count(document(concat($path,'/ТППД_',$НМС,'_',$НПД,'.html'))//table/tr)" />
      <tr>
        <xsl:copy-of select="subsequence(//tr[$номерТППД]/td,1,3)" />
        <td><xsl:value-of select="$суммаСтрок" /></td>
      </tr>
      <xsl:call-template name="копировать">
        <xsl:with-param name="номерТППД" select="$номерТППД+1" />
        <xsl:with-param name="суммаСтрок" select="$суммаСтрок+$колСтрок" /> </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>