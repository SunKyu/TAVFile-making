$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$file = $ScriptDir + "\examplep.txt"
$samplePath = $ScriptDir + "\samples.ps1"
. $samplePath

$csvPath = $ScriptDir + "\2018-12-12AD11DETAIL.csv"
Write-Host $csvPath

function loadrow{
    param($row)
    $table = @{}
    $table['LOAD'] = $row.'LOAD #'
    $zerocount = 3 - $row.'LOAD #'.Length
    $val = 0
    $FIXEDLOAD = $row.'LOAD #'
    while($val -ne $zerocount) {$val++ ; $fixedLOAD = "0" + $FIXEDLOAD}
    $table['LOAD'] = $FIXEDLOAD
    $table['CNTR'] = $row.'CNTR #'
    #$table['SEAL'] = $row.'SEAL #'
    #$table['H1'] = $row.H1
    $table['DOD'] = $row.DOD
    if ($table.DOD.equals("D561")){
        $table['WPWT'] = "2.9370"
        $table['HC'] = "1.2"
        $table['UNO'] = "0169"
    } elseif ($table.DOD.equals("D562")){
        $table['WPWT'] = "2.9237"
        $table['HC'] = "1.2"
        $table['UNO'] = "0169"
    } elseif ($table.DOD.equals("D563")){
        $table['WPWT'] = "6.3770"
        $table['HC'] = "1.1"
        $table['UNO'] = "0168"
    }else{
        $table['WPWT'] = "0.0000"
        $table['HC'] = "0.0"
        $table['UNO'] = "0000"
        #FIXME Check HC for each DODIC YELLOWBOOK
        #FIXME Check UNO for each DODIC YELLOWBOOK
    }
    $table['CONSIGNEE'] = $row.CONSIGNEE
    $table['SUFFIX'] = $row.SUFFIX
    $table['NSN'] = $row.NSN
    $table['LOTNO'] = $row.'LOT NO'
    $spaceCount = 15 - $row.'LOT NO'.Length
    $LOTNO2 = $row.'LOT NO'
    $val = 0
    while($val -ne $spaceCount) { $val++ ; $LOTNO2 = " "+$LOTNO2;}
    $table['LOTNO2'] = $LOTNO2
    $table['CC'] = $row.CC
    $table['ACCT'] = $row.ACCT
    $table['QTY'] = $row.QTY
    $table['PTBX'] = $row.'PT/BX'
    #$table['WT'] = $row.WT
    #$table['WTKG'] = $row.'WT(KG)'
    #$table['NEW'] = $row.NEW
    #$table['NEWKG'] = $row.'NEW(KG)'
    $table['ACTUALWT'] = $row.'ACTUAL WT'
    $table['ACTUALWT'] = $table['ACTUALWT'] -replace " ", ""
    $table['ACTUALWT'] = $table['ACTUALWT'] -replace ",", ""
    #$table['ACTUALWTKG'] = $row.'ACTUAL WT(KG)'
    #$table['WTTARE'] = $row.'WT TARE'
    #$table['TAREKG'] = $row.'TARE(KG)'

    return $table
}
$text = (Get-Content -Path $file -ReadCount 0)
Write-Host $csvPath
$rows = Import-Csv $csvPath
$count = 0
$incompleteDataFlag = $false
$mixedFlag = $false
#FIX MiXED line array
$mixedrows = @()
ForEach ($row in $rows){
    $rowdic = loadrow -row $row
    <#
    if ($rowdic.LOTNO.Equals("TOTAL")){
        Write-Output $mixedrows
        $mixedFlag = $false
        #$mixedrows = @()
        continue
    }
    if ($mixedFlag){
        #$mixedrows.Add($row)
        #next line to the end
        continue
    }
    #>
    if ($rowdic.LOTNO.Equals("MIXED")){
        write-output "MIXED"
        
        #$mixedrows.Add($row)
        $mixedFlag = $true
        $tempMixedCMDDATA = ""
        $tempMixedTCMDDATA = ""
        continue
        #not FIXED DATA
        # 1. LOTNO
        # 2. QTY
        # 3. ACCT (if exist It is LOTQTY(sum of same LOTNO QTY)
        # 4. PTBX
        #developing
    }
    $temp = $oneLineText
    ForEach ($key in $rowdic.Keys){
        $target = "!"+$key+"!"
        if($rowdic.$key.Length.Equals(0)){
            $incompleteDataFlag = $true
            Write-Output "EMPPPTTY"
            Write-Output $key
            break
        }
        switch($key){
            "QTY"{
                $temp = $temp -replace '!LOTQTY!', $rowdic.$key
                $temp = $temp -replace '!QTY!', $rowdic.$key
            }
            "NSN"{
                $noDashNSN = $rowdic.$key -replace "-", ""
                $temp = $temp -replace $target, $noDashNSN
                break
            }
            "SUFFIX"{
                $noDashSUFFIX = $rowdic.$key -replace "-", ""
                $noDashSUFFIX = $noDashSUFFIX.Substring(0,14)
                $temp = $temp -replace $target, $noDashSUFFIX
                break
            }
            default {
                $temp = $temp -replace $target, $rowdic.$key
                break
            }
        }
    }
    if ($incompleteDataFlag){
        $incompleteDataFlag = $false
        continue
    }
    $count = $count + 1
    Write-Output $temp
    $path = $ScriptDir + "\ad11\" + $rowdic.CNTR + ".TAV"
    Write-Host $path
    Set-Content -Path $path $temp
}
Write-Output $oneLineFile
Write-Output $count