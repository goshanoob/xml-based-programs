<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="no" />
  <xsl:param name="path" />
  <xsl:variable name="k" select="count(//html/table/tr)" />
  <xsl:variable name="ТППА" select="." />
  <xsl:template match="/">
    <html><table><xsl:text>&#xA;</xsl:text>
      <xsl:call-template name="получитьТПДРТК" />
    </table></html>
  </xsl:template>
  <xsl:template name="получитьТПДРТК">
    <xsl:param name="номерТППД" select="1" />
    <xsl:param name="общееВремя" select="0" />
    <xsl:param name="счётчикСтрок" select="1" />
    <xsl:if test="$номерТППД &lt;=  $k">
      <xsl:variable name="НМС" select="//tr[$номерТППД]/td[1]" />
      <xsl:variable name="НПД" select="//tr[$номерТППД]/td[2]" />
      <xsl:variable name="задержка" select="//tr[$номерТППД]/td[3]" />
      <xsl:variable name="строки" select="document(concat($path,'/ТППД_',$НМС,'_',$НПД,'.html'))//table/tr" />
      <xsl:variable name="колСтрок" select="count($строки)" />
      <xsl:for-each select="$строки">
        <xsl:variable name="i" select="position()" />
        <tr>
          <td>
            <xsl:value-of select="number(td[1])+$общееВремя+$задержка" />
          </td>
          <xsl:for-each-group select="$ТППА//html/table/tr" group-by="td[1]">
            <xsl:variable name="НМС2" select="td[1]" />
            <xsl:variable name="НПД2">
              <xsl:choose>
                <xsl:when test="($счётчикСтрок &lt; td[4]) or count(current-group())=1">
                  <xsl:value-of select="td[2]" /></xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="subsequence(current-group(),1,count(current-group())-1)">
                    <xsl:variable name="pos" select="position()" />
                    <xsl:choose>
                      <xsl:when test="(($счётчикСтрок &gt; td[4]) and ($счётчикСтрок &lt; current-group()[number($pos)+1]/td[4])) or ($счётчикСтрок = td[4]) ">
                        <xsl:value-of select="td[2]" /> </xsl:when>
                      <xsl:when test="($счётчикСтрок &gt;= current-group()[number($pos)+1]/td[4]) and ($pos=count(current-group())-1)">
                        <xsl:value-of select="current-group()[number($pos)+1]/td[2]" /> </xsl:when>
                    </xsl:choose>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="строки2" select="document(concat($path,'/ТППД_',$НМС2,'_',$НПД2,'.html'))//table/tr" />
            <xsl:choose>
              <xsl:when test='$НМС = $НМС2'>
                <xsl:copy-of select="subsequence($строки2[$i]/td,2,count($строки2[1]/td)-2)" /> </xsl:when>
              <xsl:when test='$счётчикСтрок &lt; td[4]'>
                <xsl:copy-of select="subsequence($строки2[1]/td,2,count($строки2[1]/td)-2)" /> </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="subsequence($строки2[last()]/td,2,count($строки2[1]/td)-2)" /> </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each-group>
        </tr><xsl:text>&#xA;</xsl:text>
      </xsl:for-each>
      <xsl:call-template name="получитьТПДРТК">
        <xsl:with-param name="номерТППД" select="$номерТППД+1" />
        <xsl:with-param name="общееВремя" select="$общееВремя+number($строки[last()]/td[1])+$задержка" />
        <xsl:with-param name="счётчикСтрок" select="$счётчикСтрок+$колСтрок" /> </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>