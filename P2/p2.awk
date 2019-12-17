BEGIN {
last = 0 
tcp_sz=0
cbr_sz=0
total_sz=0
}
{
if ($5=="tcp" && $1 =="r")
	tcp_sz=4
if ( $5=="cbr" && $1=="r")
	cbr_sz+=4
total_sz+=4
}
END{
	print time ,(tcp_sz*8(1000000))
	print time ,(tcp_sz*8(1000000))
				((total_sz*8)/1000000)
}	

