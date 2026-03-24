*** Settings ***
Resource     Settings.robot

*** Variables ***

# paths
${LOGIN_HEADER} =         //section[@id='loginform']//h2[text()='Login']
${LOADING_PAGE_HEAD} =    Customer Service - Login
${TEXT_FIELD_EMAIL} =     //*[@id="email-id"]
${TEXT_FIELD_PASSWORD} =  //*[@id="password"] 
${CHECKBOX_REMEMBER} =    //*[@id="remember"]
${BUTTON_SUBMIT} =        //*[@id="submit-id"]

${ERROR_PAGE_HEAD} =      IIS 10.0 Detailed Error - 404.15 - Not Found
${ERROR_HEADING} =        //h3[contains(text(), 'HTTP Error 404.15 - Not Found')]
${ERROR_CAUSE_ITEM} =     //fieldset[*[contains(text(), 'Most likely causes:')]]//li[contains(text(), 'query string is too long')]

# test data
${EMAIL_VALID}          NONE
${PASSWORD_VALID}       NONE
${EMAIL_INVALID}        NONE
${EMAIL_LONG}           NONE
${PASSWORD_INVALID}     NONE
${PASSWORD_LONG}        NONE

&{DICTIONARY_VALID_EMAILS} =
...            email_1=valid@example.com
...            email_2=john.doe@domain.org
...            email_3=TEST@CAPS.com
...            email_4=user.name+tag@sub.domain.com
...            email_5=u5eR.NAM3+tag@sub.domain.com
...            email_6=g@n.com

&{DICTIONARY_INVALID_EMAILS} =      
...            email_1=user#example.com
...            email_2=@domain.com
...            email_3=invalid@
...            email_4=DIascasascil.com
...            email_4=r r@domain.com

&{DICTIONARY_VALID_PASSWORDS} =     
...            pass_1=SuperSecret123
...            pass_2=P@ssw0rd!
...            pass_3=abcABC123.
...            pass_4=123456Aa.
...            pass_5=1a.

&{DICTIONARY_INVALID_PASSWORDS} =   
...            pass_1=${EMPTY}
...            pass_2='OR '1'='1
...            pass_3= 
...            pass_4=pass with spaces

*** Keywords ***
Open Login Page
    Click    ${SIGN_IN}
    Enrure Login Page Is Loaded

Enrure Login Page Is Loaded
    Wait For Elements State     ${LOGIN_HEADER}    visible    timeout=5s    
    Should Be Title Case        ${LOADING_PAGE_HEAD}

Enrure HTTP Error Page Is Loaded
    Wait For Elements State     ${ERROR_HEADING}    visible    timeout=5s    
    Wait For Elements State     ${ERROR_CAUSE_ITEM}    visible    timeout=5s    
    Should Be Title Case        ${LOADING_PAGE_HEAD}

Enter Email
    [Arguments]    ${GIVEN_EMAIL}
    Fill Text    ${TEXT_FIELD_EMAIL}    ${GIVEN_EMAIL}

Enter Password
    [Arguments]    ${GIVEN_PASSWORD}
    Fill Text    ${TEXT_FIELD_PASSWORD}    ${GIVEN_PASSWORD}

Ensure 'Remember Me' Is Settable
    ${state}=    Get Checkbox State    ${CHECKBOX_REMEMBER}
    Should Not Be True    ${state}

    ${random}=    Evaluate    random.randint(0, 1)    random
    IF    ${random} == 1
        Check Checkbox    ${CHECKBOX_REMEMBER}
        ${new_state}=    Get Checkbox State    ${CHECKBOX_REMEMBER}
        Should Be True    ${new_state}
    END

Click Submit
    Click    ${BUTTON_SUBMIT}

Set Random Valid Email
    ${keys}=    Get Dictionary Keys    ${DICTIONARY_VALID_EMAILS}
    ${rand_key}=      Evaluate    random.choice(${keys})    random
    ${value}=    Get From Dictionary    ${DICTIONARY_VALID_EMAILS}    ${rand_key}
    Set Test Variable    ${EMAIL_VALID}    ${value}

Set Random Invalid Email
    ${keys}=    Get Dictionary Keys    ${DICTIONARY_INVALID_EMAILS}
    ${rand_key}=      Evaluate    random.choice(${keys})    random
    ${value}=         Get From Dictionary    ${DICTIONARY_INVALID_EMAILS}    ${rand_key}
    Set Test Variable    ${EMAIL_INVALID}    ${value}

Set Random Long Email
    ${chars}=    Set Variable    abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
    ${username}=    Set Variable    ${EMPTY}
    FOR    ${i}    IN RANGE    2000
        ${char}=    Evaluate    random.choice('${chars}')    modules=random
        ${username}=    Set Variable    ${username}${char}
    END
    ${email}=    Set Variable    ${username}@gmail.com
    Set Test Variable    ${EMAIL_LONG}    ${email}

Set Random Valid Password
    ${keys}=    Get Dictionary Keys    ${DICTIONARY_VALID_PASSWORDS}
    ${rand_key}=      Evaluate    random.choice(${keys})    random
    ${value}=         Get From Dictionary    ${DICTIONARY_VALID_PASSWORDS}    ${rand_key}
    Set Test Variable    ${PASSWORD_VALID}    ${value}

Set Random Invalid Password
    ${keys}=    Get Dictionary Keys    ${DICTIONARY_INVALID_PASSWORDS}
    ${rand_key}=      Evaluate    random.choice(${keys})    random
    ${value}=         Get From Dictionary    ${DICTIONARY_INVALID_PASSWORDS}    ${rand_key}
    Set Test Variable    ${PASSWORD_INVALID}    ${value}

Set Random Long Password
    ${chars}=    Set Variable    abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()
    ${password}=    Set Variable    ${EMPTY}
    FOR    ${i}    IN RANGE    2000
        ${char}=    Evaluate    random.choice('${chars}')    modules=random
        ${password}=    Set Variable    ${password}${char}
    END
    Set Test Variable    ${PASSWORD_LONG}    ${password}




