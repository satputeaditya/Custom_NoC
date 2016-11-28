// NocC_ver_2.v

module NocC_ver_2 (
					input 	clk, 
					input 	rst, 				
					input   [7:0] CMD_READ,		// DataW
					input         ALE_READ,		// CmdW	
					output  [7:0] CMD_WRITE,	// DataR
					output        ALE_WRITE		// CmdR		
				);

//******** Main State definitions ********
parameter IDLE 				= 	4'b1_000;
parameter READ 				=	4'b1_001;	 
parameter READ_RESPONSE 	=	4'b1_010;	 
parameter WRITE 			=	4'b1_011;	 
parameter WRITE_RESPONSE	=	4'b1_100;  	 
parameter RESERVED 			=	4'b1_101; 	
parameter MESSAGE 			=	4'b1_110; 		
parameter END 				=	4'b1_111; 		

//******** FIFO size parameters ********
parameter WIDTH = 8; 
parameter DEPTH = 256;
parameter BYTES_1 = 8;		// READ CODE MAX BYTES LIMIT
parameter BYTES_2 = 11;		// WRITE CODE MAX BYTES LIMIT
				
//******** Registers to store data ********

reg [BYTES_1*8-1:0]SIPO_1,SIPO_1_copy;
reg [BYTES_2*8-1:0]SIPO_2,SIPO_2_copy;

reg [8:0] READ_CODE , WRITE_CODE , READ_RESP_CODE , WRITE_RESP_CODE , MESSAGE_CODE;
reg [7:0] READ_SOURCE_ID , WRITE_SOURCE_ID;

reg [8:0] RETURN_ID;
reg [7:0] READ_PKT_SIZE , WRITE_PKT_SIZE;

reg [7:0] READ_ADDRESS_1 , READ_ADDRESS_2 , READ_ADDRESS_3 , READ_ADDRESS_4; 	
wire [31:0] READ_ADDRESS ; 	

reg [7:0] WRITE_ADDRESS_1 , WRITE_ADDRESS_2 , WRITE_ADDRESS_3 , WRITE_ADDRESS_4; 	
wire [31:0] WRITE_ADDRESS ; 	

reg [7:0] WRITE_DATA_1 , WRITE_DATA_2 , WRITE_DATA_3 , WRITE_DATA_4; 	
wire [31:0] WRITE_DATA ; 	

reg [7:0] READ_LEN_1 , READ_LEN_2;		
wire [15:0] READ_LEN;		

reg [7:0] WRITE_LEN_1 , WRITE_LEN_2;	
wire [15:0] WRITE_LEN;		

reg  READ_SM_FIFO_push , READ_SM_FIFO_pop;
wire READ_SM_FIFO_full , READ_SM_FIFO_empty;

reg [7:0] READ_SM;
wire [7:0]READ_SM_FIFO_data_out;
		
reg [7:0]  IDLE_count , WRITE_count , READ_count;  
reg WRITE_count_en,READ_count_en;

wire R_LEN_BIT , R_ONES; 
wire [2:0] R_ADDR_LEN;

wire W_LEN_BIT , W_ONES;
wire [2:0] W_ADDR_LEN;

wire READ_RESP_RESERVED;

wire [4:0] MESSAGE_LENGTH;
wire [8:0] READ_THIS;
reg  [8:0] WRITE_THIS;

reg CRC_Sel, CRC_RW;
reg [31:0] CRC_addr, CRC_data_wr, CRC_data_rd ;

reg  READ_count_re1 , READ_count_re2;
wire READ_count_re;

reg  WRITE_count_re1 , WRITE_count_re2;
wire WRITE_count_re;

assign READ_LEN 	= {READ_LEN_1,READ_LEN_2};
assign READ_ADDRESS = {READ_ADDRESS_1,READ_ADDRESS_2,READ_ADDRESS_3,READ_ADDRESS_4};

assign WRITE_LEN 	 = {WRITE_LEN_1,WRITE_LEN_2};
assign WRITE_ADDRESS = {WRITE_ADDRESS_1	,WRITE_ADDRESS_2,WRITE_ADDRESS_3,WRITE_ADDRESS_4};
assign WRITE_DATA 	 = {WRITE_DATA_1 	,WRITE_DATA_2	,WRITE_DATA_3	,WRITE_DATA_4};

assign R_LEN_BIT  	=  READ_CODE[4];
assign R_ONES  		=  READ_CODE[3];
assign R_ADDR_LEN  	=  READ_CODE[2:0];

assign W_LEN_BIT  	=  WRITE_CODE[4];
assign W_ONES  		=  WRITE_CODE[3];
assign W_ADDR_LEN  	=  WRITE_CODE[2:0];

assign READ_RESP_RESERVED 	=  READ_RESP_CODE[4];
assign READ_ERROR  			=  READ_RESP_CODE[3];
assign READ_ERR_CODE  		=  READ_RESP_CODE[2:0];

assign MESSAGE_LENGTH  		=  MESSAGE_CODE[4:0];

assign READ_THIS 				= {ALE_READ,CMD_READ};
assign {ALE_WRITE,CMD_WRITE}	= WRITE_THIS;

assign READ_count_re	= (READ_count_re1 & (~ READ_count_re2));
assign WRITE_count_re	= (WRITE_count_re1 & (~ WRITE_count_re2));
		
//******** Process for read / write code packet size ********

always@(*)				
		begin
			if (rst)
				begin
					WRITE_PKT_SIZE 	<= 8'h00;		
					READ_PKT_SIZE 	<= 8'h00;		 	
				end
			else
				begin
					casez (W_ADDR_LEN) // WRITE_PKT_SIZE  = SOURCE_ID (1 byte)  + W_LEN_BIT (1/2 bytes) + W_ADDR_LEN (1/2/3/4/5/7/8/12 bytes) + DATA PACKET (4 bytes)
							3'b000	: if (W_LEN_BIT) WRITE_PKT_SIZE <= 8'h08; else WRITE_PKT_SIZE <= 8'h07;
							3'b001	: if (W_LEN_BIT) WRITE_PKT_SIZE <= 8'h09; else WRITE_PKT_SIZE <= 8'h08;
							3'b010	: if (W_LEN_BIT) WRITE_PKT_SIZE <= 8'h0A; else WRITE_PKT_SIZE <= 8'h09;
							3'b011	: if (W_LEN_BIT) WRITE_PKT_SIZE <= 8'h0B; else WRITE_PKT_SIZE <= 8'h0A;
							3'b100	: if (W_LEN_BIT) WRITE_PKT_SIZE <= 8'h0C; else WRITE_PKT_SIZE <= 8'h0B;
							3'b101	: if (W_LEN_BIT) WRITE_PKT_SIZE <= 8'h0E; else WRITE_PKT_SIZE <= 8'h0D;
							3'b110	: if (W_LEN_BIT) WRITE_PKT_SIZE <= 8'h0F; else WRITE_PKT_SIZE <= 8'h0E;
							3'b111	: if (W_LEN_BIT) WRITE_PKT_SIZE <= 8'h13; else WRITE_PKT_SIZE <= 8'h12;
					endcase

					casez (R_ADDR_LEN) // READ_PKT_SIZE   = SOURCE_ID (1 byte)  + W_LEN_BIT (1/2 bytes) + W_ADDR_LEN (1/2/3/4/5/7/8/12 bytes)
							3'b000	: if (R_LEN_BIT) READ_PKT_SIZE <= 8'h04; else READ_PKT_SIZE <= 8'h03;
							3'b001	: if (R_LEN_BIT) READ_PKT_SIZE <= 8'h05; else READ_PKT_SIZE <= 8'h04;
							3'b010	: if (R_LEN_BIT) READ_PKT_SIZE <= 8'h06; else READ_PKT_SIZE <= 8'h05;
							3'b011	: if (R_LEN_BIT) READ_PKT_SIZE <= 8'h07; else READ_PKT_SIZE <= 8'h06;
							3'b100	: if (R_LEN_BIT) READ_PKT_SIZE <= 8'h08; else READ_PKT_SIZE <= 8'h07;
							3'b101	: if (R_LEN_BIT) READ_PKT_SIZE <= 8'h0A; else READ_PKT_SIZE <= 8'h09;
							3'b110	: if (R_LEN_BIT) READ_PKT_SIZE <= 8'h0B; else READ_PKT_SIZE <= 8'h0A;
							3'b111	: if (R_LEN_BIT) READ_PKT_SIZE <= 8'h0F; else READ_PKT_SIZE <= 8'h0E;
					endcase
				end
		end

//******** Process for current state of NoC read ********
	
always@(*)
	begin	
		if (rst)
			begin
				READ_SM <= 'b0;
				READ_CODE <= 'b0;
				WRITE_CODE <= 'b0;
			end				
		else
				casez (READ_THIS[8:5])
						IDLE	: begin  	READ_SM <= 8'h03;   							end
						READ	: begin 	READ_SM <= 8'h01; 	READ_CODE 	<= READ_THIS; 	end
						WRITE	: begin 	READ_SM <= 8'h02; 	WRITE_CODE 	<= READ_THIS; 	end
						default	: ;
				endcase
	end

	
	
//******** Process for serial shift registers for READ / WRITE  ********
	
always@(negedge clk, posedge rst)
	begin	
		if (rst)
			begin
				IDLE_count <= 'b0;
				SIPO_1 <= 'b0;
				SIPO_2 <= 'b0;				
			end
		else		
				casez (READ_SM)
					8'h00	: begin /* DO NOTHING IN THIS STATE , */						end		// IDLE
					8'h01 	: begin SIPO_1 <=  {SIPO_1[(BYTES_1-1)*8-1:0],CMD_READ};	  	end 	// READ
					8'h02 	: begin SIPO_2 <=  {SIPO_2[(BYTES_2-1)*8-1:0],CMD_READ};		end		// WRITE			
					8'h03	: begin IDLE_count <= IDLE_count +1;							end		// IDLE					
					default : ;
				endcase 				
	end
	


//******** Process for  READ / WRITE counters (sequrntial logic)********
	
always@(negedge clk or posedge rst)
	begin	
		if (rst)
			begin
				READ_count <= 'b0;
				WRITE_count <= 'b0;
			end
		else									
				casez (READ_SM)
					8'h01 	: 	begin if (READ_count_en) 	READ_count 	<= 'b0; else READ_count  <= READ_count +1;	  	WRITE_count <= 'b0;	end 	// IDLE    
					8'h02 	: 	begin if (WRITE_count_en) 	WRITE_count <= 'b0; else WRITE_count <= WRITE_count +1;		READ_count 	<= 'b0;	end		// READ			
					default : 	begin
									READ_count <= 'b0;
									WRITE_count <= 'b0;
								end
				endcase 				
	end

//******** Process for READ / WRITE counter control (combinational logic) ********
	
always@(*)
	begin	
		if (rst)
			begin
				READ_count_en <= 'b0;
				WRITE_count_en <= 'b0;
			end
		else
			begin				
				if (READ_count 	> READ_PKT_SIZE) 	READ_count_en 	<= 'b1; else READ_count_en   <= 'b0;									
				if (WRITE_count >= WRITE_PKT_SIZE) 	WRITE_count_en 	<= 'b1; else WRITE_count_en  <= 'b0;
			end
	end	

//******** Process for shift registers for detecting rising edge of READ / WRITE count equal ********
	
always@(negedge clk or posedge rst)
	begin	
		if (rst)
			begin
				READ_count_re1 	<= 'b0;
				READ_count_re2 	<= 'b0;
				WRITE_count_re1 <= 'b0;
				WRITE_count_re2 <= 'b0;
			end
		else
			begin				
				READ_count_re1 <= READ_count_en;
				READ_count_re2 <= READ_count_re1;
				WRITE_count_re1 <= WRITE_count_en;
				WRITE_count_re2 <= WRITE_count_re1;				
			end
	end

	
//******** Process for storing data from shift registers to appropriate registers ********
	
always@(negedge clk or posedge rst)
	begin	
		if (rst)
			begin
				SIPO_1_copy 	<= 'b0;
				READ_SOURCE_ID 	<= 'b0;
				READ_ADDRESS_1 	<= 'b0;
				READ_ADDRESS_2 	<= 'b0;
				READ_ADDRESS_3 	<= 'b0;
				READ_ADDRESS_4 	<= 'b0;				
				READ_LEN_1		<= 'b0;
				READ_LEN_2		<= 'b0;				

				SIPO_2_copy 		<= 'b0;
				WRITE_SOURCE_ID 	<= 'b0;
				WRITE_ADDRESS_1 	<= 'b0;
				WRITE_ADDRESS_2 	<= 'b0;
				WRITE_ADDRESS_3 	<= 'b0;
				WRITE_ADDRESS_4 	<= 'b0;					
				WRITE_DATA_1 		<= 'b0;
				WRITE_DATA_2 		<= 'b0;
				WRITE_DATA_3 		<= 'b0;
				WRITE_DATA_4 		<= 'b0;									
				WRITE_LEN_1			<= 'b0;
				WRITE_LEN_2			<= 'b0;								
			end
		else
			if (READ_count_re)
				begin				
				case (R_LEN_BIT)
					1'b0	: 	{READ_SOURCE_ID,READ_ADDRESS_4,READ_ADDRESS_3,READ_ADDRESS_2,READ_ADDRESS_1,READ_LEN_1} <=  SIPO_1[49:0];
					1'b1	: 	{READ_SOURCE_ID,READ_ADDRESS_4,READ_ADDRESS_3,READ_ADDRESS_2,READ_ADDRESS_1,READ_LEN_1,READ_LEN_2}  <=  SIPO_1[55:0];
				endcase																				
					SIPO_1_copy 	<= SIPO_1;					
				end				

			if (WRITE_count_re)
				begin				
				case (W_LEN_BIT)
					1'b0	: 	{WRITE_SOURCE_ID,WRITE_ADDRESS_4,WRITE_ADDRESS_3,WRITE_ADDRESS_2,WRITE_ADDRESS_1,WRITE_DATA_4,WRITE_DATA_3,WRITE_DATA_2,WRITE_DATA_1,WRITE_LEN_1} <=  SIPO_2[79:0];
					1'b1	: 	{WRITE_SOURCE_ID,WRITE_ADDRESS_4,WRITE_ADDRESS_3,WRITE_ADDRESS_2,WRITE_ADDRESS_1,WRITE_DATA_4,WRITE_DATA_3,WRITE_DATA_2,WRITE_DATA_1,WRITE_LEN_1,WRITE_LEN_2}  <=  SIPO_2[71:0];
				endcase																				
					SIPO_2_copy 	<= SIPO_2;					
				end				
	end

	
 crc U1 (rst, clk, CRC_Sel, CRC_RW, CRC_addr, CRC_data_wr, CRC_data_rd );
	
endmodule
