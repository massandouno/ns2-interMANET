
## IDRM NAM support for color coding nodes
Node instproc idrm-dump-namconfig {size str} {
	$self instvar attr_ id_ address_ X_ Y_ Z_
	set ns [Simulator instance]

	if ![info exists attr_(SHAPE)] {
		set attr_(SHAPE) "circle"
	} 
	if ![info exists attr_(COLOR)] {
		set attr_(COLOR) "black"
	        set attr_(LCOLOR) "black"
	}
        if ![info exists attr_(DCOLOR)] {
                set attr_(DCOLOR) "black"
        }
	if [info exists attr_(DLABEL)] {
		set str1 "-S DLABEL -l \"$str\" -L $attr_(DLABEL)"
	} else {
		set str1 "-S DLABEL -l \"$str\" -L \"\""
	}
	set attr_(DLABEL) \"$str\"

	if { [info exists X_] && [info exists Y_] } {
		if [info exists Z_] {
			$ns puts-nam-config \
			[eval list "n -t * -a $address_ -s $id_ $str1 -z $size -v $attr_(SHAPE) -c $attr_(COLOR) -i $attr_(LCOLOR) -x $X_ -y $Y_ -Z $Z_"]
		} else {
			$ns puts-nam-config \
			[eval list "n -t * -a $address_ -s $id_ $str1 -z $size -v $attr_(SHAPE) -c $attr_(COLOR) -i $attr_(LCOLOR) -x $X_ -y $Y_"]
		}
	} else {
	$ns puts-nam-config \
		[eval list "n -t * -a $address_ -s $id_ $str1 -z $size -v $attr_(SHAPE) -c $attr_(COLOR) -i $attr_(LCOLOR)"]
	}
}

## Adding interface to Node to set and get an IDRM routing agent
Node/MobileNode instproc set-idrm-agent {idrmagent} {
	$self instvar idrmagent_
	set idrmagent_ $idrmagent
}
Node/MobileNode instproc get-idrm-agent {} {
	$self instvar idrmagent_
	if { [ info exists idrmagent_ ] } {
		return $idrmagent_
	} else {
		return ""
	}
}

### addition of interface procedure one time for all nodes (to the simulation instance)

Simulator instproc change-numifs { newnumifs } {
	$self instvar numifs_
	set numifs_ $newnumifs
}

### addition of channel to interface maintained for interfaces. Number of channels == number of interfaces. One-to-one mapping

Simulator instproc add-channel-and-routing-to-interface { indexch ch ragent} {
	$self instvar chan routingAgent
	set chan($indexch) $ch
	set routingAgent($indexch) $ragent
}

Simulator instproc idrm_set { domain_ identity_ num_gateway_ num_domain_members_ fname_ eBeacon_ iBeacon_ method_ sh_dynamic_ sh_schannel_ color_} { 
	$self instvar domain identity num_gateway num_domain_members fname eBeacon iBeacon method sh_dynamic sh_schannel color #0102 0214
	set domain 							$domain_
	set identity						$identity_
	set num_gateway					$num_gateway_
	set num_domain_members	$num_domain_members_
	set fname								$fname_
	set eBeacon							$eBeacon_
	set iBeacon							$iBeacon_

	#0102
	set method							$method_	
	
	#0214
	set sh_dynamic					$sh_dynamic_
	
	set sh_schannel					$sh_schannel_
	set color					$color_
}

Simulator instproc idrm_gateway_set { index_ gateway_ } {
	$self instvar gateways
	set gateways($index_)			$gateway_
}

#IDRM_SH: 0623
Simulator instproc idrm_domain_set { index_ domain_members_ } {
	$self instvar domain_members
	set domain_members($index_)			$domain_members_
}

### procudre to get number of interfaces

Simulator instproc get-numifs { } {
	$self instvar numifs_
	if { [ info exists numifs_ ] } {
		return $numifs_
	} else {
		return ""
	}
}

### addition of number of interface for node-config command

Simulator instproc ifNum { val } {$self set numifs_ $val}

## IDRM routing agent create

#Simulator instproc create-idrm-agent { node numifs my_if_id my_ragent_name base_if_id base_ragent_name base_ragent} {
Simulator instproc create-idrm-agent { node numifs my_if_id my_ragent_name base_if_id base_ragent_name base_ragent file_name eBeacon_ iBeacon_ method_ sh_dynamic_ sh_schannel_ color_ } {
#color_} {
	## Do some check ups to ensure the "right" parameters are passed as other code may call this
	set tmpError 1
	if {  
		(( $numifs == 2 ) && ($my_if_id == 1) && ( $my_ragent_name == "IDRM" ) && ($base_if_id == 0) && (( $base_ragent_name == "AODV" ) || ( $base_ragent_name == "DSDV" ) || ( $base_ragent_name == "DSR" ) || ( $base_ragent_name == "TORA" )))
	   } {
		set tmpError 0
	} 
	if {$tmpError != 0} {
		    set tmpError [$node node-addr]
		    puts "IDRM ERROR: Wrong Routing agent configuration on Node $node (id=$tmpError). IDRM agents to be started only on Gateways. Interface 0 should be associated with AODV/DSDV/DSR/TORA and Interface 1 should be configured with IDRM"
           	    exit
	}

        #  Create IDRM routing agent
	set idrmagent [new Agent/IDRM [$node node-addr] $numifs $my_if_id $base_if_id]
	$idrmagent set-baseagent $base_ragent $base_ragent_name
        #$self at 0.0 "$idrmagent start"     ;# start an agent process
	      #$self at 0.0 "$idrmagent start $file_name $eBeacon_ $iBeacon_"     ;# start an agent process
				
				$self at 0.0 "$idrmagent start $file_name $eBeacon_ $iBeacon_ $method_ $sh_dynamic_ $sh_schannel_ $color_"     ;# start an agent process 0102 0214 $color_

        return $idrmagent
}

