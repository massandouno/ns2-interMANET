

# Create Layer 4 and above
#   - UDP/TCP agents
#   - application and/or setup traffic sources

for {set i 0} {$i < $nt } {incr i} {
    #Set up transport layer (UDP). UDP agent for src and NULL agent for dest
    set udp($i) [new Agent/UDP]
    set null($i) [new Agent/Null]
    $ns attach-agent $node($traffic($i,src)) $udp($i)
    $ns attach-agent $node($traffic($i,dst)) $null($i)
    $ns connect $udp($i) $null($i)

    #define traffic
    set cbr($i) [new Application/Traffic/CBR]
    $cbr($i) set packetSize_ $traffic($i,pksize)
    #$cbr($i) set interval_ $traffic($i,period)
    $cbr($i) set rate_ $traffic($i,rate)
    $cbr($i) attach-agent $udp($i)

    $ns at [expr $starttime + $traffic($i,startoffset)] "puts \"Starting CBR traffic $i...\";$cbr($i) start"
}

