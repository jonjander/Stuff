#
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
            sleep -Milliseconds 2
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

#write-host $ct
#write-host $cl
#write-host $wt
#write-host $wl
#write-host $wh
#write-host $ww

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
write-c -word "Starting program snow" -wrColor Red -Color Cyan
if ($logi -lt ($bottom -5)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi


[console]::setcursorposition($logL,$logT)
write-c -word "Write window" -wrColor Red -Color Cyan
if ($logi -lt ($bottom -5)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi

[console]::setcursorposition($left,$wt)
write-host "o" -ForegroundColor Red -NoNewline
[console]::SetWindowPosition(0,$wt)
sleep -Milliseconds 200

[console]::setcursorposition($right,$wt)
write-host "o" -ForegroundColor Red -NoNewline
[console]::SetWindowPosition(0,$wt)
sleep -Milliseconds 200

[console]::setcursorposition($right,$bottom)
write-host "o" -ForegroundColor Red -NoNewline
[console]::SetWindowPosition(0,$wt)
sleep -Milliseconds 200

[console]::setcursorposition($left,$bottom)
write-host "o" -ForegroundColor Red -NoNewline
[console]::SetWindowPosition(0,$wt)
sleep -Milliseconds 200

[console]::SetWindowPosition(0,$wt)
[console]::setcursorposition($logL,$logT)
write-c -word "Set windows position" -wrColor Red -Color Cyan
if ($logi -lt ($bottom -5)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi

[console]::setcursorposition($logL,$logT)
write-c -word "Clear screen" -wrColor Red -Color Cyan
if ($logi -lt ($bottom -5)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi
sleep -Milliseconds 200

for ($x = $left; $x -lt ($right + 1); $x++)
{ 
    for ($y = $top; $y -lt ($bottom + 1); $y++)
    { 
        [console]::setcursorposition($x,$y)
        write-host " " -NoNewline
    }
}
[console]::SetWindowPosition(0,$wt)

$f="      ``/oooooooo+.                  ``    ````````````  ``  ````````````            ``````       `````````` ..:. :..`` /..  "
[console]::setcursorposition($left + 3,$top + 3)
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
Sleep 10
#for ($y = $top; $y -lt ($bottom + 1); $y++)
#{ 
#    for ($x = $left; $x -lt ($right + 1); $x++)
#    { 
#        [console]::setcursorposition($x,$y)
#        write-host " " -NoNewline
#    }
#}
#[console]::SetWindowPosition(0,$wt)

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
    $r | Add-Member -MemberType NoteProperty -Name Density -Value 1
    $r | Add-Member -MemberType NoteProperty -Name Skin -Value "*"
    return $r
}

[object[]]$snowFlages=testFlage
$snowFlages+=testFlage
$snowFlages+=testFlage
$snowFlages+=testFlage
$snowFlages+=testFlage
$snowFlages+=testFlage
$snowFlages+=testFlage
#$snowFlages+=testFlage
#$snowFlages+=testFlage
#$snowFlages+=testFlage

Sleep 4
while (1) {
[console]::SetWindowPosition(0,$wt)
$snowFlages+=testFlage
#$snowFlages+=testFlage

$snowFlages.where({$psitem.Stoped -eq $false}).ForEach({
    sleep -Milliseconds 10
    $id=$psitem.id
    $oldx=$psitem.x
    $oldy=$psitem.y
    #[console]::setcursorposition($left,$top)
    #write-host "Old "
    #write-host "x " $oldx
    #Write-Host "y " $oldy
    #write-host "t " $top
    #write-host "l " $left
    #write-host "r "  $right
    #write-host "b "  $bottom
    $out=$false
    $down=$false
    $dir=Get-Random -Minimum 1 -Maximum 3
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
            $newy=$oldy + 1
        }
    }
    [console]::setcursorposition($left,$top + 8)
    #write-host "new "
    #write-host "x " $newx
    #Write-Host "y " $newy
    #sleep -Milliseconds 50
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
    $stFlag=$snowFlages.where({$psitem.x -eq $newx -and $psitem.y -eq $newy -and $psitem.Stoped -eq $true}) 
    if ($stFlag.Count -gt 0) { #Hit a stopped snowflage
        if (($stFlag.Density | measure -Sum).Sum -gt 10) {
            #Add layer
            $newx=$newx
            $newy=$newy-1
            $down=$true
            $psitem.Skin = "▄"
        } else {
            switch (($stFlag.Density | measure -Sum).Sum)
            {
                {$_ -le 3} {$nsk = "▄"}
                {$_ -gt 3 -and $_ -le 7} {$nsk = "░"}
                {$_ -gt 7 -and $_ -le 9} {$nsk = "▓"}
                {$_ -gt 9} {$nsk = "█"}
            }
            $psitem.Skin=$nsk
            #merge
            $down=$true
        }
    }

    if ($down) {
        $psitem.Stoped = $true
        #$psitem.Skin = "▄"
        #▄░▓█

        #[console]::setcursorposition($logL,$logT)
        #write-c -word "Down!" -wrColor DarkCyan -Color Cyan
        #if ($logi -lt ($bottom -3)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi
        #WriteStopped
        [console]::setcursorposition($newx,$newy)
        write-host ("{0}" -f $psitem.Skin) -NoNewline -ForegroundColor White

    }

    if ($out -eq $false) {
        #remove old
        [console]::setcursorposition($oldx,$oldy)
        write-host " " -NoNewline
        #writeNew
        [console]::setcursorposition($newx,$newy)
        write-host ("{0}" -f $psitem.Skin) -NoNewline -ForegroundColor White
        #write-host ("*" -f $psitem.Skin) -NoNewline -ForegroundColor White
        #Update flage posistion
        $psitem.x=$newx
        $psitem.y=$newy
    } else {
        #remove old
        [console]::setcursorposition($oldx,$oldy)
        write-host " "
        #write-host "X" -NoNewline -ForegroundColor Red
        $snowFlages=$snowFlages.Where({$PSItem.id -ne $id})
        [console]::setcursorposition($logL,$logT)
        #write-c -word "Out!" -wrColor DarkCyan -Color Cyan
        #sleep 1
        if ($logi -lt ($bottom -5)) {$logi++} else {$logi=0} ; $logT=$top + 3 + $logi
    }

})
}