-- Handles x0 to x31 (read/write to RD1/RD2)
-- x0 is always 0
-- x30 is linked to leds
-- x31 is linked to the buttons
ARCHITECTURE rtl OF registerFile IS
    -- Bank of register
    type t_registersBank is array (31 downto 0) of
        std_ulogic_vector(31 downto 0);
    -- A bank of registers
    signal larr_registers: t_registersBank;
BEGIN

    -- Clocked write
    process(rst, clk) begin
    if rst = '1' then
        larr_registers <= (others => (others => '0')) after g_tRfWr;
    elsif rising_edge(clk) then
        if writeEnable3 = '1' and en = '1' then
            larr_registers(to_integer(unsigned(addr3))) <= writeData after (g_tRfWr + g_tSetup);
        end if;
    end if;
    end process;

    -- Comb. read
    -- Addr 0 wired to 0s
    process(addr1, addr2) begin
        if (to_integer(unsigned(addr1)) = 0) then
            RD1 <= (others => '0') after g_tRfRd;
        elsif (to_integer(unsigned(addr1)) = 31) then -- buttons
            RD1 <= btns after g_tRfRd;
        else
            RD1 <= larr_registers(to_integer(unsigned(addr1))) after g_tRfRd;
        end if;

        if (to_integer(unsigned(addr2)) = 0) then
            RD2 <= (others => '0') after g_tRfRd;
        elsif (to_integer(unsigned(addr2)) = 31) then -- buttons
            RD2 <= btns after g_tRfRd;
        else
            RD2 <= larr_registers(to_integer(unsigned(addr2))) after g_tRfRd;
        end if;
    end process;

    leds <= larr_registers(30);

END ARCHITECTURE rtl;
