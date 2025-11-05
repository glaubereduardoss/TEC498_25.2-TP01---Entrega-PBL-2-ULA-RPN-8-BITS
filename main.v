// =================================================================
// MÓDULO PRINCIPAL: Calculadora RPN com Display de 7 Segmentos
// =================================================================
module main(
    // --- Entradas Físicas da Placa ---
   input  wire [7:0] A,                 // 8 chaves para entrada de dados (SW7..SW0)
   input  wire [1:0] sel_ope,           // 2 botões para seleção de operação
   input  wire       Enable,            // Botão "Enter" para executar a operação
   input  wire       clk,               // Sinal de clock de 50MHz da placa
   input  wire       last_operation,    // Chave para usar o resultado anterior como operando A
   input  wire       reset,             

    // --- Saídas para a Placa ---
   output wire [6:0] d3, d2, d1,      // Displays 0-2: RESULTADO
   output wire [6:0] d6, d5, d4,     // Displays 3-5: RESTO
   output wire       FlagCarryOut,      // LED para a flag de Carry Out/Borrow Out
   output wire       FlagErro,          // LED para a flag de Erro (ex: divisão por zero)
   output wire       FlagZero,          // LED para a flag de Zero
   output wire       FlagOverflow,      // LED para a flag de Overflow da ULA
   output wire       overflow_result,   // Saída não utilizada no momento
   output wire       overflow_muitos_bits, // Saída não utilizada no momento
	output wire Dp
);
	 
	//===================Shift register/debounce==========================
	
	// --- Fios do Caminho de Dados (Datapath) ---
   wire [7:0] Data_A, Data_B, Data_in; // Fios para os valores dos Registradores A, B e entrada
   wire [7:0] last_result;             // Fio para o feedback do resultado anterior
   wire [2:0] Ope;                     // Fio para o código da operação selecionada
   wire       executar, not_executar;  // Sinal que habilita a execução da operação
	
	// --- Registrador para armazenar o resultado da última operação ---
	register_8bit reg_last_result(
		 .data_in(mux[7:0]),
		 .enable_signal(register_pulse),
		 .reset_in(reset),
		 .data_out(last_result)
);
	
	mux_register mux_last_operation(
		.data_in_A(A),                   
		.data_in_B(last_result),         
		.select_line(last_operation),    
		.data_out(Data_in)              
);
	
	top top_inst(
		 .clk_in(clk),
		 .switch(Enable),
		 .data_in(Data_in),
		 .reg1_out(Ope),
		 .reg2_out(Data_B),
		 .reg3_out(Data_A),
		 .execute_out(executar)
);

//===================================================================
//===================================================================	
//OPERAÇÕES ARITMETICAS
//===================================================================
//===================================================================	
	
   // --- Fios de Saída da ULA ---
   wire [8:0]  Som, Ss;                       // Saída da soma/subtração (8 bits) com o carry (1 bit)
   wire [15:0] Sm;                      // Saída da multiplicação (16 bits)
   wire [7:0] Sa, So, Sxor, Snot; // Saídas das operações lógicas
   wire [15:0] mux;                     // Fio para a saída do multiplexador de resultados
   wire [7:0] Sd, Resto;							//Resto da divisão
	
//===================================================================	
//SOMADOR
//===================================================================

	A_8bits_fulladder sum(
		.S(Som[7:0]),
		.Co(Som[8]),
		.A(Data_A),
		.B(Data_B), 
		.Ci(1'b0)
);

//===================================================================
//SUBTRATOR
//===================================================================

	A_8bits_fullsubtractor sub(
		.Diff(Ss[7:0]),
		.Bo(Ss[8]),
		.A(Data_A),
		.B(Data_B), 
		.Bi(1'b0)
);

//===================================================================	
//DIVISOR
//===================================================================
	
	A_8bits_Divisor div(
		.A(Data_A),
		.B(Data_B),
		.Q(Sd),
		.R(Resto)
);

//===================================================================	
//MULTIPLICADOR 8x8 BITS
//===================================================================

    wire mult_start;
    wire mult_done;
    wire mult_busy;
    wire [15:0] mult_produto;
    wire executar_estendido;
    wire is_mult_operation;
    wire not_ope_bit0, not_ope_bit2;
	 
    // Detecta se a operação é multiplicação (Ope = 010)
    not (not_ope_bit0, Ope[0]);
    not (not_ope_bit2, Ope[2]);
    and (is_mult_operation, not_ope_bit2, Ope[1], not_ope_bit0); 
    
    // Gera pulso de start quando executar=1 E operação é multiplicação
    and (mult_start, executar, is_mult_operation);
	 
    // Mantém executar ativo enquanto a multiplicação está rodando
    or (executar_estendido, executar, mult_busy);
	
    // Instancia o multiplicador 8x8 bits
    multiplicador_8x8 u_multiplicador(
        .clk(clk),
        .reset(reset),
        .start(mult_start),
        .A(Data_A),
        .B(Data_B),
        .out(mult_produto),
        .busy(mult_busy),
        .done(mult_done)
    );
    
    // Conecta a saída do multiplicador ao fio Sm
    assign Sm=mult_produto;

//===================================================================
//===================================================================	
//OPERAÇÕES LOGICAS
//===================================================================
//===================================================================


//===================================================================
//AND
//===================================================================
	A_8bits_AND andeh(
		.S(Sa),
		.A(Data_A),
		.B(Data_B)
);
//===================================================================		
//OR
//===================================================================
	A_8bits_OR oreh(
		.S(So),
		.A(Data_A),
		.B(Data_B)
);

//===================================================================		
//XOR
//===================================================================

	A_8bits_XOR xoreh(
		.S(Sxor),
		.A(Data_A),
		.B(Data_B)
);


//===================================================================	
//	NOT
//===================================================================

	A_8bits_NOT noteh(
		.S(Snot),
		.A(Data_A)
);

//===================================================================	
//	MUX PRINCIPAL
//===================================================================

	mux mux_main(
		 .data_in_0(Som),         // Saída da Soma 000
		 .data_in_1(Ss),        // Saída da Subtração 001
		 .data_in_2(Sm),        // Saída da Multiplicação 010
		 .data_in_3(Sd),        // Saída da Divisão 011
		 .data_in_4(Sa),        // Saída da operação AND 100
		 .data_in_5(So),        // Saída da operação OR  101
		 .data_in_6(Sxor),      // Saída da operação XOR 110
		 .data_in_7(Snot),      // Saída da operação NOT 111
		 .select_lines(Ope),    // Seletor da operação
		 .enable_mux(executar_estendido), // Habilita a saída do MUX
		 .data_out(mux)         // Saída final de 16 bits
);
	
//===================================================================    
//    FLAGS
//===================================================================

// --- Flag C (Carry/Borrow) - Compartilhada entre Soma e Subtração ---
	wire flag_c_interno;
	wire is_soma, is_subtracao;

// Detecta se é soma (000) ou subtração (001)
	and (is_soma, ~Ope[2], ~Ope[1], ~Ope[0]);
	and (is_subtracao, ~Ope[2], ~Ope[1], Ope[0]);

// Multiplexador manual: mostra carry da soma OU borrow da subtração
	wire carry_selected, borrow_selected;
	and (carry_selected, Som[8], is_soma);
	and (borrow_selected, Ss[8], is_subtracao);
	or (flag_c_interno, carry_selected, borrow_selected);

// Ativa o LED apenas quando está executando
	and (FlagCarryOut, flag_c_interno, executar_estendido);

// --- Flag Overflow - Para QUALQUER operação quando resultado > 255 ---
	wire flag_overflow_interno;

	// Detecta overflow: qualquer bit alto [15:8] do resultado final
	or (flag_overflow_interno, mux[8], mux[9], mux[10], mux[11], 
	                           mux[12], mux[13], mux[14], mux[15]);
	
	// Ativa o LED apenas quando está executando
	and (FlagOverflow, flag_overflow_interno, executar_estendido);

// --- Flag Erro - Só para DIVISÃO (011) quando B = 0 ---
	wire flag_erro_interno;
	wire is_divisao, b_eh_zero;

	and (is_divisao, ~Ope[2], Ope[1], Ope[0]);
	
	// Usa o módulo ZEFlag8 para verificar se B = 0
	ZEFlag8 check_b_zero(
		.R(Data_B),
		.Z(b_eh_zero)
	);
	
	and (flag_erro_interno, is_divisao, b_eh_zero);
	and (FlagErro, flag_erro_interno, executar_estendido);

// --- Flag Zero - TODAS as operações (checa se os 8 bits exibidos = 0) ---
	wire flag_zero_interno;
	
	// Verifica se os 8 bits baixos [7:0] são zero (o que é exibido no display)
	ZEFlag8 check_zero(
		.R(mux[7:0]),
		.Z(flag_zero_interno)
	);
	
	and (FlagZero, flag_zero_interno, executar_estendido);

	
//===================================================================	
//	REGISTRADOR DO  ÚLTIMO RESULTADO
//===================================================================
	wire register_pulse, clk_dividido, overflow_result_prev;
	
	// Detecta overflow: OR dos bits altos [15:8] do resultado
	or (overflow_result_prev, mux[8], mux[9], mux[10], mux[11], 
	                          mux[12], mux[13], mux[14], mux[15]);
	
	d_flipflop dff0(
		 .data_in(overflow_result_prev),
		 .clock_signal(register_pulse),
		 .reset_active_high(reset),
		 .data_out(overflow_result)
);

	dividir_5 div_clk(
		 .clk_in(clk),
		 .clk_out(clk_dividido)
);

	wire exec_or_done;
	or (exec_or_done, executar_estendido, mult_done);
	and gerar_pulso_reg (register_pulse, clk_dividido, exec_or_done);
	
   //===================================================================	
   //	DISPLAY PRINCIPAL (Resultado/Quociente)
   //===================================================================
    Display7Seg display_resultado(
        .Data(mux), 
        .sel(sel_ope), 
        .d1(d1),      // HEX0
        .d2(d2),      // HEX1
        .d3(d3)       // HEX2
    );
    
   //===================================================================	
   //	DISPLAY DO RESTO (só aparece se for divisão)
   //===================================================================
    wire is_division;
    wire show_resto;
    
    // Detecta se a operação é divisão (Ope = 011)
    wire not_ope2;
    not (not_ope2, Ope[2]);
    and (is_division, not_ope2, Ope[1], Ope[0]);
    
    // Mostra resto apenas se for divisão E estiver executando
    and (show_resto, is_division, executar_estendido);
    
    Display7Seg_Resto display_resto(
        .Resto(Resto),           // Entrada de 8 bits do resto
        .sel(sel_ope),           // Mesma seleção de base
        .enable(show_resto),     // Só mostra se for divisão
        .d4(d4),                 // HEX3
        .d5(d5),                 // HEX4
        .d6(d6)                  // HEX5
    );
	and(Dp,1'b0);
	
endmodule

// =================================================================
// MÓDULO: Topo do Controlador RPN
// =================================================================
module top(
    // --- Portas de Entrada ---
    input  wire       clk_in,
    input  wire       switch,
    input  wire [7:0] data_in,

    // --- Portas de Saída ---
    output wire [7:0] reg1_out,
    output wire [7:0] reg2_out,
    output wire [7:0] reg3_out,
    output wire       execute_out
);

    // --- Fios Internos ---
    wire enable_pulse; // Pulso único gerado pelo debouncer

    // =================================================================
    // INSTANCIAÇÃO DOS SUB-MÓDULOS
    // =================================================================

    // --- Shift Register principal para controle da RPN ---
    shift_register sr(
        .data_in(data_in),
        .enable_clk(enable_pulse),
        .reg1_out(reg1_out),
        .reg2_out(reg2_out),
        .reg3_out(reg3_out),
        .execute_pulse(execute_out)
);

	switch_debouncer deb(
		 .clk(clk_in),
		 .reset(1'b0),
		 .botao_raw(switch), // Conectado à porta 'botao_raw' do módulo
		 .botao_ok(enable_pulse)  // Conectado à porta 'botao_ok' do módulo
);
endmodule