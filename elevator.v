module elevator(
    input clk, reset,
    input [3:0] request,       // floor requests (one-hot: 0001=floor0, 0010=floor1, etc.)
    input [1:0] current_floor, // current floor sensor (00-11)
    output reg [1:0] motor,    // 00=stop, 01=up, 10=down
    output reg door_open,
    output reg [1:0] floor_display
);
    // State encoding
    parameter IDLE         = 3'b000,
              MOVE_UP      = 3'b001,
              MOVE_DOWN    = 3'b010,
              OPEN_DOOR    = 3'b011,
              CLOSE_DOOR   = 3'b100,
              RETURN_HOME  = 3'b101,
              RETURN_BACK  = 3'b110;

    reg [2:0] state, next_state;
    reg [1:0] target_floor;
    reg [1:0] saved_target_floor;
    reg returning_home;
    reg returning_back;
    // Select target floor (priority encoder - lowest request first)
    always @(*) begin
        if (!returning_home && !returning_back) begin
            if (request[0])      target_floor = 2'd0;
            else if (request[1]) target_floor = 2'd1;
            else if (request[2]) target_floor = 2'd2;
            else if (request[3]) target_floor = 2'd3;
            else                 target_floor = current_floor;
        end else if (returning_home) begin
            target_floor = 2'd0; // go to ground floor
        end else begin
            target_floor = saved_target_floor; // return to original target
        end
    end
    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            returning_home <= 0;
            returning_back <= 0;
            saved_target_floor <= 2'd0;
        end else begin
            state <= next_state;
        end
    end
    // Next-state logic & outputs
    always @(*) begin
        // default values
        next_state    = state;
        motor         = 2'b00;
        door_open     = 0;
        floor_display = current_floor;
        case (state)
            IDLE: begin
                if (!returning_home && !returning_back && request != 4'b0000) begin
                    saved_target_floor = target_floor;
                    if (target_floor > current_floor) next_state = MOVE_UP;
                    else if (target_floor < current_floor) next_state = MOVE_DOWN;
                    else next_state = OPEN_DOOR;
                end else if ((returning_home || returning_back) && target_floor > current_floor) begin
                    next_state = MOVE_UP;
                end else if ((returning_home || returning_back) && target_floor < current_floor) begin
                    next_state = MOVE_DOWN;
                end else if ((returning_home || returning_back) && target_floor == current_floor) begin
                    next_state = OPEN_DOOR;
                end
            end

            MOVE_UP: begin
                motor = 2'b01;
                if (current_floor == target_floor)
                    next_state = OPEN_DOOR;
            end
   MOVE_DOWN: begin
                motor = 2'b10;
                if (current_floor == target_floor)
                    next_state = OPEN_DOOR;
            end
            OPEN_DOOR: begin
                door_open = 1;
                next_state = CLOSE_DOOR;
            end
CLOSE_DOOR: begin
                door_open = 0;
                if (!returning_home && !returning_back && current_floor != 2'd0) begin
                    returning_home = 1;
                    next_state = RETURN_HOME;
                end else if (returning_home && saved_target_floor != 2'd0) begin
                    returning_home = 0;
                    returning_back = 1;
                    next_state = RETURN_BACK;
                end else begin
                    returning_home = 0;
                    returning_back = 0;
                    next_state = IDLE;
                end
            end

            RETURN_HOME: begin
                if (current_floor > 2'd0) begin
                    motor = 2'b10;
                    next_state = RETURN_HOME;
                end else begin
                    motor = 2'b00;
                    next_state = OPEN_DOOR;
                end
            end

            RETURN_BACK: begin
                if (current_floor < saved_target_floor) begin
                    motor = 2'b01;
                    next_state = RETURN_BACK;
                end else if (current_floor > saved_target_floor) begin
                    motor = 2'b10;
                    next_state = RETURN_BACK;
                end else begin
                    motor = 2'b00;
                    next_state = OPEN_DOOR;
                end
            end
        endcase
    end
endmodule
