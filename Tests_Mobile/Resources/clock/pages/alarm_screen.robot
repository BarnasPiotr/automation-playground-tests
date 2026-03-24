*** Settings ***
Library             BuiltIn
Library             AppiumLibrary
Library             String
Library             Collections
Library    ../../core/python/time_utils.py

*** Variables ***
# Alarm buttons
${BUTTON_FLOATING_ACTION}        id=com.google.android.deskclock:id/fab
${BUTTON_TAB_ALARM}              id=com.google.android.deskclock:id/tab_menu_alarm

# Tab Alarm
${TAB_ALARM}              //android.widget.TextView[contains(@text, "Alarm")]

# Alarm card components
${ALARM_CARD}             //android.view.ViewGroup[@resource-id='com.google.android.deskclock:id/alarm_card_layout']
${ALARM_LABEL}            //android.widget.TextView[@resource-id='com.google.android.deskclock:id/edit_label']
${ALARM_TOGGLE}           //android.widget.Switch[@resource-id='com.google.android.deskclock:id/onoff']
${ALARM_CLOCK_TEXT}       //android.widget.TextView[@resource-id='com.google.android.deskclock:id/digital_clock']

# Dialogs / pickers
${LABEL_INPUT_FIELD}      id=com.google.android.deskclock:id/label_input_field
${TIMEPICKER_OK_BTN}      id=com.google.android.deskclock:id/material_timepicker_ok_button


*** Keywords ***
Navigate To Alarm Tab
    Click Element    ${BUTTON_TAB_ALARM}
    Wait Until Element Is Visible    ${TAB_ALARM}    1s
    Log To Console    🕓 Alarm screen loaded successfully

Tap Add Alarm
    Wait Until Element Is Visible    ${TAB_ALARM}    1s
    Wait Until Element Is Visible    ${BUTTON_FLOATING_ACTION}   1s
    Click Element    ${BUTTON_FLOATING_ACTION}
    Sleep    1s

Set Alarm Time
    [Arguments]    ${time}
    [Documentation]    Sets the alarm time (HH:MM AM/PM) on Material TimePicker and verifies selection.

    # --- Parse time ---
    ${parts}=    Split String    ${time}    ${SPACE}
    ${hour_min}=    Set Variable    ${parts}[0]
    ${period}=      Set Variable    ${parts}[1]
    ${hour}=        Split String    ${hour_min}    :
    ${hour_val}=    Set Variable    ${hour}[0]
    ${minute_val}=  Set Variable    ${hour}[1]

 # --- Select hour (always click to switch to minute dial) ---
    ${hour_xpath}=    Set Variable    //android.widget.TextView[@content-desc="${hour_val} o'clock"]
    Wait Until Element Is Visible    ${hour_xpath}    1s
    Click Element    ${hour_xpath}
    Log To Console    Clicked hour ${hour_val} to open minute dial
    Sleep    0.8s
    
    # --- Select minutes ---
    ${minute_xpath}=    Set Variable    //android.widget.TextView[@content-desc="${minute_val} minutes"]
    Wait Until Element Is Visible    ${minute_xpath}    1s
    Click Element    ${minute_xpath}
    Log To Console    Minutes ${minute_val} selected
    Sleep    0.5s

    # --- Select AM/PM ---
    ${am_xpath}=    Set Variable    //android.widget.RadioButton[@resource-id="com.google.android.deskclock:id/material_clock_period_am_button"]
    ${pm_xpath}=    Set Variable    //android.widget.RadioButton[@resource-id="com.google.android.deskclock:id/material_clock_period_pm_button"]
    Run Keyword If    '${period}'=='AM'    Click Element    ${am_xpath}
    ...    ELSE    Click Element    ${pm_xpath}
    Log To Console    Period ${period} selected
    Sleep    0.5s

    # --- Validate hour/minute/period fields ---
    ${hour_text}=    Get Element Attribute    id=com.google.android.deskclock:id/material_hour_tv    text
    ${minute_text}=  Get Element Attribute    id=com.google.android.deskclock:id/material_minute_tv    text
    Log To Console    Validation: ${hour_text}:${minute_text} ${period}
        # --- Add 0 at front, if needed
    ${hour_val}=     Evaluate    f"{int(${hour_val}):02d}"
    ${minute_val}=   Evaluate    f"{int(${minute_val}):02d}"
    Should Be Equal As Strings    ${hour_text}    ${hour_val}
    Should Be Equal As Strings    ${minute_text}  ${minute_val}

    # --- Confirm time ---
    ${ok_btn}=    Set Variable    //android.widget.Button[@resource-id="com.google.android.deskclock:id/material_timepicker_ok_button"]
    Wait Until Element Is Visible    ${ok_btn}    1s
    Click Element    ${ok_btn}

    # --- Verify picker closed and container with given time is created ---
    Wait Until Page Does Not Contain Element    ${ok_btn}    1s
    ${alarm_container}=    _Get Alarm Container By Label And Time    Today    ${time}
    Wait Until Element Is Visible    ${alarm_container}    1s

Create Unique Label
    ${label_base}=    Set Variable    Test Alarm-
    ${rand_suffix}=   Generate Random String    5    [LETTERS][NUMBERS]
    ${label}=         Catenate    SEPARATOR=    ${label_base}    ${rand_suffix}
    Log To Console    Label created: ${label}
    RETURN    ${label}

Set Alarm Label
    [Arguments]    ${label}
    Wait Until Element Is Visible    ${ALARM_LABEL}    1s
    Click Element    ${ALARM_LABEL}
    # 2️⃣ Poczekaj na pojawienie się pola edycji
    Wait Until Element Is Visible    ${LABEL_INPUT_FIELD}    1s
    # 3️⃣ Wyczyść istniejący tekst i wpisz nowy label
    Clear Text    ${LABEL_INPUT_FIELD}
    Input Text    ${LABEL_INPUT_FIELD}    ${label}
    # 4️⃣ Kliknij przycisk OK
    ${ok_button}=    Set Variable    //android.widget.Button[@text='OK']
    Wait Until Element Is Visible    ${ok_button}    3s
    Click Element    ${ok_button}
    Sleep    1s

Assert Alarm Enabled For Label
    [Arguments]    ${expected_label}    ${expected_time}    ${expected_state}=true
    Log To Console    🔍 Checking toggle for alarm label '${expected_label}', expecting state: ${expected_state}
    ${alarm_container}=    _Get Alarm Container By Label And Time    ${expected_label}    ${expected_time}
    ${toggle}=    Set Variable    ${alarm_container}//android.widget.Switch[@content-desc="${expected_time} alarm"]
    Wait Until Element Is Visible    ${toggle}    1s
    ${checked}=    Get Element Attribute    ${toggle}    checked
    Log To Console    🔎 Toggle checked=${checked}
    Should Be Equal As Strings    ${checked}    ${expected_state}

Open Alarm With Label And Time
    [Arguments]    ${expected_label}    ${expected_time}
    ${alarm_container}=    _Get Alarm Container By Label And Time    ${expected_label}    ${expected_time}
    Wait Until Element Is Visible    ${alarm_container}    1s
    Click Element    ${alarm_container}

Delete Alarm With Label And Time
    [Arguments]    ${expected_label}    ${expected_time}
    Open Alarm With Label And Time        ${expected_label}    ${expected_time}
    ${alarm_container}=    _Get Alarm Container By Label And Time    ${expected_label}    ${expected_time}
    #Wait Delete
    #Klik Delete
    #View alarm deleted
    #niech zrwoci FAILED    ${alarm_container}=    _Get Alarm Container By Label And Time    ${expected_label}    ${expected_time}




# ========================
# 🔒 Helper / Private Keywords
# ========================

_Get Alarm Container By Time
    [Arguments]    ${alarm_time}
    ${container}=    Catenate
    ...    //android.view.ViewGroup[@resource-id="com.google.android.deskclock:id/alarm_card_layout"
    ...    and .//android.widget.TextView[@content-desc="${alarm_time}"]]
    RETURN    ${container}

_Get Alarm Container By Label
    [Arguments]    ${alarm_label}
    ${container}=    Catenate
    ...    //android.view.ViewGroup[@resource-id="com.google.android.deskclock:id/alarm_card_layout"
    ...    and .//android.widget.TextView[@resource-id="com.google.android.deskclock:id/upcoming_instance_label" and @text="${alarm_label}"]]
    RETURN    ${container}

_Get Alarm Container By Label And Time
    [Arguments]    ${alarm_label}    ${alarm_time}
    ${hour_part}=    Evaluate    "${alarm_time}".split(":")[0]
    ${container}=    Catenate
    ...    //androidx.cardview.widget.CardView[
    ...        contains(@content-desc,"${hour_part}:")
    ...        and contains(@content-desc,"Alarm")
    ...        and .//android.widget.TextView[@resource-id="com.google.android.deskclock:id/upcoming_instance_label" and @text="${alarm_label}"]
    ...    ]
    [Return]    ${container}

_Normalize Time String
    [Arguments]    ${time}
    ${normalized}=    Evaluate    re.sub(r'[\u2000-\u200A\u202F\u205F\u00A0]', '', """${time}""")    re
    ${normalized}=    Evaluate    "${normalized}".replace(' ', '')    
    [Return]    ${normalized}
