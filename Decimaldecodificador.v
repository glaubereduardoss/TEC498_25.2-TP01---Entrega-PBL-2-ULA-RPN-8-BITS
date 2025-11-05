module Decimaldecodificador(
    input [7:0] bin_in,
    output [6:0] segU,
    output [6:0] segD,
    output [6:0] segC
);
    
    // Wires para as saídas dos 3 corretores em cada estágio
    wire [3:0] c1, d1, u1;
    wire [3:0] c2, d2, u2;
    wire [3:0] c3, d3, u3;
    wire [3:0] c4, d4, u4;
    wire [3:0] c5, d5, u5;
    wire [3:0] c6, d6, u6;
    wire [3:0] c7, d7, u7;
    wire [3:0] c8, d8, u8;
    
    // Fios para construir as entradas dos corretores
    wire [3:0] u1_input;
    wire [3:0] s2_c_in, s2_d_in, s2_u_in;
    wire [3:0] s3_c_in, s3_d_in, s3_u_in;
    wire [3:0] s4_c_in, s4_d_in, s4_u_in;
    wire [3:0] s5_c_in, s5_d_in, s5_u_in;
    wire [3:0] s6_c_in, s6_d_in, s6_u_in;
    wire [3:0] s7_c_in, s7_d_in, s7_u_in;
    
    // Fios para a saída final BCD
    wire [3:0] BCD_Centena, BCD_Dezena, BCD_Unidade;
    
    // -------------------------
    // ESTÁGIO 1: Constrói u1_input = {3'b0, bin_in[7]}
    // -------------------------
    and (u1_input[0], bin_in[7], 1'b1);  // LSB = bin_in[7]
    and (u1_input[1], 1'b0, 1'b1);       // Bit 1 = 0
    and (u1_input[2], 1'b0, 1'b1);       // Bit 2 = 0
    and (u1_input[3], 1'b0, 1'b1);       // Bit 3 = 0
    
    // -------------------------
    // ESTÁGIO 2
    // -------------------------
    Add3Corrector corr_c1 (c2, , u1[3:0]);
    Add3Corrector corr_d1 (d2, , d1[3:0]);
    Add3Corrector corr_u1 (u2, , u1_input);
    
    // Constrói s2_c_in = {c2[2:0], d2[3]}
    and (s2_c_in[0], d2[3], 1'b1);
    and (s2_c_in[1], c2[0], 1'b1);
    and (s2_c_in[2], c2[1], 1'b1);
    and (s2_c_in[3], c2[2], 1'b1);
    
    // Constrói s2_d_in = {d2[2:0], u2[3]}
    and (s2_d_in[0], u2[3], 1'b1);
    and (s2_d_in[1], d2[0], 1'b1);
    and (s2_d_in[2], d2[1], 1'b1);
    and (s2_d_in[3], d2[2], 1'b1);
    
    // Constrói s2_u_in = {u2[2:0], bin_in[6]}
    and (s2_u_in[0], bin_in[6], 1'b1);
    and (s2_u_in[1], u2[0], 1'b1);
    and (s2_u_in[2], u2[1], 1'b1);
    and (s2_u_in[3], u2[2], 1'b1);
    
    // -------------------------
    // ESTÁGIO 3
    // -------------------------
    Add3Corrector corr_c2 (c3, , s2_c_in);
    Add3Corrector corr_d2 (d3, , s2_d_in);
    Add3Corrector corr_u2 (u3, , s2_u_in);
    
    // Constrói s3_c_in = {c3[2:0], d3[3]}
    and (s3_c_in[0], d3[3], 1'b1);
    and (s3_c_in[1], c3[0], 1'b1);
    and (s3_c_in[2], c3[1], 1'b1);
    and (s3_c_in[3], c3[2], 1'b1);
    
    // Constrói s3_d_in = {d3[2:0], u3[3]}
    and (s3_d_in[0], u3[3], 1'b1);
    and (s3_d_in[1], d3[0], 1'b1);
    and (s3_d_in[2], d3[1], 1'b1);
    and (s3_d_in[3], d3[2], 1'b1);
    
    // Constrói s3_u_in = {u3[2:0], bin_in[5]}
    and (s3_u_in[0], bin_in[5], 1'b1);
    and (s3_u_in[1], u3[0], 1'b1);
    and (s3_u_in[2], u3[1], 1'b1);
    and (s3_u_in[3], u3[2], 1'b1);
    
    // -------------------------
    // ESTÁGIO 4
    // -------------------------
    Add3Corrector corr_c3 (c4, , s3_c_in);
    Add3Corrector corr_d3 (d4, , s3_d_in);
    Add3Corrector corr_u3 (u4, , s3_u_in);
    
    // Constrói s4_c_in = {c4[2:0], d4[3]}
    and (s4_c_in[0], d4[3], 1'b1);
    and (s4_c_in[1], c4[0], 1'b1);
    and (s4_c_in[2], c4[1], 1'b1);
    and (s4_c_in[3], c4[2], 1'b1);
    
    // Constrói s4_d_in = {d4[2:0], u4[3]}
    and (s4_d_in[0], u4[3], 1'b1);
    and (s4_d_in[1], d4[0], 1'b1);
    and (s4_d_in[2], d4[1], 1'b1);
    and (s4_d_in[3], d4[2], 1'b1);
    
    // Constrói s4_u_in = {u4[2:0], bin_in[4]}
    and (s4_u_in[0], bin_in[4], 1'b1);
    and (s4_u_in[1], u4[0], 1'b1);
    and (s4_u_in[2], u4[1], 1'b1);
    and (s4_u_in[3], u4[2], 1'b1);
    
    // -------------------------
    // ESTÁGIO 5
    // -------------------------
    Add3Corrector corr_c4 (c5, , s4_c_in);
    Add3Corrector corr_d4 (d5, , s4_d_in);
    Add3Corrector corr_u4 (u5, , s4_u_in);
    
    // Constrói s5_c_in = {c5[2:0], d5[3]}
    and (s5_c_in[0], d5[3], 1'b1);
    and (s5_c_in[1], c5[0], 1'b1);
    and (s5_c_in[2], c5[1], 1'b1);
    and (s5_c_in[3], c5[2], 1'b1);
    
    // Constrói s5_d_in = {d5[2:0], u5[3]}
    and (s5_d_in[0], u5[3], 1'b1);
    and (s5_d_in[1], d5[0], 1'b1);
    and (s5_d_in[2], d5[1], 1'b1);
    and (s5_d_in[3], d5[2], 1'b1);
    
    // Constrói s5_u_in = {u5[2:0], bin_in[3]}
    and (s5_u_in[0], bin_in[3], 1'b1);
    and (s5_u_in[1], u5[0], 1'b1);
    and (s5_u_in[2], u5[1], 1'b1);
    and (s5_u_in[3], u5[2], 1'b1);
    
    // -------------------------
    // ESTÁGIO 6
    // -------------------------
    Add3Corrector corr_c5 (c6, , s5_c_in);
    Add3Corrector corr_d5 (d6, , s5_d_in);
    Add3Corrector corr_u5 (u6, , s5_u_in);
    
    // Constrói s6_c_in = {c6[2:0], d6[3]}
    and (s6_c_in[0], d6[3], 1'b1);
    and (s6_c_in[1], c6[0], 1'b1);
    and (s6_c_in[2], c6[1], 1'b1);
    and (s6_c_in[3], c6[2], 1'b1);
    
    // Constrói s6_d_in = {d6[2:0], u6[3]}
    and (s6_d_in[0], u6[3], 1'b1);
    and (s6_d_in[1], d6[0], 1'b1);
    and (s6_d_in[2], d6[1], 1'b1);
    and (s6_d_in[3], d6[2], 1'b1);
    
    // Constrói s6_u_in = {u6[2:0], bin_in[2]}
    and (s6_u_in[0], bin_in[2], 1'b1);
    and (s6_u_in[1], u6[0], 1'b1);
    and (s6_u_in[2], u6[1], 1'b1);
    and (s6_u_in[3], u6[2], 1'b1);
    
    // -------------------------
    // ESTÁGIO 7
    // -------------------------
    Add3Corrector corr_c6 (c7, , s6_c_in);
    Add3Corrector corr_d6 (d7, , s6_d_in);
    Add3Corrector corr_u6 (u7, , s6_u_in);
    
    // Constrói s7_c_in = {c7[2:0], d7[3]}
    and (s7_c_in[0], d7[3], 1'b1);
    and (s7_c_in[1], c7[0], 1'b1);
    and (s7_c_in[2], c7[1], 1'b1);
    and (s7_c_in[3], c7[2], 1'b1);
    
    // Constrói s7_d_in = {d7[2:0], u7[3]}
    and (s7_d_in[0], u7[3], 1'b1);
    and (s7_d_in[1], d7[0], 1'b1);
    and (s7_d_in[2], d7[1], 1'b1);
    and (s7_d_in[3], d7[2], 1'b1);
    
    // Constrói s7_u_in = {u7[2:0], bin_in[1]}
    and (s7_u_in[0], bin_in[1], 1'b1);
    and (s7_u_in[1], u7[0], 1'b1);
    and (s7_u_in[2], u7[1], 1'b1);
    and (s7_u_in[3], u7[2], 1'b1);
    
    // -------------------------
    // ESTÁGIO 8 (Final)
    // -------------------------
    Add3Corrector corr_c7 (c8, , s7_c_in);
    Add3Corrector corr_d7 (d8, , s7_d_in);
    Add3Corrector corr_u7 (u8, , s7_u_in);
    
    // -------------------------
    // SAÍDA FINAL: Constrói BCD usando apenas portas AND
    // -------------------------
    // BCD_Centena = {c8[2:0], d8[3]}
    and (BCD_Centena[0], d8[3], 1'b1);
    and (BCD_Centena[1], c8[0], 1'b1);
    and (BCD_Centena[2], c8[1], 1'b1);
    and (BCD_Centena[3], c8[2], 1'b1);
    
    // BCD_Dezena = {d8[2:0], u8[3]}
    and (BCD_Dezena[0], u8[3], 1'b1);
    and (BCD_Dezena[1], d8[0], 1'b1);
    and (BCD_Dezena[2], d8[1], 1'b1);
    and (BCD_Dezena[3], d8[2], 1'b1);
    
    // BCD_Unidade = {u8[2:0], bin_in[0]}
    and (BCD_Unidade[0], bin_in[0], 1'b1);
    and (BCD_Unidade[1], u8[0], 1'b1);
    and (BCD_Unidade[2], u8[1], 1'b1);
    and (BCD_Unidade[3], u8[2], 1'b1);
    
    // -------------------------
    // Decodificadores para 7 segmentos
    // -------------------------
    A_4bits_decodedecimal decU (.S(segU), .A(BCD_Unidade));
    A_4bits_decodedecimal decD (.S(segD), .A(BCD_Dezena));
    A_4bits_decodedecimal decC (.S(segC), .A(BCD_Centena));
    
endmodule

module A_4bits_decodedecimal(output [6:0] S, input [3:0] A);

	wire [3:0]N;
	wire [12:0]F;

	not(N[0], A[0]);
	not(N[1], A[1]);
	not(N[2], A[2]);
	not(N[3], A[3]);

	//a
	and(F[0],N[3],N[2],N[1],A[0]);
	and(F[1], A[2], N[1], N[0]);
	or(S[0], F[1], F[0]);

	//b
	and(F[2], A[2], N[1], A[0]);
	and(F[3], A[2], A[1], N[0]);
	or(S[1], F[2], F[3]);

	//c
	and(S[2], N[2], A[1], N[0]);

	//d
	and(F[4], A[2], N[1], N[0]);
	and(F[5], N[3], N[2], N[1], A[0]);
	and(F[6], A[2], A[1], A[0]);
	or(S[3], F[5], F[6], F[4]);

	//e
	and(F[7], A[2], N[1]);
	or(S[4], A[0], F[7]);

	//f
	and(F[8], A[1], A[0]);
	and(F[9], N[3], N[2], A[0]);
	and(F[10], N[2], A[1]);
	or(S[5], F[8], F[9], F[10]);

	//g
	and(F[11], N[3], N[2], N[1]);
	and(F[12], A[2], A[1], A[0]);
	or(S[6], F[11], F[12]);

endmodule

module Add3Corrector (
    output [3:0] Q_next, 
    output C_out,        // Carry out
    input [3:0] Q_in     // Saída atual
);
    wire Cond, W1, W2;
    wire [3:0] B_add;
    
    and A1(W1, Q_in[2], Q_in[1]);
    and A2(W2, Q_in[2], Q_in[0]);
    or O1(Cond, Q_in[3], W1, W2);
    

// Objetivo: Se Cond=0, B_add = 4'b0000. Se Cond=1, B_add = 4'b0011.

// MUX para o LSB (B_add[0]): Seleciona 0 se Cond=0, ou 1 se Cond=1.
A_Mux2x1 MUXB0 (.sel(Cond), .A(1'b0), .B(1'b1), .Y(B_add[0]));

// MUX para B_add[1]: Seleciona 0 se Cond=0, ou 1 se Cond=1.
A_Mux2x1 MUXB1 (.sel(Cond), .A(1'b0), .B(1'b1), .Y(B_add[1]));

// MUX para B_add[2]: Seleciona 0 se Cond=0, ou 0 se Cond=1. (Sempre 0)
A_Mux2x1 MUXB2 (.sel(Cond), .A(1'b0), .B(1'b0), .Y(B_add[2])); 

// MUX para o MSB (B_add[3]): Seleciona 0 se Cond=0, ou 0 se Cond=1. (Sempre 0)
A_Mux2x1 MUXB3 (.sel(Cond), .A(1'b0), .B(1'b0), .Y(B_add[3]));
    
    A_4Bits_fulladder FA (
        .S (Q_next),
        .Co (C_out),
        .A (Q_in),
        .B (B_add),
        .Ci (1'b0)
    );
endmodule