*** Settings ***
Library    Process
Library    OperatingSystem

*** Variables ***
${K6_SCRIPT}      Tests_Load/Resources/OpenMeteo_K6.js
${OUTPUT_JSON}    Results/Load/OpenMeteo_K6.json
${VUS}            15
${DURATION}       10s
${INFLUX_URL}     http://localhost:8086/k6db
${GRAFANA_URL}    http://localhost:3000/d/129c6543-debd-4a39-965f-093a67222207/k6-load-testing-results

*** Test Cases ***
Run K6 Load Test For OpenMeteo
    [Documentation]    Runs K6 with configurable parameters and stores results.

    # --- przygotuj katalog ---
    IF    not os.path.exists("Results/Load")
        Create Directory    Results/Load
    END

    # --- zbuduj komendę ---
    ${cmd}=    Set Variable
    ...    k6 run --out influxdb=${INFLUX_URL} --out json=${OUTPUT_JSON} -e VUS=${VUS} -e DURATION=${DURATION} ${K6_SCRIPT}

    Log To Console    \n🚀 Running: ${cmd}

    # --- uruchom K6 ---
    ${result}=    Run Process    ${cmd}    shell=True    stdout=PIPE    stderr=PIPE

    # --- sprawdź status ---
    IF    ${result.rc} == 0
        Log To Console    ✅ All thresholds within limits (Green)
    ELSE IF    ${result.rc} == 99
        Log To Console    ⚠️ Performance thresholds exceeded (Yellow/Red)
    ELSE
        Fail    ❌ K6 process failed! Exit code: ${result.rc}\n${result.stderr}
    END

    # --- loguj dane ---
    Log To Console    \n\n===== K6 OUTPUT =====
    Log To Console    ${result.stdout}
    Log To Console    \n\n===== K6 ERROR =====
    Log To Console    ${result.stderr}
    Log To Console    \n\n======================
    Log To Console    ✅ K6 load test finished successfully.\n
    Log To Console    📊 Grafana dashboard: \n${GRAFANA_URL}\n\n

    # --- zapisz link ---
    Append To File    Results/Load/last_grafana_link.txt    ${GRAFANA_URL}\n\n\n
