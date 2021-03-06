﻿param(
[switch]$Debug
)
#Todo melt snow and distribute left and right
function write-c {
    param(
        $word="Test",
        [ValidateSet("Black","Blue","Cyan","DarkBlue","DarkCyan","DarkGray","DarkGreen","DarkMagenta","DarkRed","DarkYellow","Gray","Green","Magenta","Red","White","Yellow")]$wrColor="Cyan",
        [ValidateSet("Black","Blue","Cyan","DarkBlue","DarkCyan","DarkGray","DarkGreen","DarkMagenta","DarkRed","DarkYellow","Gray","Green","Magenta","Red","White","Yellow")]$Color="Green"
    )
    $wordLen=$Word.Length
    $y=[console]::CursorTop
    $offY = [console]::WindowTop
    $x=[console]::CursorLeft
    for ($i = 0; $i -lt $wordLen; $i++)
    { 
        if ($Word[$i] -eq " ") {$pen=4} else {$pen=0}
        for ($is = 1; $is -lt (Get-Random -Minimum 3 -Maximum (10 - $pen)); $is++)
        { 
            [console]::setcursorposition($x,$y) #$offY+
            write-host ("{0}" -f [char]$(get-random -Minimum 32 -Maximum 122)) -ForegroundColor $wrColor -NoNewline
     
        }
        [console]::setcursorposition($x,$y)
        write-host ("{0}" -f [char]$($Word[$i])) -ForegroundColor $Color -NoNewline
        $x++
    }
    write-host ""
}

$ct=[console]::CursorTop
$cl=[console]::CursorLeft
$wt = [console]::WindowTop
$wl=[console]::WindowLeft
$wh=[console]::WindowHeight
$ww=[console]::WindowWidth
[console]::CursorVisible = $false

prompt ""

if ($Debug) {
    write-host $ct
    write-host $cl
    write-host $wt
    write-host $wl
    write-host $wh
    write-host $ww
}

$left=0
$right=($ww - 1)
$top=$wt
$bottom=($wt + $wh - 1)

$logi=0
$logL=$left + 1
$logT=$top + 3 + $logi

[console]::setcursorposition($logL,$logT)
#write-c -word "------------------------------" -wrColor DarkCyan -Color Cyan
if ($logi -lt ($bottom -5)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi
[console]::setcursorposition($logL,$logT)
write-c -word "Starting program : Altitude365 Snow" -wrColor Red -Color Cyan
if ($logi -lt ($bottom -5)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi


[console]::setcursorposition($logL,$logT)
write-c -word "Write window corners" -wrColor Red -Color Cyan
if ($logi -lt ($bottom -5)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi

[console]::setcursorposition($left,$wt)
write-host "o" -ForegroundColor Red -NoNewline
[console]::SetWindowPosition(0,$wt)

[console]::setcursorposition($right,$wt)
write-host "o" -ForegroundColor Red -NoNewline
[console]::SetWindowPosition(0,$wt)

[console]::setcursorposition($right,$bottom)
write-host "o" -ForegroundColor Red -NoNewline
[console]::SetWindowPosition(0,$wt)

[console]::setcursorposition($left,$bottom)
write-host "o" -ForegroundColor Red -NoNewline
[console]::SetWindowPosition(0,$wt)

[console]::SetWindowPosition(0,$wt)
[console]::setcursorposition($logL,$logT)
write-c -word "Set window position" -wrColor Red -Color Cyan
if ($logi -lt ($bottom -5)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi

[console]::setcursorposition($logL,$logT)
write-c -word "Clear screen" -wrColor Red -Color Cyan
if ($logi -lt ($bottom -5)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi

for ($x = $left; $x -lt ($right + 1); $x++)
{ 
    for ($y = $top; $y -lt ($bottom + 1); $y++)
    { 
        try {
        [console]::setcursorposition($x,$y)
        write-host " " -NoNewline
        } catch {}
    }
}
try {
    [console]::SetWindowPosition(0,$wt)

$f="      ``/oooooooo+.                  ``    ````````````  ``  ````````````            ``````       `````````` ..:. :..`` /..  "

    [console]::setcursorposition($left + 3,$top + 3)
} catch {}
if ($f.Length -gt $right) {  
    write-host "Merry Christmas Altitude365"
} else {
write-host "Merry Christmas"
write-host "                                                                                                     "
write-host "         ``:/++/:.                                                                       ````    ``  `````` "
write-host $f
write-host "  .-::+ooo:.``-+ooo///:.     ``sy.   .h``  ``++oh++: y: ++oh++/ y:    o/ ``ho+++o:`` ``d+++/ ``.:.``/``.: .``-. "
write-host "``+oooooo:.-.``:.-+oooooo/    so/h``  .N.     :m    m/   -m``   m/    yo ``m.   .yy ``M``````  ..-. -... ..-`` "
write-host "/ooooooo+oo-``oo+oooooooo``  oh-.yy  .N.     :m    m/   -m``   m/    yo ``m.    :m ``M+++-                "
write-host ".oooooooooo-``oooooooooo:  /d/::/ho .N.     :m    m/   -m``   ys   ``d: ``m.   :h/ ``M``                   "
write-host "  -:///////.``////////-``  ``s.    ``s.``soooo`` -s    s-   .o    ``/oo+o-  ``soo++:``  ``yooo+``               "
}
#for ($y = $top; $y -lt ($bottom + 1); $y++)
#{ 
#    for ($x = $left; $x -lt ($right + 1); $x++)
#    { 
#        [console]::setcursorposition($x,$y)
#        write-host " " -NoNewline
#    }
#}
try {
    [console]::SetWindowPosition(0,$wt)
} catch {}

function createNewSnowflage {
    $randomStart=Get-Random -Minimum $left -Maximum $right

}

function testFlage {
    $randomStart=Get-Random -Minimum $left -Maximum $right
    $r=New-Object System.Object
    $r | Add-Member -MemberType NoteProperty -Name ID -Value ([guid]::NewGuid())
    $r | Add-Member -MemberType NoteProperty -Name X -Value $randomStart
    $r | Add-Member -MemberType NoteProperty -Name y -Value $top
    $r | Add-Member -MemberType NoteProperty -Name Stoped -Value $false
    $dsr=(get-random -min 0 -max 5)
    $r | Add-Member -MemberType NoteProperty -Name Density -Value ($dsr + 1)
    $r | Add-Member -MemberType NoteProperty -Name Skin -Value $(@("·","•","*","☼","*"))[$dsr]
    return $r
}

[object[]]$snowflakes=testFlage
$snowflakes+=testFlage
$snowflakes+=testFlage
$snowflakes+=testFlage
$snowflakes+=testFlage
$snowflakes+=testFlage
#$snowflakes+=testFlage
#$snowflakes+=testFlage
#$snowflakes+=testFlage
#$snowflakes+=testFlage

while (1) {
try {
    [console]::SetWindowPosition(0,$wt)
} catch {}
$snowflakes+=testFlage
#$snowflakes+=testFlage

$snowflakes.where({$psitem.Stoped -eq $false}).where({
    $gr=Get-Random -Minimum 1 -Maximum 10
    if ($gr -lt 6) {
        $gr2=Get-Random -Minimum 1 -Maximum 6
            if ($gr2 -le $psitem.Density) {$true} else {$false} #Slowdown random
        } else {
            $true
        } #Slowdown random
    }).ForEach({
    if (-not $Debug) {
    }
    $id=$psitem.id
    $oldx=$psitem.x
    $oldy=$psitem.y
    if ($Debug) {
        [console]::setcursorposition($left,$top)
        write-host "Old " -BackgroundColor White -ForegroundColor Black
        write-host "x " $oldx -BackgroundColor White -ForegroundColor Black
        Write-Host "y " $oldy -BackgroundColor White -ForegroundColor Black
        write-host "t " $top -BackgroundColor White -ForegroundColor Black
        write-host "l " $left -BackgroundColor White -ForegroundColor Black
        write-host "r "  $right -BackgroundColor White -ForegroundColor Black
        write-host "b "  $bottom -BackgroundColor White -ForegroundColor Black
    }
    $out=$false
    $down=$false
    $optdir=@(1,2,3)
    $dir=Get-Random $optdir
    switch ($dir)
    {
        1 {
            #left
            $newx=$oldx - 1
            $newy=$oldy + 1
        }
        2 {
            #right
            $newx=$oldx + 1
            $newy=$oldy + 1
        }
        3 {
            #down
            $newx=$oldx + 0
            $newy=$oldy + 1
        }
    }
    if ($Debug) {
        [console]::setcursorposition($left,$top + 8)
        write-host "new " -BackgroundColor White -ForegroundColor Black
        write-host "x " $newx -BackgroundColor White -ForegroundColor Black
        Write-Host "y " $newy -BackgroundColor White -ForegroundColor Black
        write-host "Number of objects " $snowflakes.Count -BackgroundColor White -ForegroundColor Black

    }
    ##Within boundarys
    if ($newx -lt $left) { # Left
        $out=$true
    }
    if ($newx -gt $right) { # right
        $out=$true
    }
    if ($newy -gt $bottom) { # Down
        $newx=$PSItem.x
        $newy=$PSItem.y
        $down=$true
    }
    function hitCalc { 
    param (
        $rrr
    )
        $newy = $rrr.newy
        $newx = $rrr.newx
        $psitem = $rrr.psitem
        $down = $rrr.down

        $rrr=new-object System.Object
        $stFlag=$snowflakes.where({($psitem.x -eq $newx) -and ($psitem.y -eq $newy) -and ($psitem.Stoped -eq $true)})
        if ($stFlag.Count -gt 0) { #Hit a stopped snowflage
            if (($stFlag.Density | measure -Sum).Sum -gt 21) {
                #Write-Host "MGL!!" $newy -ForegroundColor Blue
                #[console]::setcursorposition($left,$top + 8)
                #write-host "Loop newy" $newy (Get-Date) -BackgroundColor White -ForegroundColor Black
                $newy=$newy-1
                #$newx=$newx
                #Write-Host "MGL!!" $newy -ForegroundColor Green
 
                $rrr | Add-Member -MemberType NoteProperty -Name newy -Value $newy -Force
                $rrr | Add-Member -MemberType NoteProperty -Name newx -Value $newx -Force
                $rrr | Add-Member -MemberType NoteProperty -Name psitem -Value $psitem -Force
                $rrr | Add-Member -MemberType NoteProperty -Name down -Value $down -Force
                $rrr = hitCalc -rrr $rrr  
                $newx = $rrr.newx
                $newy = $rrr.newy
                $psitem = $rrr.psitem
                $down = $rrr.down    
            } else {
                #merge
                #[console]::setcursorposition($left,$top + 8)
                #write-host "merge " -BackgroundColor White -ForegroundColor Black
                switch (($stFlag.Density | measure -Sum).Sum)
                {
                    {$_ -le 5} {$nsk = "▄"}
                    {$_ -gt 5 -and $_ -le 10} {$nsk = "░"} #░
                    {$_ -gt 10 -and $_ -le 14} {$nsk = "▓"} #▓
                    {$_ -gt 14} {$nsk = "█"}
                }
                $psitem.Skin=$nsk #Behöver säkert returna denna också för att få rätt skin.
                $down=$true #säkert return down. Många variabler kommer inter ur funkltionen.
            }
        } else {
            #toplevel
            $down=$true
            #[console]::setcursorposition($left,$top + 2)
            #write-host "TTLLLLLLLLLLLLLLLLLLLLLL" $newy (Get-Date) -BackgroundColor White -ForegroundColor Black
        }
        $rrr | Add-Member -MemberType NoteProperty -Name newy -Value $newy -Force
        $rrr | Add-Member -MemberType NoteProperty -Name newx -Value $newx -Force
        $rrr | Add-Member -MemberType NoteProperty -Name psitem -Value $psitem -Force
        $rrr | Add-Member -MemberType NoteProperty -Name down -Value $down -Force
        #[console]::setcursorposition($left,$top + 5)
        #write-host "Exit" $newy (Get-Date) -BackgroundColor White -ForegroundColor Black
        #write-host "Exit" $down (Get-Date) -BackgroundColor White -ForegroundColor Black
        #write-host "Exit" $psitem.Skin (Get-Date) -BackgroundColor White -ForegroundColor Black
        return $rrr
    }

    $stFlag=$snowflakes.where({($psitem.x -eq $newx) -and ($psitem.y -eq $newy) -and ($psitem.Stoped -eq $true)}) 
    if ($stFlag.Count -gt 0) {
        #if (($stFlag.Density | measure -Sum).Sum -gt 16) {
            $rrr=new-object System.Object
            $rrr | Add-Member -MemberType NoteProperty -Name newy -Value $newy -Force
            $rrr | Add-Member -MemberType NoteProperty -Name newx -Value $newx -Force
            $rrr | Add-Member -MemberType NoteProperty -Name psitem -Value $psitem -Force
            $rrr | Add-Member -MemberType NoteProperty -Name down -Value $down -Force
            $rrr=hitCalc -rrr $rrr
            $newx = $rrr.newx
            $newy = $rrr.newy
            $psitem = $rrr.psitem
            $down = $rrr.down
            #[console]::setcursorposition($left,$top + 8)
            #write-host "Exit" $newy (Get-Date) -BackgroundColor White -ForegroundColor red
            #write-host "Exit" $down (Get-Date) -BackgroundColor White -ForegroundColor red
            #write-host "Exit" $psitem.Skin (Get-Date) -BackgroundColor White -ForegroundColor red
      
        #}
    }

    if ($down) {
        $psitem.Stoped = $true
        #$psitem.Skin = "▄"
        #▄░▓█

        #[console]::setcursorposition($logL,$logT)
        #write-c -word "Down!" -wrColor DarkCyan -Color Cyan
        #if ($logi -lt ($bottom -3)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi
        #WriteStopped
        try {
            [console]::setcursorposition($newx,$newy)
            write-host ("{0}" -f $psitem.Skin) -NoNewline -ForegroundColor White
        } catch {}

    }

    if ($out -eq $false) {
        #remove old
        try {
            [console]::setcursorposition($oldx,$oldy)
            write-host " " -NoNewline
        } catch {}
        #writeNew
        try {
            [console]::setcursorposition($newx,$newy)
            write-host ("{0}" -f $psitem.Skin) -NoNewline -ForegroundColor White
        } catch {}
        #write-host ("*" -f $psitem.Skin) -NoNewline -ForegroundColor White
        #Update flage posistion
        $psitem.x=$newx
        $psitem.y=$newy
    } else {
        #remove old
        try {
            [console]::setcursorposition($oldx,$oldy)
            write-host " "
        } catch {}
        if ($Debug) {
            write-host "X" -NoNewline -ForegroundColor Red
        }
        $snowflakes=$snowflakes.Where({$PSItem.id -ne $id})
        #[console]::setcursorposition($logL,$logT)
    }

})
    #dont run every time
    
    $cmd = {
    param([object[]]$sn)
        [object[]]$moveR=$sn.where({$psitem.Stoped -eq $true}).where({
            $xu=$PSItem.x
            $yu=$PSItem.y

            if (($sn.Where({$PSItem.x -eq ($xu + 1) -and $PSItem.y -eq ($yu - 1)}).Density | measure -Sum).Sum -eq 0 ) {             
            #    if (($sn.Where({$PSItem.x -eq ($xu - 1) -and $PSItem.y -eq ($yu - 1)}).Density | measure -Sum).Sum -eq 0 ) {
                    if (($sn.Where({$PSItem.x -eq ($xu + 1) -and $PSItem.y -eq ($yu - 0)}).Density | measure -Sum).Sum -eq 0 ) {
            #            if (($sn.Where({$PSItem.x -eq ($xu - 1) -and $PSItem.y -eq ($yu - 0)}).Density | measure -Sum).Sum -eq 0 ) {
                            (($sn.Where({$PSItem.x -eq ($xu + 0) -and $PSItem.y -eq ($yu + 1)}).Density | measure -Sum).Sum -gt 16) -and
                            (($sn.Where({$PSItem.x -eq ($xu + 0) -and $PSItem.y -eq ($yu - 1)}).Density | measure -Sum).Sum -eq 0)
                        } else { $false }
            #        } else { $false }
            #    } else { $false }
            } else { $false }
        }) | select * -First (Get-Random -Minimum 4 -Maximum 15)

        [object[]]$moveL=$sn.where({$psitem.Stoped -eq $true}).where({
            $xu=$PSItem.x
            $yu=$PSItem.y

            #if (($sn.Where({$PSItem.x -eq ($xu + 1) -and $PSItem.y -eq ($yu - 1)}).Density | measure -Sum).Sum -eq 0 ) {             
                if (($sn.Where({$PSItem.x -eq ($xu - 1) -and $PSItem.y -eq ($yu - 1)}).Density | measure -Sum).Sum -eq 0 ) {
            #        if (($sn.Where({$PSItem.x -eq ($xu + 1) -and $PSItem.y -eq ($yu - 0)}).Density | measure -Sum).Sum -eq 0 ) {
                        if (($sn.Where({$PSItem.x -eq ($xu - 1) -and $PSItem.y -eq ($yu - 0)}).Density | measure -Sum).Sum -eq 0 ) {
                            #if (($sn.Where({$PSItem.x -eq ($xu + 1) -and $PSItem.y -eq ($yu + 1)}).Density | measure -Sum).Sum -eq 0 ) {
                                #if (($sn.Where({$PSItem.x -eq ($xu - 1) -and $PSItem.y -eq ($yu + 1)}).Density | measure -Sum).Sum -eq 0 ) {
                                    (($sn.Where({$PSItem.x -eq ($xu + 0) -and $PSItem.y -eq ($yu + 1)}).Density | measure -Sum).Sum -gt 16) -and
                                    (($sn.Where({$PSItem.x -eq ($xu + 0) -and $PSItem.y -eq ($yu - 1)}).Density | measure -Sum).Sum -eq 0)
                                    #(($sn.Where({$PSItem.x -eq ($xu) -and $PSItem.y -eq ($yu)}).Density | measure -Sum).Sum -gt 16)
                                #} else { $false }
                            #} else { $false }
            #            } else { $false }
            #       } else { $false }
                } else { $false }
            } else { $false }
        }) | select * -First (Get-Random -Minimum 4 -Maximum 15)

        $rtemp = $moveR.foreach({
            $snowflakesChange=New-Object System.Object
            $tempID=$PSItem.ID
            $PSItem.x++
            $PSItem.Stoped = $false
            $snowflakesChange | Add-Member -MemberType NoteProperty -Name ID -value $tempID
            $snowflakesChange | Add-Member -MemberType NoteProperty -Name x -Value $PSItem.x
            $snowflakesChange | Add-Member -MemberType NoteProperty -Name y -Value $PSItem.y
            return $snowflakesChange
        })
        $rtemp += $moveL.foreach({
            $snowflakesChange=New-Object System.Object
            $tempID=$PSItem.ID
            $PSItem.x--
            $PSItem.Stoped = $false
            $snowflakesChange | Add-Member -MemberType NoteProperty -Name ID -value $tempID
            $snowflakesChange | Add-Member -MemberType NoteProperty -Name x -Value $PSItem.x
            $snowflakesChange | Add-Member -MemberType NoteProperty -Name y -Value $PSItem.y
            return $snowflakesChange
        })

        return $rtemp
    } #cmd end
    if (-not (Get-Job)) {
        try {
            Start-Job -ScriptBlock $cmd -ArgumentList (,$snowflakes)  | Out-Null
        } catch {}
        
    }

    [object[]]$jobs=Get-Job
    $gj=$jobs.where({ $psitem.State -eq "Completed"})
    if ($gj) {
        $gj | % { 
            [object[]]$snowflakesm=(Receive-Job $_.Id)
            $snowflakesm.ForEach({
                $newSFid=$PSItem.id
                $SFindex=$snowflakes.id.indexof($newSFid)
                #Write-host -ForegroundColor Yellow "AA"
                if ($SFindex -ne -1) {
                    #Write-host -ForegroundColor Green "FF"
                    $snowflakes[$SFindex].x = $PSItem.x
                    $snowflakes[$SFindex].y = $PSItem.y
                    $snowflakes[$SFindex].Stoped = $false
                    if ($Debug) {
                        try {
                            [console]::setcursorposition($PSItem.x,$PSItem.y)
                            write-host "Z" -ForegroundColor Red
                        }catch {}
                    }
                }
            })
            Remove-Job $_.Id 
        }
    }
}


#$cmd = {
#  param($a, $b)
#  Write-Host $a $b
#}
#
#$foo = "foo"
#
#1..5 | ForEach-Object {
#  Start-Job -ScriptBlock $cmd -ArgumentList $_, $foo
#}
#
#Get-Job | % { Receive-Job $_.Id; Remove-Job $_.Id }