-- Handles x0 to x31 (read/write to RD1/RD2)
-- x0 is always 0
-- x30 is linked to leds
-- x31 is linked to the buttons
ARCHITECTURE rtl_synch OF registerFile IS
    -- Bank of register
    type t_registersBank is array (31 downto 0) of
        std_ulogic_vector(31 downto 0);
    -- A bank of registers
    signal larr_registers: t_registersBank;
    signal lvec_btns : std_ulogic_vector(31 downto 0);
    signal lvec_rd1, lvec_rd2 : std_ulogic_vector(31 downto 0);
BEGIN
    -- Special regs
    process(rst, clk)
    begin
        if rst = '1' then
            lvec_btns <= (others => '0');
        elsif rising_edge(clk) then
          if en = '1' then
            lvec_btns <= (btns'length to g_datawidth-1 => '0') & btns;
          end if;
        end if;
    end process;

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

    -- Clocked read.
    -- Addr 0 wired to 0s
    process(rst, clk) begin
      if rst = '1' then
        lvec_rd1 <= (others => '0');
        lvec_rd2 <= (others => '0');
      elsif rising_edge(clk) then
        if en = '1' then
          if (to_integer(unsigned(addr1)) = 0) then
            lvec_rd1 <= (others => '0') after g_tRfRd;
          elsif (to_integer(unsigned(addr1)) = 31) then -- buttons
            lvec_rd1 <= lvec_btns after g_tRfRd;
          else
            lvec_rd1 <= larr_registers(to_integer(unsigned(addr1))) after g_tRfRd;
          end if;

          if (to_integer(unsigned(addr2)) = 0) then
            lvec_rd2 <= (others => '0') after g_tRfRd;
          elsif (to_integer(unsigned(addr2)) = 31) then -- buttons
            lvec_rd2 <= lvec_btns after g_tRfRd;
          else
            lvec_rd2 <= larr_registers(to_integer(unsigned(addr2))) after g_tRfRd;
          end if;
        end if;
      end if;
    end process;

    leds <= larr_registers(30);
    RD1 <= lvec_rd1;
    RD2 <= lvec_rd2;
END ARCHITECTURE rtl_synch;
