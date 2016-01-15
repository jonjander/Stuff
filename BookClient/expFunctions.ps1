function Get-KeySilent
{
    if([console]::KeyAvailable){
            while([console]::KeyAvailable){
                  $key = [console]::readkey("noecho")}}
    else{$key = "nokey"}
    $key
}



function read-HostV2 {
    $cuPosL=[console]::CursorLeft
    $cuPosT=[console]::CursorTop
    $cPos=0
    [char[]]$Output="abcd"
    $wordStartLen=$Output.Length
    function WW {
            [console]::SetCursorPosition(0,$cuPosT)
            write-host ([string]$($Output -join ""))
            [console]::SetCursorPosition($cPos,$cuPosT)
        }
    WW
    
    [console]::SetCursorPosition($wordStartLen,$cuPosT) #Set Start pos to last char
    $editMode=$true
    while ($editMode) {
        
        $cPos=[console]::CursorLeft
        $cuPosL=[console]::CursorLeft
        $cuPosT=[console]::CursorTop
        $key=Get-KeySilent
        $Specialkeys=@("Enter","Nokey","LeftArrow","RightArrow","Delete","Backspace")

        
        switch ($key) {
            {$key.key -notin $Specialkeys -and $key.KeyChar.Length -eq 1} {
                #Write-host -NoNewline $key.KeyChar
                #write-host ($key | gm)
                

                ###TEst add
                $inc=0
                [char[]]$Output=$Output.ForEach({
                    $PSItem
                    if ($inc -eq $cPos -1) {
                        $key.KeyChar
                    }
                    $inc++
                })
                WW
                [console]::SetCursorPosition($cuPosL + 1,$cuPosT)

                #$Output+=$key.KeyChar
                #$cPos++
                break
            }
            {$key.key -eq "LeftArrow" -and $cuPosL -gt 0} {
                [console]::SetCursorPosition($cuPosL - 1,$cuPosT)
                break
            }
            {$key.key -eq "RightArrow" -and $cuPosL -lt $Output.Length} {
                [console]::SetCursorPosition($cuPosL + 1,$cuPosT)
                break
            }
            {$key.key -eq "Backspace"} {
                #[console]::SetCursorPosition($cuPosL - 1,$cuPosT)
                #Write-host " "
                #[console]::SetCursorPosition($cuPosL - 1,$cuPosT)
                $inc=0
                (0..($Output.Length)).ForEach({write-host " " -NoNewline})
                [char[]]$Output=$Output.ForEach({
                    if (-not ($inc -eq $cPos -1)) {
                        $PSItem
                    }
                    $inc++
                })

                WW
                [console]::SetCursorPosition($cuPosL - 1,$cuPosT)



                break
            }
            {$key.key -eq "Enter"} {
                
                break
            }
        }

    }


}

read-HostV2