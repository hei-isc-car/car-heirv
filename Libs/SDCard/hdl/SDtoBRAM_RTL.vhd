--
-- VHDL Architecture SDCard.SDtoBRAM.RTL
--
-- Created:
--          by - Axam.UNKNOWN (WE10628)
--          at - 10:11:16 03.02.2025
--
-- using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
--

LIBRARY Common;
  USE Common.CommonLib.all;

ARCHITECTURE RTL OF SDtoBRAM IS

-- Parallel process timing out if file not found
signal lvec_filenotfound_timer : unsigned(requiredBitNb(g_FILENOTFOUND_TIMER_TARGET) - 1 downto 0);
signal lsig_notfound_timer_expired : std_ulogic;

-- Sttae machine for file loading into BRAM
type state_t is (ST_IDLE, ST_READING, ST_DONE);
signal lvec_state : state_t;
-- Address counter to load BRAM
signal lvec_bram_addr, lvec_bram_addr_delayed : unsigned(g_ADDRESS_BIT_NB - 1 downto 0);
-- Number of bytes to fit read byte into BRAM
constant c_BRAM_BYTE_NB : integer := integer((g_DATA_BIT_NB - 1) / 8) + 1;
signal lvec_bram_byte_counter : unsigned(requiredBitNb(c_BRAM_BYTE_NB) - 1 downto 0);
  -- Array of bytes
type byte_array_t is array(0 to c_BRAM_BYTE_NB - 1) of std_ulogic_vector(7 downto 0);
signal lvec_bram_byte : byte_array_t;
-- Data to be loaded into BRAM
signal lsig_bram_loaded, lsig_bram_en, lsig_bram_wren : std_ulogic;
signal lsig_filefound : std_ulogic;

BEGIN

-- Time out indicator if file not found
fnf_timeout_proc : process(clk, rst)
begin
  if rst = '1' then
    lvec_filenotfound_timer <= (others => '0');
    lsig_notfound_timer_expired <= '0';
    lsig_filefound <= '0';
  elsif rising_edge(clk) then
    if i_file_found = '1' then
      lsig_filefound <= '1';
    end if;

    if lsig_bram_en = '1' or lsig_bram_loaded = '1' then
      lsig_notfound_timer_expired <= '0';
    elsif lvec_filenotfound_timer = to_unsigned(g_FILENOTFOUND_TIMER_TARGET, lvec_filenotfound_timer'length) then
      lsig_notfound_timer_expired <= '1';
    elsif i_file_found = '0' then
      lvec_filenotfound_timer <= lvec_filenotfound_timer + 1;
    end if;
  end if;
end process fnf_timeout_proc;
read_timeout_ind <= lsig_notfound_timer_expired;

-- BRAM loading state machine
-- Not able to restart loading as is
bram_load_proc : process(clk, rst)
begin
  if rst = '1' then
    lvec_state <= ST_IDLE;
    lvec_bram_addr <= (others => '0');
    lvec_bram_addr_delayed <= (others => '0');
    lvec_bram_byte_counter <= (others => '0');
    lvec_bram_byte <= (others => (others => '0'));
    lsig_bram_loaded <= '0';
    lsig_bram_en <= '0';
    lsig_bram_wren <= '0';
  elsif rising_edge(clk) then
    lsig_bram_wren <= '0';
    lvec_bram_addr_delayed <= lvec_bram_addr;

    case lvec_state is

      when ST_IDLE =>
        lsig_bram_en <= '0';
        if i_file_found = '1' then
          lvec_state <= ST_READING;
          lsig_bram_en <= '1';
        end if;

      when ST_READING =>
        if i_byte_en = '1' then -- suppose the read file is big enough, else will never exit this and enable BRAM
          -- Register the c_BRAM_BYTE_NB next bytes
          if lvec_bram_byte_counter = to_unsigned(c_BRAM_BYTE_NB - 1, lvec_bram_byte_counter'length) then
            lvec_bram_byte(to_integer(lvec_bram_byte_counter)) <= i_byte_in;
            -- lvec_bram_byte(0) <= i_byte_in;
            lvec_bram_byte_counter <= (others => '0');
            lvec_bram_addr <= lvec_bram_addr + 1;
            lsig_bram_wren <= '1';
            -- When wrote last data
            if lvec_bram_addr = to_unsigned(2**g_ADDRESS_BIT_NB - 1, lvec_bram_addr'length) then
              lvec_state <= ST_DONE;
            end if;
          else
            lvec_bram_byte(to_integer(lvec_bram_byte_counter)) <= i_byte_in;
            -- lvec_bram_byte(to_integer(c_BRAM_BYTE_NB - 1 - lvec_bram_byte_counter)) <= i_byte_in;
            lvec_bram_byte_counter <= lvec_bram_byte_counter + 1;
          end if;
        end if;
        
      when ST_DONE =>
        lsig_bram_loaded <= '1';
        lsig_bram_en <= '0';
      
      when others =>
        lvec_state <= ST_IDLE;
    end case;
  end if;
end process bram_load_proc;

bram_loaded_indicator <= lsig_bram_loaded;
o_bram_address <= lvec_bram_addr_delayed;
bram_data_gen: for i in 0 to c_BRAM_BYTE_NB - 2 generate
  o_bram_data(((i + 1) * 8) - 1 downto i * 8) <= lvec_bram_byte(i);
end generate bram_data_gen;
o_bram_data(g_DATA_BIT_NB - 1 downto (c_BRAM_BYTE_NB - 1) * 8) <= lvec_bram_byte(c_BRAM_BYTE_NB - 1)(7 - ((c_BRAM_BYTE_NB * 8) - g_DATA_BIT_NB) downto 0);
o_bram_en <= lsig_bram_en;
o_bram_write_en <= lsig_bram_wren;

END ARCHITECTURE RTL;
