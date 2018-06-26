with Amatrix.Client;

package body Client is

   package Matrix is new Amatrix.Client ("Genode Matrix Log");

   procedure Login (
                    User     : System.Address;
                    USize    : Integer;
                    Password : System.Address;
                    PSize    : Integer
                   )
   is
      Uname : String (1 .. USize)
        with Address => User;
      Pword : String (1 .. PSize)
        with Address => Password;
   begin
      Matrix.Login (Uname, Pword);
   end Login;

   procedure Send_Message (
                           Message : System.Address;
                           MSize   : Integer;
                           Room    : System.Address;
                           RSize   : Integer
                          )
   is
      Msg : String (1 .. MSize)
        with Address => Message;
      Rm  : Matrix.Room_Type (1 .. RSize)
        with Address => Room;
   begin
      Matrix.Send_Message (Msg, Rm);
   end Send_Message;

end Client;
