
Mac/802_11 set dataRate_          54Mb          ;# 54Mbps //0710 SHLEE

# Traffic Parameters (all CBR type unicast traffic flows)
set traffic(num_flows) 3 ;# Total Number of flows
# flows (i) A1 to A0 (ii) B2 to B3 and (iii) A3 to B2
# A1 has node id 0, A0 is 3, A3 is 1, B2 is 4 and B3 is 6
set traffic(0,src) 0 ;# Src node ID
set traffic(0,dst) 3 ;# Dest node ID
set traffic(0,pksize) 500 ;# Packet Size in bytes
set traffic(0,period) 0.01 ;# period in secs
set traffic(0,rate) 1Mb ;# period in secs
set traffic(0,startoffset) 10.0 ;# offset in secs from Simulation starttime


set traffic(1,src) 4 ;# Src node ID
set traffic(1,dst) 6 ;# Dest node ID
set traffic(1,pksize) 10 ;# Packet Size in bytes
set traffic(1,period) 1.0 ;# period in secs
set traffic(1,rate) 1Mb ;# period in secs
set traffic(1,startoffset) 1.0 ;# offset in secs from Simulation starttime

set traffic(2,src) 1 ;# Src node ID
set traffic(2,dst) 2;# Dest node ID
set traffic(2,pksize) 64 ;# Packet Size in bytes
set traffic(2,period) 1.0 ;# period in secs
set traffic(2,rate) 1Mb ;# period in secs
set traffic(2,startoffset) 1.0 ;# offset in secs from Simulation starttime

#IDRM_SH: traffic over MANETs
set traffic(3,src)                               1;                              #Src node ID in MANET A
set traffic(3,dst)                               3;                              #Dest node ID in MANET B
set traffic(3,pksize)  			        						 64;  		         						 #Packet size in bytes
set traffic(3,period)                    	 			 1.0;           		 						 #Period in secs
set traffic(3,rate) 														 1Mb;														 #data rate
set traffic(3,startoffset) 											 1.0;                 		 			 #Offset in secs

set traffic(4,src)                               9;                              #Src node ID in MANET A
set traffic(4,dst)                               11;                              #Dest node ID in MANET B
set traffic(4,pksize)  			        						 64;  		         						 #Packet size in bytes
set traffic(4,period)                    	 			 1.0;           		 						 #Period in secs
set traffic(4,rate) 														 0.001Mb;														 #data rate
set traffic(4,startoffset) 											 1.0;                 		 			 #Offset in secs

set traffic(5,src)                               0;                              #Src node ID in MANET A
set traffic(5,dst)                               11;                              #Dest node ID in MANET B
set traffic(5,pksize)                            1400;                           #Packet size in bytes
set traffic(5,period)                            0.1;                            #Period in secs
set traffic(5,rate) 														 0.01Mb;														 #data rate
set traffic(5,startoffset)                       3.0;                            #Offset in secs

# Create Layer 4 and above
#   - UDP/TCP agents
#   - application and/or setup traffic sources

#for {set i 1} {$i < $traffic(num_flows) } {incr i} {
#IDRM_SH: Let's only see traffic 3
for {set i 4} {$i < 6 } {incr i} {
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

