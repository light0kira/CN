#CREATE AN EVENT SCHEDULER 
#MULTICAST TURNED ON
set ns [new Simulator -multicast on]
$ns multicast
#Turn on tracing
set tf [open mcast.tr w]
$ns trace-all $tf
set fd [open pg5.nam w]
$ns namtrace-all $fd
#creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
$ns duplex-link $n0 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 5ms DropTail
$ns duplex-link $n3 $n7 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n6 1.5Mb 5ms DropTail

#Routing protocol say distance vector
#Protocol ctrMcast ,DM,ST,BST
set mproto DM
set mrthandle [$ns mrtproto $mproto {}]

#Allocate group addresses
set group1 [Node allocaddr]
set group2 [Node allocaddr]
#Udp transport agent for the traffic source
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
$udp0 set dist_addr_ $group1
$udp0 set dist_port_ 0
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0

#transport agent for the traffic source
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
$udp1 set dist_addr_ $group2
$udp1 set dist_port_ 0
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp1

#create receiver 
set rcvr1 [new Agent/Null]
$ns attach-agent $n5 $rcvr1
$ns at 1.0 "$n5 join-group $rcvr1 $group1"

set rcvr2 [new Agent/Null]
$ns attach-agent $n6 $rcvr2
$ns at 1.5 "$n6 join-group $rcvr2 $group1"

set rcvr3 [new Agent/Null]
$ns attach-agent $n7 $rcvr3
$ns at 2.5 "$n7 join-group $rcvr3 $group1"

set rcvr4 [new Agent/Null]
$ns attach-agent $n5 $rcvr1
$ns at 3.0 "$n5 join-group $rcvr4 $group2"
set rcvr5 [new Agent/Null]
$ns attach-agent $n6 $rcvr2
$ns at 3.5 "$n6 join-group $rcvr5 $group2"
set rcvr6 [new Agent/Null]
$ns attach-agent $n7 $rcvr3
$ns at 3.5 "$n7 join-group $rcvr6 $group2"

$ns at 4.0 "$n5 leave-group $rcvr1 $group1"
$ns at 4.5 "$n6 leave-group $rcvr2 $group1"
$ns at 5.0 "$n7 leave-group $rcvr3 $group1"

$ns at 5.5 "$n5 leave-group $rcvr4 $group2"
$ns at 6.0 "$n6 leave-group $rcvr5 $group2"
$ns at 6.5 "$n7 leave-group $rcvr6 $group2"
 #schedule events
 $ns at 0.5 "$cbr1 start"
 $ns at 9.5 "$cbr1 stop"
 $ns at 0.5 "$cbr2 start"
 $ns at 9.5 "$cbr2 stop"

 proc finish {} {
 	global ns tf fd
 	$ns flush-trace 
 	close $tf
 	close $fd
	exec nam pg5.nam &
	exit 0
	}
	#group0 source 
	#$udp0 set fid_1 
	#$n0 color red
	#$n0 label "source1"
	#group1 source
	#$udp set fid_ 2
	#$n1 color green
	#$n1 label "Source 2"
	#colors for packets from two mcast 
	$ns color 1 red
	$ns color 2 green	
 	$n5 label "reciever 1"
 	$n5 color blue
 	$n6 label "reciever 2"
	$n6 color blue
	$n7 label "reciever 3"
	$n7 color blue 
	$ns at 10.0 "finish"
	$ns run
