Library Common;
  Use Common.CommonLib.all;
  
ARCHITECTURE studentVersion OF hb_gen IS

  constant c_TARGET : positive := positive(g_CLK_DIV) / 4;
  signal lvec_cnt : unsigned( requiredBitNb(c_TARGET) - 1 downto 0);
  signal lsig_hb : std_ulogic;

BEGIN

  -- Heartbeat signal generation
  process(rst, clk)
  begin
    if rst = '1' then
      lsig_hb <= '1';
    elsif rising_edge(clk) then
      if lvec_cnt = 0 then
        lsig_hb <= not lsig_hb;  -- Toggle heartbeat signal
        lvec_cnt <= to_unsigned(c_TARGET, lvec_cnt'length);  -- Reset counter
      else
        lvec_cnt <= lvec_cnt - 1;  -- Decrement counter
      end if;
    end if;
  end process;

  -- Output heartbeat signal
  hb <= lsig_hb;

END ARCHITECTURE studentVersion;
