program apb_test();

	apb_env apb_env_h;

	initial begin
		apb_env_h=new();
		apb_env_h.run();
	end
endprogram
