*** Settings ***
Resource    Settings.robot
Resource    LoginPage.robot

*** Variables ***    
${HEADLESS_STATUS} =            true    #IMPORTANT: Change to true, pushing to master (GitHub Actions must have true, to work)   

${CUSTOMER_SERVICE_HEAD} =      Customer Service
${LOGIN_URL} =                  https://www.automationplayground.com/crm/
${SIGN_IN} =                    //a[contains(text(), 'Sign In')]

*** Keywords ***
Prepare Test Setup
    Prepare Used Data
    Open Playground Browser

Prepare Used Data
    LoginPage.Set Random Valid Email
    LoginPage.Set Random Invalid Email
    LoginPage.Set Random Long Email
    LoginPage.Set Random Valid Password
    LoginPage.Set Random Invalid Password
    LoginPage.Set Random Long Password

Open Playground Browser
    New Browser             headless=${HEADLESS_STATUS}
    New Page                ${LOGIN_URL}
    Should Be Title Case    ${CUSTOMER_SERVICE_HEAD}