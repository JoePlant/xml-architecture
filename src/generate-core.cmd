
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

%nxslt% Working\model.xml StyleSheets\render-adapters.xslt -o Working\adapters-node-tb.dotml message-format=node title="Adapters & Messages View" direction=TB
%nxslt% Working\model.xml StyleSheets\render-adapters.xslt -o Working\adapters-node-lr.dotml message-format=node title="Adapters & Messages View" direction=LR
%nxslt% Working\model.xml StyleSheets\render-adapters.xslt -o Working\adapters-label-tb.dotml message-format=label title="Adapters View" direction=TB
%nxslt% Working\model.xml StyleSheets\render-adapters.xslt -o Working\adapters-label-lr.dotml message-format=label title="Adapters View" direction=LR
%nxslt% Working\model.xml StyleSheets\render-adapters.xslt -o Working\adapters-simple-tb.dotml message-format=none title="Simple Adapters View" direction=TB
%nxslt% Working\model.xml StyleSheets\render-adapters.xslt -o Working\adapters-simple-lr.dotml message-format=none title="Simple Adapters View" direction=LR
%nxslt% Working\adapters-node-tb.dotml %dotml%\dotml2dot.xsl -o "Working\adapters-node-tb.gv" 
%nxslt% Working\adapters-node-lr.dotml %dotml%\dotml2dot.xsl -o "Working\adapters-node-lr.gv" 
%nxslt% Working\adapters-label-tb.dotml %dotml%\dotml2dot.xsl -o "Working\adapters-label-tb.gv" 
%nxslt% Working\adapters-label-lr.dotml %dotml%\dotml2dot.xsl -o "Working\adapters-label-lr.gv" 
%nxslt% Working\adapters-simple-tb.dotml %dotml%\dotml2dot.xsl -o "Working\adapters-simple-tb.gv" 
%nxslt% Working\adapters-simple-lr.dotml %dotml%\dotml2dot.xsl -o "Working\adapters-simple-lr.gv" 
%graphviz%\dot.exe -Tpng "Working\adapters-node-tb.gv"  -o "%output%\adapters-top-node.png"
%graphviz%\dot.exe -Tpng "Working\adapters-node-lr.gv"  -o "%output%\adapters-left-node.png"
%graphviz%\dot.exe -Tpng "Working\adapters-label-tb.gv"  -o "%output%\adapters-top-label.png"
%graphviz%\dot.exe -Tpng "Working\adapters-label-lr.gv"  -o "%output%\adapters-left-label.png"
%graphviz%\dot.exe -Tpng "Working\adapters-simple-tb.gv"  -o "%output%\adapters-top-simple.png"
%graphviz%\dot.exe -Tpng "Working\adapters-simple-lr.gv"  -o "%output%\adapters-left-simple.png"

@echo   Generated: %output%\adapters-top-node.png
@echo   Generated: %output%\adapters-left-node.png
@echo   Generated: %output%\adapters-top-label.png
@echo   Generated: %output%\adapters-left-label.png
@echo   Generated: %output%\adapters-top-simple.png
@echo   Generated: %output%\adapters-left-simple.png

goto end

:Error
echo Something is not right. 
echo Please check that these exist
echo Model=%model%
echo OutputDir=%output%

:end
pause