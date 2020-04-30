function Test-LuhnValidation {

    param (
        [Parameter(Mandatory=$True)]
        [string]$Number
    )
    
    $temp = $Number.ToCharArray();
    $numbers = @(0) * $Number.Length;
    $alt = $false;

    for($i = $temp.Length -1; $i -ge 0; $i--) {
       $numbers[$i] = [int]::Parse($temp[$i])
       if($alt){
           $numbers[$i] *= 2
           if($numbers[$i] -gt 9) { 
               $numbers[$i] -= 9 
           }
       }
       $sum += $numbers[$i]
       $alt = !$alt
    }
    return ($sum % 10) -eq 0
}



$ssns = @(
9202010360
)



$ssns |% {Test-LuhnValidation $_}