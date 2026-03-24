*** Settings ***
Library            BuiltIn
Library            AppiumLibrary
Library             String
Library            ../../core/python/time_utils.py

*** Keywords ***
Get Next Full Hour
    [Documentation]    Returns next full hour + random 5-minute step (e.g. 14:20 / 14:25 if current time is 13:37)
    ${base_time}=    Get Two Hour From Now Raw
    ${random_minutes}=    Evaluate    random.choice(range(0, 60, 10))    random
    ${result}=    Add Minutes To Time Raw    ${base_time}    ${random_minutes}
    RETURN    ${result}

Get Current Time
    [Documentation]    Returns current system time in HH:MM format
    ${now}=    Get Current Time Raw
    RETURN    ${now}

Get Time Plus Minutes
    [Documentation]    Adds given number of minutes to provided time string (HH:MM)
    [Arguments]    ${time}    ${minutes}
    ${result}=    Add Minutes To Time Raw    ${time}    ${minutes}
    RETURN    ${result}

Convert To 12h
    [Documentation]    Converts 24h time string (HH:MM) to 12h format with zero-padding (e.g. 14:30 → 02:30 PM)
    [Arguments]    ${time_24h}
    ${time_12h}=    Convert To 12h Raw    ${time_24h}
    RETURN           ${time_12h}
