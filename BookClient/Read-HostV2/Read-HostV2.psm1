function Get-KeySilent
{
    if([console]::KeyAvailable){
            while([console]::KeyAvailable){
                  $key = [console]::readkey("noecho")}}
    else{$key = "nokey"}
    $key
}

function read-HostV2 {
param (
    [char[]]$StartText="abcd"

)
    $cuPosL=[console]::CursorLeft
    $cuPosT=[console]::CursorTop
    $cPos=0
    [char[]]$Output=$StartText
    $wordStartLen=$Output.Length
    function WW {
            [console]::SetCursorPosition(0,$cuPosT)
            write-host ([string]$($Output -join "")) -NoNewline
            #Write-Host X -ForegroundColor Red
            [console]::SetCursorPosition($cPos,$cuPosT)
        }
    WW #Write initial input
    
    [console]::SetCursorPosition($wordStartLen,$cuPosT) #Set Start pos to last char
    $editMode=$true
    while ($editMode) {
        $cPos=[console]::CursorLeft
        $cuPosL=[console]::CursorLeft
        $cuPosT=[console]::CursorTop
        $key=Get-KeySilent
        $Specialkeys=@("Enter","Nokey","LeftArrow","RightArrow","Delete","Backspace","UpArrow","DownArrow")
        switch ($key) {
            {$key.key -notin $Specialkeys -and $key.KeyChar.Length -eq 1} { #Add
                $inc=0
                $Output=for ($inc = 0; $inc -lt $Output.Length + 1; $inc++)
                { 
                    if ($inc -eq $cPos) {
                        $key.KeyChar
                    }
                    $Output[$inc]
                }
                WW
                [console]::SetCursorPosition($cuPosL + 1,$cuPosT)
                break
            }
            {$key.key -eq "LeftArrow" -and $cuPosL -gt 0} { #Move Cursor left
                [console]::SetCursorPosition($cuPosL - 1,$cuPosT)
                break
            }
            {$key.key -eq "RightArrow" -and $cuPosL -lt $Output.Length} { #Mpve Cursor Right
                [console]::SetCursorPosition($cuPosL + 1,$cuPosT)
                break
            }
            {$key.key -eq "Backspace" -and $cPos -gt 0} { #Backspace Erase
                [console]::SetCursorPosition(0,$cuPosT) #clear old word
                (0..($Output.Length)).ForEach({write-host " " -NoNewline})
                $inc=0
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
            {$key.key -eq "Delete" -and $Output.Length -gt 0} { #Delete Erase
                [console]::SetCursorPosition(0,$cuPosT) #clear old word
                (0..($Output.Length)).ForEach({write-host " " -NoNewline})
                $inc=0
                [char[]]$Output=$Output.ForEach({
                    if (-not ($inc -eq $cPos)) {
                        $PSItem
                    }
                    $inc++
                })
                WW
                [console]::SetCursorPosition($cuPosL,$cuPosT)
                break
            }
            {$key.key -eq "Enter"} {
                $editMode=$false
                #write-host ""
                #write-host ($Output -join "") -ForegroundColor Cyan
                [console]::SetCursorPosition(0,$cuPosT)
                Write-Output ([string]$($Output -join ""))
                break
            }
        }

    }
}