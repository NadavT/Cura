copy /Y "..\CuraEngine\install_dir_classic\bin\CuraEngine.exe" CuraEngine.exe
copy /Y "..\CuraEngine\install_dir_ratio\bin\CuraEngine.exe" CuraEngine_ratio.exe
copy /Y "..\CuraEngine\install_dir_differential\bin\CuraEngine.exe" CuraEngine_differntial.exe
cmd /V /C "set PYTHONPATH=!PYTHONPATH!;C:\dev\cura\Uranium && python cura_app.py"
