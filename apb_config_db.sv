class apb_config_db;
	static virtual apb_intf cb_intf;  //virtual interface

	static mailbox gen2bfm=new();     //generator to bfm mailbox
	static mailbox mon2scb=new();     //monitor to scoreboard mailbox
endclass
