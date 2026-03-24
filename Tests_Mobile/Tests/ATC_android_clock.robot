*** Settings ***
Library             BuiltIn
Library             AppiumLibrary

Resource            ../Resources/core/app.robot
Resource            ../Resources/clock/clock.robot
Resource            ../Resources/clock/pages/alarm_screen.robot


Suite Setup         Log To Console    \n Starting Android Clock test suite...
Suite Teardown      Log To Console    \n Test suite finished.
Test Setup          Open Clock App
Test Teardown       Close Clock App


*** Test Cases ***
Add New Alarm (Clock)
    [Documentation]    Adds a new alarm to the clock app and verifies its visibility.
    [Tags]    E2E    UI    Clock    Sanity    Requirement_01
    Log To Console    Test start
    ${label}=    alarm_screen.Create Unique Label
    ${time}=     Get Next Full Hour
    ${time_12h}=    Convert To 12h    ${time}
    alarm_screen.Navigate To Alarm Tab
    alarm_screen.Tap Add Alarm
    alarm_screen.Set Alarm Time    ${time_12h}
    alarm_screen.Open Alarm With Label And Time    Today    ${time_12h}

    alarm_screen.Set Alarm Label    ${label}
    alarm_screen.Assert Alarm Enabled For Label    ${label}    ${time_12h}
    #alarm_screen.Delete Alarm With Label    ${label}

Toggle Existing Alarm
    [Documentation]    Add here ....
    [Tags]    e2e    ui    clock    regression    requirement_02
    Wait Until Page Contains Element    ${ALARM_SWITCH}    5s
    Click Element    ${ALARM_SWITCH}
    Sleep    1s
    Click Element    ${ALARM_SWITCH}
    Log    Alarm toggled on/off successfully


Delete All Alarms
    [Documentation]    Add here ....
    [Tags]    e2e    ui    clock    regression    requirement_03
    Wait Until Page Contains Element    ${ALARM_CARD}    5s
    # Long Press Element    ${ALARM_CARD}
    Click Element    ${DELETE_BTN}
    Click Element    ${CONFIRM_BTN}
    Sleep    1s
    Log    All alarms deleted successfully


Measure App Launch Performance
    [Documentation]    Add here ....
    [Tags]    e2e    performance    clock    requirement_04
    ${start}=    Get Current Time
    Open Clock App
    Wait Until Page Contains Element    ${FAB_ADD}    5s
    ${end}=    Get Current Time
    ${elapsed}=    Evaluate    ${end} - ${start}
    Log    App launch time: ${elapsed} seconds
