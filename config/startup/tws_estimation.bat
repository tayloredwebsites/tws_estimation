rem \config\startup\tws_estimation.bat
rem set ruby version
echo "set path to ruby version 1.9.3 p125"
path C:\progs\RailsInstaller\Ruby1.9.3\bin;%path%
rem start up thin server
cd \sites\estimation
echo "start up estimation thin server on port 4002"
C:\progs\RailsInstaller\Ruby1.9.3\bin\thin.bat --port 4002 start
