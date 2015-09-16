*** Settings ***
Resource          libdoc_resource.robot
Test Template     Library Should Have No Init

*** Test Cases ***
New Style Python Class With No Init
    NewStyleNoInit.py

Old Style Python Class With No Argument Init
    no_arg_init.py

Java Class With No Constructor
    [Tags]    require-jython
    NoConstructor.java

Java Class With Default and Private Constructors
    [Tags]    require-jython
    NoArgConstructor.java


*** Keywords ***
Library Should Have No Init
    [Arguments]    ${library}
    Run Libdoc And Parse Output    ${TESTDATADIR}/${library}
    Should Have No Init
    Doc Should Be    No inits here!
    Keyword Name Should Be         0    Keyword
    Keyword Arguments Should Be    0    arg1    arg2
    Keyword Doc Should Be          0    The only lonely keyword.
