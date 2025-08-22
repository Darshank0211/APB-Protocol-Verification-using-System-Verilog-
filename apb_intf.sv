interface apb_intf(input bit pclk,presetn);

logic 	    psel   ;
logic 	    pwrite ;
logic 	    penable;
logic [31:0]paddr  ;
logic [31:0]pwdata ;
logic [31:0]prdata ;
logic 	    pready ; 
logic       pslverr;

clocking bfm_cb @(posedge pclk);
  default input #1 output #1;

  output psel   ;
  output pwrite ;
  output penable; 
  output paddr  ;  
  output pwdata ;
  input  prdata ;
  input  pready ;
  input  pslverr; 

endclocking

clocking mon_cb @(posedge pclk);
  default input #1 output #1;

  input psel   ;
  input pwrite ;
  input penable; 
  input paddr  ;  
  input pwdata ;
  input  prdata ;
  input  pready ;
  input  pslverr; 

endclocking

modport bfm(clocking bfm_cb,input pclk,presetn);

modport monitor(clocking mon_cb,input pclk,presetn);


endinterface 
