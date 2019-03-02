$header = @"
#JDTAVSUSTAINMENTDATA#
2.50
N|N
#LPDATA#
!CNTR!|T|W90Z9C4225V!LOAD!KK2|D|!CONSIGNEE!|D|W90Z9C|D|3C4|UDA|2|SEAU|!ACTUALWT!|1360|0|018|1|FY19 JAN RETROGRADE|CLASS V|!HC!|||D
"@
$CMDDATAHeader = @"

#CMDDATA#

"@
$CMDDATA = @"
C|PROJECTILES|!SUFFIX!X|!DOD!|!NSN!||EA|!QTY!|A|!SUFFIX!X|
A|!DOD!|!LOTNO!||0000!LOTQTY!|
"@
$TCMDDATAHeader = @"

#TCMDDATA#

"@
$TCMDDATA = @"
TE2     W90Z9C             BX!SUFFIX!X  !CONSIGNEE! 003           00012894401.0
TE9     W90Z9C             BX!SUFFIX!X  !CONSIGNEE! VN00000000                1
TE4     W90Z9C             BX!SUFFIX!X  !CONSIGNEE! 003           00012894401.0
TE6     1                  BX!SUFFIX!X  !CONSIGNEE! !NSN!!DOD!13 UN!UNO!C
TE7     !WPWT!             BX!SUFFIX!X  !CONSIGNEE!!LOTNO2!0001000000001
TE9                        BX!SUFFIX!X  !CONSIGNEE! PROJECTILES !DOD! !PTBX!/PLT   2
TE9                       BX!SUFFIX!X  !CONSIGNEE! EXPLOSIVES WITH PREDOMINATE3
"@
$endlines = @"

#USERDATA#
##END##
"@

$oneLineText =  $header + $CMDDATAHeader + $CMDDATA + $TCMDDATAHeader + $TCMDDATA + $endlines
$multiLineHeader = $header + $CMDDATAHeader
Write-Output $oneLineFile
