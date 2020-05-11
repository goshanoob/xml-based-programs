<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="no" />
  <xsl:param name="path" />
  

  <!-- на входе ТППА -->
  <xsl:variable name="k" select="count(//tr)" />
  <xsl:variable name="ТППА" select="." />
  <xsl:variable name="колСТ" select="max($ТППА//tr/td[1])" />
  <xsl:variable name="суммаКолТел">
	<xsl:call-template name="получитьСписокКоличестваТел"/>
   </xsl:variable>
  <xsl:variable name="суммаКолОМ">
    <xsl:call-template name="получитьСписокКоличестваОМ"/>
  </xsl:variable>
  
  <xsl:template match="/">
   <html><table> <xsl:text>&#xA;</xsl:text>
   <xsl:call-template name="получитьТПОМРТК" />
   <xsl:text>&#xA;</xsl:text></table></html>
  </xsl:template>
  
  <xsl:template name="получитьТПОМРТК">
    <xsl:param name="номерТППД" select="1" />
    <xsl:param name="общееВремя" select="0" />
	<xsl:param name="количествоСтрок" select="0" />
    <xsl:if test="$номерТППД &lt;=  $k">
      <xsl:variable name="НМС" select="//tr[$номерТППД]/td[1]" />
      <xsl:variable name="НПД" select="//tr[$номерТППД]/td[2]" />
      <xsl:variable name="задержка" select="//tr[$номерТППД]/td[3]" />
      <xsl:variable name="строкиТПОМ" select="document(concat($path,'/ТПОМ_',$НМС,'_',$НПД,'.html'))//tr" />
      <xsl:variable name="ТППД" select="document(concat($path,'/ТППД_',$НМС,'_',$НПД,'.html'))" />
	  <xsl:for-each select="$строкиТПОМ"> <xsl:variable name="время" select="td[1]" />
        <tr>
          <td>
            <xsl:value-of select="number($время)+$общееВремя+$задержка" />
          </td>
		  <td>
		    <xsl:value-of select="number(td[2])+number(tokenize($суммаКолОМ,' ')[number($НМС)])" />
          </td>
		  <td>
            <xsl:choose>
              <xsl:when test='td[3]="0"'>
                <xsl:text>0</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="number(td[3])+number(tokenize($суммаКолТел,' ')[number($НМС)])" /> </xsl:otherwise>
            </xsl:choose>
          </td>
		  <xsl:copy-of select="subsequence(td,4)" /> 
		  <td><xsl:value-of select="$ТППД//tr[td[1] eq $время]/td[last()]" /></td>
        </tr><xsl:text>&#xA;</xsl:text>
      </xsl:for-each>
      <xsl:call-template name="получитьТПОМРТК">
        <xsl:with-param name="номерТППД" select="$номерТППД+1" />
        <xsl:with-param name="общееВремя" select="$общееВремя+number($ТППД//tr[last()]/td[1])+$задержка" />
	  </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="получитьСписокКоличестваТел">
    <xsl:param name="номерСТ" select="1" />
    <xsl:param name="суммаКолТел" select="0" />

    <xsl:if test="$колСТ &gt;= $номерСТ">
      <xsl:variable name="колСтрок" select="count(document(concat($path,'/ТПСТ_',$номерСТ,'.html'))//tr)" />
      <xsl:value-of select="concat($суммаКолТел,' ')" />
      <xsl:call-template name="получитьСписокКоличестваТел">
        <xsl:with-param name="номерСТ" select="$номерСТ+1" />
        <xsl:with-param name="суммаКолТел" select="$суммаКолТел+$колСтрок" /> </xsl:call-template>
		 </xsl:if>
  </xsl:template>
  
  
  <xsl:template name="получитьСписокКоличестваОМ">
    <xsl:param name="номерСТ" select="1" />
    <xsl:param name="суммаКолОМ" select="0" />
    
    <xsl:if test="$колСТ &gt;= $номерСТ">
      <xsl:variable name="колОМ" select="max(document(concat($path,'/ТМОМ_',$номерСТ,'.html'))//tr/td[1])" />
      <xsl:value-of select="concat($суммаКолОМ,' ')" />
      <xsl:call-template name="получитьСписокКоличестваОМ">
        <xsl:with-param name="номерСТ" select="$номерСТ+1" />
        <xsl:with-param name="суммаКолОМ" select="$суммаКолОМ+$колОМ" /> </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>