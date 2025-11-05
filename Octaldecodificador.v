module Octaldecodificador(output [6:0] C, D, U, input [7:0] A);
	A_4bits_decodeOCtal octalcentena(C[6:0], {1'b0, A[7:6]});
	A_4bits_decodeOCtal octaldezena(D[6:0], A[5:3]);
	A_4bits_decodeOCtal octalunidade(U[6:0], A[2:0]);
endmodule

module A_4bits_decodeOCtal(output [6:0] S, input [2:0] A);
		
	wire [2:0] N;
	wire [13:0] F;

	not(N[0], A[0]);
	not(N[1], A[1]);
	not(N[2], A[2]);

	//a
	and(F[1], A[2], N[1], N[0]);
	and(F[2], N[2],N[1],A[0]);
	or(S[0], F[1], F[2]);

	//b
	and(F[3], A[2], N[1], A[0]);
	and(F[4], A[2], A[1], N[0]);
	or(S[1], F[3], F[4]);

	//c
	and(S[2], N[2], A[1], N[0]);

	//d
	and(F[5], N[2], N[1], A[0]);
	and(F[6], A[2], N[1], N[0]);
	and(F[7], A[2], A[1], A[0] );
	or(S[3], F[5], F[6], F[7]);

	//e
	and(F[8], A[2], N[1]);
	or(S[4], A[0], F[8]);

	//f
	and(F[9], N[2], A[0]);
	and(F[10], A[1], A[0]);
	and(F[11], N[2], A[1], N[0]);
	or(S[5], F[9], F[10], F[11]);

	//g
	and(F[12], N[2], N[1]);
	and(F[13], A[2], A[1], A[0]);
	or(S[6], F[12], F[13]);
	
endmodule
