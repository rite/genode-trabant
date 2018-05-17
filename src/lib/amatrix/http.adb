with System;

package body Http
is

   type Curl_Type is new System.Address;
   Curl : Curl_Type := Curl_Type (System.Null_Address);

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
   begin
      return Url & Content & Authentication;
   end Put;

   function Post (
                  Url : String;
                  Content : String
                 ) return String
   is
      function Curl_Post (
                          Curl : Curl_Type;
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
      Response : String := String_From_C ( Curl_Post (
                                           Curl,
                                           C_Url'Address,
                                           C_Content'Address));
   begin
      return Response;
   end Post;

   function Curl_Easy_Init return Curl_Type
     with
       Import,
       Convention => C,
       External_Name => "curl_easy_init";

begin

   Curl := Curl_Easy_Init;

end Http;
