package body Http
is

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
   begin
      return Url & Content;
   end Post;

end Http;
