set ns [new Simulator]
set fin [open pg3.tr w]
$ns trace-all $fin
set nfin [open pg3.nam w]
$ns namtrace-all $nfin
set cwind [open win3.tr w]
$ns rtproto DV
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n0 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n4 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 5ms DropTail
$ns duplex-link $n3 $n5 1.5Mb 5ms DropTail

$ns duplex-link-op $n0 $n1 orient up-right
$ns duplex-link-op $n1 $n2 orient down
$ns duplex-link-op $n0 $n2 orient down-right
$ns duplex-link-op $n1 $n3 orient right
$ns duplex-link-op $n3 $n4 orient down
$ns duplex-link-op $n2 $n4 orient right
$ns duplex-link-op $n4 $n5 orient up-right
$ns duplex-link-op $n3 $n5 orient down-right

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set tcp1 [new Agent/TCPSink]
$ns attach-agent $n3 $tcp1

$ns connect $tcp0 $tcp1
set ftp [new Application/FTP]
$ftp attach-agent $tcp0

$ns rtmodel-at 1.0 down $n1 $n3
$ns rtmodel-at 3.0 up $n1 $n3
$ns at 0.1 "$ftp start"
$ns at 5.0 "$ftp stop"
$ns at 10.0 "finish"
proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file"
}
$ns at 0.1 "plotWindow $tcp0 $cwind"
proc finish {} {
global ns fin nfin
$ns flush-trace 
close $nfin
exec nam pg3.nam &
exit 0
}
$ns at 5.2 "finish"
$ns run
