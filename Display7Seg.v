// =================================================================
// MÓDULO: Display de 7 Segmentos para RESULTADO (3 displays)
// =================================================================
module Display7Seg(
    input [15:0] Data,
    input [1:0] sel,
    output [6:0] d1, d2, d3  // Apenas 3 displays
);
    
    // -------------------------
    // Fios para saídas dos decodificadores
    // -------------------------
    wire [6:0] dec_C, dec_D, dec_U;
    wire [6:0] hex_D, hex_U;
    wire [6:0] oct_C, oct_D, oct_U;
    
    // -------------------------
    // Fio para display apagado
    // -------------------------
    wire [6:0] display_apagado;
    
    and (display_apagado[0], 1'b1, 1'b1);
    and (display_apagado[1], 1'b1, 1'b1);
    and (display_apagado[2], 1'b1, 1'b1);
    and (display_apagado[3], 1'b1, 1'b1);
    and (display_apagado[4], 1'b1, 1'b1);
    and (display_apagado[5], 1'b1, 1'b1);
    and (display_apagado[6], 1'b1, 1'b1);
    
    // -------------------------
    // Instanciação dos Decodificadores
    // -------------------------
    Decimaldecodificador dec_inst(
        .bin_in(Data[7:0]),
        .segC(dec_C),
        .segD(dec_D),
        .segU(dec_U)
    );
    
    Hexadecodificador hex_inst(
        .A(Data[7:0]),
        .D(hex_D),
        .U(hex_U)
    );
    
    Octaldecodificador oct_inst(
        .A(Data[7:0]),
        .C(oct_C),
        .D(oct_D),
        .U(oct_U)
    );
    
    // -------------------------
    // Lógica de Seleção
    // -------------------------
    wire sel_decimal, sel_hexa, sel_octal;
    wire not_sel0, not_sel1;
    
    not (not_sel0, sel[0]);
    not (not_sel1, sel[1]);
    
    and (sel_decimal, sel[1], sel[0]);   // 11 = Decimal
    and (sel_hexa, not_sel1, sel[0]);    // 01 = Hexadecimal
    and (sel_octal, sel[1], not_sel0);   // 10 = Octal
    
    // -------------------------
    // MUXes para os 3 displays
    // -------------------------
    mux_7bits_3to1 mux_d1(
        .in_decimal(dec_U),
        .in_hexa(hex_U),
        .in_octal(oct_U),
        .sel_decimal(sel_decimal),
        .sel_hexa(sel_hexa),
        .sel_octal(sel_octal),
        .out(d1)
    );
    
    mux_7bits_3to1 mux_d2(
        .in_decimal(dec_D),
        .in_hexa(hex_D),
        .in_octal(oct_D),
        .sel_decimal(sel_decimal),
        .sel_hexa(sel_hexa),
        .sel_octal(sel_octal),
        .out(d2)
    );
    
    mux_7bits_3to1 mux_d3(
        .in_decimal(dec_C),
        .in_hexa(display_apagado),  // Hexa não usa centena
        .in_octal(oct_C),
        .sel_decimal(sel_decimal),
        .sel_hexa(sel_hexa),
        .sel_octal(sel_octal),
        .out(d3)
    );
    
endmodule

// =================================================================
// MÓDULO: Display de 7 Segmentos para RESTO (3 displays)
// =================================================================
module Display7Seg_Resto(
    input [7:0] Resto,       // Resto da divisão (8 bits)
    input [1:0] sel,         // Seleção de base
    input enable,            // Habilita exibição (só em divisão)
    output [6:0] d4, d5, d6  // Displays 3, 4, 5
);
    
    // -------------------------
    // Fios para decodificadores do resto
    // -------------------------
    wire [6:0] resto_dec_C, resto_dec_D, resto_dec_U;
    wire [6:0] resto_hex_D, resto_hex_U;
    wire [6:0] resto_oct_C, resto_oct_D, resto_oct_U;
    
    // -------------------------
    // Fio para display apagado
    // -------------------------
    wire [6:0] display_apagado;
    
    and (display_apagado[0], 1'b1, 1'b1);
    and (display_apagado[1], 1'b1, 1'b1);
    and (display_apagado[2], 1'b1, 1'b1);
    and (display_apagado[3], 1'b1, 1'b1);
    and (display_apagado[4], 1'b1, 1'b1);
    and (display_apagado[5], 1'b1, 1'b1);
    and (display_apagado[6], 1'b1, 1'b1);
    
    // -------------------------
    // Decodificadores do Resto
    // -------------------------
    Decimaldecodificador resto_dec_inst(
        .bin_in(Resto),
        .segC(resto_dec_C),
        .segD(resto_dec_D),
        .segU(resto_dec_U)
    );
    
    Hexadecodificador resto_hex_inst(
        .A(Resto),
        .D(resto_hex_D),
        .U(resto_hex_U)
    );
    
    Octaldecodificador resto_oct_inst(
        .A(Resto),
        .C(resto_oct_C),
        .D(resto_oct_D),
        .U(resto_oct_U)
    );
    
    // -------------------------
    // Lógica de Seleção
    // -------------------------
    wire sel_decimal, sel_hexa, sel_octal;
    wire not_sel0, not_sel1;
    
    not (not_sel0, sel[0]);
    not (not_sel1, sel[1]);
    
    and (sel_decimal, sel[1], sel[0]);   // 11 = Decimal
    and (sel_hexa, not_sel1, sel[0]);    // 01 = Hexadecimal
    and (sel_octal, sel[1], not_sel0);   // 10 = Octal
    
    // -------------------------
    // Fios intermediários para MUX com enable
    // -------------------------
    wire [6:0] d4_selected, d5_selected, d6_selected;
    
    // MUX de base para d4 (unidade do resto)
    mux_7bits_3to1 mux_d4_base(
        .in_decimal(resto_dec_U),
        .in_hexa(resto_hex_U),
        .in_octal(resto_oct_U),
        .sel_decimal(sel_decimal),
        .sel_hexa(sel_hexa),
        .sel_octal(sel_octal),
        .out(d4_selected)
    );
    
    // MUX de base para d5 (dezena do resto)
    mux_7bits_3to1 mux_d5_base(
        .in_decimal(resto_dec_D),
        .in_hexa(resto_hex_D),
        .in_octal(resto_oct_D),
        .sel_decimal(sel_decimal),
        .sel_hexa(sel_hexa),
        .sel_octal(sel_octal),
        .out(d5_selected)
    );
    
    // MUX de base para d6 (centena do resto)
    mux_7bits_3to1 mux_d6_base(
        .in_decimal(resto_dec_C),
        .in_hexa(display_apagado),  // Hexa não usa centena
        .in_octal(resto_oct_C),
        .sel_decimal(sel_decimal),
        .sel_hexa(sel_hexa),
        .sel_octal(sel_octal),
        .out(d6_selected)
    );
    
    // -------------------------
    // MUX final com enable (mostra ou apaga)
    // -------------------------
    mux_7bits_2to1 mux_d4_enable(
        .in_A(display_apagado),  // Se enable=0, apaga
        .in_B(d4_selected),      // Se enable=1, mostra resto
        .sel(enable),
        .out(d4)
    );
    
    mux_7bits_2to1 mux_d5_enable(
        .in_A(display_apagado),
        .in_B(d5_selected),
        .sel(enable),
        .out(d5)
    );
    
    mux_7bits_2to1 mux_d6_enable(
        .in_A(display_apagado),
        .in_B(d6_selected),
        .sel(enable),
        .out(d6)
    );
    
endmodule