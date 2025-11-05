module A_halfadder(output Co,S, input A,B);
	//Sum
	xor (S, A,B);
	//Carry out
	and (Co, A,B);
endmodule

module A_fulladder(output Co,S, input A,B,Ci);
	//Wires
	wire AxorB, AandB, CinAxorB;
	
	//Sum
	xor ouex0(AxorB,A,B);
	xor ouex1(S,AxorB,Ci);
	
	//Carry out
	and e0(AandB, A, B);
	and e1(CinAxorB, Ci, AxorB);
	or ou0(Co, AandB, CinAxorB);
	
endmodule

module A_4Bits_fulladder(output[3:0] S, output Co, input[3:0] A,B, input Ci);
	
	//Wires to connect carry in on carry out
	wire c1,c2,c3;
	
	//First bit(column)
	A_fulladder full1(c1, S[0], A[0], B[0], Ci);
	//Second bit(column)
	A_fulladder full2(c2, S[1], A[1], B[1], c1);
	//Third bit(column)
	A_fulladder full3(c3, S[2], A[2], B[2], c2);
	//Fourth bit(column)
	A_fulladder full4(Co, S[3], A[3], B[3], c3);
endmodule

module A_8bits_fulladder(output [7:0] S, output Co, input[7:0] A, B, input Ci);
	
	// Wires para conectar carry in no carry out
	wire c1, c2, c3, c4, c5, c6, c7;
	
	// Primeiro bit (coluna)
	A_fulladder full1(c1, S[0], A[0], B[0], Ci);
	// Segundo bit (coluna)
	A_fulladder full2(c2, S[1], A[1], B[1], c1);
	// Terceiro bit (coluna)
	A_fulladder full3(c3, S[2], A[2], B[2], c2);
	// Quarto bit (coluna)
	A_fulladder full4(c4, S[3], A[3], B[3], c3);
	// Quinto bit (coluna)
	A_fulladder full5(c5, S[4], A[4], B[4], c4);
	// Sexto bit (coluna)
	A_fulladder full6(c6, S[5], A[5], B[5], c5);
	// Sétimo bit (coluna)
	A_fulladder full7(c7, S[6], A[6], B[6], c6);
	// Oitavo bit (coluna)
	A_fulladder full8(Co, S[7], A[7], B[7], c7);
	
endmodule

module A_16bits_fulladder(Cout, S, A, B);
    input [15:0]A;
    input [15:0]B;
    output Cout;
    output [15:0]S;
    wire [14:0]Co;
    
    A_fulladder somador1(Co[0], S[0], A[0], B[0], 1'b0);
    A_fulladder somador2(Co[1], S[1], A[1], B[1], Co[0]);
    A_fulladder somador3(Co[2], S[2], A[2], B[2], Co[1]);
    A_fulladder somador4(Co[3], S[3], A[3], B[3], Co[2]);
    A_fulladder somador5(Co[4], S[4], A[4], B[4], Co[3]);
    A_fulladder somador6(Co[5], S[5], A[5], B[5], Co[4]);
    A_fulladder somador7(Co[6], S[6], A[6], B[6], Co[5]);
    A_fulladder somador8(Co[7], S[7], A[7], B[7], Co[6]);
    A_fulladder somador9(Co[8], S[8], A[8], B[8], Co[7]);
    A_fulladder somador10(Co[9], S[9], A[9], B[9], Co[8]);
    A_fulladder somador11(Co[10], S[10], A[10], B[10], Co[9]);
    A_fulladder somador12(Co[11], S[11], A[11], B[11], Co[10]);
    A_fulladder somador13(Co[12], S[12], A[12], B[12], Co[11]);
    A_fulladder somador14(Co[13], S[13], A[13], B[13], Co[12]);
    A_fulladder somador15(Co[14], S[14], A[14], B[14], Co[13]);
    A_fulladder somador16(Cout, S[15], A[15], B[15], Co[14]);
endmodule
