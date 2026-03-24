*** Settings ***
Resource     Settings.robot
Resource     LoginPage.robot

*** Variables ***
${DASHBOARD_PAGE_HEAD} =        Customers
${DASHBOARD_HEADER} =          //h2[text()="Our Happy Customers"]

*** Keywords ***
Verify Dashboard Page Loaded
    Should Be Title Case        ${DASHBOARD_PAGE_HEAD}
    Wait For Elements State     ${DASHBOARD_HEADER}    visible    timeout=5s

Verify Dashboard Page Not Loaded
    Wait For Elements State     ${LOGIN_HEADER}    visible    timeout=1s
    Should Be Title Case        ${LOADING_PAGE_HEAD}
    Run Keyword And Expect Error    *    Run Keywords
    ...    Should Be Title Case    ${DASHBOARD_PAGE_HEAD}
    ...    AND    Wait For Elements State    ${DASHBOARD_HEADER}    visible    timeout=3s
