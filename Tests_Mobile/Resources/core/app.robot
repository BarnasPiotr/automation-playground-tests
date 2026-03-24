*** Settings ***
Library        AppiumLibrary
Resource       ./variables.robot

*** Keywords ***
SetUp
    Log To Console    Starting Appium session
    Open Application    ${REMOTE}
    ...    platformName=Android
    ...    automationName=UiAutomator2
    ...    deviceName=${DEVICE_NAME}
    ...    appPackage=${PKG}
    ...    appActivity=${ACT}
    Wait Until Page Contains Element    ${FAB_ADD}
    Log To Console    App ready

TearDown
    Log To Console    Closing Appium session
    Close Application
