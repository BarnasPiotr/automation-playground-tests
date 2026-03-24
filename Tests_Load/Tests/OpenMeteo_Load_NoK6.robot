*** Settings ***
Documentation     Simulates multiple users sequentially sending API requests to Open-Meteo and logs response times.
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           DateTime
Library           String

Suite Setup       Setup Environment
Suite Teardown    Log Load Summary

*** Variables ***
${USERS}          5
${REQ_PER_USER}   10
${LAT}            60.17
${LON}            24.94
${CSV_FILE}       Results/API/load_perf_metrics.csv


*** Keywords ***
Setup Environment
    [Documentation]    Initializes environment, disables SSL warnings and creates API session
    Disable SSL Warnings
    Create Session    weather    https://api.open-meteo.com/v1/forecast    verify=False
    ${ALL_TIMES}=    Create List
    Set Suite Variable    ${ALL_TIMES}

Disable SSL Warnings
    Evaluate    __import__('urllib3').disable_warnings(__import__('urllib3').exceptions.InsecureRequestWarning)

Send Weather Request
    ${params}=    Create Dictionary    latitude=${LAT}    longitude=${LON}    current_weather=true
    ${start}=     Get Time    epoch
    ${resp}=      GET On Session    weather    url=/    params=${params}
    ${end}=       Get Time    epoch
    ${elapsed}=   Evaluate    ${end}-${start}
    Should Be Equal As Integers    ${resp.status_code}    200
    Append To List    ${ALL_TIMES}    ${elapsed}
    RETURN    ${elapsed}

User Session
    [Arguments]    ${user_id}
    Log To Console    👤 User ${user_id} starting (${REQ_PER_USER} requests)
    FOR    ${i}    IN RANGE    ${REQ_PER_USER}
        ${elapsed}=    Send Weather Request
        #Log To Console    User ${user_id} - Request ${i}: ${elapsed}s
    END
    Log To Console    👤 User ${user_id} done (${REQ_PER_USER} requests)

Log Load Summary
    ${min}=    Evaluate    min(@{ALL_TIMES})    modules=statistics
    ${max}=    Evaluate    max(@{ALL_TIMES})    modules=statistics
    ${avg}=    Evaluate    sum(@{ALL_TIMES}) / len(@{ALL_TIMES})    modules=statistics

    Log To Console    \n--- LOAD TEST SUMMARY ---
    Log To Console    Users: ${USERS} | Requests per user: ${REQ_PER_USER}
    Log To Console    Min: ${min}s | Max: ${max}s | Avg: ${avg}s
    Log To Console    -----------------------------

    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${header}=       Create List    timestamp    users    req_per_user    min    max    avg
    ${row}=          Create List    ${timestamp}    ${USERS}    ${REQ_PER_USER}    ${min}    ${max}    ${avg}

    ${file_exists}=    Evaluate    os.path.exists("${CSV_FILE}")    modules=os
    Run Keyword If    not ${file_exists}    Create File    ${CSV_FILE}    ${header}[0],${header}[1],${header}[2],${header}[3],${header}[4],${header}[5]\n



*** Test Cases ***
Simulate Multi-User Load On OpenMeteo
    [Documentation]    Simulates ${USERS} users sequentially sending ${REQ_PER_USER} requests each.
    FOR    ${user_id}    IN RANGE    ${USERS}
        User Session    ${user_id}
    END
