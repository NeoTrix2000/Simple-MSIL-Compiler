msbuild /Property:configuration=Release /Property:platform=x86
mkdir \occil
xcopy /S /Y ..\installartifacts\*.* \occil  
mkdir \occil\DotNetPELib
xcopy /S /Y ..\netil\netlib\*.* \occil\DotNetPELib
xcopy Release\*.exe \occil\bin
xcopy Release\*.dll \occil\bin
iscc ..\occil.iss
