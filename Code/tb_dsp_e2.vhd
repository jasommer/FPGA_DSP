-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 6.11.2020 16:45:11 UTC

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;
 
entity tb_dsp_e2 is
end tb_dsp_e2;

architecture tb of tb_dsp_e2 is

    component dsp_e2
        port (clk  : in std_logic;
              w1   : in std_logic_vector (2  downto 0);
              w2   : in std_logic_vector (2  downto 0);
              a1   : in std_logic_vector (3  downto 0);
              a2   : in std_logic_vector (3  downto 0);
              a1w1 : out std_logic_vector (6  downto 0);
              a2w1 : out std_logic_vector (6  downto 0);
              a1w2 : out std_logic_vector (6  downto 0);
              a2w2 : out std_logic_vector (6  downto 0));
    end component;

    signal clk  : std_logic;
    signal w1   : std_logic_vector (2  downto 0);
    signal w2   : std_logic_vector (2  downto 0);
    signal a1   : std_logic_vector (3  downto 0);
    signal a2   : std_logic_vector (3  downto 0);
    signal a1w1 : std_logic_vector (6  downto 0);
    signal a2w1 : std_logic_vector (6  downto 0);
    signal a1w2 : std_logic_vector (6  downto 0);
    signal a2w2 : std_logic_vector (6  downto 0);

    constant TbPeriod : time := 300 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
    
    file file_test_vectors: text;
    file file_output_results: text;

begin

    dut : dsp_e2
    port map (clk  => clk,
              w1   => w1,
              w2   => w2,
              a1   => a1,
              a2   => a2,
              a1w1 => a1w1,
              a2w1 => a2w1,
              a1w2 => a1w2,
              a2w2 => a2w2);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
        variable v_ILINE     : line;
        variable v_OLINE     : line;
        variable v_SPACE     : character;
        variable v_a1        : std_logic_vector(3 downto 0);
        variable v_a2        : std_logic_vector(3 downto 0);
        variable v_w1        : std_logic_vector(2 downto 0);
        variable v_w2        : std_logic_vector(2 downto 0);
    begin
    
        file_open(file_output_results, "output_results.txt", write_mode);
        file_open(file_test_vectors, "test_vectors.txt", read_mode);
        
        while not endfile(file_test_vectors) loop
            readline(file_test_vectors, v_ILINE);
            read(v_ILINE, v_a1);
            read(v_ILINE, v_SPACE); -- read in the space character as delimiter
            read(v_ILINE, v_a2);
            read(v_ILINE, v_SPACE);          
            read(v_ILINE, v_w1);
            read(v_ILINE, v_SPACE);          
            read(v_ILINE, v_w2);
            
            -- Pass the variable to signal
            a1 <= v_a1;
            a2 <= v_a2;
            w1 <= v_w1;
            w2 <= v_w2;
            
            wait for TbPeriod * 4; -- 4 pipeline stages within the dsp block
            
            write(v_OLINE, a1w1, right, 0);
            write(v_OLINE, a2w1, right, 8);
            write(v_OLINE, a1w2, right, 8);
            write(v_OLINE, a2w2, right, 8);
            writeline(file_output_results, v_OLINE);
        
        end loop;
    
        file_close(file_output_results);
        file_close(file_test_vectors);
        -- Stop the clock and hence terminate the simulation
        --TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.
configuration cfg_tb_dsp_e2 of tb_dsp_e2 is
    for tb
    end for;
end cfg_tb_dsp_e2;