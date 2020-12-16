// ----------------------------------------------------------------
// CLA with 4-bit Blocks
// ----------------------------------------------------------------
module  cla4(
                o_c,
                i_a,
                i_b,
                i_c     );

output          o_c     ;

input   [3:0]   i_a     ;
input   [3:0]   i_b     ;
input           i_c     ;

wire    [3:0]   i_g     ;
wire    [3:0]   g       ;                       // signal 'G' of generating a carry out

wire    [3:0]   i_p     ;
wire    [3:0]   p       ;                       // signal 'P' of propagating a carry in to the carry out

assign          i_g = i_a * i_b;

assign          i_p = i_a + i_b;

assign          g   = i_g[3] + i_p[3]*(i_g[2] + i_p[2]*(i_g[1] + i_p[1]*i_g[0]));

assign          p   = i_p[3] * i_p[2] * i_p[1] * i_p[0];

assign          o_c = g + p*i_c;

endmodule

// ----------------------------------------------------------------
// 32-bit CLA
// ----------------------------------------------------------------
module  add32(  o_sum,
                o_c,
                i_a,
                i_b,
                i_c     );

output  [31:0]  o_sum   ;
output          o_c     ;

input   [31:0]  i_a     ;
input   [31:0]  i_b     ;
input           i_c     ;

wire    [6:0]   carry   ;

cla4            dut0(
                .o_c    ( carry[0]      ),
                .i_a    ( i_a[3:0]      ),
                .i_b    ( i_b[3:0]      ),
                .i_c    ( i_c           ));

cla4            dut1(
                .o_c    ( carry[1]      ),
                .i_a    ( i_a[7:4]      ),
                .i_b    ( i_b[7:4]      ),
                .i_c    ( carry[0]      ));

cla4            dut2(
                .o_c    ( carry[2]      ),
                .i_a    ( i_a[11:8]     ),
                .i_b    ( i_b[11:8]     ),
                .i_c    ( carry[1]      ));

cla4            dut3(
                .o_c    ( carry[3]      ),
                .i_a    ( i_a[15:12]    ),
                .i_b    ( i_b[15:12]    ),
                .i_c    ( carry[2]      ));

cla4            dut4(
                .o_c    ( carry[4]      ),
                .i_a    ( i_a[19:16]    ),
                .i_b    ( i_b[19:16]    ),
                .i_c    ( carry[3]      ));

cla4            dut5(
                .o_c    ( carry[5]      ),
                .i_a    ( i_a[23:20]    ),
                .i_b    ( i_b[23:20]    ),
                .i_c    ( carry[4]      ));

cla4            dut6(
                .o_c    ( carry[6]      ),
                .i_a    ( i_a[27:24]    ),
                .i_b    ( i_b[27:24]    ),
                .i_c    ( carry[5]      ));

cla4            dut7(
                .o_c    ( o_c           ),
                .i_a    ( i_a[31:28]      ),
                .i_b    ( i_b[31:28]      ),
                .i_c    ( carry[6]      ));

assign          o_sum = i_a + i_b + i_c;        // RCA: calculating sum

endmodule
