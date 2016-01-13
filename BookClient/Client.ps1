[object[]]$Story=@("This is a test","This is test two","This is test 3")
$NumberOfParts=$Story.Count

cls

function Get-KeySilent
{
    if([console]::KeyAvailable){
            while([console]::KeyAvailable){
                  $key = [console]::readkey("noecho").Key}}
    else{$key = "nokey"}
    $key
}

function ReadFrom-Pos ($x, $y)
{
      if($x -ge 0 -and $y -ge 0 -and $x -le [Console]::WindowWidth -and
            $y -le [Console]::WindowHeight) {
      $y += [console]::WindowTop
      $r = New-Object System.Management.Automation.Host.Rectangle $x,$y,$x,$y
      $host.UI.RawUI.GetBufferContents($r)[0,0]
      }
}

#Get-KeySilent

#Init 
$end=New-Object psobject -Property @{
    "x" = 0
    "y" = 0
}

$wordLocalDB=""
$i=0
[console]::SetWindowPosition(0,([console]::CursorTop))
$WT=[console]::WindowTop

function reset-HelpText {
    [console]::setcursorposition(2,([console]::WindowTop + [console]::WindowHeight - 2))
    Write-Host -ForegroundColor DarkBlue -BackgroundColor White "." -NoNewline
    Write-Host  " Knife " -NoNewline
    Write-Host -ForegroundColor DarkBlue -BackgroundColor White "DEL" -NoNewline
    Write-Host  " Delete " -NoNewline
    Write-Host -ForegroundColor DarkBlue -BackgroundColor White "ENT" -NoNewline
    Write-Host  " Change " -NoNewline
}


function write-stry {
    [console]::SetWindowPosition(0,([console]::WindowTop + [console]::WindowHeight - 0))
    [console]::SetCursorPosition(0,[console]::WindowTop)
    $Story.ForEach({
        $len=$PSItem.count
        $CTS=[console]::CursorTop
        $CLS=[console]::CursorLeft
        Write-Host "$PSItem" -NoNewline
        Write-Host ". " -NoNewline
        $CTE=[console]::CursorTop
        $CLE=[console]::CursorLeft  
        $rtemp=New-Object psobject -Property @{
            "index"=$i
            "word"=$PSItem
            "CTS"=$CTS
            "CLS"=$CLS
            "CTE"=$CTE
            "CLE"=$CLE
        }
        $i++
        return $rtemp
    })
    reset-HelpText
}
[console]::SetWindowPosition(0,([console]::WindowTop + [console]::WindowHeight))
$wordLocalDB=write-stry

function Clean-inputArea {
    param ($pos)
    #Clean Input area
    [console]::setcursorposition(0,$pos)
    (1..([console]::WindowWidth)).foreach({Write-Host " " -NoNewline})
}


$WriteMode=$false
$wordSelected=0
$ISlastWord=$false
$wordChange=$true
$lastWord=0
#[console]::SetWindowPosition(0,([console]::WindowTop + [console]::WindowHeight - 1))

while (1) {
    $key=Get-KeySilent
    switch ($key) {
    {$key -ne "nokey" -and (ReadFrom-Pos -x 2 -y ([console]::WindowTop + [console]::WindowHeight - 2)).Character -ne "."} {
        reset-HelpText
    }
     {($key -eq "LeftArrow" -and $wordSelected -gt 0)} {
        [console]::setcursorposition($wordLocalDB[$NumberOfParts - 1].CLE,$wordLocalDB[$NumberOfParts - 1].CTE)
        Write-Host " " -NoNewline
        $ISlastWord=$false
        
        $ISlastWord=$false
        $wordSelected--
        $wordChange = $true
        break
     }
     {($key -eq "RightArrow" -and $wordSelected -lt ($NumberOfParts - 1))} {
        $ISlastWord=$false
        $wordSelected++
        $wordChange = $true
        break
     }
     {($key -eq "RightArrow" -and $wordSelected -eq ($NumberOfParts - 1))} {
        #add word.
        #$wordSelected++
        $ISlastWord=$true
        [console]::setcursorposition($wordLocalDB[$NumberOfParts - 1].CLE,$wordLocalDB[$NumberOfParts - 1].CTE)
        Write-Host ">" -ForegroundColor Red -NoNewline
        #$wordChange = $true
        break
     } 
     {$key -eq "Enter"} {
        [console]::setcursorposition(0,([console]::WindowTop + [console]::WindowHeight - 1))
        $pos = ([console]::WindowTop + [console]::WindowHeight - 1)
        $wt=[console]::WindowTop #Save pos
        $tmpNw=Read-Host ">"
        [console]::SetCursorPosition(0,$wt) #Load pos
        [console]::SetWindowPosition(0,$wt) #Load pos
        #Write-Host "rwed" -ForegroundColor Red
        Clean-inputArea -pos $pos #Clean Input area
        $tmpNw=$tmpNw -replace "\.",""
        if ($tmpNw -eq "") {
            $wordLocalDB=write-stry
            [console]::SetWindowPosition(0,([console]::WindowTop + [console]::WindowHeight - 1))
            [console]::setcursorposition($wordLocalDB[$wordSelected].CLS,$wordLocalDB[$wordSelected].CTS)
            write-host ("{0}." -f $wordLocalDB[$wordSelected].word) -BackgroundColor White -ForegroundColor DarkBlue -NoNewline
        } else {
            $Story[$wordSelected]=$tmpNw
            $wordLocalDB=write-stry
            [console]::SetWindowPosition(0,([console]::WindowTop + [console]::WindowHeight - 1))
            [console]::setcursorposition($wordLocalDB[$wordSelected].CLS,$wordLocalDB[$wordSelected].CTS)
            write-host ("{0}." -f $wordLocalDB[$wordSelected].word) -BackgroundColor DarkGreen -ForegroundColor DarkBlue -NoNewline
        }
        Break
     }
     {$key -ne "nokey" -and $key.ToString().Length -eq 1 -and $ISlastWord -eq $true} {
        #Write-Host -ForegroundColor Cyan $key.Length
        [console]::setcursorposition(0,([console]::WindowTop + [console]::WindowHeight - 1))
        Write-Host (">:{0}" -f $key) -NoNewline
        [string]$tmpNw=$key
        $pos = ([console]::WindowTop + [console]::WindowHeight - 1)
        $wt=[console]::WindowTop #Save pos
        $tmpNw+=Read-Host
        [console]::SetCursorPosition(0,$wt) #Load pos
        [console]::SetWindowPosition(0,$wt) #Load pos


        Clean-inputArea -pos $pos #Clean Input area
        $tmpNw=$tmpNw -replace "\.",""
        if ($tmpNw -eq "") {
            $wordLocalDB=write-stry
            $wordSelected = $NumberOfParts - 1
            $lastWord = $wordSelected
            [console]::setcursorposition($wordLocalDB[$wordSelected].CLS,$wordLocalDB[$wordSelected].CTS)
            write-host ("{0}." -f $wordLocalDB[$wordSelected].word) -BackgroundColor White -ForegroundColor DarkBlue -NoNewline
        } else {
            [console]::SetWindowPosition(0,([console]::WindowTop + [console]::WindowHeight - 1))
            $Story+=$tmpNw
            $NumberOfParts=$Story.Count
            $wordLocalDB=write-stry
            $wordSelected = $NumberOfParts - 1
            $lastWord = $wordSelected
            [console]::setcursorposition($wordLocalDB[$wordSelected].CLS,$wordLocalDB[$wordSelected].CTS)
            write-host ("{0}." -f $wordLocalDB[$wordSelected].word) -BackgroundColor White -ForegroundColor DarkBlue -NoNewline
        }
        Break
     }
     "." {
        #Inject left if not last word
     }
     "DELETE" {
        #Fråga om delete.
     }
    }

    if ($wordChange -eq $true) {

        [console]::setcursorposition($wordLocalDB[$lastWord].CLS,$wordLocalDB[$lastWord].CTS)
        write-host ("{0}." -f $wordLocalDB[$lastWord].word) -NoNewline
        #WriteSelected Word
        [console]::setcursorposition($wordLocalDB[$wordSelected].CLS,$wordLocalDB[$wordSelected].CTS)
        write-host ("{0}." -f $wordLocalDB[$wordSelected].word) -BackgroundColor White -ForegroundColor DarkBlue -NoNewline
        $lastWord=$wordSelected
        $wordChange = $false
    }

}