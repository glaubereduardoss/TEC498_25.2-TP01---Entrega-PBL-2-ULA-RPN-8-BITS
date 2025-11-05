module ZEFlag8(input [7:0] R, output Z);
    wire t1, t2, t3, t4, t5, t6, t7;
    or (t1, R[0], R[1]);
    or (t2, R[2], R[3]);
    or (t3, R[4], R[5]);
    or (t4, R[6], R[7]);
    or (t5, t1, t2);
    or (t6, t3, t4);
    or (t7, t5, t6);
    not (Z, t7);
endmodule
