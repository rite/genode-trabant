with System;
with Escape_Dfa;
use all type System.Address;

package VGA
with
SPARK_Mode
is

    type Background_Color is new Integer range 0 .. 7
      with Size => 3;
    type Foreground_Color is new Integer range 0 .. 15
      with Size => 4;

    Buffer_Size : constant Integer := 1024;
    Screen_Size : constant Integer := 25;

    type Symbol is
        record
            Blink      : Boolean;
            Background : Background_Color;
            Foreground : Foreground_Color;
            Char       : Character;
        end record with
      Size => 16;

    for Symbol use
        record
            Blink      at 1 range 7 .. 7;
            Background at 1 range 4 .. 6;
            Foreground at 1 range 0 .. 3;
            Char       at 0 range 0 .. 7;
        end record;

    type Cursor_Location is new Integer range 0 .. 79;

    type Line is array (Cursor_Location range 0 .. 79) of Symbol;
    type Screen is array (Integer range 0 .. Screen_Size - 1) of Line;
    type Screen_Buffer is array (Integer range 0 .. Buffer_Size - 1) of Line;

    Max_Offset : constant Integer := Buffer_Size - Screen_Size;
    Offset : Integer := Max_Offset;

    function Get_Buffer return System.Address
      with
        Import,
        Convention => C,
        External_Name => "get_buffer";

    Cursor : Cursor_Location := 0;
    Cur_Blink : Boolean := False;
    Cur_Background : Background_Color := 0;
    Cur_Foreground : Foreground_Color := 15;

    VGA_Screen : Screen
      with
        Address => Get_Buffer,
        Volatile,
        Effective_Writes,
        Async_Readers;

    VGA_Buffer : Screen_Buffer := (others => (others => (Blink => False,
                                                         Background => 0,
                                                         Foreground => 0,
                                                         Char       => ' ')));

    procedure Putchar (C : Character)
      with
        Global => (In_Out => (Cursor,
                              Cur_Blink,
                              Cur_Background,
                              Cur_Foreground),
                   Output => (VGA_Buffer));

    procedure Window;

    procedure Up;
    procedure Down;
    procedure Reset;

    Ascii_State : Escape_Dfa.Escape_Mode := Escape_Dfa.Normal;

private

    procedure Scroll
      with Global => (In_Out => VGA_Screen);

end VGA;
