module apb_tb_top;

bit pclk;		
bit presetn;

always #5 pclk=~pclk;

initial begin
presetn=0;
#5 presetn=1;
end

apb_intf intf(pclk,presetn);

initial begin
	apb_config_db::cb_intf=intf;
end

apb_dut dut(.pclk(pclk),.presetn(presetn),.psel(intf.psel),.pwrite(intf.pwrite),.penable(intf.penable),.paddr(intf.paddr),.pwdata(intf.pwdata),.prdata(intf.prdata),.pready(intf.pready),.pslverr(intf.pslverr));

apb_test test_h();

initial begin
	#2000 $finish;
end

endmodule
