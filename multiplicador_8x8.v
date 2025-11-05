// ============================================================================
// MÓDULO MULTIPLICADOR 8x8 
// ============================================================================
module multiplicador_8x8(
    // --- Entradas Físicas da Placa DE10-Lite ---
    input  wire        clk,
    input  wire        reset,
    input  wire        start,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    
    // --- Saídas para a Placa ---
    output wire [15:0] out,
    output wire        busy,
    output wire        done
);
    wire [15:0] acc, acc_next;
    wire [7:0]  count;
    wire        carry;
    wire        enable_logic;
    wire        not_done;

    // --- Lógica de Controle ---
    not u_not_done (not_done, done);
    and u_is_busy (enable_logic, start, not_done);
    
    buffer_1bit u_busy_led (.in(enable_logic), .out(busy));

    // --- Contador Síncrono de 8 bits ---
    contador_sincrono_8bit ctr(
        .clk(clk),
        .en(enable_logic),
        .reset(reset),
        .q(count)
    );

    // --- Comparador para parar quando count == B ---
    comparador_8bit cmp(
        .equal(done),
        .A(count),
        .B(B)
    );

    // --- Somador de 16 bits: acc_next = acc + A ---
    A_16bits_fulladder u_sum(
        .A(acc),
        .B({8'b0, A}),
        .S(acc_next),
        .Cout(carry)
    );

    // --- Registrador de acumulador (16 bits) síncrono ---
    register_16bits reg_acc(
        .clk(clk),
        .en(enable_logic),
        .reset(reset),
        .d(acc_next),
        .q(acc)
    );

    // --- Registrador de Saída (16 bits) síncrono ---
    register_16bits reg_out(
        .clk(clk),
        .en(done),
        .reset(reset),
        .d(acc),
        .q(out)
    );
endmodule

// ============================================================================
// SEÇÃO 1: BLOCOS DE CONSTRUÇÃO FUNDAMENTAIS
// ============================================================================

module d_flip_flop_with_reset(
    input  wire clk,
    input  wire reset,
    input  wire d,
    output reg  q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end
endmodule

module buffer_1bit(
    input  wire in,
    output wire out
);
    wire temp_inv;
    not u_inv1(temp_inv, in);
    not u_inv2(out, temp_inv);
endmodule

module comparador_4bit (
    output wire equal,
    input  wire [3:0] A,
    input  wire [3:0] B
);
    wire [3:0] xnor_bits;
    xnor (xnor_bits[0], A[0], B[0]);
    xnor (xnor_bits[1], A[1], B[1]);
    xnor (xnor_bits[2], A[2], B[2]);
    xnor (xnor_bits[3], A[3], B[3]);
    and (equal, xnor_bits[0], xnor_bits[1], xnor_bits[2], xnor_bits[3]);
endmodule

module comparador_8bit (
    output wire equal,
    input  wire [7:0] A,
    input  wire [7:0] B
);
    wire [7:0] xnor_bits;
    wire eq_low, eq_high;
    
    xnor (xnor_bits[0], A[0], B[0]);
    xnor (xnor_bits[1], A[1], B[1]);
    xnor (xnor_bits[2], A[2], B[2]);
    xnor (xnor_bits[3], A[3], B[3]);
    xnor (xnor_bits[4], A[4], B[4]);
    xnor (xnor_bits[5], A[5], B[5]);
    xnor (xnor_bits[6], A[6], B[6]);
    xnor (xnor_bits[7], A[7], B[7]);
    
    and (eq_low, xnor_bits[0], xnor_bits[1], xnor_bits[2], xnor_bits[3]);
    and (eq_high, xnor_bits[4], xnor_bits[5], xnor_bits[6], xnor_bits[7]);
    and (equal, eq_low, eq_high);
endmodule

// ============================================================================
// SEÇÃO 4: FLIP-FLOPS E REGISTRADORES
// ============================================================================

module d_flip_flop_with_enable_and_reset(
    input  wire clk,
    input  wire reset,
    input  wire load,
    input  wire d,
    output wire q
);
    wire d_mux_out;
    wire q_feedback;
    A_1bit_Mux u_mux_enable ( .sel(load), .X(q_feedback), .Y(d), .S(d_mux_out) );
    d_flip_flop_with_reset u_dff ( .clk(clk), .reset(reset), .d(d_mux_out), .q(q) );
    buffer_1bit u_feedback_buffer (.in(q), .out(q_feedback));
endmodule

module register_4bits(
    input  wire       clk,
    input  wire       en,
    input  wire       reset,
    input  wire [3:0] d,
    output wire [3:0] q
);
    d_flip_flop_with_enable_and_reset ff0 (.clk(clk), .reset(reset), .load(en), .d(d[0]), .q(q[0]));
    d_flip_flop_with_enable_and_reset ff1 (.clk(clk), .reset(reset), .load(en), .d(d[1]), .q(q[1]));
    d_flip_flop_with_enable_and_reset ff2 (.clk(clk), .reset(reset), .load(en), .d(d[2]), .q(q[2]));
    d_flip_flop_with_enable_and_reset ff3 (.clk(clk), .reset(reset), .load(en), .d(d[3]), .q(q[3]));
endmodule

module register_8bits(
    input  wire       clk,
    input  wire       en,
    input  wire       reset,
    input  wire [7:0] d,
    output wire [7:0] q
);
    d_flip_flop_with_enable_and_reset ff0 (.clk(clk), .reset(reset), .load(en), .d(d[0]), .q(q[0]));
    d_flip_flop_with_enable_and_reset ff1 (.clk(clk), .reset(reset), .load(en), .d(d[1]), .q(q[1]));
    d_flip_flop_with_enable_and_reset ff2 (.clk(clk), .reset(reset), .load(en), .d(d[2]), .q(q[2]));
    d_flip_flop_with_enable_and_reset ff3 (.clk(clk), .reset(reset), .load(en), .d(d[3]), .q(q[3]));
    d_flip_flop_with_enable_and_reset ff4 (.clk(clk), .reset(reset), .load(en), .d(d[4]), .q(q[4]));
    d_flip_flop_with_enable_and_reset ff5 (.clk(clk), .reset(reset), .load(en), .d(d[5]), .q(q[5]));
    d_flip_flop_with_enable_and_reset ff6 (.clk(clk), .reset(reset), .load(en), .d(d[6]), .q(q[6]));
    d_flip_flop_with_enable_and_reset ff7 (.clk(clk), .reset(reset), .load(en), .d(d[7]), .q(q[7]));
endmodule

module register_16bits(
    input  wire        clk,
    input  wire        en,
    input  wire        reset,
    input  wire [15:0] d,
    output wire [15:0] q
);
    d_flip_flop_with_enable_and_reset ff0 (.clk(clk), .reset(reset), .load(en), .d(d[0]), .q(q[0]));
    d_flip_flop_with_enable_and_reset ff1 (.clk(clk), .reset(reset), .load(en), .d(d[1]), .q(q[1]));
    d_flip_flop_with_enable_and_reset ff2 (.clk(clk), .reset(reset), .load(en), .d(d[2]), .q(q[2]));
    d_flip_flop_with_enable_and_reset ff3 (.clk(clk), .reset(reset), .load(en), .d(d[3]), .q(q[3]));
    d_flip_flop_with_enable_and_reset ff4 (.clk(clk), .reset(reset), .load(en), .d(d[4]), .q(q[4]));
    d_flip_flop_with_enable_and_reset ff5 (.clk(clk), .reset(reset), .load(en), .d(d[5]), .q(q[5]));
    d_flip_flop_with_enable_and_reset ff6 (.clk(clk), .reset(reset), .load(en), .d(d[6]), .q(q[6]));
    d_flip_flop_with_enable_and_reset ff7 (.clk(clk), .reset(reset), .load(en), .d(d[7]), .q(q[7]));
    d_flip_flop_with_enable_and_reset ff8 (.clk(clk), .reset(reset), .load(en), .d(d[8]), .q(q[8]));
    d_flip_flop_with_enable_and_reset ff9 (.clk(clk), .reset(reset), .load(en), .d(d[9]), .q(q[9]));
    d_flip_flop_with_enable_and_reset ff10 (.clk(clk), .reset(reset), .load(en), .d(d[10]), .q(q[10]));
    d_flip_flop_with_enable_and_reset ff11 (.clk(clk), .reset(reset), .load(en), .d(d[11]), .q(q[11]));
    d_flip_flop_with_enable_and_reset ff12 (.clk(clk), .reset(reset), .load(en), .d(d[12]), .q(q[12]));
    d_flip_flop_with_enable_and_reset ff13 (.clk(clk), .reset(reset), .load(en), .d(d[13]), .q(q[13]));
    d_flip_flop_with_enable_and_reset ff14 (.clk(clk), .reset(reset), .load(en), .d(d[14]), .q(q[14]));
    d_flip_flop_with_enable_and_reset ff15 (.clk(clk), .reset(reset), .load(en), .d(d[15]), .q(q[15]));
endmodule

// ============================================================================
// SEÇÃO 5: CONTADORES
// ============================================================================

module contador_sincrono_4bit(
    input  wire       clk,
    input  wire       en,
    input  wire       reset,
    output wire [3:0] q
);
    wire [3:0] count_plus_1;
    wire       carry_out;
    wire [3:0] next_count;

    A_4Bits_fulladder u_incrementador(
        .A(q),
        .B(4'b0001),
        .C(1'b0),
        .S(count_plus_1),
        .Cout(carry_out)
    );

    A_4bits_Mux u_mux_enable(
        .sel(en),
        .X(q),
        .Y(count_plus_1),
        .S(next_count)
    );

    register_4bits u_reg_count(
        .clk(clk),
        .en(1'b1),
        .reset(reset),
        .d(next_count),
        .q(q)
    );
endmodule

module contador_sincrono_8bit(
    input  wire       clk,
    input  wire       en,
    input  wire       reset,
    output wire [7:0] q
);
    wire [7:0] count_plus_1;
    wire       carry_out;
    wire [7:0] next_count;

    A_8bits_fulladder u_incrementador(
		  .S(count_plus_1),
		  .Co(carry_out),
        .A(q),
        .B(8'b00000001),
        .Ci(1'b0)
        
    );

    A_8bits_Mux u_mux_enable(
        .sel(en),
        .X(q),
        .Y(count_plus_1),
        .S(next_count)
    );

    register_8bits u_reg_count(
        .clk(clk),
        .en(1'b1),
        .reset(reset),
        .d(next_count),
        .q(q)
    );
endmodule