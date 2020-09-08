// Verilog netlist generated by Workcraft 3 (Return of the Hazard), version 3.1.9
module LPG_A_CONTROLLER (ack, reset , LED1, LED2, LED3);
    input ack,reset;
    output LED1, LED2, LED3;
	 
    
    //reg csc1,csc0;
    //C2_r CLED2(.Q(LED2), .A(csc1), .B(map1), .R(reset));
    assign LED2 = (csc1 & map1 | LED2 & ((map1 | csc1))) 	& ~reset;
    assign _1_ = ack | ~LED2;
    assign _2_ = ~ack & ~LED1 & ~csc0;
    //C2_r CCSC1(.Q(csc1), .A(_1_), .B(_2_), .R(reset));
    assign csc1 = _1_ & _2_ | csc1 & ((_2_ | _1_));
    assign map0 = (~ack & LED1) 										& ~reset;
    assign map1 = (ack & csc0 & csc1)								& ~reset;
    assign map2 = (ack & ~csc0 & ~LED3)							& ~reset;
    //C2_r CLED1(.Q(LED1), .A(map2), .B(~csc0), .R(reset));
    assign LED1 = (map2 & ~csc0 | LED1 & ((~csc0 | map2))) 	& ~reset;
    //C2_r CLED3(.Q(LED3), .A(ack), .B(~csc1), .R(reset));
    assign LED3 = (ack & ~csc1 | LED3 & ((~csc1 | ack)))		& ~reset;
    //C2_r CCSC0(.Q(csc0), .A(map0), .B(~LED3), .R(reset));
    assign csc0 = (map0 & ~LED3 | csc0 & ((~LED3 | map0)))	& ~reset;
    
	
    // signal values at the initial state:
    // !LED2 _1_ _2_ csc1 !map0 !map1 !map2 !LED1 !LED3 !csc0 !ack
endmodule