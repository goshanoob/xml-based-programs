<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="html" indent="yes" />
  <xsl:variable name="путь" select="'file:///I:/Платформа/nwjs-v0.12.3-win-ia32/СистемаТел (СТ и РТК)2/РТУ механической обработки/'" />
  <xsl:variable name="ТПРТК" select="document('ТПРТК.html')" />
  <xsl:variable name="структураРТК" select="document(concat($путь,'структураРТК.x3d'))" />
  <xsl:variable name="колСТ" select="count(document('ТПРСТ.html')//tr)" />
 
  <xsl:variable name="количествоТел">
    <xsl:call-template name="получитьСписокКоличестваТел">
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:template match="/">  
    
    <X3D version="3.2">
      <Scene>
        <Background skyColor="1 1 1" />
        <Viewpoint position="0 0 4" />
        <xsl:copy-of select="document('структураРТК.x3d')//X3D/Scene/Transform" />
        
       <!-- функция запуска -->
        <xsl:variable name="запуск"> <xsl:text> function initialize(){  старт=true; } </xsl:text></xsl:variable>
        
        
        <xsl:for-each-group select="//call" group-by="@process">
          <xsl:variable name="номерСТ" select="tokenize(current-grouping-key(),'_')[2]" />
          <xsl:variable name="ТППД" select="document(concat('ТП',current-grouping-key(),'.html'))" />
          <xsl:variable name="СТ" select="document(concat('ТПСТ_',tokenize(current-grouping-key(),'_')[2],'.html'))" />
          <xsl:variable name="номерТаймера5">
            <xsl:number level="any" count="call"/>
          </xsl:variable>  
          <xsl:for-each select="$СТ//tr">
           
            <xsl:variable name="поз" select="position()" /> <!-- номер тела для текущей СТ -->
            <xsl:variable name="номТела" select="$поз+number(tokenize($количествоТел,' ')[number($номерСТ)])"/> <!-- накопленное количество тел для РТК  -->
              
            <!-- переменную начальное q  заменить генерацией дополнительного трансформатора для подсистемы ??? 
            <xsl:variable name="начальное_q">
              <xsl:choose>
                <xsl:when test="td[2] = '0'">
				  <xsl:choose>
				    <xsl:when test='td[3]="П"'>
                      <xsl:choose>
                        <xsl:when test='$тело/td[4]="X"'>
                          <xsl:value-of select="concat($q,' ',$y,' ',$z)" /> </xsl:when>
                        <xsl:when test='$тело/td[4]="Y"'>
                          <xsl:value-of select="concat($x,' ',$q,' ',$z)" /> </xsl:when>
                        <xsl:when test='$тело/td[4]="Z"'>
                          <xsl:value-of select="concat($x,' ',$y,' ',$q)" /> </xsl:when>
                      </xsl:choose>
                    </xsl:when>
					<xsl:when test='td[3]="В"'>
					  <xsl:value-of select="tokenize(document('ТПРСТ.html')//tr[number($номерСТ)]/td[5],',\s*')[4]"/>
					</xsl:when>
				  </xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="0"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>-->
			
			<xsl:variable name="начальное_q">
              <xsl:choose>
                <xsl:when test="$поз = 1"><xsl:value-of select="tokenize(document('ТПРСТ.html')//tr[number($номерСТ)]/td[5],',\s*')[4]"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="0"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="keyValue">
              <xsl:call-template name="получить_keyValue">
                <xsl:with-param name="номерТела" select="$поз" /> 
                <xsl:with-param name="номерСтрокиТППД" select="count($ТППД//tr)" />
                <xsl:with-param name="СТ" select="$СТ" />
                <xsl:with-param name="ТППД" select="$ТППД" />
                <xsl:with-param name="начальное_q" select="$начальное_q" />
                <xsl:with-param name="номерСТ" select="$номерСТ" />
              </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="key">
              <xsl:call-template name="получить_key" >
                <xsl:with-param name="номерСтрокиТППД" select="count($ТППД//tr)" />
                <xsl:with-param name="ТППД" select="$ТППД" />
              </xsl:call-template> 
            </xsl:variable>
            
            
            <xsl:variable name="идентификатор">
              <xsl:value-of select="concat('аниматор_',current-grouping-key(),'_',$номТела)" />
            </xsl:variable>
            
            <xsl:choose>
              <xsl:when test='td[3]="В"'>
                <OrientationInterpolator>
                  <xsl:attribute name="DEF">
                    <xsl:value-of select="$идентификатор" /></xsl:attribute>
                  <xsl:attribute name="key">
                    <xsl:value-of select="$key" /></xsl:attribute>
                  <xsl:attribute name="keyValue">
                    <xsl:value-of select="$keyValue" /></xsl:attribute>
                </OrientationInterpolator>
                <ROUTE fromField="value_changed" toField="set_rotation">
                  <xsl:attribute name="fromNode"><xsl:value-of select="$идентификатор" /></xsl:attribute>
                  <xsl:attribute name="toNode"><xsl:value-of select="concat('тело_',$номТела)" /></xsl:attribute>
                </ROUTE>
              </xsl:when>
              <xsl:when test='td[3]="П"'>
                <PositionInterpolator>
                  <xsl:attribute name="DEF">
                    <xsl:value-of select="$идентификатор" /></xsl:attribute>
                  <xsl:attribute name="key">
                    <xsl:value-of select="$key" /></xsl:attribute>
                  <xsl:attribute name="keyValue">
                    <xsl:value-of select="$keyValue" /></xsl:attribute>
                </PositionInterpolator>
                <ROUTE fromField="value_changed" toField="set_translation">
                  <xsl:attribute name="fromNode"><xsl:value-of select="$идентификатор" /></xsl:attribute>
                  <xsl:attribute name="toNode"><xsl:value-of select="concat('тело_',$номТела)" /></xsl:attribute>
                </ROUTE>
              </xsl:when>
            </xsl:choose>
            
              <!--
            <ROUTE  fromField="fraction_changed" toField="set_fraction" >
              <xsl:attribute name="fromNode"><xsl:value-of select="concat('таймер_',current-grouping-key(),'_',position())" /></xsl:attribute>
              <xsl:attribute name="toNode"><xsl:value-of select="$идентификатор" /></xsl:attribute>
            </ROUTE>-->

          </xsl:for-each>
          
          
        </xsl:for-each-group>
        
        
        
        <xsl:for-each select="//call"><xsl:variable name="ПД" select="@process"/>
          <xsl:variable name="ТППД" select="document(concat('ТП',$ПД,'.html'))" />
          <xsl:variable name="времяПД" select="number($ТППД//tr[last()]/td[1])" />
          <xsl:variable name="поз" select="position()"/>
          
          <TimeSensor>
            <xsl:attribute name="DEF">
              <xsl:value-of select="concat('таймер_',$ПД,'_',$поз)" />
            </xsl:attribute>
            <xsl:attribute name="cycleInterval">
              <xsl:value-of select="$времяПД"/>
            </xsl:attribute>
          </TimeSensor>
          <!--
          <ROUTE fromField="value_changed" toField="set_rotation" fromNode="аниматор_2_1_2" toNode="тело_2"/>
          <ROUTE fromNode="таймер_2_1_5" fromField="fraction_changed" toField="set_fraction" toNode="аниматор_2_1_2"/>-->
          
          <xsl:variable name="СТ" select="document(concat('ТПСТ_',tokenize($ПД,'_')[2],'.html'))" />
          <xsl:variable name="номерСТ" select="tokenize($ПД,'_')[2]" />
          
          <xsl:for-each select="$СТ//tr"> 
            <xsl:variable name="номТела" select="position()+number(tokenize($количествоТел,' ')[number($номерСТ)])"/>
            
            
            <ROUTE  fromField="fraction_changed" toField="set_fraction" > 
              <xsl:attribute name="fromNode"><xsl:value-of select="concat('таймер_',$ПД,'_',$поз)" /></xsl:attribute>
              <xsl:attribute name="toNode"><xsl:value-of select="concat('аниматор_',$ПД,'_',$номТела)" /></xsl:attribute>
            </ROUTE>
          </xsl:for-each>
          
          
        </xsl:for-each>
        <Script DEF="скриптЗапуска">
          <field accessType="outputOnly" name="старт" type="SFBool"/>
          
          <xsl:text>&lt;![CDATA[javascript: </xsl:text>
          <xsl:value-of select="$запуск"/>
          <xsl:text> ]]&gt;</xsl:text>
        </Script>
        <TimeTrigger DEF="старт1"/>
        <ROUTE fromNode='скриптЗапуска' fromField='старт' toNode='старт1' toField='set_boolean' />
        
        <xsl:for-each select="xml/*"> 
          <xsl:choose>
            <xsl:when test=".[name()='all'] and following-sibling::*[1][name()='call']  ">
              <!-- роуты для запуска анимации -->
              <xsl:if test="position() eq 1">
                <xsl:for-each select="./*">  
                  <ROUTE fromNode='старт1' fromField='triggerTime' toField='startTime' >
                    <xsl:attribute name="toNode"><xsl:value-of select="concat('таймер_',@process,'_',position())" /></xsl:attribute>
                  </ROUTE>
                </xsl:for-each>  
              </xsl:if>
              <Script><xsl:attribute name="DEF"><xsl:value-of select="concat('скриптПереключения',position())" /></xsl:attribute>
               <!-- входные узлы для окончания нескольких прооцессов -->
                <xsl:for-each select="./*">
                  <field accessType="inputOnly" type="SFBool">
                    <xsl:attribute name="name"><xsl:value-of select="concat('конец_',@process)" /></xsl:attribute>
                  </field>
                  
                </xsl:for-each>
                
                <!-- один выходной узел для начала следующего процесса -->
                <field accessType="outputOnly" type="SFBool">
                  <xsl:attribute name="name"><xsl:value-of select="concat('начало_', following-sibling::*[1]/@process)" /></xsl:attribute>
                </field>
                
                <xsl:text>&lt;![CDATA[javascript: var </xsl:text>
                <xsl:for-each select="./*"> <xsl:value-of select="concat('вкл_',@process,'=false, ')" /> </xsl:for-each>
                <xsl:value-of select="concat('начало_',following-sibling::*[1]/@process,'=false; ')" />
                <xsl:for-each select="./*">   
                  <xsl:value-of select="concat('function конец_',@process,'(значение){ вкл_',@process,'=значение; сложение();}')" />
                </xsl:for-each>
              <!--  <xsl:if test="position() eq 1"><xsl:value-of select="$запуск"/></xsl:if>-->
                 <xsl:text>  function сложение(){ if(</xsl:text>
                <xsl:for-each select="./*">   
                  <xsl:value-of select="concat('!вкл_',@process)" />
                  <xsl:if test="position() != count(parent::node()/*)">
                    <xsl:text> &amp;&amp; </xsl:text>
                  </xsl:if>
                </xsl:for-each>
                <xsl:value-of select="concat('){ начало_',following-sibling::*[1]/@process,'=true;}}')" />
                <xsl:text> ]]&gt;</xsl:text>
              </Script>
              
              <TimeTrigger>
                <xsl:attribute name="DEF"><xsl:value-of select="concat('переключатель',position())" /></xsl:attribute>
              </TimeTrigger>
              <xsl:variable name="поз" select="position()"/><!-- перенести выше -->
              <xsl:variable name="номерТаймера3">
                  <xsl:number level="any" count="call" select="following-sibling::call[1]"/>
                </xsl:variable>
              <xsl:for-each select="./*">  
                <xsl:variable name="номерТаймера4">
                  <xsl:number level="any" count="call"/>
                </xsl:variable>
                
                <ROUTE fromField="isActive">
                  <xsl:attribute name="fromNode"><xsl:value-of select="concat('таймер_',@process,'_',$номерТаймера4)" /></xsl:attribute><!-- что-то -->
                  <xsl:attribute name="toField"><xsl:value-of select="concat('конец_',@process)" /></xsl:attribute>
                  <xsl:attribute name="toNode"><xsl:value-of select="concat('скриптПереключения',$поз)" /></xsl:attribute>
                </ROUTE>
              </xsl:for-each>
            
              <ROUTE  toField="set_boolean">
                <xsl:attribute name="fromField"><xsl:value-of select="concat('начало_',following-sibling::*[1]/@process)" /></xsl:attribute>
                <xsl:attribute name="fromNode"><xsl:value-of select="concat('скриптПереключения',position())" /></xsl:attribute>
                <xsl:attribute name="toNode"><xsl:value-of select="concat('переключатель',position())" /></xsl:attribute>
              </ROUTE>
              
              <ROUTE fromField="triggerTime" toField="startTime" >
                <xsl:attribute name="fromNode"><xsl:value-of select="concat('переключатель',position())" /></xsl:attribute>
                <xsl:attribute name="toNode"><xsl:value-of select="concat('таймер_',following-sibling::*[1]/@process,'_',$номерТаймера3)" /></xsl:attribute><!-- что-то -->
              </ROUTE>
              
            </xsl:when>
            <xsl:when test=".[name()='all'] and following-sibling::*[1][name()='all']">
              <!-- роуты для запуска анимации -->
              <xsl:if test="position() eq 1">
                <xsl:for-each select="./*">  
                  <ROUTE fromNode='старт1' fromField='triggerTime' toField='startTime' >
                    <xsl:attribute name="toNode"><xsl:value-of select="concat('таймер_',@process,'_',position())" /></xsl:attribute>
                  </ROUTE>
                </xsl:for-each>  
              </xsl:if>
             <Script><xsl:attribute name="DEF"><xsl:value-of select="concat('скриптПереключения',position())" /></xsl:attribute>
               
               <!-- входные узлы для окончания нескольких прооцессов -->
                <xsl:for-each select="./*">
                  <field accessType="inputOnly" type="SFBool">
                    <xsl:attribute name="name"><xsl:value-of select="concat('конец_',@process)" /></xsl:attribute>
                  </field>
                  
                </xsl:for-each>
                
                <!-- один выходной узел для начала следующего процесса -->
                <field  name="начало" accessType="outputOnly" type="SFBool"/>
                
                <!-- поле для запуска анимации 
                <xsl:if test="position() eq 1">
                  <field accessType="outputOnly" name="старт" type="SFBool"/> 
                </xsl:if> -->
                
                <xsl:text>&lt;![CDATA[javascript: var </xsl:text>
                <xsl:for-each select="./*"> <xsl:value-of select="concat('вкл_',@process,'=false, ')" /> </xsl:for-each>
                <xsl:text>начало=false; </xsl:text>
                <xsl:for-each select="./*">   
                  <xsl:value-of select="concat('function конец_',@process,'(значение){ вкл_',@process,'=значение; сложение();}')" />
                </xsl:for-each>
              <!-- <xsl:if test="position() eq 1"><xsl:value-of select="$запуск"/></xsl:if>-->
                <xsl:text>  function сложение(){ if(</xsl:text>
                <xsl:for-each select="./*">   
                  <xsl:value-of select="concat('!вкл_',@process)" />
                  <xsl:if test="position() != count(parent::node()/*)">
                    <xsl:text> &amp;&amp; </xsl:text>
                  </xsl:if>
                </xsl:for-each>
                <xsl:text>){ начало=true;}} ]]&gt;</xsl:text>
              </Script>
              
			  <!--
              <xsl:if test="position() eq 1">
                <TimeTrigger DEF="старт1"/>
                <ROUTE fromNode='скриптПереключения1' fromField='старт' toNode='старт1' toField='set_boolean' />
                <xsl:for-each select="./*">  
                  <ROUTE fromNode='старт1' fromField='triggerTime' toField='startTime' >
                    <xsl:attribute name="toNode"><xsl:value-of select="concat('таймер_',@process,'_',position())" /></xsl:attribute>
                  </ROUTE>
                </xsl:for-each>  
                
              </xsl:if>-->
              
              <TimeTrigger>
                <xsl:attribute name="DEF"><xsl:value-of select="concat('переключатель',position())" /></xsl:attribute>
              </TimeTrigger>
              <xsl:variable name="поз" select="position()"/><!-- перенести выше -->
              
              <xsl:for-each select="./*">  
                <xsl:variable name="номерТаймера4">
                  <xsl:number level="any" count="call"/>
                </xsl:variable>
                
                <ROUTE fromField="isActive">
                  <xsl:attribute name="fromNode"><xsl:value-of select="concat('таймер_',@process,'_',$номерТаймера4)" /></xsl:attribute><!-- что-то -->
                  <xsl:attribute name="toField"><xsl:value-of select="concat('конец_',@process)" /></xsl:attribute>
                  <xsl:attribute name="toNode"><xsl:value-of select="concat('скриптПереключения',$поз)" /></xsl:attribute>
                </ROUTE>
              </xsl:for-each>
            
              <ROUTE  toField="set_boolean" fromField="начало">
                <xsl:attribute name="fromNode"><xsl:value-of select="concat('скриптПереключения',position())" /></xsl:attribute>
                <xsl:attribute name="toNode"><xsl:value-of select="concat('переключатель',position())" /></xsl:attribute>
              </ROUTE>
              
			  
              <xsl:for-each select="following-sibling::*[1]/*">  
                <xsl:variable name="номерТаймера2">
                  <xsl:number level="any" count="call"/>
                </xsl:variable>
                <ROUTE fromField="triggerTime" toField="startTime">
                  <xsl:attribute name="fromNode"><xsl:value-of select="concat('переключатель',$поз)" /></xsl:attribute>
                  <xsl:attribute name="toNode"><xsl:value-of select="concat('таймер_',@process,'_',$номерТаймера2)" /></xsl:attribute><!-- что-то -->
                </ROUTE>
              </xsl:for-each>
			 
            </xsl:when>
            <xsl:when test=".[name()='call'] and following-sibling::*[1][name()='all']">
              <!-- роуты для запуска анимации -->
              <xsl:if test="position() eq 1">
                  <ROUTE fromNode='старт1' fromField='triggerTime' toField='startTime' >
                    <xsl:attribute name="toNode"><xsl:value-of select="concat('таймер_',@process,'_',position())" /></xsl:attribute>
                  </ROUTE>
               </xsl:if>
              <BooleanFilter>
                <xsl:attribute name="DEF"><xsl:value-of select="concat('фильтр',position())" /></xsl:attribute>
              </BooleanFilter>
              <TimeTrigger>
                <xsl:attribute name="DEF"><xsl:value-of select="concat('переключатель',position())" /></xsl:attribute>
              </TimeTrigger>
              
              <xsl:variable name="номерТаймера1">
                <xsl:number level="any" count="call"/>
              </xsl:variable>
                         
              <ROUTE fromField="isActive" toField="set_boolean" >
                <xsl:attribute name="fromNode"><xsl:value-of select="concat('таймер_',@process,'_',$номерТаймера1)" /></xsl:attribute><!-- что-то -->
                <xsl:attribute name="toNode"><xsl:value-of select="concat('фильтр',position())" /></xsl:attribute>
              </ROUTE>
              <ROUTE fromField="inputFalse" toField="set_boolean" >
                <xsl:attribute name="fromNode"><xsl:value-of select="concat('фильтр',position())" /></xsl:attribute>
                <xsl:attribute name="toNode"><xsl:value-of select="concat('переключатель',position())" /></xsl:attribute>
              </ROUTE>
              <xsl:variable name="поз" select="position()"/><!-- перенести выше -->
              <xsl:for-each select="following-sibling::*[1]/*">  
                <xsl:variable name="номерТаймера2">
                  <xsl:number level="any" count="call"/>
                </xsl:variable>
                <ROUTE fromField="triggerTime" toField="startTime">
                  <xsl:attribute name="fromNode"><xsl:value-of select="concat('переключатель',$поз)" /></xsl:attribute>
                  <xsl:attribute name="toNode"><xsl:value-of select="concat('таймер_',@process,'_',$номерТаймера2)" /></xsl:attribute><!-- что-то -->
                </ROUTE>
              </xsl:for-each>
              
              
              
              
              
              
            </xsl:when>
            <xsl:when test=".[name()='call'] and  following-sibling::*[1][name()='call']">
              <!-- роуты для запуска анимации -->
              <xsl:if test="position() eq 1">
                <ROUTE fromNode='старт1' fromField='triggerTime' toField='startTime' >
                  <xsl:attribute name="toNode"><xsl:value-of select="concat('таймер_',@process,'_',position())" /></xsl:attribute>
                </ROUTE>
              </xsl:if>
              <BooleanFilter>
                <xsl:attribute name="DEF"><xsl:value-of select="concat('фильтр',position())" /></xsl:attribute>
              </BooleanFilter>
              <TimeTrigger>
                <xsl:attribute name="DEF"><xsl:value-of select="concat('переключатель',position())" /></xsl:attribute>
              </TimeTrigger>
              
              <xsl:variable name="номерТаймера1">
                <xsl:number level="any" count="call"/>
              </xsl:variable>
              
              <ROUTE fromField="isActive" toField="set_boolean" >
                <xsl:attribute name="fromNode"><xsl:value-of select="concat('таймер_',@process,'_',$номерТаймера1)" /></xsl:attribute><!-- что-то -->
                <xsl:attribute name="toNode"><xsl:value-of select="concat('фильтр',position())" /></xsl:attribute>
              </ROUTE>
              <ROUTE fromField="inputFalse" toField="set_boolean" >
                <xsl:attribute name="fromNode"><xsl:value-of select="concat('фильтр',position())" /></xsl:attribute>
                <xsl:attribute name="toNode"><xsl:value-of select="concat('переключатель',position())" /></xsl:attribute>
              </ROUTE>
              <xsl:variable name="поз" select="position()"/><!-- перенести выше -->
              <xsl:for-each select="following-sibling::*[1]">  
                <xsl:variable name="номерТаймера2">
                  <xsl:number level="any" count="call"/>
                </xsl:variable>
                <ROUTE fromField="triggerTime" toField="startTime">
                  <xsl:attribute name="fromNode"><xsl:value-of select="concat('переключатель',$поз)" /></xsl:attribute>
                  <xsl:attribute name="toNode"><xsl:value-of select="concat('таймер_',@process,'_',$номерТаймера2)" /></xsl:attribute><!-- что-то -->
                </ROUTE>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          
        </xsl:for-each>

      </Scene>
    </X3D>
  </xsl:template>
      
    
  <xsl:template name="получить_keyValue">
    <xsl:param name="номерТела" />
    <xsl:param name="номерСтрокиТППД"  />
    <xsl:param name="СТ"  />
    <xsl:param name="ТППД"  />
<xsl:param name="начальное_q"  />
<xsl:param name="номерСТ"  />
   
	
    <xsl:if test="1 &lt;=  $номерСтрокиТППД">
      <xsl:variable name="перенос" select="document('ТПРТК.html')//tr[number(tokenize($количествоТел,' ')[number($номерСТ)])+number($номерТела)]/td[5]" />

      <xsl:variable name="тело" select="$СТ//tr[$номерТела]" />
      <xsl:variable name="ОК">
        <xsl:variable name="q" select="$ТППД//tr[$номерСтрокиТППД]/td[$номерТела+1]" />
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
		  
            <xsl:variable name="x" select="tokenize($перенос,',')[1]" />
            <xsl:variable name="y" select="tokenize($перенос,',')[2]" />
            <xsl:variable name="z" select="tokenize($перенос,',')[3]" />
            <xsl:choose>
              <xsl:when test='$тело/td[4]="X"'>
			    <xsl:variable name="начальное" >
				  <xsl:choose>
				    <xsl:when test="$тело/td[2] = 0">
					  <xsl:value-of select="number($q)+number($x)"/>
				    </xsl:when>
					<xsl:otherwise> 
					  <xsl:value-of select="$q"/>
					</xsl:otherwise>
				  </xsl:choose>
			    </xsl:variable>
                <xsl:value-of select="concat($начальное,' ',$y,' ',$z)" /> </xsl:when>
              <xsl:when test='$тело/td[4]="Y"'>
			    <xsl:variable name="начальное" >
				  <xsl:choose>
				    <xsl:when test="$тело/td[2] = 0">
					  <xsl:value-of select="number($q)+number($y)"/>
				    </xsl:when>
					<xsl:otherwise> 
					  <xsl:value-of select="$q"/>
					</xsl:otherwise>
				  </xsl:choose>
			    </xsl:variable>
                <xsl:value-of select="concat($x,' ',$начальное,' ',$z)" /> </xsl:when>
              <xsl:when test='$тело/td[4]="Z"'>
			    <xsl:variable name="начальное" >
				  <xsl:choose>
				    <xsl:when test="$тело/td[2] = 0">
					  <xsl:value-of select="number($q)+number($z)"/>
				    </xsl:when>
					<xsl:otherwise> 
					  <xsl:value-of select="$q"/>
					</xsl:otherwise>
				  </xsl:choose>
			    </xsl:variable>
                <xsl:value-of select="concat($x,' ',$y,' ',$начальное)" /> </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="получить_keyValue">
        <xsl:with-param name="номерСтрокиТППД" select="$номерСтрокиТППД - 1" />
        <xsl:with-param name="номерТела" select="$номерТела" /> 
        <xsl:with-param name="СТ" select="$СТ" /> 
        <xsl:with-param name="ТППД" select="$ТППД" /> 
        <xsl:with-param name="начальное_q" select="$начальное_q" /> 
        <xsl:with-param name="номерСТ"  select="$номерСТ" />
      </xsl:call-template> 
      <xsl:value-of select="concat(', ',replace($ОК,'--',''))" /> </xsl:if>
  </xsl:template>
  
  
  <xsl:template name="получить_key">
    <xsl:param name="номерСтрокиТППД" />
    <xsl:param name="ТППД" />
    <xsl:variable name="время" select="number($ТППД//tr[last()]/td[1])" />
    <xsl:if test="1 &lt;=  $номерСтрокиТППД">
      <xsl:variable name="доля" select="format-number(number($ТППД//tr[$номерСтрокиТППД]/td[1]) div $время,'#.0000')" />
      <xsl:call-template name="получить_key">
        <xsl:with-param name="номерСтрокиТППД" select="$номерСтрокиТППД - 1" /> 
        <xsl:with-param name="ТППД" select="$ТППД" /> 
      </xsl:call-template>
      <xsl:value-of select="concat(', ',$доля)" /> </xsl:if>
  </xsl:template>
    
  <xsl:template name="получитьСписокКоличестваТел">
    <xsl:param name="номерСТ" select="1" />
    <xsl:param name="суммаКолТел" select="0" />
    <xsl:value-of select="concat($суммаКолТел,' ')" />
    <xsl:if test="$колСТ &gt;= $номерСТ">
      <xsl:variable name="колСтрок" select="count(document(concat('ТПСТ_',$номерСТ,'.html'))//tr)" />
     
      <xsl:call-template name="получитьСписокКоличестваТел">
        <xsl:with-param name="номерСТ" select="$номерСТ+1" />
        <xsl:with-param name="суммаКолТел" select="$суммаКолТел+$колСтрок" /> </xsl:call-template>
    </xsl:if> 
  </xsl:template>
  

  
  
</xsl:stylesheet>