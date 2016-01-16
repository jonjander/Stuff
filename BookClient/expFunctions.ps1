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

               
                ###TEst add
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
            {$key.key -eq "Backspace" -and $cPos -gt 0} {
                #[console]::SetCursorPosition($cuPosL - 1,$cuPosT)
                #Write-host " "
                #[console]::SetCursorPosition($cuPosL - 1,$cuPosT)
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
            {$key.key -eq "Delete"} {
                $editMode=$false
                write-host ""
                write-host ($Output -join "") -ForegroundColor Cyan
                break
            }
            {$key.key -eq "Enter"} {
                $editMode=$false
                write-host ""
                write-host ($Output -join "") -ForegroundColor Cyan
                break
            }
        }

    }


}

read-HostV2