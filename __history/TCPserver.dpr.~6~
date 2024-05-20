program TCPserver;

uses
  Vcl.Forms,
  Server in 'Server.pas' {FormServer},
  ConversationList in 'ConversationList.pas' {FormConversation};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormServer, FormServer);
  Application.CreateForm(TFormConversation, FormConversation);
  Application.Run;
end.
