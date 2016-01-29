
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
    "1111"="X"
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
<#
function getFitness {
param([string[]]$gene)


[byte[]][char[]]$Goal="Hejsan Jon"
$Rgoal=$Goal.ForEach({[convert]::ToString($PSItem,2)}).PadLeft(8,"0") -join ""
#$Rgoal.Length

$rc=$Rgoal -split "(\w{8})" | ? {$_}
$gc=$gene  -split "(\w{8})" | ? {$_}
$comO=for ($i = 0; $i -lt $rc.Count; $i++)
{ 
    Compare-Object -ReferenceObject $rc[$i] -DifferenceObject $gc[$i] -IncludeEqual
}
#Compare-Object -ReferenceObject $rc[0] -DifferenceObject $gc[0] -IncludeEqual
$score=0
$score+=$comO.where({$PSItem.SideIndicator -eq "=="}).count

$miss=$comO.where({$PSItem.SideIndicator -ne "=="})
$ml=$miss.Count
$iu=0
$missR=$miss[0..(($ml/2)-1)].ForEach({
    
    #write-host $psitem.InputObject -ForegroundColor Green
    #write-host $miss[($ml/2)..($miss.Count)][$iu].InputObject -ForegroundColor Red
    $bas=$psitem.InputObject
    $ref=$miss[($ml/2)..($miss.Count)][$iu].InputObject
    $errorindev=([convert]::ToInt32($bas,2)) - ([convert]::ToInt32($ref,2))
    $nRb=([char[]][string]($bas -band $ref)).where({$psitem -eq "1"}).count

    $bitdifFitness=100-$errorindev/255
    $bitFitness=($nRb/8*100)/8
    ($bitdifFitness+$bitFitness)/2
    $iu++
})

$NumberOfMiss=$missR.Count
$totalNumber=$NumberOfMiss+$score
$score=(($score*100) + ($missR | measure -Sum).Sum) / $totalNumber

return $score
}
#>
function getFitness {
param([string[]]$gene,[float]$goal)
    $rc=$gene -split "(\w{4})" | ? {$_}
    #$calc="`$r=4+5*8/2"
    $calc="`$r=", ($rc.ForEach({$options["$psitem"]}) -join "") -join ""


    try {
        Invoke-Expression $calc
    } catch {
        $r=0
    }
    try {
        if ($r.ToString() -eq "¤¤¤") {
            $r=0
        }
    } catch {
        $r=0
    }


    $ggsa=$goal-$r
    [float]$fit=($ggsa/$goal)*100
    if ($fit -lt 0) {$fit=-($fit)}
    if ((100-$fit) -lt 0) {[float]$fit=99}
    $ru=(100-$fit)
    if ($ru -eq 0) {$ru=1}
    #Write-Host $ru 

        
    if ($ru -eq 100) { #substract penelty for using *0 or +0 ops
        $tmpScount=($calc -split "(([^\d]0\*)|(\*0)|(\+0)|([^\d]0\+))|(\/1[^\d])|([^\d]\+\d)" | ? {$_}).count
        if ($tmpScount -gt 1) {
            $ru -= ($tmpScount * 0.01)
        }
    }
    return $ru
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
param ($pop,$goal)
    $popt=$pop.count
    $popi=0
    $newPop=$pop.ForEach({
        $popi++
        write-progress -id  1 -activity "Calc fitness" -status 'Progress' -percentcomplete (($popi/$popt)*100)
        $r=New-Object System.Object
        $r | Add-Member -MemberType NoteProperty -Name DNA -Value $PSItem
        $r | Add-Member -MemberType NoteProperty -Name Fitness -Value (getFitness -gene $PSItem -goal $goal)
        return $r
    })
    return $newPop
}

$goal=13.37

$spopSize=600
$popSize=350
$nGenes=80
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
    $CGen++
    $newPop=CalcFitness -pop $pop -goal $goal
    
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

    [string[]]$pop=($newPop | sort -Property Fitness -Descending | select -First (get-random -Minimum 0 -Maximum 20)).DNA #surving 
    $tmpResize=(get-random -Minimum 0 -Maximum 20)
    do
    { 
        write-progress -id  2 -activity "Generating new popilation" -status 'Progress' -percentcomplete (($pop.Count/($popSize + $tmpResize))*100)
        $Childs=mate -newPop $newPop -xrate $xrate
        $Childs=$Childs.ForEach({mutate -gene $PSItem -mRate $mrate})
        $pop+=$Childs
        $pop = $pop | sort | Get-Unique #Only 
    }
    until ($pop.Count -ge ($popSize + $tmpResize))
    
}

#5+501-8%3*-42%67+814