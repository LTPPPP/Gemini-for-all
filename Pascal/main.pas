program GeminiChatbot;

uses
  SysUtils, httpsend, ssl_openssl, classes, dotenv;

procedure ChatWithGemini(const Prompt: string);
var
  APIKey, Model, URL, Response, Payload: string;
  HTTPSender: THTTPSend;
  Stream: TStringStream;
begin
  LoadEnvFile('.env');
  APIKey := GetEnvVar('GEMINI_API_KEY');
  Model := GetEnvVar('MODEL');

  URL := 'https://generativelanguage.googleapis.com/v1beta/models/' + Model + ':generateContent?key=' + APIKey;
  Payload := '{"contents":[{"parts":[{"text":"' + Prompt + '"}]}]}';

  HTTPSender := THTTPSend.Create;
  Stream := TStringStream.Create('', TEncoding.UTF8);
  try
    HTTPSender.MimeType := 'application/json';
    HTTPSender.Headers.Add('Content-Type: application/json');
    HTTPSender.Document.Write(Pointer(Payload)^, Length(Payload));
    HTTPSender.Document.Position := 0;

    if HTTPSender.HTTPMethod('POST', URL) then
    begin
      Stream.CopyFrom(HTTPSender.Document, 0);
      Stream.Position := 0;
      Response := Stream.DataString;
      WriteLn('Response: ', Response);
    end
    else
      WriteLn('HTTP request failed.');
  finally
    HTTPSender.Free;
    Stream.Free;
  end;
end;

var
  Input: string;
begin
  WriteLn('== Gemini Chatbot ==');
  while True do
  begin
    Write('You: ');
    ReadLn(Input);
    if Input = 'exit' then Break;
    ChatWithGemini(Input);
  end;
end.
