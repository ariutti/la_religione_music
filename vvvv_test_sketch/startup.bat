@echo off

echo "starting SuperCollider w/ the desired file"
start "supercollider" sclang C:\Users\nicola\Documents\repos\la_religione_music\sounds\test.scd

echo "starting VVVV w/ the desired patch" 
start "vvvv_window" vvvv /o "C:\Users\nicola\Documents\repos\la_religione_music\vvvv_test_sketch\osc-controller.v4p"