 
module top(LEDR, SW, CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	
	input [9:0] SW;
	input [9:0] LEDR;
	input [5:0] KEY;
	
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	
	 FullFSM U1 (SW, CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

endmodule


module FullFSM(SW, CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 );

    // all the flags for the different states
	 input [9:0] SW;
	 
	 //output the spin number to the hex for now
	 output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 
	 //input to start game and enter the load state
	 wire keyboardENTER = SW[0];
	
	 //input to select the max bet (5coins)
	 wire keyboardMINBET = SW[1];
	
	 //input to select the min bet (1 coin)
	 wire keyboardMAXBET = SW [2];
	
	 //input to keep spining once one spoin has finished (continue playing slots)
	 wire keyboardSPINAGAIN = SW[3];
	
	 //input to write name in ram (for leaderboard)
	 wire keyboardNAME = SW[4];
	
	 //input to initilize start spin
	 wire keyboardPLAY = SW[5];
	
	 //input to stop the spin of the slots 
	 wire keyboardSPACEBAR = SW[6];
	
	 //input end game session
	 wire keyboardESCAPE = SW[7];
	 
	 
	 
	 // output when the space bar is hit 3 times to stop each individual slot
	 wire doneFlag;
	 
	 //output when the players score and name are in the ram and its score is reset
	 wire clearFlag;
	 
	 
	 //generated player spin number through radon num generator
	 reg [11:0] pSPIN;
	 
	 // initilizing the starting jackpot to 10,000 coins
	 reg [16:0] jackpot= 17d'10000;
	 // initilize the jackpot to a ram slot 
	 
	 //player score/number of spins
	 wire reg [16:0] = playerScore;  
  
    
    // One-hot code for states
    parameter startState  = 6'b000001, 
              loadState   = 6'b000010, 
              playState   = 6'b000100, 
              spinState   = 6'b001000, 
              winState    = 6'b010000, 
              resetState  = 6'b100000;

    reg [5:0] currentState, nextState;  // Current and next state (6-bit for one-hot encoding)
    

    // Next state logic
    always @(currentState) begin
        case (currentState)

            //THE START STATE
				startState: 
				begin
				
				
            // code to Display the slot machine using VGA.
				
				
				if (keyboardENTER == 1) 
                            nextState = loadState;
                        else 
                            nextState = startState;
				end

            // THE LOAD STATE
            loadState: 
				begin 
				
				
				//code for mini FSM
				//ENTER NAME
				//ENTER COINS
				//once this is called enetr is allowed to be pressed and move on to next state
				
				
				//maybe other button instead of keyboard input
				if (keyboardENTER == 1) 
                           nextState = playState;
                       else 
                           nextState = loadState;
				end
									
									

            // THE PLAY STATE
            playState: 
				begin
				
				//Display buttons and graphics change.
				//does all the subtraction to the score/ displaying score
				
				//functions
				//max bet or min bet selector input to mux
				
				// mux selects
				//subtractor 1
				//subtractor 5
				
				
				//inputs
				//currentPlayerSCORE (17b)
				//min or max bet button
				
				//outputs
				//SUBTRACTED PLAYER SCORE (17b)
				

				if (keyboardPLAY == 1) 
                           nextState = spinState;
                       else if (keyboardESCAPE == 1) 
                           nextState = resetState;
                       else 
                           nextState = playState;
				end	
	
								
            // THE SPIN STATE
            spinState: 
				begin
				
				// Graphics for each individual slot spin based on the number of <enter> key presses.
				// NOTE: Code it to only track the <enter> keyboard input and no other in this state.
				
				//function
				// spin GENERATOR (12 bit number generator)
				
				//inputs 
				//clock50, spacebar
				
				//output 
				//SpinNUMBER (12b), doneFlag (1b)
				
				if (doneFLAG ==1) 
                           nextState = winState;
                       else 
                           nextState = spinState;
				end

            // THE WIN STATE
            winState: 
				begin
				
				// Calculate the new player score.
            // Handle jackpot.
            // Handle player spin number to check if won.
				
				//inputs
				//SpinNUMBER (12b), MAX and MIN bet button, subtracted players core
				
				//outputs
				// NewPlayer score (17b)
				
				//functions
				//check spun number
				
				//score selctor
				// selects score based on max min bet
				// 200 vs 1000 coins min vs max 
				
				//everything gets shoved into the newscoreadder
				//newscoreADDER
				
				
				// we need to leave if the try and play again but the score is zero
				
				if (keyboardSPINAGAIN == 1 & PLAYERSCORE != 17b'00000000000000000) 
                          nextState = playState;
                      else if (keyboardESCAPE == 1) 
                          nextState = resetState;
								  else
								  nextState = winState;
				end

				
            // RESET STATE
            resetState: 
				begin
				// Update player score to leaderboard in the RAM slots.
            // Clear/reset player score to 17'b00000000000000000
				
				if (clearFlag == 1) 
                            nextState = startState;
                        else 
                            nextState = resetState;
				end 

            default: nextState = startState; // Ensures a defined state in case of errors
        endcase
    end

    //state transition is indpendent of any clock
    always @(*) 
	 begin
	 if(PLAYERSCORE = 17'b00000000000000000)
	     currentState = ResetState
		  else
            currentState = nextState;

    end
    
endmodule
