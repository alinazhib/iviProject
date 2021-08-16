*** Settings ***
Documentation   Поиск в Google ivi

Test Teardown   TestLibrary.Close Browser

Library     Collections
Library     String
Library     TestLibrary

*** Test Cases ***
Search In Google ivi Images
    [Documentation]     Ищет в Google ivi, переходит к картинкам и выбирает Большие
    ...     после чего проверяет, что не менее 3 картинок в результате поиска ведут на ivi.ru
    Go To Google And Search ivi
    Go To Images And Сhoose Large
    Checks That At Least 3 Pictures Lead On ivi

Search In Google ivi Application For Android
    [Documentation]     Ищет в Google ivi, на первых 5 страницах находит ссылки на приложение ivi в play.google.com
    ...     после чего проверяет, что рейтинг приложения на кратком контенте страницы совпадает с рейтингом при переходе
    Go To Google And Search ivi
    Checks Rating ivi Application

Search In Google Wikipedia Article About ivi
    [Documentation]     Ищет в Google ivi, на первых 5 страницах находит ссылку на статью в Wikipedia об ivi
    ...     после чего проверяет, что в статье есть ссылка на официальный сайт ivi.ru
    Go To Google And Search ivi
    Find Wikipedia Article About ivi
    Wiki Article Should Contains Link To ivi.ru

*** Keywords ***
Checks That At Least 3 Pictures Lead On ivi
    [Documentation]     Проверяет, что не менее 3 картинок ведут на ivi.ru

    Set Test Variable  @{pic_urls}   @{EMPTY}

    ${elements}      Get WebElements By Class Name     class_name=rg_i
    FOR    ${el}    IN  @{elements}
        ${amount}    Get length    ${pic_urls}
        Continue For Loop If    ${amount} == 3
        Click On Element    ${el}
        ${pic}  Get WebElement Attribute By Class Name    class_name=eHAdSb   attribute=href
        ${status}    ${value} =  Run Keyword And Ignore Error   Should Match Regexp    ${pic}    (https:\/\/www.ivi.ru)
        Run Keyword If    '${status}' != 'FAIL'     Append To List  ${pic_urls}  ${pic}
    END
    Should Be Equal    ${amount}    ${3}

Checks Rating ivi Application
    [Documentation]     Проверяет, что рейтинг приложения на кратком контенте страницы совпадает с рейтингом при переходе

    Set Test Variable  @{app_urls}  @{EMPTY}
    Set Test Variable  @{rates}     @{EMPTY}

    FOR     ${page}     IN RANGE    1   5
        ${elements}     Get WebElements By Xpath    xpath=//a[@href]
        FOR    ${el}    IN    @{elements}
            ${url}  Get WebElement Attribute   ${el}   attribute=href
            ${status}    ${value} =  Run Keyword And Ignore Error   Should Match Regexp    ${url}    (https:\/\/play.google.com)
            Run Keyword If    '${status}' != 'FAIL'   Append Elements To List   ${url}  ${app_urls}     ${rates}
        END
        Find Element By Xpath And Click    //a[@aria-label="Page ${{int($page)+1}}"]
    END
    Checks Rate  ${app_urls}    ${rates}

Append Elements To List
    [Documentation]     Добавляет в список  ${app_urls} ссылки на приложение ivi в play.google.com
    ...                 Добавляет в список  ${rates} рейтинг приложения на кратком контенте страницы
    [Arguments]     ${url}  ${app_urls}  ${rates}
    ${rate_preview}     Get Webelement Text    //span[contains(text(),"Рейтинг")]
    Append To List  ${app_urls}  ${url}
    Append To List  ${rates}  ${rate_preview}

Checks Rate
    [Documentation]     Сравнивает рейтинг приложения на кратком контенте страницы
    ...                 с рейтингом на странице приложения ivi в play.google.com
    [Arguments]     ${app_urls}     ${rates}
    FOR    ${url}   ${rate}   IN ZIP   ${app_urls}     ${rates}
        ${rate_preview}    Return Rate    ${rate}
        TestLibrary.Go To    ${url}     Google Play
        ${rate_play_store}  Get Webelement Text    //div[@class="BHMmbe"]
        Should Be Equal    ${rate_preview}  ${rate_play_store}
    END

Find Wikipedia Article About ivi
    [Documentation]     Находит в Google ссылку на статью в Wikipedia об ivi

    Set Test Variable  @{wiki_ivi}  @{EMPTY}

    FOR     ${page}     IN RANGE    1   5
        ${elements}     Get WebElements By Xpath    xpath=//a[@href]
        FOR    ${el}    IN    @{elements}
            ${amount}    Get length    ${wiki_ivi}
            Continue For Loop If    ${amount} == 1
            ${url}  Get WebElement Attribute    ${el}   attribute=href
            ${status}    ${value} =  Run Keyword And Ignore Error   Should Match Regexp    ${url}    (https:\/\/ru.wikipedia.org\/wiki\/Ivi.ru)
            Run Keyword If    '${status}' != 'FAIL'     Append To List  ${wiki_ivi}  ${url}
        END
        Find Element By Xpath And Click    //a[@aria-label="Page ${{int($page)+1}}"]
    END
    Set Test Variable    ${WIKI URL}         ${wiki_ivi}[0]
    [Return]  ${WIKI URL}

Wiki Article Should Contains Link To ivi.ru
    [Documentation]     Проверяет, что в статье Wikipedia есть ссылка на официальный сайт ivi.ru
    Get Variable Value    ${WIKI URL}
    TestLibrary.Go To    ${WIKI URL}    ivi.ru — Википедия
    ${url}  Get WebElement Attribute By Xpath    //a[text()='ivi.ru']   attribute=href
    Should Be Equal    ${url}    https://www.ivi.ru/