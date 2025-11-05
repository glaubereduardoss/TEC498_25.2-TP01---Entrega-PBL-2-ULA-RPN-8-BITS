// =================================================================
// MÓDULO: Divisor de Frequência Principal
// =================================================================
module divisor_frequencia(
    input  wire clk_in,
    output wire main_clk_out, // Clock principal, mais lento
    output wire aux_clk_out,  // Clock auxiliar para debounce
    output wire btn_clk_out   // Clock auxiliar para botões
);

    // --- Fios Internos ---
    wire [6:0] div_chain;       // Fios para a cadeia de divisores por 5
    wire [2:0] ff_q;            // Saídas dos flip-flops finais
    wire       n_ff_q0, n_ff_q1, n_ff_q2; // Saídas invertidas dos FFs
    wire       n_main_clk;      // Fio para o clock de saída invertido

    // =================================================================
    // LÓGICA DO CIRCUITO
    // =================================================================

    // --- Inversores para a cadeia de flip-flops ---
    not(n_ff_q0, ff_q[0]);
    not(n_ff_q1, ff_q[1]);
    not(n_ff_q2, ff_q[2]);
    not(n_main_clk, main_clk_out);

    // --- Cadeia de 6 divisores por 5 ---
    dividir_5 div1 (.clk_in(clk_in),         .clk_out(div_chain[1]));
    dividir_5 div2 (.clk_in(div_chain[1]),   .clk_out(div_chain[2]));
    dividir_5 div3 (.clk_in(div_chain[2]),   .clk_out(div_chain[3]));
    dividir_5 div4 (.clk_in(div_chain[3]),   .clk_out(div_chain[4]));
    dividir_5 div5 (.clk_in(div_chain[4]),   .clk_out(div_chain[5]));
    dividir_5 div6 (.clk_in(div_chain[4]),   .clk_out(div_chain[6]));
    
    // --- Flip-flops finais para gerar clocks auxiliares e principal ---
    d_flipflop div7 (.data_out(ff_q[0]),      .data_in(n_ff_q0),    .reset_active_high(1'b0), .clock_signal(div_chain[6]));
    d_flipflop div8 (.data_out(ff_q[1]),      .data_in(n_ff_q1),    .reset_active_high(1'b0), .clock_signal(n_ff_q0));
    d_flipflop div9 (.data_out(ff_q[2]),      .data_in(n_ff_q2),    .reset_active_high(1'b0), .clock_signal(n_ff_q1));
    d_flipflop div10(.data_out(main_clk_out), .data_in(n_main_clk), .reset_active_high(1'b0), .clock_signal(n_ff_q2));

    // --- Saídas de Clocks Auxiliares ---
    and(aux_clk_out, ff_q[0], 1'b1);
    and(btn_clk_out, ff_q[1], 1'b1);

endmodule

// =================================================================
// MÓDULO: Divisor de Frequência por 5
// =================================================================
module dividir_5(
    input  wire clk_in,
    output wire clk_out
);

    // --- Fios Internos ---
    wire        reset_sig;    // Fio para o sinal de reset gerado internamente
    wire [2:0]  q;            // Fio para o estado do contador (saída dos FFs)
    wire        nq0, nq1, nq2;  // Fios para os estados invertidos



    // --- Inversores para realimentação dos Flip-Flops ---
    not(nq0, q[0]);
    not(nq1, q[1]);
    not(nq2, q[2]);
    
    // --- Lógica de Reset: Reseta quando o contador atinge 5 (101) ---
    and(reset_sig, q[0], q[2]);

    // --- Lógica de Saída: Derivada do bit mais significativo ---
    and(clk_out, q[2], 1'b1);

    // =================================================================
    // LÓGICA DOs (Flip-Flops)
    // =================================================================
    
	d_flipflop b0(
		 .data_in(nq0),
		 .clock_signal(clk_in),
		 .reset_active_high(reset_sig),
		 .data_out(q[0])
	);

	d_flipflop b1(
		 .data_in(nq1),
		 .clock_signal(nq0),
		 .reset_active_high(reset_sig),
		 .data_out(q[1])
	);

	d_flipflop b2(
		 .data_in(nq2),
		 .clock_signal(nq1),
		 .reset_active_high(reset_sig),
		 .data_out(q[2])
	);

endmodule

// =================================================================
// MÓDULO: Registrador de 8 Bits com Habilitação
// =================================================================
module register_8bit(
    input  wire [7:0] data_in,
    input  wire       enable_signal, // Habilitação - atua como clock para os FFs
    input  wire       reset_in,
    output wire [7:0] data_out
);

    // --- Lógica do Circuito (Instanciação dos Flip-Flops) ---
    d_flipflop dff0(.data_in(data_in[0]), .clock_signal(enable_signal), .reset_active_high(reset_in), .data_out(data_out[0]));
    d_flipflop dff1(.data_in(data_in[1]), .clock_signal(enable_signal), .reset_active_high(reset_in), .data_out(data_out[1]));
    d_flipflop dff2(.data_in(data_in[2]), .clock_signal(enable_signal), .reset_active_high(reset_in), .data_out(data_out[2]));
    d_flipflop dff3(.data_in(data_in[3]), .clock_signal(enable_signal), .reset_active_high(reset_in), .data_out(data_out[3]));
    d_flipflop dff4(.data_in(data_in[4]), .clock_signal(enable_signal), .reset_active_high(reset_in), .data_out(data_out[4]));
    d_flipflop dff5(.data_in(data_in[5]), .clock_signal(enable_signal), .reset_active_high(reset_in), .data_out(data_out[5]));
    d_flipflop dff6(.data_in(data_in[6]), .clock_signal(enable_signal), .reset_active_high(reset_in), .data_out(data_out[6]));
    d_flipflop dff7(.data_in(data_in[7]), .clock_signal(enable_signal), .reset_active_high(reset_in), .data_out(data_out[7]));

endmodule
// =================================================================
// MÓDULO: Flip-Flop D com Reset Ativo em Alto (Wrapper)
// =================================================================
module d_flipflop(
    input  wire data_in,           // Entrada de dados
    input  wire clock_signal,      // Sinal de clock
    input  wire reset_active_high, // Sinal de reset 
    output wire data_out           // Saída do flip-flop
);

    // --- Fios Internos ---
    wire reset_active_low; // Fio para o sinal de reset invertido

    // Inverte o sinal de reset de ativo-alto para ativo-baixo
    not(reset_active_low, reset_active_high);

    // Instancia o flip-flop D fundamental, que espera um reset ativo-baixo (clrn)
    dff flipflop_inst (
        .d(data_in),
        .clk(clock_signal),
        .clrn(reset_active_low), 
        .q(data_out)
    );

endmodule

// =================================================================
// MÓDULO: Shift Register com Controle de Execução
// =================================================================
module shift_register(
    // --- Portas de Entrada ---
    input  wire [7:0] data_in,      // Barramento de dados de entrada
    input  wire       enable_clk,   // Sinal de habilitação que atua como clock

    // --- Portas de Saída ---
    output wire [7:0] reg1_out,     // Saída do primeiro registrador
    output wire [7:0] reg2_out,     // Saída do segundo registrador
    output wire [7:0] reg3_out,     // Saída do terceiro registrador
    output wire       execute_pulse // Pulso de execução gerado no final do ciclo
);

    // --- Fios Internos ---
    wire [1:0] count_val;       // Fio para o valor atual do contador
    wire       n_count0;        // Fio para o bit 0 do contador invertido
    wire       is_state_2;      // Fio que fica em '1' quando o contador está em 2

    // =================================================================
    // CADEIA DE REGISTRADORES
    // =================================================================

    register_8bit reg1(
        .data_in(data_in),
        .enable_signal(enable_clk),
        .reset_in(1'b0),
        .data_out(reg1_out)
    );
    
    register_8bit reg2(
        .data_in(reg1_out),
        .enable_signal(enable_clk),
        .reset_in(1'b0),
        .data_out(reg2_out)
    );
    
    register_8bit reg3(
        .data_in(reg2_out),
        .enable_signal(enable_clk),
        .reset_in(1'b0),
        .data_out(reg3_out)
    );

// =================================================================
// LÓGICA DE CONTROLE
// =================================================================

    // --- Contador de estados síncrono (avança a cada pulso de 'enable_clk') ---
    contador_mod4 shift_register_counter(
        .enable_clk(enable_clk),
        .count_out(count_val)
    );

    // --- Lógica para detectar o estado 2 (binário 10) ---
    not(n_count0, count_val[0]);
    and(is_state_2, count_val[1], n_count0);

    // --- Flip-flop para gerar o pulso de execução ---
    // Armazena o sinal 'is_state_2', gerando o pulso na saída no ciclo seguinte.
    d_flipflop dff_execute(
        .data_in(is_state_2),
        .clock_signal(enable_clk),
        .reset_active_high(1'b0),
        .data_out(execute_pulse)
    );
endmodule

// =================================================================
// MÓDULO: DEBOUNCER
// =================================================================
module switch_debouncer(
    // --- Portas de Entrada ---
    input wire clk,   // clock principal da FPGA
    input wire reset,
    input wire botao_raw,   // botão com bounce
	 
    // --- Portas de Saída ---
    output wire botao_ok    // botão estável
);
    wire clk_out, clk_aux, clk_botao;

// --- Gera os clocks mais lentos para o sistema ---
	divisor_frequencia div_inst(
		.clk_in(clk),
		.main_clk_out(clk_out),
		.aux_clk_out(clk_aux),
		.btn_clk_out(clk_botao)
);

    // sincroniza o botão
	 
    wire botao_sync;
	 
	d_flipflop sync1(
		 .data_in(botao_raw),
		 .clock_signal(clk_botao),
		 .reset_active_high(reset),
		 .data_out(botao_sync)
);

    // saída estável
	d_flipflop stable(
		.data_in(botao_sync),
		.clock_signal(clk_botao),
		.reset_active_high(reset),
		.data_out(botao_ok)
);
endmodule

// =================================================================
// MÓDULO: Contador Módulo 4 (0 a 3)
// =================================================================
module contador_mod4(
    // --- Portas de Entrada ---
    input  wire enable_clk,    // Habilitação/Clock para o contador avançar

    // --- Porta de Saída ---
    output wire [1:0] count_out   // Saída de 2 bits com o valor da contagem
);

    // --- Fios Internos ---
    wire next_q0; // Fio para o próximo estado do bit 0 (Q0_n = ~Q0)
    wire next_q1; // Fio para o próximo estado do bit 1 (Q1_n = Q1 ^ Q0)

    // --- Lógica Combinacional para o Próximo Estado ---
    not(next_q0, count_out[0]);
    xor(next_q1, count_out[1], count_out[0]);

    // --- Lógica Sequencial (Registradores de Estado) ---
    d_flipflop dff0(.data_in(next_q0), .clock_signal(enable_clk), .reset_active_high(1'b0), .data_out(count_out[0]));
    d_flipflop dff1(.data_in(next_q1), .clock_signal(enable_clk), .reset_active_high(1'b0), .data_out(count_out[1]));

endmodule