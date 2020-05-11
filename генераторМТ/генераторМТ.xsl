<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="fileName" />
  <xsl:template match="/">
    <xsl:for-each-group select="//table/tr" group-by="td[1]">
      <xsl:result-document href="{concat($fileName, current-grouping-key(), '.x3d')}">
        <X3D version="3.2">
          <Scene>
            <Background skyColor="1 1 1" />
            <Viewpoint position="0 0 4" />
            <xsl:for-each select="current-group()">
              <xsl:variable name="угол" select="number(substring-after(td[4],','))*0.017453" />
              <xsl:variable name="ось" select="substring-before(td[4],',')" />
              <Transform>
                <xsl:attribute name="translation">
                  <xsl:value-of select="td[3]" /></xsl:attribute>
                <xsl:attribute name="rotation">
                  <xsl:choose>
                    <xsl:when test='$ось="X"'>
                      <xsl:value-of select="concat('1 0 0 ',$угол)" /> </xsl:when>
                    <xsl:when test='$ось="Y"'>
                      <xsl:value-of select="concat('0 1 0 ',$угол)" /> </xsl:when>
                    <xsl:when test='$ось="Z"'>
                      <xsl:value-of select="concat('0 0 1 ',$угол)" /> </xsl:when>
                  </xsl:choose>
                </xsl:attribute>
                <Shape>
                  <xsl:variable name="КГО" select="td[2]" />
                  <xsl:choose>
                    <xsl:when test='$КГО="Б"'>
                      <Box>
                        <xsl:attribute name="size">
                          <xsl:value-of select="td[6]" /></xsl:attribute>
                      </Box>
                    </xsl:when>
                    <xsl:when test='$КГО="Ц"'>
                      <Cylinder>
                        <xsl:attribute name="radius">
                          <xsl:value-of select="substring-before(td[6],',')" /></xsl:attribute>
                        <xsl:attribute name="height">
                          <xsl:value-of select="substring-after(td[6],',')" /></xsl:attribute>
                      </Cylinder>
                    </xsl:when>
                    <xsl:when test='$КГО="К"'>
                      <Cone>
                        <xsl:attribute name="bottomRadius">
                          <xsl:value-of select="substring-before(td[6],',')" /></xsl:attribute>
                        <xsl:attribute name="height">
                          <xsl:value-of select="substring-after(td[6],',')" /></xsl:attribute>
                      </Cone>
                    </xsl:when>
                    <xsl:when test='$КГО="С"'>
                      <Sphere>
                        <xsl:attribute name="radius">
                          <xsl:value-of select="td[6]" /></xsl:attribute>
                      </Sphere>
                    </xsl:when>
                  </xsl:choose>
                  <Appearance>
                    <Material>
                      <xsl:attribute name="diffuseColor">
                        <xsl:value-of select="td[5]" /></xsl:attribute>
                    </Material>
                  </Appearance>
                </Shape>
              </Transform>
            </xsl:for-each>
          </Scene>
        </X3D>
      </xsl:result-document>
    </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>