module A_8bits_XOR(output [7:0] S, input [7:0] A, B);
	A_4bits_XOR xor0(S[3:0], A[3:0], B[3:0]);
	A_4bits_XOR xor1(S[7:4], A[7:4], B[7:4]);
endmodule

module A_4bits_XOR(output [3:0] Y, input [3:0] A, B);
    xor ouex0(Y[0], A[0], B[0]);
    xor ouex1(Y[1], A[1], B[1]);
    xor ouex2(Y[2], A[2], B[2]);
    xor ouex3(Y[3], A[3], B[3]);
endmodule

module A_4bits_OR(output [3:0] Y, input [3:0] A, B);
    or ou0(Y[0], A[0], B[0]);
    or ou1(Y[1], A[1], B[1]);
    or ou2(Y[2], A[2], B[2]);
    or ou3(Y[3], A[3], B[3]);
endmodule

module A_8bits_OR(output [7:0] S, input [7:0] A, B);
	A_4bits_OR or1(S[3:0], A[3:0], B[3:0]);
	A_4bits_OR or2(S[7:4], A[7:4], B[7:4]);
endmodule

module A_4bits_AND( output [3:0]Y, input [3:0]A, B);
	and e0(Y[0], A[0], B[0]);
   and e1(Y[1], A[1], B[1]);
   and e2(Y[2], A[2], B[2]);
   and e3(Y[3], A[3], B[3]);
endmodule

module A_8bits_AND(output [7:0] S, input [7:0] A, B);
	A_4bits_AND and0(S[3:0], A[3:0], B[3:0]);
	A_4bits_AND and1(S[7:4], A[7:4], B[7:4]);
endmodule

module A_8bits_NOT(output [7:0] S, input [7:0] A);
    not(S[0], A[0]);
    not(S[1], A[1]);
    not(S[2], A[2]);
    not(S[3], A[3]);
    not(S[4], A[4]);
    not(S[5], A[5]);
    not(S[6], A[6]);
    not(S[7], A[7]);
endmodule