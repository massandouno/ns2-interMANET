set val(chan)       	Channel/WirelessChannel
set val(prop)       	Propagation/FreeSpace
set val(netif)      	Phy/WirelessPhy
set val(mac)        	Mac/802_11
set val(ifq)        	Queue/DropTail/PriQueue
set val(ll)         	LL
set val(ant)   	    	Antenna/OmniAntenna
set val(x)              [lindex $argv 1] ;#max_x
set val(y)              [lindex $argv 2] ;#max_y
set val(ifqlen)         50            ;# max packet in ifq
set val(seed)           1.0
set val(adhocRouting)   AODV
set val(nn)             [lindex $argv 0] ;# how many nodes are simulated
set val(sc)             [lindex $argv 4]
set val(stop)           [lindex $argv 3] ;#sim_time

set ns_		[new Simulator]
set topo	[new Topography]

set tracefd	[open $val(sc).tr  w]
set namtrace    [open $val(sc).nam w]

$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]

$ns_ node-config -adhocRouting $val(adhocRouting) \
                 -llType $val(ll) \
                 -macType $val(mac) \
                 -ifqType $val(ifq) \
                 -ifqLen $val(ifqlen) \
                 -antType $val(ant) \
                 -propType $val(prop) \
                 -phyType $val(netif) \
                 -channelType $val(chan) \
                 -topoInstance $topo \
                 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace ON \
                 -movement Trace ON

for {set i 0} {$i < $val(nn) } {incr i} {
	set node_($i) [$ns_ node]	
	$node_($i) random-motion 0 
	$node_($i) log-movement
}

source $val(sc)

for {set i 0} {$i < $val(nn)} {incr i} {

    # 20 defines the node size in nam, must adjust it according to your scenario
    # The function must be called after mobility model is defined
    
    $ns_ initial_node_pos $node_($i) 20
}


for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at $val(stop).0 "$node_($i) reset";
}

proc record {} {
	global node_ val
	set ns [Simulator instance]
	set time 1
	set now [$ns now]
	for {set i 0} {$i < $val(nn) } {incr i} {
		$node_($i) log-movement
		set x_ [$node_($i) set X_]
		set y_ [$node_($i) set Y_]
		puts "$now $i $x_ $y_"
	}
	$ns at [expr $now+$time] "record"
}

$ns_ at  $val(stop).0002 "$ns_ halt"

#puts $tracefd "M 0.0 nn $val(nn) x $val(x) y $val(y) rp $val(adhocRouting)"
#puts $tracefd "M 0.0 sc $val(sc) cp seed $val(seed)"
#puts $tracefd "M 0.0 prop $val(prop) ant $val(ant)"

$ns_ at 0.0 "record"
$ns_ run




