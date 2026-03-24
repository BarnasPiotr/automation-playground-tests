*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    DateTime

Suite Setup       Setup Environment
Suite Teardown    Log Summary

*** Variables ***
${LAT}           60.17
${LON}           24.94
${REQ_COUNT}     10
${CSV_FILE}      ${EXECDIR}/Results/API/perf_metrics.csv
@{RESPONSE_TIMES}

*** Keywords ***
Setup Environment
    Disable SSL Warnings
    Create Session    weather    https://api.open-meteo.com/v1/forecast    verify=False

Disable SSL Warnings
    Evaluate    __import__('urllib3').disable_warnings(__import__('urllib3').exceptions.InsecureRequestWarning)

Send Weather Request
    [Arguments]    ${i}
    ${params}=    Create Dictionary    latitude=${LAT}    longitude=${LON}    current_weather=true
    ${start}=     Evaluate    __import__('time').time()
    ${resp}=      GET On Session    weather    url=/    params=${params}
    ${end}=       Evaluate    __import__('time').time()
    ${elapsed}=   Evaluate    ${end} - ${start}
    Append To List    ${RESPONSE_TIMES}    ${elapsed}
    Should Be Equal As Integers    ${resp.status_code}    200
    Log To Console    ${i}: Response time ${elapsed}s

Log Summary
    ${count}=    Get Length    ${RESPONSE_TIMES}
    IF    ${count} == 0
        Log To Console    ⚠️ No responses recorded — check API connection.
        Log    ⚠️ No responses recorded — check API connection.    console=False
        RETURN
    END

    ${min}=    Evaluate    min(${RESPONSE_TIMES})    modules=statistics
    ${max}=    Evaluate    max(${RESPONSE_TIMES})    modules=statistics
    ${avg}=    Evaluate    sum(${RESPONSE_TIMES}) / len(${RESPONSE_TIMES})    modules=statistics

    Log To Console    \n--- PERFORMANCE SUMMARY ---
    Log To Console    Requests: ${REQ_COUNT}
    Log To Console    Min: ${min}s | Max: ${max}s | Avg: ${avg}s
    Log To Console    ------------------------------

    # Dodatkowo zapisujemy do raportu HTML
    ${summary}=    Catenate
    ...    \n--- PERFORMANCE SUMMARY ---
    ...    \nRequests: ${REQ_COUNT}
    ...    \nMin: ${min}s | Max: ${max}s | Avg: ${avg}s
    ...    \n------------------------------
    Log    ${summary}    level=INFO

    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${header}=    Create List    Timestamp    Total_Requests    Min    Max    Avg
    ${row}=       Create List    ${timestamp}    ${REQ_COUNT}    ${min}    ${max}    ${avg}

    Run Keyword And Ignore Error    Create File    ${CSV_FILE}
    Append To File    ${CSV_FILE}    ${header}[0],${header}[1],${header}[2],${header}[3],${header}[4]\n
    Append To File    ${CSV_FILE}    ${row}[0],${row}[1],${row}[2],${row}[3],${row}[4]\n


*** Test Cases ***
Simulate High Load On OpenMeteo
    [Documentation]    Sends ${REQ_COUNT} sequential API requests and records response times.
    FOR    ${i}    IN RANGE    ${REQ_COUNT}
        Send Weather Request    ${i}
    END

