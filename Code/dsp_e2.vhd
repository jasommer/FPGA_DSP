----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.08.2020 20:25:59
-- Design Name: 
-- Module Name: dsp - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-- Implemn
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dsp_e2 is
Port ( 
        clk     : in  std_logic;
        w1      : in  std_logic_vector (2  downto 0); 
        w2      : in  std_logic_vector (2  downto 0);
        a1      : in  std_logic_vector (3  downto 0);
        a2      : in  std_logic_vector (3  downto 0);
        a1w1    : out  std_logic_vector (6  downto 0);
        a2w1    : out  std_logic_vector (6  downto 0);
        a1w2    : out  std_logic_vector (6  downto 0);
        a2w2    : out  std_logic_vector (6  downto 0)
    );
end dsp_e2;

architecture Behavioral of dsp_e2 is
    signal a_vect:  std_logic_vector(26 downto 0);
    signal d_vect:  std_logic_vector(26 downto 0); -- DSP48E1: D=25 bit, DSP48E2: D=27 bit
    signal b_vect:  std_logic_vector(17 downto 0); 
    signal c_vect:  std_logic_vector(47 downto 0);
    signal dsp_out: std_logic_vector(47 downto 0);

    constant A2_OFFSET : integer := 11;
    constant PADDING   : integer := 4;
    constant BIT_WIDTH : integer := 7;
    constant OFFSET    : integer := PADDING + BIT_WIDTH;
    
    component xbip_dsp48e2_macro_0 is
    port (
        clk : in std_logic;
        a   : in std_logic_vector(26 downto 0);
        b   : in std_logic_vector(17 downto 0);
        c   : in std_logic_vector(47 downto 0);
        d   : in std_logic_vector(26 downto 0);
        p   : out std_logic_vector(47 downto 0)
    );
    end component;
        
    begin
        
    DSP_PORT_MAP: process(w1, w2, a1, a2, dsp_out)
    begin
        
        -- populate  c_vect
        c_vect(31 downto 0) <= (others => '0');
        c_vect(32) <= w2(2);  
        c_vect(47 downto 33) <= (others => '0');          
        
        -- map w1 to a_vect
        a_vect(2  downto 0) <= w1;
        
        for i in 3 to 6 loop --a_vect'high
            a_vect(i) <= w1(2);
        end loop;
        for i in 7 to a_vect'high loop --
            a_vect(i) <= '0';
        end loop;
        
        -- map w2 to d_vect
        d_vect(d_vect'high) <= w2(2);
        d_vect(d_vect'high-1) <= w2(2);
        d_vect(d_vect'high-2 downto d_vect'high-4) <= w2;
        
        for i in 0 to d_vect'high-5 loop
            d_vect(i) <= '0';
        end loop;
        
        -- map a1 and a2 to b_vect
        for i in 0 to b_vect'high loop
            if(i >= 0 AND i <= 3) then
                b_vect(i) <= a1(i);
            elsif(i >= A2_OFFSET AND i <= A2_OFFSET+3) then
                b_vect(i) <= a2(i-A2_OFFSET);
            else
                b_vect(i) <= '0';
            end if;
        end loop;
        
        -- map dsp_out to outputs a1w1, a2w1, a1w2, a2w2
        a1w1 <= dsp_out(           6 downto        0);
        a2w1 <= dsp_out(OFFSET*1 + 6 downto OFFSET*1);
        a1w2 <= dsp_out(OFFSET*2 + 6 downto OFFSET*2);
        a2w2 <= dsp_out(OFFSET*3 + 6 downto OFFSET*3);
        
    end process DSP_PORT_MAP;
    
    dsp48_instance : xbip_dsp48e2_macro_0
    port map (
        CLK => clk,
        A   => a_vect,
        B   => b_vect,
        C   => c_vect,
        D   => d_vect, 
        P   => dsp_out
    ); 
    
end Behavioral;
