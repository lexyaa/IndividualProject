module  tb;
// ----------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------
parameter           tCK = 1000/50   ;
parameter           N   = 100       ;

// ----------------------------------------------------------------
// Clock / Reset
// ----------------------------------------------------------------
reg                 CLK             ;
initial             CLK = 1'b1      ;
always  #(tCK/2)
                    CLK = ~CLK      ;
reg                 RSTb = 1'b0     ;

// ----------------------------------------------------------------
// readmemb signals
// ----------------------------------------------------------------
reg     [31:0]      vo_sum[0:N-1];
reg                 vo_c[0:N-1];
reg     [31:0]      vi_a[0:N-1];
reg     [31:0]      vi_b[0:N-1];
reg                 vi_c[0:N-1];

// ----------------------------------------------------------------
// I/O Declare
// ----------------------------------------------------------------
wire    [31:0]      o_sum           ;
wire                o_c             ;
reg     [31:0]      i_a             ;
reg     [31:0]      i_b             ;
reg                 i_c             ;

// ----------------------------------------------------------------
// Instantiate
// ----------------------------------------------------------------
add32               dut(
                    .o_sum  ( o_sum ),
                    .o_c    ( o_c   ),
                    .i_a    ( i_a   ),
                    .i_b    ( i_b   ),
                    .i_c    ( i_c   ));

// ----------------------------------------------------------------
// Input Definition
// ----------------------------------------------------------------
integer             i               ;
integer             err             ;
initial begin
    #(00*tCK)       RSTb = 1'b1     ;
    #(01*tCK)       RSTb = 1'b0     ;
    $readmemb("o_sum.vec", vo_sum);
    $readmemb("o_c.vec", vo_c);
    $readmemb("i_a.vec", vi_a);
    $readmemb("i_b.vec", vi_b);
    $readmemb("i_c.vec", vi_c);
    i       = 0;
    err     = 0;
    for(i = 0; i < N ; i = i+1) begin
        #(0.1*tCK)
            i_a     = vi_a[i]     ;
            i_b     = vi_b[i]     ;
            i_c     = vi_c[i]     ;
        #(0.1*tCK)
            if(o_sum != vo_sum[i] || o_c != vo_c[i]) begin
                err = err + 1;
                $display("o_sum /vo_sum: %b /%b", o_sum, vo_sum[i]);
                $display("o_c   /vo_c  : %b /%b", o_c, vo_c[i]);
            end
        #(0.1*tCK)
            $display("[%5d]Error: %d", i, err);
        #(0.7*tCK);
    end
    #(10*tCK)   $finish;
end

endmodule
