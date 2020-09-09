module Pong_Ball_Ctrl #(
    parameter           c_GAME_WIDTH    = 40,
    parameter           c_GAME_HEIGHT   = 30
) (
    input               i_Clk,
    input               i_Game_Active,
    input       [5:0]   i_Col_Count_Div,
    input       [5:0]   i_Row_Count_Div,
    output reg          o_Draw_Ball,
    output reg  [5:0]   o_Ball_X        = 0,
    output reg  [5:0]   o_Ball_Y        = 0
);

    // Set the speed of the bal movement
    // In this case, the ball will move on board game unit
    // every 50 milliseconds that the button is held down
    parameter           c_BALL_SPEED    = 1250000;


    reg         [5:0]   r_Ball_X_Prev   = 0;
    reg         [5:0]   r_Ball_Y_Prev   = 0;
    reg         [31:0]  r_Ball_Count    = 0;

    always @(posedge i_Clk) begin
        // If the game is not active, ball stays in the middle of
        // the screen until the game starts.
        if (i_Game_Active == 1'b0) begin
            o_Ball_X        <= c_GAME_WIDTH / 2;
            o_Ball_Y        <= c_GAME_WIDTH / 2;
            r_Ball_X_Prev   <= c_GAME_WIDTH / 2 + 1;
            r_Ball_Y_Prev   <= c_GAME_WIDTH / 2 - 1;
        end

        // Update the ball counter continuously. Ball movement 
        // update rate is determined by input parameter
        // If ball counter is at its limit, update the ball position
        // in both X and Y.
        else begin
            if (r_Ball_Count < c_BALL_SPEED)
                r_Ball_Count <= r_Ball_Count + 1;
            else begin
                r_Ball_Count <= 0;

                // Store Previous Location to keep track of movement
                r_Ball_X_Prev <= o_Ball_X;
                r_Ball_Y_Prev <= o_Ball_Y;

                // When previous value is less than current value, ball is moveng to right.
                // Keep it moveing to the right unless we are at a wall.
                // When Previous value is greater than current value, ball is moveing to the 
                // left. Keep it moving to the left unless we are at a wall
                // Same thing for both X and Y

                if ((r_Ball_X_Prev < o_Ball_X && o_Ball_X == c_GAME_WIDTH-1) || (r_Ball_X_Prev > o_Ball_X & o_Ball_X != 0))
                    o_Ball_X <= o_Ball_X - 1;
                else 
                    o_Ball_X <= o_Ball_X + 1;

                if ((r_Ball_Y_Prev < o_Ball_Y && o_Ball_Y == c_GAME_HEIGHT-1) || (r_Ball_Y_Prev > o_Ball_Y && o_Ball_Y != 0))
                    o_Ball_Y <= o_Ball_Y - 1;
                else 
                    o_Ball_Y <= o_Ball_Y + 1;
            end 
        end
    end 

    // Draws a ball at the location determined by X and Y indexes
    always @(posedge i_Clk) begin
        if (i_Col_Count_Div == o_Ball_X && i_Row_Count_Div == o_Ball_Y)
            o_Draw_Ball <= 1'b1;
        else 
            o_Draw_Ball <= 1'b0; 
    end
endmodule