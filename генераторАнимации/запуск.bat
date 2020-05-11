chcp 65001
start java -jar "C:/saxon/saxon9he.jar" -xsl:"генераторАнимацииТППД.xsl" -s:"ТППД.html" -o:"анимация.x3d" TP="ТПСТ.html" path="."