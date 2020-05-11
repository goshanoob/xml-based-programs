<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:param name="path" />
  <xsl:param name="TP" />
  <xsl:variable name="анимация" select="document(concat($path,'/анимация0.x3d'))" />
  <xsl:variable name="ТП" select="document($TP)" />
  <xsl:variable name="ТППД" select="." />
  <xsl:variable name="колПереходов" select="count(//html/table/tr)" />
  <xsl:variable name="время" select="number($ТППД//html/table/tr[last()]/td[1])" />
  <xsl:template match="/">
    <X3D>
      <Scene>
        <Background skyColor="1 1 1" />
        <Viewpoint position="0 0 4" />
        <xsl:copy-of select="$анимация//X3D/Scene/Transform" />
        <TimeSensor DEF="таймер" loop="true">
          <xsl:attribute name="cycleInterval">
            <xsl:value-of select="$время" /></xsl:attribute>
        </TimeSensor>
        <xsl:variable name="key">
          <xsl:call-template name="получить_key" /> </xsl:variable>
        <xsl:for-each select="$ТП//html/table/tr">
          <xsl:variable name="keyValue">
            <xsl:call-template name="получить_keyValue">
              <xsl:with-param name="номерТела" select="position()" /> </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="поз" select="position()" />
          <xsl:element name="{name($анимация//X3D/Scene/(PositionInterpolator|OrientationInterpolator)[$поз])}">
            <xsl:attribute name="DEF">
              <xsl:value-of select="concat('аниматор',$поз)" /></xsl:attribute>
            <xsl:attribute name="key">
              <xsl:value-of select="$key" /></xsl:attribute>
            <xsl:attribute name="keyValue">
              <xsl:value-of select="$keyValue" /></xsl:attribute>
          </xsl:element>
        </xsl:for-each>
        <xsl:copy-of select="$анимация//X3D/Scene/ROUTE" /> </Scene>
    </X3D>
  </xsl:template>
  <xsl:template name="получить_keyValue">
    <xsl:param name="номерСтрокиТППД" select="$колПереходов" />
    <xsl:param name="номерТела" />
    <xsl:if test="1 &lt;=  $номерСтрокиТППД">
      <xsl:variable name="тело" select="$ТП//html/table/tr[$номерТела]" />
      <xsl:variable name="ОК">
        <xsl:variable name="q" select="$ТППД//html/table/tr[$номерСтрокиТППД]/td[$номерТела+1]" />
        <xsl:choose>
          <xsl:when test='$тело/td[3]="В"'>
            <xsl:variable name="НК">
              <xsl:choose>
                <xsl:when test='$тело/td[4]="X"'>
                  <xsl:value-of select="'1 0 0'" /> </xsl:when>
                <xsl:when test='$тело/td[4]="Y"'>
                  <xsl:value-of select="'0 1 0'" /> </xsl:when>
                <xsl:when test='$тело/td[4]="Z"'>
                  <xsl:value-of select="'0 0 1'" /> </xsl:when>
              </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="concat($НК,' ',string(number($q)*0.017453))" /> </xsl:when>
          <xsl:when test='$тело/td[3]="П"'>
            <xsl:variable name="x" select="tokenize($тело/td[5],',\s*')[1]" />
            <xsl:variable name="y" select="tokenize($тело/td[5],',\s*')[2]" />
            <xsl:variable name="z" select="tokenize($тело/td[5],',\s*')[3]" />
            <xsl:choose>
              <xsl:when test='$тело/td[4]="X"'>
                <xsl:value-of select="concat($q,' ',$y,' ',$z)" /> </xsl:when>
              <xsl:when test='$тело/td[4]="Y"'>
                <xsl:value-of select="concat($x,' ',$q,' ',$z)" /> </xsl:when>
              <xsl:when test='$тело/td[4]="Z"'>
                <xsl:value-of select="concat($x,' ',$y,' ',$q)" /> </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="получить_keyValue">
        <xsl:with-param name="номерСтрокиТППД" select="$номерСтрокиТППД - 1" />
        <xsl:with-param name="номерТела" select="$номерТела" /> </xsl:call-template>
      <xsl:value-of select="concat(', ',replace($ОК,'--',''))" /> </xsl:if>
  </xsl:template>
  <xsl:template name="получить_key">
    <xsl:param name="номерСтрокиТППД" select="$колПереходов" />
    <xsl:if test="1 &lt;=  $номерСтрокиТППД">
      <xsl:variable name="доля" select="format-number(number($ТППД//html/table/tr[$номерСтрокиТППД]/td[1]) div $время,'#.0000')" />
      <xsl:call-template name="получить_key">
        <xsl:with-param name="номерСтрокиТППД" select="$номерСтрокиТППД - 1" /> </xsl:call-template>
      <xsl:value-of select="concat(', ',$доля)" /> </xsl:if>
  </xsl:template>
</xsl:stylesheet>