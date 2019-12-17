set ns [new Simulator]
set tf [open ex4.tr w]
$ns trace-all $tf
set nf [open ex4.nam w]
$ns namtrace-all $nf

set s [$ns node]
set c [$ns node]

$ns color 1 Blue
$s label "Server"
$c label "Client"

$ns duplex-link $s $c 10Mb 22ms DropTail

$ns duplex-link-op $s $c orient right

set tcp0 [new Agent/TCP]
$ns attach-agent $s $tcp0
set tcp1 [new Agent/TCPSink]
$ns attach-agent $c $tcp1
$tcp0 set packetSize_ 1500

$ns connect $tcp0 $tcp1

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

proc finish {} {
global ns nf tf
$ns flush-trace
close $tf
close $nf
exec nam ex4.nam &
exec awk -f 4_a.awk ex4.tr &
exec awk -f 4_b.awk ex4.tr > convert.tr &
exec xgraph convert.tr &
}

$ns at 0.01 "$ftp0 start"
$ns at 15.0 "$ftp0 stop"
$ns at 15.1 "finish"
$ns run


