

<#

Sharp turns
X SL SR

Medium turns

XX XX  ML MR
X   X

Large turns

 XXX  LL LR
XXX
XX
X

S curve

XX 5L 5R
XX
XX


(Crossing) 
 X
XXX  CR
 X

Start line
XXXXX  ST

         0
         x
         x
         x
         x
 3 xxxxxxxxxxxxx 1
         x 
         x
         x
         x
         2
x

x
x
x
x
x
x
x
oyyyyyyyyyyyyyyy y







#>


class Vector2 {
[int]$x
[int]$y
[int]$dir # 0,1,2,3 Can be X?
[boolean]$isEndPoint=$false

    Vector2([int]$x,[int]$y) {
        $this.x = $x
        $this.y = $y
        $this.dir = $null
        $this.isEndPoint = $false
    }

    Vector2([int]$x,[int]$y,[string]$dir,[boolean]$isEndPoint) {
        $this.x = $x
        $this.y = $y
        $this.dir = $dir
        $this.isEndPoint = $isEndPoint
    }

    Vector2([Vector2]$clonSelf) {
        $this.dir = $clonSelf.dir
        $this.isEndPoint = $clonSelf.isEndPoint
        $this.x = $clonSelf.x
        $this.y = $clonSelf.y
    }

}

class MapCell {
[int]$x
[int]$y
[boolean]$build=$false

    MapCell([int]$x,[int]$y) {
        $this.x = $x
        $this.y = $y
        $this.build = $false
    }
} #unused?

class track {
[Vector2[]]$shape #=@(
#    [Vector2]::new(0,0,0,$true)
#    [Vector2]::new(0,1)
#    [Vector2]::new(0,2)
#    [Vector2]::new(0,3) #End not included in shape
#) #right turn
[Vector2]$Start #=[Vector2]::new(0,0,0,$false) #Zero point prev end
[Vector2]$End #=[Vector2]::new(1,3,1,$true) #Match angle?
[int]$rotation #=0 # 0, 1, 2, 3

    [void] AddRotation ([int]$Rotation) {
        $iBlock = 0
        $this.shape | % {
            [Vector2]$trackBlock=$_
            #Write-host "Moving block"
            [int]$trackBlockX=$trackBlock.x
            [int]$trackBlockY=$trackBlock.y
            [int]$trackBlockR=$trackBlock.dir
            [int]$trackBlockXTmp=0
            [int]$trackBlockYTmp=0

            for ($i = 0; $i -lt $Rotation; $i++)
            { 
                #Set new values
                $trackBlockXTmp=$trackBlockY
                $trackBlockYTMP=-($trackBlockX)

                #Overwrite Org values
                $trackBlockX = $trackBlockXTmp
                $trackBlockY = $trackBlockYTmp

                $trackBlockR = ($trackBlockR + 1) % 4
                
            }
            $this.shape[$iBlock].x = $trackBlockX
            $this.shape[$iBlock].y = $trackBlockY
            $this.shape[$iBlock].dir = $trackBlockR
            $iBlock++
        }
        $this.rotation = ($this.rotation + $Rotation) % 4
        $this.Start.dir = ($this.Start.dir + $Rotation) % 4
        $this.End.dir = ($this.End.dir + $Rotation) % 4

        #End rotation
        $endTmpX=$this.End.x
        $endTmpY=$this.End.y

        $endx=$endTmpY
        $endy=-($endTmpX)

        $this.End.x = $endx
        $this.End.y = $endy

    }
    [void] setRotation([int]$rotation) {
        do
        {
            $this.AddRotation(1)
        }
        until ($this.rotation -eq $rotation)

    }
    [void] Move([int]$x,[int]$y) {
        $iBlock = 0
        $this.shape | % {
            [Vector2]$trackBlock=$_
            #Write-host "Moving block"
            $trackBlock.x = $trackBlock.x + $x
            $trackBlock.y = $trackBlock.y + $y                
            $this.shape[$iBlock].x = $trackBlock.x
            $this.shape[$iBlock].y = $trackBlock.y
            $iBlock++
        }

        $this.Start.x = $this.Start.x + $x
        $this.Start.y = $this.Start.y + $y

        $this.End.x = $this.End.x + $x
        $this.End.y = $this.End.y + $y

    }

    track ([int[]]$Data) {  
        $dataLen = $Data.count - 1
        for ($i = 0; $i -le ($Data.count - 1 - 9); $i+=4)
        { 
           #Write-host $i
           $this.shape += [Vector2]::new($Data[$i],$Data[$i+1],$Data[$i+2],$Data[$i+3])
        }
        $this.Start = [Vector2]::new($Data[$dataLen - 8],$Data[$dataLen - 7],$Data[$dataLen - 6],$Data[$dataLen - 5])
        $this.End = [Vector2]::new($Data[$dataLen - 4],$Data[$dataLen - 3],$Data[$dataLen - 2],$Data[$dataLen - 1])
        $this.rotation = $Data[$dataLen]
    }

    track ([Vector2[]]$shape,[Vector2]$Start,[Vector2]$End) {
        $this.shape = $shape
        $this.Start = $Start
        $this.End = $end
        $this.rotation = 0
    }
    track () {
        $this.shape = [Vector2]::new(0,0,0,$true)
        $this.End = [Vector2]::new(0,1,0,$true) 
        $this.rotation = 0
        $this.Start = [Vector2]::new(0,0,0,$false)
    }

}

class map {
    [int]$x=60
    [int]$y=60
    [Vector2]$staringPos=$null
    #[MapCell[]]$mapCells=$null
    [track[]]$tracks = [track]::new($trackTemplates["0000"]) #Init start track

    #map() {
    #    for ($i = 1; $i -le $this.x; $i++)
    #    { 
    #        for ($j = 1; $j -le $this.y; $j++)
    #        { 
    #            $this.mapCells+=[MapCell]::new($i,$j)
    #        }
    #    }
    #}
    [void] setStartPoint(){
        $this.staringPos = [Vector2]::new(($this.x/2),($this.y/2))
        $this.tracks[0].move($this.staringPos.x,$this.staringPos.y)
    }

    [boolean] BuildTrack([track]$track) {
        #last track
        $LastTrack = $this.tracks[$this.tracks.Length - 1]

        $TmpNewTrack=$track
        $TmpNewTrack.setRotation($LastTrack.End.dir) #Set new track rotation
        $TmpNewTrack.Move($LastTrack.End.x,$LastTrack.End.y) #Move track to end position

        if ((@($this.tracks,$TmpNewTrack).shape | group -Property x,y).where({$psitem.Count -gt 1})) {
            return $false
        } else {
            $this.tracks+=$TmpNewTrack
            return $true
        }
    }
    [int] getDelta() {
        
        $LastTrack = $this.tracks[$this.tracks.Length - 1]
        $firstTrack = $this.tracks[0]

        $xDiff = [math]::Sqrt([math]::pow($LastTrack.End.x - $firstTrack.Start.x,2))
        $yDiff = [math]::Sqrt([math]::pow($LastTrack.End.y - $firstTrack.Start.y,2))

        $Delta = $yDiff + $xDiff 
        #$Delta = ($LastTrack.End.x - $firstTrack.Start.x) - ($LastTrack.End.y - $firstTrack.Start.y)

        return $Delta
    }
    [bool] testLoop() {

        $LastTrack = $this.tracks[$this.tracks.Length - 1]
        $firstTrack = $this.tracks[0]

        $xDiff = [math]::Sqrt([math]::pow($LastTrack.End.x - $firstTrack.Start.x,2))
        $yDiff = [math]::Sqrt([math]::pow($LastTrack.End.y - $firstTrack.Start.y,2))
        $sameX=$false
        $sameY=$false
        if ($LastTrack.End.x -eq $firstTrack.Start.x) {
            $sameX=$true
        }
        if ($LastTrack.End.y -eq $firstTrack.Start.y) {
            $sameY=$true
        }
        

        $Delta = $yDiff + $xDiff 
        #if ($Delta -le 1 -and ((($LastTrack.end.dir + 2) % 4) -eq $firstTrack.Start.dir) -and $this.tracks.Count -gt 1) {
        if ($Delta -eq 0 -and ($LastTrack.end.dir -eq $firstTrack.Start.dir) -and $this.tracks.Count -gt 1) {
            if (($sameY -and $LastTrack.end.dir -in @(3,1)) -or ($sameX -and $LastTrack.end.dir -in @(0,2))) {
                return $true
            } else {
                return $false
            }
        } else { 
            return $false
        }
    }
}


$trackTemplates = @{
    "0000" = @( #Part1
        0,0,0,1 #Shape
        0,1,0,0
        0,2,0,0

        0,0,0,0 #Start
        0,3,1,1 #End

        0 #Rotation
    )
    "0001" = @( #LeftTurn
        0,0,0,1
        0,1,0,0
        -1,1,0,0
    
        0,0,0,0
        -2,1,3,1
    
        0
    )
    "0010" = @( #RightTurn
        0,0,0,1
        0,1,0,0
        1,1,0,0
    
        0,0,0,0
        2,1,1,1
    
        0
    )
    "0011" = @( #Line
        0,0,0,1
        0,1,0,0
        0,2,0,0
    
        0,0,0,0
        0,3,0,1
    
        0
    )
    "0100"=@( #S curve left
        0,0,0,1
        0,1,0,0
        -1,1,0,0
        -1,2,0,0
    
        0,0,0,0
        -1,3,0,1
    
        0
    )
    "0101"=@( #Big right
        0,0,0,1
        0,1,0,0
        1,1,0,0
        1,2,0,0
        2,2,0,0
    
        0,0,0,0
        3,2,1,1
    
        0
    )
    "0110"=@( #Big left
        0,0,0,1
        0,1,0,0
        -1,1,0,0
        -1,2,0,0
        -2,2,0,0
    
        0,0,0,0
        -3,2,3,1
    
        0
    )
    "0111"=@( #S curve right
        0,0,0,1
        0,1,0,0
        1,1,0,0
        1,2,0,0
    
        0,0,0,0
        1,3,0,1
    
        0
    ) 
    "1000"=@( #U turn right
        0,0,0,1
        0,1,0,0
        -1,1,0,0
        -2,1,0,0
        -2,0,0,0

        0,0,0,0
        -2,-1,2,1
    
        0
    ) 
    "1001"=""
    "1010"=""
    "1011"=""
    "1100"=""
    "1101"=""
    "1110"="" #%
    "1111"=""
}

#$gene = "00000000000001110000101"


#$map=getFitness -gene "0000000000011001101111110110111101101010001110010110110100010001100100010" -outObj

function getFitness {
param ($gene,
[switch]$outObj,
$targetTracks
)
    #Create genebank
    [string[]]$geneSeq=$gene -split "(\w{4})" | ? {$_}
    
    [int]$Fitness=0

    #Sandbox map
    $TMPmap = [map]::new()
    $TMPmap.setStartPoint()
    
    try {
        $geneSeq.ForEach({
            if ($trackTemplates[$PSItem] -ne "") {
                $TmpTrack=[track]::new($trackTemplates[$PSItem])
                if ($TMPmap.BuildTrack($TmpTrack) -eq $false) {
                    $Fitness=0
                    throw
                }
                $Fitness+=6
            }
        })
    } catch { $Fitness-=14 }


    $xMaxMin=($TMPmap.tracks.shape.x) | measure -Maximum -Minimum
    $yMaxMin=($TMPmap.tracks.shape.y) | measure -Maximum -Minimum

    #Big aria bonus
    $Fitness+=(($xMaxMin.Maximum - $xMaxMin.Minimum) + ($yMaxMin.Maximum - $yMaxMin.Minimum))*3

    #shape count bonus
    $fitness+=$TMPmap.tracks.shape.count*1.5

    #$targetTracks = 14 # move to parameter
    $trackDiff = $targetTracks - (($TMPmap.tracks.Count + $TMPmap.tracks.shape.Count) / 2)
    $trackDiff = [math]::Sqrt([math]::Pow($trackDiff,2)) #Normalize

    $Fitness-=$trackDiff
    if ((($TMPmap.tracks.Count + $TMPmap.tracks.shape.Count) / 2) -lt ($targetTracks/2)) { $Fitness/=4 } #

    if ($TMPmap.getDelta() -gt 20) { $Fitness -= 20 + $TMPmap.getDelta() }
    if ($TMPmap.getDelta() -lt 20) { 
        $Fitness += (20 - $TMPmap.getDelta()) * (20 - $TMPmap.getDelta())
        $Fitness += $TMPmap.tracks.Count
        }
    if ($TMPmap.testLoop() -eq $true) {$Fitness += 1000}

    ##diff rightleft turns
    if ($outObj) {
        return $TMPmap
    } else {
        return $Fitness
    }
}

#GetFitness -gene $gene

#$map = [map]::new()
#$map.setStartPoint()
#
#Remove-Variable newRandomTrack
#$newRandomTrack=[track]::new($trackTemplates[(get-random ([string[]]$($trackTemplates.Keys)))])
#$map.BuildTrack($newRandomTrack)
#$map.getDelta()
#$map.testLoop()
#
#
##$map.tracks.shape | ogv
#
#$newRandomTrack = [track]::new($trackTemplates["Line"])
#$newRandomTrack=[track]::new($trackTemplates[(get-random ([string[]]$($trackTemplates.Keys)))])
#$map.BuildTrack($newRandomTrack)
#        
        
        

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

#function getFitness {
#param([string[]]$gene,[float]$goal)
#    $rc=$gene -split "(\w{4})" | ? {$_}
#    [string]$tmpFormula=$rc.ForEach({$options["$psitem"]}) -join ""
#    $calc="`$r=", $tmpFormula -join ""
#
#    if (($tmpFormula -split ("([*/%X]{2,})|(^[*/%X])|([*/%X]$)|(X)")).count -gt 1) { #Calculation error avoidance
#        $r=0
#        write-host "Error avoided " -ForegroundColor Green -NoNewline
#        write-host $calc
#    } else {
#
#        try { Invoke-Expression $calc -ErrorAction SilentlyContinue } catch { $r=0 }
#        try {
#            if ($r.ToString() -eq "¤¤¤") {
#                $r=0
#                write-host "inf " -ForegroundColor Red -NoNewline
#                write-host $calc
#            }
#        } catch {
#            $r=0
#            write-host "Error " -ForegroundColor Red -NoNewline
#            write-host $calc
#        }
#    }
#    #write-host $r
#    
#    $ggsa=$goal-$r
#    [float]$fit=($ggsa/$goal)*100
#    if ($fit -lt 0) {$fit=-($fit)}
#    if ((100-$fit) -lt 0) {[float]$fit=99}
#    $ru=(100-$fit)
#    #write-host $ru
#    if ($ru -eq 0) {$ru=1}
#    $gCompR=gComp -ref $goal -org $r
#    #write-host $gCompR -f Cyan
#
#    [string[]]$BlendOptions=@("0","1","2") #"0","1","2"
#    $blendR=Get-Random $BlendOptions #Random fitnessblend
#    if ($gCompR -ne -1) {
#        if ($blendR -eq "1") { #mix
#            $ru=($ru+$gCompR)/2
#            #Write-Host "avg mix" -ForegroundColor Yellow
#        } elseif ($blendR -eq "2") { #Use right
#            $ru=$gCompR
#            #Write-Host "By position" -ForegroundColor Yellow
#        } else { #Use left
#            #$ru=$ru
#            #Write-Host "By math" -ForegroundColor Yellow
#        }
#    }
#    #write-host $ru
#    if ($ru -gt 25) { #substract penalty for using *0 or +0 ops
#        $tmpScount=($calc -split "(([^\d]0\*)|(\*0)|(\+0)|([^\d]0\+))|(\/1[^\d])|(\/1$)|([^\d]\+\d)|(\*1[^\d])|(\*1$)|([\+\-])\1|($goal)" | ? {$_}).count
#        if ($tmpScount -gt 1) {
#            $ru -= ($tmpScount * 0.5) 
#        }
#        $tmpeScount=0
#        $tmpeScount=($calc -split "[\+\-\*\\\%]" | ? {$_}).count
#        $ru += ($tmpeScount*0.5) #Add bonus for using operators
#    }
#
#    $e=[math]::E
#    $po=[math]::Pow($e,-(($ru/10)-5))
#    $ru=(1/(1+$po*7))*100
#
#    return $ru
#}

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
        $r | Add-Member -MemberType NoteProperty -Name Fitness -Value (getFitness -gene $PSItem -targetTracks $targetTracks)
        return $r
    })
    write-progress -id  1 -Completed -Activity "Calc fitness"
    return $newPop
}

$spopSize=30 #initial population size
$popSize=20 #Population size
$targetTracks=40 #avg trackparts + Trackcells
$nGenes=(4*$targetTracks) #each character requires four genes #defailt 20
$mrate=14 #Mutation rate
$xrate=800 #Crossover rate
$complexitivity=500 # 0 - 700 , 400 simple 

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
[object[]]$timeLine = $null

$timeLine+=while ($best.Fitness -lt 1000 + $complexitivity) {
    if ($mrate -gt 50 -or (($CGen%5) -eq 0)) {
        $script:popSize += [math]::Floor($popSize * 0.20)
        $script:nGenes += 4*1
        $pop+=getFirstPopulation -size $spopSize -nGenes $nGenes
    }

    $robj=New-Object System.Object
    $CGen++
    $newPop=CalcFitness -pop $pop -goal $goal
    write-host "Top 4 best chromosomes"
    write-host (($newPop | sort -Descending -Property Fitness | select -First 4).DNA  -join "`n")
    $best=$newPop | sort -Property Fitness -Descending | select -First 1
    $rc=$best.DNA -split "(\w{4})" | ? {$_}
    #$tcalc="`$r=", ($rc.ForEach({$options["$psitem"]}) -join "") -join ""
    Write-host ("Current generation : {0}" -f $CGen) -f cyan
    Write-Host ("Popilation size : {0}" -f ($newPop).count)
    #Write-Host ("Calculation formula : {0}" -f $tcalc)
    #try {Invoke-Expression -Command $tcalc } catch { $r = "Error" }
    #write-host ("Calculation result : {0}" -f $r) -ForegroundColor Green
    Write-Host ("Current best fitness : {0}" -f $best.Fitness) -f magenta
    $robj | Add-Member -MemberType NoteProperty -Name Fitness -Value $best.Fitness
    $robj | Add-Member -MemberType NoteProperty -Name Formulat -Value $tcalc
    $robj | Add-Member -MemberType NoteProperty -Name Time -Value (get-date)
    Write-Host ("Mutation rate {0}" -f $mrate)
    [string[]]$pop=($newPop.Where({$psitem.Fitness -gt 10}) | sort -Property Fitness -Descending | select -First (get-random -Minimum 2 -Maximum $newPop.Count)).DNA #surving 
    write-host ("Surving creatures : {0}" -f $pop.Count ) -ForegroundColor Green
    $tmpResize=(get-random -Minimum 0 -Maximum 20)
    do
    { 
        try {
            write-progress -id  2 -activity "Generating new popilation" -status 'Progress' -percentcomplete (($pop.Count/($popSize + $tmpResize))*100)
        } catch {}
        $Childs=mate -newPop $newPop -xrate $xrate
        $Childs=$Childs.ForEach({Mutate -gene $PSItem -mRate $mrate})
        $pop+=$Childs
    }
    until ($pop.Count -ge ($popSize + $tmpResize))
    #inbreeding detect
    [int]$CloneChilds=($pop | sort).count - ($pop | sort | Get-Unique).count
    if ($CloneChilds -gt 2) { #Increase mutation
        write-host "Warning inbreeding! Increasing mutation" -f yellow
        $Script:mrate += [math]::Floor($CloneChilds / 2)
    } elseif ($CloneChilds -lt 2 -and $mrate -gt 14) { #Decrease mutation
        $Script:mrate = [math]::Floor($mrate / 2)
    }
    $pop = $pop | sort | Get-Unique #Clean Clones

    write-progress -id 2 -Completed -Activity "Generating new popilation"
    Write-Output $robj
}

$timeLine | ogv


(getFitness -targetTracks $targetTracks -gene $best.dna -outObj).testLoop()
$bestTrackObj = (getFitness -targetTracks $targetTracks -gene $best.dna -outObj)
$bestTrackObj.tracks.shape | ogv


#($newPop | sort -Descending -Property Fitness | select -First 4).DNA.foreach({
#    $btobj = (getFitness -targetTracks $targetTracks -gene $psitem -outObj)
#    $btobj.tracks.shape | ogv
#})