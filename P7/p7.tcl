set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(ifq) CMUPriQueue
set val(ifqlen) 50
set val(mac) Mac/802_11
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(x) 600
set val(y) 300
set val(nn) 3
set val(stop) 60.0
set val(rp) DSR

set ns_ [new Simulator]
set tf [open p7.tr w]
$ns_ trace-all $tf

set nf [open p7.nam w]
$ns_ namtrace-all-wireless $nf $val(x) $val(y)

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]
$ns_ node-config -adhocRouting $val(rp)\
-llType $val(ll)\
-macType $val(mac)\
-ifqType $val(ifq)\
-ifqLen $val(ifqlen)\
-antType $val(ant)\
-propType $val(prop)\
-phyType $val(netif)\
-channelType $val(chan)\
-topoInstance $topo\
-agentTrace ON\
-routerTrace ON\
-macTrace ON


for {set i 0} {$i<$val(nn)} {incr i} {
 set node_($i) [$ns_ node]
 $node_($i) random-motion 0
}
$node_(0) set X_ 5.0
$node_(0) set Y_ 5.0
$node_(0) set Z_ 0.0
$node_(1) set X_ 490.0
$node_(1) set Y_ 285.0
$node_(1) set Z_ 0.0
$node_(2) set X_ 150.0
$node_(2) set Y_ 240.0
$node_(2) set Z_ 0.0

for {set i 0} {$i<$val(nn)} {incr i} {
$ns_ initial_node_pos $node_($i) 40
}

$ns_ at 0.0 "$node_(0) setdest 450.0 285.0 30.0"
$ns_ at 0.0 "$node_(1) setdest 200.0 285.0 30.0"
$ns_ at 0.0 "$node_(2) setdest 200.0 285.0 30.0"

$ns_ at 25.0 "$node_(0) setdest 300.0 285.0 30.0"
$ns_ at 25.0 "$node_(2) setdest 100.0 285.0 30.0"


$ns_ at 40.0 "$node_(0) setdest 490.0 285.0 30.0"
$ns_ at 40.0 "$node_(2) setdest 1.0 285.0 30.0"


set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp0
$ns_ attach-agent $node_(2) $sink0
$ns_ connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns_ at 10.0 "$ftp0 start"


for {set i 0} {$i<$val(nn)} {incr i} {
$ns_ at $val(stop) "$node_($i) reset";
}
$ns_ at $val(stop) "puts \"NS EXITING ...\"; $ns_ halt"
puts "Starting Simulation ... "
exec nam p7.nam &
$ns_ run