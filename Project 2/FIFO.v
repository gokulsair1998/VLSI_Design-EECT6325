module FIFObuffer 
#(parameter data_size=32,
parameter data_alloc=32,
parameter rdwd_c_bit=($clog2(data_alloc)+1)
)

( Clk,dataIn,RD,WR,EN,dataOut,Rst,EMPTY,FULL); 


input  Clk,RD,WR,EN,Rst;
output  EMPTY, FULL;

input   [data_size-1:0] dataIn;
output reg [data_size-1:0] dataOut; // internal registers 

reg [rdwd_c_bit:0]  Count = 0; 
reg [data_size:0] FIFO [0:data_alloc]; 
reg [rdwd_c_bit:0]  readCounter = 0,writeCounter = 0; 

assign EMPTY = (Count==0)? 1'b1:1'b0; 
assign FULL = (Count==data_alloc)? 1'b1:1'b0; 

always @ (posedge Clk) 
begin 
 if (EN==0); 

 else
  begin 
  if (Rst) begin 
   readCounter = 0; 
   writeCounter = 0; 
  end 

  else if (RD ==1'b1 && Count!=0)
  begin 
   dataOut  = FIFO[readCounter]; 
   readCounter = readCounter+1; 
  end 

  else if (WR==1'b1 && Count<data_alloc) 
  begin
   FIFO[writeCounter]  = dataIn; 
   writeCounter  = writeCounter+1; 
  end 

  else; 
  end 

 if (writeCounter==data_alloc) 
  writeCounter=0; 
 else if (readCounter==data_alloc) 
  readCounter=0; 

 else;

 if (readCounter > writeCounter) 
 begin 
  Count=readCounter-writeCounter; 
 end 

 else if (writeCounter > readCounter) 
  Count=writeCounter-readCounter; 

 else;

end 

endmodule