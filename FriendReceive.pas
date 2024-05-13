unit FriendReceive;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormFriendReceive = class(TForm)
    AcceptButton: TButton;
    RejectButton: TButton;
    RequestLabel: TLabel;
    UserNameLabel: TLabel;
    procedure AcceptButtonClick(Sender: TObject);
    procedure RejectButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormFriendReceive: TFormFriendReceive;

implementation

{$R *.dfm}

procedure TFormFriendReceive.AcceptButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFormFriendReceive.RejectButtonClick(Sender: TObject);
begin
  Close;
end;

end.
