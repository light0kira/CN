set ns [new Simulator]
set fin [open esult.tr w]
$ns trace-all $fin
set nfin [open out.nam w]
$ns namtrace-all $nfin
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
$ns duplex-link $n0 $n1 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail
$ns queue-limit $n0 $n1 5
$ns queue-limit $n1 $n2 5
$ns queue-limit $n2 $n3 5
$ns color 1 Blue
$ns color 2 Red
set tcp0 [new Agent/TCP]
$tcp0 set class_ 1
$ns attach-agent $n0 $tcp0
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n3 $tcp1
$ns connect $tcp0 $tcp1
set udp0 [new Agent/UDP]
$udp0 set class_ 2
$ns attach-agent $n1 $udp0
set udp1 [new Agent/Null]
$ns attach-agent $n3 $udp1
$ns connect $udp0 $udp1
$ns connect $udp0 $udp1 
set ftp [new Application/FTP]
$ftp attach-agent $tcp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$ns at 0.1 "$ftp start"
$ns at 2.0 "$ftp stop"
$ns at 0.1 "$cbr0 start"
$ns at 2.0 "$cbr0 stop"
proc finish {} {
global ns fin nfin
$ns flush-trace
close $nfin 
exec nam out.nam &
exit 0
}
$ns at 2.2 "finish"
$ns run
