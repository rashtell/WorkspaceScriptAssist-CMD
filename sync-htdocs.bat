@echo off
setlocal enabledelayedexpansion


:: Function to collect symbolic links from a given directory
set "base_path=%1"

if not exist "%base_path%" (
    set "base_path=C:\"
)

echo Collecting links from: %base_path%

:: Define the base xampp directory pattern
set "xampp_base=%base_path%xampp*"

:: Handle Xampp directories
for /d %%a in (!xampp_base!) do (
    echo Processing xampp directory: %%a

    set "htdocs_folder=%%a\htdocs"

    if exist "!htdocs_folder!" (
        for /f "tokens=*" %%b in ('dir /al /b "!htdocs_folder!"') do (
            set "link_name=%%b"
            set "link_target=!htdocs_folder!\%%b"

            :: Iterate through all xampp htdocs folders and create the link if it doesn't exist
            for /d %%d in (!xampp_base!) do (
                set "link_path=%%d\htdocs\!link_name!"

                if not exist "!link_path!" (
                    echo Creating link: !link_name! - !link_target! in %%d\htdocs

                    mklink /D "!link_path!" "!link_target!"

                    echo Created link: !link_name! in %%d\htdocs
                )
            )
        )
    ) else (
        echo htdocs folder not found: !htdocs_folder!
    )
)


echo Synchronization complete.

endlocal

pause
