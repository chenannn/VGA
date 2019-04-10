module vga_diver(
    input 				vga_clk		,
    input 				rst_n		,
    input		[15:0]	pixel_data	,

    output				vga_hs 		,
    output				vga_vs 		,
    output		[15:0]	vga_rgb  /* ,
 	output		[ 9:0]	vga_x		,
    output		[ 9:0]	vga_y	*/	
   	 );
	parameter H_SYNC	=	11'd136	;
	parameter H_BACK	=	11'd160	;
	parameter H_DISP	=	11'd1024;
	parameter H_FRONT	=	11'd24	;
	parameter H_TOTAL	=	11'd1344;

	parameter V_SYNC	=	11'd6	;
	parameter V_BACK	=	11'd29	;
	parameter V_DISP	=	11'd768 ;
	parameter V_FRONT	=	11'd3	;
	parameter V_TOTAL	=	11'd806;

//pclk = H_TOTAL * V_TOTAL * fps



/*Note the data width*/
	reg		[10:0]	h_cnt 			;
	reg		[10:0]	v_cnt 			;
	wire			vag_en			;
//	wire			data_req		;


//=======================================
//=============main code=================
//=======================================
always @(posedge vga_clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		h_cnt <= 11'd0;
	end
	else  begin
		if (h_cnt < (H_TOTAL-1'b1)) begin
			h_cnt <= h_cnt+1'b1;
	 	end
		else begin
			h_cnt <= 11'd0;
		end
	end
end
always @(posedge vga_clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		v_cnt <= 11'd0;
	end
	else if (h_cnt == (H_TOTAL-1'b1)) begin
		if (v_cnt< V_TOTAL -1'b1) begin
			v_cnt<= v_cnt+1'b1;
		end
		else begin
			v_cnt<=11'd0;
		end
	end
end

assign vga_hs =(h_cnt<=H_SYNC)? 1'b0:1'b1 ;
assign vga_vs =(v_cnt<=V_SYNC)? 1'b0:1'b1 ;

assign vag_en   =(
					((h_cnt>=H_SYNC+H_BACK)&&(h_cnt<H_SYNC+H_BACK+H_DISP))
					&&
					((v_cnt>=V_SYNC+V_BACK)&&(v_cnt<V_SYNC+V_BACK+V_DISP))
				)? 1'b1:1'b0 ;

/*assign data_req =(
	 				((h_cnt>=H_SYNC+H_BACK-1'b1)&&(h_cnt<H_SYNC+H_BACK+H_DISP-1'b1))
					&&
					((v_cnt>=V_SYNC+V_BACK)&&(v_cnt<V_SYNC+V_BACK+V_DISP))
				)? 1'b1:1'b0 ; 

  assign vga_x =data_req? (h_cnt-(H_SYNC+H_BACK-1'b1)):10'd0 ;
  assign vga_y =data_req? (v_cnt-(V_SYNC+V_BACK-1'b1)):10'd0 ;*/

assign vga_rgb = vag_en? pixel_data:16'd0;
endmodule
