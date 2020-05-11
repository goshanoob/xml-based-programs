<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="no" />
  <xsl:param name="path" />
  <xsl:variable name="k" select="count(//html/table/tr)" />
  <xsl:template match="/">
    <html><table>
      <xsl:call-template name="получитьТПРТК" />
    </table></html>
  </xsl:template>
  <xsl:template name="получитьТПРТК">
    <xsl:param name="номерТаблицы" select="1" />
    <xsl:param name="количествоСтрок" select="0" />
    <xsl:param name="НМС" select="0" />
    <xsl:param name="ННТ" select="0" />
    <xsl:param name="РМС" select="1" />
    <xsl:param name="списокКолТел" />
    <xsl:param name="КПТ" select="//html/table/tr[1]/td[4]" />
    <xsl:if test="$номерТаблицы &lt;=  $k">
      <xsl:variable name="строки" select="document(concat($path,'/ТПСТ_',$РМС,'.html'))//table/tr" />
      <xsl:variable name="колСтрок" select="count($строки)" />
      <xsl:for-each select="$строки">
        <tr>
          <td>
            <xsl:value-of select="$количествоСтрок+number(td[1])" />
          </td>
          <td>
            <xsl:choose>
              <xsl:when test='td[2]="0"'>
                <xsl:choose>
                  <xsl:when test="$НМС != 0">
                    <xsl:variable name="y">
                      <xsl:call-template name="найтиСумму">
                        <xsl:with-param name="список" select="$списокКолТел" />
                        <xsl:with-param name="s" select="$НМС" /> </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$y+$ННТ" /> </xsl:when>
                  <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="number(td[2])+$количествоСтрок" /> </xsl:otherwise>
            </xsl:choose>
          </td>
          <xsl:copy-of select="subsequence(td,3,2)" />
          <xsl:choose>
            <xsl:when test='td[2]="0"'>
              <td>
                <xsl:variable name="x" select="number(tokenize(td[5],',\s*')[1])+number(tokenize($КПТ,',\s*')[1])" />
                <xsl:variable name="y" select="number(tokenize(td[5],',\s*')[2])+number(tokenize($КПТ,',\s*')[2])" />
                <xsl:variable name="z" select="number(tokenize(td[5],',\s*')[3])+number(tokenize($КПТ,',\s*')[3])" />
				<xsl:value-of select="concat($x,',',$y,',',$z)" />
              </td>
              <xsl:copy-of select="subsequence(td,6)" /> </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="subsequence(td,5)" /></xsl:otherwise>
          </xsl:choose>
        </tr>
      </xsl:for-each>
      <xsl:call-template name="получитьТПРТК">
        <xsl:with-param name="номерТаблицы" select="$номерТаблицы+1" />
        <xsl:with-param name="количествоСтрок" select="$количествоСтрок+$колСтрок" />
        <xsl:with-param name="НМС" select="//html/table/tr[$номерТаблицы+1]/td[1]" />
        <xsl:with-param name="ННТ" select="//html/table/tr[$номерТаблицы+1]/td[2]" />
        <xsl:with-param name="РМС" select="//html/table/tr[$номерТаблицы+1]/td[3]" />
        <xsl:with-param name="списокКолТел" select="concat($списокКолТел,' ',$колСтрок)" />
        <xsl:with-param name="КПТ" select="//html/table/tr[$номерТаблицы+1]/td[4]" /> </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template name="найтиСумму">
    <xsl:param name="список" />
    <xsl:param name="i" select="1" />
    <xsl:param name="s" />
    <xsl:variable name="Нсписок" select="concat(normalize-space($список),' ')" />
    <xsl:choose>
      <xsl:when test="$i &lt; $s">
        <xsl:variable name="голова" select="substring-before($Нсписок,' ')" />
        <xsl:variable name="хвост" select="substring-after($Нсписок,' ')" />
        <xsl:variable name="сумма">
          <xsl:call-template name="найтиСумму">
            <xsl:with-param name="список" select="$хвост" />
            <xsl:with-param name="i" select="$i+1" />
            <xsl:with-param name="s" select="$s" /> </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="number($голова)+number($сумма)" /> </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>