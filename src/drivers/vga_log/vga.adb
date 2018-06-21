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
                    VGA_Buffer (Buffer_Size - 1) (Cursor) := VC;
                    Cursor := Cursor + 1;
                when others =>
                    null;
                end case;
            when Escape_Dfa.Graphics_Mode_Text_Attributes_Off =>
                Cur_Blink := False;
                Cur_Foreground := 15;
                Cur_Background := 0;
            when Escape_Dfa.Graphics_Mode_Foreground_Colors_Black =>
                Cur_Foreground := 0;
            when Escape_Dfa.Graphics_Mode_Foreground_Colors_Red =>
                Cur_Foreground := 4;
            when Escape_Dfa.Graphics_Mode_Foreground_Colors_Green =>
                Cur_Foreground := 2;
            when Escape_Dfa.Graphics_Mode_Foreground_Colors_Yellow =>
                Cur_Foreground := 14;
            when Escape_Dfa.Graphics_Mode_Foreground_Colors_Blue =>
                Cur_Foreground := 1;
            when Escape_Dfa.Graphics_Mode_Foreground_Colors_Magenta =>
                Cur_Foreground := 5;
            when Escape_Dfa.Graphics_Mode_Foreground_Colors_Cyan =>
                Cur_Foreground := 3;
            when Escape_Dfa.Graphics_Mode_Foreground_Colors_White =>
                Cur_Foreground := 7;
            when others =>
                null;
        end case;
    end Putchar;

    procedure Scroll
    is
        Empty : constant Symbol := (False, 0, 0, Character'Val (0));
    begin
        for I in 0 .. VGA_Buffer'Last - 1 loop
            VGA_Buffer (I) := VGA_Buffer (I + 1);
        end loop;
        VGA_Buffer (VGA_Buffer'Last) := (others => Empty);
        Cursor := 0;
        Window;
    end Scroll;

    procedure Window
    is
    begin
        for I in VGA_Screen'Range loop
            VGA_Screen (I) := VGA_Buffer (I + Offset);
        end loop;
    end Window;

    procedure Up
    is
    begin
        if Offset > 0 then
            Offset := Offset - 1;
        end if;
        Window;
    end Up;

    procedure Down
    is
    begin
        if Offset < Max_Offset then
            Offset := Offset + 1;
        end if;
        Window;
    end Down;

    procedure Reset
    is
    begin
        Offset := Max_Offset;
        Window;
    end Reset;

end VGA;
