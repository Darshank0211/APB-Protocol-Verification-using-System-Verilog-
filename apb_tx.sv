typedef enum {write,read} op_t; //operation types for apb_transactions

class apb_tx;

rand op_t op; //random operation type (w/r/w_r)

rand bit       psel    ; //random apb select 
rand bit       pwrite  ; //random apb write
rand bit [31:0]paddr   ; //random apb address
rand bit [31:0]pwdata  ; //random apb data
     bit [31:0]prdata  ; //       apb read data
rand bit       pready  ; //random pready
     bit       pslverr ; //	  pslave error
     bit       penable ; //	  penable


function void print();

$display("###########################op_t=%s###############",op);

if(op==write)
begin
$display("##################write_operation#####################");
$display("psel   =%d", psel   );
$display("pwrite =%d", pwrite );
$display("paddr  =%h", paddr  );
$display("pwdata =%h", pwdata );
//$display("prdata =%h", prdata );
$display("pready =%d", pready );
$display("pslverr=%d", pslverr);
$display("penable=%d", penable);
end

if(op==read)
begin
$display("##################read_operation#####################");
$display("psel   =%d", psel   );
$display("pwrite =%d", pwrite );
$display("paddr  =%h", paddr  );
//$display("pwdata =%h", pwdata );
$display("prdata =%h", prdata );
$display("pready =%d", pready );
$display("pslverr=%d", pslverr);
$display("penable=%d", penable);
end

endfunction

constraint psel_c { psel==1'b1;} //select signal range (0/1) // as its single slave the psel is always kept high

constraint pwrite_c {
        if (op == write) 
            pwrite == 1'b1;
        else if (op == read)
            pwrite == 1'b0;
    }

constraint pready_c { pready inside{1,0};} //ready signal (0/1)

constraint p_c { op dist {write:= 70, read:=30}; }

constraint addr_range_c { 
        paddr inside {[32'h0000_0000:32'h0000_03FF]}; // 1KB address space
    }

constraint pwdata_c {
    pwdata != 32'h0000_0000;                         // Non-zero write data
    pwdata inside {[32'h0000_0001:32'h0000_FFFF]};   // Reasonable data range
}

endclass



