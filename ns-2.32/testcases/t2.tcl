# simulation parameters and options
set duration 1500;		# simualtion time in secs
set starttime 1.0; 	# simulation start time in secs

if {[llength $argv] != 1} {
	puts "Missing parameters... Speed"
	exit 1
}

#command arguments
set myspeed				[lindex $argv 0]

# Topology Parameters and associated nam attributes for animation 
set topo(nn)     12; 													# Number of nodes 
set topo(grid_x) 2500;													# grid length in meters
set topo(grid_y) 2500;													# grid width in meters
set file_name tmp;

#IDRM_SH
set topo(nd)		 2;														# number of domains
set topo(ng)		 6; 													# max number of gateway nodes
set topo(dnn) 	 [expr $topo(nn) / $topo(nd)];

set topo(eb)		 10;
set topo(ib)		 10;

#0102
set topo(method) 2;

#0214
set topo(dynamic) 1;

set topo(schannel) 0;

set proto(chan) 	Channel/WirelessChannel;			# channel type
set proto(prop) 	Propagation/TwoRayGround;			# radio-propagation model
set proto(netif) 	Phy/WirelessPhy;							# network interface type
set proto(mac) 		Mac/802_11;										# MAC type
set proto(ifq) 		Queue/DropTail/PriQueue;			# interface queue type
set proto(ll) 		LL;														# link layer type
set proto(ant) 		Antenna/OmniAntenna;					# antenna model
set proto(ifqlen) 50;														# max packet in ifq

set proto(rp,5) IDRM;													# routing protocol

# IDRM based network settings
set net(max_net_chans) 101;												# This is the maximum number of channels on the network. 
                         												# One channel each for domains A, B and C (both gateways and non-gateways operate) and 
                         												# one channel for gateways ONLY to operate on a separate additional domain.
			 									 												# let channe index 0 for A, 1 for B, 2 for C and 3 for gateways
			 									 												# let routing protcol index be 0 for A, 0 for B and 0 for C i.e. all AODV on interface 0 and IDRM on interface 1 (for gateways)

set net(max_node_ifaces) 2; 										# maximum number of interfaces per node. non-gateways will have one interface while gateways will have 2
			    																			# for non gateways, inteface index 0 (there is only one) is used to operate on the channel 
                            										# corresponding to domain. For gateways too inteface index 0 is used to operate on the channel 
			    																			# and interface index 1 used to operate on the channel assigned for gateway interaction


#set position
source "testcases/t2_topology.tcl"


set proto(rp,0)		DSDV
set proto(rp,1)		DSDV
set proto(rp,2)		DSDV
set proto(rp,3)		IDRM

# =====================================================================
# Other default settings

LL set mindelay_				50us
LL set delay_						25us
LL set bandwidth_				0;					# not used

Agent/Null set sport_		0
Agent/Null set dport_		0

Agent/CBR set sport_		0
Agent/CBR set dport_		0

Agent/UDP set sport_		0
Agent/UDP set dport_		0


Queue/DropTail/PriQueue set Prefer_Routing_Protocols    1

# unity gain, omni-directional antennas
# set up the antennas to be centered in the node and 1.5 meters above it
Antenna/OmniAntenna set X_ 0
Antenna/OmniAntenna set Y_ 0
Antenna/OmniAntenna set Z_ 1.5
Antenna/OmniAntenna set Gt_ 1.0
Antenna/OmniAntenna set Gr_ 1.0

# Initialize the SharedMedia interface with parameters to make
# it work like the 914MHz Lucent WaveLAN DSSS radio interface
Phy/WirelessPhy set CPThresh_ 10.0
Phy/WirelessPhy set CSThresh_ 1.559e-11
Phy/WirelessPhy set RXThresh_ 3.652e-10
Phy/WirelessPhy set Rb_ 2*1e6
Phy/WirelessPhy set Pt_ 0.2818s
Phy/WirelessPhy set freq_ 914e+6 
Phy/WirelessPhy set L_ 1.0

#Set wireless data rate
Mac/802_11 				set dataRate_          11Mb;	# 11Mbps //0710 SHLEE
Mac/802_11 				set basicRate_         11Mb;		# 1Mbps
Mac/802_11 set RTSThreshold_ 3000

Mac/802_11 set sifs_ 10us
Mac/802_11 set difs_ 50us


# ======================================================================
# Main Program
# ======================================================================
# 
# Initialize ns
#
set ns [new Simulator]

#
# Initialize Global Variables
#
# define color index

#random
ns-random my_seed

# [Turn on tracing]
#Open the nam/other trace file
# if you want to use the new  trace format uncomment the next line
$ns use-newtrace

#Open the NAM trace file
set nf [open dump_files/idrm_main.nam w]
$ns namtrace-all-wireless $nf $topo(grid_x) $topo(grid_y)
$ns trace-all $nf

#Open the Trace file
set tf [open dump_files/idrm_main.tr w]
$ns trace-all $tf


# Create topology
# set up topography object
set topog	[new Topography]
for {set i 0} {$i < $net(max_net_chans)} {incr i} {
	set chan($i)        [new $proto(chan)]
}

$topog load_flatgrid $topo(grid_x) $topo(grid_y)
create-god [expr $topo(nn) * $net(max_node_ifaces)]; 

# create MobileNode object (PHY to layer 3 configured) 
# first use $chan(0) for all, we will change it when we set the nodes
# also first use some basic routing protocol (agent) for all like AODV. Later we will set up one routing agent per interface
$ns node-config -adhocRouting $proto(rp,0) -llType $proto(ll) \
    -macType $proto(mac)   -ifqType $proto(ifq) \
    -ifqLen $proto(ifqlen) -antType $proto(ant) \
    -propType $proto(prop) -phyType $proto(netif) \
    -channel $chan(0)      -topoInstance $topog \
    -agentTrace ON         -routerTrace ON \
    -macTrace ON           -movementTrace ON \
    -ifNum $net(max_node_ifaces) 


# create Mobile Node object 
for {set i 0} {$i < $topo(nn)} {incr i} {

    # now set channels and interfaces properly
    $ns change-numifs $topo($i,num_if_ch)
    for {set k 0} {$k < $topo($i,num_if_ch)} {incr k} {
        $ns add-channel-and-routing-to-interface $k $chan($topo($i,idx_map_if_to_ch,$k)) $proto(rp,$topo($i,idx_map_if_to_ragent,$k))

			puts "node:$i $k $chan($topo($i,idx_map_if_to_ch,$k)) $proto(rp,$topo($i,idx_map_if_to_ragent,$k)) "    

    }

    
    #set DomainId, Identity, and number of gateways..
    $ns idrm_set $topo($i,my_domain) $topo($i,my_identity) $topo(ng) $topo(dnn) $file_name $topo(eb) $topo(ib) $topo(method) $topo(dynamic) $topo(schannel) 12
        
    #Set gateway nodes to each node
    for {set k 0} {$k < $topo(ng)} {incr k} {
			$ns idrm_gateway_set $k $topo($i,my_gateway,$k)
    }
    
    #Set domain members to each node
		set dc 0;
		for {set j 0} {$j < $topo(nn)} {incr j} {
			if { $topo($i,my_domain) == $topo($j,my_domain) } {
				$ns idrm_domain_set $dc $j
				incr dc
			}
  	}

		for {set j $dc} {$j < $topo(dnn)} {incr j} {
				$ns idrm_domain_set $dc -1
				incr dc
  	}
    
    set node($i) [$ns node]
    $node($i) random-motion 0		;# disable random motion
    # Now set node's starting placement
    $node($i) set X_ $topo($i,start_x);
    $node($i) set Y_ $topo($i,start_y);
    $node($i) set Z_ 0.0
    $node($i) color $nam($i,color);# sets color of node and label
    $node($i) shape $nam($i,shape);# sets shape of node
 	
    # sets label on node and ...
    # 50 defines the node size in nam, must adjust it according to your scenario
    # The following function must be called after mobility model is defined
    #$ns initial_node_pos $node($i) 50
    # the procedure above forces the color and shape, so instead use own line insertion in nam file

    $node($i) idrm-dump-namconfig 50 "$nam($i,dom_id)$nam($i,node_id)"
}

#set mobility
source "testcases/t2_mobility.tcl"

#
# UDP traffic
#

set traffic(0,src)				2 ;
set traffic(0,dst)				9 ;
set traffic(0,pksize)			1000 ;
set traffic(0,rate)				800Kb ;
set traffic(0,startoffset)	    40.000000 ;

set traffic(1,src)				5 ;
set traffic(1,dst)				8 ;
set traffic(1,pksize)			1000 ;
set traffic(1,rate)				100Kb ;
set traffic(1,startoffset)	    40.000000 ;

for {set i 0} {$i < 1 } {incr i} { #hack
    #Set up transport layer (UDP). UDP agent for src and NULL agent for dest
    set udp($i) [new Agent/UDP]
    set null($i) [new Agent/Null]
    $ns attach-agent $node($traffic($i,src)) $udp($i)
    $ns attach-agent $node($traffic($i,dst)) $null($i)
    $ns connect $udp($i) $null($i)

    #define traffic
	  global ::cbr($i)
    set cbr($i) [new Application/Traffic/CBR]
    $cbr($i) set packetSize_ $traffic($i,pksize)
    $cbr($i) set rate_ $traffic($i,rate)
    $cbr($i) attach-agent $udp($i)

    $ns at [expr $starttime + $traffic($i,startoffset)] "puts \"Starting CBR traffic $i...\";$cbr($i) start"
}


# Tell nodes when the simulation ends
#
for {set i 0} {$i < $topo(nn)} {incr i} {
#   $ns at [expr $starttime + $duration] "$node($i) reset";
}

#Call the finish procedure after of simulation time
$ns at [expr $starttime + $duration + 0.000001] "finish"

# Post-processing procedures
#Define a 'finish' procedure
proc finish {} {
        global ns nf tf
        $ns flush-trace
        #Close the NAM trace file
        close $nf
        #Close the Trace file
        close $tf

	#Execute nam on the trace file
        #exec nam dump_files/idrm_main.nam &
        exit 0
}

#Run the simulation
puts "Starting Simulation..."
# Start simulation
$ns run

