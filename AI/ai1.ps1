
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
    "1110"="*"
    "1111"="/"
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

function getFitness {
param([string[]]$gene,$goal)
    #$goal=1337
    
    
    #$gene="00110001011000011010110101011010111100101111111001110100010001101101010100110110"
    $rc=$gene -split "(\w{4})" | ? {$_}
    #$calc="`$r=4+5*8/2"
    $calc="`$r=", ($rc.ForEach({$options["$psitem"]}) -join "") -join ""


    try {
        Invoke-Expression $calc
    } catch {
        $r=0
    }
    $ggsa=1337-$r
    $fit=($ggsa/1337)*100
    if ($fit -lt 0) {$fit=-($fit)}
    if (100-$fit -lt 0) {$fit=100}
    return (100-$fit)
}

function mate {
param ($newPop)
    $rsum=($newPop.Fitness | measure -Sum).Sum
    do
    {
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
    until ($p2.DNA -ne $p1.DNA)
    #Write-Host $p2.DNA -ForegroundColor Cyan
   # Write-Host $p1.DNA -ForegroundColor Cyan
    return crossover -p1 $p1.DNA -p2 $p2.DNA -xrate 800
}

function CalcFitness {
param ($pop)
    $newPop=$pop.ForEach({
        $r=New-Object System.Object
        $r | Add-Member -MemberType NoteProperty -Name DNA -Value $PSItem
        $r | Add-Member -MemberType NoteProperty -Name Fitness -Value (getFitness -gene $PSItem)
        return $r
    })
    return $newPop
}

$goal=1337

$spopSize=1000
$popSize=20
$nGenes=80

Write-Host "Goal is " $goal
Write-Host "Generate fist popilation " $spopSize
Write-Host "Number of genes " $nGenes
$pop=getfistpopilation -size $spopSize -nGenes $nGenes
$best=$null
$CGen=0
while ($best.Fitness -ne 100) {
    $CGen++
    $newPop=CalcFitness -pop $pop -goal $goal
    Write-host "Current generation" $CGen
    write-host "Top 4 best chromosomes"
    write-host (($newPop.DNA | sort -Descending |select -First 4)  -join "`n")

    $best=$newPop | sort -Property Fitness -Descending | select -First 1
    #Write-Host ([string][char[]]($best.DNA -split "(\w{8})" | ? {$_}).ForEach({[convert]::ToInt32($psitem,2)}))

    $rc=$best.DNA -split "(\w{4})" | ? {$_}
    #$calc="`$r=4+5*8/2"
    $tcalc="`$r=", ($rc.ForEach({$options["$psitem"]}) -join "") -join ""
    Write-Host $tcalc
    Write-Host "Fitness : " $best.Fitness
    $Childs=mate -newPop $newPop
    #$Childs=$Childs.ForEach({mutate -gene $PSItem -mRate 10})

    $pop=($newPop | sort -Property Fitness -Descending | select -First 20).DNA
    do
    {
        $Childs=mate -newPop $newPop
        $Childs=$Childs.ForEach({mutate -gene $PSItem -mRate 1})
        $pop = $pop | sort | Get-Unique
        $pop+=$Childs
    }
    until ($pop.Count -ge $popSize)
}