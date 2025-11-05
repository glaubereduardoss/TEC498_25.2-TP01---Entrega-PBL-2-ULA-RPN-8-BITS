module A_halfsubtractor(output Diff, Bo, input A, B);
	//not A
	wire nA;
	not(nA, A);
	
	//AxorB
	xor(Diff, A, B);
	//Borrow out
	and(Bo, nA, B);
	
endmodule

module A_fullsubtractor(output Bo, S, input A, B, Bi);
    //Borrow out
    wire b1, b2, b3;
    //Difference and Borrow out
    
    // hs0(Diff, Bo, A, B)
    A_halfsubtractor hs0(b2, b1, A, B); // b2 = A^B, b1 = (!A)&B
    
    // hs1(Diff, Bo, A, B)
    // CORRIGIDO: O primeiro port é 'Diff' (S), o segundo é 'Bo' (b3)
    A_halfsubtractor hs1 (S, b3, b2, Bi); // S = b2^Bi, b3 = (!b2)&Bi
    
    or or0(Bo, b1, b3); // Bo = b1 | b3
endmodule

module A_4Bits_fullsubtractor(output [3:0] Diff, output Bo, input [3:0] A, B, input Bi);

    wire b1, b2, b3;
	 
    A_fullsubtractor fs0 (b1, Diff[0], A[0] ,B[0], Bi);
    A_fullsubtractor fs1 (b2, Diff[1], A[1] ,B[1], b1);
    A_fullsubtractor fs2 (b3, Diff[2], A[2] ,B[2], b2);
    A_fullsubtractor fs3 (Bo, Diff[3], A[3] ,B[3], b3);
	 
endmodule

module A_8bits_fullsubtractor(output [7:0] Diff, output Bo, input [7:0] A, B, input Bi);
	
	// Wires para conectar borrow in no borrow out
	wire b1, b2, b3, b4, b5, b6, b7;
	
	// Primeiro bit (coluna)
	A_fullsubtractor fs0(b1, Diff[0], A[0], B[0], Bi);
	// Segundo bit (coluna)
	A_fullsubtractor fs1(b2, Diff[1], A[1], B[1], b1);
	// Terceiro bit (coluna)
	A_fullsubtractor fs2(b3, Diff[2], A[2], B[2], b2);
	// Quarto bit (coluna)
	A_fullsubtractor fs3(b4, Diff[3], A[3], B[3], b3);
	// Quinto bit (coluna)
	A_fullsubtractor fs4(b5, Diff[4], A[4], B[4], b4);
	// Sexto bit (coluna)
	A_fullsubtractor fs5(b6, Diff[5], A[5], B[5], b5);
	// Sétimo bit (coluna)
	A_fullsubtractor fs6(b7, Diff[6], A[6], B[6], b6);
	// Oitavo bit (coluna)
	A_fullsubtractor fs7(Bo, Diff[7], A[7], B[7], b7);
	
endmodule
