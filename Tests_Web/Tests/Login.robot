*** Settings ***
Resource         ../Resources/Settings.robot

Test Setup       CustomerService.Prepare Test Setup
Task Teardown    Close Browser

*** Test Cases ***
TC_UI_001_Valid Credentials Shows Dashboard
    [Tags]    TC_UI_001    smoke    regression    positive    functional    ui    login    e2e
    LoginPage.Open Login Page
    LoginPage.Enter Email        ${EMAIL_VALID}
    LoginPage.Enter Password     ${PASSWORD_VALID}
    LoginPage.Ensure 'Remember Me' Is Settable
    LoginPage.Click Submit
    DashboardPage.Verify Dashboard Page Loaded

TC_UI_002_Invalid Login Does Not Show Dashboard
    [Tags]    TC_UI_002    regression    negative    functional    ui    login
    LoginPage.Open Login Page
    LoginPage.Enter Email        ${EMAIL_INVALID}
    LoginPage.Enter Password     ${PASSWORD_VALID}
    LoginPage.Ensure 'Remember Me' Is Settable
    LoginPage.Click Submit
    DashboardPage.Verify Dashboard Page Not Loaded

TC_UI_003_Invalid Password Does Not Show Dashboard
    [Tags]    TC_UI_003    regression    negative    functional    ui    login
    LoginPage.Open Login Page
    LoginPage.Enter Email        ${EMAIL_VALID}
    LoginPage.Enter Password     ${PASSWORD_INVALID}
    LoginPage.Ensure 'Remember Me' Is Settable
    LoginPage.Click Submit
    DashboardPage.Verify Dashboard Page Not Loaded

TC_UI_004 - Login With Valid Email But Empty Password
    [Tags]    TC_UI_004    edge    negative    functional    ui    regression
    LoginPage.Open Login Page
    LoginPage.Enter Email        ${EMAIL_VALID}
    # Skip entering password
    LoginPage.Ensure 'Remember Me' Is Settable
    LoginPage.Click Submit
    DashboardPage.Verify Dashboard Page Not Loaded
    LoginPage.Enrure Login Page Is Loaded
    
TC_UI_005 - Login With Empty Email And Valid Password
    [Tags]    TC_UI_005    edge    negative    functional    ui    regression
    LoginPage.Open Login Page
    # Skip entering email
    LoginPage.Enter Password     ${PASSWORD_VALID}
    LoginPage.Ensure 'Remember Me' Is Settable
    LoginPage.Click Submit
    DashboardPage.Verify Dashboard Page Not Loaded
    LoginPage.Enrure Login Page Is Loaded

TC_UI_006 - Login With Overly Long Password
    [Tags]    TC_UI_006    boundary    negative    functional    ui    regression
    LoginPage.Open Login Page
    LoginPage.Enter Email        ${EMAIL_VALID}
    LoginPage.Enter Password     ${PASSWORD_LONG}
    LoginPage.Ensure 'Remember Me' Is Settable
    LoginPage.Click Submit
    LoginPage.Enrure HTTP Error Page Is Loaded

TC_UI_007 - Login With Overly Long Email
    [Tags]    TC_UI_007    boundary    negative    functional    ui    regression
    LoginPage.Open Login Page
    LoginPage.Enter Email        ${EMAIL_LONG}
    LoginPage.Enter Password     ${PASSWORD_VALID}
    LoginPage.Ensure 'Remember Me' Is Settable
    LoginPage.Click Submit
    LoginPage.Enrure HTTP Error Page Is Loaded
