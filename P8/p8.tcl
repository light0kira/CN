set val(chan)	Channel/WirelessChannel
set val(prop)	Propagation/TwoRayGround
set val(netif)	Phy/WirelessPhy
set val(mac) 	Mac/802_11
set val(ifq)	Queue/DropTail/PriQueue
set val(ll) 	LL
set val(ant) 	Antenna/OmniAntenna
set val(ifqlen) 50
set val(nn)		6
set val(rp)		AODV
set val(x)		500
set val(y)		500
set val(stop)	60
set val(sf)		"sf"
set val(cf)		"cf"

set ns_ [new Simulator]
set tf [open 8.tr w]
$ns trace-all $tf

set nf [open 8.nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

set prop [new $val(prop)]

set god_ [create-god $val(nn)]

$ns_ node-config -adhocRouting $val(rp) \
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
		 
for {set i 0} {$i<$val(nn)} {incr i} {
 set node_($i) [$ns_ node]	
 $node_($i) random-motion 0
}

for {set i 0} {$i<$val(nn)} {incr i} {
set xx [expr rand()*500]
set yy [expr rand()*400]
$node_($i) set X_ $xx
$node_($i) set Y_ $yy
}

$node_(0) set X_ 150.0
$node_(0) set Y_ 300.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 300.0
$node_(1) set Y_ 500.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 500.0
$node_(2) set Y_ 500.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 300.0
$node_(3) set Y_ 100.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 500.0
$node_(4) set Y_ 100.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 650.0
$node_(5) set Y_ 300.0
$node_(5) set Z_ 0.0


for {set i 0} {$i<$val(nn)} {incr i} {
$ns_ initial_node_pos $node_($i) 40
}

puts "Loading scenario file ...."
source $val(sf)
puts "Loading connection file ...."
source $val(cf)

for {set i 0} {$i<$val(nn)} {incr i} {
$ns_ at $val(stop) "$node_($i) reset";
}

$ns_ at $val(stop) "puts \"NS EXITING ...\"; $ns halt"
puts "Starting Simulation ... "

$ns_ run
