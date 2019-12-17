BEGIN{
revdsize=0;
starttime=400;
stoptime=0;
hdr_size=0;
sent=0; rcv=0;
}
{
event=$1;
time=$2;
pkt_size=$8;
level=$4
if(level=="AGT" && event=="s" && pkt_size>=512)
{
sent+=1;
if(time<starttime){
starttime=time;
}
}
if(level=="AGT" && event=="r" && pkt_size>=512)
{
rcv+=1;
if(time>stoptime){
stoptime=time;
}
hdr_size=pkt_size%512;
pkt_size-=hdr_size;
revdsize+=pkt_size;
}
}
END{
printf("Average goodput in kbps = %.2f\n", (revdsize/(stoptime-starttime))*(8/1000));
printf("Sent = %f\n", sent);
printf("Recieved = %f\n", rcv);

}  //awk script for 7