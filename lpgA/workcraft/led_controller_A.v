// Verilog netlist generated by Workcraft 3 (Return of the Hazard), version 3.1.9
module UNTITLED (ack, LED1, LED2, LED3);
    input ack;
    output LED1, LED2, LED3;

    assign LED2 = csc1 & map1 | LED2 & (~~(map1 | csc1));
    assign _1_ = ack | ~LED2;
    assign _2_ = ~ack & ~LED1 & ~csc0;
    assign csc1 = _1_ & _2_ | csc1 & (~~(_2_ | _1_));
    assign map0 = ~ack & LED1;
    assign map1 = ack & csc0 & csc1;
    assign map2 = ack & ~csc0 & ~LED3;
    assign LED1 = map2 & ~csc0 | LED1 & (~~(~csc0 | map2));
    assign LED3 = ack & ~csc1 | LED3 & (~~(~csc1 | ack));
    assign csc0 = map0 & ~LED3 | csc0 & (~~(~LED3 | map0));


    // signal values at the initial state:
    // !LED2 _1_ _2_ csc1 !map0 !map1 !map2 !LED1 !LED3 !csc0 !ack
endmodule
