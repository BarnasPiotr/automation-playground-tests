*** Settings ***
Resource   ../Resources/Settings.robot

*** Variables ***
${BASE_URL}    https://api.open-meteo.com/v1/forecast
${LAT}         60.17
${LON}         24.94

*** Test Cases ***
Get Current Weather For Helsinki
    [Documentation]    Pobiera dane pogodowe i waliduje strukturę JSON.
    Create Session    weather    ${BASE_URL}    verify=False

    ${params}=    Create Dictionary    latitude=${LAT}    longitude=${LON}    current_weather=true
    ${resp}=      GET On Session    weather    url=/    params=${params}
    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=      Set Variable    ${resp.json()}

    Dictionary Should Contain Key    ${json}    current_weather
    Dictionary Should Contain Key    ${json["current_weather"]}    temperature

    Log To Console    ✅ Temperatura w Helsinkach: ${json["current_weather"]["temperature"]}°C
