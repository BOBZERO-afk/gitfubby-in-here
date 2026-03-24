@echo off
set webhook=mamma
for /f "usebackq delims=" %%A in ("outmain.txt") do (
    curl -X POST -H "Content-type: application/json" --data "{\"content\": \"%%A\"}" %webhook%
)
exit /b 0