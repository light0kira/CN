BEGIN {
recvdSize = 0
startTime=400
stopTime = 0
}
{
event = $1
time=$2
node_id = $3
pkt_Size = $8
level = $4

#store start time

if(level== "AGT" && event == "s" && pkt_Size >= 512) {
if(time < startTime){
startTime = time
}
}

#update total recieved packets size and store packets arrival time

if(level== "AGT" && event == "r" && pkt_Size >= 512) {
if(time > stopTime){
stopTime = time
}
}


#Rip off the header
hdr_Size =pkt_Size% 512
pkt_Size = hdr_Size

#store recieved packets size

recvdSize+=pkt_Size
}

END {
printf("Average throughput[Kbps] = %2f\t\t startTime= %2f\t stopTime = %2f\n",(recvdSize/(stopTime-startTime))*(8/1000),startTime,stopTime)
}


