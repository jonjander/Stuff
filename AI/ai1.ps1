
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

function getFirstPopulation {
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

function Mutate {
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

function gComp {
param([float]$ref,[float]$org)
    if ($ref.ToString().length -eq $org.ToString().length) {
        $tref=$ref -split ""
        $igComp=0
        $nFr=($org -split "").ForEach({
            compare -ReferenceObject $tref[$igComp] -DifferenceObject $PSItem
            $igComp++
        }).where({$PSItem.SideIndicator -eq "=>"}).count

        return (($ref.ToString().length) - $nFr)/($ref.ToString().length)*100
    } else {
        return 10 #Force to 10 #Expremental
    }
}

function getFitness {
param([string[]]$gene,[float]$goal)
    $rc=$gene -split "(\w{4})" | ? {$_}
    [string]$tmpFormula=$rc.ForEach({$options["$psitem"]}) -join ""
    $calc="`$r=", $tmpFormula -join ""

    if (($tmpFormula -split ("([*/%X]{2,})|(^[*/%X])|([*/%X]$)|(X)")).count -gt 1) { #Calculation error avoidance
        $r=0
        write-host "Error avoided " -ForegroundColor Green -NoNewline
        write-host $calc
    } else {

        try { Invoke-Expression $calc -ErrorAction SilentlyContinue } catch { $r=0 }
        try {
            if ($r.ToString() -eq "¤¤¤") {
                $r=0
                write-host "inf " -ForegroundColor Red -NoNewline
                write-host $calc
            }
        } catch {
            $r=0
            write-host "Error " -ForegroundColor Red -NoNewline
            write-host $calc
        }
    }
    #write-host $r
    
    $ggsa=$goal-$r
    [float]$fit=($ggsa/$goal)*100
    if ($fit -lt 0) {$fit=-($fit)}
    if ((100-$fit) -lt 0) {[float]$fit=99}
    $ru=(100-$fit)
    #write-host $ru
    if ($ru -eq 0) {$ru=1}
    $gCompR=gComp -ref $goal -org $r
    #write-host $gCompR -f Cyan

    [string[]]$BlendOptions=@("0","1","2")
    $blendR=Get-Random $BlendOptions #Random fitnessblend
    if ($gCompR -ne -1) {
        if ($blendR -eq "1") { #mix
            $ru=($ru+$gCompR)/2
            #Write-Host "avg mix" -ForegroundColor Yellow
        } elseif ($blendR -eq "2") { #Use right
            $ru=$gCompR
            #Write-Host "By position" -ForegroundColor Yellow
        } else { #Use left
            #$ru=$ru
            #Write-Host "By math" -ForegroundColor Yellow
        }
    }
    #write-host $ru
    #if ($ru -eq 100) { #substract penalty for using *0 or +0 ops
        $tmpScount=($calc -split "(([^\d]0\*)|(\*0)|(\+0)|([^\d]0\+))|(\/1[^\d])|(\/1$)|([^\d]\+\d)|(\*1[^\d])|(\*1$)|([\+\-])\1" | ? {$_}).count
        if ($tmpScount -gt 1) {
            $ru -= ($tmpScount * 0.0001) 
        }
        $tmpeScount=0
        $tmpeScount=($calc -split "[\+\-\*\\\%]" | ? {$_}).count
        $ru += ($tmpeScount*0.0001) #Add bonus for using operators
    #}

    $e=[math]::E
    $po=[math]::Pow($e,-(($ru/10)-5))
    $ru=(1/(1+$po*7))*100

    return $ru
}

function mate {
param ($newPop,$xrate)
    $rsum=($newPop.Fitness | measure -Sum).Sum
    $timeout=0
    do
    {
        $timeout++
        if ($timeout -gt 3) {
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
    until ($p2.DNA -ne $p1.DNA -or $timeout -gt 4)
    return crossover -p1 $p1.DNA -p2 $p2.DNA -xrate $xrate
}

function CalcFitness {
param ($pop,$goal)
    $popt=$pop.count
    $popi=0
    $newPop=$pop.ForEach({
        $popi++
        write-progress -id  1 -activity "Calc fitness" -status "Progressing $PSItem" -percentcomplete (($popi/$popt)*100)
        $r=New-Object System.Object
        $r | Add-Member -MemberType NoteProperty -Name DNA -Value $PSItem
        $r | Add-Member -MemberType NoteProperty -Name Fitness -Value (getFitness -gene $PSItem -goal $goal)
        return $r
    })
    write-progress -id  1 -Completed -Activity "Calc fitness"
    return $newPop
}

$goal=8801156673

$spopSize=1500 #initial population size
$popSize=800 #Population size
$nGenes=(4*20) #each character requires four genes #defailt 20
$mrate=14 #Mutation rate
$xrate=800 #Crossover rate

Write-Host ("Goal is : {0}" -f $goal)
Write-Host ("Generate fist popilation : {0}" -f $spopSize)
Write-Host ("Popilation Size : {0}" -f $popSize)
Write-Host ("Number of genes in chromosome : {0}" -f $nGenes)
write-host ("Mutation rate : ({0}/100000)" -f $mrate)
write-host ("Crossover rate : {0}%" -f ($xrate/1000))

$pop=getFirstPopulation -size $spopSize -nGenes $nGenes
$best=$null
$CGen=0
$r=$null #clear result
$timeLine=while ($r -ne $goal) {
    $robj=New-Object System.Object
    $CGen++
    $newPop=CalcFitness -pop $pop -goal $goal
    write-host "Top 4 best chromosomes"
    write-host (($newPop.DNA | sort -Descending |select -First 4)  -join "`n")
    $best=$newPop | sort -Property Fitness -Descending | select -First 1
    $rc=$best.DNA -split "(\w{4})" | ? {$_}
    $tcalc="`$r=", ($rc.ForEach({$options["$psitem"]}) -join "") -join ""
    Write-host ("Current generation : {0}" -f $CGen) -f cyan
    Write-Host ("Popilation size : {0}" -f ($newPop).count)
    Write-Host ("Calculation formula : {0}" -f $tcalc)
    try {Invoke-Expression -Command $tcalc } catch { $r = "Error" }
    write-host ("Calculation result : {0}" -f $r)
    Write-Host ("Current best fitness : {0}" -f $best.Fitness) -f magenta
    $robj | Add-Member -MemberType NoteProperty -Name Fitness -Value $best.Fitness
    $robj | Add-Member -MemberType NoteProperty -Name Formulat -Value $tcalc
    $robj | Add-Member -MemberType NoteProperty -Name Time -Value (get-date)
    Write-Host ("Mutation rate {0}" -f $mrate)
    [string[]]$pop=($newPop | sort -Property Fitness -Descending | select -First (get-random -Minimum 0 -Maximum 20)).DNA #surving 
    $tmpResize=(get-random -Minimum 0 -Maximum 20)
    do
    { 
        write-progress -id  2 -activity "Generating new popilation" -status 'Progress' -percentcomplete (($pop.Count/($popSize + $tmpResize))*100)
        $Childs=mate -newPop $newPop -xrate $xrate
        $Childs=$Childs.ForEach({Mutate -gene $PSItem -mRate $mrate})
        $pop+=$Childs
        $pop = $pop | sort | Get-Unique
    }
    until ($pop.Count -ge ($popSize + $tmpResize))
    write-progress -id 2 -Completed -Activity "Generating new popilation"
    Write-Output $robj
}
$timeLine | ogv
