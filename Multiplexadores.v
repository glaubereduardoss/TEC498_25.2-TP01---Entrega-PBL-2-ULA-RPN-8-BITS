module A_Mux2x1(input sel, A, B, output Y);

    wire nsel, a1, b1;

    not n0(nsel, sel);
    and a0(a1, A, nsel);
    and a2(b1, B, sel);
    or  o0(Y, a1, b1);
endmodule

module A_1bit_Mux(
    input sel,
    input X,
    input Y,
    output S
);
    wire nsel, t1, t2;

    not(nsel, sel);
    and(t1, nsel, X);
    and(t2, sel, Y);
    or(S, t1, t2);

endmodule

module A_4bits_Mux(
    input  wire       sel,
    input  wire [3:0] X,
    input  wire [3:0] Y,
    output wire [3:0] S
);
    Mux1Bit mux0 (.sel(sel), .X(X[0]), .Y(Y[0]), .S(S[0]));
    Mux1Bit mux1 (.sel(sel), .X(X[1]), .Y(Y[1]), .S(S[1]));
    Mux1Bit mux2 (.sel(sel), .X(X[2]), .Y(Y[2]), .S(S[2]));
    Mux1Bit mux3 (.sel(sel), .X(X[3]), .Y(Y[3]), .S(S[3]));
endmodule

module A_8bits_Mux(
    input sel,
    input  [7:0] X,
    input  [7:0] Y,
    output [7:0] S
);
    
    A_1bit_Mux mux0 (.sel(sel), .X(X[0]), .Y(Y[0]), .S(S[0]));
    A_1bit_Mux mux1 (.sel(sel), .X(X[1]), .Y(Y[1]), .S(S[1]));
    A_1bit_Mux mux2 (.sel(sel), .X(X[2]), .Y(Y[2]), .S(S[2]));
    A_1bit_Mux mux3 (.sel(sel), .X(X[3]), .Y(Y[3]), .S(S[3]));
	 A_1bit_Mux mux4 (.sel(sel), .X(X[4]), .Y(Y[4]), .S(S[4]));
	 A_1bit_Mux mux5 (.sel(sel), .X(X[5]), .Y(Y[5]), .S(S[5]));
	 A_1bit_Mux mux6 (.sel(sel), .X(X[6]), .Y(Y[6]), .S(S[6]));
	 A_1bit_Mux mux7 (.sel(sel), .X(X[7]), .Y(Y[7]), .S(S[7]));
    
endmodule

module mux8PARA1(
    // --- Entradas (Nomes Adaptados) ---
    input wire data_in_0, // I0
    input wire data_in_1, // I1
    input wire data_in_2, // I2
    input wire data_in_3, // I3
    input wire data_in_4, // I4
    input wire data_in_5, // I5
    input wire data_in_6, // I6
    input wire data_in_7, // I7
    input wire [2:0] select_lines, // SEL
    input wire enable_mux,         // Nova porta de Habilitação

    // --- Saída (Nome Adaptado) ---
    output wire data_out // Y
);
    
    // --- Fios Internos (Nomes Adaptados) ---
    wire [2:0] n_sel;
    wire term_0, term_1, term_2, term_3, term_4, term_5, term_6, term_7;

    // --- Inversores para as linhas de seleção ---
    not (n_sel[2], select_lines[2]); // not_S2
    not (n_sel[1], select_lines[1]); // not_S1
    not (n_sel[0], select_lines[0]); // not_S0

    // --- Decodificação e AND para cada entrada ---
    // Inclui a porta 'enable_mux' em todas as 8 portas AND.

    // Sel = 000
    and (term_0, n_sel[2], n_sel[1], n_sel[0], data_in_0, enable_mux); 
    // Sel = 001
    and (term_1, n_sel[2], n_sel[1], select_lines[0], data_in_1, enable_mux); 
    // Sel = 010
    and (term_2, n_sel[2], select_lines[1], n_sel[0], data_in_2, enable_mux); 
    // Sel = 011
    and (term_3, n_sel[2], select_lines[1], select_lines[0], data_in_3, enable_mux); 
    // Sel = 100
    and (term_4, select_lines[2], n_sel[1], n_sel[0], data_in_4, enable_mux); 
    // Sel = 101
    and (term_5, select_lines[2], n_sel[1], select_lines[0], data_in_5, enable_mux); 
    // Sel = 110
    and (term_6, select_lines[2], select_lines[1], n_sel[0], data_in_6, enable_mux); 
    // Sel = 111
    and (term_7, select_lines[2], select_lines[1], select_lines[0], data_in_7, enable_mux); 

    // --- Combinação final com a porta OR ---
    or (data_out, term_0, term_1, term_2, term_3, term_4, term_5, term_6, term_7);
    
endmodule

// =================================================================
// MÓDULO: Multiplexador Principal da ULA (16-bit)
// - Seleciona uma das oito fontes de dados de larguras variadas
//   para a saída de 16 bits.
// =================================================================
module mux(
    // --- Portas de Entrada ---
    input  wire [8:0]  data_in_0,    // Saída da Soma (com carry)
    input  wire [8:0]  data_in_1,    // Saída da Subtração (com carry)
    input  wire [15:0] data_in_2,    // Saída da Multiplicação
    input  wire [7:0]  data_in_3,    // Saída da Divisão
    input  wire [7:0]  data_in_4,    // Saída da operação AND
    input  wire [7:0]  data_in_5,    // Saída da operação OR
    input  wire [7:0]  data_in_6,    // Saída da operação XOR
    input  wire [7:0]  data_in_7,    // Saída da operação NOT
    input  wire [3:0]  select_lines, // Linhas de seleção da operação
    input  wire        enable_mux,   // Habilita a saída do MUX

    // --- Porta de Saída ---
    output wire [15:0] data_out      // Saída de 16 bits do MUX
);

    // --- Lógica do Circuito (Instanciação dos MUXs de 1 bit) ---
    // Cada instância de 'mux8bit' constrói um bit da saída final de 16 bits.
	mux8PARA1 mux00(data_in_0[0], data_in_1[0], data_in_2[0], data_in_3[0], data_in_4[0], data_in_5[0], data_in_6[0], data_in_7[0], select_lines, enable_mux, data_out[0]);
	mux8PARA1 mux01(data_in_0[1], data_in_1[1], data_in_2[1], data_in_3[1], data_in_4[1], data_in_5[1], data_in_6[1], data_in_7[1], select_lines, enable_mux, data_out[1]);
	mux8PARA1 mux02(data_in_0[2], data_in_1[2], data_in_2[2], data_in_3[2], data_in_4[2], data_in_5[2], data_in_6[2], data_in_7[2], select_lines, enable_mux, data_out[2]);
	mux8PARA1 mux03(data_in_0[3], data_in_1[3], data_in_2[3], data_in_3[3], data_in_4[3], data_in_5[3], data_in_6[3], data_in_7[3], select_lines, enable_mux, data_out[3]);
	mux8PARA1 mux04(data_in_0[4], data_in_1[4], data_in_2[4], data_in_3[4], data_in_4[4], data_in_5[4], data_in_6[4], data_in_7[4], select_lines, enable_mux, data_out[4]);
	mux8PARA1 mux05(data_in_0[5], data_in_1[5], data_in_2[5], data_in_3[5], data_in_4[5], data_in_5[5], data_in_6[5], data_in_7[5], select_lines, enable_mux, data_out[5]);
	mux8PARA1 mux06(data_in_0[6], data_in_1[6], data_in_2[6], data_in_3[6], data_in_4[6], data_in_5[6], data_in_6[6], data_in_7[6], select_lines, enable_mux, data_out[6]);
	mux8PARA1 mux07(data_in_0[7], data_in_1[7], data_in_2[7], data_in_3[7], data_in_4[7], data_in_5[7], data_in_6[7], data_in_7[7], select_lines, enable_mux, data_out[7]);
	mux8PARA1 mux08(data_in_0[8], data_in_1[8], data_in_2[8], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, select_lines, enable_mux, data_out[8]);
	mux8PARA1 mux09(1'b0, 1'b0, data_in_2[9], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, select_lines, enable_mux, data_out[9]);
	mux8PARA1 mux10(1'b0, 1'b0, data_in_2[10], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, select_lines, enable_mux, data_out[10]);
	mux8PARA1 mux11(1'b0, 1'b0, data_in_2[11], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, select_lines, enable_mux, data_out[11]);
	mux8PARA1 mux12(1'b0, 1'b0, data_in_2[12], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, select_lines, enable_mux, data_out[12]);
	mux8PARA1 mux13(1'b0, 1'b0, data_in_2[13], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, select_lines, enable_mux, data_out[13]);
	mux8PARA1 mux14(1'b0, 1'b0, data_in_2[14], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, select_lines, enable_mux, data_out[14]);
	mux8PARA1 mux15(1'b0, 1'b0, data_in_2[15], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, select_lines, enable_mux, data_out[15]);
	//APENAS MULTIPLICAÇÃO PODE CHEGAR A 15 BITS! RESTO ZERO ZERO ZERO ZERO !!!!!!

endmodule

// =================================================================
// MÓDULO: MUX de 7 bits com 3 entradas (só portas lógicas)
// =================================================================
module mux_7bits_3to1(
    input [6:0] in_decimal,
    input [6:0] in_hexa,
    input [6:0] in_octal,
    input sel_decimal,
    input sel_hexa,
    input sel_octal,
    output [6:0] out
);
    // Fios intermediários para cada bit
    wire [6:0] and_dec, and_hex, and_oct;
    
    // Bit 0
    and (and_dec[0], in_decimal[0], sel_decimal);
    and (and_hex[0], in_hexa[0], sel_hexa);
    and (and_oct[0], in_octal[0], sel_octal);
    or  (out[0], and_dec[0], and_hex[0], and_oct[0]);
    
    // Bit 1
    and (and_dec[1], in_decimal[1], sel_decimal);
    and (and_hex[1], in_hexa[1], sel_hexa);
    and (and_oct[1], in_octal[1], sel_octal);
    or  (out[1], and_dec[1], and_hex[1], and_oct[1]);
    
    // Bit 2
    and (and_dec[2], in_decimal[2], sel_decimal);
    and (and_hex[2], in_hexa[2], sel_hexa);
    and (and_oct[2], in_octal[2], sel_octal);
    or  (out[2], and_dec[2], and_hex[2], and_oct[2]);
    
    // Bit 3
    and (and_dec[3], in_decimal[3], sel_decimal);
    and (and_hex[3], in_hexa[3], sel_hexa);
    and (and_oct[3], in_octal[3], sel_octal);
    or  (out[3], and_dec[3], and_hex[3], and_oct[3]);
    
    // Bit 4
    and (and_dec[4], in_decimal[4], sel_decimal);
    and (and_hex[4], in_hexa[4], sel_hexa);
    and (and_oct[4], in_octal[4], sel_octal);
    or  (out[4], and_dec[4], and_hex[4], and_oct[4]);
    
    // Bit 5
    and (and_dec[5], in_decimal[5], sel_decimal);
    and (and_hex[5], in_hexa[5], sel_hexa);
    and (and_oct[5], in_octal[5], sel_octal);
    or  (out[5], and_dec[5], and_hex[5], and_oct[5]);
    
    // Bit 6
    and (and_dec[6], in_decimal[6], sel_decimal);
    and (and_hex[6], in_hexa[6], sel_hexa);
    and (and_oct[6], in_octal[6], sel_octal);
    or  (out[6], and_dec[6], and_hex[6], and_oct[6]);
    
endmodule

// =================================================================
// MÓDULO: MUX 2-para-1 de 7 bits (estrutural)
// =================================================================
module mux_7bits_2to1(
    input [6:0] in_A,
    input [6:0] in_B,
    input sel,
    output [6:0] out
);
    // Instancia 7 MUXes de 1 bit
    A_Mux2x1 mux_bit0 (.sel(sel), .A(in_A[0]), .B(in_B[0]), .Y(out[0]));
    A_Mux2x1 mux_bit1 (.sel(sel), .A(in_A[1]), .B(in_B[1]), .Y(out[1]));
    A_Mux2x1 mux_bit2 (.sel(sel), .A(in_A[2]), .B(in_B[2]), .Y(out[2]));
    A_Mux2x1 mux_bit3 (.sel(sel), .A(in_A[3]), .B(in_B[3]), .Y(out[3]));
    A_Mux2x1 mux_bit4 (.sel(sel), .A(in_A[4]), .B(in_B[4]), .Y(out[4]));
    A_Mux2x1 mux_bit5 (.sel(sel), .A(in_A[5]), .B(in_B[5]), .Y(out[5]));
    A_Mux2x1 mux_bit6 (.sel(sel), .A(in_A[6]), .B(in_B[6]), .Y(out[6]));
endmodule

// =================================================================
// MÓDULO: Multiplexador de 8 Bits, 2 para 1
// =================================================================
module mux_register(

    // --- Portas de Entrada ---
    input  wire [7:0] data_in_A,      // Barramento de dados de entrada 
    input  wire [7:0] data_in_B,      // Barramento de dados de entrada 
    input  wire       select_line,   // Linha de seleção 

    // --- Porta de Saída ---
    output wire [7:0] data_out         // Barramento de dados de saída selecionado
);

    // --- Lógica do Circuito  ---
    
    A_Mux2x1 mux_bit0 (.sel(select_line), .A(data_in_A[0]), .B(data_in_B[0]), .Y(data_out[0]));
    A_Mux2x1 mux_bit1 (.sel(select_line), .A(data_in_A[1]), .B(data_in_B[1]), .Y(data_out[1]));
    A_Mux2x1 mux_bit2 (.sel(select_line), .A(data_in_A[2]), .B(data_in_B[2]), .Y(data_out[2]));
    A_Mux2x1 mux_bit3 (.sel(select_line), .A(data_in_A[3]), .B(data_in_B[3]), .Y(data_out[3]));
    A_Mux2x1 mux_bit4 (.sel(select_line), .A(data_in_A[4]), .B(data_in_B[4]), .Y(data_out[4]));
    A_Mux2x1 mux_bit5 (.sel(select_line), .A(data_in_A[5]), .B(data_in_B[5]), .Y(data_out[5]));
    A_Mux2x1 mux_bit6 (.sel(select_line), .A(data_in_A[6]), .B(data_in_B[6]), .Y(data_out[6]));
    A_Mux2x1 mux_bit7 (.sel(select_line), .A(data_in_A[7]), .B(data_in_B[7]), .Y(data_out[7]));

endmodule