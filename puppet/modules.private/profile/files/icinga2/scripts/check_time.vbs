' Author: Dmitry Vayntrub (dvayntrub@yahoo.com)
' Loosely based off the check_ad_time.vbs by Mattias Ryrl�n (mr@op5.com) 
' Version: 1.01 17/01/2010
' Description: Check time offset of a Windows server against NTPD server(s).


Set Args = WScript.Arguments
If WScript.Arguments.Count < 3 Then
Err = 3
WScript.Echo "check_time.vbs V1.01"
WScript.Echo "Usage: cscript /NoLogo check_time.vbs serverlist warn crit [biggest]"
Wscript.Echo ""
Wscript.Echo "Options:"
Wscript.Echo " serverlist (required): one or more server names, coma-separated"
Wscript.Echo " warn  (required): warning offset in seconds, can be partial"
Wscript.Echo " crit  (required): critical offset in seconds, can be partial"
Wscript.Echo " biggest (optional): if multiple servers, else use default least offset" 
Wscript.Echo ""
Wscript.Echo "Example:"
Wscript.Echo "cscript /NoLogo check_time.vbs myserver1,myserver2 0.4 5 biggest"
Wscript.Quit(Err)
End If

serverlist = Args.Item(0)
warn = Args.Item(1)
crit = Args.Item(2)
If WScript.Arguments.Count > 3 Then
  criteria = Args.Item(3)
  Else
  criteria = least
End If

Set objShell = CreateObject("Wscript.Shell")
strCommand = "%SystemRoot%\System32\w32tm.exe /monitor /nowarn /computers:" & serverlist
set objProc = objShell.Exec(strCommand)

input = ""
strOutput = ""
Do While Not objProc.StdOut.AtEndOfStream
  input = objProc.StdOut.ReadLine
  If InStr(input, "NTP") Then
    strOutput = strOutput & input
  End If
Loop

Set myRegExp = New RegExp
myRegExp.IgnoreCase = True
myRegExp.Global = True
myRegExp.Pattern = " NTP: ([+-][0-9]+\.[0-9]+)s"
Set myMatches = myRegExp.Execute(strOutput)

result = ""
If myMatches(0).SubMatches(0) <> "" Then
  result = myMatches(0).SubMatches(0)
End If
For Each myMatch in myMatches
  If myMatch.SubMatches(0) <> "" Then
    If criteria = "biggest" Then
      If abs(result) < Abs(myMatch.SubMatches(0)) Then
        result = myMatch.SubMatches(0)
      End If
    Else
      If abs(result) > Abs(myMatch.SubMatches(0)) Then
        result = myMatch.SubMatches(0)
      End If
    End If
  End If
' Wscript.Echo myMatch.SubMatches(0) & " -debug"
Next

If result = "" Then
  Err = 3
  Status = "UNKNOWN"
  ElseIf abs(result) > crit*10000000 Then
  Err = 2
  status = "CRITICAL"
  ElseIf abs(result) > warn*10000000 Then
  Err = 1
  status = "WARNING"
  Else
  Err = 0
  status = "OK"
End If

Wscript.Echo "NTP " & status & ": Offset " & result & " secs|'offset'=" & result & "s;" & warn & ";" & crit & ";"
Wscript.Quit(Err)
