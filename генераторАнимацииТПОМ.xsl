<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="html" indent="yes" />
  <xsl:param name="path" />
  <xsl:param name="TP" />
  <xsl:variable name="ТПОМ" select="document($path)" />
  <!-- ТППД -->
  <xsl:variable name="время" select="number(document($TP)//tr[last()]/td[1])" /> 
  <xsl:variable name="колСтрокТПОМ" select="count($ТПОМ//tr)" />
  <!-- генерация узла Script -->
  <xsl:variable name="узелСкрипт">
    <xsl:for-each-group select="$ТПОМ//tr" group-by="td[3]">
      <xsl:for-each select="current-group()">
        <xsl:if test="td[3]=0 or (td[3]!=0 and position()=1)">
          <!-- выполнить для всех строк с базой 0, выполнить однажды для каждой группы -->
          <xsl:variable name="путь">
            <xsl:value-of select="concat(td[2],'_',td[3],'_',position())" /> </xsl:variable>
          <xsl:element name="Script">
            <xsl:attribute name="DEF">
              <xsl:value-of select="concat('скрипт',$путь)" /> </xsl:attribute>
            <field accessType='inputOnly' type='SFInt32'>
              <xsl:attribute name="name">
                <xsl:value-of select="concat('схват',$путь)" /></xsl:attribute>
            </field>
            <field accessType='outputOnly' type='SFString'>
              <xsl:attribute name="name">
                <xsl:value-of select="concat('видимость',$путь)" /></xsl:attribute>
            </field>
            <xsl:text>&lt;![CDATA[javascript: function </xsl:text>
            <xsl:value-of select="concat('схват',$путь)" />
            <xsl:text>(ОМ){ var объект = 'объект'+ОМ+'.x3d';</xsl:text>
            <xsl:value-of select="concat('видимость',$путь)" />
            <xsl:text>= объект.replace('объект0.x3d',''); } ]]&gt;</xsl:text>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:variable>
  <!-- генерация узлов целочисленных последовательностей с номерами ОМ -->
  <xsl:variable name="узлыПослед">
    <xsl:for-each-group select="$ТПОМ//tr" group-by="td[3]">
      <xsl:for-each select="current-group()">
        <xsl:if test="td[3]=0 or (td[3]!=0 and position()=1)">
          <!-- выполнить для всех строк с базой 0, выполнить однажды для каждой группы -->
          <!-- вызов шаблона вычисления атрибутов узла последовательностей -->
          <xsl:variable name="key">
            <xsl:call-template name="получитьКлюч" /> </xsl:variable>
          <xsl:variable name="значение">
            <xsl:call-template name="получитьЗначение">
              <xsl:with-param name="k1" select="number(td[1])" />
              <xsl:with-param name="k3" select="number(td[3])" />
              <xsl:with-param name="ид" select="number(td[2])" /> </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="keyValue">
            <xsl:call-template name="поменятьПорядок">
              <xsl:with-param name="строка" select="$значение" /> </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="путь">
            <xsl:value-of select="concat(td[2],'_',td[3],'_',position())" /> </xsl:variable>
          <IntegerSequencer>
            <xsl:attribute name="DEF">
              <xsl:value-of select="concat('объекты',$путь)" /></xsl:attribute>
            <xsl:attribute name="key">
              <xsl:value-of select="$key" /></xsl:attribute>
            <xsl:attribute name="keyValue">
              <xsl:value-of select="$keyValue" /></xsl:attribute>
          </IntegerSequencer>
          <ROUTE fromNode="таймер" fromField="fraction_changed" toField="set_fraction">
            <xsl:attribute name="toNode">
              <xsl:value-of select="concat('объекты',$путь)" /></xsl:attribute>
          </ROUTE>
          <ROUTE fromField="value_changed">
            <xsl:attribute name="toNode">
              <xsl:value-of select="concat('скрипт',$путь)" /></xsl:attribute>
            <xsl:attribute name="fromNode">
              <xsl:value-of select="concat('объекты',$путь)" /></xsl:attribute>
            <xsl:attribute name="toField">
              <xsl:value-of select="concat('схват',$путь)" /></xsl:attribute>
          </ROUTE>
          <ROUTE toField="url">
            <xsl:attribute name="fromNode">
              <xsl:value-of select="concat('скрипт',$путь)" /></xsl:attribute>
            <xsl:attribute name="fromField">
              <xsl:value-of select="concat('видимость',$путь)" /></xsl:attribute>
            <xsl:attribute name="toNode">
              <xsl:value-of select="concat('схват_',$путь)" /></xsl:attribute>
          </ROUTE>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:variable>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" /> </xsl:copy>
  </xsl:template>
  <xsl:template match="Scene">
    <xsl:copy>
      <xsl:apply-templates select="@* | *" />
      <xsl:copy-of select="$узелСкрипт" />
      <xsl:copy-of select="$узлыПослед" /> </xsl:copy>
  </xsl:template>
  <xsl:template match="Transform">
    <xsl:variable name="DEF" select="@DEF" />
    <xsl:copy>
      <xsl:apply-templates select="@* | *" />
      <xsl:for-each-group select="$ТПОМ//tr" group-by="td[3]">
        <xsl:for-each select="current-group()">
          <xsl:if test="$DEF=concat('тело_',td[3]) and (td[3]=0 or (td[3]!=0 and position()=1))">
            <Transform>
              <xsl:attribute name="translation">
                <xsl:value-of select="td[4]" /></xsl:attribute>
              <xsl:variable name="угол" select="number(substring-after(td[5],','))*0.017453" />
              <xsl:variable name="ось" select="substring-before(td[5],',')" />
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
              <Inline>
                <xsl:attribute name="DEF">
                  <xsl:value-of select="concat('схват','_',td[2],'_',td[3],'_',position())" /></xsl:attribute>
                <xsl:attribute name="url">
                  <xsl:value-of select="''" /></xsl:attribute>
              </Inline>
            </Transform>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="получитьКлюч">
    <xsl:param name="номерСтроки" select="$колСтрокТПОМ" />
    <xsl:if test="1 &lt;=  $номерСтроки">
      <xsl:variable name="ключ">
        <xsl:value-of select="format-number(number($ТПОМ//tr[$номерСтроки]/td[1]) div $время,'#.0000')" /> </xsl:variable>
      <xsl:call-template name="получитьКлюч">
        <xsl:with-param name="номерСтроки" select="$номерСтроки - 1" /> </xsl:call-template>
      <xsl:value-of select="concat($ключ,', ')" /> </xsl:if>
  </xsl:template>
  <xsl:template name="получитьЗначение">
    <xsl:param name="k1" />
    <!-- время для идентификации строки -->
    <xsl:param name="k3" />
    <!-- База -->
    <xsl:param name="ид" />
    <!-- ОМ для идентификации строки -->
    <xsl:param name="k2" select="0" />
    <!-- НОМ -->
    <xsl:param name="номерСтроки" select="1" />
    <xsl:if test="$колСтрокТПОМ &gt;=  $номерСтроки">
      <xsl:variable name="td1" select="$ТПОМ//tr[$номерСтроки]/td[1]" />
      <xsl:variable name="td2" select="$ТПОМ//tr[$номерСтроки]/td[2]" />
      <xsl:variable name="td3" select="$ТПОМ//tr[$номерСтроки]/td[3]" />
      <xsl:variable name="значение">
        <xsl:choose>
          <!-- если есть функция определения положения (индекса) элемента в коллекции, то здесь использовать ее вместо ид index-of??-->
          <xsl:when test='($k3!=0 and $td3=$k3 and $td2!=$k2) or ($k3=0 and $td1=$k1 and $td2=$ид)'>
            <xsl:value-of select="$td2" /> </xsl:when>
          <xsl:when test='($k3!=0 and $td3!=$k3 and $td2=$k2) or ($k3=0 and $td1 &lt; $k1) '>
            <xsl:value-of select="0" /> </xsl:when>
          <xsl:when test='$k3!=0 or ($k3=0 and $td2!=$k2)'>
            <xsl:value-of select="$k2" /> </xsl:when>
          <xsl:when test='$k3=0 and $td2=$k2'>
            <xsl:value-of select="0" /> </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="получитьЗначение">
        <xsl:with-param name="k1" select="$k1" />
        <xsl:with-param name="k3" select="$k3" />
        <xsl:with-param name="ид" select="$ид" />
        <xsl:with-param name="k2" select="$значение" />
        <!-- поменять значение k2 -->
        <xsl:with-param name="номерСтроки" select="$номерСтроки + 1" /> </xsl:call-template>
      <xsl:value-of select="concat($значение,', ')" /> </xsl:if>
  </xsl:template>
  <xsl:template name="поменятьПорядок">
    <xsl:param name="строка" />
    <xsl:if test="contains($строка, ', ')">
      <xsl:variable name="подстрока" select="substring-before($строка, ', ')" />
      <xsl:call-template name="поменятьПорядок">
        <xsl:with-param name="строка" select="substring-after($строка, ', ')" /> </xsl:call-template>
      <xsl:value-of select="concat($подстрока,', ')" /> </xsl:if>
  </xsl:template>
</xsl:stylesheet>