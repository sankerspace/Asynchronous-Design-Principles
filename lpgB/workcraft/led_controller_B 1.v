// Verilog netlist generated by Workcraft 3 (Return of the Hazard), version 3.1.9
module UNTITLED (ack, LED1, LED2, LED3);
    input ack;
    output LED1, LED2, LED3;

    assign _0_ = LED3 | ~ack | ~LED2;
    assign _1_ = ~LED2 & ack & ~LED3;
    assign LED1 = _0_ & _1_ | LED1 & (~~(_1_ | _0_));
    assign LED2 = map0 & map1 | LED2 & (~~(map1 | map0));
    assign _4_ = LED2 & ~ack & ~LED1;
    assign _5_ = LED1 | ack | LED2;
    assign LED3 = _4_ & _5_ | LED3 & (~~(_5_ | _4_));
    assign map0 = ~ack & LED1;
    assign map1 = ~LED3 | ~ack;


    // signal values at the initial state:
    // _0_ !_1_ !LED1 !LED2 !_4_ !_5_ !LED3 !map0 map1 !ack
endmodule
