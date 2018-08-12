with System;

package body Http
is

   type LV_String is
      record
         Length : Integer;
         Value  : System.Address;
      end record
     with Size => 96;

   for LV_String use
      record
         Length at 0 range 0 .. 31;
         Value at 4 range 0 .. 63;
      end record;

   function String_From_C (
                           Ptr : System.Address
                          ) return String
   is
      C_Str : LV_String
        with Address => Ptr;
      Str   : String (1 .. C_Str.Length)
        with Address => C_Str.Value;
   begin
      return Str;
   end String_From_C;

   function Get (
                 Url : String
                ) return String
   is
   begin
      return Url;
   end Get;

   function Put (
                 Url : String;
                 Content : String;
                 Authentication : String
                ) return String
   is
       function Curl_Put (
           Url : System.Address;
           Content : System.Address;
           Auth : System.Address
           ) return System.Address
        with
            Import,
            Convention => C,
            External_Name => "curl_put";
       Auth_Header : String := "Authorization: Bearer " & Authentication & Character'Val(0);
       C_Url : String := Url & Character'Val(0);
       C_Content : String := Url & Character'Val(0);
       Response : constant String := String_From_C ( Curl_Put (C_Url'Address,
                                                      C_Content'Address,
                                                      Auth_Header'Address));
   begin
      return Response;
   end Put;

   function Post (
                  Url : String;
                  Content : String
                 ) return String
   is
      function Curl_Post (
                          Url  : System.Address;
                          Content : System.Address
                         )
                          return System.Address
        with
          Import,
          Convention => C,
          External_Name => "curl_post";
      C_Url : String := Url & Character'Val (0);
      C_Content : String := Content & Character'Val (0);
      Response : constant String := String_From_C ( Curl_Post (
                                           C_Url'Address,
                                           C_Content'Address));
   begin
      return Response;
   end Post;

end Http;
