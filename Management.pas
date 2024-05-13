unit Management;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst;

type
  TFormManagement = class(TForm)
    ClientsLabel: TLabel;
    ClientList: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormManagement: TFormManagement;

implementation

{$R *.dfm}

end.
