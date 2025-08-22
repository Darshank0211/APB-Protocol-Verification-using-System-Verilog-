class apb_env;

apb_gen apb_gen_h;
apb_bfm apb_bfm_h;
apb_mon apb_mon_h;
apb_scb apb_scb_h;

function new();
	apb_gen_h=new();
	apb_bfm_h=new();
	apb_mon_h=new();
	apb_scb_h=new();
endfunction

task run();

	fork
		begin
			apb_gen_h.run();
		end
	
		begin
			apb_bfm_h.run();
		end
		
	 	begin 
			apb_mon_h.run();
		end
	
		begin 
			apb_scb_h.run();
		end 
	join
endtask

endclass
