#ai2

#

$options=@{
    "0000"="0"
    "0001"="1"
    "0010"="2"
    "0011"="3"
    "0100"="4"
    "0101"="5"
    "0110"="6"
    "0111"="7"
    "1000"="8"
    "1001"="9"
    "1010"="+"
    "1011"="-"
    "1100"="*"
    "1101"="/"
    "1110"="%"
    "1111"="`$G"
}


function getfistpopilation {
param ($size,$nGenes)
    $rt = for ($i = 0; $i -lt $size; $i++)
    { 
        $r=for ($f = 0; $f -lt $nGenes; $f++)
        { 
            Get-Random @(0,1)
        }
        Write-Output ($r -join "")
    }
   return $rt
}
function mutate {
param ($mRate,$gene)
    [byte[]]$gAr=($gene -split "")[1..$gene.Length]
    $ng=$gAr.ForEach({
        $rn=Get-Random -Minimum 0 -Maximum 100000
        if ($rn -le $mRate) {
            [int]$(-not $PSItem)
        } else {
            [int]$($PSItem)
        }
    })
    return $ng -join ""
}
function crossover {
param($p1,$p2,$xrate)
    [string]$k1=$null
    [string]$k2=$null
    $gSize=$p1.Length
    #Generate xratemodifier
    for ($i = 0; $i -lt $gSize; $i++)
    { 
        $c=Get-Random -Maximum 1000 -Minimum 0
        if ($c -le $xrate) {
            $k1+=$p1[$i]
            $k2+=$p2[$i]
        } else {
            $k1+=$p2[$i]
            $k2+=$p1[$i] 
        }
    }
    Write-Output $k1
    Write-Output $k2
} 
function ConstructGame {
    (1..9).ForEach({
        $r=New-Object System.Object
        $r | Add-Member -MemberType NoteProperty -Name Index -Value $PSItem
        $r | Add-Member -MemberType NoteProperty -Name Player -Value 0
        return $r
    })
}
function mate {
param ($newPop,$xrate)
    $rsum=($newPop.Fitness | measure -Sum).Sum
    $timeout=0
    do
    {
        $timeout++
        #write-host $timeout
        if ($timeout -gt 4) {
            $script:mrate++
        }
        #Parent 1
        $esum=0
        $random=Get-Random -Minimum 0 -Maximum $rsum
        $p1=$newPop.where({
            $esum+=$PSItem.Fitness
            if ($random -le $esum -and $random -gt ($esum - $PSItem.Fitness)) {
                $true
            } else {
                $false
            }
        }) | select -First 1
        #Parent 2
        $esum=0
        $random=Get-Random -Minimum 0 -Maximum $rsum
        $p2=$newPop.where({
            $esum+=$PSItem.Fitness
            if ($random -le $esum -and $random -gt ($esum - $PSItem.Fitness)) {
                $true
            } else {
                $false
            }
        }) | select -First 1
        }    
    until ($p2.DNA -ne $p1.DNA -or $timeout -gt 5)
    #Write-Host $p2.DNA -ForegroundColor Cyan
   # Write-Host $p1.DNA -ForegroundColor Cyan
    return crossover -p1 $p1.DNA -p2 $p2.DNA -xrate $xrate
}
function CalcFitness {
param ($pop,$Game)
    $popt=$pop.count
    $popi=0
    $newPop=$pop.ForEach({
        $popi++
        write-progress -id  1 -activity "Calc fitness" -status 'Progress' -percentcomplete (($popi/$popt)*100)
        $r=New-Object System.Object
        $r | Add-Member -MemberType NoteProperty -Name DNA -Value $PSItem
        $r | Add-Member -MemberType NoteProperty -Name Fitness -Value (getFitness -gene $PSItem -Game $Game)
        return $r
    })
    write-progress -id  1 -Completed -Activity "Calc fitness"
    return $newPop
}

function getFitness {
param([string[]]$gene,[object[]]$Game)
    
    $P=0
    $HumanC=$Game.Where({$PSItem.Player -eq 1}).count
    $CPUC=$Game.Where({$PSItem.Player -eq 2}).count
    $rc=$gene -split "(\w{4})" | ? {$_}
    #$rc[$CPUC+1]
    $DeCoded=($rc.ForEach({$options["$psitem"]}))
    
    [string[]]$inputs=$DeCoded.Where({$psitem -eq "`$G"})
    if ($inputs.count -ne 9) {
        $P+=$inputs.count * 10
    }
    $tmpii=0
    $DeCoded=$DeCoded.ForEach({
        if ($psitem -eq "`$G") {
            return $Game[$tmpii].Player
            $tmpii++
        } else {
            return $PSItem
        }
    })

    $tGar=(1..9).ForEach({
        $tr=New-Object System.Object
        $tr | Add-Member -MemberType NoteProperty -Name C -Value 0
        $tr | Add-Member -MemberType NoteProperty -Name index -Value $psitem
        return $tr
    })

    $calc1="`$tGar[0].C=1", ($DeCoded -join "") -join ""
    try {Invoke-Expression $calc1} catch {$tGar[0].C=0}
    $calc2="`$tGar[1].C=2", ($DeCoded -join "") -join ""
    try {Invoke-Expression $calc2} catch {$tGar[1].C=0}
    $calc3="`$tGar[2].C=3", ($DeCoded -join "") -join ""
    try {Invoke-Expression $calc3} catch {$tGar[2].C=0}

    $calc4="`$tGar[3].C=4", ($DeCoded -join "") -join ""
    try {Invoke-Expression $calc4} catch {$tGar[3].C=0}
    $calc5="`$tGar[4].C=5", ($DeCoded -join "") -join ""
    try {Invoke-Expression $calc5} catch {$tGar[4].C=0}
    $calc6="`$tGar[5].C=6", ($DeCoded -join "") -join ""
    try {Invoke-Expression $calc6} catch {$tGar[5].C=0}

    $calc7="`$tGar[6].C=7", ($DeCoded -join "") -join ""
    try {Invoke-Expression $calc7} catch {$tGar[6].C=0}
    $calc8="`$tGar[7].C=8", ($DeCoded -join "") -join ""
    try {Invoke-Expression $calc8} catch {$tGar[7].C=0}
    $calc9="`$tGar[8].C=9", ($DeCoded -join "") -join ""
    try {Invoke-Expression $calc9} catch {$tGar[8].C=0}

    try {if (($tGar[0].C).ToString() -eq "¤¤¤") {$tGar[0].C=0}} catch {$tGar[0].C=0}
    try {if (($tGar[1].C).ToString() -eq "¤¤¤") {$tGar[1].C=0}} catch {$tGar[1].C=0}
    try {if (($tGar[2].C).ToString() -eq "¤¤¤") {$tGar[2].C=0}} catch {$tGar[2].C=0}
    try {if (($tGar[3].C).ToString() -eq "¤¤¤") {$tGar[3].C=0}} catch {$tGar[3].C=0}
    try {if (($tGar[4].C).ToString() -eq "¤¤¤") {$tGar[4].C=0}} catch {$tGar[4].C=0}
    try {if (($tGar[5].C).ToString() -eq "¤¤¤") {$tGar[5].C=0}} catch {$tGar[5].C=0}
    try {if (($tGar[6].C).ToString() -eq "¤¤¤") {$tGar[6].C=0}} catch {$tGar[6].C=0}
    try {if (($tGar[7].C).ToString() -eq "¤¤¤") {$tGar[7].C=0}} catch {$tGar[7].C=0}
    try {if (($tGar[8].C).ToString() -eq "¤¤¤") {$tGar[8].C=0}} catch {$tGar[8].C=0}

    $tGar.Where({
        $PSItem.C -eq 0
    }).foreach({
        $P+=10
    })

    $draw=$tGar | sort -Property C -Descending | select -First 1
    $drawIndex=$Game.Index.IndexOf($draw.index)
    $gameObject=$Game[$drawIndex]
    if ($gameObject.Player -ne 0) {
        return 1
    } else {
        $game[$drawIndex].Player = 2

        function getV {
        param($game,$v1,$v2,$v3,$pl)
            ($Game.Where({$PSItem.Index -eq $v1 -and $PSItem.Player -eq $pl}).count + 
            $Game.Where({$PSItem.Index -eq $v2 -and $PSItem.Player -eq $pl}).count + 
            $Game.Where({$PSItem.Index -eq $v3 -and $PSItem.Player -eq $pl}).count) -
            ($Game.Where({$PSItem.Index -eq $v1 -and $PSItem.Player -eq 1}).count + 
            $Game.Where({$PSItem.Index -eq $v2 -and $PSItem.Player -eq 1}).count + 
            $Game.Where({$PSItem.Index -eq $v3 -and $PSItem.Player -eq 1}).count)
        }

        function firsTest {
            getV -game $Game -v1 1 -v2 2 -v3 3 -pl 2 # T
            getV -game $Game -v1 4 -v2 5 -v3 6 -pl 2 # -
            getV -game $Game -v1 7 -v2 8 -v3 9 -pl 2 # B
            getV -game $Game -v1 1 -v2 4 -v3 7 -pl 2 # L
            getV -game $Game -v1 2 -v2 5 -v3 8 -pl 2 # |
            getV -game $Game -v1 3 -v2 6 -v3 9 -pl 2 # R
            getV -game $Game -v1 3 -v2 5 -v3 7 -pl 2 # /
            getV -game $Game -v1 1 -v2 5 -v3 9 -pl 2 # \
        }
        [object[]]$ft=firsTest
        
        $good=0
        $twoinRowFactor=0.60
        $good+=$ft.Where({$PSItem -gt 1}).count * $twoinRowFactor #Two on a row

        if ($ft.Where({$PSItem -eq -3}).count -gt 0) { #Lost
            $good+=100
        }
    
        if ($ft.Where({$PSItem -eq -3}).count -gt 0) { #Lost
            $result=1
        }

        if ($result -eq 1) {
            return 1
        } else {
            $good - ($P * 0.002)
        }


    }

    # 1 2 3
    # 4 5 6
    # 7 8 9

    # X X O
    # O O O
    # X N N

    #penelty for missing input

}


$Game=ConstructGame
$Game[(get-random -Maximum 9 -Minimum 0)].Player = 2
$Game[(get-random -Maximum 9 -Minimum 0)].Player = 2
$Game[(get-random -Maximum 9 -Minimum 0)].Player = 1
$Game[(get-random -Maximum 9 -Minimum 0)].Player = 1
$MaxTurns=5
$popSize=10

$spopSize=2000
$popSize=500
$nGenes=(4*50)
$mrate=4
$xrate=800

Write-Host ("Goal is : {0}" -f $goal)
Write-Host ("Generate fist popilation : {0}" -f $spopSize)
Write-Host ("Popilation Size : {0}" -f $popSize)
Write-Host ("Number of genes in chromosome : {0}" -f $nGenes)
write-host ("Mutation rate : ({0}/100000)" -f $mrate)
write-host ("Crossover rate : {0}%" -f ($xrate/1000))
$pop=getfistpopilation -size $spopSize -nGenes $nGenes
$best=$null
$CGen=0
while ($best.Fitness -ne 100) {

    $Game=ConstructGame
    $Game[(get-random -Maximum 9 -Minimum 0)].Player = 2
    $Game[(get-random -Maximum 9 -Minimum 0)].Player = 2
    $Game[(get-random -Maximum 9 -Minimum 0)].Player = 1
    $Game[(get-random -Maximum 9 -Minimum 0)].Player = 1

    $CGen++
    $newPop=CalcFitness -pop $pop -Game $Game
    
    write-host "Top 4 best chromosomes"
    write-host (($newPop.DNA | sort -Descending |select -First 4)  -join "`n")

    $best=$newPop | sort -Property Fitness -Descending | select -First 1
    #Write-Host ([string][char[]]($best.DNA -split "(\w{8})" | ? {$_}).ForEach({[convert]::ToInt32($psitem,2)}))

    $rc=$best.DNA -split "(\w{4})" | ? {$_}
    #$calc="`$r=4+5*8/2"
    $tcalc="`$r=", ($rc.ForEach({$options["$psitem"]}) -join "") -join ""
    Write-host ("Current generation : {0}" -f $CGen)
    Write-Host ("Popilation size : {0}" -f ($newPop).count)
    Write-Host ("Calculation result : {0}" -f $tcalc)
    Write-Host ("Current best fitness : {0}" -f $best.Fitness)
    Write-Host ("Mutation rate {0}" -f $mrate)
    #$Childs=mate -newPop $newPop
    #$Childs=$Childs.ForEach({mutate -gene $PSItem -mRate 10})

    [string[]]$pop=($newPop | sort -Property Fitness -Descending | select -First (get-random -Minimum 10 -Maximum 20)).DNA #surving 
    $tmpResize=(get-random -Minimum 5 -Maximum 20)
    do
    { 
        write-progress -id  2 -activity "Generating new popilation" -status 'Progress' -percentcomplete (($pop.Count/($popSize + $tmpResize))*100)
        $Childs=mate -newPop $newPop -xrate $xrate
        $Childs=$Childs.ForEach({mutate -gene $PSItem -mRate $mrate})
        $pop+=$Childs
        $pop = $pop | sort | Get-Unique #Only 
    }
    until ($pop.Count -ge ($popSize + $tmpResize))
    write-progress -id 2 -Completed -Activity "Generating new popilation"
}
