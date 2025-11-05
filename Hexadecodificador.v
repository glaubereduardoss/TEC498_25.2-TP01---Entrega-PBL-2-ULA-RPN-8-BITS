module Hexadecodificador(output[6:0] D, U, input [7:0]A);
	A_4bits_decodeHexa hexdezena(D[6:0], A[7:4]);
	A_4bits_decodeHexa hexunidade(U[6:0], A[3:0]);
endmodule

module A_4bits_decodeHexa(output [6:0] S, input [3:0] A);

	wire [3:0] N;
	wire [25:0] F;
	
	not(N[0], A[0]);
	not(N[1], A[1]);
	not(N[2], A[2]);
	not(N[3], A[3]);
	
	//a
	and(F[1],N[3], N[2], N[1], A[0]);
	and(F[2],N[3], A[2], N[1], N[0]);
	and(F[3], A[3], A[2], N[1], A[0]);
	and(F[4], A[3], N[2], A[1], A[0]);
	or(S[0], F[1], F[2], F[3], F[4]);
	
	//b
	and(F[5], N[3], A[2], N[1], A[0]);
	and(F[6], A[3], A[2], N[0]);
	and(F[7], A[2], A[1], N[0]);
	and(F[8], A[3], A[1], A[0]);
	or(S[1], F[5], F[6], F[7], F[8]);
	
	//c
	and(F[9], N[3], N[2], A[1], N[0]);
	and(F[10], A[3], A[2], N[0]);
	and(F[11], A[3], A[2], A[1]);
	or(S[2], F[9], F[10], F[11]);
	
	//d
	and(F[12], N[3], N[2], N[1], A[0]);
	and(F[13], N[3], A[2], N[1], N[0]);
	and(F[14], A[2], A[1], A[0]);
	and(F[15], A[3], N[2], A[1], N[0]);
	or(S[3], F[12], F[13], F[14], F[15]);
	
	//e
	and(F[16], N[3], A[0]);
	and(F[17], N[3], A[2], N[1]);
	and(F[18], N[2], N[1], A[0]);
	or(S[4], F[16], F[17], F[18]);
	
	//f
	and(F[19], A[3], A[2], N[1], A[0]);
	and(F[20], N[3], N[2], A[0]);
	and(F[21], N[3], N[2], A[1]);
	and(F[22], N[3], A[1], A[0]);
	or(S[5], F[19], F[20], F[21], F[22]);
	
	//g
	and(F[23], N[3], N[2], N[1]);
	and(F[24], A[3], A[2], N[1], N[0]);
	and(F[25], N[3], A[2], A[1], A[0]);
	or(S[6], F[23], F[24], F[25]);
	
endmodule
