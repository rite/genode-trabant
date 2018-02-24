pragma Ada_2012;

with Escape_Dfa;
use all type Escape_Dfa.Escape_Mode;

package body VGA
with
SPARK_Mode
is

    procedure Putchar
      (C : Character)
    is
        VC : constant Symbol := (Cur_Blink, Cur_Background, Cur_Foreground, C);
    begin
        pragma Warnings (Off, "pragma Restrictions (No_Exception_Propagation) in effect");
        if Cursor = 79 then
            Scroll;
        end if;

        Ascii_State := Escape_Dfa.Translate (Character'Pos (C), Ascii_State);

        case Ascii_State is
            when Escape_Dfa.Normal =>
                case Character'Pos (C) is
                when 10 =>
                    Scroll;
                when 32 .. 126 =>
                    VGA_Screen (24) (Cursor) := VC;
                    Cursor := Cursor + 1;
                when others =>
                    null;
                end case;
            when Escape_Dfa.Graphics_Mode_Text_Attributes_Off =>
                Cur_Blink := False;
                Cur_Foreground := 15;
                Cur_Background := 0;
            when Escape_Dfa.Graphics_Mode_Foreground_Colors_Red =>
                Cur_Foreground := 4;
            when Escape_Dfa.Graphics_Mode_Foreground_Colors_Blue =>
                Cur_Foreground := 1;
            when others =>
                null;
        end case;
    end Putchar;

    procedure Scroll
    is
        Empty : constant Symbol := (False, 0, 0, Character'Val (0));
    begin
        for I in 0 .. 23 loop
            VGA_Screen (I) := VGA_Screen (I + 1);
        end loop;
        VGA_Screen (24) := (others => Empty);
        Cursor := 0;
    end Scroll;

end VGA;
