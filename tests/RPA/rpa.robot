*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${URL}    https://emerging-ghastly-urchin.ngrok-free.app/
${BROWSER}    Chrome

*** Test Cases ***
CP001 - Inicio de sesión en eShopOnWeb con credenciales no válidas
    Start_Browser
    Go_Login
    Login    demousermicrosoft.com    Pass@word1
    Start_Browser
    Go_Login
    Login    admin@microsoft.com    pass@word1

CP002 - Inicio de sesión en eShopOnWeb con credenciales válidas
    Start_Browser
    Go_Login
    Login    demouser@microsoft.com    Pass@word1
    Start_Browser
    Go_Login
    Login    admin@microsoft.com    Pass@word1

CP003 - Comprar X unidades de un producto sin tener la sesión iniciada
    Start_Browser
    Add_Product    css=input.esh-catalog-button[type='submit']    4
    Checkout

CP004 - Comprar X unidades de un producto filtrando por la marca Y teniendo que iniciar sesion
    Start_Browser
    Filter    2
    Add_Product    css=input.esh-catalog-button[type='submit']    4
    Checkout
    Login    admin@microsoft.com    Pass@word1
    Pay

CP005 - Comprar X unidades de Z productos filtrando por la marca Y teniendo que iniciar sesion
    Start_Browser
    Filter    2
    Add_Product    css=input.esh-catalog-button[type='submit']    4
    Continue_Shopping
    Filter    3
    Add_Product    css=input.esh-catalog-button[type='submit']    4
    Checkout
    Login    admin@microsoft.com    Pass@word1
    Pay

CP006 - Cerrar sesión teniendo la sesión iniciada
    Start_Browser
    Go_Login
    Login    demouser@microsoft.com    Pass@word1
    Logout

*** Keywords ***
Start_Browser
    Open Browser    ${URL}    ${BROWSER} 
    Maximize Browser Window
# Not free hosting, bot needs to click on blue button
    Wait Until Element Is Visible    xpath=//button[contains(text(),'Visit Site')]    timeout=10s
    Click Button    xpath=//button[contains(text(),'Visit Site')]

Go_Login
    Click Link    css=.esh-identity-name.esh-identity-name--upper

Login
    [Arguments]  ${user}    ${pass}
    Input Text    Input_Email    ${user}
    Input Password    Input_Password    ${pass}
    Select Checkbox    Input_RememberMe 
    Click Button    css=.btn.btn-default
Add_Product
    [Arguments]    ${add_product_component}    ${quantity}
    Click Button    ${add_product_component}
    Input Text    css=input.esh-basket-input[type='number']    ${quantity}
    Update

Checkout
    Click Link    xpath=//a[contains(@class, 'esh-basket-checkout') and contains(text(), 'Checkout')]

Update
    Click Button   xpath=//button[contains(@class, 'esh-basket-checkout') and contains(text(), 'Update')]


Continue_Shopping
    Click Link    xpath=//a[contains(@class, 'esh-basket-checkout') and contains(text(), 'Continue Shopping')]

Pay
    Click Button    xpath=//input[@type='submit' and contains(@class, 'esh-basket-checkout') and @value='[ Pay Now ]']
    
Filter
    [Arguments]    ${brand}
    Select From List By Value    id=CatalogModel_BrandFilterApplied    ${brand}
    Click Button    css=.esh-catalog-send

Logout
    Mouse Over    css=.esh-identity-section
    Click Element    xpath=//section[@class='esh-identity-drop']//a[last()]

    