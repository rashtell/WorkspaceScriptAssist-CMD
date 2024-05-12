@echo off
:: Dependencies - pascal-case.bat

:: Elevate the current console window to admin
::#region
setlocal
cd /d "%~dp0"
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if "%errorlevel%" NEQ "0" (
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)

cd \
endlocal
::#endregion

:: Actual script starts here
setlocal EnableDelayedExpansion


::#region Get Inputs
    set "workspace_path=C:\workspace"

    ::#region Project
    :: Inputs
    set "projects_path=!workspace_path!\projects"

    if not exist %projects_path% (
        md "%projects_path%"
    )

    ::#region Check if the projects path is empty
    set "is_projects_path_empty=true"
    for /f %%i in ('dir /b "!projects_path!"') do (
        set "is_projects_path_empty=false"
        goto :projects_path_check_end
    )
    :projects_path_check_end
    ::#endregion Check if the projects-path is empty

    set "project_name="

    ::#region Project input
    :input_project_name
    goto :project_input_end
    :project_input_start

    set /p project_name=Enter project name: 
    if "!project_name!"=="" (
        echo Project name cannot be empty. Please try again.
        echo.
        if "!is_projects_path_empty!"=="true" (
            goto :input_project_name
        ) else (
            goto :list_projects
        )
    )

    :: Convert to camel case and remove spaces
    for /f "delims=" %%a in ('pascal-case.bat !project_name!') do (
        set "project_name=%%a"
    )
    :project_input_end
    ::#endregion Project input

    ::#region Project input and list
    if "!project_name!"=="" (
        if "!is_projects_path_empty!"=="true" (
            goto :project_input_start
        )
    )

    if "!project_name!"=="" (
        if "!is_projects_path_empty!"=="false" (
        :list_projects
            :: List the projects with indexes
            echo 0. Manually Input Project
            set "index=0"
            for /f "tokens=*" %%i in ('dir /b /ad "!projects_path!"') do (
                set /a "index+=1"
                echo !index!. %%i
            )
            echo.

            :: Prompt for the project index
            set "choice="
            set /p "choice=Input the index of the project you want to delete: "

            if "!choice!"=="0" (
                goto :project_input_start
            ) else if "!choice!" GEQ "1" (
                :: Find the corresponding project
                set "current_index=0"
                for /f "tokens=*" %%i in ('dir /b /ad "!projects_path!"') do (        
                    set /a "current_index+=1"
                    if "!current_index!"=="!choice!" (
                        set "project_name=%%i"
                        goto :end_corresponding_project
                    )
                )
            )

            goto :list_projects
        )   
    )

    :end_corresponding_project
    ::#endregion Project input and list

    :: Echo the selected project
    if not defined project_name (
        echo Invalid project index. Please enter a valid index.
        echo.
        goto :input_project_name
    ) 
    ::#endregion Project

::#endregion Get Inputs

:: clear console
cls

:: Set the project path
set "project_path=%projects_path%\!project_name!"

:: Loop through each subfolder in the project path
for /f %%i in ('dir /b /ad "!project_path!" 2^>null') do (
    set "sub_project_name=%%i"
    set "sub_project_path=!project_path!\!sub_project_name!"

    :: Handle Xampp
    set "xampp7Link=C:\xampp7.4\htdocs\!sub_project_name!"
    set "xampp8Link=C:\xampp8\htdocs\!sub_project_name!"
    set "xamppLink=C:\xampp\htdocs\!sub_project_name!"
    
    :: Remove symbolic links from XAMPP directories if they exist
    if exist !xampp7Link! (
        rd /s /q !xampp7Link!
        echo Unlinked !sub_project_name! from xampp7.
        echo.
    )
    if exist !xampp8Link! (
        rd /s /q !xampp8Link!
        echo Unlinked !sub_project_name! from xampp8.
        echo.
    )
    if exist !xamppLink! (
        rd /s /q !xamppLink!
        echo Unlinked !sub_project_name! from xampp.
        echo.
    )

    :: Loop through folders up to two generations deep
    for /d %%a in (!workspace_path!\*) do (
        for /d %%b in ("%%a\*") do (
            if %%a==!workspace_path!\lang-frames (   
                :: For lang-frames folder, go one level deeper
                for /d %%c in ("%%b\*") do (
                    for /f "tokens=4,5,*" %%d in ('dir "%%c" /al  2^>nul') do (                    
                        set "link_target=%%e"
                        
                        if /i "!link_target!"=="[!sub_project_path!]" (
                            rd /s /q %%c\%%d
                            echo Found %%c\%%d
                            echo Unlinked !sub_project_name! from %%a.
                            echo.
                        )
                    )
                )
            ) else (
                :: For other folders, directly search for symbolic links
                for /f "tokens=4,5,*" %%f in ('dir "%%b" /al  2^>nul') do (     
                    set "link_target=%%g"
                    
                    if /i "!link_target!"=="[!sub_project_path!]" (
                        rd /s /q %%b\%%f
                        echo Found %%b\%%f
                        echo Unlinked !sub_project_name! from %%a.
                        echo.
                    )

                    if /i "!link_target!"=="[!project_path!]" (
                        rd /s /q %%b\%%f
                        echo Found %%b\%%f
                        echo Unlinked !project_name! from %%a.
                        echo.
                    )                   
                )
            )
        )
    )
)

:: Handle project
::#region
if exist "%project_path%" (
    rd /s /q "%project_path%"
    echo Project directory deleted.
    echo .
)
::#endregion

pause