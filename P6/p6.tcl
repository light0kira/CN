
set val(chan) Channel/WirelessChannel
set val(nn) 2
set val(stop) 200
set val(prop) Propagation/TwoRayGround
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(ifq) Queue/DropTail/PriQueue
set val(ifqlen) 50
set val(x) 500
set val(y) 500
set val(rp) DSDV


set ns_ [new Simulator]
set tf [open prg6.tr w]
$ns_ trace-all $tf
set nf [open prg6.nam w]
$ns_ namtrace-all-wireless $nf $val(x) $val(y)
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
set god_ [create-god $val(nn)]


$ns_ node-config -adhocRouting $val(rp)\
				 -channelType $val(chan)\
-phyType $val(netif)\
-propType $val(prop)\
-llType $val(ll)\
-antType $val(ant)\
-macType $val(mac)\
-ifqType $val(ifq)\
-ifqLen $val(ifqlen)\
-agentTrace ON\
-routerTrace ON\
-macTrace ON\
-topoInstance $topo


for {set i 0} {$i<$val(nn)} {incr i} {
	set node_($i) [$ns_ node]
	
}


for {set i 0} {$i<$val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 40
}

$ns_ at 1.0 "$node_(0) setdest 310.0 10.0 20.0"
$ns_ at 1.0 "$node_(1) setdest 10.0 310.0 20"

set tcp [new Agent/TCP]
$ns_ attach-agent $node_(0) $tcp
set tcpsink [new Agent/TCPSink]
$ns_ attach-agent $node_(1) $tcpsink
$ns_ connect $tcp $tcpsink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 1.0 "$ftp start"
$ns_ at 18.0 "$ftp stop"

for {set i 0} {$i<$val(nn)} {incr i} {
	$ns_ at $val(stop) "$node_($i) reset"
}

$ns_ at $val(stop) "puts \"Exiting nam\";$ns_ halt"
puts "Starting simulation"
exec nam prg6.nam & 
$ns_ run 





