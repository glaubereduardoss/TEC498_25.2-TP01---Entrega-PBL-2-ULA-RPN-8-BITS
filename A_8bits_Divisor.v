// =================================================================
// MÓDULO : OPERAÇÃO Divisor de 8 bits (CORREÇÃO DE BIT-WIDTH)
// =================================================================
module A_8bits_Divisor(
    input [7:0] A, // Dividendo (8 bits)
    input [7:0] B, // Divisor (8 bits)
    output [7:0] Q, // Quociente (8 bits)
    output [7:0] R  // Resto (8 bits)
);
    wire bout0, bout1, bout2, bout3, bout4, bout5, bout6, bout7;
    wire [7:0] subout0, subout1, subout2, subout3, subout4, subout5, subout6, subout7;
    // prem é sempre 8 bits
    wire [7:0] prem0, prem1, prem2, prem3, prem4, prem5, prem6;
    
    // --- Passo 1 (MSB - para Q[7]) ---
    // A entrada A do subtrator precisa de 8 bits: {7 zeros, A[7]}
    A_8bits_fullsubtractor sub0 (.A({7'b0, A[7]}), .B(B), .Bi(1'b0), .Diff(subout0), .Bo(bout0));
    A_8bits_Mux mux0 (.sel(bout0), .X(subout0), .Y({7'b0, A[7]}), .S(prem0));
    not(Q[7], bout0);
    
    // --- Passo 2 (para Q[6]) ---
    // A entrada A do subtrator precisa de 8 bits: {7 bits do resto anterior, A[6]}
    A_8bits_fullsubtractor sub1 (.A({prem0[6:0], A[6]}), .B(B), .Bi(1'b0), .Diff(subout1), .Bo(bout1));
    A_8bits_Mux mux1 (.sel(bout1), .X(subout1), .Y({prem0[6:0], A[6]}), .S(prem1));
    not(Q[6], bout1);
    
    // --- Passo 3 (para Q[5]) ---
    A_8bits_fullsubtractor sub2 (.A({prem1[6:0], A[5]}), .B(B), .Bi(1'b0), .Diff(subout2), .Bo(bout2));
    A_8bits_Mux mux2 (.sel(bout2), .X(subout2), .Y({prem1[6:0], A[5]}), .S(prem2));
    not(Q[5], bout2);
    
    // --- Passo 4 (para Q[4]) ---
    A_8bits_fullsubtractor sub3 (.A({prem2[6:0], A[4]}), .B(B), .Bi(1'b0), .Diff(subout3), .Bo(bout3));
    A_8bits_Mux mux3 (.sel(bout3), .X(subout3), .Y({prem2[6:0], A[4]}), .S(prem3));
    not(Q[4], bout3);
    
    // --- Passo 5 (para Q[3]) ---
    A_8bits_fullsubtractor sub4 (.A({prem3[6:0], A[3]}), .B(B), .Bi(1'b0), .Diff(subout4), .Bo(bout4));
    A_8bits_Mux mux4 (.sel(bout4), .X(subout4), .Y({prem3[6:0], A[3]}), .S(prem4));
    not(Q[3], bout4);
    
    // --- Passo 6 (para Q[2]) ---
    A_8bits_fullsubtractor sub5 (.A({prem4[6:0], A[2]}), .B(B), .Bi(1'b0), .Diff(subout5), .Bo(bout5));
    A_8bits_Mux mux5 (.sel(bout5), .X(subout5), .Y({prem4[6:0], A[2]}), .S(prem5));
    not(Q[2], bout5);
    
    // --- Passo 7 (para Q[1]) ---
    A_8bits_fullsubtractor sub6 (.A({prem5[6:0], A[1]}), .B(B), .Bi(1'b0), .Diff(subout6), .Bo(bout6));
    A_8bits_Mux mux6 (.sel(bout6), .X(subout6), .Y({prem5[6:0], A[1]}), .S(prem6));
    not(Q[1], bout6);
    
    // --- Passo 8 (LSB - para Q[0] e Resto final R) ---
    A_8bits_fullsubtractor sub7 (.A({prem6[6:0], A[0]}), .B(B), .Bi(1'b0), .Diff(subout7), .Bo(bout7));
    A_8bits_Mux mux7 (.sel(bout7), .X(subout7), .Y({prem6[6:0], A[0]}), .S(R));
    not(Q[0], bout7);
    
endmodule