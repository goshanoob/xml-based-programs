<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="no" />
  <xsl:param name="path" />
  <xsl:variable name="ТПРМС" select="." />
  <xsl:variable name="k" select="count(//html/table/tr)" />
  <xsl:template match="/">
    <html><table>
      <xsl:call-template name="получитьТПТРТК" />
    </table></html>
  </xsl:template>
  <xsl:template name="получитьТПТРТК">
    <xsl:param name="номерТаблицы" select="1" />
    <xsl:param name="РМС" select="1" />
    <xsl:param name="количествоСтрок" select="0" />
    <xsl:if test="$номерТаблицы &lt;=  $k">
      <xsl:variable name="строки" select="document(concat($path,'/ТПМТ_',$РМС,'.html'))//table/tr" />
      <xsl:variable name="колТелСТ" select="count(document(concat($path,'/ТПСТ_',$РМС,'.html'))//table/tr)" />
      <xsl:for-each select="$строки">
        <tr>
          <xsl:choose>
            <xsl:when test="td[1]!='0'">
              <td>
                <xsl:value-of select="number(td[1])+$количествоСтрок" /> </td>
              <xsl:copy-of select="subsequence(td,2)" /> </xsl:when>
            <xsl:otherwise>
              <td>
                <xsl:value-of select="0" />
              </td>
              <xsl:copy-of select="subsequence(td,2,1)" />
              <xsl:variable name="координаты" select="$ТПРМС//tr[$номерТаблицы]/td[4]" />
              <xsl:variable name="x" select="number(tokenize(td[3],',\s*')[1])+number(tokenize($координаты,',\s*')[1])" />
              <xsl:variable name="y" select="number(tokenize(td[3],',\s*')[2])+number(tokenize($координаты,',\s*')[2])" />
              <xsl:variable name="z" select="number(tokenize(td[3],',\s*')[3])+number(tokenize($координаты,',\s*')[3])" />
              <td>
                <xsl:value-of select="concat($x,',',$y,',',$z)" />
              </td>
              <xsl:copy-of select="subsequence(td,4)" /> </xsl:otherwise>
          </xsl:choose>
        </tr>
      </xsl:for-each>
      <xsl:call-template name="получитьТПТРТК">
        <xsl:with-param name="номерТаблицы" select="$номерТаблицы+1" />
        <xsl:with-param name="РМС" select="//html/table/tr[$номерТаблицы+1]/td[3]" />
		<!-- лучше передать количество тел СТ или хотя бы max(td[1]) -->
        <xsl:with-param name="количествоСтрок" select="$количествоСтрок+$колТелСТ" /> 
	  </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>