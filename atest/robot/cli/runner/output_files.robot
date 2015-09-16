*** Settings ***
Test Setup      Create Output Directory
Resource        cli_resource.robot


*** Test Cases ***

Output Only
    Run Tests Without Processing Output  --outputdir ${CLI OUTDIR} --output myoutput.xml --report none --log none    ${TESTFILE}
    Output Directory Should Contain  myoutput.xml

Output And Report
    Run Tests Without Processing Output  --outputdir ${CLI OUTDIR} --output myoutput.xml --report myreport.html --log none    ${TESTFILE}
    Output Directory Should Contain  myoutput.xml  myreport.html

Output And Log
    Run Tests Without Processing Output  --outputdir ${CLI OUTDIR} --output myoutput.xml --report none --log mylog.html    ${TESTFILE}
    Output Directory Should Contain  mylog.html  myoutput.xml

Disabling output XML only disables log with a warning
    Run Tests Without Processing Output  --outputdir ${CLI OUTDIR} -o nOnE -r report.html -l mylog.html    ${TESTFILE}
    Output Directory Should Contain    report.html
    Check Stderr Matches Regexp    \\[ ERROR \\] Log file is not created if output.xml is disabled.

All output files disabled
    Run Tests Without Processing Output  --outputdir ${CLI OUTDIR} -o nOnE -r NONE -l none    ${TESTFILE}
    Directory Should Be Empty    ${CLI OUTDIR}

Debug, Xunit And Report File Can Be Created When Output Is NONE
    Run Tests Without Processing Output  --outputdir ${CLI OUTDIR} -o NONE -r myreport.html -b mydebug.txt -x myxunit.xml    ${TESTFILE}
    Output Directory Should Contain  mydebug.txt  myreport.html  myxunit.xml

All Outputs
    Run Tests Without Processing Output  --outputdir=${CLI OUTDIR} --output=myoutput.xml --report=myreport.html --log=mylog.html  ${TESTFILE}
    Output Directory Should Contain  mylog.html  myoutput.xml  myreport.html

All Outputs With Default Names
    Run Robot Directly  --outputdir ${CLI OUTDIR} ${DATADIR}${/}${TESTFILE}
    Output Directory Should Contain  log.html  output.xml  report.html

All Outputs Without Extensions
    Run Tests Without Processing Output  --outputdir ${CLI OUTDIR} -o myoutput -r myreport -l mylog  ${TESTFILE}
    Output Directory Should Contain  mylog.html  myoutput.xml  myreport.html

Outputs Into Different Dirs
    Run Tests Without Processing Output  --outputdir ::invalid:: -o ${CLI OUTDIR}/o/o.xml -r ${CLI OUTDIR}/r/r.html -l ${CLI OUTDIR}/l.html  ${TESTFILE}
    Directory Should Contain  ${CLI OUTDIR}/o  o.xml
    Directory Should Contain  ${CLI OUTDIR}/r  r.html
    Directory Should Contain  ${CLI OUTDIR}  l.html  o  r

Split Log
    Run Tests Without Processing Output  --outputdir ${CLI OUTDIR} --output o.xml --report r.html --log l.html --splitlog  ${TESTFILE}
    Directory Should Contain  ${CLI OUTDIR}  l-1.js  l-2.js  l.html  o.xml  r.html

Non-writable Output File
    Create Directory  ${CLI OUTDIR}/diréctöry.xml
    Run Tests Without Processing Output  --output ${CLI OUTDIR}/diréctöry.xml  ${TESTFILE}
    Check Stderr Matches Regexp  \\[ ERROR \\] Opening output file '.*diréctöry.xml' failed: .*${USAGE_TIP}

Non-writable Log and Report
    ${directory} =  Normalize Path  ${CLI OUTDIR}/diréctöry.html
    Create Directory  ${directory}
    Run Tests  --log ${directory} --report ${directory}  ${TESTFILE}
    Should Be Equal  ${SUITE.status}  PASS
    Check Stderr Matches Regexp  SEPARATOR=\n
    ...  \\[ ERROR \\] Writing log file '.*diréctöry.html' failed: .*
    ...  \\[ ERROR \\] Writing report file '.*diréctöry.html' failed: .*
    Check Stdout Contains  Output:
    Check Stdout Does Not Contain  Log:
    Check Stdout Does Not Contain  Report:

Non-writable Split Log
    Create Directory  ${CLI OUTDIR}/dir-1.js
    Run Tests  --splitlog --log ${CLI OUTDIR}/dir.html --report r.html  ${TESTFILE}
    Should Be Equal  ${SUITE.status}  PASS
    Check Stderr Matches Regexp  \\[ ERROR \\] Writing log file '.*dir.html' failed: .*
    Check Stdout Contains  Output:
    Check Stdout Does Not Contain  Log:
    Check Stdout Contains  Report:

