*** Settings ***
Documentation      Clock app keywords
Library            BuiltIn
Library            AppiumLibrary
Library            Process

Resource           ../core/variables.robot
Resource           ./pages/time_keywords.robot
Resource           ./pages/alarm_screen.robot


*** Keywords ***
Open Clock App
    [Documentation]    Opens the Clock app reliably (even if closed or backgrounded).
    Run Process    adb    shell    am start -n ${PKG}/${ACT}
    Sleep    2s
    Open Application
    ...    ${REMOTE}
    ...    platformName=Android
    ...    automationName=UiAutomator2
    ...    deviceName=${DEVICE_NAME}
    ...    appPackage=${PKG}
    ...    appActivity=${ACT}
    ...    appWaitActivity=*.DeskClock
    ...    noReset=true
    ...    dontStopAppOnReset=true
    ...    newCommandTimeout=${TIMEOUT}
    Sleep    1s
    Log To Console    ✅ Clock app launched and Appium attached


Close Clock App
    [Documentation]    Closes the Clock app forcefully.
    Run Process    adb    shell    am force-stop ${PKG}
    Log To Console    🛑 Clock app closed (force-stop)
