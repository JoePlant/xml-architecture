rem @echo off
set sample=..\doc\Sample\sample.xml

if EXIST Working goto Working_exists
mkdir Working
:Working_exists

set nxslt=..\lib\nxslt\nxslt.exe
set graphviz=..\lib\GraphViz-2.30.1\bin
set dotml=..\lib\dotml-1.4

@echo === Sample ===
%nxslt% %sample% StyleSheets\generate-model.xslt -o Working\model.xml 

@echo === Generate Diagrams ===

%nxslt% Working\model.xml StyleSheets\render-services.xslt -o Working\services.dotml cluster=true
%nxslt% Working\model.xml StyleSheets\render-services.xslt -o Working\services2.dotml
%nxslt% Working\services.dotml %dotml%\dotml2dot.xsl -o "Working\services.gv" 
%nxslt% Working\services2.dotml %dotml%\dotml2dot.xsl -o "Working\services2.gv" 
%graphviz%\dot.exe -Tpng "Working\services.gv"  -o "..\doc\Sample\services.png"
%graphviz%\dot.exe -Tpng "Working\services2.gv"  -o "..\doc\Sample\services2.png"

pause