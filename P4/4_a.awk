BEGIN{
 count=0;
 time=0;
 total_bytes_sent=0;
 total_bytes_recived=0;
 }
{
  if($1 == "r" && $4 == "1" && $5 == "tcp")
  	total_bytes_recived+=$6;
  	
  if($1 == "+" && $3 == "0" && $5 == "tcp")
  	total_bytes_sent+=$6;
}
END{
 system("clear");
 print("\n Transaction time required to transfer the file is %f ",$2);
 print("\n Actual amount of data being sent %f ",(total_bytes_sent)/1000000);
 print("\n Actual amount of data being recived %f ",(total_bytes_recived)/1000000);
 }
