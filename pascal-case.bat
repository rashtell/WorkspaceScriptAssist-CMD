@echo off

setlocal enabledelayedexpansion

@REM set /p "input_string="
set "input_string=%*"

:: Check if the first argument is "/s" and set a flag
set exclude_s=0
if "%~1"=="/s" (
    set exclude_s=1
    shift
    set "input_string=!input_string:~2!"
)

:: Initialize the CamelCase result
set "camel_case="

:: Split the input string by spaces and capitalize the first letter of each word
for %%i in (!input_string!) do (
    set "word=%%i"
    set "first_letter=!word:~0,1!"
    set "rest_of_word=!word:~1!"

    :: Use the inner loop to convert the first letter to uppercase
    for %%a in ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I"
            "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R"
            "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") do (
        call set "first_letter=%%first_letter:%%~a%%"
    )

    :: Optionally convert the rest of the word to lowercase
    if !exclude_s!==1 (
        for %%a in ( "A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" 
                "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" 
                "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") do (
            call set "rest_of_word=%%rest_of_word:%%~a%%"
        )
    )

    set "camel_case=!camel_case!!first_letter!!rest_of_word!"
)

:: Display the CamelCase result
echo %camel_case%

endlocal
