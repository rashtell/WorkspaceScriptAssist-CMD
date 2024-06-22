@echo off
:: Dependencies - pascal-case.bat

:: Elevate the current console window to admin
::#region
:: Set the current directory to the script's directory
setlocal
cd /d "%~dp0"

:: Check and request admin privileges if not already elevated
::#region
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if "%errorlevel%" NEQ "0" (
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)
::#endregion

:: Change directory to the root of the current drive
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
    for /f %%i in ('dir /b /ad "!projects_path!" 2^>null') do (
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
            :: List the projects with indexes
            :list_projects
            echo 0. New Project
            set "index=0"
            for /f "tokens=*" %%i in ('dir /b /ad "!projects_path!" 2^>null') do (
                set /a "index+=1"
                echo !index!. %%i
            )
            echo.

            :: Prompt for the project index
            set "choice="
            set /p "choice=Input the index of the project you want to select: "

            if "!choice!"=="0" (
                goto :project_input_start
            ) else if "!choice!" GEQ "1" (
                :: Find the corresponding project
                set "current_index=0"
                for /f "tokens=*" %%i in ('dir /b /ad "!projects_path!" 2^>null') do (        
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

    
    ::#region Sub-project
    :: Inputs
    set "sub_projects_path=!projects_path!\!project_name!"

    ::#region Check if the sub-projects path is empty
    set "is_sub_projects_path_empty=true"
    for /f %%i in ('dir /b /ad "!sub_projects_path!" 2^>null') do (
        set "is_sub_projects_path_empty=false"
        goto :sub_projects_path_check_end
    )
    :sub_projects_path_check_end
    ::#endregion Check if the sub-projects path is empty

    set "sub_project_name="

    ::#region Sub-project input
    :input_sub_project_name
    goto :sub_project_input_end
    :sub_project_input_start

    set /p sub_project_name=Enter sub-project name: 
    if "!sub_project_name!"=="" (
        echo Sub_project name cannot be empty. Please try again.
        echo.
        if "!is_sub_projects_path_empty!"=="true" (
            goto :input_sub_project_name
        ) else (
            goto :list_sub_projects
        )
    )

    :: Convert to camel case and remove spaces
    for /f "delims=" %%a in ('pascal-case.bat !sub_project_name!') do (
        set "sub_project_name=%%a"
    )
    :sub_project_input_end
    ::#endregion Sub-project input

    ::#region Sub-project input and list
    if "!sub_project_name!"=="" (
        if "!is_sub_projects_path_empty!"=="true" (
            goto :sub_project_input_start
        )
    )

    if "!sub_project_name!"=="" (
        if "!is_sub_projects_path_empty!"=="false" (
            :: List the sub-projects with indexes
            :list_sub_projects
            echo 0. New Sub-project
            set "index=0"
            for /f "tokens=*" %%i in ('dir /b /ad "!sub_projects_path!" 2^>null') do (
                set /a "index+=1"
                echo !index!. %%i
            )
            echo.

            :: Prompt for the sub-project index
            set "choice="
            set /p "choice=Input the index of the sub-project you want to select: "

            if "!choice!"=="0" (
                goto :sub_project_input_start
            ) else if "!choice!" GEQ "1" (
                :: Find the corresponding sub-project
                set "current_index=0"
                for /f "tokens=*" %%i in ('dir /b /ad "!sub_projects_path!" 2^>null') do (        
                    set /a "current_index+=1"
                    if "!current_index!"=="!choice!" (
                        set "sub_project_name=%%i"
                        goto :end_corresponding_sub_project
                    )
                )
            )

            goto :list_sub_projects
        )   
    )

    :end_corresponding_sub_project
    ::#endregion Sub-project input and list

    :: Echo the selected sub_project
    if not defined sub_project_name (
        echo Invalid sub-project index. Please enter a valid index.
        echo.
        goto :input_sub_project_name
    ) 
    ::#endregion Sub-project


    ::#region Organization
    :: Inputs
    set "organizations_path=!workspace_path!\organizations"

    if not exist %organizations_path% (
        md "%organizations_path%" 
    )

    ::#region Check if the organizations path is empty
    set "is_organizations_path_empty=true"
    for /f %%i in ('dir /b /ad "!organizations_path!" 2^>null') do (
        set "is_organizations_path_empty=false"
        goto :organizations_path_check_end
    )
    :organizations_path_check_end
    ::#endregion Check if the organizations-path is empty

    set "organization_name="

    ::#region Organization input
    :input_organization_name
    goto :organization_input_end
    :organization_input_start

    set /p organization_name=Enter organization name: 
    if "!organization_name!"=="" (
        echo Organization name cannot be empty. Please try again.
        echo.
        if "!is_organizations_path_empty!"=="true" (
            goto :input_organization_name
        ) else (
            goto :list_organizations
        )
    )

    :: Convert to camel case and remove spaces
    for /f "delims=" %%a in ('pascal-case.bat !organization_name!') do (
        set "organization_name=%%a"
    )
    :organization_input_end
    ::#endregion Organization input

    ::#region Organization input and list
    if "!organization_name!"=="" (
        if "!is_organizations_path_empty!"=="true" (
            goto :organization_input_start
        )
    )

    if "!organization_name!"=="" (
        if "!is_organizations_path_empty!"=="false" (
            :: List the organizations with indexes
            :list_organizations
            echo 0. New Organization
            set "index=0"
            for /f "tokens=*" %%i in ('dir /b /ad "!organizations_path!" 2^>null') do (
                set /a "index+=1"
                echo !index!. %%i
            )
            echo.

            :: Prompt for the organization index
            set "choice="
            set /p "choice=Input the index of the organization you want to select: "

            if "!choice!"=="0" (
                goto :organization_input_start
            ) else if "!choice!" GEQ "1" (
                :: Find the corresponding organization
                set "current_index=0"
                for /f "tokens=*" %%i in ('dir /b /ad "!organizations_path!" 2^>null') do (        
                    set /a "current_index+=1"
                    if "!current_index!"=="!choice!" (
                        set "organization_name=%%i"
                        goto :end_corresponding_organization
                    )
                )
            )

            goto :list_organizations
        )   
    )

    :end_corresponding_organization
    ::#endregion Organization input and list

    :: Echo the selected organization
    if not defined organization_name (
        echo Invalid organization index. Please enter a valid index.
        echo.
        goto :input_organization_name
    ) 
    ::#endregion Project

        
    ::#region Platform
    :: Inputs
    set "platforms_path=!workspace_path!\platforms"

    if not exist %platforms_path% (
        md "%platforms_path%" 
    )

    ::#region Check if the platforms path is empty
    set "is_platforms_path_empty=true"
    for /f %%i in ('dir /b /ad "!platforms_path!" 2^>null') do (
        set "is_platforms_path_empty=false"
        goto :platforms_path_check_end
    )
    :platforms_path_check_end
    ::#endregion Check if the platforms-path is empty

    set "platform="

    ::#region Platform input
    :input_platform
    goto :platform_input_end
    :platform_input_start

    set /p platform=Enter platform name: 
    if "!platform!"=="" (
        echo Platform name cannot be empty. Please try again.
        echo.
        if "!is_platforms_path_empty!"=="true" (
            goto :input_platform
        ) else (
            goto :list_platforms
        )
    )

    :: Convert to camel case and remove spaces
    for /f "delims=" %%a in ('pascal-case.bat !platform!') do (
        set "platform=%%a"
    )
    :platform_input_end
    ::#endregion Platform input

    ::#region Platform input and list
    if "!platform!"=="" (
        if "!is_platforms_path_empty!"=="true" (
            goto :platform_input_start
        )
    )

    if "!platform!"=="" (
        if "!is_platforms_path_empty!"=="false" (
            :: List the platforms with indexes
            :list_platforms
            echo 0. New Platform
            set "index=0"
            for /f "tokens=*" %%i in ('dir /b /ad "!platforms_path!" 2^>null') do (
                set /a "index+=1"
                echo !index!. %%i
            )
            echo.

            :: Prompt for the platform index
            set "choice="
            set /p "choice=Input the index of the platform you want to select: "

            if "!choice!"=="0" (
                goto :platform_input_start
            ) else if "!choice!" GEQ "1" (
                :: Find the corresponding platform
                set "current_index=0"
                for /f "tokens=*" %%i in ('dir /b /ad "!platforms_path!" 2^>null') do (        
                    set /a "current_index+=1"
                    if "!current_index!"=="!choice!" (
                        set "platform=%%i"
                        goto :end_corresponding_platform
                    )
                )
            )

            goto :list_platforms
        )   
    )

    :end_corresponding_platform
    ::#endregion Platform input and list

    :: Echo the selected platform
    if not defined platform (
        echo Invalid platform index. Please enter a valid index.
        echo.
        goto :input_platform
    ) 
    ::#endregion Project

        
    ::#region Language
    :: Inputs
    set "languages_path=!workspace_path!\languages"

    if not exist %languages_path% (
        md "%languages_path%" 
    )

    ::#region Check if the languages path is empty
    set "is_languages_path_empty=true"
    for /f %%i in ('dir /b /ad "!languages_path!" 2^>null') do (
        set "is_languages_path_empty=false"
        goto :languages_path_check_end
    )
    :languages_path_check_end
    ::#endregion Check if the languages-path is empty

    set "language="

    ::#region Language input
    :input_language
    goto :language_input_end
    :language_input_start

    set /p language=Enter language name: 
    if "!language!"=="" (
        echo Language name cannot be empty. Please try again.
        echo.
        if "!is_languages_path_empty!"=="true" (
            goto :input_language
        ) else (
            goto :list_languages
        )
    )

    :: Convert to camel case and remove spaces
    for /f "delims=" %%a in ('pascal-case.bat !language!') do (
        set "language=%%a"
    )
    :language_input_end
    ::#endregion Language input

    ::#region Language input and list
    if "!language!"=="" (
        if "!is_languages_path_empty!"=="true" (
            goto :language_input_start
        )
    )

    if "!language!"=="" (
        if "!is_languages_path_empty!"=="false" (
            :: List the languages with indexes
            :list_languages
            echo 0. New Language
            set "index=0"
            for /f "tokens=*" %%i in ('dir /b /ad "!languages_path!" 2^>null') do (
                set /a "index+=1"
                echo !index!. %%i
            )
            echo.

            :: Prompt for the language index
            set "choice="
            set /p "choice=Input the index of the language you want to select: "

            if "!choice!"=="0" (
                goto :language_input_start
            ) else if "!choice!" GEQ "1" (
                :: Find the corresponding language
                set "current_index=0"
                for /f "tokens=*" %%i in ('dir /b /ad "!languages_path!" 2^>null') do (        
                    set /a "current_index+=1"
                    if "!current_index!"=="!choice!" (
                        set "language=%%i"
                        goto :end_corresponding_language
                    )
                )
            )

            goto :list_languages
        )   
    )

    :end_corresponding_language
    ::#endregion Language input and list

    :: Echo the selected language
    if not defined language (
        echo Invalid language index. Please enter a valid index.
        echo.
        goto :input_language
    ) 
    ::#endregion Project

        
    ::#region Framework
    :: Inputs
    set "frameworks_path=!workspace_path!\frameworks"
    set "lang_frames_path=!workspace_path!\lang-frames\!language!"

    if not exist %frameworks_path% (
        md "%frameworks_path%" 
    )

    if not exist %lang_frames_path% (
        md "%lang_frames_path%" 
    )

    ::#region Check if the frameworks path is empty
    set "is_frameworks_path_empty=true"
    for /f %%i in ('dir /b /ad "!lang_frames_path!" 2^>null') do (
        set "is_frameworks_path_empty=false"
        goto :frameworks_path_check_end
    )
    :frameworks_path_check_end
    ::#endregion Check if the frameworks-path is empty

    set "framework="

    ::#region Framework input
    :input_framework
    goto :framework_input_end
    :framework_input_start

    set /p framework=Enter framework name: 
    if "!framework!"=="" (
        echo Framework name cannot be empty. Please try again.
        echo.
        if "!is_frameworks_path_empty!"=="true" (
            goto :input_framework
        ) else (
            goto :list_frameworks
        )
    )

    :: Convert to camel case and remove spaces
    for /f "delims=" %%a in ('pascal-case.bat !framework!') do (
        set "framework=%%a"
    )
    :framework_input_end
    ::#endregion Framework input

    ::#region Framework input and list
    if "!framework!"=="" (
        if "!is_frameworks_path_empty!"=="true" (
            goto :framework_input_start
        )
    )

    if "!framework!"=="" (
        if "!is_frameworks_path_empty!"=="false" (
            :: List the frameworks with indexes
            :list_frameworks
            echo 0. New Framework
            set "index=0"
            for /f "tokens=*" %%i in ('dir /b /ad "!lang_frames_path!" 2^>null') do (
                set /a "index+=1"
                echo !index!. %%i
            )
            echo.

            :: Prompt for the framework index
            set "choice="
            set /p "choice=Input the index of the framework you want to select: "

            if "!choice!"=="0" (
                goto :framework_input_start
            ) else if "!choice!" GEQ "1" (
                :: Find the corresponding framework
                set "current_index=0"
                for /f "tokens=*" %%i in ('dir /b /ad "!lang_frames_path!" 2^>null') do (        
                    set /a "current_index+=1"
                    if "!current_index!"=="!choice!" (
                        set "framework=%%i"
                        goto :end_corresponding_framework
                    )
                )
            )

            goto :list_frameworks
        )   
    )

    :end_corresponding_framework
    ::#endregion Framework input and list

    :: Echo the selected framework
    if not defined framework (
        echo Invalid framework index. Please enter a valid index.
        echo.
        goto :input_framework
    ) 
    ::#endregion Project


::#endregion Get Inputs


:: clear console
cls



:: Handle project
::#region
set "project_path=%projects_path%\!project_name!"
set "sub_project_path=%project_path%\%sub_project_name%"

if not exist "%sub_project_path%" (
    md "%sub_project_path%"

    echo Project directory created.
    echo.
) else (
    echo Project directory already exists.
    echo.
)
::#endregion

:: Handle organization
::#region
set "organization_path=%organizations_path%\%organization_name%"
set "organization_project_path=%organization_path%\!project_name!"

if not exist "%organization_project_path%" (

    if not exist "%organization_path%" (
        md "%organization_path%"
    )

    mklink /D "%organization_project_path%" "%project_path%"

    echo Project linked to organization.
    echo.
) else (
    echo Project already linked to organization.
    echo.
)
::#endregion

:: Handle platform
::#region
set "platform_path=%platforms_path%\%platform%"
set "platform_project_path=%platform_path%\%sub_project_name%"

if not exist "%platform_project_path%" (
    
    if not exist "!platform_path!" (
        md "!platform_path!"
    )
    
    mklink /D "%platform_project_path%" "%sub_project_path%"

    echo Sub-project linked to platform.
    echo.
) else (
    echo Sub-project already linked to platform.
    echo.
)
::#endregion

:: Handle language
::#region
set "language_path=%languages_path%\%language%"
set "language_project_path=%language_path%\%sub_project_name%"

if not exist "%language_project_path%" (

    if not exist "%language_path%" (
        md "%language_path%"
    )

    mklink /D "%language_project_path%" "%sub_project_path%"

    echo Sub-project linked to language.
    echo.
) else (
    echo Sub-project already linked to language.
    echo.
)

if /i "!language!"=="php" (
    for /d %%i in (C:\xampp* ) do (
        echo dir %%i
        if exist "%%i\htdocs" (
            mklink /D "%%i\htdocs\!sub_project_name!" "%sub_project_path%"
            echo Project linked to %%i.
        )
    )
    echo.
)
::#endregion

:: Handle framework
::#region
set "framework_path=%frameworks_path%\%framework%"
set "framework_project_path=%framework_path%\%sub_project_name%"

if not exist "%framework_project_path%" (

    if not exist "%framework_path%" (
        md "%framework_path%"
    )

    mklink /D "%framework_project_path%" "%sub_project_path%"

    echo Sub-project linked to framework.
    echo.
) else (
    echo Sub-project already linked to framework.
    echo.
)
::#endregion

:: Handle language/framework
::#region
set "lang_frame_path=%lang_frames_path%\%framework%"
set "lang_frame_project_path=%lang_frame_path%\%sub_project_name%"

if not exist "%lang_frame_project_path%" (

    if not exist "%lang_frame_path%" (
        md "%lang_frame_path%"
    )

    mklink /D "%lang_frame_project_path%" "%sub_project_path%"

    echo Sub-project linked to lang-frame.
    echo.
) else (
    echo Sub-project already linked to lang-frame.
    echo.
)
::#endregion


echo "Project setup completed."
echo.
pause