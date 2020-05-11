<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:param name="struc" />
  <xsl:template match="/">
    <X3D version="3.2">
      <Scene>
        <Background skyColor="1 1 1" />
        <Viewpoint position="0 0 4" />
        <xsl:copy-of select="document(replace($struc,'\\','/'))//X3D/Scene/Transform" />
        <TimeSensor DEF="таймер" cycleInterval="5" loop="true" />
        <xsl:for-each select="html/table/tr">
          <xsl:variable name="key" select="'0 0.25 0.5 0.75 1'" />
          <xsl:choose>
            <xsl:when test='td[3]="В"'>
              <xsl:variable name="НК">
                <xsl:choose>
                  <xsl:when test='td[4]="X"'>
                    <xsl:value-of select="'1 0 0'" /> </xsl:when>
                  <xsl:when test='td[4]="Y"'>
                    <xsl:value-of select="'0 1 0'" /> </xsl:when>
                  <xsl:when test='td[4]="Z"'>
                    <xsl:value-of select="'0 0 1'" /> </xsl:when>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="подстрока" select="concat($НК,' 0, ')" />
              <xsl:variable name="keyValue" select="concat($подстрока, $НК,' ',td[6]*0.017453,', ',$подстрока,$НК,' ',td[7]*0.017453,', ',$НК,' 0')" />
              <OrientationInterpolator>
                <xsl:attribute name="DEF">
                  <xsl:value-of select="concat('аниматор',position())" /></xsl:attribute>
                <xsl:attribute name="key">
                  <xsl:value-of select="$key" /></xsl:attribute>
                <xsl:attribute name="keyValue">
                  <xsl:value-of select="$keyValue" /></xsl:attribute>
              </OrientationInterpolator>
              <ROUTE fromField="value_changed" toField="set_rotation">
                <xsl:attribute name="fromNode">
                  <xsl:value-of select="concat('аниматор',position())" /></xsl:attribute>
                <xsl:attribute name="toNode">
                  <xsl:value-of select="concat('тело_',position())" /></xsl:attribute>
              </ROUTE>
            </xsl:when>
            <xsl:when test='td[3]="П"'>
              <xsl:variable name="x" select="tokenize(td[5],',\s*')[1]" />
              <xsl:variable name="y" select="tokenize(td[5],',\s*')[2]" />
              <xsl:variable name="z" select="tokenize(td[5],',\s*')[3]" />
              <PositionInterpolator>
                <xsl:attribute name="DEF">
                  <xsl:value-of select="concat('аниматор',position())" /></xsl:attribute>
                <xsl:attribute name="key">
                  <xsl:value-of select="$key" /></xsl:attribute>
                <xsl:variable name="keyValue">
                  <xsl:choose>
                    <xsl:when test='td[4]="X"'>
                      <xsl:value-of select="concat($x,' ',$y,' ',$z,', ',td[6],' ',$y,' ',$z,', ',$x,' ',$y,' ',$z,', ',td[7],' ',$y,' ',$z,', ',$x,' ',$y,' ',$z)" /> </xsl:when>
                    <xsl:when test='td[4]="Y"'>
                      <xsl:value-of select="concat($x,' ',$y,' ',$z,', ',$x,' ',td[6],' ',$z,', ',$x,' ',$y,' ',$z,', ',$x,' ',td[7],' ',$z,', ',$x,' ',$y,' ',$z)" /> </xsl:when>
                    <xsl:when test='td[4]="Z"'>
                      <xsl:value-of select="concat($x,' ',$y,' ',$z,', ',$x,' ',$y,' ',td[6],', ',$x,' ',$y,' ',$z,', ',$x,' ',$y,' ',td[7],', ',$x,' ',$y,' ',$z)" /> </xsl:when>
                  </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="keyValue">
                  <xsl:value-of select="$keyValue" /></xsl:attribute>
              </PositionInterpolator>
              <ROUTE fromField="value_changed" toField="set_translation">
                <xsl:attribute name="fromNode">
                  <xsl:value-of select="concat('аниматор',position())" /></xsl:attribute>
                <xsl:attribute name="toNode">
                  <xsl:value-of select="concat('тело_',position())" /></xsl:attribute>
              </ROUTE>
            </xsl:when>
          </xsl:choose>
          <ROUTE fromNode="таймер" fromField="fraction_changed" toField="set_fraction">
            <xsl:attribute name="toNode">
              <xsl:value-of select="concat('аниматор',position())" /></xsl:attribute>
          </ROUTE>
        </xsl:for-each>
      </Scene>
    </X3D>
  </xsl:template>
</xsl:stylesheet>