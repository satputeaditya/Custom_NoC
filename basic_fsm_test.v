module NoC_new_again (
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
				
//******** Registers to store data ********

reg [8:0] READ_CODE;
reg [8:0] READ_RESP_CODE;
reg [8:0] WRITE_CODE;
reg [8:0] WRITE_RESP_CODE;
reg [8:0] MESSAGE_CODE;

reg [7:0] READ_SOURCE_ID;
reg [7:0] WRITE_SOURCE_ID;

reg [8:0] RETURN_ID;
reg [7:0] READ_PKT_SIZE;
reg [7:0] WRITE_PKT_SIZE;
reg [7:0] READ_ADDRESS [3:0]; 	// [WIDTH][ADDRESS][DEPTH]
reg [7:0] WRITE_ADDRESS [3:0]; 	// [WIDTH][ADDRESS][DEPTH]
reg [7:0] READ_LEN[1:0];		// [WIDTH][ADDRESS][DEPTH]	
reg [7:0] WRITE_LEN[1:0];		// [WIDTH][ADDRESS][DEPTH]	

reg [3:0]  STATE_1,STATE_2;

		
reg [7:0]  JUMP;
reg [7:0]  IDLE_count,READ_count,WRITE_count;  
reg [9:0]  ERR_LOC;  		// using one hot encoding in a 10 bit vector to indicate 10 possible errors

wire R_LEN_BIT;
wire R_ONES;
wire [2:0] R_ADDR_LEN;

wire W_LEN_BIT;
wire W_ONES;
wire [2:0] W_ADDR_LEN;

wire READ_RESP_RESERVED;
wire ERROR;
wire [2:0] ERR_CODE;
wire [4:0] MESSAGE_LENGTH;
wire [8:0] READ_THIS;
reg  [8:0] WRITE_THIS;

assign R_LEN_BIT  			=  READ_CODE[4];
assign R_ONES  				=  READ_CODE[3];
assign R_ADDR_LEN  			=  READ_CODE[2:0];

assign W_LEN_BIT  			=  WRITE_CODE[4];
assign W_ONES  				=  WRITE_CODE[3];
assign W_ADDR_LEN  			=  WRITE_CODE[2:0];

assign READ_RESP_RESERVED 		=  READ_RESP_CODE[4];
assign READ_ERROR  				=  READ_RESP_CODE[3];
assign READ_ERR_CODE  			=  READ_RESP_CODE[2:0];

assign MESSAGE_LENGTH  			=  MESSAGE_CODE[4:0];

assign READ_THIS 				= {ALE_READ,CMD_READ};
assign {ALE_WRITE,CMD_WRITE}	= WRITE_THIS;


//******** State assignment ********

//******** Process for read code packet size ********

always@(posedge rst or READ_CODE)				// READ_PKT_SIZE  = SOURCE_ID (1 byte)  + lEN (1/2 bytes) + ADDR_LEN (1/2/3/4/5/7/8/12 bytes)
		begin
			if (rst)	
				READ_PKT_SIZE 	<= 8'h00;
			else
				casez (ADDR_LEN)
						3'b000	: if (LEN) READ_PKT_SIZE <= 8'h04; else READ_PKT_SIZE <= 8'h03;
						3'b001	: if (LEN) READ_PKT_SIZE <= 8'h05; else READ_PKT_SIZE <= 8'h04;
						3'b010	: if (LEN) READ_PKT_SIZE <= 8'h06; else READ_PKT_SIZE <= 8'h05;
						3'b011	: if (LEN) READ_PKT_SIZE <= 8'h07; else READ_PKT_SIZE <= 8'h06;
						3'b100	: if (LEN) READ_PKT_SIZE <= 8'h08; else READ_PKT_SIZE <= 8'h07;
						3'b101	: if (LEN) READ_PKT_SIZE <= 8'h0A; else READ_PKT_SIZE <= 8'h09;
						3'b110	: if (LEN) READ_PKT_SIZE <= 8'h0B; else READ_PKT_SIZE <= 8'h0A;
						3'b111	: if (LEN) READ_PKT_SIZE <= 8'h0F; else READ_PKT_SIZE <= 8'h0E;
				endcase
		end

		
//******** Process for write code packet size ********

always@(posedge rst or WRITE_CODE)				// WRITE_PKT_SIZE  = SOURCE_ID (1 byte)  + lEN (1/2 bytes) + ADDR_LEN (1/2/3/4/5/7/8/12 bytes)
		begin
			if (rst)	
				WRITE_PKT_SIZE 	<= 8'h00;
			else
				casez (ADDR_LEN)
						3'b000	: if (LEN) WRITE_PKT_SIZE <= 8'h04; else WRITE_PKT_SIZE <= 8'h03;
						3'b001	: if (LEN) WRITE_PKT_SIZE <= 8'h05; else WRITE_PKT_SIZE <= 8'h04;
						3'b010	: if (LEN) WRITE_PKT_SIZE <= 8'h06; else WRITE_PKT_SIZE <= 8'h05;
						3'b011	: if (LEN) WRITE_PKT_SIZE <= 8'h07; else WRITE_PKT_SIZE <= 8'h06;
						3'b100	: if (LEN) WRITE_PKT_SIZE <= 8'h08; else WRITE_PKT_SIZE <= 8'h07;
						3'b101	: if (LEN) WRITE_PKT_SIZE <= 8'h0A; else WRITE_PKT_SIZE <= 8'h09;
						3'b110	: if (LEN) WRITE_PKT_SIZE <= 8'h0B; else WRITE_PKT_SIZE <= 8'h0A;
						3'b111	: if (LEN) WRITE_PKT_SIZE <= 8'h0F; else WRITE_PKT_SIZE <= 8'h0E;
				endcase
		end
		
		
		
//******** State transition ********

always@(negedge clk or posedge rst) 
	begin
	if (rst)
		begin			
			IDLE_count		<= 'b0;				// Counter to limit IDLE states to 15 as per spec
			READ_count		<= 'b0;				// Counter to count READ_CODE  packets
			WRITE_count		<= 'b0;				// Counter to count WRITE_CODE packets
			
			ERR_LOC			<= 'b0;  		    // Using one hot encoding in a 10 bit vector to indicate 10 possible errors
			STATE_1 		<= 'b0;  			// RESET STATE = IDLE : Performed bushing to set default = IDLE state
			
			READ_CODE		<= 'b0;				// NOC REGISTER 1 
			WRITE_CODE		<= 'b0;				// NOC REGISTER 2 
			
			READ_RESP_CODE	<= 'b0;				// NOC REGISTER 3 
			WRITE_RESP_CODE	<= 'b0;				// NOC REGISTER 4 

			MESSAGE_CODE	<= 'b0;				// NOC REGISTER 5 
			
			READ_SOURCE_ID	<= 'b0;
			
			WRITE_SOURCE_ID <= 'b0;
			
			RETURN_ID		<= 'b0;
			JUMP			<= 'b0;
			
			READ_ADDRESS[0]		<=  0;
			READ_ADDRESS[1]		<=  0;			
			READ_ADDRESS[2]		<=  0;
			READ_ADDRESS[3]		<=  0;			

			WRITE_ADDRESS[0]		<=  0;
			WRITE_ADDRESS[1]		<=  0;			
			WRITE_ADDRESS[2]		<=  0;
			WRITE_ADDRESS[3]		<=  0;			
			
			
			READ_LEN[0]		<=  0;
			READ_LEN[1]		<=  0;
			READ_LEN[2]		<=  0;
			READ_LEN[3]		<=  0;
			
			WRITE_LEN[0]		<=  0;
			WRITE_LEN[1]		<=  0;
			WRITE_LEN[2]		<=  0;
			WRITE_LEN[3]		<=  0;
		end
	else 
		begin

			casez (STATE_1)    
					IDLE	:   begin
										//****** WATCHDOG COUNTER  ******//
											if (IDLE_count > 15) 			// check if bus in IDLE > 15 cycles  
												begin 
													IDLE_count <= 'b0;		// clear counter for next use
													ERR_LOC[0] <= 'b1; 		// error flag = 1
												end
											else 
												begin 
													IDLE_count <= IDLE_count + 1;  	
													ERR_LOC[0] <= 'b0; 					
												end
												
										casez (READ_THIS[8:5]) // checking for next state and accordingly changing state of state mc ;  Since this is read state mc, possible states = IDLE / READ / WRITE  
												IDLE 		: 	begin 	STATE_1 <= IDLE;								end
												READ		: 	begin	STATE_1 <= READ; 	READ_CODE  <= READ_THIS;	end
												WRITE		: 	begin 	STATE_1 <= WRITE; 	WRITE_CODE <= READ_THIS;	end	
												RESERVED	:   begin	STATE_1 <= RESERVED; 							end
												MESSAGE		:   begin	STATE_1 <= MESSAGE; 							end
												END			:   begin	STATE_1 <= END;	 								end
												default 	: 	begin 
																		casez (JUMP)
																			8'h10 :  	STATE_1 <= READ;		// READ 
																			8'h20 :  	STATE_1 <= WRITE;		// WRITE
																			8'h30 :  	STATE_1 <= RESERVED;	// RESERVED	
																			8'h40 :  	STATE_1 <= MESSAGE;		// MESSAGE	
																			8'h50 :  	STATE_1 <= END;			// END																			
																			default : 	STATE_1 <= IDLE; 		
																		endcase							
																end	
										endcase	
										
								end
								 
					READ	:   begin
										$display ("TIME :",$time,"\t READ THIS  :%h",READ_THIS);
										casez (READ_THIS[8:5]) // checking for next state and accordingly changing state of state mc ;  Since this is read state mc, possible states = IDLE / READ / WRITE  
												IDLE 		: 	begin	STATE_1 <= IDLE;	JUMP <= 8'h10;	end	
												READ 		: 	begin	STATE_1 <= READ;	JUMP <= 8'h10;	end // JUMP inluded here as 2 back to back ONLY read commands will overwrite 
												WRITE 		: 	begin	STATE_1 <= IDLE;		end
												RESERVED 	: 	begin	STATE_1 <= RESERVED;	end
												MESSAGE 	: 	begin	STATE_1 <= MESSAGE;		end
												END 		: 	begin 	STATE_1 <= END;			end
												default		: 	begin	
												
																		if (READ_count > READ_PKT_SIZE)
																			READ_count <= 'b0;
																		else	
																			READ_count <= READ_count + 1;
																		
																		casez (READ_count) 
																			8'h00 :  READ_SOURCE_ID <= READ_THIS[7:0]; 
																			8'h01 :  READ_ADDRESS[0]  	<= READ_THIS[7:0]; 	
																			8'h02 :  READ_ADDRESS[1]  	<= READ_THIS[7:0]; 		
																			8'h03 :  READ_ADDRESS[2]  	<= READ_THIS[7:0]; 		
																			8'h04 :  READ_ADDRESS[3]  	<= READ_THIS[7:0]; 		
																			8'h05 :  READ_LEN[0] 	<= READ_THIS[7:0]; 		
																			8'h06 :  READ_LEN[1] 	<= READ_THIS[7:0];
																			default : ;
																		endcase							
																			
																		casez (JUMP)
																			8'h10 :  	STATE_1 <= READ;		// READ 
																			8'h20 :  	STATE_1 <= WRITE;		// WRITE
																			8'h30 :  	STATE_1 <= RESERVED;	// RESERVED	
																			8'h40 :  	STATE_1 <= MESSAGE;		// MESSAGE	
																			8'h50 :  	STATE_1 <= END;			// END																			
																			default : 	STATE_1 <= READ; 		
																		endcase							
																end													
										endcase
								end
					

					
					WRITE	:   begin
										$display ("TIME :",$time,"\t READ THIS  :%h",READ_THIS);
										casez (READ_THIS[8:5]) // checking for next state and accordingly changing state of state mc ;  Since this is read state mc, possible states = IDLE / READ / WRITE  
												IDLE 		: 	begin	STATE_1 <= IDLE;	JUMP <= 8'h20;	end	
												READ 		: 	begin	STATE_1 <= READ;		end 
												WRITE 		: 	begin	STATE_1 <= IDLE;	JUMP <= 8'h20;	end // JUMP inluded here as 2 back to back ONLY write commands will overwrite 
												RESERVED 	: 	begin	STATE_1 <= RESERVED;	end
												MESSAGE 	: 	begin	STATE_1 <= MESSAGE;		end
												END 		: 	begin 	STATE_1 <= END;			end
												default		: 	begin	
												
																		if (WRITE_count > WRITE_PKT_SIZE)
																			WRITE_count <= 'b0;
																		else	
																			WRITE_count <= WRITE_count + 1;
																		
																		casez (WRITE_count) 
																			8'h00 :  READ_SOURCE_ID <= READ_THIS[7:0]; 
																			8'h01 :  WRITE_ADDRESS[0]  	<= READ_THIS[7:0]; 	
																			8'h02 :  WRITE_ADDRESS[1]  	<= READ_THIS[7:0]; 		
																			8'h03 :  WRITE_ADDRESS[2]  	<= READ_THIS[7:0]; 		
																			8'h04 :  WRITE_ADDRESS[3]  	<= READ_THIS[7:0]; 		
																			8'h05 :  READ_LEN[0] 	<= READ_THIS[7:0]; 		
																			8'h06 :  READ_LEN[1] 	<= READ_THIS[7:0];

																			default : ;
																		endcase							
																			
																		casez (JUMP)
																			8'h10 :  	STATE_1 <= READ;		// READ 
																			8'h20 :  	STATE_1 <= WRITE;		// WRITE
																			8'h30 :  	STATE_1 <= RESERVED;	// RESERVED	
																			8'h40 :  	STATE_1 <= MESSAGE;		// MESSAGE	
																			8'h50 :  	STATE_1 <= END;			// END																			
																			default : 	STATE_1 <= READ; 		
																		endcase							
																end													
										endcase
								end

								
					default : 	STATE_1 <= IDLE;
			endcase
								
		end
	end

endmodule