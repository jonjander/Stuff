class sentn {
    [guid]$id
    [string]$data
    [string]$owner
    #[sentn[]]$child


    sentn([string]$data) 
    {
        $this.id = [guid]::NewGuid()
        $this.data = $data
    }
    [void] sss () {
       
    }
}

class links {
    [bool]$isBase
    [guid]$parentID
    [guid]$childID

    links ([bool]$isBase,[guid]$parentID,[guid]$childID) {
        $this.isBase = $isBase
        $this.childID = $childID
        $this.parentID = $parentID
    }
}

[sentn[]]$ns = [sentn]::new("fisk1")
[links[]]$links=$null

$nobj=newNS -data "test6" -parent $ns[0]
$nobj=newNS -data "test3" -parent $nobj


$links.Where({$PSItem.childID -in $links.parentID})


$links.Where({$PSItem.parentID -in $links.childID})

$rootOBjts=$ns.Where({$PSItem.id -notin $links.childID}) #is root objects

$rootOBjts.ForEach({
    function getChild{
        param ($obj)
        write-host "ID: " $obj.id -f Green
        $childs=$links.Where({$PSItem.parentID -eq $obj.id})
        Write-Host "cc: " $childs.count
        if ($childs.count -gt 0) {
            $childs.ForEach({
                $tmpCH=$psitem
                write-host "mID: " $tmpCH.childID -f Red
                getChild -obj $ns.Where({$PSItem.id -eq $tmpCH.childID})
            })
        } else {

        }
    }
    getChild $PSItem

})

function newNS {
param ([string]$data,[sentn]$parent)

    $parentID = $parent.id #load parent
    $newNSobj=[sentn]::new($data)
    [links]$link=[links]::new($false,$parentID,$newNSobj.id)

    $script:links+=$link
    $script:ns+=$newNSobj
    return $newNSobj
}

$newNS += [sentn]::new("fisk8")
$ns += $newNS

$ns
[links[]]$links+=[links]::new($true,$newNS.id,$ns[0].id)



class story {
    [sentn]$sendOBj

}
