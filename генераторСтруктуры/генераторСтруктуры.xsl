<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="table">
    <X3D version="3.2">
      <Scene>
        <Background skyColor="1 1 1" />
        <Viewpoint position="0 0 4" />
        <Transform DEF="тело_0">
          <Inline url="тело_0.x3d" />
          <xsl:apply-templates select="tr[td[2] eq '0']" /> </Transform>
      </Scene>
    </X3D>
  </xsl:template>
  <xsl:template match="tr">
    <xsl:variable name="td" select="string(index-of(//html/table/tr, .[position()]))" />
    <Transform>
      <xsl:attribute name="DEF">
        <xsl:value-of select="concat('тело_', $td)" /></xsl:attribute>
      <xsl:attribute name="translation">
        <xsl:value-of select="td[5]" /></xsl:attribute>
      <Inline>
        <xsl:attribute name="url">
          <xsl:value-of select="concat('тело_', $td, '.x3d')" /></xsl:attribute>
      </Inline>
      <xsl:apply-templates select="../tr[td[2] eq $td]" /> </Transform>
  </xsl:template>
</xsl:stylesheet>