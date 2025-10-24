-- readData must be output on next clock, but the instruction loaded only if irWrite is '1' (FETCH stage)
-- The problem is that the state change of the FSM is also clocked, and will happen the same moment the instruction is loaded
--  => IRWrite will be asserted only a bit after the clock, thus the data would not be forwarded to the instruction line until next clock
--  => desynchronization
-- This block reacts on irWrite to decide wheter to forward the readData or not
ARCHITECTURE rtl OF instructionForwarder IS
    signal lvec_irMem : std_ulogic_vector(readData'range);
    signal lsig_irwrite : std_ulogic;
    attribute BLOCKNET : string;
    attribute BLOCKNET of instruction, readData : signal is "instruction";
BEGIN

--    process(rst, clk)
--    begin
--        if rst = '1' then
--            lvec_irMem <= (others => '0');
--        elsif rising_edge(clk) then
--            if en = '1' and irWrite = '1' then
--                lvec_irMem <= readData;
--            end if;
--        end if;
--    end process;
--    instruction <= lvec_irMem;

    -- Register IRWrite and last data
    regIR : process(rst, clk)
    begin
        if rst = '1' then
            lvec_irMem <= (others => '0');
            --lsig_irwrite <= '0';
        elsif rising_edge(clk) then
            if en = '1' then
                lsig_irwrite <= irWrite;
                -- delay of one clock to ensure fresh data
                if lsig_irwrite = '1' then
                    lvec_irMem <= readData;
                end if;
            end if;
        end if;
    end process regIR;

    -- Based on IRWrite value, either forward actual data or last one
    instruction <= readData when lsig_irwrite = '1' else lvec_irMem;




--    forwardIR : process(readData, irWrite)
--    begin
--        if irWrite = '1' then
--            lvec_irMem <= readData;
--        end if;
--    end process forwardIR;

--    instruction <= lvec_irMem;

END ARCHITECTURE rtl;
