module ctrl(op, func, rt, Branch_beq, Branch_bne, Jump, RegDst, ALUSrc, ALUctr, MemtoReg, RegWr, MemWr, ExtOp, MemRead, Bgez, Bgtz, Blez, Bltz, Jalr, B, LB, Jal, mflo, mfhi, mtlo, mthi, mult);
	input [5:0] op, func;
	input [4:0] rt;
	output reg Branch_beq, Branch_bne, Jump, RegDst, ALUSrc, MemtoReg, RegWr, MemWr, ExtOp, MemRead,Bgez, Bgtz, Blez, Bltz, Jalr, B, LB, Jal, mflo, mfhi, mtlo, mthi, mult;
	output reg [4:0] ALUctr;

	initial
	begin
		mflo = 0 ;
		mfhi = 0 ;
		mtlo = 0 ;
		mthi = 0 ;
		 Branch_beq = 0;
		 Branch_bne = 0;
		 Jump = 0;
		 RegDst = 0;
		 ALUSrc = 0;
		 ALUctr = 5'b00000;
		 MemtoReg = 0;
		 RegWr = 0;
		 MemWr = 0;
		 ExtOp = 0;
		 MemRead = 0;
		 Bgez = 0;
		 Bgtz = 0;
		 Blez = 0;
		 Bltz = 0;
		 Jalr = 0;
		 B = 0;
		 LB = 0;
		Jal = 0;
	end
    
   always@ (op or func)
	begin 
		B = (op==6'b100000) || (op==6'b100100) || (op==6'b101000);         //sb && lb && lbu
		LB = (op==6'b100000);
		Branch_beq = (op==6'b000100); //beq
		Branch_bne = (op==6'b000101); //bne
		MemRead = (op==6'b100011) || (op==6'b100000) ||(op==6'b1001000);    //lw && lb && lbu
 		Bgez = (op==6'b000001 && rt==5'b00001);
		Bgtz = (op==6'b000111);
		Blez = (op==6'b000110);
		Bltz = (op==6'b000001 && rt==5'b00000);
		Jump = (op==6'b000010);
		RegDst = (op ==6'b000000);
		Jalr = (op==6'b000000 && (func==6'b001001||func==6'b001000));  //jalr && jr
		Jal = (op==6'b000011);
		mflo = (op==6'b000000) && (func==6'b010010);
		mfhi = (op==6'b000000) && (func==6'b010000);
		mtlo = (op==6'b000000) && (func==6'b010011);
		mthi = (op==6'b000000) && (func==6'b010001);
		mult = (op==6'b000000  && func==6'b011000 );

		ALUSrc = (op==6'b001001) //addiu
				||(op==6'b100011) //lw
				||(op==6'b101011) //sw
				||(op==6'b001111) //lui
				||(op==6'b001010) //slti
				||(op==6'b001011) //sltiu
				||(op==6'b100000) //lb
				||(op==6'b100100) //lbu
				||(op==6'b101000) //sb
				||(op==6'b001100) //andi
				||(op==6'b001101) //ori
				||(op==6'b001000) //addiu
				||(op==6'b001110); //xori

		MemtoReg    = (op==6'b100011) //lw
						||(op==6'b100000) //lb
						||(op==6'b100100); //lbu

		RegWr = (op==6'b000000 && func!=6'b001000) //R
				||(op==6'b100011) //lw
				||(op==6'b001111) //lui
				||(op==6'b001010) //slti
				||(op==6'b001011) //sltiu
				||(op==6'b100000) //lb
				||(op==6'b100100) //lbu
				||(op==6'b001100) //andi
				||(op==6'b001001) //addiu
				||(op==6'b001000) //addi
				||(op==6'b001101) //ori
				||(op==6'b001110) //xori
				||(op==6'b000011); //jal
		
		MemWr = (op==6'b101011) //sw
				||(op==6'b101000);//sb

		ExtOp = (op==6'b001001)    //addiu
				||(op==6'b100011) //lw
				||(op==6'b101011) //sw
				||(op==6'b001111) //lui
				||(op==6'b001010) //slti
				||(op==6'b001011) //sltiu
				||(op==6'b000001) //bgez & bltz
				||(op==6'b000111) //bgtz
				||(op==6'b000110) //blez
				||(op==6'b100000) //lb
				||(op==6'b001000) //addi
				||(op==6'b100100) //lbu
				||(op==6'b101000); //sb

		ALUctr = (op==6'b000000 && func==6'b100001 )?5'b00000: //addu
				  (op==6'b000000 && func==6'b100011 )?5'b00001: //subu
				  (op==6'b000000 && func==6'b101010 )?5'b00010: //slt sign
				  (op==6'b000000 && func==6'b100100 )?5'b00011: //and
				  (op==6'b000000 && func==6'b100111 )?5'b00100: //nor
				  (op==6'b000000 && func==6'b100101 )?5'b00101: //or
				  (op==6'b000000 && func==6'b100110 )?5'b00110: //xor
				  (op==6'b000000 && func==6'b000000 )?5'b00111: //sll
				  (op==6'b000000 && func==6'b000010 )?5'b01000: //srl
				  (op==6'b001001)?5'b00000: //addiu
				  (op==6'b001000)?5'b00000: //addi
				  (op==6'b000100)?5'b00001: //beq sub
				  (op==6'b000101)?5'b00001: //bne sub
				  (op==6'b100011)?5'b00000: //lw add
				  (op==6'b101011)?5'b00000: //sw add
				  (op==6'b001111)?5'b01001: //lui
				  (op==6'b000100)?5'b00001: //beq
				  (op==6'b000000 && func==6'b101011 )?5'b01010: //sltu zero
				  (op==6'b000000 && func==6'b001001 )?5'b01111: //jalr 
				  (op==6'b000000 && func==6'b010010 )?5'b10000: //mflo
				  (op==6'b000000 && func==6'b010000 )?5'b10000: //mfhi
				  (op==6'b000000 && func==6'b010011 )?5'b10000: //mflo
				  (op==6'b000000 && func==6'b010001 )?5'b10000: //mfhi
				  (op==6'b000000 && func==6'b000100 )?5'b01011: //sllv
				  (op==6'b000000 && func==6'b000011 )?5'b01100: //sra
				  (op==6'b000000 && func==6'b000111 )?5'b01101: //srav
				  (op==6'b000000 && func==6'b000110 )?5'b01110: //srlv
				  (op==6'b001010)?5'b00010: //slti sign 
				  (op==6'b001011)?5'b01010: //sltiu zero
				  (op==6'b100000)?5'b00000: //lb
				  (op==6'b100100)?5'b00000: //lbu
				  (op==6'b101000)?5'b00000: //sb
				  (op==6'b001100)?5'b00011: //andi
				  (op==6'b001101)?5'b00101: //ori
				  (op==6'b001110)?5'b00110: //xori
				  (op==6'b000011)?5'b01111: 5'b00000;//jal
	end
endmodule
