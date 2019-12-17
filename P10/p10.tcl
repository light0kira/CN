set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(ifq) Queue/DropTail/PriQueue
set val(ll) LL
set val(ant) Antenna/OmniAntenna
set val(ifqlen) 50
set val(nn) 2
set val(rp) DSDV
set val(x) 500
set val(y) 400
set val(stop) 20

set ns_ [new Simulator]

set tf [open p10.tr w]
$ns_ trace-all $tf

set nf [open p10.nam w]
$ns_ namtrace-all-wireless $nf $val(x) $val(y)

set cwind [open win10.tr w] 

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

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
       			macTrace ON \
                	-Incoming ErrProc "UniformErr" \
                -outgoing ErrProc "UniformErr"
proc UniformErr {} {
set err [new ErrorModel]
$err unit pkt
$err set rate _0.50
return $err
}
for {set i 0} {$i<$val(nn)} {incr i} {
set node_($i) [$ns_ node]
#$node_($i) random_motion 0
}

for {set i 0} {$i<$val(nn)} {incr i} {
$ns_ initial_node_pos $node_($i) 40
}

$ns_ at 0.5 "$node_(0) setdest 250.0 250.0 40.0"
$ns_ at 0.6 "$node_(1) setdest 45.0 285.0 80.0"

set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(1) $sink
$ns_ connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 0.2 "$ftp start"
$ns_ at 10.0 "$ftp stop"

for {set i 0} {$i<$val(nn)} {incr i} {
$ns_ at $val(stop) "$node_($i) reset"
}
proc plotWindow {tcpSource file} {
global ns_
set time 0.01
set now [$ns_ now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns_ at [expr $now+$time] "plotWindow $tcpSource $file"
}
$ns_ at 0.1 "plotWindow $tcp $cwind"
$ns_ at $val(stop) "puts \"NS EXITING.....\"; $ns_ halt"
puts "Starting Simulation..."
$ns_ run





