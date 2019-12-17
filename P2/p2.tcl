set ns [new Simulator]
set fin [open pg2.tr w]
$ns trace-all $fin
set nfin [open pg2.nam w]
$ns namtrace-all $nfin

set cwind [open win2.tr w]

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
$ns duplex-link $n1 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n6 1.5Mb 5ms DropTail
$ns duplex-link-op $n1 $n3 orient up-right
$ns duplex-link-op $n2 $n3 orient down-right
$ns duplex-link-op $n3 $n4 orient right
$ns duplex-link-op $n4 $n5 orient up-right
$ns duplex-link-op $n4 $n6 orient down-right


set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0

set tcp1 [new Agent/TCPSink]
$ns attach-agent $n6 $tcp1

set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2

set tcp3 [new Agent/TCPSink]
$ns attach-agent $n5 $tcp3
$ns connect $tcp0 $tcp1
$ns connect $tcp2 $tcp3

set ftp [new Application/FTP]
$ftp attach-agent $tcp0

set ftp1 [new Application/Telnet]
$ftp1 attach-agent $tcp2

$ns at 0.1 "$ftp start"
$ns at 2.1 "$ftp stop"
$ns at 10.0 "finish"
$ns at 0.1 "$ftp1 start"
$ns at 2.1 "$ftp1 stop"
proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file"
}
$ns at 0.1 "plotWindow $tcp0 $cwind"
$ns at 5.5 "plotWindow $tcp1 $cwind"
$ns at 11.0 "finish"

proc finish {} {
global ns fin nfin
$ns flush-trace 
close $nfin
exec nam pg2.nam &
exit 0
}
$ns at 2.2 "finish"
$ns run
