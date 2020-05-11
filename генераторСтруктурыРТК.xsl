<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">
  <xsl:mode on-no-match="shallow-copy"/>
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="ТПРСТ" select="document('ТПРСТ.html')"/>
  <xsl:variable name="колСТ" select="count($ТПРСТ//tr)" />
  <xsl:variable name="количествоТел">
    <xsl:call-template name="получитьСписокКоличестваТел">
    </xsl:call-template>
  </xsl:variable>

  <xsl:template match="Transform[@DEF = tokenize(concat('тело_1 тело_',replace(substring-after(substring-after($количествоТел,' '),' '),' ',' тело_')),' ')]">
    <xsl:variable name="поз" select="position()"/>
    <xsl:variable name="разворот" select="tokenize($ТПРСТ//tr[$поз]/td[5],',\s*')"/>
    <xsl:variable name="угол" select="number($разворот[4])*0.017453"/>
    <Transform>
      <xsl:attribute name="rotation"><xsl:value-of select="concat($разворот[1],' ',$разворот[2],' ',$разворот[3],' ',$угол)"/></xsl:attribute>
      <xsl:next-match/>
    </Transform>
  </xsl:template>
  
    <xsl:template name="получитьСписокКоличестваТел">
    <xsl:param name="номерСТ" select="1" />
    <xsl:param name="суммаКолТел" select="0" />
    <xsl:value-of select="concat($суммаКолТел+1,' ')" />
    <xsl:if test="$колСТ &gt;= $номерСТ">
      <xsl:variable name="колСтрок" select="count(document(concat('ТПСТ_',$номерСТ,'.html'))//tr)" />
     
      <xsl:call-template name="получитьСписокКоличестваТел">
        <xsl:with-param name="номерСТ" select="$номерСТ+1" />
        <xsl:with-param name="суммаКолТел" select="$суммаКолТел+$колСтрок" /> </xsl:call-template>
    </xsl:if> 
  </xsl:template>

</xsl:stylesheet>