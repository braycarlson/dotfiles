@echo off
setlocal

for %%i in (
    "%USERPROFILE%\AppData\Roaming\alacritty"
    "%USERPROFILE%\AppData\Roaming\Sublime Text\Packages\User"
    "%USERPROFILE%\AppData\Local\nvim"
) do (
    if exist %%i (
        echo Adding %%i...
        chezmoi add -r %%i
    ) else (
        echo WARNING: %%i does not exist, skipping...
    )
)

endlocal
pause
