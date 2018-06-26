with System;

package Client is

   procedure Login (
                    User     : System.Address;
                    Usize    : Integer;
                    Password : System.Address;
                    Psize    : Integer
                   );

   procedure Send_Message (
                           Message : System.Address;
                           MSize   : Integer;
                           Room    : System.Address;
                           RSize   : Integer
                          );

end Client;
