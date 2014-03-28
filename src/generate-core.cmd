
set model=%1
set output=%2

if NOT EXIST %model% goto ERROR
if NOT EXIST %output% goto ERROR

if EXIST Working goto Working_exists
mkdir Working
:Working_exists

set nxslt=..\lib\nxslt\nxslt.exe
set graphviz=..\lib\GraphViz-2.30.1\bin
set dotml=..\lib\dotml-1.4

@echo === Model ===
@echo Model = %model%
%nxslt% %model% StyleSheets\generate-model.xslt -o Working\model.xml 

@echo === Service Diagrams ===

%nxslt% Working\model.xml StyleSheets\render-services.xslt -o Working\services-simple.dotml message-format=none title="Simple Services View" direction=TB
%nxslt% Working\model.xml StyleSheets\render-services.xslt -o Working\services-label.dotml message-format=label title="Services View" direction=TB
%nxslt% Working\model.xml StyleSheets\render-services.xslt -o Working\services-node.dotml message-format=node title="Services & Messages View" direction=LR
%nxslt% Working\services-simple.dotml %dotml%\dotml2dot.xsl -o "Working\services-simple.gv" 
%nxslt% Working\services-label.dotml %dotml%\dotml2dot.xsl -o "Working\services-label.gv" 
%nxslt% Working\services-node.dotml %dotml%\dotml2dot.xsl -o "Working\services-node.gv" 
%graphviz%\dot.exe -Tpng "Working\services-simple.gv"  -o "%output%\services-simple.png"
%graphviz%\dot.exe -Tpng "Working\services-label.gv"  -o "%output%\services-label.png"
%graphviz%\dot.exe -Tpng "Working\services-node.gv"  -o "%output%\services-node.png"

@echo   Generated: %output%\services-simple.png
@echo   Generated: %output%\services-label.png
@echo   Generated: %output%\services-node.png

@echo === Adapter Diagrams ===

%nxslt% Working\model.xml StyleSheets\render-adapters.xslt -o Working\adapters.dotml
%nxslt% Working\adapters.dotml %dotml%\dotml2dot.xsl -o "Working\adapters.gv" 
%graphviz%\dot.exe -Tpng "Working\adapters.gv"  -o "%output%\adapters.png"

@echo   Generated: %output%\adapters.png

goto end

:Error
echo Something is not right. 
echo Please check that these exist
echo Model=%model%
echo OutputDir=%output%

:end
pause