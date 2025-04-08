library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- this code will two buttons to move the blinky led

entity MoveBlinkyDisplay is
    port ( clk      : in std_logic;
           segments : out std_logic_vector(6 downto 0);
           display  : out std_logic_vector(7 downto 0);
           leftBtn  : in std_logic;
           rightBtn : in std_logic);
end MoveBlinkyDisplay;

architecture Behavioral of MoveBlinkyDisplay is
    signal clkdivDpFreshrate : integer range 0 to 50_000 := 0;
    signal clkdivBlink : integer range 0 to 12_500_000 := 0; -- 0.25 secs
    signal activeDp : integer range 0 to 3 := 0;
    type digitArray is array (0 to 3) of std_logic_vector(6 downto 0);
    constant digitData : digitArray := (
        "1111110", -- 0
        "0110000", -- 1
        "1101101", -- 2
        "1111001"); -- 3
    type dpArray is array (0 to 3) of std_logic_vector(7 downto 0);
    constant dpData : dpArray := (
        "11111110", -- 0
        "11111101", -- 1
        "11111011", -- 2
        "11110111"); -- 3
    signal blink : std_logic := '0';
    signal blinkIndx : unsigned integer range 0 to 3 := 0;
    signal leftLastState : std_logic := '0';
    signal rightLastState : std_logic := '0';
begin
    -- process used to display different values
    process(clk)
    begin
        if rising_edge(clk) then
            if clkdivDpFreshrate = 50_000 then
                clkdivDpFreshrate <= 0;
                activeDp <= (activeDp + 1) mod 4;
            else
                clkdivDpFreshrate + 1;
            end if;

            display <= dpData(activeDp);
            if blink = '1' and activeDp = blinkIndx then
                segments <= "1111111";
            else
                segments <= not digitData(activeDp);
            end if;
        end if;
    end process;

    -- process used to blink the display
    process(clk)
    begin
        if rising_edge(clk) then
            if clkdiv_blink = 12_500_000 then
                clkdiv_blink <= 0;
                blink <= not blink;
            else 
                clkdiv_blink <= clkdiv_blink + 1;
            end if;
        end if;
    end process;

    -- processing the buttons signals
    process(clk)
    -- Debounce counters (10ms at 50MHz)
    variable left_debounce  : integer range 0 to 500_000 := 0;
    variable right_debounce : integer range 0 to 500_000 := 0;
    -- Button states
    signal leftLastState    : std_logic := '0';
    signal rightLastState   : std_logic := '0';
    -- Press flags (for single-trigger)
    signal leftPressed      : std_logic := '0';
    signal rightPressed     : std_logic := '0';
begin
    if rising_edge(clk) then
        -- Left button (increment) ----------------------------
        if leftBtn /= leftLastState then
            left_debounce := 0;
            leftLastState <= leftBtn;
        elsif left_debounce < 500_000 then
            left_debounce := left_debounce + 1;
        elsif leftLastState = '1' and leftPressed = '0' then  -- New: Single-press check
            blinkIndx <= (blinkIndx + 1) mod 4;
            leftPressed <= '1';  -- Mark as pressed
        end if;

        -- Reset leftPressed when button is released
        if leftLastState = '0' then
            leftPressed <= '0';
        end if;

        -- Right button (decrement) ---------------------------
        if rightBtn /= rightLastState then
            right_debounce := 0;
            rightLastState <= rightBtn;
        elsif right_debounce < 500_000 then
            right_debounce := right_debounce + 1;
        elsif rightLastState = '1' and rightPressed = '0' then  -- New: Single-press check
            -- Safer alternative to (blinkIndx - 1) mod 4:
            if blinkIndx = 0 then
                blinkIndx <= 3;  -- Wrap around to 3
            else
                blinkIndx <= blinkIndx - 1;  -- Normal decrement
            end if;
            rightPressed <= '1';  -- Mark as pressed
        end if;

        -- Reset rightPressed when button is released
        if rightLastState = '0' then
            rightPressed <= '0';
        end if;
    end if;
end process;
end Behavioral;

